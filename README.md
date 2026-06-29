# CCOS — Cybersecurity Consulting Operating System
### rmsecurity | Internal Operations Repository

This repository is the single source of truth for every operation performed by rmsecurity.
Every client engagement, report, checklist, script, workflow, automation, policy, template,
and methodology originates here.

---

## What This Repository Is

CCOS is not a documentation repository. It is not a script collection. It is the operating
system of rmsecurity — a living, interconnected system where every module produces outputs
consumed by other modules.

**Nothing is duplicated. Everything is referenced. Every process is repeatable.**

---

## Repository Structure

```
CCOS/
├── 00-PLATFORM/           # Foundation: Git, CI/CD, Docker, Automation Engine
├── 01-STANDARDS/          # Policies, procedures, naming conventions, ADRs
├── 02-QUALITY/            # QA checklists, peer review, quality gates
├── 03-AUTOMATION/         # Python, PowerShell, GitHub Actions, AI agents
│
├── 10-CORPORATE/          # Finance, Legal, HR, Administration
├── 11-BUSINESS-DEV/       # Sales, Marketing, Proposals, CRM
├── 12-CLIENT-LIFECYCLE/   # Onboarding, ROE, delivery, archiving
├── 13-PROJECT-MGMT/       # Trackers, milestones, communication templates
├── 14-SERVICE-CATALOG/    # Service definitions, pricing tiers, SLAs
│
├── 20-RECON-OSINT/        # Asset discovery, passive and active reconnaissance
├── 21-SECURITY-ASSESSMENT/# Gap analysis, compliance audits
├── 22-PENTESTING/         # Red team, web, network, Active Directory
├── 23-CLOUD-SECURITY/     # Azure, AWS, M365, Entra ID
├── 24-VULN-MANAGEMENT/    # Scanning, prioritization, remediation tracking
├── 25-BLUE-TEAM/          # Detection engineering, hardening, threat hunting
├── 26-INCIDENT-RESPONSE/  # Playbooks, runbooks, communication templates
├── 27-FORENSICS/          # Acquisition, analysis, chain of custody
│
├── 30-THREAT-INTELLIGENCE/# Feeds, IOC enrichment, MITRE ATT&CK mapping
├── 31-RISK-MANAGEMENT/    # Risk register, scoring models, treatment records
├── 32-KNOWLEDGE-BASE/     # Articles, cheat sheets, decision logs, case studies
├── 33-RESEARCH-LAB/       # CVE research, tool development, PoC work
├── 34-TRAINING/           # Internal development, client workshops, labs
│
├── 40-EVIDENCE/           # Chain of custody, numbered artifact archive
├── 41-REPORTING/          # Technical report templates and finding sheets
├── 42-EXECUTIVE-REPORTING/# Executive templates, risk dashboards, decks
├── 43-REMEDIATION/        # Finding tracking, retest management, closure
│
├── 50-METRICS/            # KPI dashboards, OKRs, SLA compliance
├── 51-CONTINUOUS-IMPROV/  # Retrospectives, postmortems, process changes
└── 52-CLIENT-PORTAL/      # Future: web-facing client interface
```

---

## Critical Rule: No Client Data in This Repository

This repository contains **zero client data**.

Client data (evidence, scan results, reports, notes) lives exclusively in the
encrypted engagement store, documented in `00-PLATFORM/docs/client-data-architecture.md`.

What lives here:
- Methodology and playbooks
- Templates (no client content filled in)
- Scripts and automation
- Internal knowledge articles
- Configuration and tooling

What never lives here:
- Client names in file contents (use engagement IDs)
- Scan results or vulnerability data
- Screenshots, logs, or forensic artifacts
- Credentials of any kind

---

## Getting Started

New to rmsecurity operations? Start here:

1. Read `00-PLATFORM/docs/onboarding.md`
2. Run `00-PLATFORM/scripts/bootstrap.sh`
3. Read `01-STANDARDS/README.md`
4. Read `14-SERVICE-CATALOG/README.md`

---

## Versioning

This repository uses semantic versioning for major operational releases.
All changes must go through a pull request. Direct commits to `main` are blocked.

| Branch | Purpose |
|--------|---------|
| `main` | Production — current approved operating procedures |
| `dev` | Integration branch — tested before merge to main |
| `feature/*` | New domain, template, or tool development |
| `fix/*` | Corrections to existing operational content |
| `engagement/*` | Temporary branch for engagement-specific scripts (deleted after close) |

---

*rmsecurity — Operational since 2026*
