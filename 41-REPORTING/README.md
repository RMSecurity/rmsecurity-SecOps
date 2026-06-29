# 41-REPORTING — Technical Report Templates
### rmsecurity | CCOS

## Purpose

Contains all templates, finding sheets, and tools needed to produce
rmsecurity's technical deliverables. Every report produced by rmsecurity
originates from a template in this directory.

## Directory Structure

```
41-REPORTING/
├── README.md
├── templates/
│   ├── technical-report-template.docx    ← main Word template with branding
│   └── remediation-tracker-template.xlsx ← finding tracker for client
└── finding-sheets/
    └── finding-sheet-template.md         ← single finding extraction sheet
```

## How to Use

1. Copy the template to the engagement store: `06-reports/drafts/`
2. Rename using the naming convention: `ENG-YYYY-NNN_[CLIENT]_Technical-Report_[DATE]_v0.1.docx`
3. Fill in all `[BRACKETED]` fields
4. Import findings from `05-findings/` using the finding format standard
5. Run Gate 3 QA checklist before finalizing
6. Export to PDF for delivery

## Related Domains

- `01-STANDARDS/document-standards/` — report structure this template implements
- `02-QUALITY/gates/gate-3-report-qa.md` — QA checklist for this output
- `10-CORPORATE/branding/` — colors and logo used in this template
- `42-EXECUTIVE-REPORTING/` — executive summary template
