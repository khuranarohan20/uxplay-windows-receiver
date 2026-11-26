# All UxPlay arguments in one place. Flags verified against docs/uxplay-help.txt
# (generated from the built uxplay.exe) and the UxPlay README at the pinned commit.

$UxPlayArgs = @(
    '-n', 'Command Center'      # receiver name shown on the iPad
    '-nh'                       # do not append "@hostname" to the name
    '-pw', 'ChangeMe26'         # CHANGE THIS. Password, 6+ chars. Do NOT use -pin: UxPlay 1.74 crashes after PIN
                                # pairing (upstream FDH2/UxPlay#646; reproduced on our PC 2026-11-26).
    '-fs'                       # full screen (works with D3D11/12 sinks)
    '-vs', 'd3d12videosink'     # README's recommended Windows sink; use 'd3d11videosink' if d3d12 misbehaves
    '-vsync', 'no'              # README: best for mirror-only use (no A/V timestamp sync, no dropped frames)
    '-p', '35000'               # fixed ports: TCP and UDP 35000, 35001, 35002 (firewall rules match this)
)

# Logging verbosity: $true adds '-d' (debug logging; very verbose).
$UxPlayDebug = $false
if ($UxPlayDebug) { $UxPlayArgs += '-d' }
