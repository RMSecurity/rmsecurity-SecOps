# 52-CLIENT-PORTAL — Client-Facing Deliverables Portal
### rmsecurity | CCOS Layer 5: Continuous Improvement

Everything that touches the client externally — how reports are packaged,
delivered, and followed up on.

---

## What Lives Here

```
52-CLIENT-PORTAL/
├── delivery/
│   ├── delivery-procedure.md   # How to package and deliver final reports
│   └── report-naming.md        # File naming convention for delivery
├── templates/
│   ├── delivery-email.md       # Email template for report delivery
│   ├── retest-email.md         # Email template for retest scheduling
│   └── nps-survey.md           # Post-engagement NPS survey (5 questions)
└── README.md
```

---

## Delivery Standards

Every report delivery must include:

1. **Technical Report** (PDF, password-protected)
2. **Executive Summary** (PDF or Word, separate from technical report)
3. **Remediation Tracker** (Excel, client-editable)
4. **Evidence Archive** (ZIP, SHA-256 manifest included)

Password protection: unique 20+ character random password per delivery.
Communicate the password via a separate channel (phone call or encrypted
message — never in the same email as the report).

---

## Delivery Channel Options

| Channel | Use When |
|---------|---------|
| Encrypted email (S/MIME or PGP) | Client has capability |
| Password-protected ZIP via SFTP | Standard default |
| Secure file share (SharePoint/OneDrive with expiry) | Client request |
| Physical encrypted USB | Highly sensitive engagements |

**Never send unencrypted reports via email.**
