# 20-RECON-OSINT — Reconnaissance & OSINT
### rmsecurity | CCOS

## Purpose

Reconnaissance is the first phase of every engagement. This domain contains
the methodology, tool usage, and procedures for gathering intelligence on a
target without alerting them (passive) and through direct probing (active).

## Directory Structure

```
20-RECON-OSINT/
├── README.md
├── playbooks/
│   ├── passive-recon.md     <- OSINT without touching target infrastructure
│   └── active-recon.md      <- direct probing — ports, services, DNS
└── tools/
    └── osint-toolkit.md     <- tool reference with commands
```

## Recon Phases

```
Passive OSINT -> DNS Enumeration -> Network Mapping -> Service Discovery ->
Technology Fingerprinting -> (feeds into 22-PENTESTING)
```

## Key Rules

- Never touch out-of-scope targets — confirm scope before any active recon
- All recon output goes to `01-recon/` in the engagement folder
- Passive recon leaves no logs on target infrastructure — always start here
- Document every tool run with timestamp and full command

## Related Domains

- `22-PENTESTING/` — recon feeds directly into pentest phases
- `40-EVIDENCE/` — all recon output is evidence
