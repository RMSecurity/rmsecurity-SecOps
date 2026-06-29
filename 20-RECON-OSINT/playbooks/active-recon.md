# Active Reconnaissance Playbook
### rmsecurity | 20-RECON-OSINT

*Active recon touches target infrastructure and WILL generate logs.
Only begin after passive recon is complete and Gate 1 is passed.*

---

## Prerequisites

```bash
# Confirm scope before running any command
# All IPs below must be verified against the signed ROE

TARGET_DOMAIN="example.com"
TARGET_IPS="10.0.0.0/24"      # from ROE
ENG_ID="ENG-YYYY-NNN"
RECON_DIR="$ENGAGEMENT_STORE/$ENG_ID/01-recon/active"
mkdir -p "$RECON_DIR"
```

---

## 1. DNS Brute-Force & Zone Transfer

```bash
# Zone transfer attempt (rarely works but always try)
dig axfr "$TARGET_DOMAIN" @$(dig +short NS "$TARGET_DOMAIN" | head -1) | \
  tee "$RECON_DIR/zone-transfer.txt"

# DNS brute-force with common wordlist
gobuster dns \
  -d "$TARGET_DOMAIN" \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt \
  -t 30 \
  -o "$RECON_DIR/dns-bruteforce.txt"

# Alternative: amass
amass enum -d "$TARGET_DOMAIN" -o "$RECON_DIR/amass-subdomains.txt"

# Alternative: subfinder
subfinder -d "$TARGET_DOMAIN" -o "$RECON_DIR/subfinder.txt"

# Resolve all discovered subdomains to IPs
cat "$RECON_DIR/dns-bruteforce.txt" "$RECON_DIR/subfinder.txt" 2>/dev/null | \
  sort -u > "$RECON_DIR/all-subdomains.txt"

for sub in $(cat "$RECON_DIR/all-subdomains.txt"); do
  ip=$(dig +short "$sub" A | head -1)
  [ -n "$ip" ] && echo "$sub,$ip"
done | tee "$RECON_DIR/subdomain-ips.csv"
```

---

## 2. Port Scanning

### 2.1 Fast Discovery Scan (all ports, no service detection)

```bash
# Fast full-port discovery
nmap -p- --min-rate 5000 -T4 \
  -oA "$RECON_DIR/nmap-allports" \
  $TARGET_IPS

# Extract open ports for next step
grep "open" "$RECON_DIR/nmap-allports.gnmap" | \
  grep -oP '\d+/open' | cut -d'/' -f1 | sort -un | \
  tr '\n' ',' | sed 's/,$//' > "$RECON_DIR/open-ports.txt"

echo "Open ports: $(cat $RECON_DIR/open-ports.txt)"
```

### 2.2 Service & Version Detection on Open Ports

```bash
OPEN_PORTS=$(cat "$RECON_DIR/open-ports.txt")

nmap -p "$OPEN_PORTS" \
  -sV --version-intensity 5 \
  -sC \
  -O \
  --script=banner,http-title,ssl-cert \
  -oA "$RECON_DIR/nmap-services" \
  $TARGET_IPS
```

### 2.3 UDP Top Ports

```bash
# UDP scan — slow but finds SNMP, TFTP, NTP, DNS resolvers
nmap -sU --top-ports 100 \
  -T4 \
  -oA "$RECON_DIR/nmap-udp" \
  $TARGET_IPS
```

---

## 3. Web Application Discovery

```bash
# Find all HTTP/HTTPS services from nmap output
grep -E "80/open|443/open|8080/open|8443/open|8000/open" \
  "$RECON_DIR/nmap-allports.gnmap" | \
  awk '{print $2}' | tee "$RECON_DIR/webservers.txt"

# Screenshot all web services (for quick visual enumeration)
gowitness file -f "$RECON_DIR/webservers.txt" \
  -P "$RECON_DIR/screenshots/"

# Alternatively: aquatone
cat "$RECON_DIR/webservers.txt" | aquatone \
  -out "$RECON_DIR/aquatone/"
```

---

## 4. Service-Specific Enumeration

### SMB (Port 445)

```bash
# Enumerate shares, OS, users (no creds)
nmap -p 445 --script=smb-enum-shares,smb-os-discovery,smb-security-mode \
  -oA "$RECON_DIR/smb-enum" $TARGET_IPS

# Check for null session / anonymous access
smbclient -L //$TARGET_IP -N 2>&1 | tee "$RECON_DIR/smb-shares.txt"

# CrackMapExec enumeration
cme smb $TARGET_IPS --shares | tee "$RECON_DIR/cme-smb.txt"
```

### LDAP (Port 389 / 636) — Active Directory

```bash
# Anonymous LDAP bind — often reveals base DN and naming context
ldapsearch -x -H ldap://$TARGET_IP -s base namingcontexts 2>&1 | \
  tee "$RECON_DIR/ldap-base.txt"

# Enumerate AD domain info without credentials
nmap -p 389 --script=ldap-rootdse,ldap-search \
  -oA "$RECON_DIR/ldap-enum" $TARGET_IPS
```

### SNMP (UDP 161)

```bash
# Community string brute-force
onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp.txt \
  $TARGET_IPS | tee "$RECON_DIR/snmp-community.txt"

# Enumerate if community string found
snmpwalk -v2c -c [COMMUNITY] $TARGET_IP | \
  tee "$RECON_DIR/snmp-walk.txt"
```

### FTP (Port 21)

```bash
# Check anonymous login
nmap -p 21 --script=ftp-anon,ftp-bounce,ftp-syst \
  -oA "$RECON_DIR/ftp-enum" $TARGET_IPS
```

### RDP (Port 3389)

```bash
# Check RDP exposure
nmap -p 3389 --script=rdp-enum-encryption,rdp-vuln-ms12-020 \
  -oA "$RECON_DIR/rdp-enum" $TARGET_IPS
```

---

## 5. Web Application Enumeration

```bash
TARGET_URL="https://example.com"

# Directory and file discovery
gobuster dir \
  -u "$TARGET_URL" \
  -w /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt \
  -t 40 \
  -x php,asp,aspx,jsp,html,txt,xml,json,bak,old,zip \
  -o "$RECON_DIR/gobuster-dirs.txt" \
  --no-error

# Virtual host discovery (subdomains on same IP)
gobuster vhost \
  -u "https://$TARGET_IP" \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt \
  --append-domain \
  -o "$RECON_DIR/vhosts.txt"

# Technology fingerprinting
whatweb "$TARGET_URL" -v | tee "$RECON_DIR/whatweb.txt"
wapiti -u "$TARGET_URL" --format txt -o "$RECON_DIR/wapiti.txt" --depth 2

# SSL/TLS analysis
sslscan "$TARGET_URL" | tee "$RECON_DIR/sslscan.txt"
testssl.sh "$TARGET_URL" | tee "$RECON_DIR/testssl.txt"

# Common sensitive paths (manual check)
for path in robots.txt sitemap.xml .well-known/security.txt \
  .git/config .env wp-login.php admin/ phpmyadmin/ \
  api/v1/ swagger.json openapi.json; do
  code=$(curl -sk -o /dev/null -w "%{http_code}" "$TARGET_URL/$path")
  echo "$code $path"
done | tee "$RECON_DIR/sensitive-paths.txt"
```

---

## 6. Active Recon Completion Checklist

- [ ] DNS brute-force complete — all subdomains documented
- [ ] Full TCP port scan complete on all in-scope IPs
- [ ] UDP top-100 scan complete
- [ ] Service / version detection complete
- [ ] Web screenshots captured for all HTTP/S services
- [ ] SMB enumeration complete (if applicable)
- [ ] LDAP / AD enumeration complete (if applicable)
- [ ] SNMP enumeration complete (if applicable)
- [ ] Web directory enumeration complete on all web targets
- [ ] SSL/TLS scan complete on all HTTPS targets
- [ ] All output saved to `01-recon/active/`
- [ ] Attack surface documented in `01-recon/attack-surface.md`

**Proceed to:** `22-PENTESTING/playbooks/` for exploitation phase

---

## Attack Surface Summary Template

Save as `01-recon/attack-surface.md` in the engagement folder:

```markdown
# Attack Surface — [ENG-ID]

## External IPs / Hosts
| IP | Hostname | Open Ports | Services |
|----|---------|-----------|---------|
| | | | |

## Web Applications
| URL | Tech Stack | Auth | Notes |
|-----|-----------|------|-------|
| | | | |

## High-Value Targets (Prioritized)
1. [Most interesting target — why]
2. [Next target]

## Interesting Findings from Recon
- [Exposed admin panel]
- [Old / unpatched software version]
- [Anonymous access somewhere]
- [Default credentials risk]
```
