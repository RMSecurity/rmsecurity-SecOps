# Engagement ID Standard
### rmsecurity | 01-STANDARDS

## Format

```
ENG-YYYY-NNN
```

| Segment | Description | Example |
|---------|------------|---------|
| `ENG` | Fixed prefix — identifies this as an rmsecurity engagement | `ENG` |
| `YYYY` | Four-digit year the engagement was opened | `2026` |
| `NNN` | Three-digit sequential number, zero-padded, resets each year | `001` |

Examples:
```
ENG-2026-001    ← first engagement opened in 2026
ENG-2026-012    ← twelfth engagement of 2026
ENG-2027-001    ← counter resets on January 1
```

## Engagement Folder Name

The engagement folder in the encrypted store combines the ID with a client alias and type:

```
[ENG-ID]_[CLIENT-ALIAS]_[ENGAGEMENT-TYPE]
```

| Segment | Rules | Example |
|---------|-------|---------|
| `ENG-ID` | Standard format above | `ENG-2026-001` |
| `CLIENT-ALIAS` | 2–10 chars, uppercase, no real company name in CCOS | `ACME` |
| `ENGAGEMENT-TYPE` | From the approved type list | `PENTEST-EXTERNAL` |

Full example:
```
ENG-2026-001_ACME_PENTEST-EXTERNAL
ENG-2026-002_BETA_SECURITY-ASSESSMENT
ENG-2026-003_GAMMA_INCIDENT-RESPONSE
```

## Approved Engagement Types

| Code | Full name |
|------|----------|
| `PENTEST-INTERNAL` | Internal Network Penetration Test |
| `PENTEST-EXTERNAL` | External Network Penetration Test |
| `PENTEST-WEB` | Web Application Penetration Test |
| `PENTEST-AD` | Active Directory Security Assessment |
| `PENTEST-RED` | Red Team Engagement |
| `ASSESSMENT-GAP` | Security Gap Assessment |
| `ASSESSMENT-CLOUD` | Cloud Security Assessment |
| `ASSESSMENT-M365` | Microsoft 365 Security Assessment |
| `VULN-MANAGEMENT` | Vulnerability Management Program |
| `INCIDENT-RESPONSE` | Incident Response |
| `FORENSICS` | Digital Forensics Investigation |
| `PHISHING` | Phishing Simulation |
| `COMPLIANCE` | Compliance Assessment |
| `TRAINING` | Security Training Delivery |

## Where the ID is Used

The engagement ID appears in:
- The engagement folder name (encrypted store)
- All evidence IDs (`EV-ENG-2026-001-NNN`)
- All finding IDs (`FND-ENG-2026-001-NNN`)
- All report filenames
- The `engagement.json` metadata file
- Git branch names (`engagement/ENG-2026-001`)
- Project tracker references

## Generation

The `new-engagement.py` script assigns IDs automatically.
Never assign an ID manually — duplicates break traceability.
