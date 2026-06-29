# 24-VULN-MANAGEMENT — Vulnerability Management
### rmsecurity | CCOS

## Purpose

Advisory procedures for helping clients build and operate a vulnerability
management program. Distinct from rmsecurity performing a one-time assessment —
this is the ongoing process the client follows between assessments.

## Directory Structure

```
24-VULN-MANAGEMENT/
├── README.md
└── procedures/
    └── vuln-triage.md    <- how clients should prioritize and track vulns
```

## Core Concepts

- **MTTR (Mean Time to Remediate):** key metric — track per severity
- **SLA-based prioritization:** Critical 24-72h, High 7d, Medium 30d, Low 90d
- **Vulnerability aging:** vulns that exceed SLA become risk-accepted or escalated
- **Patch Tuesday awareness:** plan patch windows around Microsoft release cadence

## Related Domains

- `43-REMEDIATION/` — rmsecurity tracker is the input to the client VM program
- `21-SECURITY-ASSESSMENT/` — periodic scans feed the VM program
