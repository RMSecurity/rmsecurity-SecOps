# Service: Cloud Security Assessment
### rmsecurity | 14-SERVICE-CATALOG | Code: ASSESS-CLOUD

## Description

Comprehensive review of an organization's cloud environment, identity
configuration, and security controls. Covers misconfigurations, excessive
permissions, data exposure risks, and gaps against cloud security benchmarks.

Specialization: Microsoft Azure, Microsoft 365, and Entra ID.
AWS and GCP available on request.

---

## What Is Included

### Microsoft 365 / Entra ID

| Area | What is reviewed |
|------|----------------|
| Entra ID (Azure AD) | User accounts, MFA enrollment, Conditional Access Policies, privileged roles |
| Exchange Online | Anti-spam, anti-phishing, mail flow rules, external forwarding |
| SharePoint / OneDrive | External sharing, sensitivity labels, overly permissive access |
| Teams | Guest access, external sharing, information barriers |
| Intune / Endpoint | Device compliance policies, app protection policies |
| Defender for 365 | Safe Links, Safe Attachments, coverage gaps |
| Microsoft Secure Score | Baseline assessment and improvement roadmap |
| Privileged Identity Management | PIM configuration, just-in-time access review |

### Azure Infrastructure (if in scope)

| Area | What is reviewed |
|------|----------------|
| IAM / RBAC | Over-permissioned roles, owner assignments, service principals |
| Network Security Groups | Overly permissive rules, internet exposure |
| Storage Accounts | Public access, encryption, SAS token exposure |
| Key Vault | Access policies, soft delete, purge protection |
| Logging / SIEM | Diagnostic settings, Log Analytics, Microsoft Sentinel coverage |
| Defender for Cloud | Secure Score, recommendations, unmonitored resources |

---

## Access Requirements

| Access type | Permission level | Purpose |
|------------|----------------|---------|
| Entra ID | Global Reader | Read-only review of all identity configuration |
| Exchange | Exchange Administrator (read-only) | Mail flow and protection review |
| Azure | Reader on subscription(s) | Infrastructure configuration review |
| Defender for Cloud | Security Reader | Posture review |

All access is read-only. No changes are made to the environment.
A dedicated review account is created and removed after the engagement.

---

## Deliverables

| Deliverable | Format | Timeline |
|------------|--------|---------|
| Cloud Security Assessment Report | PDF + DOCX | Within 5 business days |
| Executive Summary | PDF | Same delivery |
| Hardening Roadmap | XLSX (prioritized) | Same delivery |
| Microsoft Secure Score baseline | Included in report | — |
| Retest (90 days) | Included | On client request after remediation |

---

## Typical Findings

- MFA not enforced for all users (especially admins)
- Missing or misconfigured Conditional Access Policies
- Over-permissioned global administrators
- Legacy authentication protocols enabled
- External email forwarding rules present
- SharePoint with anonymous external sharing enabled
- Azure storage accounts with public blob access
- Service principals with excessive subscription-level permissions
- No Privileged Identity Management (PIM) for admin roles
- Missing logging on critical Entra ID operations
- Defender for 365 not fully configured or licensed
