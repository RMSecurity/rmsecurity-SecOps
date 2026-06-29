# KB-AD-001 — Kerberoasting
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]  
**Title:** Kerberoastable Service Account with Weak Password  
**Severity:** High  
**CVSS v3.1:** 8.8 (AV:A/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)  
**CWE:** CWE-916 (Use of Password Hash With Insufficient Computational Effort)  
**MITRE ATT&CK:** T1558.003 — Steal or Forge Kerberos Tickets: Kerberoasting  

---

## Description

In Active Directory environments, any authenticated domain user can request
a Kerberos service ticket (TGS) for any service account that has a Service
Principal Name (SPN) registered. These tickets are encrypted with the service
account's password hash and can be exported by the requesting user.

An attacker with any domain user account can request these tickets and crack
them offline — without sending any traffic to the target service account's
host — using common password cracking tools and wordlists.

During this engagement, rmsecurity identified [N] service account(s) with
SPNs: [LIST OF ACCOUNTS]. The Kerberos ticket for [ACCOUNT NAME] was
successfully cracked in [TIMEFRAME], revealing the password [COMPLEXITY/PATTERN —
do not include actual password].

---

## Impact

An attacker with any domain user account (including a phished or sprayed
account) can:

1. Request Kerberos service tickets for service accounts with weak passwords
2. Crack the tickets offline using commodity hardware — no network interaction
   required after the initial ticket request, meaning this attack generates
   minimal logs
3. Authenticate as the service account, gaining access to all resources the
   service account can access

[IF HIGH-PRIVILEGE SVC ACCOUNT]: The [ACCOUNT NAME] service account has
[DESCRIBE PRIVILEGES — e.g., "local administrator rights on [N] servers",
"database administrator access to [SYSTEM]"]. Compromise of this account
provides [IMPACT].

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | impacket-GetUserSPNs output showing Kerberoastable accounts |
| [EV-ID] | Hashcat output showing successful password cracking |

---

## Remediation

**For each Kerberoastable service account:**

1. **Rotate the password to a long, random value (minimum 25 characters):**
   ```powershell
   $NewPass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
   Set-ADAccountPassword -Identity [SVC_ACCOUNT] -NewPassword `
     (ConvertTo-SecureString $NewPass -AsPlainText -Force) -Reset
   ```

2. **Migrate to Group Managed Service Accounts (gMSA)** — passwords are managed
   automatically by AD (240-character random, rotated regularly), eliminating
   the Kerberoasting risk entirely:
   ```powershell
   New-ADServiceAccount -Name "svc-[appname]" `
     -DNSHostName "svc-[appname].$DOMAIN" `
     -PrincipalsAllowedToRetrieveManagedPassword "[AppServer_Group]"
   ```

3. **Enable AES-256 encryption for service accounts** (disables RC4 tickets
   which crack faster):
   ```powershell
   Set-ADUser [SVC_ACCOUNT] -KerberosEncryptionType AES256
   ```

4. **Review service account privileges** — apply least privilege; service
   accounts should only have access to the resources they need

---

## References

- [MITRE T1558.003](https://attack.mitre.org/techniques/T1558/003/)
- [Microsoft: Group Managed Service Accounts](https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview)
- [SpecterOps: Kerberoasting Revisited](https://posts.specterops.io/kerberoasting-revisited-d434351bd4d1)
