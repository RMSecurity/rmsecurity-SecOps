# CVSS Scoring Standard
### rmsecurity | 01-STANDARDS

## Standard

rmsecurity uses **CVSS v3.1** (Common Vulnerability Scoring System version 3.1)
as the baseline for all finding severity scores.

Calculator: https://www.first.org/cvss/calculator/3.1

---

## Required Fields

Every finding with a CVSS score must include:

1. The numeric score (e.g., `8.8`)
2. The full vector string (e.g., `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H`)
3. Any business context adjustment and reason (see `risk-classification.md`)

Format in the finding file:

```
| CVSS Score | 8.8 (CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) |
```

---

## Base Metric Groups

### Attack Vector (AV)
| Value | Label | Description |
|-------|-------|------------|
| N | Network | Exploitable remotely over the network |
| A | Adjacent | Requires access to the same network segment |
| L | Local | Requires local access |
| P | Physical | Requires physical access |

### Attack Complexity (AC)
| Value | Label | Description |
|-------|-------|------------|
| L | Low | No special conditions required |
| H | High | Requires specific configuration or race condition |

### Privileges Required (PR)
| Value | Label | Description |
|-------|-------|------------|
| N | None | No authentication required |
| L | Low | Standard user account |
| H | High | Administrative account |

### User Interaction (UI)
| Value | Label | Description |
|-------|-------|------------|
| N | None | No user interaction needed |
| R | Required | A user must take an action |

### Scope (S)
| Value | Label | Description |
|-------|-------|------------|
| U | Unchanged | Impact limited to the vulnerable component |
| C | Changed | Impact extends beyond the vulnerable component |

### Confidentiality / Integrity / Availability Impact (C/I/A)
| Value | Label | Description |
|-------|-------|------------|
| N | None | No impact |
| L | Low | Limited impact |
| H | High | Total loss or complete impact |

---

## Common Finding Score Reference

| Scenario | Example Score | Vector |
|---------|--------------|--------|
| Unauthenticated RCE, internet-facing | 9.8 | AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H |
| Authenticated RCE | 8.8 | AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H |
| SQL injection (data exfil) | 8.6 | AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:L/A:N |
| Stored XSS | 6.1 | AV:N/AC:L/PR:N/UI:R/S:C/C:L/I:L/A:N |
| Missing MFA on admin account | 7.2 | AV:N/AC:L/PR:H/UI:N/S:U/C:H/I:H/A:H |
| Weak password policy | 4.3 | AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N |
| Missing security headers | 3.7 | AV:N/AC:H/PR:N/UI:R/S:U/C:L/I:L/A:N |

---

## Informational Findings

Informational findings do not receive a CVSS score.
Set the CVSS field to `N/A — Informational`.
