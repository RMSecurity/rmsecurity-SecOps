# MITRE ATT&CK Usage Standard
### rmsecurity | 01-STANDARDS

## Purpose

rmsecurity maps all findings and techniques to the MITRE ATT&CK framework.
This provides a common language for adversary behavior that clients,
SOC teams, and detection engineers understand.

Reference: https://attack.mitre.org

---

## When to Reference MITRE ATT&CK

| Scenario | Requirement |
|---------|------------|
| Penetration test finding | Required — map exploitation technique to ATT&CK |
| Red team engagement | Required — map every TTP used |
| Incident response | Required — map attacker activity to ATT&CK |
| Security assessment gap | Optional — map control gaps to ATT&CK mitigations |
| Threat intelligence report | Required — map IOCs and behaviors to ATT&CK |

---

## Format in Findings

In the finding template, the MITRE ATT&CK field uses this format:

```
| MITRE ATT&CK | TNNNN.NNN — Technique Name |
```

Examples:
```
| MITRE ATT&CK | T1110.001 — Brute Force: Password Guessing |
| MITRE ATT&CK | T1078 — Valid Accounts |
| MITRE ATT&CK | T1003.001 — OS Credential Dumping: LSASS Memory |
| MITRE ATT&CK | T1021.002 — Remote Services: SMB/Windows Admin Shares |
```

If multiple techniques apply, list them on separate lines.

---

## Key Tactics and Techniques for Common Findings

### Reconnaissance
| Technique | ID | Description |
|---------|---|------------|
| Active Scanning | T1595 | Nmap, masscan port scanning |
| Search Open Websites | T1593 | OSINT via LinkedIn, Shodan |
| DNS queries | T1590.002 | DNS enumeration |

### Initial Access
| Technique | ID | Description |
|---------|---|------------|
| Exploit Public-Facing Application | T1190 | Web app vulns, VPN exploits |
| Phishing | T1566 | Email phishing campaigns |
| Valid Accounts | T1078 | Default or compromised credentials |
| External Remote Services | T1133 | VPN, RDP, Citrix access |

### Execution
| Technique | ID | Description |
|---------|---|------------|
| Command and Scripting Interpreter | T1059 | PowerShell, cmd, bash |
| Exploitation for Client Execution | T1203 | Browser/app exploits |

### Privilege Escalation
| Technique | ID | Description |
|---------|---|------------|
| Exploitation for Privilege Escalation | T1068 | Local privesc CVEs |
| Access Token Manipulation | T1134 | Token impersonation |
| Abuse Elevation Control Mechanism | T1548 | UAC bypass |

### Credential Access
| Technique | ID | Description |
|---------|---|------------|
| OS Credential Dumping | T1003 | Mimikatz, LSASS dump |
| Brute Force | T1110 | Password spraying, credential stuffing |
| Kerberoasting | T1558.003 | SPN ticket cracking |
| AS-REP Roasting | T1558.004 | Pre-auth not required accounts |

### Lateral Movement
| Technique | ID | Description |
|---------|---|------------|
| Remote Services: SMB | T1021.002 | Pass the hash, SMB relay |
| Remote Services: RDP | T1021.001 | Lateral via RDP |
| Pass the Hash | T1550.002 | NTLM hash reuse |
| Pass the Ticket | T1550.003 | Kerberos ticket reuse |

### Persistence
| Technique | ID | Description |
|---------|---|------------|
| Account Creation | T1136 | Backdoor accounts |
| Scheduled Task/Job | T1053 | Persistence via tasks |
| Boot/Logon Autostart | T1547 | Registry run keys |

### Exfiltration
| Technique | ID | Description |
|---------|---|------------|
| Exfiltration Over C2 Channel | T1041 | Data out via C2 |
| Exfiltration Over Web Service | T1567 | Cloud storage upload |

---

## ATT&CK Navigator

For red team engagements, produce an ATT&CK Navigator layer file showing
which techniques were used. Export as JSON and attach to the engagement report.

Navigator: https://mitre-attack.github.io/attack-navigator/
