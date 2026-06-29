# KB-WEB-001 — SQL Injection
### rmsecurity | 32-KNOWLEDGE-BASE

---

**Finding ID:** FND-[ENG-ID]-[NNN]  
**Title:** SQL Injection in [PARAMETER/ENDPOINT] Allows [IMPACT]  
**Severity:** Critical / High *(Critical if auth bypass or data extraction; High if blind)*  
**CVSS v3.1 (data extraction):** 9.8 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)  
**CVSS v3.1 (blind/no impact yet):** 7.5 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)  
**CWE:** CWE-89 (Improper Neutralization of Special Elements used in SQL Command)  
**MITRE ATT&CK:** T1190 — Exploit Public-Facing Application  

---

## Description

The [PARAMETER NAME] parameter of the [ENDPOINT — e.g., `/search`, `/api/users`]
endpoint does not sanitize user-supplied input before incorporating it into
database queries. An attacker can inject arbitrary SQL syntax into this parameter,
causing the application's database server to execute attacker-controlled queries.

[INJECTION TYPE: The vulnerability is a [classic / blind boolean-based /
time-based blind / error-based / UNION-based] SQL injection.]

The application uses [DATABASE TYPE — MySQL / MSSQL / PostgreSQL / SQLite],
which was determined from [error messages / response behavior / version fingerprint].

---

## Evidence

**Injection point:** `[FULL URL OR REQUEST]`

**Confirming payload:** `[PAYLOAD USED]`

**Result:** [DESCRIBE — e.g., "The application returned a database error
revealing the SQL query structure" / "A 5-second delay was induced, confirming
blind time-based injection" / "The application returned [N] additional rows
containing user data"]

| Evidence ID | Description |
|------------|-------------|
| [EV-ID] | HTTP request and response showing injection confirmation |
| [EV-ID] | SQLMap output showing database enumeration [if performed] |
| [EV-ID] | Screenshot of extracted data [table name, count — NOT actual data] |

**Data accessible:** [DESCRIBE TABLES/DATA ACCESSIBLE without including actual user data]

---

## Impact

An unauthenticated [or authenticated as role] attacker can:

1. Extract the full contents of the [DATABASE NAME] database, including
   [user credentials / PII / payment data / [OTHER SENSITIVE DATA]]
2. [If write access]: Modify or delete database contents
3. [If MSSQL xp_cmdshell enabled or MySQL FILE privilege]: Execute operating
   system commands on the database server, achieving full server compromise
4. [If login form]: Bypass authentication entirely using a payload such as `' OR '1'='1`

---

## Remediation

**Short term:**

1. Implement a Web Application Firewall (WAF) rule to block common SQL injection
   patterns on the affected endpoint while the fix is developed
2. Disable verbose database error messages in production — errors should return
   a generic message to the user

**Long term (mandatory):**

1. **Parameterized queries (prepared statements)** — the only reliable fix.
   User input must never be concatenated into SQL strings:

   ```python
   # VULNERABLE
   query = "SELECT * FROM users WHERE name = '" + username + "'"

   # FIXED — parameterized
   cursor.execute("SELECT * FROM users WHERE name = %s", (username,))
   ```

2. Apply the principle of least privilege to the database user — the application
   account should only have SELECT/INSERT/UPDATE on the tables it needs, not
   schema-level or server-level permissions

3. Implement input validation as a defense-in-depth measure (not a primary fix)

---

## References

- [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [OWASP Query Parameterization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Query_Parameterization_Cheat_Sheet.html)
- [CWE-89](https://cwe.mitre.org/data/definitions/89.html)
- [MITRE T1190](https://attack.mitre.org/techniques/T1190/)
