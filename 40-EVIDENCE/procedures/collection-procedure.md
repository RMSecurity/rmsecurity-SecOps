# Evidence Collection Procedure
### rmsecurity | 40-EVIDENCE

*Every piece of evidence collected during an rmsecurity engagement must follow
this procedure. Non-compliant evidence will be excluded from reporting.*

---

## 1. Before You Start

- Confirm the engagement folder exists and the `chain-of-custody/manifest.csv`
  has been initialized (done by `new-engagement.py`).
- Know your Evidence ID counter — check the last `EV-[ENG-ID]-NNN` in the manifest.
- Your collection machine must be the pre-configured, isolated assessment VM.

---

## 2. Evidence ID Format

```
EV-[ENG-ID]-[NNN]

Example: EV-ENG-2026-001-012
```

Increment sequentially per engagement. Never reuse or skip numbers.

---

## 3. Collection Steps

### 3.1 Capture the evidence

Use the most artifact-preserving method available:

| Evidence Type | Preferred Tool | Notes |
|--------------|----------------|-------|
| Screenshot | Flameshot / Greenshot | Lossless PNG; include timestamp and hostname in frame |
| Network capture | Wireshark / tcpdump | Save as `.pcapng`; filter to relevant traffic only |
| Command output | Script / tmux logging | Pipe to file; do not copy-paste — copy loses escape codes |
| HTTP request/response | Burp Suite export | Export as native Burp XML or raw HTTP |
| File extracted from target | scp / netcat | Do not open on analysis machine before hashing |
| Log excerpt | cat > file | Include full log line with timestamps |
| Video / screen recording | OBS | MP4 H.264; use sparingly for multi-step exploits |

### 3.2 Name the file

```
[EV-ID]_[short-description].[ext]

Examples:
  EV-ENG-2026-001-001_admin-panel-unauthenticated.png
  EV-ENG-2026-001-002_sqlmap-dump-users-table.txt
  EV-ENG-2026-001-003_smb-capture-netntlmv2-hash.pcapng
```

- Lowercase only
- Hyphens between words, no underscores except between EV-ID and description
- Max 80 characters

### 3.3 Hash immediately

```bash
sha256sum "EV-ENG-2026-001-001_admin-panel-unauthenticated.png"
```

**Hash the file before moving it.** If the hash is taken after moving, it proves
nothing about the original state.

### 3.4 Record in manifest

Append a row to `chain-of-custody/manifest.csv`:

```
EV-ENG-2026-001-001,2026-06-29 14:32:00 UTC,[Operator Name],screenshot,admin-panel-unauthenticated.png,a3f9...sha256...,FND-ENG-2026-001-003
```

Fields: `evidence_id, timestamp_utc, collector, type, filename, sha256, linked_finding_id`

### 3.5 Move to evidence store

```bash
mv "EV-ENG-2026-001-001_*.png" \
  "$ENGAGEMENT_STORE/ENG-2026-001/04-evidence/"
```

Never leave evidence files on the assessment VM after the engagement is complete.

---

## 4. Annotation

- Never annotate an original file
- Make a copy: `EV-ENG-2026-001-001_admin-panel-unauthenticated_annotated.png`
- The annotated copy does **not** get a separate EV-ID — it references the original
- Document in the manifest that an annotated copy exists

---

## 5. Chain of Custody Verification

Before report writing (Gate 2), verify:

```bash
sha256sum -c <(awk -F',' 'NR>1 {print $6 "  " $5}' manifest.csv)
```

All hashes must match. Any mismatch is a critical integrity failure — stop,
investigate, and document the discrepancy before proceeding.

---

## 6. Evidence Reference in Reports

In the technical report, reference evidence as:

> *[Screenshot — EV-ENG-2026-001-001: unauthenticated access to /admin panel
> showing full database management interface]*

Never embed raw evidence paths from the encrypted store in any report.

---

## Related

- `40-EVIDENCE/templates/manifest-template.csv` — blank manifest
- `02-QUALITY/checklists/checklist-evidence.md` — evidence QA checklist
- `01-STANDARDS/naming-conventions/evidence-ids.md` — naming rules
