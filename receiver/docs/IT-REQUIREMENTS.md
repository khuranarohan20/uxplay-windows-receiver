# IT requirements: Command Center AirPlay receiver

What the network and IT teams need to allow so an iPad can mirror its screen to the
command-center PC. The receiver is UxPlay 1.74 (open source, GPLv3), packaged in this
repository. It runs as a normal desktop program under a local user's logon.

Values marked *(measured)* were read from the command-center PC on 2026-11-26.

## 1. Windows firewall on the receiver PC

Inbound, program-scoped to `uxplay.exe`, Domain profile only:

| Protocol | Port(s)       | Purpose                              |
|----------|---------------|--------------------------------------|
| UDP      | 5353          | mDNS discovery (iPad finds receiver) |
| TCP      | 35000–35002   | AirPlay control and video stream     |
| UDP      | 35000–35002   | AirPlay timing and audio             |

Exact commands: [`FIREWALL.md`](FIREWALL.md). They are already applied as local rules.

- The PC is domain-joined *(measured: domain IIC.COM, network profile DomainAuthenticated)*.
  Local rules only work while Group Policy allows merging them
  (Domain profile → "Apply local firewall rules" = Yes; *(measured)* currently `True`).
- **Ask:** either keep local rule merging enabled, or push the same three rules via GPO.

## 2. Network between iPad and PC

- Same subnet today *(measured: PC 172.20.1.33/22 on wired Ethernet, iPad 172.20.0.240)*.
- mDNS multicast `224.0.0.251` UDP 5353 must pass between the iPad and the PC.
- The Wi-Fi SSID used by the iPad must **not** have client/AP isolation.
- The PC sends timing (NTP-style) packets back to the iPad on UDP ports the iPad
  chooses at connect time. Stateful networks allow this; strict client-to-client ACLs
  must allow PC → iPad UDP.
- **If the iPad moves to another VLAN/subnet:** enable an mDNS/Bonjour gateway for
  service `_airplay._tcp` and `_raop._tcp` between the two networks, and route
  TCP/UDP 35000–35002 from iPad to PC.

## 3. Endpoint security on the receiver PC

- Executables are unsigned: `bin\uxplay.exe`, `bin\gst-inspect-1.0.exe`,
  `libexec\gstreamer-1.0\gst-plugin-scanner.exe`, plus the DLLs in `bin\` and
  `lib\gstreamer-1.0\`.
- **Ask:** allow the install folder (or file hashes) in antivirus/EDR and AppLocker/WDAC.
  Recommended install location: `C:\Program Files\CommandCenterReceiver\`
  (not `Downloads`, which many policies block).
- The scripts run with `powershell.exe -ExecutionPolicy Bypass`. A policy that requires
  signed scripts or Constrained Language Mode will block them.
- One-time admin rights are needed to create the firewall rules and the logon task
  (`install-logon-task.ps1`, Task Scheduler, runs at logon of one local user).

## 4. iPad (if managed by MDM)

- If AirPlay destinations are restricted (AirPlay allow-list), add this receiver.
  It identifies by the PC's Ethernet MAC address *(measured: `00:e0:4c:43:1f:c0`)*.
  This changes if the PC or its network adapter changes.
- AirPlay / Screen Mirroring must not be disabled by restriction profile.
- Access control: the receiver asks the iPad for a password (`-pw` in
  `receiver.config.ps1`). The 4-digit PIN mode (`-pin`) is not used because it crashes
  UxPlay 1.74 ([FDH2/UxPlay#646](https://github.com/FDH2/UxPlay/issues/646)).

## 5. Internet access

None required at runtime. The receiver makes no outbound internet connections.
GitHub (`github.com`) is only used to download the release zip.
