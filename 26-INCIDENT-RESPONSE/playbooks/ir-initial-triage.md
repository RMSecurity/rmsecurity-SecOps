# Incident Response — Initial Triage Playbook
### rmsecurity | 26-INCIDENT-RESPONSE

*First 24 hours. Objective: establish scope of compromise, preserve evidence,
and determine immediate containment priority. Do not remediate before scoping.*

---

## Incident Classification

| Severity | Criteria | SLA |
|---------|---------|-----|
| P1 — Critical | Active data exfiltration, ransomware, business-critical system down | 4 hours |
| P2 — High | Confirmed breach, malware active, admin credentials compromised | 8 hours |
| P3 — Medium | Suspicious activity, potential phishing victim, isolated infected host | 24 hours |
| P4 — Low | False positive investigation, security hygiene issue | 72 hours |

---

## Phase 0 — Intake (First 30 Minutes)

```
Questions to ask the client immediately:
[ ] What did you see? (alert, suspicious email, ransom note, etc.)
[ ] When was it first noticed?
[ ] How was it noticed? (user report, AV alert, SIEM alert, external notification)
[ ] What systems are affected? (hostnames, IP addresses, locations)
[ ] What critical systems / data could be at risk? (ERP, database, PII, payment)
[ ] Are any systems currently offline or inaccessible?
[ ] Has anything been changed or shut down already? (contamination concern)
[ ] Do you have endpoint detection and response (EDR) deployed?
[ ] Who else knows about this? (legal counsel, insurance, leadership)
[ ] Do you have backups? When was the last verified restore test?
```

---

## Phase 1 — Initial Evidence Preservation

**STOP. Before touching anything, preserve volatile evidence.**

### 1.1 Volatile Evidence — Collect First

```bash
# On affected host (if accessible and not ransomware)
# Run as administrator / root

# 1. Memory dump (most volatile)
# Windows:
winpmem_mini_x64.exe -o memory_$(hostname)_$(date +%Y%m%d%H%M).raw

# Linux:
dd if=/proc/mem of=/mnt/ir/memory_dump.raw bs=1M
# Or: lime (LiME kernel module)

# 2. Running processes
# Windows:
tasklist /v > processes_$(date +%Y%m%d%H%M).txt
wmic process get Name,ProcessId,ParentProcessId,CommandLine,ExecutablePath /format:csv > processes_wmic.csv

# Linux:
ps auxf > processes_$(date +%Y%m%d%H%M).txt
cat /proc/*/cmdline 2>/dev/null | strings > cmdlines.txt

# 3. Network connections
# Windows:
netstat -anob > netstat_$(date +%Y%m%d%H%M).txt
ipconfig /all >> network_info.txt

# Linux:
netstat -tulnpa > netstat_$(date +%Y%m%d%H%M).txt
ss -tulnpa >> netstat.txt
ip addr; ip route >> network_info.txt

# 4. Logged-in users
# Windows:
query session; query user; net sessions

# Linux:
who; w; last | head -50

# 5. Scheduled tasks / cron (persistence mechanisms)
# Windows:
schtasks /query /fo CSV /v > scheduled_tasks.csv
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule" tasks_reg.reg

# Linux:
crontab -l; ls /etc/cron* /var/spool/cron/crontabs/ 2>/dev/null

# 6. Autorun / startup entries
# Windows:
reg export HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run autorun_hklm.reg
reg export HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run autorun_hkcu.reg

# 7. Hash system files for integrity
# Windows:
Get-FileHash C:\Windows\System32\*.exe | Export-Csv system32-hashes.csv

# Linux:
sha256sum /bin/* /sbin/* /usr/bin/* > system-binary-hashes.txt
```

### 1.2 Network Evidence

```bash
# On network infrastructure (if accessible)
# Capture traffic on affected segment (if possible)
tcpdump -i eth0 -w capture_$(date +%Y%m%d%H%M).pcap -G 3600 &

# Collect firewall logs — last 7 days minimum
# Collect VPN authentication logs
# Collect DNS query logs from internal resolver
# Collect proxy / web filter logs
# Export SIEM alerts for the incident window

# If you have EDR:
# Export process tree for affected hosts
# Export network connections timeline
# Export file creation/modification events
```

---

## Phase 2 — Scope Assessment

```bash
# Identify patient zero (first infected host)
# Look for earliest indicators of compromise (IoC) in:
# - Email logs (phishing attachment / link)
# - Web proxy logs (download / C2 connection)
# - Authentication logs (unusual login times / locations)
# - EDR alerts (earliest detection)

# Identify lateral movement
# Compare authentication logs across systems
# Look for: new accounts, PsExec, WMI, PowerShell remoting

# Identify C2 communication
# Check DNS logs for unusual domains
# Check firewall logs for connections to known-bad IPs
# Check proxy logs for unusual user-agents or beaconing patterns
```

**Document scope assessment in IR timeline:**

```markdown
# IR Timeline — [ENG-ID]

| Time (UTC) | System | Event | Confidence | Source |
|------------|--------|-------|------------|--------|
| [TIME] | [HOST] | [What happened] | [High/Med/Low] | [Log source] |
```

---

## Phase 3 — IoC Development

```bash
# From initial triage, develop indicators of compromise:

# File hashes of malware
sha256sum [suspicious_file]

# Network indicators
# - C2 domains / IPs
# - User-agents used by malware
# - URI patterns

# Host indicators
# - Registry keys created
# - Files dropped (path + name)
# - Process names / parent-child relationships
# - Scheduled task names / service names

# Save IoC list
cat > "$ENGAGEMENT_STORE/$ENG_ID/03-ioc/iocs.txt" << 'EOF'
# IoC List — [ENG-ID]
# Format: type|value|confidence|description

hash|[sha256]|high|[malware name]
ip|[C2 IP]|high|[C2 server observed in traffic]
domain|[C2 domain]|high|[C2 domain from DNS logs]
filepath|[C:\path\to\malware.exe]|high|[dropper location]
regkey|[HKLM\...\malware]|high|[persistence mechanism]
EOF
```

---

## Phase 4 — Initial Reporting to Client

**Provide verbal update within 2 hours of engagement start.**

Template for initial status call:

```
1. What we know so far (scope, patient zero if identified)
2. What we don't know yet (full extent of compromise)
3. Immediate recommendation (isolate / don't touch / shut down)
4. What we need from the client (access, logs, contacts)
5. Next update time
```

**Proceed to:** `ir-containment.md` once scope is established.

---

## Contacts and Escalation

```
Incident lead (rmsecurity): [Name] — [phone]
Client technical contact: [from ROE]
Client management contact: [from ROE]
Client legal counsel: [if ransomware / data breach]
Client cyber insurance: [if applicable]
CERT / law enforcement: [only on advice of legal counsel]
```
