# Retest Procedure
### rmsecurity | 43-REMEDIATION

---

## 1. Triggering a Retest

A retest is triggered when the client:

1. Sends the updated remediation tracker with findings marked "Remediated" or "Mitigated"
2. Provides evidence of changes made (patch notes, config screenshots, code diffs)
3. Confirms the retest window (within 60 days of original report delivery)

Do not begin retest work without written confirmation of scope.

---

## 2. Retest Scoping

Before retesting, confirm:

- [ ] Signed ROE from original engagement still covers the retest scope
- [ ] Any new systems added to scope require a new ROE amendment
- [ ] Testing window confirmed (retest may have different window than original)
- [ ] Client contact confirmed available for quick questions during retest

Retest scope = only findings the client marked as Remediated or Mitigated.
Do not perform discovery or test new attack surface during a retest.

---

## 3. Retest Execution

For each finding in scope:

1. Reference the original finding (Finding ID, steps to reproduce, evidence)
2. Attempt to reproduce the original issue using the same technique
3. Document result: **Closed**, **Partially Remediated**, or **Still Vulnerable**
4. Collect new evidence: screenshot or output showing the current state
5. Update the remediation tracker with result and new evidence ID

---

## 4. Retest Report

The retest output is a **delta report**, not a full new report:

- 1–3 page document
- Lists each retested finding with original severity and retest result
- Does not rewrite scope, methodology, or executive summary
- Uses same naming convention: `ENG-YYYY-NNN_[CLIENT]_Retest-Report_[DATE]_v1.0.pdf`

Deliver retest report within 5 business days of completing testing.

---

## 5. Partially Remediated Findings

If a fix is incomplete:

- Status = "Partially Remediated"
- Document what was fixed and what remains
- Provide specific additional remediation guidance
- Client may choose to accept residual risk or request a second retest (billed separately)

---

## Related

- `43-REMEDIATION/templates/remediation-tracker-template.xlsx`
- `02-QUALITY/gates/gate-2-finding-validation.md`
- `12-CLIENT-LIFECYCLE/templates/email-report-delivery.md` — references retest window
