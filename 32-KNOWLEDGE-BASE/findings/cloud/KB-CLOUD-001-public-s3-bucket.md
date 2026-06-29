# KB-CLOUD-001 — Publicly Accessible S3 Bucket / Azure Blob Container
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]  
**Title:** Publicly Accessible Cloud Storage Contains [DATA TYPE]  
**Severity:** Critical / High *(Critical if sensitive data confirmed; High if exposed but empty/non-sensitive)*  
**CVSS v3.1 (sensitive data):** 9.1 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)  
**CWE:** CWE-732 (Incorrect Permission Assignment for Critical Resource)  
**MITRE ATT&CK:** T1530 — Data from Cloud Storage  

---

## Description

The [AWS S3 bucket / Azure Blob container] `[BUCKET/CONTAINER NAME]` is
configured to allow unauthenticated public read access. Any person on the
internet can enumerate and download the contents of this storage object
without credentials.

[DESCRIBE CONTENTS: e.g., "The bucket contains [N] files including backup
archives, customer export files, and application configuration files."]

This misconfiguration commonly results from developers temporarily enabling
public access for testing purposes and failing to revert the setting, or
from overly permissive bucket policies applied during initial provisioning.

---

## Impact

Any unauthenticated user on the internet can:

1. List all objects in the bucket (`[BUCKET_URL]?list-type=2`)
2. Download any object without authentication
3. [IF SENSITIVE DATA]: Access [PII / credentials / intellectual property /
   backup data / configuration files containing secrets]

[DATA FOUND — describe categories without including actual data]:
- [e.g., "Customer records including names and email addresses"]
- [e.g., "Application configuration files containing database connection strings"]
- [e.g., "Database backup files"]

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | Unauthenticated bucket listing showing contents |
| [EV-ID] | Screenshot of file download without authentication |
| [EV-ID] | Sample of file types/names showing sensitive nature (no actual data) |

---

## Remediation

**Immediate (within 24 hours):**

1. Enable "Block all public access" at the bucket level:

   **AWS:**
   ```bash
   aws s3api put-public-access-block \
     --bucket [BUCKET_NAME] \
     --public-access-block-configuration \
       "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
   ```

   **Azure:**
   ```bash
   az storage account update \
     --name [STORAGE_ACCOUNT] \
     --allow-blob-public-access false
   ```

2. Review bucket/container ACLs and policies and remove any public grants

3. Rotate any credentials or secrets found in the exposed files immediately

4. Notify your data protection officer if personal data was exposed (GDPR/
   applicable regulation may require breach notification)

**Long term:**

1. Enable AWS S3 Block Public Access at the account level (prevents future
   accidental public exposure on any bucket):
   ```bash
   aws s3control put-public-access-block \
     --account-id [ACCOUNT_ID] \
     --public-access-block-configuration \
       "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
   ```

2. Enable AWS Config rule `s3-bucket-public-read-prohibited` to continuously
   detect and alert on public S3 buckets

3. Store secrets and credentials in a dedicated secrets manager (AWS Secrets
   Manager, Azure Key Vault) — never in storage objects

---

## References

- [AWS: Blocking public access to S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
- [MITRE T1530](https://attack.mitre.org/techniques/T1530/)
- [CWE-732](https://cwe.mitre.org/data/definitions/732.html)
