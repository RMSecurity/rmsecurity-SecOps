<#
.SYNOPSIS
    Scaffold a new rmsecurity engagement directory.

.DESCRIPTION
    Creates an engagement folder under the VeraCrypt client store with the
    standard structure. Generates the Engagement ID, pre-fills the manifest
    CSV, and opens the scoping template.

.PARAMETER ClientName
    Short client name (used in folder name and documents).

.PARAMETER Type
    Engagement type: ExternalPentest | InternalPentest | WebApp | CloudAssessment | IR | RedTeam

.PARAMETER ClientStore
    Root path of the decrypted VeraCrypt client store. Defaults to E:\rmsecurity-clients

.EXAMPLE
    .\new-engagement.ps1 -ClientName "Acme Corp" -Type "InternalPentest"
#>

param(
    [Parameter(Mandatory)]
    [string]$ClientName,

    [Parameter(Mandatory)]
    [ValidateSet("ExternalPentest","InternalPentest","WebApp","CloudAssessment","IR","RedTeam")]
    [string]$Type,

    [string]$ClientStore = "E:\rmsecurity-clients"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Generate Engagement ID ---
$Year  = (Get-Date).Year
$CountFile = Join-Path $ClientStore ".engagement-counter-$Year.txt"
if (Test-Path $CountFile) {
    $Counter = [int](Get-Content $CountFile) + 1
} else {
    $Counter = 1
}
$Counter | Set-Content $CountFile
$EngID = "ENG-$Year-{0:D3}" -f $Counter

# --- Sanitize client name for filesystem ---
$ClientSlug = $ClientName -replace '[^A-Za-z0-9\-]', '-' -replace '-+', '-'
$FolderName = "$EngID-$ClientSlug"
$EngPath    = Join-Path $ClientStore $FolderName

Write-Host "`n[rmsecurity] Creating engagement: $EngID" -ForegroundColor Cyan
Write-Host "  Client  : $ClientName"
Write-Host "  Type    : $Type"
Write-Host "  Path    : $EngPath`n"

# --- Build directory structure ---
$Dirs = @(
    "00-SCOPE",
    "01-RECON",
    "02-TESTING",
    "02-TESTING\screenshots",
    "03-EVIDENCE",
    "04-FINDINGS",
    "05-REPORT",
    "05-REPORT\drafts",
    "06-DELIVERY"
)

foreach ($Dir in $Dirs) {
    New-Item -ItemType Directory -Path (Join-Path $EngPath $Dir) -Force | Out-Null
}

# --- Create manifest CSV ---
$ManifestPath = Join-Path $EngPath "03-EVIDENCE\manifest.csv"
$ManifestHeader = "EvidenceID,Filename,SHA256,CollectedAt,CollectedBy,Description,ChainOfCustody"
Set-Content -Path $ManifestPath -Value $ManifestHeader -Encoding UTF8

# --- Create findings log ---
$FindingsPath = Join-Path $EngPath "04-FINDINGS\findings.csv"
$FindingsHeader = "FindingID,Title,Severity,CVSS,Status,Target,Description"
Set-Content -Path $FindingsPath -Value $FindingsHeader -Encoding UTF8

# --- Create engagement README ---
$ReadmePath = Join-Path $EngPath "README.md"
$ReadmeContent = @"
# $EngID — $ClientName
**Type:** $Type
**Started:** $(Get-Date -Format "yyyy-MM-dd")
**Status:** Active

## Scope
_Fill in after kick-off call_

## Key Contacts
| Name | Role | Email | Phone |
|------|------|-------|-------|
|      |      |       |       |

## Quality Gates
- [ ] Gate 1 — Scope signed off
- [ ] Gate 2 — Testing complete, all findings documented
- [ ] Gate 3 — Report reviewed internally
- [ ] Gate 4 — Delivered and client acknowledged

## Notes
"@
Set-Content -Path $ReadmePath -Value $ReadmeContent -Encoding UTF8

Write-Host "[OK] Engagement scaffold created at: $EngPath" -ForegroundColor Green
Write-Host "[OK] Engagement ID: $EngID" -ForegroundColor Green
Write-Host "`nNext steps:"
Write-Host "  1. Decrypt scope documents from client and place in $EngPath\00-SCOPE\"
Write-Host "  2. Complete kick-off checklist in 12-CLIENT-LIFECYCLE\"
Write-Host "  3. Run gate-check.ps1 -EngID $EngID -Gate 1 when scope is signed`n"
