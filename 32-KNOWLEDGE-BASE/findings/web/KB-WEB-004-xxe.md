# KB-WEB-004 — XML External Entity (XXE) Injection
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** XXE Injection in [ENDPOINT] Allows File Disclosure / SSRF
**Severity:** High / Critical *(Critical if leads to RCE or cloud metadata access)*
**CVSS v3.1 (file disclosure):** 7.5 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)
**CVSS v3.1 (SSRF to internal services):** 9.1 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)
**CWE:** CWE-611 (Improper Restriction of XML External Entity Reference)
**MITRE ATT&CK:** T1190 — Exploit Public-Facing Application

---

## Description

The [ENDPOINT] endpoint accepts and parses XML input (e.g., a file upload,
SOAP request, or API payload) using an XML parser configured to resolve
external entities. An attacker can define a malicious DOCTYPE declaration
that instructs the parser to read local files or make outbound network
requests on the server's behalf.

**Payload used:**
```xml
<?xml version="1.0"?>
<!DOCTYPE root [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>
<root>&xxe;</root>
```

During this engagement, rmsecurity used this technique to read
[FILE — e.g., "/etc/passwd", "web.config", "application configuration
containing database credentials"] from the server.

---

## Impact

An attacker can:

1. Read arbitrary files from the server's filesystem, including
   application source code, configuration files, and credentials
2. Perform Server-Side Request Forgery (SSRF) by directing the XML parser
   to make requests to internal-only services or cloud metadata endpoints
   (`http://169.254.169.254/` on AWS/Azure/GCP), potentially extracting
   cloud credentials
3. In some configurations (e.g., PHP `expect://` wrapper), achieve remote
   code execution
4. Cause denial of service via the "billion laughs" entity expansion attack

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | XXE payload and response showing file contents disclosed |
| [EV-ID] | [If SSRF achieved] Response showing internal service or metadata reached |

---

## Remediation

**Mandatory — disable external entity resolution:**

```java
// Java (DocumentBuilderFactory)
factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
factory.setXIncludeAware(false);
factory.setExpandEntityReferences(false);
```

```python
# Python — use defusedxml instead of standard xml library
from defusedxml.ElementTree import parse
```

```csharp
// .NET
XmlReaderSettings settings = new XmlReaderSettings();
settings.DtdProcessing = DtdProcessing.Prohibit;
```

```php
// PHP
libxml_disable_entity_loader(true);
```

**Defense-in-depth:**

1. If XML processing of untrusted input isn't required, remove it and use
   JSON instead
2. Run the application with least-privilege filesystem and network access
3. Block outbound requests to cloud metadata endpoints at the network level

---

## References

- [OWASP XXE Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html)
- [CWE-611](https://cwe.mitre.org/data/definitions/611.html)
