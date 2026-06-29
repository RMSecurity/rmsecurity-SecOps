# KB-WEB-003 — Insecure Direct Object Reference (IDOR)
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]  
**Title:** IDOR in [ENDPOINT] Allows Unauthorized Access to [DATA TYPE]  
**Severity:** High / Critical *(Critical if PII, financial, or health data; High otherwise)*  
**CVSS v3.1:** 8.1 (AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N)  
**CWE:** CWE-639 (Authorization Through User-Controlled Key)  
**MITRE ATT&CK:** T1078 — Valid Accounts (abusing legitimate session for unauth access)  

---

## Description

The [ENDPOINT] endpoint uses a user-controlled identifier (`[PARAMETER NAME]`)
to retrieve [RESOURCE TYPE]. The application does not verify that the
authenticated user has authorization to access the requested resource —
it only verifies that the user is authenticated.

By modifying the `[PARAMETER NAME]` value in the request, any authenticated
user can access [RESOURCE TYPE] belonging to other users.

**Example request (legitimate):**
```
[HTTP METHOD] [ENDPOINT/ID_OF_OWN_RESOURCE]
Authorization: Bearer [TOKEN]
```

**Modified request accessing another user's resource:**
```
[HTTP METHOD] [ENDPOINT/ID_OF_OTHER_USER_RESOURCE]
Authorization: Bearer [TOKEN]
```

During this engagement, rmsecurity accessed [DESCRIBE — e.g., "the account
details of [N] other users including names, email addresses, and [OTHER PII]"]
by iterating the `[PARAMETER]` value.

---

## Impact

Any authenticated user can access and [read / modify / delete]
[RESOURCE TYPE] belonging to other users without their knowledge or consent.

[SCALE — e.g., "The resource IDs are sequential integers, meaning an attacker
could enumerate all [N] user records in the system in under [TIMEFRAME] using
automated requests."]

[DATA SENSITIVITY — e.g., "The exposed data includes full names, email addresses,
physical addresses, and [other fields] for all users, representing a significant
data breach risk under GDPR/relevant regulation."]

---

## Evidence

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | Request to own resource (legitimate) with response |
| [EV-ID] | Modified request with different ID accessing another user's resource |
| [EV-ID] | Side-by-side comparison showing different user's data returned |

---

## Remediation

**Mandatory fix:**

Implement server-side authorization checks on every resource access:

```python
# VULNERABLE — only checks authentication
def get_invoice(invoice_id):
    return db.query("SELECT * FROM invoices WHERE id = ?", invoice_id)

# FIXED — checks authorization
def get_invoice(invoice_id, current_user):
    invoice = db.query("SELECT * FROM invoices WHERE id = ? AND user_id = ?",
                       invoice_id, current_user.id)
    if not invoice:
        raise PermissionDenied()
    return invoice
```

**Defense-in-depth:**

1. Use non-sequential, unpredictable identifiers (UUIDs) for resources — this
   does not fix the vulnerability but makes enumeration harder
2. Implement automated testing for IDOR in CI/CD — use a tool like Autorize
   (Burp Suite extension) in regression tests

---

## References

- [OWASP IDOR](https://owasp.org/www-chapter-ghana/assets/slides/IDOR.pdf)
- [OWASP Top 10 A01:2021 — Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)
- [CWE-639](https://cwe.mitre.org/data/definitions/639.html)
