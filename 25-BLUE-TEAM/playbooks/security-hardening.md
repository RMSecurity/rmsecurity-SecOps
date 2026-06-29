# Security Hardening Guidance
### rmsecurity | 25-BLUE-TEAM

*Delivered as remediation guidance in pentest reports or as a standalone
hardening review. Based on CIS Benchmarks and NIST SP 800-53.*

---

## Windows Active Directory Hardening

### Identity Tier Model

```
Tier 0 (Domain Controllers, AD admin tools)
  ↕ No admin accounts cross tiers
Tier 1 (Servers, applications)
  ↕ No admin accounts cross tiers
Tier 2 (Workstations, help desk)
```

- Domain Admins log in ONLY to Tier 0 systems
- Server admins log in ONLY to Tier 1+ systems
- No user logs into DC for daily work

### Credential Protections

```powershell
# Enable Protected Users security group for all privileged accounts
Add-ADGroupMember -Identity "Protected Users" -Members [ADMIN_USER]
# Effect: No NTLM, no delegation, no cached creds, Kerberos only

# Enable Credential Guard (Windows 10 Enterprise+)
# Protects LSASS memory from credential dumping

# Enable LSASS audit (detect Mimikatz attempts)
auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable

# Disable NTLM authentication (after testing)
# Computer Configuration → Windows Settings → Security Settings →
# Local Policies → Security Options → Network security: LAN Manager authentication level
# Set to: "Send NTLMv2 response only. Refuse LM & NTLM"
```

### Disable Legacy Protocols

```powershell
# Disable LLMNR via GPO
# Computer Configuration → Administrative Templates → Network → DNS Client
# Set "Turn Off Multicast Name Resolution" to Enabled

# Disable NetBIOS over TCP/IP
# Network adapter → TCP/IP → Advanced → WINS → Disable NetBIOS over TCP/IP
# Or via DHCP option 43

# Disable SMBv1 (EternalBlue vector)
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart

# Block LDAP null sessions
# Computer Configuration → Windows Settings → Security Settings →
# Local Policies → Security Options:
# "Network access: Allow anonymous SID/Name translation" = Disabled
# "Network access: Do not allow anonymous enumeration of SAM accounts" = Enabled
```

### Kerberos Hardening

```powershell
# Set long random passwords on service accounts with SPNs (defeats Kerberoast)
$NewPass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | % {[char]$_})
Set-ADAccountPassword -Identity [SVC_ACCOUNT] -NewPassword (ConvertTo-SecureString $NewPass -AsPlainText -Force) -Reset

# Group Managed Service Accounts (gMSA) — password managed automatically
New-ADServiceAccount -Name "svc-app" -DNSHostName "svc-app.domain.local" -PrincipalsAllowedToRetrieveManagedPassword "AppServers"

# Enable AES encryption for Kerberos (disables RC4 / DES)
Set-ADUser -Identity [USER] -KerberosEncryptionType AES128,AES256
```

---

## Windows Workstation Hardening

```powershell
# AppLocker / WDAC — whitelist application execution
# Start with Audit mode, then enforce

# PowerShell Constrained Language Mode
[Environment]::SetEnvironmentVariable("__PSLockdownPolicy", "4", "Machine")

# Block PowerShell v2 (bypasses logging)
Disable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellV2Root"

# Enable PowerShell Script Block Logging
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" `
  -Name "EnableScriptBlockLogging" -Value 1

# Enable Windows Defender Attack Surface Reduction rules
$asrRules = @{
  "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" = 1  # Block executable content from email
  "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" = 1  # Block Office from creating child processes
  "3B576869-A4EC-4529-8536-B80A7769E899" = 1  # Block Office from creating executable content
  "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" = 1  # Block Office from injecting code into other processes
  "D3E037E1-3EB8-44C8-A917-57927947596D" = 1  # Block JS/VBS from launching downloaded executables
  "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC" = 1  # Block execution of potentially obfuscated scripts
  "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B" = 1  # Block Win32 API calls from Office macros
}
foreach ($rule in $asrRules.GetEnumerator()) {
  Add-MpPreference -AttackSurfaceReductionRules_Ids $rule.Key -AttackSurfaceReductionRules_Actions $rule.Value
}
```

---

## Linux Server Hardening (CIS Benchmark)

```bash
# System updates
apt update && apt upgrade -y
apt install unattended-upgrades -y
dpkg-reconfigure --priority=low unattended-upgrades

# Disable unused services
systemctl disable avahi-daemon cups bluetooth

# SSH hardening
cat >> /etc/ssh/sshd_config << 'EOF'
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
LoginGraceTime 60
Banner /etc/issue.net
AllowUsers [specific_users]
Protocol 2
EOF
systemctl restart sshd

# Firewall (ufw)
ufw default deny incoming
ufw default allow outgoing
ufw allow from [management_IP] to any port 22
ufw enable

# Kernel hardening (sysctl)
cat >> /etc/sysctl.d/99-hardening.conf << 'EOF'
# Disable IP forwarding (unless router)
net.ipv4.ip_forward = 0
# Disable ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
# Enable SYN flood protection
net.ipv4.tcp_syncookies = 1
# Restrict core dumps
fs.suid_dumpable = 0
# Randomize virtual address space
kernel.randomize_va_space = 2
# Restrict /proc/pid access
kernel.yama.ptrace_scope = 1
EOF
sysctl --system

# Auditd — log critical system events
apt install auditd -y
cat >> /etc/audit/rules.d/rmsecurity.rules << 'EOF'
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k sudoers
-a always,exit -F arch=b64 -S execve -k exec
-w /var/log/auth.log -p wa -k authlog
EOF
service auditd restart
```

---

## Network Hardening

```
[ ] Network segmentation — workstations cannot directly reach servers
[ ] Default deny inbound firewall on all hosts
[ ] No flat network — VLANs per function (workstations, servers, printers, IoT)
[ ] Dedicated VLAN for management interfaces (iDRAC, iLO, IPMI)
[ ] No direct internet access from servers — proxy required
[ ] Egress filtering — only necessary outbound ports
[ ] DNS sinkhole for known malicious domains
[ ] NTP from internal source only — no external NTP from endpoints
```

---

## Detection Recommendations

Derived from rmsecurity pentest techniques — configure these after a pentest:

| rmsecurity Technique | Detection |
|--------------------|-----------|
| LLMNR/NBT-NS poisoning | Alert: LLMNR query response from unknown host |
| Kerberoasting | Event 4769: Kerberos TGS request, RC4 encryption, non-computer account |
| Pass-the-Hash | Event 4624 Type 3 logon + Event 4648 from workstation |
| BloodHound enumeration | Spike in LDAP queries from workstation |
| Password spraying | Multiple 4625 failures, different accounts, same source |
| DCSync | Event 4662: Directory Service Object Access on domain partition |
| New scheduled task | Event 4698 |
| New service installed | Event 7045 |
| PowerShell encoded command | Event 4104: Script block with base64 |
