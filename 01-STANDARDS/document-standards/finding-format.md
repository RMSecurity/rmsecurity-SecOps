# Finding Format Standard
### rmsecurity | 01-STANDARDS

## What is a Finding

A finding is any security weakness, misconfiguration, vulnerability, or
compliance gap discovered during an engagement. Every finding is a discrete,
numbered, trackable unit with a defined lifecycle.

This format is the single most important standard in rmsecurity.
Every technical report, remediation tracker, and retest result references findings
in this format. Consistency here directly determines report quality.

---

## Finding File

Each finding lives in its own markdown file in the engagement store:

```
05-findings/FND-ENG-YYYY-NNN-NNN_short-title.md
```

Example: `05-findings/FND-ENG-2026-001-003_smb-signing-disabled.md`

---

## Finding Template

```markdown
# [FND-ENG-YYYY-NNN-NNN] Finding Title

| Field | Value |
|-------|-------|
| Finding ID | FND-ENG-YYYY-NNN-NNN |
| Engagement | ENG-YYYY-NNN |
| Severity | Critical / High / Medium / Low / Informational |
| CVSS Score | X.X (vector string) |
| Status | Open / In Remediation / Resolved / Accepted |
| Discovered | YYYY-MM-DD |
| Discovered by | Operator name |
| Retested | YYYY-MM-DD or — |
| CWE | CWE-NNN |
| CVE | CVE-YYYY-NNNNN or N/A |
| MITRE ATT&CK | TNNNN.NNN — Technique Name |

## Description

One to three paragraphs. Explain what the vulnerability is, not how you found it.
Write for a technical reader who has not seen this environment.
Answer: what is broken and why does it exist?

## Impact

What can an attacker do by exploiting this?
Quantify where possible: access to X systems, exposure of Y data, ability to Z.
Connect to business risk — not just technical impact.

## Evidence

| ID | Description |
|----|------------|
| EV-ENG-YYYY-NNN-NNN | Screenshot showing [what] |
| EV-ENG-YYYY-NNN-NNN | Tool output demonstrating [what] |

## Steps to Reproduce

Numbered, exact steps. Another consultant should be able to reproduce this
from scratch using only this section.

1.
2.
3.

## Affected Assets

| Asset | Type | IP / URL | Notes |
|-------|------|---------|-------|
| hostname | Server / Workstation / Service | 192.168.x.x | Domain controller |

## Remediation

### Short term (immediate action)

Specific, actionable step to reduce the risk now. Not "patch the system" — be exact.

### Long term (permanent fix)

The correct architectural or configuration solution.

### References

- [Vendor advisory or documentation]
- [CWE description]
- [NIST guidance]

## Retest Notes

_To be completed after remediation._

| Field | Value |
|-------|-------|
| Retest date | |
| Retested by | |
| Result | Resolved / Not Resolved / Partially Resolved |
| Notes | |
```

---

## Severity Definitions

| Severity | CVSS Range | Remediation SLA | Color |
|---------|-----------|----------------|-------|
| Critical | 9.0 – 10.0 | 24–72 hours | `#D92B2B` |
| High | 7.0 – 8.9 | 7 days | `#E05A00` |
| Medium | 4.0 – 6.9 | 30 days | `#D4A017` |
| Low | 0.1 – 3.9 | 90 days | `#2E7D32` |
| Informational | N/A | Best effort | `#1565C0` |

Severity is determined by CVSS v3.1 base score, then adjusted up or down
based on business context (asset criticality, data sensitivity, exploitability
in the specific environment). Document any adjustment and the reason.

---

## Finding Lifecycle

```
Discovered → Documented → Peer Reviewed → In Report → Delivered
     ↓                                                      ↓
  Evidence                                          Client Acknowledges
  Collected                                                 ↓
                                                    Remediation Begins
                                                           ↓
                                                      Retest Requested
                                                           ↓
                                                    Retest Executed
                                                           ↓
                                              Resolved / Accepted / Ongoing
```

Status values:
- `Open` — documented, not yet delivered or remediated
- `In Remediation` — client is actively fixing
- `Pending Retest` — client says it is fixed, waiting for rmsecurity to verify
- `Resolved` — rmsecurity confirmed fixed in retest
- `Accepted` — client accepted the risk formally
- `Not Applicable` — finding was invalidated after further analysis
