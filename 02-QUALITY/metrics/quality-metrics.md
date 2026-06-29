# Quality Metrics
### rmsecurity | 02-QUALITY

## Purpose

What gets measured gets improved.
These metrics track the quality of rmsecurity's deliverables over time.
They are recorded per engagement and reviewed quarterly in `51-CONTINUOUS-IMPROV`.

---

## Metrics Collected Per Engagement

### Gate Metrics

| Metric | How to measure | Target |
|--------|---------------|--------|
| Gate 1 time to pass | Days from engagement open to Gate 1 pass | < 2 days |
| Gate 2 findings validated on first pass | % of findings that pass Gate 2 without rework | > 85% |
| Gate 3 issues found | Count of issues found at report QA | < 5 minor, 0 blockers |
| Gate 3 re-reviews required | Count of re-reviews per report | 0 |
| Gate 4 delivery package errors | Errors found at final check | 0 |

### Finding Quality Metrics

| Metric | How to measure | Target |
|--------|---------------|--------|
| Evidence per finding | Average count of evidence items per finding | ≥ 2 |
| Finding rework rate | % of findings that needed correction after Gate 2 | < 15% |
| CVSS accuracy | % of CVSS scores that were not adjusted | > 80% |
| Reproducibility rate | % of findings successfully reproduced in retest | > 95% |

### Report Quality Metrics

| Metric | How to measure | Target |
|--------|---------------|--------|
| Report QA issues (blockers) | Count per report | 0 |
| Report QA issues (major) | Count per report | < 3 |
| Client revision requests | Count of revisions requested after delivery | < 2 |
| Delivery on schedule | % of deliveries on agreed date | > 90% |
| Client satisfaction (report quality) | Score from satisfaction survey (1–5) | > 4.0 |

---

## Quarterly Quality Review

Each quarter, compile the following and review in the retrospective:

1. **Defect trend** — are we finding more or fewer issues at Gate 3 over time?
2. **Top defect categories** — which type of issue appears most often?
3. **Gate 2 rework rate** — are findings getting better the first time?
4. **Client feedback** — what did clients say about report quality?
5. **Checklist gaps** — did any issue slip through that the checklist should have caught?

Results feed into `51-CONTINUOUS-IMPROV` as action items.

---

## Defect Log

Maintain a simple defect log. One row per issue found at any gate.
File: `02-QUALITY/metrics/defect-log.csv`

```csv
date,engagement_id,gate,defect_type,description,severity,resolved,root_cause
2026-07-15,ENG-2026-001,Gate 3,Writing quality,Placeholder text not removed,BLOCKER,YES,Draft not reviewed before QA
```

Defect types:
- `Writing quality` — grammar, clarity, placeholders
- `Finding accuracy` — incorrect severity, wrong CVSS, missing evidence
- `Structure` — missing section, wrong format
- `Evidence` — missing hash, incomplete manifest
- `Classification` — wrong label, wrong distribution
- `Technical accuracy` — factual error in a finding
- `Delivery` — wrong recipient, unencrypted, missing file

---

## Quality Score (per engagement)

At engagement close, calculate a Quality Score (0–100):

| Component | Weight | Max points |
|-----------|--------|-----------|
| Gate 1 passed with zero issues | 10% | 10 |
| Gate 2 findings passed first time (≥85%) | 20% | 20 |
| Gate 3 blockers = 0 | 30% | 30 |
| Gate 3 major issues ≤ 2 | 20% | 20 |
| Gate 4 passed with zero errors | 10% | 10 |
| Client revision requests = 0 | 10% | 10 |

Score interpretation:

| Score | Rating |
|-------|--------|
| 90–100 | Excellent |
| 75–89 | Good |
| 60–74 | Acceptable — improvement needed |
| < 60 | Poor — mandatory retrospective |
