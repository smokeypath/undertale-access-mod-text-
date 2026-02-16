param(
    [Parameter(Mandatory = $true)]
    [string]$GamePath,

    [string]$UtmtPath = "",
    [string]$XdeltaPath = ""
)

function Test-CommandExists {
    param([string]$Name)
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    return $null -ne $cmd
}

function Get-PeMachine {
    param([string]$ExePath)
    if (-not (Test-Path $ExePath)) { return "missing" }
    $fs = [System.IO.File]::OpenRead($ExePath)
    try {
        $br = New-Object System.IO.BinaryReader($fs)
        $fs.Seek(0x3C, [System.IO.SeekOrigin]::Begin) | Out-Null
        $peOffset = $br.ReadInt32()
        $fs.Seek($peOffset + 4, [System.IO.SeekOrigin]::Begin) | Out-Null
        $machine = $br.ReadUInt16()
        switch ($machine) {
            0x014c { return "x86" }
            0x8664 { return "x64" }
            default { return ("unknown(0x{0:X4})" -f $machine) }
        }
    } finally {
        $fs.Close()
    }
}

$repoRoot = (Get-Location).Path
$dataWin = Join-Path $GamePath "data.win"
$exePath = Join-Path $GamePath "UNDERTALE.exe"
$optionsIni = Join-Path $GamePath "options.ini"

Write-Output "GameMaker Setup Check"
Write-Output "- Repo root: $repoRoot"
Write-Output "- Game path: $GamePath"

if (-not (Test-Path $GamePath)) {
    Write-Output "- ERROR: Game path not found."
    exit 1
}

$dataWinExists = Test-Path $dataWin
$exeExists = Test-Path $exePath
$optionsExists = Test-Path $optionsIni
$exeMachine = Get-PeMachine -ExePath $exePath

$dataHash = ""
if ($dataWinExists) {
    $dataHash = (Get-FileHash $dataWin -Algorithm SHA256).Hash
}

$utmtFound = $false
if ($UtmtPath -and (Test-Path $UtmtPath)) {
    $utmtFound = $true
} elseif (Test-CommandExists -Name "UndertaleModTool") {
    $utmtFound = $true
} elseif (Test-CommandExists -Name "utmt") {
    $utmtFound = $true
}

$xdeltaFound = $false
if ($XdeltaPath -and (Test-Path $XdeltaPath)) {
    $xdeltaFound = $true
} elseif (Test-CommandExists -Name "xdelta3") {
    $xdeltaFound = $true
}

$originalDir = Join-Path $repoRoot "artifacts\original"
$workingDir = Join-Path $repoRoot "artifacts\working"
$patchesDir = Join-Path $repoRoot "patches"

Write-Output "- data.win: $($dataWinExists)"
Write-Output "- UNDERTALE.exe: $($exeExists)"
Write-Output "- options.ini: $($optionsExists)"
Write-Output "- EXE machine: $exeMachine"
if ($dataHash) {
    Write-Output "- data.win sha256: $dataHash"
}
Write-Output "- UndertaleModTool available: $utmtFound"
Write-Output "- xdelta3 available (optional): $xdeltaFound"
Write-Output "- artifacts\\original exists: $(Test-Path $originalDir)"
Write-Output "- artifacts\\working exists: $(Test-Path $workingDir)"
Write-Output "- patches exists: $(Test-Path $patchesDir)"

if (-not $dataWinExists -or -not $exeExists) {
    Write-Output "- RESULT: FAIL (missing required game files)"
    exit 2
}

if (-not $utmtFound) {
    Write-Output "- RESULT: PARTIAL (install UndertaleModTool next)"
    exit 0
}

Write-Output "- RESULT: OK (ready for data.win extraction/modding)"
exit 0
