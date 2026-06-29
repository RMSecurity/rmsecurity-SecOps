#!/usr/bin/env python3
"""
rmsecurity CCOS — Repository Structure Validator

Runs in CI to ensure the repository always maintains its intended structure.
Checks that every required directory exists and has a README.md.
Blocks merges if the structure is broken.

Exit code 0 = valid, 1 = violations found.
"""

import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent.parent

REQUIRED_DIRS = [
    "00-PLATFORM",
    "01-STANDARDS",
    "02-QUALITY",
    "03-AUTOMATION",
    "10-CORPORATE",
    "11-BUSINESS-DEV",
    "12-CLIENT-LIFECYCLE",
    "13-PROJECT-MGMT",
    "14-SERVICE-CATALOG",
    "20-RECON-OSINT",
    "21-SECURITY-ASSESSMENT",
    "22-PENTESTING",
    "23-CLOUD-SECURITY",
    "24-VULN-MANAGEMENT",
    "25-BLUE-TEAM",
    "26-INCIDENT-RESPONSE",
    "27-FORENSICS",
    "30-THREAT-INTELLIGENCE",
    "31-RISK-MANAGEMENT",
    "32-KNOWLEDGE-BASE",
    "33-RESEARCH-LAB",
    "34-TRAINING",
    "40-EVIDENCE",
    "41-REPORTING",
    "42-EXECUTIVE-REPORTING",
    "43-REMEDIATION",
    "50-METRICS",
    "51-CONTINUOUS-IMPROV",
    "52-CLIENT-PORTAL",
]

REQUIRED_ROOT_FILES = [
    "README.md",
    ".gitignore",
    ".pre-commit-config.yaml",
]

BLOCKED_PATTERNS = [
    "*.pem", "*.key", "*.p12", "*.pfx",
    "*.nessus", "*.pcap", "*.pcapng",
    ".env",
]


def check_dirs(violations: list) -> None:
    for d in REQUIRED_DIRS:
        path = ROOT / d
        if not path.exists():
            violations.append(f"MISSING DIR:    {d}/")
        elif not (path / "README.md").exists():
            violations.append(f"MISSING README: {d}/README.md")


def check_root_files(violations: list) -> None:
    for f in REQUIRED_ROOT_FILES:
        if not (ROOT / f).exists():
            violations.append(f"MISSING FILE:   {f}")


def check_blocked_files(violations: list) -> None:
    import glob
    for pattern in BLOCKED_PATTERNS:
        matches = list(ROOT.rglob(pattern))
        for match in matches:
            if ".git" not in str(match):
                violations.append(f"BLOCKED FILE:   {match.relative_to(ROOT)}")


def main() -> int:
    print("rmsecurity CCOS — Structure Validator")
    print("=" * 40)

    violations = []
    check_root_files(violations)
    check_dirs(violations)
    check_blocked_files(violations)

    if violations:
        print(f"\n[FAIL] {len(violations)} violation(s) found:\n")
        for v in violations:
            print(f"  {v}")
        print()
        return 1
    else:
        print(f"\n[PASS] Repository structure is valid. ({len(REQUIRED_DIRS)} domains checked)\n")
        return 0


if __name__ == "__main__":
    sys.exit(main())
