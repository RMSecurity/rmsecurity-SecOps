# Evidence Quality Checklist
### rmsecurity | 02-QUALITY

## Purpose

Evidence is the foundation of every finding. Bad evidence means
unverifiable findings. Unverifiable findings undermine the entire report.
This checklist is applied to every piece of evidence before it is referenced
in a finding.

---

## Evidence Collection Standards

### At Time of Collection

- [ ] Screenshot taken immediately — not reconstructed from memory later
- [ ] Screenshot shows the full context: URL/hostname, timestamp, tool output, impact
- [ ] Timestamp visible in the screenshot (OS clock, terminal, browser URL bar)
- [ ] Evidence file named using the standard: `EV-ENG-YYYY-NNN-NNN_description.ext`
- [ ] SHA-256 calculated immediately after collection
- [ ] Hash logged in `manifest.csv` before moving or copying the file

### Screenshot Quality

- [ ] Resolution is sufficient to read all text without zooming to blur
- [ ] No sensitive personal information of rmsecurity team visible (own credentials, personal data)
- [ ] Terminal shows the full command and full output — not cropped
- [ ] Browser screenshots include the URL bar
- [ ] If showing a vulnerability: the "before" state is documented, not just the "after"
- [ ] If showing credentials or sensitive data: redact anything not needed to prove the point

### Tool Output

- [ ] Raw tool output saved (XML, JSON, or text) in addition to screenshots
- [ ] Tool version noted in the manifest (e.g., `nmap 7.94`)
- [ ] Command used noted in the manifest (for reproducibility)
- [ ] Output saved at the time of the test, not re-run later

### For Critical and High Findings

- [ ] Minimum two pieces of evidence from different perspectives
- [ ] If exploiting a vulnerability: screenshot of exploitation AND screenshot of impact
- [ ] For credential findings: hash or partial credential (never store full plaintext passwords in evidence)
- [ ] For data exfiltration proof: show the data type and volume, not the data itself

---

## Evidence Integrity Rules

- Never modify, crop, or annotate the original evidence file
- Annotations (arrows, highlights) go in a separate annotated copy: `EV-...-001_annotated.png`
- The original file must be preserved unmodified with its original hash
- Never rename an evidence file after it has been hashed
- Never move an evidence file out of the `04-evidence/` folder

---

## Evidence Reference in Findings

When referencing evidence in a finding:

```markdown
## Evidence

| ID | Description |
|----|------------|
| EV-ENG-2026-001-003 | Nmap output showing port 445 open with SMB signing disabled |
| EV-ENG-2026-001-004 | Screenshot of successful null session via smbclient |
```

The description must explain what the evidence shows, not just name the file.
A reader should understand what the evidence proves without having to look at it.
