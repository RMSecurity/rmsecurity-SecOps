# 33-RESEARCH-LAB — Research Lab
### rmsecurity | CCOS

## Purpose

Structured space for evaluating new tools, developing proof-of-concept
exploits, and documenting research findings. Research here feeds into
playbooks and the knowledge base.

## Directory Structure

```
33-RESEARCH-LAB/
├── README.md
└── templates/
    └── research-note-template.md   <- standardized note for tool/technique research
```

## Research Categories

| Category | Description |
|---------|-------------|
| Tool evaluation | Testing new offensive/defensive tools for inclusion in toolkit |
| CVE research | Reproducing publicly disclosed vulnerabilities for engagements |
| Technique development | Building custom scripts or adapting public PoCs |
| Detection bypass | Researching AV/EDR evasion for red team engagements |

## Lab Rules

- Research happens in isolated VMs — never on the host machine
- PoC code goes in `33-RESEARCH-LAB/` only — never in playbooks
- If a PoC is ready for use in engagements, it moves to `22-PENTESTING/tools/`
- Malware samples: hash only in the repo; binaries in encrypted store
