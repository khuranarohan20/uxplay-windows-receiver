# Command Center AirPlay receiver (UxPlay, terminal only)

`bin\uxplay.exe` is UxPlay (GPLv3, https://github.com/FDH2/UxPlay), built unmodified.
Version/commit: `THIRD_PARTY_NOTICES.md`. All options: `docs\uxplay-help.txt`.

## Configure
Edit `receiver.config.ps1`. **Change the password** (`-pw ChangeMe26`) before use. Do not use `-pin`: it crashes UxPlay 1.74 after pairing ([FDH2/UxPlay#646](https://github.com/FDH2/UxPlay/issues/646)).
Sink fallback: replace `d3d12videosink` with `d3d11videosink` if video doesn't show.

## Firewall
See `docs\FIREWALL.md` (run as Administrator, after review).

## Start / stop
```powershell
powershell -ExecutionPolicy Bypass -File .\start-receiver.ps1     # start (restarts uxplay on exit)
```
Stop: Ctrl+C in that window. If running hidden as a task:
`Stop-ScheduledTask 'UxPlay Receiver'; Stop-Process -Name uxplay -ErrorAction SilentlyContinue`
(stop the task first, otherwise the supervisor restarts uxplay after 5 s).

Debug logging: set `$UxPlayDebug = $true` in `receiver.config.ps1`.

## Run at logon (optional)
```powershell
powershell -ExecutionPolicy Bypass -File .\install-logon-task.ps1 -UserName <localuser>
```
Remove: `Unregister-ScheduledTask 'UxPlay Receiver' -Confirm:$false`.
It is a logon task, not a service, because services cannot draw on the desktop.
The user must be logged in (consider auto-logon on a dedicated, locked-down PC).

## Logs
- `logs\uxplay-YYYY-MM-DD.log` — uxplay output + every start/exit with exit code; 14 days kept.
- `logs\monitor.csv` — from `.\monitor.ps1` (CPU %, working set, handles every 60 s) for soak tests.
- `logs\build.log` — CI build log.

## Tests
`docs\TEST-CHECKLIST.md`.
