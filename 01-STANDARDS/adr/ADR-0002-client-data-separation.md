# ADR-0002 — Client Data Lives Outside the CCOS Repository

| Field | Value |
|-------|-------|
| Status | Accepted |
| Date | 2026-06-29 |
| Deciders | Rodrigo Moses |

## Context

During CCOS design, a decision was needed on where engagement data lives:
inside the CCOS repository, or in a separate encrypted store.

Engagement data includes: evidence screenshots, scan results, client credentials
found during testing, forensic artifacts, network captures, and draft reports.

## Decision

Zero client data lives in the CCOS repository, ever.

Client data lives exclusively in an encrypted engagement store (VeraCrypt volume
or equivalent) on a separate physical location from the CCOS repo.

The CCOS repo contains only: methodology, templates (unfilled), scripts,
playbooks, and institutional knowledge. It never contains client names
in file contents, scan output, evidence, or delivered reports.

## Rationale

**Legal protection:** A git repository has a persistent history. A secret or
client credential accidentally committed is theoretically retrievable forever,
even after deletion. The blast radius of a CCOS repo compromise must be zero
for client data.

**Confidentiality:** If the GitHub repository were ever misconfigured as public,
or if a GitHub account were compromised, no client data would be exposed.

**Scalability:** The CCOS repo stays fast, lean, and useful as the number of
engagements grows. A repo containing gigabytes of scan output becomes unusable.

**Compliance:** Data protection regulations (GDPR and equivalents) require
client data to be handled with appropriate controls. Separation simplifies
the compliance story.

## Alternatives Considered

| Alternative | Why rejected |
|------------|-------------|
| Store client data in private repo subdirectory | Git history makes deletion unreliable; repo grows unmanageably |
| Store client data in git-ignored folders inside the repo | Developer error risk; git-ignored files can be accidentally staged |
| Use git-crypt for encrypted files in repo | Adds complexity, key management risk, still in git history after decryption |
| Store everything in OneDrive/SharePoint | No encryption-at-rest guarantee, no chain of custody, no forensic integrity |

## Consequences

### Positive
- CCOS repo compromise has zero client data exposure
- Engagement store has its own encryption, backup, and retention policy
- Chain of custody is clean — evidence never passes through git
- Repo performance is unaffected by engagement volume

### Negative / Trade-offs
- Requires an encrypted volume to be mounted before engagement work begins
- Slightly more friction in workflow (two locations instead of one)
- Encrypted store must be backed up separately

## Implementation

- Engagement store path is configured via `ENGAGEMENT_STORE` in `.env`
- `new-engagement.py` creates folders in the encrypted store, not in the repo
- `00-PLATFORM/docs/client-data-architecture.md` documents the full architecture
- `.gitignore` blocks common evidence file types as a safety net

## Related Decisions

- [ADR-0001](ADR-0001-ccos-architecture.md) — CCOS modular domain architecture
