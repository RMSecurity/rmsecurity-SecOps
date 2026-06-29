# Onboarding Guide
### rmsecurity | Day 1 Operational Setup

## Welcome to rmsecurity

This document walks you through setting up your operational environment from scratch.
By the end, you will have a working CCOS installation, your tools configured,
and your first engagement environment ready.

---

## Step 1 — Prerequisites

Install the following before anything else:

| Tool | Version | Purpose |
|------|---------|---------|
| Git | 2.40+ | Version control |
| Python | 3.11+ | Scripting and automation |
| Docker Desktop | Latest | Containerized tool environments |
| VS Code | Latest | Recommended editor |
| VeraCrypt | Latest | Client data encryption |

---

## Step 2 — Clone the Repository

```bash
git clone https://github.com/rmsecurity/ccos.git
cd ccos
```

---

## Step 3 — Run Bootstrap

```bash
bash 00-PLATFORM/scripts/bootstrap.sh
```

This script:
- Verifies your tools are installed
- Sets up the Python virtual environment
- Installs pre-commit hooks (secret detection runs before every commit)
- Creates your `.env` file from the template

---

## Step 4 — Configure Environment

Edit `00-PLATFORM/config/.env` and fill in:

- Your name and email (`RMSEC_OPERATOR`)
- Your GitHub token (`GITHUB_TOKEN`)
- Your engagement store path (`ENGAGEMENT_STORE`)
- Any API keys you have (VirusTotal, Shodan, etc.)

You can add API keys later as you acquire them. Only `RMSEC_OPERATOR` and `ENGAGEMENT_STORE` are required to start working.

---

## Step 5 — Set Up Encrypted Engagement Store

Follow the instructions in `00-PLATFORM/docs/client-data-architecture.md`.

In summary:
1. Install VeraCrypt
2. Create an encrypted container
3. Mount it
4. Set `ENGAGEMENT_STORE` in your `.env` to the mounted path

---

## Step 6 — Pull Docker Images

```bash
docker compose -f 00-PLATFORM/docker/compose/docker-compose.yml pull
```

If images are not yet published to GHCR, build them locally:

```bash
docker build -t rmsecurity/pentest-base:latest 00-PLATFORM/docker/pentest-base/
docker build -t rmsecurity/reporting:latest 00-PLATFORM/docker/reporting/
```

---

## Step 7 — Understand the Repository

Spend 30 minutes reading these files in order:

1. `README.md` — the system overview
2. `01-STANDARDS/README.md` — how everything is named and structured
3. `14-SERVICE-CATALOG/README.md` — what services the company offers
4. `12-CLIENT-LIFECYCLE/README.md` — how engagements flow start to finish

---

## Step 8 — Create Your First Test Engagement

Run this to verify everything works:

```bash
python3 00-PLATFORM/scripts/new-engagement.py --client TESTCLIENT --type pentest-external
```

This creates a scaffolded engagement folder in your encrypted store.
Verify the structure was created correctly, then delete it.

---

## Daily Workflow

```
Morning:
  1. Mount your encrypted VeraCrypt volume
  2. Open the CCOS repo in your editor
  3. git pull (stay current with any platform updates)

During engagement work:
  4. All evidence goes into the encrypted store (never the CCOS repo)
  5. Use CCOS templates and playbooks — never create one-off documents

End of day:
  6. git add + commit any methodology/template improvements you made
  7. Dismount the VeraCrypt volume
  8. Lock the machine
```

---

## Git Workflow

| Action | Command |
|--------|---------|
| Start new work | `git checkout -b feature/my-improvement` |
| Save progress | `git commit -m "descriptive message"` |
| Push for review | `git push origin feature/my-improvement` |
| Open PR | Via GitHub UI — fills in the PR template automatically |

Direct commits to `main` are blocked. All changes require a pull request.

---

## Getting Help

- Something in a playbook is wrong or outdated → open a GitHub Issue using the "Process improvement" template
- You learned something valuable during an engagement → add it to `32-KNOWLEDGE-BASE/`
- You found a gap in the service catalog → open a "New module" issue
