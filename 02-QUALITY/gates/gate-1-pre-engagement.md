# Gate 1 — Pre-Engagement Quality Gate
### rmsecurity | 02-QUALITY

## Purpose

No technical work begins until this gate is passed.
Gate 1 verifies that the legal, contractual, and operational foundations
are in place before a single packet is sent.

Skipping this gate exposes rmsecurity to legal liability and the client
to uncontrolled risk.

---

## Gate 1 Checklist

Complete every item. Mark as `[x]` when confirmed. Do not begin work with any `[ ]` remaining.

### Legal and Contractual

- [ ] Signed Master Services Agreement (MSA) or equivalent on file
- [ ] Signed Statement of Work (SOW) with clear scope definition on file
- [ ] Signed Non-Disclosure Agreement (NDA) on file
- [ ] Signed Rules of Engagement (ROE) on file
- [ ] ROE includes explicit written authorization for all planned testing activities
- [ ] ROE specifies in-scope and out-of-scope assets unambiguously
- [ ] ROE specifies testing window (permitted dates and hours)
- [ ] ROE includes emergency stop / pause procedure and contact
- [ ] Client emergency contact (technical) confirmed and reachable
- [ ] Client emergency contact (management) confirmed and reachable
- [ ] Third-party authorization obtained for any cloud providers, ISPs, or hosted services in scope
- [ ] If web app testing: explicit authorization for the specific URLs/domains
- [ ] If social engineering is in scope: explicit written authorization
- [ ] If phishing is in scope: explicit list of target email addresses authorized

### Scope Verification

- [ ] In-scope IP ranges or domains verified against ROE (no ambiguity)
- [ ] Out-of-scope assets explicitly documented
- [ ] Shared infrastructure identified (if attacking X could affect Y, document it)
- [ ] Production vs. non-production environments clarified
- [ ] Data sensitivity of in-scope systems understood (PII, payment data, PHI)

### Engagement Setup

- [ ] Engagement ID assigned by `new-engagement.py` (format: `ENG-YYYY-NNN`)
- [ ] Engagement folder created in encrypted store
- [ ] ROE and contracts filed in `00-admin/` of engagement folder
- [ ] Git branch created if engagement-specific scripts are needed (`engagement/ENG-YYYY-NNN`)
- [ ] Operator name set in `.env` (`RMSEC_OPERATOR`)
- [ ] Chain of custody manifest initialized (`04-evidence/chain-of-custody/manifest.csv`)

### Technical Preparation

- [ ] Target environment understood (OS versions, network topology if provided)
- [ ] Testing tools updated and ready
- [ ] VPN or jump host configured if required by client
- [ ] Egress IP confirmed with client (so they can whitelist if needed)
- [ ] Notification email drafted to send to client at start of testing

---

## Gate 1 Sign-Off Record

Complete this block and save it in `00-admin/gate-1-signoff.md` in the engagement folder.

```
Engagement ID:
Client alias:
Gate 1 completed by:
Date:
All items verified: YES / NO
Notes (any exceptions or special conditions):
```

---

## If Gate 1 Cannot Be Passed

Do not start work. Contact the client to resolve the missing items.
Document what is missing and why in the sign-off record.
If the client pushes to begin without signed authorization, escalate internally.
Never begin testing without a signed ROE.
