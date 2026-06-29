<#
.SYNOPSIS
    Run the engagement closure checklist interactively.

.PARAMETER EngID
    Engagement ID (e.g., ENG-2025-001)

.PARAMETER ClientStore
    Root path of the decrypted VeraCrypt client store. Defaults to E:\rmsecurity-clients
#>

param(
    [Parameter(Mandatory)] [string]$EngID,
    [string]$ClientStore = "E:\rmsecurity-clients"
)

Set-StrictMode -Version Latest

$EngFolder = Get-ChildItem -Path $ClientStore -Directory | Where-Object { $_.Name -like "$EngID*" } | Select-Object -First 1
if (-not $EngFolder) { Write-Error "Engagement $EngID not found"; exit 1 }

Write-Host "`n[rmsecurity] Engagement Closure — $EngID" -ForegroundColor Cyan
Write-Host "=" * 55

$Checklist = @(
    "Final report delivered and client acknowledged receipt",
    "Gate 4 checked off in engagement README",
    "Evidence archive backed up to offline storage",
    "No client data remains on testing machine / Kali VM",
    "VPN credentials / test accounts deactivated (confirm with client)",
    "Engagement added to pipeline-tracker as Closed/Won",
    "Invoice sent (if not on retainer)",
    "Post-engagement NPS survey sent",
    "Retrospective written in 32-KNOWLEDGE-BASE/lessons-learned/",
    "Any new finding types added to KB"
)

$AllDone = $true
foreach ($Item in $Checklist) {
    $Response = Read-Host "  [ ] $Item`n      Complete? (y/n)"
    if ($Response -ne "y") {
        Write-Host "      ^ Pending — complete before archiving" -ForegroundColor Yellow
        $AllDone = $false
    }
}

Write-Host "`n" + "=" * 55
if ($AllDone) {
    Write-Host "[COMPLETE] Engagement $EngID closed successfully." -ForegroundColor Green
    Write-Host "           You may now lock the VeraCrypt client volume."
} else {
    Write-Host "[INCOMPLETE] Complete the pending items above before closing." -ForegroundColor Yellow
}
