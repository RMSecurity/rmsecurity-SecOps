# 31-RISK-MANAGEMENT — Risk Management
### rmsecurity | CCOS

## Purpose

Methodology and templates for translating technical findings into business
risk language, and for helping clients build and maintain a risk register.
Risk management is the bridge between what we find and what the client prioritizes.

## Directory Structure

```
31-RISK-MANAGEMENT/
├── README.md
├── methodology/
│   └── risk-scoring.md         <- how rmsecurity calculates and communicates risk
└── templates/
    └── risk-register-template.md  <- client-facing risk register structure
```

## Risk vs Vulnerability

| Concept | Definition | Owner |
|---------|-----------|-------|
| Vulnerability | Technical weakness (CVSS score) | IT / Security |
| Risk | Likelihood × Impact to business | CISO / Leadership |
| Finding | rmsecurity confirmed vulnerability with evidence | rmsecurity |
| Risk Register item | Finding translated to business risk with residual risk tracking | Client |

## Related Domains

- `01-STANDARDS/frameworks/risk-classification.md` — severity framework
- `43-REMEDIATION/` — risk register drives remediation prioritization
- `42-EXECUTIVE-REPORTING/` — executive summary presents top risks
