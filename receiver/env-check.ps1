# Task 1: read-only environment report. Run in PowerShell on the receiver PC; paste the output back.
"== Windows";  Get-CimInstance Win32_OperatingSystem | Select Caption, Version, BuildNumber, OSArchitecture | Format-List
"== CPU";      Get-CimInstance Win32_Processor | Select Name, NumberOfCores, NumberOfLogicalProcessors | Format-List
"== GPU";      Get-CimInstance Win32_VideoController | Select Name, DriverVersion, DriverDate, CurrentHorizontalResolution, CurrentVerticalResolution | Format-List
"== Displays"; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::AllScreens | Select DeviceName, Primary, Bounds | Format-List
"== Network";  Get-NetAdapter | ? Status -eq Up | Select Name, InterfaceDescription, LinkSpeed, MacAddress | Format-Table -Auto
Get-NetIPAddress -AddressFamily IPv4 | ? IPAddress -notlike '127.*' | Select InterfaceAlias, IPAddress, PrefixLength | Format-Table -Auto
Get-NetConnectionProfile | Select InterfaceAlias, Name, NetworkCategory | Format-Table -Auto
"== Bonjour (not required by this build)"; Get-Service 'Bonjour Service' -ErrorAction SilentlyContinue | Select Name, Status
"== Bluetooth"; Get-PnpDevice -Class Bluetooth -ErrorAction SilentlyContinue | ? Status -eq OK | Select FriendlyName | Format-Table -Auto
"== GitHub reachable"; Test-NetConnection github.com -Port 443 | Select ComputerName, TcpTestSucceeded
