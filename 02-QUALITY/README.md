# 02-QUALITY — Quality Management System
### rmsecurity | CCOS

## Purpose

This domain is the enforcement layer of rmsecurity's operational standards.
Every deliverable produced by the company passes through a quality gate
before it reaches the client. No exceptions.

Quality is not a review performed at the end. It is a process built into
every step of the engagement pipeline — from how evidence is collected,
to how findings are written, to how reports are structured and reviewed.

This domain does not define standards (that is `01-STANDARDS`).
It defines the controls that verify those standards are being followed.

---

## The Four Quality Gates

Every engagement has four mandatory gates. A gate is a checkpoint that
must be passed before work can proceed to the next stage.

```
Gate 1 — PRE-ENGAGEMENT        Gate 2 — FINDING VALIDATION
Scope, ROE, legal cleared       Every finding peer-reviewed
         │                               │
         ▼                               ▼
   Work begins                    Gate 3 — REPORT QA
                                  Full report reviewed
                                          │
                                          ▼
                                  Gate 4 — PRE-DELIVERY
                                  Final check before sending
```

No deliverable is sent to a client that has not passed Gates 3 and 4.
No pentest begins without passing Gate 1.

---

## Directory Structure

```
02-QUALITY/
├── README.md
├── gates/
│   ├── gate-1-pre-engagement.md       ← checklist before testing begins
│   ├── gate-2-finding-validation.md   ← checklist for every finding
│   ├── gate-3-report-qa.md            ← full report review checklist
│   └── gate-4-pre-delivery.md         ← final delivery checklist
├── checklists/
│   ├── checklist-pentest.md           ← pentest-specific QA items
│   ├── checklist-assessment.md        ← assessment-specific QA items
│   ├── checklist-evidence.md          ← evidence quality rules
│   └── checklist-executive-report.md  ← executive summary QA
├── peer-review/
│   ├── peer-review-process.md         ← how peer reviews work
│   └── peer-review-form.md            ← the form used in every review
└── metrics/
    └── quality-metrics.md             ← how quality is measured over time
```

## Inputs

- Findings from all technical service domains
- Draft reports from `41-REPORTING` and `42-EXECUTIVE-REPORTING`
- Evidence from `40-EVIDENCE`
- Completed engagement work from any `20-27` domain

## Outputs

- Gate pass / fail decisions (documented)
- Peer review records
- Approved deliverables
- Quality defect log (feeds `51-CONTINUOUS-IMPROV`)
- Quality metrics (feeds `50-METRICS`)

## Related Domains

- `01-STANDARDS` — defines what quality means (this domain enforces it)
- `40-EVIDENCE` — evidence quality is verified at Gate 2
- `41-REPORTING` / `42-EXECUTIVE-REPORTING` — outputs reviewed at Gate 3
- `51-CONTINUOUS-IMPROV` — quality defects become improvement actions
