# Risk Classification Standard
### rmsecurity | 01-STANDARDS

## Severity Levels

rmsecurity uses five severity levels for all findings across all service types.
These levels are consistent across pentests, assessments, cloud reviews, and audits.

| Severity | Color | CVSS v3.1 Base | Remediation SLA |
|---------|-------|---------------|----------------|
| Critical | Red `#D92B2B` | 9.0 – 10.0 | 24–72 hours |
| High | Orange `#E05A00` | 7.0 – 8.9 | 7 days |
| Medium | Amber `#D4A017` | 4.0 – 6.9 | 30 days |
| Low | Green `#2E7D32` | 0.1 – 3.9 | 90 days |
| Informational | Blue `#1565C0` | N/A | Best effort |

---

## Severity Definitions

### Critical
Remote unauthenticated exploitation, direct path to domain compromise,
ransomware deployment, or mass data exfiltration. Requires immediate escalation
to client leadership. Testing may pause pending client response.

Examples: unauthenticated RCE on internet-facing system, default credentials
on domain controller, unpatched EternalBlue on production server.

### High
Significant exploitation potential, requires authentication or specific conditions,
leads to privilege escalation, lateral movement, or substantial data access.

Examples: authenticated RCE, SMB relay to admin, Kerberoastable accounts
with crackable hashes, critical misconfigurations in cloud IAM.

### Medium
Exploitable under specific conditions, provides limited access or information,
or represents a control gap that enables higher-severity attacks.

Examples: missing security headers, weak password policy, unnecessary services,
SSRF with limited impact, insecure direct object references.

### Low
Minimal direct impact, requires significant pre-conditions, or represents
defense-in-depth gaps that matter when combined with other weaknesses.

Examples: verbose error messages, outdated but non-exploitable software,
missing account lockout on low-value systems, weak TLS cipher suites.

### Informational
Observations, best practice recommendations, or configuration improvements
with no direct security impact. Included for completeness and client awareness.

---

## CVSS Adjustment Policy

The CVSS v3.1 base score provides the starting severity.
rmsecurity may adjust severity based on business context:

| Factor | Possible adjustment |
|--------|-------------------|
| Asset is a crown jewel (DC, payment system, PII database) | Up one level |
| Vulnerability is not exploitable in this specific environment | Down one level |
| Public exploit available and actively used in the wild | Up one level |
| Compensating control significantly reduces risk | Down one level |
| Client industry makes this risk particularly severe | Up one level |

**Maximum one level adjustment in either direction.**
Every adjustment must be documented in the finding with the reason.

---

## Overall Engagement Risk Rating

At the conclusion of every engagement, assign one overall risk rating:

| Rating | Criteria |
|--------|---------|
| Critical | One or more Critical findings present |
| High | One or more High findings, no Critical |
| Medium | Medium findings only, no Critical or High |
| Low | Low and Informational findings only |
| Minimal | No findings, or only Informational |

This rating appears on the executive summary cover and in the risk gauge.
