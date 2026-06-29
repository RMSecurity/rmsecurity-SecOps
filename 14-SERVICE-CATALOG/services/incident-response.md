# Service: Incident Response
### rmsecurity | 14-SERVICE-CATALOG | Code: IR-RETAINER / IR-ADHOC

## Description

Structured support for organizations experiencing or suspecting a security
incident. Available as a retainer (guaranteed SLA) or ad-hoc (best effort).

rmsecurity provides triage, containment, eradication, recovery guidance,
and post-incident reporting.

---

## Engagement Models

### Retainer (IR-RETAINER)

Pre-agreed contract ensuring guaranteed response times and reserved capacity.

| Tier | First response SLA | Analyst hours/year included | Priority |
|------|------------------|---------------------------|---------|
| Standard | 4 business hours | 20 hours | Normal queue |
| Priority | 2 hours (24/7) | 40 hours | Front of queue |
| Enterprise | 1 hour (24/7) | 80 hours | Dedicated contact |

Unused hours: roll over quarterly, expire at year end.
Additional hours billed at standard rate.

### Ad-Hoc (IR-ADHOC)

No prior contract. Response initiated on contact.
Best effort — no SLA guaranteed. Subject to analyst availability.
Recommended only for low-severity incidents.

---

## Incident Response Phases

```
Detection / Notification
         │
    [Gate: Intake & Triage]
         │
    Containment
         │
    Eradication
         │
    Recovery
         │
    Post-Incident Review
         │
    IR Report Delivered
```

### Phase 1 — Intake & Triage

- Incident intake form completed by client
- Initial call within SLA window
- Severity classification (P1/P2/P3/P4)
- Initial scope assessment: what is affected, how long, what data

### Phase 2 — Containment

- Identify affected systems
- Isolate compromised assets from the network
- Preserve evidence (memory, disk images, logs) before changes
- Credential rotation recommendations
- Communication guidance (what to say to employees, customers, regulators)

### Phase 3 — Eradication

- Remove malware, backdoors, persistence mechanisms
- Identify and close the initial access vector
- Verify eradication across all affected systems

### Phase 4 — Recovery

- Phased restoration of systems
- Hardening applied before reconnecting to network
- Monitoring increased during recovery period
- Validate systems are clean before full restoration

### Phase 5 — Post-Incident Review

- Root cause analysis
- Attack timeline reconstruction
- Lessons learned
- IR report (technical + executive)
- Recommendations to prevent recurrence

---

## Deliverables

| Deliverable | Format | Timeline |
|------------|--------|---------|
| Incident Response Report | PDF + DOCX | Within 5 business days of containment |
| Executive Summary | PDF | Same delivery |
| Lessons Learned Document | PDF | Included |
| Attack Timeline | Visual + table | Included in report |
| Remediation Recommendations | XLSX | Same delivery |

---

## Severity Classification

| Priority | Description | Response SLA (Retainer) |
|---------|------------|------------------------|
| P1 — Critical | Ransomware, data breach in progress, full compromise | 1–2 hours |
| P2 — High | Active attacker in environment, suspected breach | 2–4 hours |
| P3 — Medium | Suspicious activity, potential compromise, malware detected | 4–8 hours |
| P4 — Low | Policy violation, low-confidence alert, suspicious email | Next business day |
