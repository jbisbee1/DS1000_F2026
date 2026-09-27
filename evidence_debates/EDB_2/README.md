# DS 1000 Evidence Debate 2 — Bechdel Test & Box Office

## Claim
**"Feminist movies fail at the box office."**

This activity operationalizes "feminist movie" using the Bechdel test (at least two named women who talk to each other about something other than a man) and follows the same staged Evidence Debate architecture used elsewhere in DS 1000: Stage 0 prior judgment → Evidence A → Evidence B → Evidence C → team argument → individual adjudication.

The activity is built around Unit 2 skills: describing a bivariate relationship, identifying a plausible confounder (production budget), and comparing a pooled relationship to the relationship within subgroups.

## Evidence sequence
- **A — The initial comparison:** box-office revenue by Bechdel test result (pass/fail), pooled across all movies.
- **B1 — Bechdel status and budget:** whether production budget differs between movies that pass and fail the test.
- **B2 — Budget and box office:** the relationship between production budget and gross revenue.
- **C — Compare like with like:** box-office revenue by Bechdel result within budget bins, so students can see whether the pooled Stage-A pattern holds up once budget is held (roughly) constant.

## Data & reproducing the figures
`bechdel_prep.R` pulls `mv.Rds` (movie budget/gross/Bechdel data) from the course's F2024 data repo and regenerates all four evidence figures plus `assets/underlying_summaries.csv`. Run it with the working directory set to this folder (`evidence_debates/EDB_2/`) so the output lands in `./assets` alongside `index.html`.

## Supabase setup
The page writes to the existing `debate_responses` table using the same Supabase project and publishable key as the other DS 1000 debate pages — already filled in in `index.html`:

```js
const SUPABASE_URL = "https://syjgkatbxjiyjiosacdr.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "sb_publishable_dpOWSyvPGnRtpef9UYMvgg_I2x-hSnG";
```

The activity uses:
`DEBATE_ID = "bechdel-debate-2026"`

No new table is required if the existing anonymous INSERT policy on `debate_responses` remains active.

## Student-code note
The page currently generates and stores an anonymous student code in browser local storage (shared with the other debate pages via the `ds1000_evidence_debate1_student_code_v1` key, by design, so the same code follows a student across debates). Before deployment, implement the course-level student-code linkage plan (`evidence_debates/DS1000_student_code_linkage_plan.md`) so the same *assigned* code — not a randomly generated one — is used across all five debates.

## Testing
To reset the reveal sequence during development, clear this local-storage key in the browser console:

```js
localStorage.removeItem("ds1000_evidence_debate1_bechdel_stage_bechdel-debate-2026")
```

Reload the page afterward.

## Files
- `index.html` — student-facing staged debate
- `assets/evidence_A_bechdel_gross.png`
- `assets/evidence_B1_bechdel_budget.png`
- `assets/evidence_B2_budget_gross.png`
- `assets/evidence_C_bechdel_gross_by_budget.png`
- `assets/underlying_summaries.csv` — group medians underlying each figure
- `bechdel_prep.R` — regenerates the figures and summary CSV from `mv.Rds`
- `ds1000_evidence_debate2_bechdel_box_office.zip` — packaged copy of `index.html` + `assets/`

All evidence figures are clickable and open in a full-screen modal.
