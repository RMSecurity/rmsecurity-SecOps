# 30-THREAT-INTELLIGENCE — Threat Intelligence
### rmsecurity | CCOS

## Purpose

Track relevant threats, CVEs, and adversary techniques so engagements
reflect the current threat landscape, and clients receive timely warnings
about vulnerabilities affecting their environment.

## Directory Structure

```
30-THREAT-INTELLIGENCE/
├── README.md
├── procedures/
│   └── cve-monitoring.md       <- weekly CVE triage process
└── watchlists/
    ├── cve-watchlist.md        <- actively monitored CVEs
    └── threat-actors.md        <- relevant threat actor profiles
```

## Weekly Process

Every Monday:
1. Review CISA KEV additions from the past week
2. Review NVD CVEs with CVSS >= 9.0 published in the past week
3. Check vendor advisories for software in the rmsecurity toolset
4. Flag any CVEs relevant to current active engagements
5. Update `cve-watchlist.md` with new entries

## Sources

| Source | URL | Frequency |
|--------|-----|-----------|
| CISA KEV | cisa.gov/known-exploited-vulnerabilities-catalog | Daily |
| NVD | nvd.nist.gov/vuln/search | Weekly |
| FIRST EPSS | api.first.org/data/v1/epss | Weekly |
| ProjectZero | googleprojectzero.blogspot.com | As published |
| ExploitDB | exploit-db.com | Weekly |
| Vendor advisories | Microsoft, Cisco, Fortinet, etc. | Monthly |

## Related Domains

- `22-PENTESTING/` — new CVEs may add to exploitation playbooks
- `32-KNOWLEDGE-BASE/` — vetted intel feeds into the findings library
