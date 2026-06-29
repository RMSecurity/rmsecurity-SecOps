# OSINT Toolkit Reference
### rmsecurity | 20-RECON-OSINT

---

## Online Resources (No Install Required)

| Resource | Purpose | URL |
|---------|---------|-----|
| Shodan | Internet device search | shodan.io |
| Censys | Internet surface search | search.censys.io |
| crt.sh | Certificate transparency | crt.sh |
| DNSDumpster | DNS recon | dnsdumpster.com |
| SecurityTrails | Passive DNS / subdomain | securitytrails.com |
| BGP.he.net | ASN / IP range lookup | bgp.he.net |
| BGPView | ASN API | bgpview.io |
| Hunter.io | Email format discovery | hunter.io |
| Have I Been Pwned | Breach check | haveibeenpwned.com |
| BuiltWith | Technology fingerprint | builtwith.com |
| Wayback Machine | Historical website content | web.archive.org |
| ARIN/RIPE/LACNIC | IP registration | search.arin.net |
| Google Dorks | Search engine OSINT | google.com |
| LinkedIn | Employee / org enumeration | linkedin.com |

---

## CLI Tools

| Tool | Install | Purpose |
|------|---------|---------|
| amass | `go install github.com/OWASP/Amass/v3/...@latest` | Subdomain enum |
| subfinder | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` | Passive subdomain |
| dnsx | `go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest` | DNS resolution |
| httpx | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` | HTTP probing |
| shodan | `pip3 install shodan` | Shodan CLI |
| theHarvester | `pip3 install theHarvester` | Email/domain OSINT |

```bash
# theHarvester — all sources
theHarvester -d [domain] -b all -l 500 -f "$RECON_DIR/theharvester"

# Combine subdomain sources
cat passive-results/*.txt | sort -u | \
  dnsx -silent -a -resp > "$RECON_DIR/resolved-subdomains.txt"

# Probe for live HTTP/S services
cat "$RECON_DIR/resolved-subdomains.txt" | \
  httpx -silent -title -status-code -tech-detect \
  -o "$RECON_DIR/live-web-services.txt"
```

---

## Shodan CLI Reference

```bash
# Set API key
shodan init [API_KEY]

# Search by org name
shodan search 'org:"Target Corp"' --fields ip_str,port,product,version

# Search by domain
shodan search "hostname:target.com" --fields ip_str,port,product

# Search for specific vulnerabilities
shodan search 'org:"Target Corp" vuln:CVE-2021-44228'  # Log4Shell

# Download full results
shodan download --limit 1000 results 'org:"Target Corp"'
shodan parse --fields ip_str,port,product results.json.gz

# Get host details
shodan host [IP_ADDRESS]
```

---

## Google Dork Cheat Sheet

```
# Site-specific
site:[domain]
site:[domain] filetype:pdf
site:[domain] filetype:xlsx OR docx OR csv
site:[domain] inurl:admin
site:[domain] intitle:"index of"

# Sensitive content
site:[domain] "password" OR "credentials" OR "token"
site:[domain] "BEGIN RSA PRIVATE KEY"
site:[domain] "DB_PASSWORD" OR "API_KEY" OR "SECRET_KEY"

# Infrastructure exposure
site:[domain] intext:"SQL syntax" (error pages)
site:[domain] "phpMyAdmin"
site:[domain] "wp-login.php"
site:[domain] "Jenkins" intitle:"Dashboard"

# Employee/email discovery
"@[domain]" site:linkedin.com
"[org name]" site:github.com
```

---

## Email & Breach Investigation

```bash
# theHarvester for emails
theHarvester -d [domain] -b linkedin,google,bing -l 500

# HIBP breach check (requires API key for domain search)
curl -s "https://haveibeenpwned.com/api/v3/breacheddomain/[domain]" \
  -H "hibp-api-key: [KEY]"

# DeHashed (paid) — for credential pair research
# Use at dehashed.com — do not automate without their API terms
```
