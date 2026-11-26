# Supervisor: runs uxplay.exe with receiver.config.ps1, logs output with timestamps to
# logs\uxplay-YYYY-MM-DD.log, logs every exit code, waits 5 s and restarts. Keeps 14 days of logs.
$Root = $PSScriptRoot
. (Join-Path $Root 'receiver.config.ps1')

$LogDir = Join-Path $Root 'logs'
New-Item -ItemType Directory -Force $LogDir | Out-Null
$Exe = Join-Path $Root 'bin\uxplay.exe'

# Use only the bundled DLLs/plugins, never an MSYS2 install that may also exist on the PC.
$env:PATH = "$Root\bin;$env:SystemRoot\System32;$env:SystemRoot;$env:SystemRoot\System32\WindowsPowerShell\v1.0"
$env:GST_PLUGIN_SYSTEM_PATH_1_0 = Join-Path $Root 'lib\gstreamer-1.0'
$env:GST_PLUGIN_SCANNER_1_0 = Join-Path $Root 'libexec\gstreamer-1.0\gst-plugin-scanner.exe'
$env:GST_REGISTRY_1_0 = Join-Path $Root 'gst-registry.bin'

function Write-Log([string]$Line) {
    $now = Get-Date
    Add-Content -Path (Join-Path $LogDir ('uxplay-{0:yyyy-MM-dd}.log' -f $now)) -Value ('{0:yyyy-MM-dd HH:mm:ss} {1}' -f $now, $Line)
}

while ($true) {
    Get-ChildItem $LogDir -Filter 'uxplay-*.log' |
        Where-Object LastWriteTime -lt (Get-Date).AddDays(-14) | Remove-Item -ErrorAction SilentlyContinue

    Write-Log "START $Exe $($UxPlayArgs -join ' ')"
    # 'Continue' so stderr lines are logged instead of stopping the script (Windows PowerShell 5.1).
    $ErrorActionPreference = 'Continue'
    & $Exe @UxPlayArgs 2>&1 | ForEach-Object { Write-Log "$_" }
    Write-Log "EXIT code $LASTEXITCODE; restarting in 5 s"
    Start-Sleep -Seconds 5
}
