# AWS Security Assessment Playbook
### rmsecurity | 23-CLOUD-SECURITY

*Requires: SecurityAudit IAM policy (AWS managed) at minimum.
For full assessment: SecurityAudit + ReadOnlyAccess.*

---

## Phase 0 — Setup

```bash
ENG_ID="ENG-YYYY-NNN"
SCAN_DIR="$ENGAGEMENT_STORE/$ENG_ID/02-scans/aws"
mkdir -p "$SCAN_DIR"

# Configure credentials (use dedicated assessment profile)
aws configure --profile rmsec-assessment
# Enter: Access Key ID, Secret Access Key, Region

export AWS_PROFILE=rmsec-assessment

# Verify access
aws sts get-caller-identity | tee "$SCAN_DIR/caller-identity.json"
```

---

## Phase 1 — Account Reconnaissance

```bash
# Account info
aws iam get-account-summary | tee "$SCAN_DIR/account-summary.json"
aws iam get-account-password-policy | tee "$SCAN_DIR/password-policy.json"

# Check for MFA on root account
cat "$SCAN_DIR/account-summary.json" | python3 -c \
  "import sys,json; d=json.load(sys.stdin); print('Root MFA:', d['SummaryMap'].get('AccountMFAEnabled','0'))"

# List all users
aws iam list-users \
  --query 'Users[].{User:UserName,Created:CreateDate,PasswordLastUsed:PasswordLastUsed}' \
  -o table | tee "$SCAN_DIR/iam-users.txt"

# Find users with console access but no MFA
aws iam list-users --query 'Users[].UserName' --output text | tr '\t' '\n' | while read user; do
  mfa=$(aws iam list-mfa-devices --user-name "$user" --query 'MFADevices | length(@)')
  login=$(aws iam get-login-profile --user-name "$user" 2>/dev/null && echo "yes" || echo "no")
  [ "$login" = "yes" ] && echo "$user: console=$login mfa=$mfa"
done | tee "$SCAN_DIR/users-no-mfa.txt"
```

---

## Phase 2 — IAM Assessment

```bash
# Get IAM credential report (access keys, MFA, last use)
aws iam generate-credential-report
sleep 10
aws iam get-credential-report \
  --query 'Content' --output text | base64 -d > "$SCAN_DIR/credential-report.csv"

# Key checks in credential report:
# - root_account_mfa_active = false → CRITICAL
# - access_key_1_last_used_date = N/A (old key never used) → rotate
# - password_last_used = N/A or > 90 days → inactive users
# - mfa_active = false and password_enabled = true → no MFA

# Users with admin policies
aws iam list-users --query 'Users[].UserName' --output text | tr '\t' '\n' | while read user; do
  policies=$(aws iam list-attached-user-policies --user-name "$user" \
    --query 'AttachedPolicies[].PolicyName' --output text 2>/dev/null)
  groups=$(aws iam list-groups-for-user --user-name "$user" \
    --query 'Groups[].GroupName' --output text 2>/dev/null)
  echo "User: $user | Policies: $policies | Groups: $groups"
done | tee "$SCAN_DIR/iam-user-policies.txt"

# Inline policies (often dangerous — custom permissions)
aws iam list-users --query 'Users[].UserName' --output text | tr '\t' '\n' | while read user; do
  inline=$(aws iam list-user-policies --user-name "$user" \
    --query 'PolicyNames' --output text)
  [ -n "$inline" ] && echo "INLINE POLICY — User: $user | Policies: $inline"
done

# Check for AdministratorAccess policy attachments
aws iam list-entities-for-policy \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess \
  | tee "$SCAN_DIR/admin-policy-users.json"
```

---

## Phase 3 — S3 Bucket Assessment

```bash
# List all buckets
aws s3api list-buckets \
  --query 'Buckets[].Name' --output text | tr '\t' '\n' > "$SCAN_DIR/buckets.txt"

# Check public access block settings per bucket
cat "$SCAN_DIR/buckets.txt" | while read bucket; do
  result=$(aws s3api get-public-access-block --bucket "$bucket" 2>/dev/null || echo "NO_BLOCK")
  echo "$bucket: $result"
done | tee "$SCAN_DIR/bucket-public-access.txt"

# Check bucket ACLs
cat "$SCAN_DIR/buckets.txt" | while read bucket; do
  aws s3api get-bucket-acl --bucket "$bucket" \
    --query 'Grants[?Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`]' \
    2>/dev/null | grep -q "FULL_CONTROL\|READ" && echo "PUBLIC: $bucket"
done | tee "$SCAN_DIR/public-buckets.txt"

# Check bucket policies for public read
cat "$SCAN_DIR/buckets.txt" | while read bucket; do
  policy=$(aws s3api get-bucket-policy --bucket "$bucket" 2>/dev/null)
  [ -n "$policy" ] && echo "$bucket" && echo "$policy" | python3 -m json.tool
done | tee "$SCAN_DIR/bucket-policies.txt"

# Attempt unauthenticated access to each bucket
cat "$SCAN_DIR/buckets.txt" | while read bucket; do
  result=$(aws s3 ls "s3://$bucket" --no-sign-request 2>&1)
  echo "[$bucket] $result"
done | tee "$SCAN_DIR/bucket-anon-access.txt"
```

---

## Phase 4 — EC2 & Network Assessment

```bash
# All regions scan
for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); do
  echo "=== $region ===" >> "$SCAN_DIR/ec2-all-regions.txt"
  aws ec2 describe-instances --region $region \
    --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,PublicIP:PublicIpAddress,Type:InstanceType}' \
    -o table 2>/dev/null >> "$SCAN_DIR/ec2-all-regions.txt"
done

# Security groups with dangerous rules
aws ec2 describe-security-groups \
  --query 'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`] || Ipv6Ranges[?CidrIpv6==`::/0`]]].{Name:GroupName,ID:GroupId,Rules:IpPermissions}' \
  -o json | tee "$SCAN_DIR/sg-open-ingress.json"

# Flag: 0.0.0.0/0 on port 22, 3389, 5432, 3306, 6379 = high risk

# EBS snapshots (can contain sensitive data if public)
aws ec2 describe-snapshots --owner self \
  --query 'Snapshots[].{ID:SnapshotId,Description:Description,Public:Public}' \
  -o table | tee "$SCAN_DIR/ebs-snapshots.txt"

# Public snapshots = data exposure risk
aws ec2 describe-snapshots \
  --filters "Name=attribute,Values=createVolumePermission" \
    "Name=attribute-value,Values=all" \
  | tee "$SCAN_DIR/public-snapshots.json"
```

---

## Phase 5 — Prowler Automated Assessment

```bash
# Prowler — comprehensive AWS security benchmark (CIS, AWS Foundational)
prowler aws \
  --profile rmsec-assessment \
  -M html,json \
  -o "$SCAN_DIR/prowler/" \
  --compliance aws_foundational_security_best_practices_aws

# Review HTML report — prioritize CRITICAL and HIGH findings
# Screenshot each confirmed finding as evidence
```

---

## Common AWS Findings Reference

| Finding | Severity | Service |
|---------|---------|---------|
| Root account access keys exist | Critical | IAM |
| Root account no MFA | Critical | IAM |
| IAM user with AdministratorAccess, no MFA | Critical | IAM |
| Public S3 bucket with sensitive data | Critical | S3 |
| S3 bucket world-readable | High | S3 |
| Security group: 0.0.0.0/0 on port 22/3389 | High | EC2 |
| Public EBS snapshot | High | EC2 |
| CloudTrail disabled | High | Logging |
| No MFA on IAM users with console access | High | IAM |
| Access keys not rotated > 90 days | Medium | IAM |
| GuardDuty not enabled | Medium | Detection |
| S3 versioning disabled on sensitive buckets | Medium | S3 |
| No VPC Flow Logs | Medium | Logging |
| IAM password policy weak | Low | IAM |
