# 14-SERVICE-CATALOG — Service Catalog
### rmsecurity | CCOS

## Purpose

The single source of truth for what rmsecurity sells, how each service
is scoped, what it delivers, and how it is priced. Every proposal,
quote, and SOW originates from this catalog.

Nothing is sold that is not defined here first.

## Directory Structure

```
14-SERVICE-CATALOG/
├── README.md
├── services/
│   ├── pentest-external.md
│   ├── pentest-internal.md
│   ├── pentest-web.md
│   ├── pentest-ad.md
│   ├── pentest-red-team.md
│   ├── assessment-cloud.md
│   ├── assessment-gap.md
│   ├── vuln-management.md
│   ├── incident-response.md
│   └── phishing-simulation.md
└── pricing/
    ├── pricing-model.md
    └── sla-commitments.md
```

## Service Summary

| Code | Service | Typical Duration | Primary Deliverable |
|------|---------|-----------------|-------------------|
| `PENTEST-EXT` | External Network Pentest | 3–5 days | Technical Report + Executive Summary |
| `PENTEST-INT` | Internal Network Pentest | 5–10 days | Technical Report + Executive Summary |
| `PENTEST-WEB` | Web Application Pentest | 3–7 days | Technical Report + Executive Summary |
| `PENTEST-AD` | Active Directory Assessment | 3–5 days | Technical Report + Executive Summary |
| `PENTEST-RED` | Red Team Engagement | 2–4 weeks | Red Team Report + Executive Summary |
| `ASSESS-CLOUD` | Cloud Security Assessment | 3–5 days | Technical Report + Hardening Roadmap |
| `ASSESS-GAP` | Security Gap Assessment | 3–5 days | Gap Analysis + Remediation Roadmap |
| `VULN-MGMT` | Vulnerability Management | Ongoing | Monthly Reports + Dashboard |
| `IR-RETAINER` | Incident Response Retainer | Ongoing | SLA-backed response |
| `PHISHING` | Phishing Simulation | 1–2 weeks | Campaign Report + Awareness Metrics |

## Related Domains

- `11-BUSINESS-DEV` — uses catalog to generate proposals and quotes
- `12-CLIENT-LIFECYCLE` — uses service definitions to scope SOWs
- `02-QUALITY` — quality gates apply per service type
- `41-REPORTING` — report templates exist per service type
