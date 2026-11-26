# Firewall rules (NOT applied automatically — review, then run as Administrator)

UxPlay needs, scoped to `uxplay.exe` and the **Domain** profile only (this PC's Ethernet is DomainAuthenticated):

| Purpose | Protocol | Port(s) |
|---|---|---|
| mDNS discovery (UxPlay internal mDNS) | UDP | 5353 |
| AirPlay control/data (`-p 35000` in receiver.config.ps1) | TCP | 35000-35002 |
| AirPlay timing/audio/video (`-p 35000`) | UDP | 35000-35002 |

The command-center network adapter must be on the **Domain** network profile
(`Get-NetConnectionProfile`), or these rules won't apply.

```powershell
$exe = 'C:\UxPlay\receiver\bin\uxplay.exe'   # adjust to where you unzipped
New-NetFirewallRule -DisplayName 'UxPlay mDNS (UDP 5353)' -Direction Inbound -Action Allow -Profile Domain -Program $exe -Protocol UDP -LocalPort 5353
New-NetFirewallRule -DisplayName 'UxPlay AirPlay TCP'     -Direction Inbound -Action Allow -Profile Domain -Program $exe -Protocol TCP -LocalPort 35000-35002
New-NetFirewallRule -DisplayName 'UxPlay AirPlay UDP'     -Direction Inbound -Action Allow -Profile Domain -Program $exe -Protocol UDP -LocalPort 35000-35002
```

Remove later:

```powershell
Get-NetFirewallRule -DisplayName 'UxPlay*' | Remove-NetFirewallRule
```

If you change `-p` in `receiver.config.ps1`, change the port ranges here to match (n, n+1, n+2).
