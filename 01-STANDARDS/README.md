# 01-STANDARDS — Operational Standards & Policies
### rmsecurity | CCOS

## Purpose

This domain defines how everything in rmsecurity is done.
It is the constitutional layer of the CCOS — every other domain inherits
its naming conventions, document formats, classification schemes, and
operational policies from here.

If two people independently build something in different domains and it
looks, feels, and behaves the same way, it is because they both followed
what is written here.

## Responsibilities

| Responsibility | Location |
|--------------|------|
| How files and folders are named | `naming-conventions/` |
| How documents are structured | `document-standards/` |
| How architectural decisions are recorded | `adr/` |
| How the company behaves (policies) | `policies/` |
| Which frameworks the company maps to | `frameworks/` |

## Directory Structure

```
01-STANDARDS/
├── README.md
├── naming-conventions/
│   ├── files-and-folders.md
│   ├── engagement-ids.md
│   └── evidence-ids.md
├── document-standards/
│   ├── report-structure.md
│   ├── finding-format.md
│   ├── classification-labels.md
│   └── version-control.md
├── adr/
│   ├── README.md
│   ├── ADR-0001-ccos-architecture.md
│   └── ADR-0002-client-data-separation.md
├── policies/
│   ├── information-security-policy.md
│   ├── data-retention-policy.md
│   ├── acceptable-use-policy.md
│   └── incident-reporting-policy.md
└── frameworks/
    ├── mitre-attck.md
    ├── cvss-scoring.md
    └── risk-classification.md
```

## Inputs

- Industry standards (NIST, ISO 27001, CIS, OWASP)
- Client contractual requirements
- Lessons learned from past engagements

## Outputs

- Naming conventions consumed by all 29 CCOS domains
- Document templates consumed by `41-REPORTING` and `42-EXECUTIVE-REPORTING`
- ADRs explaining why the system works the way it does
- Policies governing how rmsecurity operates

## Related Domains

- `00-PLATFORM` — enforces structure via `validate-structure.py`
- `02-QUALITY` — enforces document standards at QA gates
- `41-REPORTING` — inherits report structure from `document-standards/`
- All domains — inherit naming conventions

## Update Process

Standards change rarely. When a standard must change:

1. Open a GitHub Issue with the "Process improvement" template
2. Draft the change in a `feature/` branch
3. PR must include an ADR explaining why the standard changed
4. Merge to `main` only after explicit review
