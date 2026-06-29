# Gate 3 — Report Quality Assurance Gate
### rmsecurity | 02-QUALITY

## Purpose

The complete report — both technical and executive — is reviewed in full
before it is shown to a client in any form, including informal previews.

A report with errors, inconsistencies, or missing sections reflects on
rmsecurity's professionalism more than any individual finding.
Gate 3 catches these before they become client-visible problems.

---

## Technical Report QA Checklist

### Structure and Completeness

- [ ] Report follows the structure defined in `01-STANDARDS/document-standards/report-structure.md`
- [ ] Cover page contains: logo, title, engagement ID, date, version, classification
- [ ] Document control page complete: version history, distribution list
- [ ] Executive summary present (1 page maximum)
- [ ] Scope and methodology section complete
- [ ] All in-scope assets documented
- [ ] Testing period documented (exact dates and hours)
- [ ] Summary of findings table present with all finding IDs, titles, severities
- [ ] All validated findings (Gate 2 PASS) are included in the report
- [ ] No finding in the report that did not pass Gate 2
- [ ] Remediation roadmap section present and prioritized
- [ ] Appendices complete (methodology, tools, evidence index)

### Finding Consistency

- [ ] Every finding in the report matches its finding file exactly
- [ ] Finding IDs are sequential and match the manifest
- [ ] Severity levels in the report match the validated findings
- [ ] Evidence IDs referenced in findings exist in the chain of custody manifest
- [ ] No finding references evidence not in `manifest.csv`
- [ ] Affected asset hostnames and IPs are consistent throughout the report
- [ ] No finding describes a technique outside the ROE scope

### Writing Quality

- [ ] Report is written in clear, professional English
- [ ] No spelling errors (spell-check run)
- [ ] No grammar errors
- [ ] No placeholder text remaining (`[TBD]`, `[INSERT]`, `[TODO]`, `[CLIENT NAME]`)
- [ ] Technical jargon is explained on first use (or a glossary is included)
- [ ] No internal notes, comments, or draft annotations remain
- [ ] Client alias used consistently (never the analyst's shorthand or a wrong name)
- [ ] Dates are in `YYYY-MM-DD` format throughout
- [ ] Version number in filename matches version number on cover page

### Visual and Formatting

- [ ] rmsecurity logo present on cover and header
- [ ] Classification label (`CONFIDENTIAL`) in footer of every page
- [ ] Engagement ID in footer of every page
- [ ] Page numbers correct (`Page N of N`)
- [ ] Severity colors match the palette in `10-CORPORATE/branding/colors/`
- [ ] Tables are consistent in style
- [ ] Screenshots are legible and readable (not blurry or cropped awkwardly)
- [ ] Finding severity badges use the correct colors
- [ ] DRAFT watermark removed for final version (v1.0+)

### Accuracy

- [ ] IP addresses and hostnames verified against scope
- [ ] CVE numbers verified against NVD
- [ ] CVSS scores verified by recalculating at least 2 critical findings
- [ ] MITRE ATT&CK technique IDs verified against attack.mitre.org
- [ ] Remediation references (links, vendor advisories) are valid and reachable
- [ ] No statement of fact that cannot be supported by evidence

---

## Executive Summary QA Checklist

- [ ] 4–8 pages maximum
- [ ] No technical jargon unexplained
- [ ] No IP addresses, CVE numbers, or tool names
- [ ] Overall risk rating clearly stated and justified
- [ ] Business impact articulated — what this means for the organization, not the systems
- [ ] Top findings described in business terms only
- [ ] Recommendations are strategic, not implementation-level
- [ ] Consistent with the technical report — no contradictions
- [ ] Client leadership could read and understand without a security background

---

## Gate 3 Sign-Off Record

Save in `06-reports/` of the engagement folder as `gate-3-signoff.md`:

```
Engagement ID:
Report version:
Technical report reviewed: YES / NO
Executive summary reviewed: YES / NO
QA completed by:
Date:
Critical issues found: YES / NO
Issues list (if any):
Gate 3 result: PASS / FAIL
Approved for Gate 4: YES / NO
```

A FAIL at Gate 3 means the report returns to the analyst for corrections.
A new Gate 3 review is required after corrections — do not skip the re-review.
