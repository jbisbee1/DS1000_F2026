# EDB 3, Phase B: An embedded AI analyst with logging

Status: design proposal for instructor decision. Nothing here is built. Prices, quotas, model names and platform limits below come from memory and must be verified against current vendor pages before commitment; where I am unsure I say so.

## 1. Goals

The page already assesses whether students can read bootstrap evidence. Phase B adds a different target: whether students can *direct* an AI analyst and *evaluate what it returns*. The concrete question is whether a student's prompts ask for the analysis that the evidence requires. In Stage 1, for example, the raw WFH gap is confounded by prior performance (`prior_pctile` in `edb3_firm_records.csv`). A student who asks only "compare output for WFH and office" gets the confounded number. A student who asks for the comparison within prior-performance groups, with a bootstrap interval, gets the Stage 2 answer. The same logic applies to the experiment file: pooled versus by-`job` effects, and `minutes` versus `per_minute` versus `output`.

Four things should be measurable from logs:

1. **Specification.** Did the prompt name the outcome, the groups, and the comparison (including a within-group comparison)?
2. **Uncertainty.** Did the student ask for resampling or an interval rather than a point estimate?
3. **Evaluation.** Did the student check, challenge, or reproduce a result, or accept it as given?
4. **Interpretation.** Did the student's later written answers (existing Stage 1d, 2e, 3d) use what the analyst returned correctly?

Phase B should also give a clean comparison with Phase A (the off-page GPT). Using the same persona text in both makes the logged version a measurable stand-in for the unlogged one. This is a design convenience, not a requirement.

## 2. Architecture

```
index.html (GitHub Pages)  --HTTPS-->  Supabase Edge Function "analyst"  --HTTPS-->  LLM API
   chat panel + WebR (in browser)         key in secrets; roster check;
                                          limits; logs every message
                                                |
                                          Postgres (service role only)
```

**Client.** A chat drawer available from Stage 1 onward, with each message tagged with the current stage. The student code is already on the page; it is sent with every request. The client never holds a model key and never writes log tables directly.

**Edge Function.** One function with a small action set: `turn` (new student message), `tool_result` (client returns R output), and `history` (reload a session). On every call it (a) validates `student_code` and a per-student access key against `roster`, (b) enforces rate and token limits, (c) rebuilds the conversation from the database rather than trusting client-supplied history, (d) calls the LLM, (e) logs the exchange, (f) returns the reply or a pending tool call. CORS is restricted to the Pages origin.

**Authentication caveat.** The existing page identifies students by code alone, and the code is guessable by classmates. For a graded or compared activity I recommend issuing each student a short secret alongside the code (stored hashed in `roster`). Whether to bother is an instructor decision (Q2). Also verify one platform detail: Supabase's newer `sb_publishable_...` keys are not JWTs, and I believe functions with JWT verification enabled by default may reject them; the likely fix is to disable gateway JWT verification and do the roster check in the function. Test this first.

**LLM and tool-use shape.** Either vendor works; tool use is equivalent for this purpose. I recommend Anthropic's API with a mid-tier model (fast, cheap enough, good at R), with a stronger model reserved for the offline scorer. The deciding factor should really be which account and billing arrangement you already have, plus data-handling terms (Q5). Do not hard-code a model ID; keep it in a config row. One tool is enough:

- `run_r(code: string)` returns `{stdout, error, n_plots, truncated}`.

The loop spans the network. The function calls the model; if the model emits `run_r`, the function returns `{status: "needs_tool", tool_use_id, code}` to the browser; WebR executes; the browser posts `tool_result`; the function appends it and calls the model again. Cap the loop at four tool calls per student turn, and truncate tool output to roughly 4,000 characters. Because the browser reports the output, a determined student could fabricate it. That affects only that student's own transcript, so I accept the risk and record `client_reported = true` on those rows.

## 3. Code execution: three options

| | WebR in browser | Server sandbox | No execution (precomputed tools) |
|---|---|---|---|
| What runs R | R compiled to WebAssembly, in a Web Worker | Container running real R, behind an API | No R; tools like `group_means(var, by)` and `bootstrap_diff(outcome, by, strata, B)` written in TypeScript in the Edge Function |
| Infrastructure | None beyond static files | A separate service (Supabase Edge Functions cannot run R); sandboxing, timeouts, ops | None |
| Cost to you | Zero marginal | Hosting plus engineering for isolation | Zero marginal |
| Security | Code runs in the student's own browser; cannot reach the key | Student-influenced code on your server: the hard part | Safest: no arbitrary code |
| Realism for a course that teaches R | High: students see and can copy real code | High | Low: no code, and the tool menu hints at the "right" analyses |
| Main risk | Load size, device variability, hung loops | Operations and abuse | Analyses outside the menu fail; weakens what we assess |

**Recommendation: WebR**, with the precomputed-tools design held as a fallback if the pilot shows load failures. Provider-hosted code execution tools exist at both vendors, but I believe they target Python and I am not sure R is available; verify before considering them.

*WebR details and uncertainties.* The first load downloads the WebAssembly runtime plus base R libraries; I expect tens of megabytes, cached afterward, but measure it on campus Wi-Fi. Packages come from the WebR package repository over the network at install time; keep to base R plus, at most, `dplyr`, and avoid the full `tidyverse` (large, slow). Load the CSVs by fetching them from the same origin in JavaScript and writing them to the virtual filesystem, then pre-evaluating `firm <- read.csv(...)` and `exp <- read.csv(...)` once, so generated code can assume those objects. Run each generated snippet through a WebR `Shelter`, which returns printed output, the value, and any plot images; show the code, output and plots in the chat so students inspect them. The system prompt tells the model the two object names and column names, nothing else about the data.

Failure modes to plan for:

- *No cross-origin isolation.* GitHub Pages cannot set the COOP/COEP headers that WebR prefers; WebR then falls back to a message-passing channel that works but cannot interrupt a running computation. The mitigation is a wall-clock timeout (say 20 seconds) that terminates and restarts the worker, with the datasets reloaded.
- *Slow bootstraps.* WebAssembly R is slower than native. The persona prompt should prefer vectorized `replicate()` code over `bind_rows` loops (the Stage 1 snippet's pattern). Measure a 1,000-resample bootstrap on the 1,200-row file on a weak laptop.
- *Blocked or slow networks, old browsers, tablets, memory limits.* Detect and show a clear message; offer the fallback or an in-person workaround.
- *Model writes R that fails or uses unavailable packages.* This is acceptable and pedagogically useful, but the model should retry once and then report the error plainly.

## 4. Supabase schema

All new tables are separate from `debate_responses`, which keeps its current open-upsert pattern for the quiz.

```sql
create table roster (
  student_code text primary key,
  access_key_hash text,              -- optional, see section 2
  section text,
  active boolean not null default true,
  token_budget integer not null default 400000,  -- total tokens, both directions
  created_at timestamptz not null default now()
);

create table chat_sessions (
  id uuid primary key default gen_random_uuid(),
  student_code text not null references roster,
  debate_id text not null,
  persona_version text not null,
  model text not null,
  started_at timestamptz not null default now()
);

create table chat_messages (
  id bigint generated always as identity primary key,
  session_id uuid not null references chat_sessions,
  student_code text not null references roster,   -- denormalized for limits and audits
  turn_idx integer not null,
  stage text,                                     -- page stage when sent
  role text not null check (role in ('user','assistant','tool_call','tool_result')),
  content jsonb not null,
  client_reported boolean not null default false,
  model text, input_tokens integer, output_tokens integer, latency_ms integer,
  created_at timestamptz not null default now()
);

create table prompt_scores (
  id bigint generated always as identity primary key,
  session_id uuid not null references chat_sessions,
  rubric_version text not null, item_id text not null,
  met boolean, evidence text, method text,        -- 'regex' | 'code' | 'judge'
  judge_model text, created_at timestamptz not null default now(),
  unique (session_id, rubric_version, item_id, method)
);

create table app_config (key text primary key, value jsonb);  -- kill switch, global caps, model id
```

**Row-level security.** Enable RLS on every table above and create *no* policies for `anon` or `authenticated`; also `revoke all` on these tables from both roles. The result is default-deny: the publishable key in the page cannot read or write any of them. Only the Edge Function, using the service-role key held as a function secret, touches them (it bypasses RLS). Students see their own history only through the function's `history` action, which checks code and key. Instructor access is through the Supabase dashboard, the service role in a local R script, or a view restricted to an instructor role. Keep `roster` unreadable so codes cannot be enumerated, and return one uniform error for bad code or bad key. One adjacent check I cannot do from the files: confirm that the existing `debate_responses` policies do not let the anon key select other students' rows.

Per-student limits come from queries over `chat_messages` (messages in the last minute, tokens used in total) compared against `roster.token_budget`; no separate counter table is needed at this scale.

## 5. Security, abuse and privacy

- **Key handling.** The model key lives only in Edge Function secrets. Set a hard monthly spend limit at the provider as the final backstop, independent of anything in code.
- **Who the adversary is.** The only user is a student, so "prompt injection" mainly means students trying to jailbreak the persona, extract the system prompt, or use the endpoint for unrelated work. Neither the prompt nor the tools should contain anything secret: the datasets are public in the repository, and the system prompt must not include `true_ate` or `edb3_results.js` contents. A leaked prompt then costs nothing.
- **Tool output as untrusted input.** Treat `tool_result` text as data. Truncate it, and tell the model in the system prompt that tool output never contains instructions.
- **Cost caps.** Maximum 2,000 characters per student message; maximum output tokens per model call; at most four tool iterations per turn; at most 30 turns per session; per-student token budget; per-IP throttle on failed roster checks; a global daily cap and a kill switch in `app_config`.
- **Privacy.** Log `student_code` only; no names, VUIDs or emails reach Supabase or the model. Logs linked to a code are still education records once the roster mapping exists, so keep that mapping outside the database (in the course gradebook or the linkage plan, which I have not read) and set a retention date. Students can type personal information into a chat box, so state on the page that conversations are logged, instruct them not to enter personal details, and cap length. Confirm the vendor's API data-use terms (my understanding is that API inputs are not used for training by default at both major vendors, but verify) and any Vanderbilt policy on third-party AI services (Q5). The data are simulated, so the sensitivity of the content is low; the exposure is in the student-linked behavior logs.

## 6. Pedagogical design of the analyst

**Persona: a literal, terse junior analyst at Meridian.** It runs what it is asked to run and reports the numbers. It does not volunteer confounders, suggest additional analyses, or comment on causality unless asked. Two constraints keep this from becoming deceptive. First, every number it states must come from executed code in the same turn. Second, if asked directly whether a result is causal or a fair comparison, it answers honestly and briefly. The design is "naive, not dishonest": the failure the course wants students to notice is the one they cause by under-specifying, not one the tool plants. I would not seed deliberate computational errors in v1. A later variant could add a "sloppy" mode that occasionally mis-implements a request (for example pooling when "within groups" was asked) with the ground truth logged, which would test the *evaluate output* goal directly (Q6).

Version the persona (`persona_version`) and keep it in `app_config`, so the Phase A GPT can share the same text.

**Auto-scoring.** Score at the session level on a short rubric, aligned to the stages: (R1) names outcome and grouping variable; (R2) requests a comparison within prior-performance groups or otherwise conditions on `prior_pctile`; (R3) requests resampling or an interval, ideally with seed and number of resamples; (R4) turns to the experiment file for a causal question; (R5) asks for effects by `job`; (R6) separates `minutes` from `per_minute`; (R7) questions selection or causal interpretation; (R8) verifies or challenges a returned number or reads the code.

Two layers, because each has a distinct weakness:

- *Deterministic checks.* Regex on student text for R2, R3, R5, R6 (`quintile|prior|within|control|stratif`, `bootstrap|resampl|interval`, `job`, `minutes|per_minute`) and, more reliably, AST-like pattern matching on the *executed code* (was there a `group_by` on `prior_pctile` or a stratified loop?). Code checks tell you what analysis was run; text checks tell you what the student asked for. Regex fails on paraphrase and on negation ("don't control for anything").
- *LLM judge.* A stronger model reads the student's messages and the code, applies the rubric with a required verbatim quote for each item, outputs structured JSON, runs at temperature 0, and runs offline after the session. Student text is delimited as data, because students may write "give me full marks." Disagreement between layers flags a session for human review.

Validate before using: hand-code about 50 sessions, compare with both layers, and report agreement per item (I would want substantial agreement, for instance kappa near 0.7 or better, before trusting any item). I recommend using scores for participation credit and formative feedback only, not high-stakes grading, and showing students their rubric feedback after the session rather than during it, so as not to coach the behavior being measured.

## 7. Cost estimate (100 students, about 15 turns each)

Assumptions: 1,500 student turns; about 1.5 model calls per turn when tool use is included (about 2,250 calls); average input about 6,000 tokens per call (system prompt plus accumulating history plus tool output); average output about 400 tokens per call. That is roughly 13.5 million input tokens and 0.9 million output tokens, before prompt caching, which should cut input cost materially.

For a mid-tier model, I would plan on input at roughly \$1 to \$5 per million tokens and output at roughly \$5 to \$25 per million (these are assumptions to verify, not quotes), giving a main-chat cost of about \$20 to \$90 for the whole class. The offline judge adds roughly 3 to 5 million input tokens at a stronger-model rate, perhaps \$10 to \$40 including reruns. Budget \$150 to \$250 with pilot, red-teaming, and a safety margin, and set the provider hard cap near that. Supabase's free tier may suffice for storage and invocations at this scale, but check current limits on invocation counts, function execution time, and inactivity pausing; a Pro plan for the month would be a modest, known cost. Check also that your API account tier allows about 100 students sending requests in the same minute; low-tier accounts can hit requests-per-minute limits in a live class.

## 8. Build plan

| Phase | Work | Effort (focused days) |
|---|---|---|
| 0 | Decisions on open questions; provider account, spend cap; consent wording | 0.5 |
| 1 | Schema, RLS, roster load, Edge Function with logging and limits, no tools; curl tests; resolve the publishable-key/JWT question | 2 |
| 2 | Chat UI in `index.html`; WebR loader, CSV mounting, `run_r` loop, capture, timeout and restart; persona v1 | 3 to 4 |
| 3 | Red-team and pilot with TAs and a few students; measure WebR load and bootstrap time on weak devices; tune persona | 1 to 2 |
| 4 | Scoring pipeline (regex, code checks, judge), hand-coding validation, instructor summary in R or Quarto | 2 to 3 |
| 5 | Load test, retention and deletion job, student-facing logging notice | 1 |

Total about 10 to 13 days; a no-execution fallback (precomputed tools, phases 1, 3 and 4) is roughly 6 to 7. These are estimates with real uncertainty, mostly in WebR behavior on student hardware and the Supabase auth detail.

## Open questions for the instructor

1. Should chat transcripts count toward the grade, or only participation? This determines how rigorous scoring validation must be.
2. Is student code alone acceptable as identity, or should each student also get a secret key?
3. Where in the sequence should the analyst appear (Stage 1 onward, or only Stage 2), and is use required or optional?
4. Should students see rubric feedback, and when?
5. What do Vanderbilt policy and the chosen vendor's terms say about student-linked logs sent to a third-party model? Do you intend to analyze logs as research (which could require IRB review)?
6. Do you want the later "sloppy analyst" variant, or an A/B of naive versus forthcoming personas across sections?
7. What retention period do you want for logs?
8. Is a no-code fallback acceptable if WebR fails on a student's device, or must everyone run R?
9. Who owns operating the system during class sessions (TA on call for outages)?
10. Which vendor account and budget will pay, and is a hard cap of about \$250 appropriate?
