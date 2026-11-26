# Soak-test sampler: every 60 s appends uxplay.exe CPU %, working set (MB) and handle count to logs\monitor.csv.
# CPU % is averaged over the interval and normalised to all logical cores (100 = whole machine).
param([int]$IntervalSeconds = 60)
$csv = Join-Path $PSScriptRoot 'logs\monitor.csv'
New-Item -ItemType Directory -Force (Split-Path $csv) | Out-Null
if (-not (Test-Path $csv)) { 'timestamp,pid,cpu_percent,working_set_mb,handles' | Set-Content $csv }
$cores = [Environment]::ProcessorCount
$prev = @{}
while ($true) {
    $now = Get-Date
    $procs = @(Get-Process uxplay -ErrorAction SilentlyContinue)
    if (-not $procs) { "{0:s},,,," -f $now | Add-Content $csv }
    foreach ($p in $procs) {
        $cpu = ''
        if ($prev.ContainsKey($p.Id)) {
            $dt = ($now - $prev[$p.Id].Time).TotalSeconds
            $cpu = [math]::Round(($p.TotalProcessorTime - $prev[$p.Id].Cpu).TotalSeconds / $dt / $cores * 100, 1)
        }
        $prev[$p.Id] = @{ Time = $now; Cpu = $p.TotalProcessorTime }
        '{0:s},{1},{2},{3},{4}' -f $now, $p.Id, $cpu, [math]::Round($p.WorkingSet64 / 1MB, 1), $p.HandleCount | Add-Content $csv
    }
    Start-Sleep -Seconds $IntervalSeconds
}
