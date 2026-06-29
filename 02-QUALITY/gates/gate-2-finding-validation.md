# Gate 2 — Finding Validation Quality Gate
### rmsecurity | 02-QUALITY

## Purpose

Every finding must be validated before it enters the report.
A finding that cannot be reproduced, lacks evidence, or has an incorrect
severity score damages rmsecurity's credibility and may harm the client.

Gate 2 is performed on each finding individually, as soon as it is documented —
not at the end of the engagement when there is time pressure.

---

## Finding Validation Checklist

Run this checklist for every finding. One checklist per finding ID.

### Reproducibility

- [ ] The finding can be reproduced from the steps documented in the finding file
- [ ] Another consultant could reproduce it using only the information in the finding
- [ ] If intermittent or condition-dependent: conditions are explicitly documented
- [ ] The steps to reproduce use only tools and techniques within the ROE

### Evidence

- [ ] At least one piece of evidence is attached (screenshot, output, log)
- [ ] Evidence clearly shows the vulnerability or its impact — not just the tool running
- [ ] Evidence files are named following the `EV-ENG-YYYY-NNN-NNN` standard
- [ ] Evidence files are hashed and logged in `manifest.csv`
- [ ] Evidence is sufficient for a skeptical client to accept the finding
- [ ] For critical findings: minimum two independent pieces of evidence

### Finding Content

- [ ] Finding ID assigned (`FND-ENG-YYYY-NNN-NNN`)
- [ ] Title is specific and descriptive (not generic like "SQL Injection found")
- [ ] Description explains what is broken and why — not how it was found
- [ ] Impact section connects to business risk, not just technical impact
- [ ] CVSS v3.1 score calculated and vector string included
- [ ] Any severity adjustment from CVSS baseline is documented with reason
- [ ] Affected assets listed with hostnames and IPs
- [ ] CWE ID included where applicable
- [ ] CVE ID included if a known vulnerability
- [ ] MITRE ATT&CK technique mapped
- [ ] Remediation guidance is specific and actionable (not "update the software")
- [ ] Remediation includes both short-term mitigation and long-term fix
- [ ] At least one reference link included in remediation

### Classification

- [ ] Severity level is appropriate for the business context
- [ ] Finding is correctly categorized (not a duplicate of another finding)
- [ ] If the finding affects multiple assets, it is one finding with multiple affected assets
  (not duplicated once per asset unless the root cause differs)

---

## Validation Record

Save this in the finding file under a "Validation" heading:

```
## Validation

| Field | Value |
|-------|-------|
| Validated by | Operator name |
| Validation date | YYYY-MM-DD |
| Reproducibility confirmed | YES / NO |
| Evidence verified | YES / NO |
| Severity reviewed | YES / NO |
| Gate 2 result | PASS / FAIL |
| Notes | |
```

---

## Common Validation Failures and How to Fix Them

| Failure | Fix |
|---------|-----|
| "Steps to reproduce" are incomplete | Add exact commands, parameters, and expected output |
| Evidence only shows a tool running, not the impact | Add screenshot of the actual impact (data accessed, shell obtained) |
| "Impact" is generic ("attacker could compromise system") | Specify: which data, which systems, what would happen in this environment |
| Remediation says "patch the system" | Name the specific patch, version, or configuration change required |
| CVSS score not matching the described vulnerability | Recalculate — use the online calculator, document the vector |
