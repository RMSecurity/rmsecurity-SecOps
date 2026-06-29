# 27-FORENSICS — Digital Forensics
### rmsecurity | CCOS

## Purpose

Procedures for forensic analysis following a security incident. Forensics
establishes what happened, when, how, and what data was accessed — the
evidentiary basis for the incident report and any legal action.

## Directory Structure

```
27-FORENSICS/
├── README.md
└── playbooks/
    └── disk-forensics.md    <- disk image acquisition and analysis
```

## Forensics Principles

1. **Preserve before analyze** — image the disk, analyze the image, never the original
2. **Document everything** — timestamps, chain of custody, every tool run
3. **Volatility order** — RAM > running processes > network state > disk
4. **No contamination** — never run tools on the live system that modify artifacts

## When to Involve Forensics

- Ransomware incident (timeline reconstruction)
- Data breach (what was exfiltrated, how long was access)
- Insider threat (activity reconstruction)
- Legal hold (preserve evidence for litigation)

## Related Domains

- `26-INCIDENT-RESPONSE/` — forensics follows IR containment
- `40-EVIDENCE/` — evidence chain of custody applies to forensic artifacts
