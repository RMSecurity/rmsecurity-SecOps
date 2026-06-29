<#
.SYNOPSIS
    Register an evidence file for an engagement — compute SHA-256 and append to manifest.

.PARAMETER EngID
    Engagement ID (e.g., ENG-2025-001)

.PARAMETER File
    Full path to the evidence file to register.

.PARAMETER Description
    Short description of what this evidence shows.

.PARAMETER ClientStore
    Root path of the decrypted VeraCrypt client store. Defaults to E:\rmsecurity-clients

.EXAMPLE
    .\evidence-register.ps1 -EngID "ENG-2025-001" -File "C:\tmp\responder.txt" -Description "Responder output showing NTLMv2 hash for user jsmith"
#>

param(
    [Parameter(Mandatory)] [string]$EngID,
    [Parameter(Mandatory)] [string]$File,
    [Parameter(Mandatory)] [string]$Description,
    [string]$ClientStore = "E:\rmsecurity-clients"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Validate source file ---
if (-not (Test-Path $File)) {
    Write-Error "Evidence file not found: $File"
    exit 1
}

# --- Locate engagement ---
$EngFolder = Get-ChildItem -Path $ClientStore -Directory | Where-Object { $_.Name -like "$EngID*" } | Select-Object -First 1
if (-not $EngFolder) {
    Write-Error "Engagement folder for $EngID not found"
    exit 1
}
$EvidenceDir = Join-Path $EngFolder.FullName "03-EVIDENCE"
$ManifestCSV = Join-Path $EvidenceDir "manifest.csv"

# --- Generate Evidence ID ---
$Existing  = @(Import-Csv $ManifestCSV)
$EvidenceNum = $Existing.Count + 1
$EvidenceID  = "EV-$EngID-{0:D3}" -f $EvidenceNum

# --- Copy file to evidence directory ---
$DestFilename = "$EvidenceID-$(Split-Path $File -Leaf)"
$DestPath     = Join-Path $EvidenceDir $DestFilename
Copy-Item -Path $File -Destination $DestPath

# --- Compute SHA-256 ---
$Hash = (Get-FileHash -Path $DestPath -Algorithm SHA256).Hash

# --- Append to manifest ---
$Row = [PSCustomObject]@{
    EvidenceID       = $EvidenceID
    Filename         = $DestFilename
    SHA256           = $Hash
    CollectedAt      = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    CollectedBy      = $env:USERNAME
    Description      = $Description
    ChainOfCustody   = "Original file copied from: $File"
}
$Row | Export-Csv -Path $ManifestCSV -Append -NoTypeInformation -Encoding UTF8

Write-Host "[OK] Evidence registered: $EvidenceID" -ForegroundColor Green
Write-Host "     SHA-256 : $Hash"
Write-Host "     Stored  : $DestPath"
