# KB-AD-004 — DCSync Privilege Abuse
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** Excessive Replication Privileges Allow DCSync Attack
**Severity:** Critical
**CVSS v3.1:** 9.8 (AV:A/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**CWE:** CWE-269 (Improper Privilege Management)
**MITRE ATT&CK:** T1003.006 — OS Credential Dumping: DCSync

---

## Description

The account [ACCOUNT NAME] (or group [GROUP NAME]) holds the Active
Directory replication permissions `DS-Replication-Get-Changes` and
`DS-Replication-Get-Changes-All` on the domain object, without requiring
Domain Controller-level access. These permissions are normally reserved for
Domain Controllers and allow any holder to impersonate a Domain Controller
and request password data for any account in the domain — including the
KRBTGT account.

During this engagement, rmsecurity used the compromised account
[ACCOUNT NAME] to perform a DCSync attack and successfully extracted the
NTLM hash for [krbtgt / Domain Admin / target account], demonstrating full
domain compromise capability.

---

## Impact

Any attacker who compromises an account with these replication rights can:

1. Extract password hashes for **every account in the domain**, including
   Domain Admins and the KRBTGT account
2. Use the KRBTGT hash to forge Golden Tickets, granting persistent,
   undetectable domain-wide access that survives password resets
3. Achieve full, silent domain compromise without ever touching a Domain
   Controller directly — this attack generates minimal forensic artifacts

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | BloodHound output showing the ACL grant on the domain object |
| [EV-ID] | impacket-secretsdump / Mimikatz lsadump::dcsync output (redacted hashes) |

---

## Remediation

**Immediate:**

1. Identify why [ACCOUNT NAME] holds replication rights — this is almost
   always a misconfiguration (incorrectly delegated permissions, leftover
   from a decommissioned product, or over-broad group nesting)
2. Remove the `DS-Replication-Get-Changes` / `-All` ACE from the account/group
   on the domain object via ADUC → Domain → Properties → Security, or:
   ```powershell
   # Use dsacls or PowerView to audit and remove the specific ACE
   dsacls "DC=domain,DC=com" /R "DOMAIN\AccountName"
   ```
3. If a legitimate product requires these rights (e.g., Azure AD Connect),
   confirm the service account is properly secured (Tier 0 protection,
   restricted logon rights, monitored)

**Detection:**

Enable and monitor Event ID 4662 with the replication GUIDs
(`1131f6aa-9c07-11d1-f79f-00c04fc2dcd2` and related) on Domain Controllers —
any source other than a legitimate DC is a critical alert.

---

## References

- [MITRE T1003.006](https://attack.mitre.org/techniques/T1003/006/)
- [Microsoft: Monitoring DCSync](https://docs.microsoft.com/en-us/security/compass/incident-response-playbook-dcsync)
