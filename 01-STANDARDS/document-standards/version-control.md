# Document Version Control
### rmsecurity | 01-STANDARDS

## Rule

Every deliverable document has a version number. The version number appears
in the filename and in the document control table on page 1.

---

## Version Numbering Scheme

```
vMAJOR.MINOR
```

| Part | When it increments | Example |
|------|--------------------|---------|
| MAJOR | New delivery to client, post-retest report, major scope change | v1.0 → v2.0 |
| MINOR | Revision after client feedback, correction, clarification | v1.0 → v1.1 |

Draft versions use `v0.x`:

| Version | Stage |
|---------|-------|
| `v0.1` | First internal draft |
| `v0.2` | After internal review / QA |
| `v0.3+` | Additional draft iterations |
| `v1.0` | First delivery to client |
| `v1.1` | Client-requested revision |
| `v2.0` | Post-remediation retest report |

---

## Version History Table

Every document includes a version history table on the document control page:

| Version | Date | Author | Reviewer | Changes |
|---------|------|--------|---------|---------|
| v0.1 | 2026-07-10 | R. Moses | — | Initial draft |
| v0.2 | 2026-07-12 | R. Moses | — | QA review corrections |
| v1.0 | 2026-07-15 | R. Moses | R. Moses | Final — delivered to client |
| v1.1 | 2026-07-22 | R. Moses | — | Client feedback — clarified Finding 003 |

---

## File Versioning in the Engagement Store

The filename always reflects the current version:

```
ENG-2026-001_ACME_Pentest-Technical-Report_2026-07-15_v1.0.pdf
ENG-2026-001_ACME_Pentest-Technical-Report_2026-07-22_v1.1.pdf
ENG-2026-001_ACME_Pentest-Technical-Report_2026-09-01_v2.0.pdf
```

Old versions are kept in `06-reports/drafts/` — never deleted.
Only the current version lives in `06-reports/final/`.

---

## What Triggers a New Version

| Event | Version change |
|-------|--------------|
| Internal correction before delivery | No version change — edit the file |
| First delivery to client | `v0.x` → `v1.0` |
| Client requests clarification or correction | `v1.0` → `v1.1` |
| Retest completed with new findings closed | `v1.x` → `v2.0` |
| Scope changed mid-engagement | `v1.x` → `v2.0` with note |
| Finding status updated (closed) in tracker | Tracker update only — not a new report version unless re-delivered |
