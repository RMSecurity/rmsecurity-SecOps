# 00-PLATFORM — Foundation & Platform Core
### rmsecurity | CCOS

## Purpose

This domain is the immune system of the entire CCOS. Every other operational domain
depends on what is defined, configured, and enforced here. It contains:

- The Git repository configuration and branching rules
- The CI/CD pipeline definitions (GitHub Actions)
- The containerized tool environments (Docker)
- The bootstrap and scaffolding scripts
- The environment configuration template
- All platform-level documentation

## Responsibilities

| Responsibility | Owner |
|--------------|-------|
| Secret prevention | Pre-commit hooks + GitHub Actions |
| Repository structure enforcement | `validate-structure.py` + CI |
| Reproducible tool environments | Docker images |
| New consultant onboarding | `bootstrap.sh` + `onboarding.md` |
| New engagement scaffolding | `new-engagement.py` |
| Dependency and version management | `.pre-commit-config.yaml` |

## Directory Structure

```
00-PLATFORM/
├── README.md                      ← this file
├── docker/
│   ├── pentest-base/              ← Kali-based pentest environment
│   │   └── Dockerfile
│   ├── reporting/                 ← Report generation (pandoc + python)
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   └── compose/
│       └── docker-compose.yml     ← Orchestrates the full tool stack
├── scripts/
│   ├── bootstrap.sh               ← Day 1 machine setup
│   ├── new-engagement.py          ← Creates scaffolded engagement folder
│   └── validate-structure.py      ← CI structure linter
├── config/
│   └── .env.example               ← All required environment variables documented
└── docs/
    ├── onboarding.md              ← Step-by-step Day 1 guide
    ├── branching-strategy.md      ← Git workflow rules
    ├── secrets-management.md      ← How secrets are handled
    └── client-data-architecture.md← Encrypted store design and evidence rules
```

## Inputs

- New consultant joining the team
- New engagement signed
- Platform dependency updates (new tools, updated base images)

## Outputs

- Configured workstation ready for operational use
- Scaffolded engagement folder in the encrypted store
- CI-enforced repository integrity on every pull request
- Versioned Docker images published to GHCR

## Naming Conventions

| Object | Convention | Example |
|--------|-----------|---------|
| Scripts | `kebab-case.py` or `.sh` | `new-engagement.py` |
| Docker images | `rmsecurity/<name>:<tag>` | `rmsecurity/pentest-base:latest` |
| Workflow files | `<action>.yml` | `validate.yml` |
| Documentation | `kebab-case.md` | `branching-strategy.md` |

## Related Domains

- `01-STANDARDS` — defines naming conventions enforced here
- `03-AUTOMATION` — builds on the platform to automate higher-level operations
- `02-QUALITY` — quality gates are enforced through CI pipelines defined here

## Future Improvements

- [ ] Add GitHub Codespaces `devcontainer.json` for zero-local-setup environments
- [ ] Add Dependabot configuration for automated dependency updates
- [ ] Add SBOM (Software Bill of Materials) generation for Docker images
- [ ] Integrate Vault (HashiCorp) when team size exceeds 3 operators
- [ ] Add infrastructure-as-code (Terraform) for cloud lab environments
