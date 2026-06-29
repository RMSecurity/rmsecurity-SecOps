# Client Onboarding Checklist
### rmsecurity | 12-CLIENT-LIFECYCLE

*Complete this checklist for every new engagement. Save completed copy in `00-admin/` of the engagement folder.*

---

**Engagement ID:** _______________
**Client alias:** _______________
**Engagement type:** _______________
**Onboarding date:** _______________

---

## Stage 1 — First Contact

- [ ] Lead source documented (referral / LinkedIn / website / other)
- [ ] Client contact name, role, email, and phone captured
- [ ] Organization type and size noted
- [ ] Initial requirement understood (what they want and why now)
- [ ] No conflict of interest (no prior relationship that creates bias)
- [ ] NDA sent or existing NDA confirmed

## Stage 2 — Scoping

- [ ] Discovery call completed
- [ ] Engagement type confirmed from service catalog
- [ ] Preliminary scope defined (IP ranges, domains, applications)
- [ ] Testing window discussed and feasibility confirmed
- [ ] Deliverables and timeline agreed in principle
- [ ] Quote / proposal sent

## Stage 3 — Contract

- [ ] Proposal accepted by client
- [ ] MSA signed (or existing MSA referenced)
- [ ] Statement of Work signed
- [ ] NDA signed
- [ ] 50% upfront payment received (or PO issued)
- [ ] Engagement ID assigned via `new-engagement.py`
- [ ] Engagement folder created in encrypted store
- [ ] Contracts filed in `00-admin/contracts/`

## Stage 4 — Rules of Engagement

- [ ] ROE template completed with client inputs
- [ ] Scope reviewed and confirmed in writing by client
- [ ] In-scope assets verified and documented
- [ ] Out-of-scope assets explicitly listed
- [ ] Testing window confirmed
- [ ] Emergency contacts confirmed
- [ ] Third-party authorizations obtained (if needed)
- [ ] ROE signed by both parties
- [ ] Signed ROE filed in `00-admin/roe/`
- [ ] **Gate 1 checklist completed and passed**

## Stage 5 — Kick-off

- [ ] Kick-off agenda sent 24 hours before call
- [ ] Kick-off call completed
- [ ] Scope confirmed verbally
- [ ] Testing window confirmed
- [ ] Egress IP shared with client
- [ ] VPN / access credentials tested (if applicable)
- [ ] Client SOC briefed (if applicable)
- [ ] Kick-off summary email sent within 24 hours
- [ ] Debrief call scheduled
- [ ] `engagement.json` updated with all confirmed details

## Stage 6 — Testing Start

- [ ] Testing start notification email sent (template: `email-testing-start.md`)
- [ ] Testing commenced at agreed time
- [ ] Evidence collection started
- [ ] Chain of custody manifest initialized

---

*All stages must be complete before testing begins. No exceptions.*
