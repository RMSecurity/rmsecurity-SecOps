# Report Structure Standard
### rmsecurity | 01-STANDARDS

## Two Report Types

Every engagement produces exactly two reports:

| Report | Audience | Length | File |
|--------|---------|--------|------|
| Technical Report | IT team, security team, system administrators | 20–80 pages | `template-technical-report.docx` |
| Executive Summary | CISO, CTO, CEO, Board | 4–8 pages | `template-executive-summary.docx` |

They are separate documents. The executive summary is never a copy-paste
of the technical report introduction.

---

## Technical Report Structure

### Cover Page
- rmsecurity logo
- Report title (e.g., "Penetration Test Report — External Network")
- Engagement ID
- Client alias / name (in final delivered version)
- Report date
- Version number
- Classification label (CONFIDENTIAL)
- Prepared by: rmsecurity

### Page 1 — Document Control

| Field | Value |
|-------|-------|
| Engagement ID | ENG-YYYY-NNN |
| Report version | v1.0 |
| Report date | YYYY-MM-DD |
| Classification | CONFIDENTIAL |
| Prepared by | rmsecurity |
| Approved by | [Lead consultant] |
| Distribution | [Client contact name and role] |

**Version history table:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| v0.1 | YYYY-MM-DD | Name | Initial draft |
| v1.0 | YYYY-MM-DD | Name | Final — delivered to client |

### Section 1 — Executive Summary (1 page)
- Engagement purpose in one paragraph
- Overall risk posture in plain language
- Finding count by severity (table)
- Top 3 most critical findings (names only, no detail)
- Key recommendation in one sentence

### Section 2 — Scope and Methodology
- Engagement type and objectives
- In-scope assets (IP ranges, domains, applications)
- Out-of-scope assets (explicitly listed)
- Testing period (start date, end date, testing hours)
- Methodology overview (frameworks used: PTES, OWASP, MITRE ATT&CK)
- Constraints and limitations

### Section 3 — Summary of Findings
- Table: all findings with ID, title, severity, affected asset, status
- Severity distribution chart
- Risk heat map (optional)

### Section 4 — Detailed Findings
One subsection per finding, using the finding format from `finding-format.md`.
Ordered by severity (Critical first).

### Section 5 — Remediation Roadmap
- Prioritized remediation table
- Grouped by: Immediate (Critical/High), Short-term (Medium), Long-term (Low)
- Estimated effort for each group

### Section 6 — Appendices
- A: Methodology details
- B: Tool list
- C: Evidence index (list of EV- IDs)
- D: Glossary (if needed)

---

## Executive Summary Structure

### Cover Page
Same as technical report cover — different title: "Executive Summary"

### Page 1 — Business Context
- Why this assessment was performed
- What was tested (in plain language, no technical jargon)
- When it was performed

### Page 2 — Overall Risk Posture
- Risk rating: Critical / High / Medium / Low
- Visual risk gauge or traffic light
- One paragraph explaining the overall picture to a non-technical reader

### Page 3 — Key Findings
- Maximum 5 findings, described in business terms
- Each finding: what it is, what an attacker could do, business impact
- No CVE numbers, no IP addresses, no technical detail

### Page 4 — Recommendations and Next Steps
- Top 3 strategic recommendations
- Suggested remediation timeline
- Offer for follow-up retest

---

## Version Numbering

| Version | When used |
|---------|---------|
| `v0.1` | First internal draft |
| `v0.x` | Draft revisions before delivery |
| `v1.0` | First version delivered to client |
| `v1.x` | Minor revisions after client feedback |
| `v2.0` | Post-remediation retest report |

Never deliver a `v0.x` document to a client.
