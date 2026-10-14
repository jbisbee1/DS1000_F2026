# Meridian Services data dictionary (simulated data)

## edb3_firm_records.csv (n = 1,200; observational)
Each row is an employee. Employees **chose** whether to work from home.

| Column | Meaning |
|---|---|
| `id` | Employee identifier |
| `job` | Job type: Call center, Data entry, or Analyst |
| `prior_pctile` | Prior-year performance percentile (1-99; higher = stronger prior performance) |
| `wfh` | 1 = works from home, 0 = works in the office |
| `output` | Output per shift, indexed so the average office employee is about 100 |

Prior-performance quintiles used in class: 1-20, 21-40, 41-60, 61-80, 81-100 (on `prior_pctile`).

## edb3_experiment.csv (n = 300; randomized experiment)
Volunteers were **randomly assigned** to work from home or in the office for six months.

| Column | Meaning |
|---|---|
| `id` | Employee identifier |
| `job` | Job type: Call center (150), Data entry (75), Analyst (75) |
| `wfh` | 1 = randomly assigned to work from home, 0 = assigned to the office |
| `minutes` | Minutes worked per shift, indexed (office average about 100) |
| `per_minute` | Output per minute, indexed (office average about 100) |
| `output` | Output per shift, indexed; approximately `minutes * per_minute / 100` |

A difference of +4 in an index means 4% higher than the office average.
