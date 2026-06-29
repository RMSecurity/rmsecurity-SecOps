# Vulnerability Triage Procedure
### rmsecurity | 24-VULN-MANAGEMENT

*Guidance for clients on building a vulnerability management program.
Delivered as an advisory output or appendix to assessment reports.*

---

## Core Process

```
Discover → Triage → Prioritize → Assign → Remediate → Verify → Track
```

---

## 1. Discovery Sources

| Source | Frequency | Tool |
|--------|-----------|------|
| Authenticated vulnerability scan | Weekly (critical assets) / Monthly (all) | Nessus, Qualys, Tenable |
| Unauthenticated scan | Monthly | Nessus, OpenVAS |
| External attack surface scan | Weekly | Shodan, Censys, runZero |
| Penetration test | Annually (minimum) | rmsecurity |
| Threat intelligence feeds | Continuous | CISA KEV, NVD, vendor advisories |
| Manual code review / SAST | Per release | Semgrep, SonarQube |

---

## 2. Triage Criteria

For each discovered vulnerability, answer:

| Question | Scoring |
|---------|---------|
| Is this exploitable from the internet? | Yes = +2 severity levels |
| Is there a known public exploit (in the wild)? | Yes = +1 severity level |
| Is this on a CISA KEV list? | Yes = treat as Critical regardless of CVSS |
| What data is at risk? | PII/payment = +1 severity level |
| Is compensating control in place? | Yes = -1 severity level |

---

## 3. SLA-Based Remediation Targets

| Severity | CVSS Range | SLA | Review Cadence |
|---------|-----------|-----|---------------|
| Critical | 9.0–10.0 | 24–72 hours (emergency) | Daily until closed |
| High | 7.0–8.9 | 7 calendar days | Weekly |
| Medium | 4.0–6.9 | 30 calendar days | Monthly |
| Low | 0.1–3.9 | 90 calendar days | Quarterly |
| Informational | 0.0 | Next scheduled maintenance | N/A |

**Override:** Any vulnerability on the CISA KEV list → treat as Critical regardless of CVSS.

---

## 4. Prioritization Framework (EPSS + CVSS)

Use **CVSS** for base severity, **EPSS** (Exploit Prediction Scoring System) for real-world risk:

```bash
# Check EPSS score for a CVE
curl -s "https://api.first.org/data/v1/epss?cve=[CVE-ID]" | python3 -m json.tool
```

| CVSS | EPSS > 50% | Priority |
|------|-----------|---------|
| Critical | Yes | P0 — Immediate |
| Critical | No | P1 — This week |
| High | Yes | P1 — This week |
| High | No | P2 — This month |
| Medium | Any | P3 — Standard SLA |

---

## 5. Tracking Metrics (Report Monthly to CISO)

| Metric | Target | How to Measure |
|--------|--------|---------------|
| Mean Time to Remediate — Critical | < 3 days | Avg days from discovery to closure |
| Mean Time to Remediate — High | < 14 days | Avg days from discovery to closure |
| Patch rate — Critical (% closed in SLA) | > 95% | (Closed in SLA / Total) × 100 |
| Patch rate — High (% closed in SLA) | > 90% | same |
| Vulnerability recurrence rate | < 5% | Findings from retest that were "Closed" |
| Open Critical vulnerabilities > 30 days | 0 | Count |

---

## 6. Risk Acceptance Process

If a vulnerability cannot be remediated within SLA:

1. Document the business reason for exception
2. Identify compensating controls in place
3. Set exception expiry date (max: 90 days for Critical, 6 months for High)
4. Get written sign-off from CISO / appropriate authority
5. Track as "Risk Accepted" in vulnerability tracker
6. Review at expiry — renew or remediate

**Never permanently accept Critical vulnerabilities without a documented compensating control.**

---

## 7. Patch Management Integration

```
Vulnerability scan → Identify patch → Test in non-prod → 
Approve change → Deploy → Rescan to verify → Close ticket
```

- Always test patches in staging before production
- Schedule Critical patches as emergency changes (outside change window if needed)
- Document rollback plan before applying patches to production
- Patch Tuesdays: plan patch windows weekly on Wednesday/Thursday
