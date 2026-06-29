# KB-NET-001 — LLMNR / NBT-NS Poisoning
### rmsecurity | 32-KNOWLEDGE-BASE

*Copy to engagement findings folder and replace all `[PLACEHOLDERS]`.*

---

**Finding ID:** FND-[ENG-ID]-[NNN]  
**Title:** LLMNR and NBT-NS Poisoning Allows Network Credential Capture  
**Severity:** High  
**CVSS v3.1:** 8.8 (AV:A/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H)  
**CWE:** CWE-294 (Authentication Bypass by Capture-replay)  
**MITRE ATT&CK:** T1557.001 — Adversary-in-the-Middle: LLMNR/NBT-NS Poisoning and SMB Relay  

---

## Description

The network is configured to use Link-Local Multicast Name Resolution (LLMNR)
and NetBIOS Name Service (NBT-NS). These protocols are used by Windows hosts
to resolve hostnames when DNS resolution fails. Both protocols broadcast
name resolution requests to the local network segment without authentication.

An attacker positioned on the network can respond to these broadcast requests
with a spoofed answer, directing the victim's authentication attempt to
attacker-controlled infrastructure. The resulting authentication handshake
contains the victim's NTLMv2 password hash, which the attacker captures for
offline cracking or relay attacks.

During this engagement, [DESCRIBE WHAT HAPPENED — e.g., "we ran Responder on
the internal network segment and captured NTLMv2 hashes for [N] accounts
within [TIMEFRAME], including the domain account [USERNAME]."]

---

## Impact

An attacker with access to the network (including a rogue device, a compromised
workstation, or an insider) can:

1. Capture password hashes for any network user who generates a failed DNS
   lookup during the attacker's session
2. Crack the NTLMv2 hashes offline using commodity hardware if the passwords
   are not sufficiently complex
3. Relay the captured hashes to other network services that accept NTLM
   authentication, potentially achieving unauthenticated access to servers,
   file shares, or other resources without needing to crack the hash

[ENGAGEMENT-SPECIFIC: During testing, the hash for [USERNAME] was cracked in
[TIMEFRAME], revealing the password [REDACTED/COMPLEXITY DESCRIPTION]. / The
captured hash was relayed to [TARGET] achieving [ACCESS LEVEL].]

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | Responder output showing captured NTLMv2 hash for [USERNAME] |
| [EV-ID] | Hashcat output showing successful password recovery |

---

## Remediation

**Short term — Compensating controls:**

Disable LLMNR via Group Policy:
- Computer Configuration → Administrative Templates → Network → DNS Client
- Set **"Turn Off Multicast Name Resolution"** to **Enabled**

Disable NBT-NS:
- Via DHCP server: set DHCP option 001 (Microsoft Disable NetBIOS option) to `0x2`
- Or: Network adapter → TCP/IP Properties → Advanced → WINS → **Disable NetBIOS over TCP/IP**

**Long term — Detection:**

Deploy monitoring for unexpected LLMNR/NBT-NS responses. Any response to these
queries from a host that is not the DNS server is anomalous and should alert.
Configure SIEM rule: `event.type = LLMNR_response AND source.ip NOT IN dns_server_list`.

---

## References

- [Microsoft: Disable LLMNR via GPO](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ee941151(v=ws.10))
- [MITRE ATT&CK T1557.001](https://attack.mitre.org/techniques/T1557/001/)
- [Responder tool](https://github.com/lgandx/Responder)
