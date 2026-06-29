# 12-CLIENT-LIFECYCLE — Client Lifecycle Management
### rmsecurity | CCOS

## Purpose

Manages every client touchpoint from first contact through final archive.
Every interaction, document, and communication has a defined process here.

The lifecycle ensures that no client is handled inconsistently and
that every engagement starts, runs, and closes the same way — regardless
of how busy the pipeline is.

## Lifecycle Stages

```
01 LEAD          →  02 SCOPING       →  03 PROPOSAL
New contact          Requirements         Quote + SOW
captured             understood           sent

        ↓
04 CONTRACT      →  05 KICK-OFF      →  06 DELIVERY
ROE + MSA            Testing begins       Reports sent
signed               Gate 1 passed        Gates 3 + 4

        ↓
07 DEBRIEF       →  08 REMEDIATION   →  09 ARCHIVE
Results walk-        Client fixes         Engagement
through              Retest               closed
```

## Directory Structure

```
12-CLIENT-LIFECYCLE/
├── README.md
├── templates/
│   ├── template-nda.md
│   ├── template-roe.md
│   ├── template-kickoff-agenda.md
│   ├── email-testing-start.md
│   ├── email-report-delivery.md
│   └── email-retest-request.md
├── onboarding/
│   └── client-onboarding-checklist.md
└── offboarding/
    └── engagement-closure-checklist.md
```

## Related Domains

- `14-SERVICE-CATALOG` — scope and deliverables defined here
- `02-QUALITY` — Gate 1 runs during onboarding, Gates 3–4 during delivery
- `41-REPORTING` — report templates used at delivery stage
- `40-EVIDENCE` — evidence management during active engagement
- `43-REMEDIATION` — post-delivery remediation tracking
