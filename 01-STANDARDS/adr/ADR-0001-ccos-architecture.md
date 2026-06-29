# ADR-0001 — CCOS Modular Domain Architecture

| Field | Value |
|-------|-------|
| Status | Accepted |
| Date | 2026-06-29 |
| Deciders | Rodrigo Moses |

## Context

rmsecurity needed an operational foundation before its first client engagement.
The options were: (a) build documents as needed, (b) buy an off-the-shelf platform,
or (c) design a structured, integrated operating system from the start.

Option (a) leads to inconsistency, duplication, and institutional knowledge loss
as the company grows. Every consultant reinvents the wheel.

Option (b) creates vendor dependency, limits customization, and rarely fits
the specific workflow of a boutique cybersecurity consultancy.

## Decision

Build the Cybersecurity Consulting Operating System (CCOS) as a Git repository
with 29 numbered operational domains organized into 6 layers.

Each domain has a defined purpose, inputs, outputs, and dependencies.
All domains are interconnected — outputs from one become inputs to another.
The repository is the single source of truth for all methodology, tooling,
templates, and institutional knowledge.

## Rationale

- Git is universally available, version-controlled, auditable, and free
- The domain model matches how a consulting company actually operates
- Numbered domains sort correctly in any file system
- The structure scales from 1 to 20+ consultants without architectural changes
- Everything lives in one place — no fragmentation across SharePoint, Notion, email, etc.
- CI/CD enforcement ensures the structure remains consistent as it grows

## Alternatives Considered

| Alternative | Why rejected |
|------------|-------------|
| Notion / Confluence wiki | No version control, no CI enforcement, vendor lock-in, poor for scripts/code |
| SharePoint | Microsoft dependency, poor developer experience, no automation integration |
| Ad-hoc document library | Does not scale, creates duplication, loses institutional knowledge |
| Commercial GRC platform | Expensive, opinionated, does not support technical delivery workflows |
| Single flat repository | No organization, impossible to navigate at scale |

## Consequences

### Positive
- Every process is repeatable and consistent
- Institutional knowledge is preserved as the company grows
- Automation can target specific domains without affecting others
- New consultants can onboard by reading the repo
- CI/CD enforces quality without manual oversight

### Negative / Trade-offs
- Initial investment to build the system before first engagement
- Requires git literacy from all future team members
- The structure must be maintained — domain READMEs become stale if neglected
- Overkill for a company that will stay at 1 person forever

## Related Decisions

- [ADR-0002](ADR-0002-client-data-separation.md) — Client data lives outside the CCOS repo
