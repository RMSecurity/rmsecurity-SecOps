# Evidence ID Standard
### rmsecurity | 01-STANDARDS

## Format

```
EV-[ENG-ID]-NNN
```

| Segment | Description | Example |
|---------|------------|---------|
| `EV` | Fixed prefix — Evidence | `EV` |
| `ENG-ID` | The engagement this evidence belongs to | `ENG-2026-001` |
| `NNN` | Three-digit sequential number within the engagement | `001` |

Full example: `EV-ENG-2026-001-001`

## Evidence Filename Format

```
EV-[ENG-ID]-NNN_[short-description].[ext]
```

Examples:
```
EV-ENG-2026-001-001_nmap-scan-192.168.1.0-24.xml
EV-ENG-2026-001-002_smb-null-session-screenshot.png
EV-ENG-2026-001-003_domain-admin-hash-extraction.txt
EV-ENG-2026-001-004_bloodhound-ad-graph.png
EV-ENG-2026-001-005_memory-dump-dc01.raw
```

## Rules

- Numbers are sequential and never reused within an engagement
- Descriptions use `kebab-case`, max 40 characters
- Extension reflects the actual file type — never rename extensions
- Every evidence file must have a corresponding entry in `manifest.csv`

## Finding ID Format

Findings (vulnerabilities, misconfigurations, weaknesses) use a parallel format:

```
FND-[ENG-ID]-NNN
```

Examples:
```
FND-ENG-2026-001-001    ← first finding of the engagement
FND-ENG-2026-001-012    ← twelfth finding
```

The finding ID appears in:
- The finding markdown file (`05-findings/FND-ENG-2026-001-001_smb-signing-disabled.md`)
- The technical report (cross-reference)
- The remediation tracker
- The retest documentation

## Chain of Custody Manifest Entry

Every evidence file requires a row in `04-evidence/chain-of-custody/manifest.csv`:

```csv
evidence_id,filename,sha256,collected_at,collected_by,tool_used,notes
EV-ENG-2026-001-001,EV-ENG-2026-001-001_nmap-scan.xml,a3f4b2...,2026-07-01T14:32:00Z,Rodrigo Moses,nmap 7.94,Initial full port scan TCP
```

Calculate SHA-256 before moving or copying the file.
The hash in the manifest is the hash of the original file at time of collection.
