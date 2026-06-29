# Corporate Branding
### rmsecurity | 10-CORPORATE/branding

## Purpose

Single source of truth for all rmsecurity visual identity assets.
Every report, template, presentation, and client-facing document draws
assets from this directory. Nothing is duplicated across domains.

## Directory Structure

```
branding/
├── logo/
│   ├── rmsecurity-logo-primary.png      ← main logo (dark background) — 1080×1080px
│   ├── rmsecurity-logo-light.png        ← version for light backgrounds
│   ├── rmsecurity-logo-square.png       ← square crop for favicons / avatars
│   ├── rmsecurity-logo-horizontal.png   ← horizontal layout for report headers
│   └── rmsecurity-icon-only.png         ← shield icon only, no text
├── colors/
│   └── rmsecurity-palette.md            ← hex codes, RGB, CMYK values
├── fonts/
│   └── fonts.md                         ← approved typefaces and usage rules
└── templates/
    └── brand-guidelines.md              ← full usage rules (spacing, don'ts)
```

## Logo Usage in Automation

The reporting engine reads the logo path from the environment variable:

```bash
RMSEC_LOGO_PATH=/absolute/path/to/ccos/10-CORPORATE/branding/logo/rmsecurity-logo-primary.png
```

Set this in `00-PLATFORM/config/.env`.

## Brand Identity

**Company name:** rmsecurity
**Tagline:** Assess · Protect · Respond · Improve
**Primary colors:** Navy (#0D1B2A), Blue (#1E6FD9), Silver (#C0C0C0)

## Naming Convention for Logo Files

| Variant | Filename pattern | Use case |
|---------|-----------------|---------|
| Primary (dark bg) | `rmsecurity-logo-primary.png` | Reports, presentations, dark headers |
| Light background | `rmsecurity-logo-light.png` | White/light report pages |
| Square | `rmsecurity-logo-square.png` | GitHub avatar, profile photos |
| Horizontal | `rmsecurity-logo-horizontal.png` | Report header banners |
| Icon only | `rmsecurity-icon-only.png` | Watermarks, small-format use |

## File Format Standards

| Format | Use case |
|--------|---------|
| PNG (transparent background) | All digital use, reports |
| SVG | Future web/portal use — request from designer |
| PDF | Print use |

Minimum resolution for PNG variants: **300 DPI** for print, **72 DPI acceptable** for screen-only.
