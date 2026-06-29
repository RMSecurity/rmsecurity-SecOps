# Report Delivery Procedure
### rmsecurity | 52-CLIENT-PORTAL

*Follow this procedure for every final report delivery.*

---

## Step 1 — Assemble Deliverable Package

Create a delivery folder at `06-DELIVERY/` inside the engagement directory:

```
ENG-YYYY-NNN-ClientName/
└── 06-DELIVERY/
    ├── [EngID]-Technical-Report-v1.0.pdf
    ├── [EngID]-Executive-Summary-v1.0.pdf
    ├── [EngID]-Remediation-Tracker-v1.0.xlsx
    └── [EngID]-Evidence-Archive.zip        (optional — if client requested)
```

**Naming convention:** `[EngID]-[DocumentType]-v[Version].[ext]`

---

## Step 2 — Quality Check Before Delivery

- [ ] Technical report: all findings have ID, severity, CVSS, description, evidence reference, and remediation
- [ ] Executive summary: risk gauge, finding counts, top 3 recommendations
- [ ] Remediation tracker: all findings imported, due dates populated
- [ ] No internal notes, draft watermarks, or placeholder text remaining
- [ ] Client name spelled correctly throughout
- [ ] Dates are correct (testing dates, report date)
- [ ] All evidence references (EV-IDs) exist in the manifest

---

## Step 3 — Encrypt the Package

```powershell
# Generate a strong random delivery password
$Password = -join ((48..57) + (65..90) + (97..122) + (33..47) | Get-Random -Count 24 | % {[char]$_})
Write-Host "DELIVERY PASSWORD (store in password manager BEFORE sending): $Password"

# Create encrypted ZIP (requires 7-Zip)
& "C:\Program Files\7-Zip\7z.exe" a -p"$Password" -mhe=on `
  "06-DELIVERY\$EngID-Delivery.7z" "06-DELIVERY\*.pdf" "06-DELIVERY\*.xlsx"
```

**Store the password in the password manager under the client entry BEFORE sending the files.**

---

## Step 4 — Send the Files

Send the encrypted archive via the agreed delivery channel.
In a separate communication (phone call preferred, or encrypted message):
- Provide the decryption password
- Confirm the SHA-256 hash of the archive so the client can verify integrity:

```powershell
Get-FileHash "06-DELIVERY\$EngID-Delivery.7z" -Algorithm SHA256
```

---

## Step 5 — Delivery Email

Use the template at `52-CLIENT-PORTAL/templates/delivery-email.md`.

Key elements:
- Reference the engagement name and testing dates
- List the deliverables included
- Provide decryption instructions (password sent separately)
- Provide your contact information for questions
- Include retest offer and timeline (60-day window)

---

## Step 6 — Mark Gate 4 Complete

After the client acknowledges receipt:

1. Update the engagement README: check off `[x] Gate 4`
2. Run `gate-check.ps1 -EngID [ID] -Gate 4`
3. Run `close-engagement.ps1 -EngID [ID]`
4. Move engagement to completed status in `11-BUSINESS-DEV/crm/pipeline-tracker.md`
