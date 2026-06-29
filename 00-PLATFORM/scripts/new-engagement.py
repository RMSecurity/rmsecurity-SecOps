#!/usr/bin/env python3
"""
rmsecurity CCOS — New Engagement Scaffolder

Creates a fresh engagement folder in the encrypted engagement store,
pre-populated with the correct directory structure, naming conventions,
and operational templates.

Usage:
    python3 00-PLATFORM/scripts/new-engagement.py

The engagement ID format is: ENG-YYYY-NNN
Example: ENG-2026-001
"""

import os
import sys
import json
import shutil
import argparse
from datetime import datetime
from pathlib import Path


ENGAGEMENT_STORE = Path(os.environ.get("ENGAGEMENT_STORE", Path.home() / "rmsecurity-engagements"))

ENGAGEMENT_TYPES = {
    "pentest-internal": "Internal Network Penetration Test",
    "pentest-external": "External Network Penetration Test",
    "pentest-web":      "Web Application Penetration Test",
    "pentest-ad":       "Active Directory Security Assessment",
    "pentest-red":      "Red Team Engagement",
    "assessment-gap":   "Security Gap Assessment",
    "assessment-cloud": "Cloud Security Assessment",
    "assessment-m365":  "Microsoft 365 Security Assessment",
    "vuln-management":  "Vulnerability Management Program",
    "incident-response":"Incident Response",
    "forensics":        "Digital Forensics Investigation",
    "phishing":         "Phishing Simulation",
    "compliance":       "Compliance Assessment",
    "training":         "Security Training Delivery",
}

ENGAGEMENT_STRUCTURE = [
    "00-admin",
    "00-admin/contracts",
    "00-admin/roe",
    "00-admin/comms",
    "01-recon",
    "01-recon/passive",
    "01-recon/active",
    "01-recon/osint",
    "02-assessment",
    "02-assessment/scans",
    "02-assessment/manual",
    "02-assessment/screenshots",
    "03-exploitation",
    "03-exploitation/payloads",
    "03-exploitation/shells",
    "03-exploitation/loot",
    "04-evidence",
    "04-evidence/screenshots",
    "04-evidence/logs",
    "04-evidence/artifacts",
    "04-evidence/chain-of-custody",
    "05-findings",
    "06-reports",
    "06-reports/drafts",
    "06-reports/final",
    "07-remediation",
    "07-remediation/tracking",
    "07-remediation/retests",
    "08-archive",
]


def get_next_engagement_id() -> str:
    year = datetime.now().year
    if not ENGAGEMENT_STORE.exists():
        return f"ENG-{year}-001"

    existing = [
        d.name for d in ENGAGEMENT_STORE.iterdir()
        if d.is_dir() and d.name.startswith(f"ENG-{year}-")
    ]
    if not existing:
        return f"ENG-{year}-001"

    last_num = max(int(d.split("-")[2]) for d in existing)
    return f"ENG-{year}-{(last_num + 1):03d}"


def create_engagement_metadata(eng_id: str, client_alias: str, eng_type: str, start_date: str) -> dict:
    return {
        "engagement_id": eng_id,
        "client_alias": client_alias,
        "engagement_type": eng_type,
        "engagement_type_label": ENGAGEMENT_TYPES.get(eng_type, eng_type),
        "start_date": start_date,
        "created_at": datetime.now().isoformat(),
        "status": "active",
        "operator": os.environ.get("RMSEC_OPERATOR", "unset"),
        "ccos_version": "1.0.0",
        "notes": "",
    }


def scaffold_engagement(eng_id: str, client_alias: str, eng_type: str) -> Path:
    if not ENGAGEMENT_STORE.exists():
        print(f"[ERROR] Engagement store not found at {ENGAGEMENT_STORE}")
        print("        Set up your encrypted store first.")
        print("        See: 00-PLATFORM/docs/client-data-architecture.md")
        sys.exit(1)

    folder_name = f"{eng_id}_{client_alias.upper().replace(' ', '-')}_{eng_type.upper()}"
    eng_path = ENGAGEMENT_STORE / folder_name

    if eng_path.exists():
        print(f"[ERROR] Engagement folder already exists: {eng_path}")
        sys.exit(1)

    print(f"\n  Creating engagement: {eng_id}")
    print(f"  Client alias:        {client_alias}")
    print(f"  Type:                {ENGAGEMENT_TYPES.get(eng_type, eng_type)}")
    print(f"  Path:                {eng_path}")
    print()

    for subdir in ENGAGEMENT_STRUCTURE:
        (eng_path / subdir).mkdir(parents=True, exist_ok=True)

    # Metadata file
    meta = create_engagement_metadata(eng_id, client_alias, eng_type, datetime.now().strftime("%Y-%m-%d"))
    with open(eng_path / "engagement.json", "w") as f:
        json.dump(meta, f, indent=2)

    # Placeholder README
    readme_content = f"""# {eng_id} — {client_alias} — {ENGAGEMENT_TYPES.get(eng_type, eng_type)}

**Status:** Active
**Start date:** {meta['start_date']}
**Operator:** {meta['operator']}

## Folder structure

| Folder | Purpose |
|--------|---------|
| 00-admin/ | Contracts, ROE, communication logs |
| 01-recon/ | Reconnaissance and OSINT output |
| 02-assessment/ | Scan results and manual findings |
| 03-exploitation/ | Exploitation artifacts (payloads, shells, loot) |
| 04-evidence/ | Numbered evidence with chain of custody |
| 05-findings/ | Individual finding documentation |
| 06-reports/ | Draft and final reports |
| 07-remediation/ | Remediation tracking and retest results |
| 08-archive/ | Final archive after engagement close |

## Evidence numbering

All evidence files must follow: `EV-{eng_id}-NNN_description.ext`
Example: `EV-{eng_id}-001_rdp-login-screenshot.png`

Log the hash of every evidence file in `04-evidence/chain-of-custody/manifest.csv`.
"""
    with open(eng_path / "README.md", "w") as f:
        f.write(readme_content)

    # Chain of custody manifest
    coc_header = "evidence_id,filename,sha256,collected_at,collected_by,tool_used,notes\n"
    with open(eng_path / "04-evidence/chain-of-custody/manifest.csv", "w") as f:
        f.write(coc_header)

    print(f"  [OK] Engagement scaffolded successfully.")
    print(f"\n  Next steps:")
    print(f"    1. Copy signed contract to:  {eng_path}/00-admin/contracts/")
    print(f"    2. Copy signed ROE to:       {eng_path}/00-admin/roe/")
    print(f"    3. Begin recon in:           {eng_path}/01-recon/")
    print()

    return eng_path


def main():
    parser = argparse.ArgumentParser(description="rmsecurity — Create new engagement")
    parser.add_argument("--client", help="Client alias (e.g., ACMECORP) — no real names")
    parser.add_argument("--type", help="Engagement type", choices=list(ENGAGEMENT_TYPES.keys()))
    args = parser.parse_args()

    print("\n  rmsecurity CCOS — New Engagement Scaffolder")
    print("  " + "=" * 44)

    client_alias = args.client
    if not client_alias:
        print("\n  Available engagement types:")
        for key, label in ENGAGEMENT_TYPES.items():
            print(f"    {key:<25} {label}")
        print()
        client_alias = input("  Client alias (no real names, e.g. ACMECORP): ").strip().upper()

    eng_type = args.type
    if not eng_type:
        eng_type = input("  Engagement type: ").strip()

    if eng_type not in ENGAGEMENT_TYPES:
        print(f"[ERROR] Unknown engagement type: {eng_type}")
        sys.exit(1)

    eng_id = get_next_engagement_id()
    scaffold_engagement(eng_id, client_alias, eng_type)


if __name__ == "__main__":
    main()
