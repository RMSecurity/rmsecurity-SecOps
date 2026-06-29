# File and Folder Naming Conventions
### rmsecurity | 01-STANDARDS

## Core Rule

Every name must be readable, sortable, and unambiguous without context.
A file found months later, outside its original folder, must still be identifiable.

---

## General Rules

| Rule | Correct | Wrong |
|------|---------|-------|
| Use `kebab-case` for all files and folders | `pentest-methodology.md` | `PentestMethodology.md` |
| Use lowercase always | `ad-attack-playbook.md` | `AD-Attack-Playbook.md` |
| No spaces — ever | `client-onboarding.md` | `client onboarding.md` |
| No special characters except `-` and `_` | `nmap-scan-results.xml` | `nmap scan (results).xml` |
| Use `_` only for separating semantic segments | `ENG-2026-001_ACME_pentest` | `eng-2026-001-acme-pentest` |
| Dates in filenames: `YYYY-MM-DD` | `report-2026-07-15.docx` | `report-15-07-26.docx` |
| Version numbers: `v1`, `v2`, `v1.1` | `template-v2.docx` | `template-new-final.docx` |
| No words like `final`, `new`, `v2-final` | — | `report-FINAL-v3-new.docx` |

---

## Domain Directories (CCOS)

Format: `NN-DOMAIN-NAME` where `NN` is a two-digit number.

```
00-PLATFORM
01-STANDARDS
22-PENTESTING
```

The number controls sort order. Numbers 00–09 are foundation. 10–19 are business.
20–29 are technical delivery. 30–39 are intelligence. 40–49 are reporting. 50–59 are metrics.

---

## Subdirectory Naming

Subdirectories within a domain use `kebab-case` without numbering unless order matters.

```
22-PENTESTING/
├── playbooks/
├── checklists/
├── tools/
└── templates/
```

Use numbered subdirectories only when sequence is operationally meaningful:

```
26-INCIDENT-RESPONSE/
├── 01-triage/
├── 02-containment/
├── 03-eradication/
├── 04-recovery/
└── 05-post-incident/
```

---

## Document Files

| Document type | Convention | Example |
|-------------|-----------|---------|
| Playbook | `playbook-[topic].md` | `playbook-ad-enumeration.md` |
| Runbook | `runbook-[topic].md` | `runbook-ir-initial-triage.md` |
| Checklist | `checklist-[topic].md` | `checklist-pentest-pre-engagement.md` |
| Template | `template-[topic].[ext]` | `template-technical-report.docx` |
| Policy | `policy-[name].md` | `policy-information-security.md` |
| Procedure | `procedure-[name].md` | `procedure-evidence-collection.md` |
| ADR | `ADR-NNNN-[slug].md` | `ADR-0003-cvss-scoring-model.md` |
| Cheat sheet | `cheatsheet-[topic].md` | `cheatsheet-nmap-flags.md` |
| Knowledge article | `kb-[topic].md` | `kb-pass-the-hash-detection.md` |

---

## Script Files

| Language | Convention | Example |
|---------|-----------|---------|
| Python | `kebab-case.py` | `new-engagement.py` |
| PowerShell | `Verb-Noun.ps1` (PS convention) | `New-Engagement.ps1` |
| Bash | `kebab-case.sh` | `bootstrap.sh` |
| YAML (workflow) | `action-name.yml` | `validate.yml` |

---

## Report Files (in engagement store)

Reports in the encrypted engagement store follow a stricter format
to ensure they sort correctly and are unambiguous:

```
[ENG-ID]_[CLIENT-ALIAS]_[REPORT-TYPE]_[YYYY-MM-DD]_[VERSION].[ext]
```

Examples:
```
ENG-2026-001_ACME_Pentest-Technical-Report_2026-07-15_v1.0.pdf
ENG-2026-001_ACME_Executive-Summary_2026-07-15_v1.0.pdf
ENG-2026-001_ACME_Pentest-Technical-Report_2026-07-20_v2.0-remediated.pdf
```

---

## What Never Goes in a Filename

- Client real names in CCOS repo files (use engagement ID or alias)
- Dates without `YYYY-MM-DD` format
- Words: `final`, `new`, `updated`, `copy`, `backup`, `temp`, `old`
- Reviewer initials or author names
- Version numbers without `v` prefix (`2` not `v2`)
