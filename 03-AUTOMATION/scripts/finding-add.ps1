<#
.SYNOPSIS
    Add a finding to an active engagement.

.DESCRIPTION
    Generates a Finding ID (FND-ENG-YYYY-NNN-NNN), appends it to the engagement
    findings.csv, and creates a pre-filled finding markdown file from the
    KB template for the specified severity/type.

.PARAMETER EngID
    Engagement ID (e.g., ENG-2025-001)

.PARAMETER Title
    Short finding title.

.PARAMETER Severity
    Critical | High | Medium | Low | Informational

.PARAMETER CVSS
    CVSS v3.1 base score (0.0 - 10.0). Optional — fill in later if not yet calculated.

.PARAMETER Target
    Affected target (IP, hostname, URL, or component).

.PARAMETER ClientStore
    Root path of the decrypted VeraCrypt client store. Defaults to E:\rmsecurity-clients

.EXAMPLE
    .\finding-add.ps1 -EngID "ENG-2025-001" -Title "LLMNR Poisoning" -Severity "High" -Target "10.0.0.0/24"
#>

param(
    [Parameter(Mandatory)] [string]$EngID,
    [Parameter(Mandatory)] [string]$Title,
    [Parameter(Mandatory)]
    [ValidateSet("Critical","High","Medium","Low","Informational")]
    [string]$Severity,
    [string]$CVSS    = "TBD",
    [string]$Target  = "TBD",
    [string]$ClientStore = "E:\rmsecurity-clients"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Locate engagement folder ---
$EngFolder = Get-ChildItem -Path $ClientStore -Directory | Where-Object { $_.Name -like "$EngID*" } | Select-Object -First 1
if (-not $EngFolder) {
    Write-Error "Engagement folder for $EngID not found under $ClientStore"
    exit 1
}
$EngPath = $EngFolder.FullName

# --- Generate Finding ID ---
$FindingsCSV = Join-Path $EngPath "04-FINDINGS\findings.csv"
$Existing = @(Import-Csv $FindingsCSV)
$FindingNum = $Existing.Count + 1
$FindingID  = "FND-$EngID-{0:D3}" -f $FindingNum

# --- Append to CSV ---
$Row = [PSCustomObject]@{
    FindingID   = $FindingID
    Title       = $Title
    Severity    = $Severity
    CVSS        = $CVSS
    Status      = "Open"
    Target      = $Target
    Description = ""
}
$Row | Export-Csv -Path $FindingsCSV -Append -NoTypeInformation -Encoding UTF8

# --- Create finding markdown ---
$FindingMD = Join-Path $EngPath "04-FINDINGS\$FindingID.md"
$Content = @"
# $FindingID — $Title

**Severity:** $Severity
**CVSS v3.1:** $CVSS
**Target:** $Target
**Status:** Open
**Found:** $(Get-Date -Format "yyyy-MM-dd")

---

## Description

_Copy from KB template or write here._

## Impact

## Evidence

| Evidence ID | Description |
|------------|-------------|
|            |             |

## Remediation

## References

"@
Set-Content -Path $FindingMD -Value $Content -Encoding UTF8

Write-Host "[OK] Finding created: $FindingID ($Severity) — $Title" -ForegroundColor Green
Write-Host "     File: $FindingMD"
