# Risk Scoring Methodology
### rmsecurity | 31-RISK-MANAGEMENT

*How rmsecurity translates technical vulnerability scores into business risk.*

---

## Base Score: CVSS v3.1

All findings start with a CVSS v3.1 base score. CVSS measures technical severity —
it does not account for the client's specific context.

## Context Modifiers

After the CVSS base score, apply these adjustments:

| Factor | Condition | Adjustment |
|--------|-----------|-----------|
| Internet exposure | Vulnerability is externally reachable | +1 severity level |
| Active exploitation | CVE on CISA KEV or EPSS > 50% | Upgrade to Critical |
| Data sensitivity | PII, payment, or health data at risk | +1 severity level |
| Business criticality | Affects a system essential to operations | +1 severity level |
| Compensating control | Effective mitigation in place | -1 severity level |
| Unauthenticated | No credentials required to exploit | +1 severity level |

**Cap: maximum severity is Critical. Floor: minimum is Low (never below 0.1).**

---

## Severity Definitions

| Severity | CVSS Range | Business Impact |
|---------|-----------|----------------|
| Critical | 9.0–10.0 | Immediate, severe impact — data breach, ransomware, full system compromise likely without action in 24-72 hours |
| High | 7.0–8.9 | Significant risk — attacker can cause serious damage; remediate within 7 days |
| Medium | 4.0–6.9 | Meaningful risk — requires chained attack or specific conditions; remediate within 30 days |
| Low | 0.1–3.9 | Limited direct impact — defense-in-depth issue; remediate within 90 days |
| Informational | 0.0 | Observation, no direct vulnerability — improve when convenient |

---

## Business Risk Translation

For executive-facing communication, translate technical severity into business terms:

| Technical | Business Language |
|-----------|-----------------|
| RCE (Remote Code Execution) | An attacker can take complete control of [SYSTEM] remotely |
| SQLi → data extraction | An attacker can read and export the entire [DATABASE] without credentials |
| Credential exposure | An attacker can impersonate any user, including administrators |
| Lateral movement path | A breach of one workstation provides access to the entire network |
| AD domain compromise | An attacker has administrative control over all [N] computers and [N] users in the organization |
| Public cloud storage | Any internet user can download [data type] without authentication |

---

## Risk Acceptance Criteria

Clients may formally accept a risk under these conditions:

1. The risk is documented in writing with business justification
2. A compensating control is in place or explicitly waived
3. The acceptance is signed by an appropriate authority (CISO or equivalent)
4. An expiry date is set: Critical max 30 days, High max 90 days, Medium max 180 days
5. The risk is tracked and reviewed at expiry

**rmsecurity never recommends accepting Critical risks without a compensating control.**
