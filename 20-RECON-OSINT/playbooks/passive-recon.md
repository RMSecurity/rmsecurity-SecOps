# Passive Reconnaissance Playbook
### rmsecurity | 20-RECON-OSINT

*Passive recon generates zero logs on target systems. Complete this phase
before any active probing. All output saved to `01-recon/passive/`.*

---

## 1. Target Profile — Start Here

```bash
TARGET_DOMAIN="example.com"
TARGET_ORG="Example Corp"
ENG_ID="ENG-YYYY-NNN"
RECON_DIR="$ENGAGEMENT_STORE/$ENG_ID/01-recon/passive"
mkdir -p "$RECON_DIR"
```

---

## 2. WHOIS & Registration Data

```bash
# Domain registration
whois "$TARGET_DOMAIN" | tee "$RECON_DIR/whois-domain.txt"

# IP range WHOIS (after you have IPs)
whois [IP] | tee "$RECON_DIR/whois-ip.txt"

# ARIN / RIPE / LACNIC search
# https://search.arin.net — search org name for IP ranges
```

**Document:**
- Registrar and registration dates
- Registrant contact (often privacy-protected)
- Name servers
- ASN numbers and IP ranges belonging to the org

---

## 3. DNS Enumeration (Passive)

```bash
# Basic DNS records
for record in A AAAA MX NS TXT SOA; do
  dig +short "$TARGET_DOMAIN" "$record" | tee -a "$RECON_DIR/dns-$record.txt"
done

# Historical DNS (no direct contact)
# Tools: SecurityTrails, PassiveDNS, DNSHistory
# https://securitytrails.com/domain/$TARGET_DOMAIN/history

# Certificate transparency — find subdomains from certs
curl -s "https://crt.sh/?q=%25.$TARGET_DOMAIN&output=json" | \
  python3 -c "import sys,json; [print(c['name_value']) for c in json.load(sys.stdin)]" | \
  sort -u | tee "$RECON_DIR/subdomains-crtsh.txt"

# Passive subdomain sources (no API key required)
# https://dnsdumpster.com
# https://rapiddns.io/subdomain/$TARGET_DOMAIN
```

---

## 4. ASN & IP Range Discovery

```bash
# Find ASN from org name
# https://bgp.he.net — search for org name

# Get all prefixes for an ASN
curl -s "https://api.bgpview.io/asn/[ASNNUMBER]/prefixes" | \
  python3 -m json.tool | tee "$RECON_DIR/asn-prefixes.txt"

# BGP toolkit
bgp-toolkit() { curl -s "https://api.bgpview.io/search?query_term=$1" | python3 -m json.tool; }
bgp-toolkit "$TARGET_ORG"
```

---

## 5. Google Dorks (Search Engine OSINT)

```bash
# Save queries — run them manually in browser to avoid Google blocks
cat > "$RECON_DIR/google-dorks.txt" << EOF
site:$TARGET_DOMAIN
site:$TARGET_DOMAIN filetype:pdf
site:$TARGET_DOMAIN filetype:xlsx OR filetype:docx
site:$TARGET_DOMAIN inurl:admin OR inurl:login OR inurl:portal
site:$TARGET_DOMAIN intitle:"index of"
site:$TARGET_DOMAIN "password" OR "credentials" OR "secret"
"$TARGET_ORG" site:linkedin.com/in
"$TARGET_ORG" site:github.com
"@$TARGET_DOMAIN" site:pastebin.com
"$TARGET_DOMAIN" site:shodan.io
EOF
```

---

## 6. Shodan / Censys (Internet Exposure)

```bash
# Shodan CLI (requires API key in .env)
shodan search "org:\"$TARGET_ORG\"" --fields ip_str,port,product,version | \
  tee "$RECON_DIR/shodan-org.txt"

shodan search "hostname:$TARGET_DOMAIN" --fields ip_str,port,product,version | \
  tee "$RECON_DIR/shodan-hostname.txt"

# Shodan specific service searches
shodan search "org:\"$TARGET_ORG\" product:\"Apache httpd\""
shodan search "org:\"$TARGET_ORG\" port:3389"   # RDP exposed
shodan search "org:\"$TARGET_ORG\" port:22"     # SSH exposed
shodan search "org:\"$TARGET_ORG\" port:23"     # Telnet exposed
shodan search "org:\"$TARGET_ORG\" ssl.cert.subject.cn:$TARGET_DOMAIN"

# Censys (requires API key)
# https://search.censys.io/search?resource=hosts&q=$TARGET_DOMAIN
```

---

## 7. GitHub / Code Repository OSINT

```bash
# Search GitHub for leaked secrets / code mentioning target
# Manual searches (do not automate — may violate ToS):
# "$TARGET_DOMAIN" password
# "$TARGET_DOMAIN" secret
# "$TARGET_DOMAIN" api_key
# "$TARGET_DOMAIN" BEGIN RSA
# "$TARGET_ORG" internal
# "@$TARGET_DOMAIN"

# Tools:
# trufflehog (for specific repos if found)
# gitleaks (for specific repos)
# gitrob / gitrob-ng

# Check for org on GitHub
curl -s "https://api.github.com/orgs/$TARGET_ORG/repos" | \
  python3 -c "import sys,json; [print(r['full_name']) for r in json.load(sys.stdin)]" | \
  tee "$RECON_DIR/github-repos.txt" 2>/dev/null || true
```

---

## 8. Email & Employee OSINT

```bash
# Email format discovery
# https://hunter.io/domain-search/$TARGET_DOMAIN
# Typical formats: firstname.lastname@domain, firstlast@domain, first@domain

# LinkedIn employee enumeration (manual — browser)
# Search: site:linkedin.com/in "$TARGET_ORG"
# Look for: security team, IT/infrastructure, executives

# Email breach check
# https://haveibeenpwned.com/DomainSearch (paid — email breaches for domain)
# https://dehashed.com — comprehensive breach data (paid)

cat > "$RECON_DIR/employees-found.csv" << EOF
name,title,email_guess,linkedin_url,notes
EOF
```

---

## 9. Technology Stack Fingerprinting (Passive)

```bash
# Wappalyzer browser extension on public-facing assets
# BuiltWith: https://builtwith.com/$TARGET_DOMAIN

# Job postings — reveal internal stack
# LinkedIn Jobs, Indeed, company careers page
# Search for: "$TARGET_ORG" IT jobs, security jobs, developer jobs
# Document: technologies, frameworks, cloud providers, vendors mentioned

# Security vendor footprint (reveals what they're protecting with)
# Look for Cloudflare, Akamai, Zscaler, Palo Alto in DNS/MX/SPF records

cat > "$RECON_DIR/tech-stack.md" << EOF
# Technology Stack — $TARGET_ORG

## Web Technologies
- [CMS / Framework]
- [CDN / WAF]
- [Analytics]

## Email / Collaboration
- [Mail provider — from MX records]
- [SPF/DKIM/DMARC configuration]

## Cloud / Hosting
- [Cloud provider — from ASN / DNS]

## Security Products (observed)
- [WAF, CDN, etc.]

## From Job Postings
- [Technologies mentioned]
EOF
```

---

## 10. SPF / DMARC Analysis

```bash
# Check email security posture — often reveals phishing risk
dig +short "$TARGET_DOMAIN" TXT | grep -i "v=spf" | tee "$RECON_DIR/spf.txt"
dig +short "_dmarc.$TARGET_DOMAIN" TXT | tee "$RECON_DIR/dmarc.txt"
dig +short "_domainkey.$TARGET_DOMAIN" TXT | tee "$RECON_DIR/dkim.txt"

# Weak SPF: +all or ?all = anyone can send email as this domain
# No DMARC or p=none = phishing emails will be delivered
# Missing DMARC / p=none → note as potential finding (Low/Medium)
```

---

## Passive Recon Completion Checklist

- [ ] WHOIS and registration data collected
- [ ] All DNS record types enumerated
- [ ] Subdomains enumerated via certificate transparency
- [ ] ASN and IP ranges documented
- [ ] Google dorks run and findings documented
- [ ] Shodan / Censys scan complete — exposed services documented
- [ ] GitHub repositories searched for leaks
- [ ] Employee list started (LinkedIn)
- [ ] Technology stack documented
- [ ] SPF / DMARC posture assessed
- [ ] Output saved to `01-recon/passive/`
- [ ] Findings of interest noted for active recon and exploitation phases

**Proceed to:** `active-recon.md`
