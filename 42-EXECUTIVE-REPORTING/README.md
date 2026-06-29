# 42-EXECUTIVE-REPORTING — Executive Summary Templates
### rmsecurity | CCOS

## Purpose

Provides templates for the executive-facing deliverable — a concise, non-technical
summary of engagement results written for C-suite and board audiences. The executive
summary is always delivered alongside the technical report, never standalone.

## Directory Structure

```
42-EXECUTIVE-REPORTING/
├── README.md
└── templates/
    └── executive-summary-template.docx    ← 4–6 page branded Word template
```

## Executive Summary vs Technical Report

| Dimension | Executive Summary | Technical Report |
|-----------|------------------|-----------------|
| Length | 4–6 pages | 20–60 pages |
| Audience | CEO, CISO, Board | Security team, IT, developers |
| Language | Business risk | Technical detail |
| Findings detail | Risk narrative + counts | Full technical steps, PoC, CVE |
| Remediation | Strategic priorities | Specific technical fixes |

## How to Use

1. Complete the technical report first — the executive summary derives from it
2. Copy template to `06-reports/drafts/` in the engagement folder
3. Rename: `ENG-YYYY-NNN_[CLIENT]_Executive-Summary_[DATE]_v0.1.docx`
4. Fill all `[BRACKETED]` fields
5. Calibrate the risk narrative to the client's industry and risk appetite
6. Gate 3 QA applies to both reports

## Writing Guidance

- Write the risk narrative in terms of business impact, not technical mechanism
- Never use acronyms (CVE, CVSS, RCE) without spelling them out
- One finding = one business consequence
- Remediation priorities should align with business continuity risk, not just CVSS score

## Related Domains

- `41-REPORTING/` — technical report template
- `02-QUALITY/gates/gate-3-report-qa.md` — QA checklist covers both reports
- `01-STANDARDS/document-standards/report-structure.md` — structure this implements
- `10-CORPORATE/branding/` — brand guidelines for this template
