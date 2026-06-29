<#
.SYNOPSIS
    Validate Quality Gate requirements for an engagement.

.DESCRIPTION
    Checks that the engagement meets all requirements for the specified gate
    before allowing progression. Gates 1-4 map to the rmsecurity quality
    gate model.

.PARAMETER EngID
    Engagement ID (e.g., ENG-2025-001)

.PARAMETER Gate
    Gate number: 1 | 2 | 3 | 4

.PARAMETER ClientStore
    Root path of the decrypted VeraCrypt client store. Defaults to E:\rmsecurity-clients

.EXAMPLE
    .\gate-check.ps1 -EngID "ENG-2025-001" -Gate 2
#>

param(
    [Parameter(Mandatory)] [string]$EngID,
    [Parameter(Mandatory)] [ValidateRange(1,4)] [int]$Gate,
    [string]$ClientStore = "E:\rmsecurity-clients"
)

Set-StrictMode -Version Latest

$EngFolder = Get-ChildItem -Path $ClientStore -Directory | Where-Object { $_.Name -like "$EngID*" } | Select-Object -First 1
if (-not $EngFolder) { Write-Error "Engagement $EngID not found"; exit 1 }
$EngPath = $EngFolder.FullName

$Pass    = $true
$Results = @()

function Check {
    param([string]$Description, [bool]$Result)
    $Status = if ($Result) { "[PASS]" } else { "[FAIL]" }
    $Color  = if ($Result) { "Green" } else { "Red" }
    Write-Host "  $Status $Description" -ForegroundColor $Color
    if (-not $Result) { $script:Pass = $false }
}

Write-Host "`n[rmsecurity] Quality Gate $Gate — $EngID" -ForegroundColor Cyan
Write-Host ("-" * 55)

switch ($Gate) {
    1 {
        Write-Host "Gate 1: Scope & Authorization"
        Check "00-SCOPE directory exists" (Test-Path (Join-Path $EngPath "00-SCOPE"))
        Check "Scope file present in 00-SCOPE" ((Get-ChildItem (Join-Path $EngPath "00-SCOPE") -ErrorAction SilentlyContinue).Count -gt 0)
        Check "README.md exists" (Test-Path (Join-Path $EngPath "README.md"))
        Check "Findings CSV initialized" (Test-Path (Join-Path $EngPath "04-FINDINGS\findings.csv"))
        Check "Evidence manifest initialized" (Test-Path (Join-Path $EngPath "03-EVIDENCE\manifest.csv"))
    }
    2 {
        Write-Host "Gate 2: Testing Complete"
        $Findings = @(Import-Csv (Join-Path $EngPath "04-FINDINGS\findings.csv") -ErrorAction SilentlyContinue)
        Check "At least one finding documented" ($Findings.Count -gt 0)
        Check "No findings with empty Title" (($Findings | Where-Object { -not $_.Title }).Count -eq 0)
        Check "All findings have Severity" (($Findings | Where-Object { -not $_.Severity }).Count -eq 0)
        $Evidence = @(Import-Csv (Join-Path $EngPath "03-EVIDENCE\manifest.csv") -ErrorAction SilentlyContinue)
        Check "At least one evidence item registered" ($Evidence.Count -gt 0)
        Check "All evidence has SHA-256 hash" (($Evidence | Where-Object { -not $_.SHA256 }).Count -eq 0)
    }
    3 {
        Write-Host "Gate 3: Report Reviewed"
        $DraftsDir = Join-Path $EngPath "05-REPORT\drafts"
        $ReportDir = Join-Path $EngPath "05-REPORT"
        Check "Report draft exists" ((Get-ChildItem $DraftsDir -ErrorAction SilentlyContinue).Count -gt 0)
        Check "Report directory has files" ((Get-ChildItem $ReportDir -ErrorAction SilentlyContinue).Count -gt 0)
        $Findings = @(Import-Csv (Join-Path $EngPath "04-FINDINGS\findings.csv") -ErrorAction SilentlyContinue)
        $OpenCritHigh = @($Findings | Where-Object { $_.Severity -in @("Critical","High") -and $_.Status -eq "Open" })
        Check "All Critical/High findings have descriptions" `
            (($Findings | Where-Object { $_.Severity -in @("Critical","High") -and -not $_.Description }).Count -eq 0)
    }
    4 {
        Write-Host "Gate 4: Delivery Complete"
        $DeliveryDir = Join-Path $EngPath "06-DELIVERY"
        Check "06-DELIVERY directory exists" (Test-Path $DeliveryDir)
        Check "Delivery contains files" ((Get-ChildItem $DeliveryDir -ErrorAction SilentlyContinue).Count -gt 0)
        $ReadmeContent = Get-Content (Join-Path $EngPath "README.md") -Raw -ErrorAction SilentlyContinue
        Check "Gate 4 checked off in README" ($ReadmeContent -match "\[x\] Gate 4")
    }
}

Write-Host ("-" * 55)
if ($Pass) {
    Write-Host "`n[PASS] Gate $Gate requirements met. Proceed to next phase." -ForegroundColor Green
} else {
    Write-Host "`n[FAIL] Gate $Gate not cleared. Resolve the items above before proceeding." -ForegroundColor Red
    exit 1
}
