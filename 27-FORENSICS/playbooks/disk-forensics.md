# Disk Forensics Playbook
### rmsecurity | 27-FORENSICS

*Acquire first, analyze second. Never analyze original media.*

---

## Phase 1 — Evidence Acquisition

```bash
# Verify evidence drive is forensically wiped before use
sudo shred -v -n 1 /dev/sdb   # target drive for image

# Acquire disk image with hash verification
sudo dcfldd if=/dev/sda \
  of=/mnt/evidence/case_$(date +%Y%m%d)_disk.dd \
  bs=512 \
  hash=sha256 \
  hashlog=/mnt/evidence/case_$(date +%Y%m%d)_disk.sha256 \
  conv=noerror,sync

# Alternative: dd with hash
sudo dd if=/dev/sda bs=512 conv=noerror,sync | \
  tee /mnt/evidence/disk.dd | sha256sum > /mnt/evidence/disk.sha256

# Verify acquisition integrity
sha256sum /mnt/evidence/disk.dd
diff <(sha256sum /mnt/evidence/disk.dd | awk '{print $1}') \
  <(cat /mnt/evidence/disk.sha256 | awk '{print $1}') && \
  echo "INTEGRITY OK" || echo "INTEGRITY MISMATCH — STOP"

# Mount image read-only for analysis
sudo mkdir /mnt/analysis
sudo mount -o ro,loop,noexec /mnt/evidence/disk.dd /mnt/analysis
```

---

## Phase 2 — Timeline Analysis

```bash
EVIDENCE="/mnt/evidence/disk.dd"
OUT_DIR="$ENGAGEMENT_STORE/$ENG_ID/07-forensics"
mkdir -p "$OUT_DIR"

# Create filesystem timeline (MFT / inode times)
# Linux
find /mnt/analysis -printf "%T@ %Tc %f %p\n" 2>/dev/null | sort -n > "$OUT_DIR/fs-timeline.txt"

# Windows NTFS — use The Sleuth Kit
fls -r -m / $EVIDENCE > "$OUT_DIR/bodyfile.txt"
mactime -b "$OUT_DIR/bodyfile.txt" > "$OUT_DIR/timeline-full.txt"

# Filter to incident window (±7 days around incident date)
grep "2024/[0-9][0-9]/[0-9][0-9]" "$OUT_DIR/timeline-full.txt" | \
  awk -F'|' '$1 > 1704067200 && $1 < 1704672000' > "$OUT_DIR/timeline-window.txt"
```

---

## Phase 3 — Windows Artefact Analysis

```bash
# Registry analysis (requires Windows forensic tools)
# Mount the registry hives:
SYSTEM_HIVE="/mnt/analysis/Windows/System32/config/SYSTEM"
SAM_HIVE="/mnt/analysis/Windows/System32/config/SAM"
SOFTWARE_HIVE="/mnt/analysis/Windows/System32/config/SOFTWARE"

# Use regripper for automated registry analysis
rip.pl -r $SYSTEM_HIVE -f system > "$OUT_DIR/reg-system.txt"
rip.pl -r $SOFTWARE_HIVE -f software > "$OUT_DIR/reg-software.txt"
rip.pl -r $SAM_HIVE -f sam > "$OUT_DIR/reg-sam.txt"

# Key registry locations for attacker persistence:
# HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
# HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
# HKLM\SYSTEM\CurrentControlSet\Services (malicious services)
# HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
```

```bash
# Event Log analysis
EVTX_DIR="/mnt/analysis/Windows/System32/winevt/Logs"

# Convert evtx to text
evtx_dump.py "$EVTX_DIR/Security.evtx" > "$OUT_DIR/security-events.json"
evtx_dump.py "$EVTX_DIR/System.evtx" > "$OUT_DIR/system-events.json"
evtx_dump.py "$EVTX_DIR/Microsoft-Windows-PowerShell%4Operational.evtx" \
  > "$OUT_DIR/powershell-events.json"

# Key Event IDs for investigation:
# 4624 — Successful logon
# 4625 — Failed logon
# 4648 — Logon with explicit credentials (lateral movement)
# 4672 — Special privileges assigned (admin logon)
# 4688 — Process creation (requires audit enabled)
# 4698 — Scheduled task created
# 4720 — User account created
# 7045 — New service installed
# 4104 — PowerShell script block logging

# Quick search for suspicious events
cat "$OUT_DIR/security-events.json" | \
  python3 -c "
import sys, json
for line in sys.stdin:
    try:
        e = json.loads(line)
        eid = e.get('Event',{}).get('System',{}).get('EventID',{}).get('#text','')
        if eid in ['4624','4625','4648','4698','4720','7045']:
            print(json.dumps(e, indent=2))
    except: pass
" > "$OUT_DIR/key-events.json"
```

```bash
# Prefetch files (program execution history)
ls "/mnt/analysis/Windows/Prefetch/"
# pecmd.exe -d "$EVTX_DIR/../Prefetch" --csv $OUT_DIR
# Or: python3 prefetch.py /path/to/file.pf

# Browser history
find /mnt/analysis -path "*/Chrome/User Data/Default/History" 2>/dev/null
find /mnt/analysis -path "*/Firefox/Profiles/*/places.sqlite" 2>/dev/null

# Recent files
find /mnt/analysis -name "*.lnk" -path "*/Recent/*" 2>/dev/null
find /mnt/analysis -name "*.lnk" -path "*/AppData/Roaming/Microsoft/Windows/Recent/*" 2>/dev/null

# Shellbags (folder access history)
# Use shellbags parser: python3 shellbags.py $SOFTWARE_HIVE
```

---

## Phase 4 — Malware Analysis (Basic)

```bash
# Extract suspicious files for analysis
SUSPICIOUS_FILE="/mnt/analysis/Windows/Temp/malware.exe"
HASH=$(sha256sum "$SUSPICIOUS_FILE" | awk '{print $1}')

# Preserve original
cp "$SUSPICIOUS_FILE" "$OUT_DIR/$HASH.bin"
echo "$HASH  $SUSPICIOUS_FILE" >> "$OUT_DIR/suspicious-files.sha256"

# VirusTotal check (online — requires API key or manual upload)
curl -s "https://www.virustotal.com/vtapi/v2/file/report?apikey=$VT_API_KEY&resource=$HASH" | \
  python3 -m json.tool | tee "$OUT_DIR/vt-$HASH.json"

# Static analysis
file "$OUT_DIR/$HASH.bin"
strings "$OUT_DIR/$HASH.bin" | grep -iE "http|ftp|cmd|powershell|reg|schtask" | head -50
exiftool "$OUT_DIR/$HASH.bin" 2>/dev/null

# PE header analysis (Windows executables)
objdump -f "$OUT_DIR/$HASH.bin" 2>/dev/null
# Or: python3 -m pefile "$OUT_DIR/$HASH.bin"
```

---

## Forensic Report Structure

The forensic report follows the technical report template with these sections:

1. **Executive Summary** — what happened, what was found, business impact
2. **Methodology** — tools, approach, evidence handled
3. **Timeline of Events** — chronological reconstruction
4. **Findings** — each artefact / IOC as a finding
5. **Attacker TTPs** — MITRE ATT&CK mapping
6. **Data Impacted** — what was accessed, exfiltrated, or destroyed
7. **Recommendations** — how to prevent recurrence
8. **Appendix** — raw evidence index, hash values

**Key difference from pentest report:** forensic reports establish facts, not vulnerabilities.
Write in past tense. Every claim requires an evidence citation.
