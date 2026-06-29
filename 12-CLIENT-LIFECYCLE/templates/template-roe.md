# Rules of Engagement Template
### rmsecurity | 12-CLIENT-LIFECYCLE

---

*Copy this template. Fill in all `[BRACKETED]` fields. Remove all instructional notes in italics.*
*File name: `ENG-YYYY-NNN_[CLIENT]_ROE_YYYY-MM-DD_v1.0.pdf`*

---

# RULES OF ENGAGEMENT

**rmsecurity — [CLIENT ORGANIZATION NAME]**
**Engagement ID:** [ENG-YYYY-NNN]
**Engagement Type:** [e.g., External Network Penetration Test]
**Document Version:** v1.0
**Date:** [YYYY-MM-DD]
**Classification:** CONFIDENTIAL

---

## 1. Parties

**Service Provider:**
rmsecurity
Contact: [Operator Name]
Email: [operator@rmsecurity.com]
Phone: [+XX XXX XXX XXXX]

**Client:**
[Client Organization Name]
Contact: [Client Technical Contact Name]
Role: [e.g., IT Manager / CISO]
Email: [client@organization.com]
Phone: [+XX XXX XXX XXXX]

**Client Management Contact (Escalation):**
[Client Management Contact Name]
Role: [e.g., CEO / CTO]
Email: [management@organization.com]
Phone: [+XX XXX XXX XXXX]

---

## 2. Authorization

[Client Organization Name] hereby grants rmsecurity explicit written authorization
to perform the security testing activities described in this document against
the in-scope systems listed in Section 4, during the testing window defined
in Section 5.

This authorization is limited strictly to the scope, methods, and timeline
defined herein. Any activity outside this authorization must be approved
in writing before execution.

---

## 3. Engagement Objectives

*State 2–4 clear objectives. Examples:*

1. Identify vulnerabilities in [Client]'s external attack surface exploitable
   by an unauthenticated attacker.
2. Determine whether an attacker could gain unauthorized access to internal
   systems or sensitive data.
3. Provide actionable remediation guidance prioritized by business risk.

---

## 4. Scope

### 4.1 In Scope

*List all authorized targets. Be specific — vague scope = legal risk.*

| Asset | Type | IP / Domain | Notes |
|-------|------|------------|-------|
| [hostname] | [Server / Domain / App] | [IP or URL] | [e.g., primary web server] |

**IP Ranges authorized for scanning:**
- [x.x.x.x/24]

**Domains authorized for testing:**
- [domain.com]
- [*.domain.com] *(if wildcard authorized)*

### 4.2 Explicitly Out of Scope

*Anything not listed above is out of scope by default. List known items to avoid ambiguity.*

- [Third-party SaaS systems: Salesforce, Office 365 tenant admin, etc.]
- [Production database servers — read-only access only]
- [Any IP address not listed in Section 4.1]
- [Physical security testing]
- [Social engineering of employees]

### 4.3 Third-Party Authorizations

*List any third-party systems that require separate authorization.*

| Provider | System | Authorization obtained | Contact |
|---------|--------|----------------------|---------|
| [AWS / Azure / Hosting provider] | [Hosted systems] | [YES / NO / N/A] | [Contact] |

---

## 5. Testing Window

| Field | Value |
|-------|-------|
| Start date | [YYYY-MM-DD] |
| End date | [YYYY-MM-DD] |
| Permitted hours | [e.g., 08:00–18:00 local time / 24 hours] |
| Time zone | [e.g., UTC-3] |
| Weekend testing | [Permitted / Not permitted] |

Testing will not occur outside the authorized window without written approval.

---

## 6. Authorized Activities

The following activities are explicitly authorized:

- [x] Port scanning and service enumeration
- [x] Vulnerability scanning (authenticated and unauthenticated)
- [x] Manual exploitation of discovered vulnerabilities
- [x] Password spraying against [specify: VPN portal / web app / etc.]
- [ ] Phishing simulation *(not authorized unless checked)*
- [ ] Social engineering *(not authorized unless checked)*
- [ ] Denial of Service testing *(not authorized unless checked)*
- [ ] Physical access attempts *(not authorized unless checked)*

---

## 7. Prohibited Activities

The following are strictly prohibited regardless of technical possibility:

- Intentional disruption of production services
- Exfiltration of real customer, employee, or confidential data
- Destruction or modification of data
- Persistence beyond what is needed to demonstrate a finding
- Testing of any system not listed in Section 4.1
- Sharing of discovered vulnerabilities or credentials with any third party

---

## 8. Emergency Stop Procedure

If at any point rmsecurity discovers evidence of an active third-party attack,
critical data exposure, or causes unintended disruption, testing stops
immediately and the client emergency contact is called.

**Emergency Stop Contact (Technical):**
Name: [Name]
Phone: [+XX XXX XXX XXXX]
Available: [24/7 / Business hours]

**Emergency Stop Contact (Management):**
Name: [Name]
Phone: [+XX XXX XXX XXXX]

Testing does not resume without written approval from the client.

---

## 9. Data Handling

- All findings and evidence are stored in an encrypted environment
- No real customer data will be retained after engagement close
- Evidence will be securely deleted [30 / 60 / 90] days after final report delivery
- Report transmission will use encrypted channels only

---

## 10. Confidentiality

Both parties acknowledge that all information exchanged during this engagement
is confidential and governed by the Non-Disclosure Agreement signed on [DATE].

---

## 11. Signatures

By signing below, both parties confirm they have read, understood, and
authorize the activities described in this Rules of Engagement document.

**rmsecurity**

Signature: _________________________ Date: _______________
Name: [Operator Name]
Title: Security Consultant

**[Client Organization Name]**

Signature: _________________________ Date: _______________
Name: [Client Signatory Name]
Title: [Title]

---

*This document must be signed by both parties before any testing begins.*
*Gate 1 cannot be passed without a signed copy on file.*
