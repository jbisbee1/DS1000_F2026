# DS 1000 Evidence Debate 5: Design Session

EDB 5 (11/18) is the second of the two debates repurposed as scaffolding for the final project (see `../PROJECT_SEQUENCE_PLAN.md`). It replaces the planned red-team audit. Pairs design the artifact they will defend, by hand, before any software, and leave with the first draft of their Content Spec. On 11/30 they give that draft and a photo of their sketch to the Project Builder GPT (`../../Project/gpt/`).

The debate stays unaided (no AI, no internet except this page and the EDB 4 codebook). That fits the purpose: everything the GPT later refuses to supply is written here, in the students' own words.

## Format (about 35 minutes, pairs, one laptop + one sheet of poster paper per pair)

| Phase | The pair does | Saved (stage) |
|---|---|---|
| 1. Set up (~3 min) | Student codes; the EDB 4 pitch card, pair number and claim are filled in from the codes (see below); claim as of today; optional note on what changed | 0: pair row |
| 2. Make (~13 min) | On paper: title and claim, the **figure they expect** (hand-drawn, stamped EXPECTED), a **six-panel storyboard** (one panel per step of the argument chain), and what the visitor should look at first. On the page: title, the expected figure's type, axes and pattern, a 0-100 confidence, and one sentence per panel. One partner draws, the other types; they switch halfway | 1: pair row; `confidence` = figure confidence |
| 3. Headlines (~4 min) | The overhyped headline a careless outlet or AI summary would write, the headline they'd defend, and which words changed and why (the Lecture 19 lens applied to their own project) | 2 |
| 4. Visit (~10 min) | Paired with another pair (1↔3, 2↔4, 5↔7, 6↔8, ...: never their EDB 4 stress-test partner). Each way: 2 minutes of silent study, a **teach-back** (visitors explain the claim back without looking), then 3 minutes of grader-style questions. Hosts record what visitors said the claim was, what they missed, and the hardest question; visitors record their best question | 3 |
| 5. Revise (~5 min) | Revise the claim and panels in light of the visit; name one change to the sheet. Then each partner, on a hand-off screen, explains one assigned panel (data, method, alternatives, or warrant; partners get different ones) and names one fix for the pair they visited | 4: pair row (with the full spec as markdown in `spec_md`) + one row per student |

The final screen shows the spec draft, with **Download spec (.md)** and **Copy as text**, plus the steps for 11/30. It also has a photo upload: pairs can upload a photo of their sheet from the laptop, or scan a QR code that opens `photo.html` on a phone with their pair number filled in (they enter a student code there). Photos go to the private Supabase bucket `edb5-photos`, under `pair-<N>/`, named by side (front or back), student code and time. Large photos are shrunk to about 2400 px before upload. View them in the Supabase dashboard under Storage. The spec uses the same headings as `Project/gpt/content_spec_template.md`; Section 4 is marked EXPECTED, NOT A RESULT.

**Example sketches.** During Make, a button opens four example paper prototypes (three columns, one big figure, storyboard path, myth vs. evidence), each with a note on why the layout works. Their topics (coffee loyalty apps, bike-share and rain, shelter-dog photos, front-row seating) are fictional and deliberately off the data menu, so pairs borrow a layout and not a topic. The same four layouts are described in `Project/gpt/format_recipes.md`.

**Extensions (optional, for pairs who finish early).** Everyone builds a poster; from the final screen, pairs can also sketch a **slide-deck version** (5–8 takeaway headlines, the slide a grader sees on arrival, one appendix question; stage 5) or an **interactive-app version** (home screen plus a control sheet: control, the question it lets a viewer ask, what they'll say; stage 6), drawn on the back of the sheet. Saved extension sketches are appended to the downloadable spec, and the Project Builder starts from them on 11/30 and 12/02. They are not scored.

**Pre-filled pitch cards.** When a student enters their code, the page fills in their pair's EDB 4 pitch card, their pair number, and their final EDB 4 claim (only into empty fields; everything stays editable). The cards come from `pitch_cards.json`, built by `NFGH/EDB/make_edb5_pitch_cards.R` from the EDB 4 grading file and the pair roster. The file is public, so it holds no names or codes: each entry is stored under a hash of the student's code and encrypted with a key derived from that code, so a card can only be read by typing the right code. Rerun the script if pairs or EDB 4 grades change. Students with no EDB 4 card (currently Lavin Maddox and Jeremy Worth, plus anyone missing from the grading file) see a note and can paste or type their card.

## Scoring (5 pts), consistent with earlier debates
Participation and reasoning quality across phases (pair rows, stages 0-4). The individual component is the panel explanation and the fix for the visited pair (individual rows, stage 4), which previews the defense's individual-command criterion.

## Before class
1. **Materials:** one sheet of poster paper (or two taped flip-chart sheets) and a few markers per pair, about 28 pairs. Tape or wall space for hosting visits.
2. **Photo uploads:** run `supabase_photo_setup.sql` once in the Supabase SQL editor. It creates a private storage bucket, `edb5-photos`, that students can upload to but not browse. (No Brightspace assignment is needed.)
3. **Announce on 11/16:** bring your EDB 4 pitch card (it's on the EDB 4 final screen, or in your notes) and anything you've found in your data since.
4. Pairs and pair numbers carry over from EDB 4 (`NFGH/edb4_pairs/pairs_PRIVATE.csv`). If a pair has lost a partner, the remaining student works alone and visits with a TA.
5. Do one live (non-dry) run and delete the test rows.

## Supabase
Writes to the existing `debate_responses` table with `debate_id = "evidence-debate-5-design-session"`. Pair rows use `student_code = "pair-<N>"`; individual rows (stage 4) use the student's own code. No new table is required if the anonymous upsert policy used by EDB 3 and EDB 4 is still active.

## Testing
- `?dry=1` logs every row to the browser console instead of saving it, and shows a yellow banner.
- `?reset=1` clears saved progress (key `ds1000_edb5_design_v1`).

## Files
- `index.html`: the page.
- `photo.html`: the phone upload page (opened from the QR code on the final screen).
- `upload.js`: the photo upload code both pages share.
- `supabase_photo_setup.sql`: one-time bucket setup.
- `pitch_cards.json`: encrypted EDB 4 pitch cards (built by `NFGH/EDB/make_edb5_pitch_cards.R`).
- `archive/`: the displaced tweet-sentiment debate (`index_tweet_sentiment.html`, `README_tweet_sentiment.md`, `tweet_sentiment_prep.R`, and its zip). Its numbers were never filled in; it can serve as a makeup or practice set after running the prep script. The folder is gitignored, so it isn't published.
