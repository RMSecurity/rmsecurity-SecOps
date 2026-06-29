# Client Data Architecture
### rmsecurity | 00-PLATFORM

## The Core Rule

**Zero client data lives in the CCOS repository.**

The CCOS repository is methodology, tooling, and institutional knowledge.
Client data — evidence, scan results, reports, notes, credentials found during testing —
lives exclusively in an encrypted engagement store on a separate volume.

This separation exists for three reasons:

1. **Legal protection.** Client data cannot accidentally appear in a git push or a diff.
2. **Confidentiality.** If the CCOS repo were ever compromised, no client data is exposed.
3. **Scalability.** The CCOS repo stays fast and clean as the company grows.

---

## Engagement Store Architecture

```
[Encrypted Volume]
└── rmsecurity-engagements/
    ├── ENG-2026-001_ACMECORP_PENTEST-EXTERNAL/
    │   ├── engagement.json           ← metadata (type, dates, operator)
    │   ├── README.md                 ← engagement overview
    │   ├── 00-admin/
    │   │   ├── contracts/            ← signed SOW, MSA, NDA
    │   │   ├── roe/                  ← signed Rules of Engagement
    │   │   └── comms/                ← email threads, meeting notes
    │   ├── 01-recon/
    │   │   ├── passive/              ← WHOIS, DNS, passive recon
    │   │   ├── active/               ← nmap, masscan output
    │   │   └── osint/                ← OSINT findings, screenshots
    │   ├── 02-assessment/
    │   │   ├── scans/                ← Nessus, OpenVAS, Burp exports
    │   │   ├── manual/               ← manual testing notes
    │   │   └── screenshots/          ← raw screenshots during testing
    │   ├── 03-exploitation/
    │   │   ├── payloads/             ← custom payloads used
    │   │   ├── shells/               ← shell session logs
    │   │   └── loot/                 ← hashes, credentials, data exfil proof
    │   ├── 04-evidence/
    │   │   ├── screenshots/          ← numbered evidence screenshots
    │   │   ├── logs/                 ← log extracts
    │   │   ├── artifacts/            ← files, configs, malware samples
    │   │   └── chain-of-custody/
    │   │       └── manifest.csv      ← hash + metadata for every artifact
    │   ├── 05-findings/              ← one markdown file per finding
    │   ├── 06-reports/
    │   │   ├── drafts/               ← working report drafts
    │   │   └── final/                ← delivered, signed-off reports
    │   ├── 07-remediation/
    │   │   ├── tracking/             ← remediation status per finding
    │   │   └── retests/              ← retest evidence and results
    │   └── 08-archive/               ← final encrypted ZIP after close
    └── ENG-2026-002_.../
```

---

## Encryption Options

### Option A — VeraCrypt (Recommended for solo / small team)

VeraCrypt creates an encrypted container file that mounts as a drive letter.

1. Download VeraCrypt from https://veracrypt.fr
2. Create a new volume → Standard VeraCrypt volume
3. Choose a file location (e.g., `D:\rmsec-engagements.vc`)
4. Use AES encryption + SHA-512 hash
5. Set a strong passphrase (20+ characters)
6. Mount as drive letter (e.g., `E:\`)
7. Set `ENGAGEMENT_STORE=E:\rmsecurity-engagements` in `.env`

Mount the volume before starting any engagement work.
Dismount when stepping away from the machine.

### Option B — BitLocker (Windows, simpler)

Encrypt the entire drive where engagements are stored.
Less granular than VeraCrypt but simpler to manage on Windows.

### Option C — OneDrive with Sensitivity Labels (Microsoft 365)

If the company has Microsoft 365 Business Premium or E3+:
- Create a Sensitivity Label: "rmsecurity — Confidential"
- Apply encryption and access restrictions
- Store the engagement folder in OneDrive with this label applied

This gives cloud backup + encryption but requires M365 licensing.

---

## Evidence Chain of Custody

Every piece of evidence collected during an engagement must be logged in
`04-evidence/chain-of-custody/manifest.csv` with the following fields:

```csv
evidence_id,filename,sha256,collected_at,collected_by,tool_used,notes
EV-ENG-2026-001-001,nmap-scan-192.168.1.0_24.xml,a3f4...,2026-07-01T14:32:00Z,operator-name,nmap 7.94,Initial port scan
```

The `evidence_id` format is: `EV-[ENGAGEMENT-ID]-[NNN]`

Calculate SHA-256 on Windows:
```powershell
Get-FileHash .\filename.ext -Algorithm SHA256
```

On Linux/macOS:
```bash
sha256sum filename.ext
```

---

## Engagement Lifecycle

1. `new-engagement.py` → creates the folder structure
2. Work happens inside the encrypted store
3. Reports are generated using templates from CCOS + data from the store
4. Final reports are saved to `06-reports/final/` and delivered to the client
5. After remediation close, the engagement is archived:
   - Compress the full folder to an encrypted ZIP
   - Move to `08-archive/`
   - Log the closure in `engagement.json`
   - Keep for minimum 5 years (adjust per legal requirements in your jurisdiction)

---

## Backup Strategy

The encrypted engagement store must be backed up to at least two locations:

| Tier | Location | Frequency |
|------|---------|---------|
| Primary | Local encrypted drive | Continuous (working copy) |
| Secondary | Encrypted external drive | Daily |
| Tertiary | Cloud (OneDrive/S3 encrypted) | Daily |

Test restore procedure quarterly.
