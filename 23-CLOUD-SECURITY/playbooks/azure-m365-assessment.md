# Azure / Microsoft 365 Security Assessment Playbook
### rmsecurity | 23-CLOUD-SECURITY

*Requires: Global Reader role or equivalent read-only permissions
in the target tenant. Confirm authorization in ROE before starting.*

---

## Phase 0 — Setup

```bash
ENG_ID="ENG-YYYY-NNN"
TENANT_ID="[client tenant GUID]"
SCAN_DIR="$ENGAGEMENT_STORE/$ENG_ID/02-scans/azure"
mkdir -p "$SCAN_DIR"

# Install required tools (if not on pentest base image)
pip install roadrecon
pip install o365-spray
npm install -g @microsoft/entra-ps  # optional

# Authenticate
az login --tenant $TENANT_ID
az account show | tee "$SCAN_DIR/account-info.json"
```

---

## Phase 1 — Tenant Reconnaissance (Passive)

```bash
TENANT_DOMAIN="client.onmicrosoft.com"

# Public tenant info (no auth required)
curl -s "https://login.microsoftonline.com/$TENANT_DOMAIN/v2.0/.well-known/openid-configuration" | \
  python3 -m json.tool | tee "$SCAN_DIR/tenant-oidc.json"

# Check federation / SSO configuration
curl -s "https://login.microsoftonline.com/common/userrealm/$TENANT_DOMAIN?api-version=1.0" | \
  python3 -m json.tool | tee "$SCAN_DIR/tenant-realm.json"

# AADInternals tenant info
# AADInternals::Get-AADIntLoginInformation -Domain $TENANT_DOMAIN

# Check M365 products licensed
curl -s "https://autodiscover-s.outlook.com/autodiscover/autodiscover.svc" \
  -H "Content-Type: text/xml" \
  -d '<Autodiscover><Request><EMailAddress>admin@'$TENANT_DOMAIN'</EMailAddress></Request></Autodiscover>' | \
  tee "$SCAN_DIR/autodiscover.xml"
```

---

## Phase 2 — Entra ID (Azure AD) Assessment

```bash
# ROADrecon — comprehensive Entra ID enumeration
roadrecon gather \
  --tenant $TENANT_ID \
  -o "$SCAN_DIR/roadrecon.db"

roadrecon analyze
roadrecon gui   # launch web UI at localhost:5000

# Key areas to review in ROADrecon:
# - Users with Global Admin
# - Guest accounts (external access)
# - Service Principals with high privileges
# - App registrations with secrets/certificates
# - Conditional Access Policies (gaps)
# - MFA enrollment status
# - Legacy authentication enabled

# Enumerate via Graph API (with reader rights)
# All users
az ad user list --query '[].{UPN:userPrincipalName,Admin:accountEnabled}' \
  -o table | tee "$SCAN_DIR/users.txt"

# All global admins
az role assignment list \
  --role "Global Administrator" \
  --query '[].{User:principalName}' \
  -o table | tee "$SCAN_DIR/global-admins.txt"

# Guest users (can be risk if external sharing uncontrolled)
az ad user list \
  --filter "userType eq 'Guest'" \
  --query '[].{UPN:userPrincipalName,Source:userPrincipalName}' \
  -o table | tee "$SCAN_DIR/guest-users.txt"

# Service principals with permissions
az ad sp list --all \
  --query '[].{Name:displayName,AppId:appId}' \
  -o table | tee "$SCAN_DIR/service-principals.txt"
```

---

## Phase 3 — Conditional Access & MFA

```bash
# List all Conditional Access Policies
az rest --method get \
  --url "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
  --query 'value[].{Name:displayName,State:state}' \
  -o table | tee "$SCAN_DIR/conditional-access.txt"

# Get full policy detail
az rest --method get \
  --url "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
  > "$SCAN_DIR/conditional-access-full.json"

# Key CA gaps to check:
# [ ] MFA not required for admins
# [ ] MFA not required for all users
# [ ] Legacy authentication not blocked
# [ ] No device compliance policy
# [ ] No location/IP-based restriction for admins
# [ ] Sign-in risk policy not enabled

# MFA enrollment report
az rest --method get \
  --url "https://graph.microsoft.com/v1.0/reports/credentialUserRegistrationDetails" \
  > "$SCAN_DIR/mfa-registration.json"
```

---

## Phase 4 — Exchange Online / Email Security

```bash
# Connect to Exchange Online (PowerShell — run from Windows or use Docker)
# Connect-ExchangeOnline -UserPrincipalName admin@$TENANT_DOMAIN

# From Linux using ExoPS module or Graph API:

# DMARC / SPF / DKIM check
dig +short $TENANT_DOMAIN TXT | grep "v=spf"
dig +short "_dmarc.$TENANT_DOMAIN" TXT
dig +short "selector1._domainkey.$TENANT_DOMAIN" TXT

# External email forwarding (data exfiltration risk)
# Check for inbox rules forwarding to external addresses
az rest --method get \
  --url "https://graph.microsoft.com/v1.0/users" \
  --query 'value[].userPrincipalName' -o tsv | while read upn; do
  az rest --method get \
    --url "https://graph.microsoft.com/v1.0/users/$upn/mailFolders/inbox/messageRules" \
    2>/dev/null | python3 -m json.tool >> "$SCAN_DIR/mail-rules.json"
done

# Anti-phishing / anti-spoofing policies
# Review in Microsoft Defender portal — screenshot required
```

---

## Phase 5 — Azure Storage Assessment

```bash
# Find storage accounts
az storage account list \
  --query '[].{Name:name,RG:resourceGroup,PublicAccess:allowBlobPublicAccess}' \
  -o table | tee "$SCAN_DIR/storage-accounts.txt"

# Check for public blob containers
az storage account list --query '[].name' -o tsv | while read account; do
  az storage container list \
    --account-name $account \
    --auth-mode login \
    --query '[].{Container:name,Public:properties.publicAccess}' \
    -o table 2>/dev/null
done | tee "$SCAN_DIR/storage-containers.txt"

# Attempt unauthenticated access to public containers
STORAGE_ACCOUNT="[target_account]"
CONTAINER="[container_name]"
curl -s "https://$STORAGE_ACCOUNT.blob.core.windows.net/$CONTAINER?restype=container&comp=list"

# Check SAS token policies
az storage account list --query '[].name' -o tsv | while read account; do
  az storage account show \
    -n $account \
    --query '{SASPolicy:sasPolicy,MinTLS:minimumTlsVersion}' \
    -o json
done | tee "$SCAN_DIR/storage-policies.txt"
```

---

## Phase 6 — Azure VM & Network Posture

```bash
# List all VMs and public IPs
az vm list-ip-addresses \
  --query '[].{VM:virtualMachine.name,PublicIP:virtualMachine.network.publicIpAddresses[0].ipAddress}' \
  -o table | tee "$SCAN_DIR/vms-public-ips.txt"

# NSG rules — find overly permissive inbound rules
az network nsg list \
  --query '[].{NSG:name,RG:resourceGroup}' \
  -o tsv | while read name rg; do
  az network nsg show -n $name -g $rg \
    --query 'securityRules[?access==`Allow` && direction==`Inbound`].{Port:destinationPortRange,Source:sourceAddressPrefix,Priority:priority}' \
    -o table
done | tee "$SCAN_DIR/nsg-rules.txt"

# Dangerous rules to flag:
# Source: * (Any) on Port: * (Any) = direct internet access to all ports
# Source: * on Port: 3389 = RDP exposed
# Source: * on Port: 22 = SSH exposed
```

---

## Phase 7 — ScoutSuite Automated Assessment

```bash
# ScoutSuite — multi-cloud security posture tool
scout azure \
  --tenant $TENANT_ID \
  --report-dir "$SCAN_DIR/scoutsuite/" \
  --no-browser

# Opens HTML report — review:
# - Danger (red) findings first
# - Warning (orange) next
# - Screenshot each relevant finding as evidence
```

---

## Common Azure / M365 Findings Reference

| Finding | Severity | Area |
|---------|---------|------|
| Global Admin without MFA | Critical | Identity |
| Legacy auth not blocked (allows bypass MFA) | High | Identity |
| MFA not required for all users | High | Identity |
| Public blob container with sensitive data | Critical/High | Storage |
| No DMARC / p=none | Medium | Email |
| Overly permissive NSG (0.0.0.0/0 on RDP) | High | Network |
| External email forwarding rule | High | Email |
| Guest users with excessive permissions | Medium | Identity |
| No Conditional Access for admin sign-in | High | Identity |
| App registration with client secret expiry ignored | Medium | Identity |
| No DLP policy on sensitive labels | Medium | Compliance |
| Privileged Identity Management (PIM) not used | Medium | Identity |
