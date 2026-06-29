# Branching Strategy
### rmsecurity | 00-PLATFORM

## Model: Trunk-Based Development with Protected Main

CCOS uses a simplified trunk-based model. The `main` branch is always
production-ready. Everything else is a short-lived branch that merges quickly.

---

## Branch Types

| Branch | Pattern | Purpose | Lifetime |
|--------|---------|---------|---------|
| `main` | — | Current approved operating system | Permanent |
| `dev` | — | Integration — tested before main | Permanent |
| `feature/*` | `feature/add-ad-playbook` | New content or capability | Days to 2 weeks |
| `fix/*` | `fix/roe-template-typo` | Correction to existing content | Hours to days |
| `engagement/*` | `engagement/ENG-2026-001` | Engagement-specific scripts | Duration of engagement, then deleted |
| `release/*` | `release/v1.1` | Preparation for a versioned release | Days |

---

## Rules

### Main branch
- Direct commits are **blocked** — all changes must come through a PR
- Every PR requires passing CI (secret scan + structure validator + markdown lint)
- As a solo operator: self-review is acceptable, but take a deliberate pause before merging

### Dev branch
- Receives feature and fix branches via PR
- CI must pass before merging to main
- Rebase onto main regularly to avoid drift

### Engagement branches
- Used when you need to develop or test scripts specific to one engagement
- **Must not contain any client data** — only the scripts, not the output
- Delete after the engagement closes

---

## Commit Message Convention

Format: `[domain] short description in imperative mood`

```
[platform] add VeraCrypt setup instructions to onboarding
[pentest] add BloodHound AD enumeration playbook
[reporting] fix page numbering in executive report template
[knowledge] document pass-the-hash detection technique
[standard] clarify evidence numbering convention
```

Keep the first line under 72 characters. Use the body for why, not what.

---

## Versioning

CCOS uses semantic versioning for major operational releases:

- **MAJOR** (v2.0) — breaking change to a core operational process
- **MINOR** (v1.1) — new domain, significant new capability
- **PATCH** (v1.0.1) — corrections, small additions

Tag releases on `main`:
```bash
git tag -a v1.0.0 -m "CCOS v1.0.0 — Initial operational release"
git push origin v1.0.0
```
