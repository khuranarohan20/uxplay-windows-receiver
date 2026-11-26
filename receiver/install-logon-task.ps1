# Registers a Task Scheduler task that runs start-receiver.ps1 when the given local user logs on,
# in that user's desktop session (a Windows service cannot draw on the desktop).
# Run from an elevated PowerShell:  .\install-logon-task.ps1 -UserName "CommandCenter"
param(
    [Parameter(Mandatory)] [string]$UserName,
    [string]$TaskName = 'UxPlay Receiver'
)
$script = Join-Path $PSScriptRoot 'start-receiver.ps1'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`"" `
    -WorkingDirectory $PSScriptRoot
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $UserName
$principal = New-ScheduledTaskPrincipal -UserId $UserName -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew `
    -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings
