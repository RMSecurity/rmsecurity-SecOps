# Executive Report QA Checklist
### rmsecurity | 02-QUALITY

## Purpose

The executive summary is the most read document rmsecurity produces.
A CEO, Board member, or CISO will judge rmsecurity's value almost entirely
by this document. It must be perfect — clear, concise, and persuasive
without being alarmist or vague.

---

## Content Checklist

### Language and Clarity

- [ ] Zero unexplained technical jargon
- [ ] No CVE numbers, IP addresses, or tool names
- [ ] No acronyms without spelling them out on first use
- [ ] Business risk language used throughout ("an attacker could access customer payment data"
  not "we achieved RCE via an unpatched service")
- [ ] Every finding described in terms of business impact, not technical mechanics
- [ ] Active voice used throughout — avoid passive constructions that obscure meaning
- [ ] Reading level appropriate for a non-technical executive

### Structure

- [ ] Follows the structure in `01-STANDARDS/document-standards/report-structure.md`
- [ ] 4–8 pages total — not longer
- [ ] Business context section: why this was done (1 paragraph)
- [ ] Overall risk rating clearly stated with a one-sentence justification
- [ ] Maximum 5 key findings — most critical ones only
- [ ] Each finding: what is it, what could happen, business impact (3 sentences max each)
- [ ] Recommendations section: strategic, not implementation-level
- [ ] No contradictions with the technical report

### Visual Elements

- [ ] Risk gauge or traffic light visual for overall rating
- [ ] Finding severity summary chart (Critical/High/Medium/Low counts)
- [ ] rmsecurity logo on cover
- [ ] Brand colors used correctly (from `10-CORPORATE/branding/colors/`)
- [ ] Executive cover is polished — this is what the client photographs and shows their board

### Tone

- [ ] Tone is professional and authoritative — not alarmist, not dismissive
- [ ] Recommendations are actionable — client should know what to do next
- [ ] rmsecurity's value is evident — the document should feel like expert guidance, not a form
- [ ] Does not make the client feel attacked or blamed — findings are observations, not accusations

---

## Self-Review Test

Before submitting for Gate 3, read the executive summary aloud.
Ask yourself:

1. Could my grandmother understand what is at risk here?
2. Would a CEO feel they understand their security posture after reading this?
3. Would a CISO feel this accurately represents what was found?
4. Are the recommendations something a CFO would approve budget for?

If the answer to any of these is "no" — revise before Gate 3.
