# KB-WEB-002 — Stored Cross-Site Scripting (XSS)
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]  
**Title:** Stored XSS in [FEATURE] Allows Account Takeover  
**Severity:** High  
**CVSS v3.1:** 8.8 (AV:N/AC:L/PR:L/UI:R/S:C/C:H/I:L/A:N)  
**CWE:** CWE-79 (Improper Neutralization of Input During Web Page Generation)  
**MITRE ATT&CK:** T1059.007 — Command and Scripting Interpreter: JavaScript  

---

## Description

The [FEATURE — e.g., "comment field", "user profile bio", "product review"]
at [URL] does not sanitize HTML or JavaScript submitted by users before
storing and displaying it to other users. An attacker can inject malicious
JavaScript that executes in the browser of any user who views the affected page.

Unlike reflected XSS, stored XSS is persistent — the payload executes for
every visitor without requiring the victim to click a crafted link. This makes
stored XSS significantly more impactful, particularly in features that are
viewed by administrators or privileged users.

During this engagement, rmsecurity injected the following payload into the
[FEATURE] field:

```html
[PAYLOAD USED — sanitize for report: show type but not weaponized version]
```

The payload executed when [WHO — "any authenticated user" / "administrators" /
"all visitors"] viewed [WHERE].

---

## Impact

An attacker who can submit content to [FEATURE] can:

1. Steal session cookies of users who view the affected content, enabling
   account takeover without knowing the victim's password
2. Perform actions on behalf of the victim (transfers, data modification,
   password changes) using the victim's authenticated session
3. Redirect victims to phishing pages or deliver malware
4. [If admin users are affected]: Escalate to full administrative access
   to the application

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | Screenshot of payload injected into [FEATURE] |
| [EV-ID] | Screenshot of payload executing in browser (alert/proof of execution) |
| [EV-ID] | [Optional] Cookie captured via XSS to demonstrate account takeover |

---

## Remediation

**Short term:**

1. Identify and remove any existing stored payloads from the database
2. Set the `HttpOnly` flag on session cookies — this prevents JavaScript from
   reading session cookies and reduces the impact of XSS to click-jacking only:
   ```
   Set-Cookie: session=xxx; HttpOnly; Secure; SameSite=Strict
   ```
3. Implement Content Security Policy (CSP) header to restrict script execution:
   ```
   Content-Security-Policy: default-src 'self'; script-src 'self'
   ```

**Long term (mandatory):**

1. **Output encoding** — encode all user-supplied data before inserting into HTML:
   - HTML context: `&`, `<`, `>`, `"`, `'` → `&amp;`, `&lt;`, `&gt;`, `&quot;`, `&#x27;`
   - Use established libraries: OWASP Java Encoder, DOMPurify (JavaScript), Bleach (Python)

2. **Input validation** — reject input that does not conform to expected format
   (not a substitute for output encoding, but defense-in-depth)

3. **CSP with nonces** — strict CSP with per-request nonces prevents most XSS execution

---

## References

- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [DOMPurify](https://github.com/cure53/DOMPurify)
- [CWE-79](https://cwe.mitre.org/data/definitions/79.html)
