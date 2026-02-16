param(
    [Parameter(Mandatory = $true)]
    [string]$GamePath,

    [int]$PollMs = 150,

    [ValidateSet("Auto", "SystemSpeech", "SpVoice", "Tolk")]
    [string]$Engine = "Auto",

    [int]$MinSpeakIntervalMs = 120,

    [int]$DedupWindowMs = 1500,

    [string]$TolkPath = "",

    [string]$AnnouncementPath = ""
)

$announcementFiles = @()
if (-not [string]::IsNullOrWhiteSpace($AnnouncementPath)) {
    $announcementFiles += $AnnouncementPath
} else {
    $announcementFiles += (Join-Path $GamePath "accessibility_announce.txt")
    $announcementFiles += (Join-Path (Join-Path $env:LOCALAPPDATA "UNDERTALE") "accessibility_announce.txt")
}
$announcementFiles = $announcementFiles | Select-Object -Unique

$speakerMode = ""
$synth = $null
$spVoice = $null
$tolkReady = $false
$initErrors = @{}

function Initialize-SystemSpeech {
    try {
        Add-Type -AssemblyName System.Speech -ErrorAction Stop
        $script:synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $script:synth.Rate = 0
        $script:speakerMode = "SystemSpeech"
        $script:initErrors["SystemSpeech"] = $null
        return $true
    } catch {
        $script:initErrors["SystemSpeech"] = $_.Exception.Message
        return $false
    }
}

function Initialize-SpVoice {
    try {
        $script:spVoice = New-Object -ComObject SAPI.SpVoice
        $script:speakerMode = "SpVoice"
        $script:initErrors["SpVoice"] = $null
        return $true
    } catch {
        $script:initErrors["SpVoice"] = $_.Exception.Message
        return $false
    }
}

function Initialize-Tolk {
    param([string]$RootPath, [string]$ExplicitTolkPath)
    try {
        $tolkDllPath = $ExplicitTolkPath
        if ([string]::IsNullOrWhiteSpace($tolkDllPath)) {
            $tolkDllPath = Join-Path $RootPath "Tolk.dll"
        }

        if (-not (Test-Path $tolkDllPath)) {
            $script:initErrors["Tolk"] = "Tolk.dll not found: $tolkDllPath"
            return $false
        }

        $tolkDir = Split-Path -Path $tolkDllPath -Parent
        $env:PATH = "$tolkDir;$env:PATH"

        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class TolkBridge {
    [DllImport("Tolk.dll")] public static extern void Tolk_Load();
    [DllImport("Tolk.dll")] public static extern void Tolk_Unload();
    [DllImport("Tolk.dll")] public static extern bool Tolk_IsLoaded();
    [DllImport("Tolk.dll")] public static extern bool Tolk_HasSpeech();
    [DllImport("Tolk.dll", CharSet=CharSet.Unicode)] public static extern bool Tolk_Output(string text, bool interrupt);
}
"@ -ErrorAction Stop

        [TolkBridge]::Tolk_Load()
        if (-not [TolkBridge]::Tolk_IsLoaded()) {
            $script:initErrors["Tolk"] = "Tolk loaded API call returned false."
            return $false
        }
        if (-not [TolkBridge]::Tolk_HasSpeech()) {
            $script:initErrors["Tolk"] = "No screen reader speech provider detected by Tolk."
            return $false
        }

        $script:tolkReady = $true
        $script:speakerMode = "Tolk"
        $script:initErrors["Tolk"] = $null
        return $true
    } catch {
        $script:initErrors["Tolk"] = $_.Exception.Message
        return $false
    }
}

if ($Engine -eq "SystemSpeech") {
    if (-not (Initialize-SystemSpeech)) {
        Write-Error "Failed to initialize SystemSpeech."
        exit 2
    }
} elseif ($Engine -eq "SpVoice") {
    if (-not (Initialize-SpVoice)) {
        Write-Error "Failed to initialize SAPI.SpVoice."
        exit 3
    }
} elseif ($Engine -eq "Tolk") {
    if (-not (Initialize-Tolk -RootPath $GamePath -ExplicitTolkPath $TolkPath)) {
        Write-Error "Failed to initialize Tolk. Ensure Tolk.dll and matching NVDA controller DLL are available."
        exit 5
    }
} else {
    if (-not (Initialize-Tolk -RootPath $GamePath -ExplicitTolkPath $TolkPath)) {
        Write-Warning ("Tolk init failed: " + $initErrors["Tolk"])
        if (-not (Initialize-SystemSpeech)) {
            Write-Warning ("SystemSpeech init failed: " + $initErrors["SystemSpeech"])
            if (-not (Initialize-SpVoice)) {
                Write-Warning ("SpVoice init failed: " + $initErrors["SpVoice"])
                Write-Error "Failed to initialize any speech engine (Tolk, SystemSpeech, SpVoice all failed)."
                exit 4
            }
        }
    }
}

Write-Output "Announcement relay started."
Write-Output "- Watching:"
foreach ($path in $announcementFiles) {
    Write-Output ("  - " + $path)
}
Write-Output "- Engine: $speakerMode"
Write-Output "- Press Ctrl+C to stop."

$lastText = ""
$lastSpeakAt = [datetime]::MinValue
$recentText = @{}
$pathState = @{}
foreach ($path in $announcementFiles) {
    $pathState[$path] = @{
        LastStamp = [datetime]::MinValue
    }
}

while ($true) {
    foreach ($announcementFile in $announcementFiles) {
        if (Test-Path $announcementFile) {
            $item = Get-Item $announcementFile -ErrorAction SilentlyContinue
            if ($null -ne $item -and $item.LastWriteTime -gt $pathState[$announcementFile].LastStamp) {
                $text = (Get-Content $announcementFile -ErrorAction SilentlyContinue | Select-Object -First 1)
                $normalizedText = if ([string]::IsNullOrWhiteSpace($text)) { "" } else { ($text -replace "\s+", " ").Trim() }
                $now = Get-Date

                foreach ($key in @($recentText.Keys)) {
                    if (($now - $recentText[$key]).TotalMilliseconds -gt $DedupWindowMs) {
                        $recentText.Remove($key)
                    }
                }

                $tooSoon = $false
                if ($lastSpeakAt -ne [datetime]::MinValue) {
                    $tooSoon = (($now - $lastSpeakAt).TotalMilliseconds -lt $MinSpeakIntervalMs)
                }

                if (-not [string]::IsNullOrWhiteSpace($normalizedText) -and $normalizedText -ne $lastText -and -not $recentText.ContainsKey($normalizedText) -and -not $tooSoon) {
                    $lastText = $normalizedText
                    $lastSpeakAt = $now
                    $recentText[$normalizedText] = $now
                    $pathState[$announcementFile].LastStamp = $item.LastWriteTime
                    Write-Output ("[ANNOUNCE] " + $normalizedText)
                    if ($speakerMode -eq "SystemSpeech") {
                        $synth.SpeakAsyncCancelAll()
                        [void]$synth.SpeakAsync($normalizedText)
                    } elseif ($speakerMode -eq "Tolk") {
                        [void][TolkBridge]::Tolk_Output($normalizedText, $true)
                    } else {
                        [void]$spVoice.Speak($normalizedText, 1)
                    }
                } else {
                    $pathState[$announcementFile].LastStamp = $item.LastWriteTime
                }
            }
        }
    }
    Start-Sleep -Milliseconds $PollMs
}
