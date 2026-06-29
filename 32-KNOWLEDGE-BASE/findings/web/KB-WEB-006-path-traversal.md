# KB-WEB-006 — Path Traversal / Local File Inclusion
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]
**Title:** Path Traversal in [PARAMETER] Allows Arbitrary File Read
**Severity:** High / Critical *(Critical if leads to RCE via log/config file inclusion)*
**CVSS v3.1:** 7.5 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)
**CWE:** CWE-22 (Improper Limitation of a Pathname to a Restricted Directory)
**MITRE ATT&CK:** T1083 — File and Directory Discovery

---

## Description

The [PARAMETER — e.g., "filename", "template", "lang"] parameter of the
[ENDPOINT] endpoint is used to construct a filesystem path without
sanitizing directory traversal sequences (`../`). An attacker can supply
a crafted path to read files outside the intended directory.

**Payload used:**
```
GET [ENDPOINT]?[PARAMETER]=../../../../etc/passwd
GET [ENDPOINT]?[PARAMETER]=....//....//....//etc/passwd  (filter bypass)
GET [ENDPOINT]?[PARAMETER]=..%2f..%2f..%2fetc%2fpasswd   (encoded bypass)
```

During this engagement, rmsecurity retrieved [FILE] from the server using
this technique, confirming arbitrary file read access outside the web root.

---

## Impact

An attacker can:

1. Read arbitrary files accessible to the application's process user,
   including source code, configuration files, and credential stores
   (e.g., `.env`, `web.config`, database connection strings)
2. **If combined with a file upload feature or log file access (LFI →
   log poisoning):** achieve Remote Code Execution by writing PHP/JSP code
   into a log file and including it via the traversal vulnerability
3. Map the server's directory structure and technology stack from
   retrieved configuration files

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | Request and response showing successful file disclosure |
| [EV-ID] | [If RCE achieved] Evidence of code execution via log poisoning |

---

## Remediation

**Mandatory:**

1. **Avoid passing user input directly into filesystem APIs.** Use an
   indirect reference instead — map a request parameter to a fixed
   filename via a server-side lookup table:
   ```python
   ALLOWED_FILES = {"report1": "/safe/path/report1.pdf", "report2": "/safe/path/report2.pdf"}
   filepath = ALLOWED_FILES.get(request.args.get("file"))
   if not filepath:
       abort(404)
   ```
2. If direct paths are unavoidable, canonicalize and verify the resolved
   path is within the intended directory:
   ```python
   import os
   base = os.path.realpath("/safe/directory")
   target = os.path.realpath(os.path.join(base, user_input))
   if not target.startswith(base + os.sep):
       raise ValueError("Path traversal attempt blocked")
   ```
3. Run the application with a restricted filesystem user (chroot or
   container-based isolation) so even a successful traversal has limited reach

---

## References

- [OWASP Path Traversal](https://owasp.org/www-community/attacks/Path_Traversal)
- [CWE-22](https://cwe.mitre.org/data/definitions/22.html)
