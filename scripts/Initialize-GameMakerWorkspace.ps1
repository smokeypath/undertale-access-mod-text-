param(
    [Parameter(Mandatory = $true)]
    [string]$GamePath
)

$repoRoot = (Get-Location).Path
$dataWin = Join-Path $GamePath "data.win"
$exePath = Join-Path $GamePath "UNDERTALE.exe"

if (-not (Test-Path $GamePath)) {
    Write-Output "ERROR: Game path not found: $GamePath"
    exit 1
}

if (-not (Test-Path $dataWin)) {
    Write-Output "ERROR: data.win not found: $dataWin"
    exit 2
}

if (-not (Test-Path $exePath)) {
    Write-Output "ERROR: UNDERTALE.exe not found: $exePath"
    exit 3
}

$originalDir = Join-Path $repoRoot "artifacts\original"
$workingDir = Join-Path $repoRoot "artifacts\working"
$patchesDir = Join-Path $repoRoot "patches"
$metadataDir = Join-Path $repoRoot "artifacts\metadata"

New-Item -ItemType Directory -Path $originalDir -Force | Out-Null
New-Item -ItemType Directory -Path $workingDir -Force | Out-Null
New-Item -ItemType Directory -Path $patchesDir -Force | Out-Null
New-Item -ItemType Directory -Path $metadataDir -Force | Out-Null

$originalDataWin = Join-Path $originalDir "data.win"
$workingDataWin = Join-Path $workingDir "data.win"

Copy-Item -Path $dataWin -Destination $originalDataWin -Force
Copy-Item -Path $dataWin -Destination $workingDataWin -Force

$hash = (Get-FileHash $dataWin -Algorithm SHA256).Hash
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$metadataPath = Join-Path $metadataDir "setup.json"

$metadata = @"
{
  "gamePath": "$($GamePath.Replace('\', '\\'))",
  "repoRoot": "$($repoRoot.Replace('\', '\\'))",
  "initializedAt": "$stamp",
  "dataWinSha256": "$hash",
  "artifacts": {
    "originalDataWin": "$($originalDataWin.Replace('\', '\\'))",
    "workingDataWin": "$($workingDataWin.Replace('\', '\\'))"
  }
}
"@

Set-Content -Path $metadataPath -Value $metadata -Encoding UTF8

Write-Output "GameMaker workspace initialized."
Write-Output "- Original: $originalDataWin"
Write-Output "- Working: $workingDataWin"
Write-Output "- Metadata: $metadataPath"
Write-Output "- SHA256: $hash"
