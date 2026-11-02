# DS 1000 Evidence Debate 4 — Congress and Polarization

## Claim
**"Political polarization in Congress has become so extreme that a legislator's party can now be predicted almost perfectly just from their voting record — proof that Americans have become deeply divided."**

This package follows the staged Evidence Debate architecture used elsewhere in DS 1000:
Stage 0 prior judgment → Evidence A → Evidence B → Evidence C → Evidence D → team argument → individual adjudication.

The activity is built around Unit 4 skills (prediction vs. explanation, classification evaluation, what a model's accuracy does and doesn't establish) and closes with a Unit 1-style construct-validity audit, giving the semester's first and last units a direct callback.

## ⚠️ Before deployment: run the prep script

Unlike EDB1/EDB3, this activity's evidence panels are **data tables, not pre-rendered images**, and the exact numbers were not computed in this environment (no R available). `index.html` currently contains `[FILL IN: ...]` placeholders in Stage 1 and Stage 3's tables.

1. Run `congress_prep.R` with the working directory set to this folder (`evidence_debates/EDB_4/`). It reproduces the exact classification workflow from Lecture 14/15 (linear-probability-model classifier predicting party from `nominate_dim1`/`nominate_dim2`, 100 cross-validated train/test splits, accuracy at a 0.5 cutoff, and AUC via `sweep_thresholds()`/`compute_auc()`).
2. It prints six results (97th/117th Congress, each overall and by chamber) and also writes them to `assets/congress_classification_results.csv`.
3. Replace each `[FILL IN: ...]` placeholder in `index.html`'s Stage 1 and Stage 3 tables with the corresponding real number.
4. Sanity-check the numbers make substantive sense before deploying (the debate's Evidence B and C prompts assume — but do not require — that predictability rose from the 97th to the 117th Congress; if the actual numbers show something different, the prompts in Stage 1–3 may need light rewording to match what the data actually shows, rather than what was expected).

## Evidence sequence
- **A — Can party be predicted from voting record?** Held-out accuracy and AUC of a party classifier, 97th vs. 117th Congress.
- **B — Whose polarization is this measuring?** The elite/party-sorting vs. mass-polarization distinction — rising predictability of party from voting record is direct evidence of the former, weaker evidence of the latter.
- **C — Does the pattern hold in both chambers?** The same classifier run separately for House and Senate, as a robustness check (Lecture 10's "resampled from what?" habit).
- **D — What does DW-NOMINATE actually measure?** A construct-validity audit: DW-NOMINATE is built from roll-call votes, not survey data on how divided the public feels (affective polarization). Closes with two separate confidence sliders — one for the narrow, data-supported claim (predictability rose) and one for the broad claim in the debate title (Americans are more divided) — the same narrow-vs-broad structure EDB3 uses for productivity vs. employer benefit.

## Data
`H097_members.csv` and `H117_members.csv` (already in `data/`), the same DW-NOMINATE files used in Lecture 16's clustering demonstration. This debate reframes the same underlying data as a classification problem instead of a clustering problem, giving students two different analytical lenses on one real dataset.

## Supabase setup
The page writes to the existing `debate_responses` table using the same Supabase project and publishable key as the other DS 1000 debate pages — already filled in in `index.html`:

```js
const SUPABASE_URL = "https://syjgkatbxjiyjiosacdr.supabase.co";
const SUPABASE_KEY = "sb_publishable_dpOWSyvPGnRtpef9UYMvgg_I2x-hSnG";
```

The activity uses:
`EXPERIMENT_ID = "evidence-debate-4-congress-polarization"`

No new table is required if the existing anonymous INSERT policy on `debate_responses` remains active.

## Student-code note
The page uses a course-assigned student code (entered by the student, stored under the shared `ds1000_course_student_code` key), matching EDB3's approach and the course-level student-code linkage plan (`evidence_debates/DS1000_student_code_linkage_plan.md`).

## Testing
To reset the reveal sequence during development, clear this local-storage key in the browser console:

```js
localStorage.removeItem("ds1000_evidence_debate4_congress_stage")
```

Reload the page afterward.

## Files
- `index.html` — student-facing staged debate
- `congress_prep.R` — reproduces the classification results the evidence tables need
- `assets/congress_classification_results.csv` — prep script output (created when the script is run)
- `ds1000_evidence_debate4_congress_polarization.zip` — packaged copy of `index.html` + `congress_prep.R`
