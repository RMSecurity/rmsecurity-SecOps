# 13-PROJECT-MGMT — Engagement Project Management
### rmsecurity | CCOS

## Purpose

Provides templates and procedures for managing the operational delivery
of engagements: timeline tracking, status reporting to clients, and internal
milestone management. Every engagement is a project with a defined timeline,
and that timeline must be actively managed.

## Directory Structure

```
13-PROJECT-MGMT/
├── README.md
└── templates/
    ├── engagement-timeline.md       <- per-engagement timeline and milestone tracker
    └── status-report-template.md    <- weekly client-facing status update
```

## Engagement Phases

```
Kick-off -> Reconnaissance -> Active Testing -> Findings Documentation ->
Report Draft -> QA (Gate 3) -> Report Delivery -> Debrief -> Retest
```

## Timeline Standards

| Engagement Size | Testing Days | Report Delivery | Total Duration |
|----------------|-------------|----------------|----------------|
| Small (1-2 days) | 1-2 | 5 business days | ~2 weeks |
| Medium (3-5 days) | 3-5 | 7 business days | 3-4 weeks |
| Large (6-10 days) | 6-10 | 10 business days | 4-6 weeks |

## Communication Cadence

- Testing phase: client notified at start and end
- Extended engagements (> 5 days): weekly status report
- Critical findings: notify client same-day via phone

## Related Domains

- `12-CLIENT-LIFECYCLE/` — triggers and communication templates
- `02-QUALITY/gates/` — gate checkpoints appear on the timeline
- `41-REPORTING/` — report delivery is the final milestone
