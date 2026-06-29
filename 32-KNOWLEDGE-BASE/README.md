# 32-KNOWLEDGE-BASE — Findings Knowledge Base
### rmsecurity | CCOS

## Purpose

Library of pre-written, quality-reviewed findings that can be adapted for
any engagement. A finding written once and reviewed becomes a reusable asset
that improves report quality and reduces writing time.

## Directory Structure

```
32-KNOWLEDGE-BASE/
├── README.md
├── findings/
│   ├── network/
│   ├── web/
│   ├── active-directory/
│   └── cloud/
└── lessons-learned/
    └── engagement-retrospectives.md
```

## How to Use

1. Search this library for a finding that matches what you found
2. Copy the template to the engagement findings folder (`05-findings/`)
3. Replace `[PLACEHOLDER]` values with engagement-specific details
4. Add your specific evidence references
5. Adjust CVSS score for the specific context
6. Run Gate 2 validation before including in report

## How to Contribute

After each engagement, if you wrote a new finding type not in the library:
1. Generalize it (remove client-specific details)
2. Have a peer review the write-up
3. Add to the appropriate category in this library
4. Commit with message: `[kb] add finding: [short name]`

## Related Domains

- `01-STANDARDS/document-standards/finding-format.md` — format standard
- `02-QUALITY/gates/gate-2-finding-validation.md` — validation before use
