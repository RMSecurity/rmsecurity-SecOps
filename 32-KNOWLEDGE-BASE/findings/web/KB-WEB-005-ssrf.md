# KB-WEB-005 — Server-Side Request Forgery (SSRF)
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** SSRF in [FEATURE] Allows Access to Internal Services
**Severity:** High / Critical *(Critical if cloud metadata or internal admin access achieved)*
**CVSS v3.1:** 8.6 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:L/A:N)
**CWE:** CWE-918 (Server-Side Request Forgery)
**MITRE ATT&CK:** T1190 — Exploit Public-Facing Application

---

## Description

The [FEATURE — e.g., "URL preview", "webhook configuration", "PDF export
from URL", "image fetch from URL"] feature at [ENDPOINT] accepts a
user-supplied URL and makes a server-side HTTP request to it without
adequately validating or restricting the destination. An attacker can
supply an internal or cloud-metadata URL, causing the application server
to make requests on the attacker's behalf to destinations that should not
be reachable from the internet.

**Payload used:** `[URL SUPPLIED — e.g., http://169.254.169.254/latest/meta-data/iam/security-credentials/]`

During this engagement, rmsecurity used this feature to access
[DESCRIBE — e.g., "the AWS instance metadata service, retrieving temporary
IAM credentials for the EC2 instance role", "an internal admin panel not
exposed to the internet at http://10.0.0.5:8080/admin"].

---

## Impact

An attacker can:

1. Access internal services not exposed to the internet (admin panels,
   internal APIs, databases on internal-only ports), bypassing network
   segmentation entirely
2. **Cloud environments:** retrieve instance metadata, including temporary
   IAM credentials, often leading to full cloud account compromise
3. Port-scan the internal network from the server's vantage point
4. In some cases, escalate to Remote Code Execution by reaching internal
   services with known vulnerabilities (Redis, internal management APIs)

[ENGAGEMENT-SPECIFIC IMPACT — describe what was actually reached and what
access it provided]

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | Request showing SSRF payload and response containing internal data |
| [EV-ID] | [If cloud metadata] Response showing IAM role credentials (redact secret) |

---

## Remediation

**Mandatory:**

1. **Allowlist destinations** — only permit requests to a pre-approved set
   of domains/IPs; reject everything else by default
2. **Block requests to private IP ranges and metadata endpoints** at the
   application layer:
   ```python
   import ipaddress
   BLOCKED_RANGES = [
       ipaddress.ip_network("169.254.0.0/16"),   # link-local / metadata
       ipaddress.ip_network("10.0.0.0/8"),
       ipaddress.ip_network("172.16.0.0/12"),
       ipaddress.ip_network("192.168.0.0/16"),
       ipaddress.ip_network("127.0.0.0/8"),
   ]
   ```
3. **Disable URL redirects** when making the server-side request, or
   re-validate the destination after each redirect (attackers bypass
   allowlists via open redirects)
4. **Cloud-specific:** enforce IMDSv2 on AWS (requires a token, mitigates
   basic SSRF-to-metadata attacks):
   ```bash
   aws ec2 modify-instance-metadata-options --instance-id [ID] \
     --http-tokens required --http-endpoint enabled
   ```

**Defense-in-depth:**

- Run the request-making service with a dedicated, minimally-privileged
  network identity / IAM role
- Use a network proxy/firewall to enforce egress restrictions independent
  of application logic

---

## References

- [OWASP SSRF Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
- [AWS IMDSv2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html)
- [CWE-918](https://cwe.mitre.org/data/definitions/918.html)
