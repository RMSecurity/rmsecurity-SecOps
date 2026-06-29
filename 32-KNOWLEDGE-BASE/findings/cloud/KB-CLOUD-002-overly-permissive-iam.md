# KB-CLOUD-002 — Overly Permissive IAM Policy
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** IAM [Role/User] Holds Excessive Privileges ([Action])
**Severity:** Critical / High *(Critical if full admin / privilege escalation path exists)*
**CVSS v3.1:** 8.6 (AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:H/A:L)
**CWE:** CWE-269 (Improper Privilege Management)
**MITRE ATT&CK:** T1078.004 — Valid Accounts: Cloud Accounts

---

## Description

The IAM [role / user / group] `[NAME]` is attached to a policy granting
[`*:*` / overly broad wildcard actions / specific dangerous permissions such
as `iam:PassRole` + `lambda:CreateFunction`]. This violates the principle of
least privilege and, depending on the specific permission combination, may
allow privilege escalation to full administrative control of the AWS/Azure/GCP
account.

**Policy excerpt:**
```json
{
  "Effect": "Allow",
  "Action": "[ACTION]",
  "Resource": "*"
}
```

During this engagement, rmsecurity used the credentials for [PRINCIPAL] to
[DESCRIBE — e.g., "create a new IAM user with AdministratorAccess",
"assume a higher-privileged role via sts:AssumeRole", "modify a Lambda
function's execution role to escalate privileges"], achieving
[FINAL ACCESS LEVEL].

---

## Impact

A holder of these credentials (including via SSRF, leaked access keys, or
a compromised application using this role) can:

1. [SPECIFIC IMPACT BASED ON PERMISSIONS — e.g., "Escalate to full account
   administrator via iam:CreatePolicyVersion", "Read/modify all S3 buckets
   account-wide", "Launch arbitrary EC2 instances incurring cost and
   providing a foothold"]
2. Pivot to other AWS services and potentially other accounts via assumed roles
3. Persist access by creating new credentials or backdoor IAM entities

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | IAM policy document showing the overly broad grant |
| [EV-ID] | Output of privilege escalation proof-of-concept (e.g., Pacu, PMapper) |

---

## Remediation

**Mandatory:**

1. Apply least privilege — replace wildcard actions/resources with the
   specific actions and ARNs actually required:
   ```json
   {
     "Effect": "Allow",
     "Action": ["s3:GetObject", "s3:PutObject"],
     "Resource": "arn:aws:s3:::specific-bucket/*"
   }
   ```
2. Use AWS IAM Access Analyzer to identify unused permissions and generate
   a least-privilege policy based on actual CloudTrail activity
3. Remove or restrict dangerous permission combinations known to enable
   privilege escalation (`iam:PassRole` + service that can assume roles,
   `iam:CreatePolicyVersion`, `iam:AttachUserPolicy`, etc.) — see the
   referenced privilege escalation matrix

**Detection:**

- Enable AWS Config rule `iam-policy-no-statements-with-admin-access`
- Run a privilege escalation scanner (PMapper, Pacu) quarterly against the account

---

## References

- [AWS IAM Privilege Escalation Methods (Rhino Security)](https://rhinosecuritylabs.com/aws/aws-privilege-escalation-methods-mitigation/)
- [AWS IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)
- [CWE-269](https://cwe.mitre.org/data/definitions/269.html)
