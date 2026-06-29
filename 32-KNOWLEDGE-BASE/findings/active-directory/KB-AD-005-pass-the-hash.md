# KB-AD-005 — Pass-the-Hash / Local Admin Password Reuse
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** Identical Local Administrator Password Across Multiple Hosts
**Severity:** Critical / High *(Critical if leads to Domain Admin path; High if contained)*
**CVSS v3.1:** 9.1 (AV:A/AC:L/PR:H/UI:N/S:C/C:H/I:H/A:H)
**CWE:** CWE-262 (Not Using Password Aging) / CWE-521
**MITRE ATT&CK:** T1550.002 — Use Alternate Authentication Material: Pass the Hash

---

## Description

The local Administrator account password (or its NTLM hash) is identical
across [N] hosts in the environment. Because NTLM authentication validates
a password hash rather than the plaintext password, an attacker who obtains
the local Administrator hash from one machine (via LSASS dump, SAM dump, or
similar) can authenticate as Administrator on every other host sharing
that hash — without ever cracking the password.

During this engagement, rmsecurity dumped the local Administrator hash from
[HOST] and successfully authenticated to [N] additional hosts using
Pass-the-Hash, demonstrating lateral movement across the environment.

---

## Impact

Compromise of a single workstation with a shared local admin password
provides an attacker with:

1. Administrative access to every host sharing that password — often the
   entire workstation fleet
2. The ability to harvest credentials from memory (LSASS) on each
   additional host, potentially capturing domain admin credentials if any
   privileged user has logged into one of the affected machines
3. A direct path to full domain compromise if a Domain Admin has ever
   logged on interactively to any shared-password host

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | CrackMapExec output showing successful auth across multiple hosts with same hash |
| [EV-ID] | secretsdump output showing identical local admin hash on [N] hosts |

---

## Remediation

**Mandatory fix — deploy LAPS (Local Administrator Password Solution):**

1. Install LAPS (or Windows LAPS, built into recent Windows builds):
   ```powershell
   Install-WindowsFeature -Name RSAT-AD-PowerShell
   # Configure via GPO: Computer Configuration → Administrative Templates → LAPS
   ```
2. LAPS generates a unique, randomized local administrator password per
   host and rotates it automatically, eliminating hash reuse across machines
3. Restrict LAPS password read access to a tightly scoped admin group

**Compensating controls while LAPS is deployed:**

1. Restrict local Administrator account usage to break-glass scenarios only
2. Disable the built-in local Administrator account where possible and use
   named admin accounts instead
3. Enable Windows Defender Credential Guard to limit LSASS credential
   exposure

---

## References

- [Microsoft: Windows LAPS](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview)
- [MITRE T1550.002](https://attack.mitre.org/techniques/T1550/002/)
