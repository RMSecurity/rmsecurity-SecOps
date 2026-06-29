# Document Classification Labels
### rmsecurity | 01-STANDARDS

## Classification Scheme

Every document produced by rmsecurity must carry a classification label.
The label appears in the footer of every page and on the cover page.

| Label | Meaning | Who can receive it |
|-------|---------|-------------------|
| `CONFIDENTIAL` | Contains client-specific data | Client contacts named in the engagement ROE only |
| `RESTRICTED` | Internal rmsecurity only | rmsecurity personnel only |
| `INTERNAL` | General internal use | rmsecurity personnel, may share with trusted partners under NDA |
| `PUBLIC` | No restrictions | Anyone |

---

## Usage by Document Type

| Document | Default Classification |
|---------|----------------------|
| Technical report | CONFIDENTIAL |
| Executive summary | CONFIDENTIAL |
| Rules of Engagement | CONFIDENTIAL |
| Proposal / quote | RESTRICTED |
| Internal playbooks | RESTRICTED |
| Policies | INTERNAL |
| Knowledge base articles | INTERNAL |
| Blog posts / case studies | PUBLIC |
| Templates (blank) | INTERNAL |

---

## Footer Format

Every page footer must contain:

```
rmsecurity | CONFIDENTIAL | ENG-YYYY-NNN | Page N of N
```

For RESTRICTED and INTERNAL documents:

```
rmsecurity | RESTRICTED — Internal Use Only | Page N of N
```

---

## Handling Rules by Classification

### CONFIDENTIAL
- Transmitted only via encrypted channel (encrypted email, secure file share)
- Never sent as an unencrypted email attachment
- Never stored outside the encrypted engagement store
- Password-protected PDF before transmission
- Deleted from email after client confirms receipt

### RESTRICTED
- Stored only in the CCOS repo (private) or encrypted store
- Not transmitted externally without explicit approval
- Never posted to public or shared systems

### INTERNAL
- Stored in the CCOS repo
- May be shared with contractors under NDA
- Not published publicly

### PUBLIC
- May appear on the rmsecurity website, blog, or LinkedIn
- Must be reviewed before publication
- Must not contain any client data, even anonymized, without explicit client consent

---

## Draft Watermark

All draft documents carry an additional watermark across every page:

```
DRAFT — NOT FOR DISTRIBUTION
```

This watermark is removed only when the document reaches `v1.0` and has passed
the QA gate in `02-QUALITY`.
