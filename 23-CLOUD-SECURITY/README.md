# 23-CLOUD-SECURITY — Cloud Security Assessment
### rmsecurity | CCOS

## Purpose

Playbooks for assessing cloud environments: AWS, Azure, and Microsoft 365.
Cloud assessments focus on identity and access misconfigurations, exposed storage,
overprivileged roles, and insecure workloads.

## Directory Structure

```
23-CLOUD-SECURITY/
├── README.md
├── playbooks/
│   ├── aws-assessment.md          <- AWS IAM, S3, EC2, Lambda assessment
│   └── azure-m365-assessment.md   <- Azure AD, M365, storage, workloads
└── tools/
    └── cloud-toolkit.md           <- tool reference (ScoutSuite, Prowler, etc.)
```

## Engagement Types

| Type | Scope | Credentials |
|------|-------|-------------|
| External cloud attack surface | Public buckets, APIs, exposed services | None |
| IAM / posture assessment | IAM policies, roles, permissions | Read-only credentials provided |
| Full cloud pentest | Exploit misconfigs, escalate, pivot | Start with limited user |

## Related Domains

- `22-PENTESTING/` — cloud pentest overlaps with network pentest
- `14-SERVICE-CATALOG/services/assessment-cloud.md` — service definition
