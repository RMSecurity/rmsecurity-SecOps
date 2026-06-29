# Gate 4 — Pre-Delivery Quality Gate
### rmsecurity | 02-QUALITY

## Purpose

The final check before the report leaves rmsecurity's hands.
Gate 3 validated the content. Gate 4 validates the delivery package —
the right files, the right format, encrypted correctly, addressed to the
right people, with the right accompanying materials.

A perfect report delivered to the wrong person, unencrypted, or missing
the remediation tracker is a delivery failure.

---

## Gate 4 Checklist

### Report Files

- [ ] Technical report exported to PDF (not only DOCX)
- [ ] Executive summary exported to PDF
- [ ] PDF is password-protected (password communicated separately from the file)
- [ ] PDF password is a minimum of 16 characters
- [ ] DOCX version retained in `06-reports/final/` (for client edits on request)
- [ ] Filenames follow the naming standard: `ENG-YYYY-NNN_[ALIAS]_[TYPE]_[DATE]_v[VERSION].pdf`
- [ ] Version number on the file matches the version in the document
- [ ] Both PDF and DOCX are stored in `06-reports/final/`

### Accompanying Materials

- [ ] Remediation tracker prepared (`07-remediation/tracking/`) — client-facing version
- [ ] Evidence index included or referenced (list of EV- IDs)
- [ ] Engagement debrief presentation prepared (if agreed in SOW)
- [ ] Retest proposal included (if applicable)

### Delivery Package Verification

- [ ] Delivery package contains: technical report PDF, executive summary PDF, remediation tracker
- [ ] No draft files included in delivery package
- [ ] No internal notes or working files included
- [ ] No evidence files included (unless specifically requested and in scope of SOW)
- [ ] Report version matches what was reviewed in Gate 3 (no changes after Gate 3)
- [ ] SHA-256 of each delivered PDF calculated and noted (for integrity verification)

### Recipient Verification

- [ ] Recipient names and email addresses verified against the ROE distribution list
- [ ] No report sent to anyone not named in the ROE
- [ ] Delivery method verified: encrypted email, secure file share, or client portal
- [ ] PDF password delivery method confirmed (separate channel from the file — not same email)
- [ ] Client acknowledged they are ready to receive the report

### Communication

- [ ] Delivery email drafted using the template in `12-CLIENT-LIFECYCLE/templates/`
- [ ] Email body does not contain any finding details (report is the deliverable)
- [ ] Debrief meeting scheduled (if in SOW)
- [ ] Client contact confirmed for the debrief

---

## Gate 4 Sign-Off Record

Save in `06-reports/` of the engagement folder as `gate-4-signoff.md`:

```
Engagement ID:
Report version delivered:
Delivery date:
Delivered by:
Recipient(s):
Delivery method:
PDF password communicated via:
SHA-256 (Technical Report PDF):
SHA-256 (Executive Summary PDF):
Gate 4 result: PASS / DELIVERED
Notes:
```

---

## After Delivery

After Gate 4 and delivery are complete:

1. Log delivery in the engagement metadata (`engagement.json`: `status: delivered`)
2. Start the remediation tracking phase (`07-remediation/`)
3. Schedule the debrief meeting if not already done
4. Schedule the retest (agree on timeline with client)
5. Begin knowledge capture — add anything learned to `32-KNOWLEDGE-BASE/`
