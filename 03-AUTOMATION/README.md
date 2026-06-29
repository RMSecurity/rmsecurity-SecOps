# 03-AUTOMATION — Engagement Automation
### rmsecurity | CCOS Layer 0: Infrastructure

Scripts and tools that wire the CCOS together — reducing repetitive work
and enforcing consistency across every engagement.

---

## What Lives Here

```
03-AUTOMATION/
├── scripts/
│   ├── new-engagement.ps1      # Scaffold a new engagement directory
│   ├── finding-add.ps1         # Add a finding to an engagement
│   ├── evidence-register.ps1   # Register evidence and compute SHA-256
│   ├── gate-check.ps1          # Validate Quality Gate requirements
│   └── close-engagement.ps1    # Run closure checklist
├── templates/
│   └── engagement-scaffold/    # Directory tree cloned by new-engagement.ps1
└── README.md
```

---

## Scripts

| Script | Purpose | When to Run |
|--------|---------|------------|
| `new-engagement.ps1` | Create engagement directory from scaffold | After SOW is signed |
| `finding-add.ps1` | Add finding with auto-generated FND-ID | During testing |
| `evidence-register.ps1` | Hash file and append to manifest | When collecting evidence |
| `gate-check.ps1` | Verify gate requirements before proceeding | At each quality gate |
| `close-engagement.ps1` | Walk through closure checklist | After report delivery |

---

## Quick Start

```powershell
# New engagement
.\scripts\new-engagement.ps1 -ClientName "Acme Corp" -Type "Internal Pentest"

# Add a finding
.\scripts\finding-add.ps1 -EngID "ENG-2025-001" -Title "LLMNR Poisoning" -Severity "High"

# Register evidence
.\scripts\evidence-register.ps1 -EngID "ENG-2025-001" -File "C:\evidence\responder.txt"

# Check Quality Gate 1
.\scripts\gate-check.ps1 -EngID "ENG-2025-001" -Gate 1
```
