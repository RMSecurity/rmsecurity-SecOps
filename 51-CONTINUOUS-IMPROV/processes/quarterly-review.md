# Quarterly CCOS Review Process
### rmsecurity | 51-CONTINUOUS-IMPROV

*Run this review at the end of each quarter (last week of March, June, September, December).*
*Budget approximately 4 hours.*

---

## Part 1 — Methodology Audit (90 min)

Walk each active playbook and ask: is this still accurate?

### Pentest Playbooks
- [ ] `22-PENTESTING/playbooks/external-network.md` — tool versions current?
- [ ] `22-PENTESTING/playbooks/internal-network.md` — new AD attacks to add?
- [ ] `22-PENTESTING/playbooks/web-application.md` — OWASP WSTG version check
- [ ] `22-PENTESTING/playbooks/active-directory.md` — new techniques (check SpecterOps blog)
- [ ] `22-PENTESTING/checklists/pentest-master.md` — aligned with playbooks?
- [ ] `23-CLOUD-SECURITY/playbooks/aws-assessment.md` — new AWS services/risks?
- [ ] `23-CLOUD-SECURITY/playbooks/azure-m365-assessment.md` — new Entra ID risks?
- [ ] `25-BLUE-TEAM/playbooks/security-hardening.md` — new CIS baseline version?
- [ ] `26-INCIDENT-RESPONSE/playbooks/` — IR procedures still match NIST SP 800-61?

### Checklist: tool version review
```bash
# Check latest versions of core tools
# Run in Kali lab and compare to what playbooks reference
nmap --version
gobuster version
impacket-GetUserSPNs --help | head -3
bloodhound --version
crackmapexec --version
```

---

## Part 2 — Knowledge Base Review (45 min)

- [ ] Review `32-KNOWLEDGE-BASE/findings/` — are all templates still accurate?
- [ ] Add any new finding types encountered in the quarter that aren't in the KB
- [ ] Update CVSS scores if NVD has revised any referenced CVEs
- [ ] Add retrospective entries for all engagements closed this quarter
- [ ] Review `30-THREAT-INTELLIGENCE/watchlists/cve-watchlist.md` — remove resolved CVEs

---

## Part 3 — Business & Templates Review (45 min)

- [ ] `11-BUSINESS-DEV/templates/proposal-template.md` — update pricing if needed
- [ ] `11-BUSINESS-DEV/crm/pipeline-tracker.md` — clean up stale opportunities
- [ ] `12-CLIENT-LIFECYCLE/templates/template-nda.md` — any legal updates needed?
- [ ] `13-PROJECT-MGMT/templates/status-report-template.md` — format still working?
- [ ] `42-EXECUTIVE-REPORTING/templates/` — update templates if report structure changed

---

## Part 4 — Metrics Review (30 min)

- [ ] Update `50-METRICS/dashboards/business-kpis.md` with quarterly actuals
- [ ] Update `50-METRICS/dashboards/delivery-kpis.md` — findings profile, speed metrics
- [ ] Complete `50-METRICS/templates/monthly-review.md` for the final month of quarter
- [ ] Review cert progress vs. `34-TRAINING/paths/certification-roadmap.md`
- [ ] Set 3 goals for next quarter

---

## Output

After the review, commit to GitHub with message:
```
[quarterly-review] YYYY-QN — brief description of main changes
```
