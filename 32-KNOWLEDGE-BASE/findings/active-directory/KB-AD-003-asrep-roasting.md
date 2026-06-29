# KB-AD-003 — AS-REP Roasting
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** AS-REP Roastable Account with Weak Password
**Severity:** High
**CVSS v3.1:** 7.5 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)
**CWE:** CWE-330 (Use of Insufficiently Random Values) / CWE-916
**MITRE ATT&CK:** T1558.004 — Steal or Forge Kerberos Tickets: AS-REP Roasting

---

## Description

Active Directory accounts with the attribute **"Do not require Kerberos
preauthentication"** (`DONT_REQ_PREAUTH`) enabled are vulnerable to AS-REP
Roasting. Unlike Kerberoasting, this attack requires no valid credentials at
all — any unauthenticated user on the network can request an AS-REP message
for a vulnerable account and receive a portion encrypted with that account's
password hash, suitable for offline cracking.

During this engagement, rmsecurity identified [N] account(s) with
preauthentication disabled: [LIST ACCOUNTS]. The AS-REP hash for
[ACCOUNT NAME] was cracked in [TIMEFRAME].

---

## Impact

An attacker with **no domain credentials** can:

1. Enumerate AS-REP roastable accounts (often via anonymous LDAP bind or a
   pre-built list)
2. Request and capture the encrypted AS-REP without authenticating
3. Crack the hash offline and gain valid domain credentials with zero
   prior access — making this attack the cheapest entry point into AD

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | impacket-GetNPUsers output showing roastable accounts |
| [EV-ID] | Hashcat output showing successful password recovery |

---

## Remediation

1. **Re-enable Kerberos preauthentication** for all affected accounts unless
   there is a documented, reviewed business reason not to:
   ```powershell
   Set-ADAccountControl -Identity [ACCOUNT] -DoesNotRequirePreAuth $false
   ```
2. If preauthentication must remain disabled, enforce a long random password
   (25+ characters) and monitor the account closely
3. Audit all accounts for this flag periodically:
   ```powershell
   Get-ADUser -Filter {DoesNotRequirePreAuth -eq $true} -Properties DoesNotRequirePreAuth
   ```

---

## References

- [MITRE T1558.004](https://attack.mitre.org/techniques/T1558/004/)
- [impacket GetNPUsers](https://github.com/fortra/impacket)
