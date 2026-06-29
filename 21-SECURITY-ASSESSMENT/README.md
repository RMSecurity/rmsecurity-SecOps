# 21-SECURITY-ASSESSMENT — Vulnerability Assessment
### rmsecurity | CCOS

## Purpose

Structured vulnerability scanning and assessment procedures — distinct from
penetration testing in that the goal is to enumerate vulnerabilities without
necessarily exploiting them. Used for compliance-driven assessments and
as the scanning phase within penetration tests.

## Directory Structure

```
21-SECURITY-ASSESSMENT/
├── README.md
├── playbooks/
│   └── vuln-scan-procedure.md   <- authenticated and unauthenticated scanning
└── tools/
    └── scanner-config.md        <- Nessus / OpenVAS configuration reference
```

## Assessment vs Pentest

| Dimension | Vulnerability Assessment | Penetration Test |
|-----------|------------------------|-----------------|
| Exploitation | No — identify only | Yes — prove impact |
| Depth | Broad coverage | Targeted, deep |
| Output | Vulnerability list | Attack chains + business impact |
| Credentials | Usually credentialed | Starts uncredentialed |
| Duration | 1–3 days | 3–10 days |

## Related Domains

- `22-PENTESTING/` — exploitation builds on VA findings
- `24-VULN-MANAGEMENT/` — client uses VA output for ongoing management
