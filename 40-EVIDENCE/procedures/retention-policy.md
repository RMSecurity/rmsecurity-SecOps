# Evidence Retention and Destruction Policy
### rmsecurity | 40-EVIDENCE

---

## Retention Periods

| Evidence Type | Retention Period | Rationale |
|--------------|-----------------|-----------|
| Final reports (PDF) | 3 years | Client may need retest comparison |
| Technical evidence (pcaps, screenshots, outputs) | 1 year | Retest support window |
| Raw engagement data | 1 year | Dispute resolution window |
| Chain of custody manifests | 3 years | Audit and legal |
| Signed contracts and ROE | 7 years | Legal obligation |

All retention periods begin on the date of final report delivery.

---

## Storage Requirements

All evidence must remain in the encrypted VeraCrypt engagement store for
the full retention period. Evidence must never be:

- Copied to unencrypted drives or cloud storage
- Transmitted unencrypted (use password-protected zip or PGP if delivery required)
- Retained on assessment VMs after engagement close

---

## Destruction Procedure

At end of retention period:

1. Confirm retention period has elapsed (check delivery date in `engagement.json`)
2. Record destruction intent in `chain-of-custody/manifest.csv` — append row:
   `DESTRUCTION,[DATE],[Operator],all evidence for [ENG-ID] scheduled for destruction`
3. Use secure delete:
   ```bash
   find "$ENGAGEMENT_STORE/[ENG-ID]/" -type f -exec shred -u -z {} \;
   rm -rf "$ENGAGEMENT_STORE/[ENG-ID]/"
   ```
4. Record completion in manifest with SHA256 of the manifest itself
5. Archive the manifest to long-term storage before deleting the folder

---

## Client-Requested Early Destruction

If a client requests early destruction of their engagement data:

1. Confirm request is in writing from authorized contact
2. Notify client of what will be destroyed and what will be retained (contracts, manifests)
3. Perform destruction per procedure above
4. Send written confirmation to client within 5 business days

---

## Related

- `40-EVIDENCE/procedures/collection-procedure.md`
- `12-CLIENT-LIFECYCLE/offboarding/engagement-closure-checklist.md`
