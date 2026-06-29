# 40-EVIDENCE — Evidence Management
### rmsecurity | CCOS

## Purpose

Defines how every piece of evidence is collected, named, hashed, stored,
and referenced across all technical engagements. Forensic integrity and
chain of custody are non-negotiable — a finding without traceable evidence
is an opinion, not a finding.

## Directory Structure

```
40-EVIDENCE/
├── README.md
├── procedures/
│   ├── collection-procedure.md    ← how to collect and hash evidence
│   └── retention-policy.md        ← how long evidence is kept and how it is destroyed
└── templates/
    └── manifest-template.csv      ← chain of custody manifest template
```

## Core Rules

1. Every piece of evidence gets a unique ID: `EV-[ENG-ID]-NNN`
2. Every evidence file is SHA-256 hashed immediately at collection
3. The hash is logged in `manifest.csv` before the file is moved or copied
4. Original files are never modified — annotations go in separate copies
5. Evidence lives in the encrypted engagement store, never in this repo

## Related Domains

- `01-STANDARDS/naming-conventions/evidence-ids.md` — ID format
- `02-QUALITY/checklists/checklist-evidence.md` — quality controls
- `00-PLATFORM/docs/client-data-architecture.md` — where evidence is stored
- `41-REPORTING` — evidence is referenced in technical reports
