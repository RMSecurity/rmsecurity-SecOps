# KB-NET-003 — SMB / NTLM Relay
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** SMB Signing Disabled Allows NTLM Relay Attack
**Severity:** Critical / High *(Critical if relay leads to Domain Admin; High if contained)*
**CVSS v3.1:** 9.8 (AV:A/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H)
**CWE:** CWE-294 (Authentication Bypass by Capture-replay)
**MITRE ATT&CK:** T1557.001 — Adversary-in-the-Middle: LLMNR/NBT-NS Poisoning and SMB Relay

---

## Description

SMB signing is not enforced on [N] hosts in the environment, including
[HOSTNAMES — note especially if any Domain Controller is affected].
Without SMB signing, an attacker positioned on the network can relay a
captured NTLM authentication attempt (e.g., from LLMNR/NBT-NS poisoning,
or a forced authentication via PetitPotam/PrinterBug) directly to one of
these hosts and authenticate as the victim, without ever cracking the
password.

During this engagement, rmsecurity captured an authentication attempt from
[VICTIM ACCOUNT] and relayed it to [TARGET HOST], obtaining
[administrative access / SMB share access / a session as the victim].

---

## Impact

An attacker on the network can:

1. Relay any captured NTLM authentication to a host with signing disabled,
   gaining the privileges of the victim account on that host — without
   cracking any password
2. If the relayed account has local admin rights on the target, achieve
   full code execution
3. **If a Domain Controller has signing disabled and LDAP signing/channel
   binding is also not enforced**, relay an authentication to LDAP and
   create a computer object with delegation rights, leading to full
   domain compromise via Resource-Based Constrained Delegation

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | ntlmrelayx output showing successful relay and authentication |
| [EV-ID] | nmap/CrackMapExec output confirming SMB signing not required on target hosts |

---

## Remediation

**Mandatory:**

1. **Enforce SMB signing on all hosts**, especially Domain Controllers, via GPO:
   - Computer Configuration → Windows Settings → Security Settings →
     Local Policies → Security Options
   - **"Microsoft network server: Digitally sign communications (always)"** → Enabled
   - **"Microsoft network client: Digitally sign communications (always)"** → Enabled

2. **Enforce LDAP signing and channel binding** on Domain Controllers (closes
   the LDAP relay path):
   ```
   "Domain controller: LDAP server signing requirements" → Require signing
   "Domain controller: LDAP server channel binding token requirements" → Always
   ```

3. Disable LLMNR/NBT-NS (see [[KB-NET-001]]) to reduce opportunities to
   capture authentication attempts in the first place

4. Patch and mitigate forced-authentication vectors (PetitPotam, PrinterBug)
   by disabling the Print Spooler on Domain Controllers and applying
   relevant Microsoft patches

---

## References

- [MITRE T1557.001](https://attack.mitre.org/techniques/T1557/001/)
- [Microsoft: SMB Signing](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/overview-server-message-block-signing)
- [impacket ntlmrelayx](https://github.com/fortra/impacket)
