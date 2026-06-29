# Incident Response — Containment & Recovery Playbook
### rmsecurity | 26-INCIDENT-RESPONSE

*Run after initial triage scope is established.
Containment must not destroy evidence — preserve before containing.*

---

## Containment Strategy

Choose based on incident type and business impact:

| Strategy | When to Use | Risk |
|---------|------------|------|
| Full isolation | Ransomware, active exfiltration, unknown scope | Business disruption |
| Network segmentation | Contained to a segment | Partial disruption |
| Host-level containment | Single infected host, contained | Minimal |
| Monitor and observe | Threat actor still present — intelligence value | Ongoing risk |

---

## Phase 1 — Containment

### Ransomware

```bash
# IMMEDIATE: Isolate infected hosts from network
# Do NOT power off — memory evidence is lost
# Preserve power, disconnect network cable / disable NIC

# Windows — disable NIC (if remote access needed first)
Disable-NetAdapter -Name "Ethernet" -Confirm:$false

# Block C2 at firewall (use IoCs from triage)
# Add deny rules for C2 IPs identified in triage

# Identify spread: which other hosts encrypted?
# Look for: .locked, .encrypted, ransom note files
Get-ChildItem -Path C:\ -Recurse -Filter "*HELP*" -ErrorAction SilentlyContinue
Get-ChildItem -Path C:\ -Recurse -Filter "*DECRYPT*" -ErrorAction SilentlyContinue

# Check backup integrity BEFORE notifying ransomware actors
# Backup + no C2 persistence = rebuild, do not pay
```

### Compromised Credentials

```bash
# Immediately reset compromised accounts
# Windows AD:
Set-ADAccountPassword -Identity [username] -Reset -NewPassword (ConvertTo-SecureString -String "TempP@ss$(date +%Y%m%d)" -AsPlainText -Force)
Disable-ADAccount -Identity [username]

# Force logout all sessions
# Windows: 
query session /server:[DC]
logoff [session_id] /server:[DC]

# Revoke all auth tokens (Entra ID / M365):
# Azure Portal → Users → [user] → Revoke sessions

# If service account compromised:
# Rotate service account password immediately
# Check where service account is used (SPNs, scheduled tasks, services)

# Check for new accounts created by attacker
Get-ADUser -Filter {WhenCreated -gt (Get-Date).AddDays(-7)} | \
  Select-Object Name, WhenCreated, Enabled
```

### Malware / RAT

```bash
# Identify and kill malicious process
# Windows:
Get-Process | Where-Object {$_.Path -like "*AppData*" -or $_.Path -like "*Temp*"} | \
  Select-Object Name, Id, Path

# Kill process
Stop-Process -Id [PID] -Force

# Remove persistence
# Scheduled task:
Unregister-ScheduledTask -TaskName "[task_name]" -Confirm:$false

# Registry autorun:
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" `
  -Name "[malware_key]"

# Service:
Stop-Service -Name "[malware_service]" -Force
sc.exe delete "[malware_service]"

# Remove malware files
Remove-Item -Path "[malware_path]" -Force
# Hash before removing: sha256sum [file]

# Linux:
kill -9 [PID]
systemctl disable --now [malware_service]
rm -rf [malware_path]
crontab -r   # WARNING: removes all crons — confirm first
```

---

## Phase 2 — Eradication

```bash
# Only after ALL affected systems are identified and contained

# 1. Rebuild affected systems (preferred over cleaning)
# Cleaning malware from a live system is unreliable
# Rebuild from known-good image or baseline

# 2. If rebuild not possible — thorough cleaning:
# - Remove all persistence mechanisms
# - Remove malware files
# - Restore modified system files from backup
# - Run multiple AV/EDR scans

# 3. Search all systems for IoCs
# File hash search (Windows):
Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | \
  Get-FileHash | Where-Object {$_.Hash -eq "[MALWARE_HASH]"}

# File hash search (Linux):
find / -type f -exec sha256sum {} \; 2>/dev/null | grep "[MALWARE_HASH]"

# Registry search for malware keys:
reg query HKLM /f "[malware_string]" /s

# 4. Check all privileged accounts for unauthorized changes
# Compare current domain admins to baseline
Get-ADGroupMember "Domain Admins" | Select-Object Name, SamAccountName

# 5. Reset ALL credentials that could have been exposed
# - All domain admin passwords
# - KRBTGT (if AD compromise — rotate twice)
# - Service account passwords
# - Application secrets / API keys
```

---

## Phase 3 — Recovery

```bash
# 1. Restore from backup (verify backup integrity first)
# Test restore to isolated environment before production

# 2. Apply missing patches that enabled the initial compromise
# Identify the initial attack vector and patch it before restoring

# 3. Restore systems in order of criticality
# Business-critical systems first

# 4. Monitor closely during recovery
# Increase logging verbosity on restored systems
# Keep EDR in high-alert mode for 30 days post-incident

# 5. Verify data integrity
# Compare critical file hashes to pre-incident baseline (if available)
```

---

## Phase 4 — Post-Incident Review

Run within 1–2 weeks of incident closure.

```markdown
# Post-Incident Review — [ENG-ID]

## Incident Summary
- Type: [ransomware / credential theft / data breach / etc.]
- Duration: [first IoC to containment]
- Systems affected: [count and list]
- Data impacted: [PII / financial / IP / none confirmed]
- Business impact: [downtime hours, estimated cost]

## Root Cause
[How did the attacker get in? Initial access vector]

## Attack Timeline
[From triage — key events with timestamps]

## What Worked Well
[Detection, response, communication]

## Gaps Identified
[What would have helped: EDR, backups, MFA, patching, etc.]

## Immediate Recommendations (short-term)
1.
2.
3.

## Strategic Recommendations (long-term)
1.
2.
3.
```

---

## KRBTGT Reset Procedure (After AD Compromise)

```powershell
# Step 1: First reset
$krbtgt = Get-ADUser "krbtgt" -Properties PasswordLastSet
$newPass = ConvertTo-SecureString -String ([System.Web.Security.Membership]::GeneratePassword(64,10)) -AsPlainText -Force
Set-ADAccountPassword -Identity "krbtgt" -NewPassword $newPass -Reset

# Wait minimum 10 hours (max Kerberos ticket lifetime)
# Step 2: Second reset (invalidates any golden tickets from first password)
Set-ADAccountPassword -Identity "krbtgt" -NewPassword $newPass -Reset

# Force replication across all DCs
repadmin /syncall /AdeP
```
