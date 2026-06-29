# 26-INCIDENT-RESPONSE — Incident Response
### rmsecurity | CCOS

## Purpose

Playbooks for responding to active security incidents. IR is a distinct
service from pentesting — the client has an active compromise and needs
containment, eradication, and recovery, not simulated attacks.

## Directory Structure

```
26-INCIDENT-RESPONSE/
├── README.md
├── playbooks/
│   ├── ir-initial-triage.md     <- first 24 hours — scope the incident
│   └── ir-containment.md        <- contain, eradicate, recover
└── templates/
    └── ir-report-template.md    <- incident report structure
```

## IR Phases (NIST SP 800-61)

```
Preparation -> Detection -> Containment -> Eradication ->
Recovery -> Post-Incident Review
```

## Engagement Types

| Type | Trigger | SLA |
|------|---------|-----|
| Retainer (proactive) | Scheduled — client has rmsecurity on retainer | 4-hour response |
| Ad-hoc emergency | Active breach — client calls us | Best effort (same day) |

## Critical Rule

**Never perform IR remotely without a signed SOW.** Verbal authorization
is not sufficient for IR work — you may be accessing systems with legal
implications. Get the SOW signed even if it takes an extra hour.

## Related Domains

- `14-SERVICE-CATALOG/services/incident-response.md` — service definition
- `27-FORENSICS/` — forensic analysis follows containment
