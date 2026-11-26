# Manual test checklist (run by a person with the iPad — results left blank)

Build under test: see `THIRD_PARTY_NOTICES.md` (UxPlay commit) and `bin\uxplay.exe -v`.
PC: __________  iPad model / iPadOS: __________  Date: __________  Tester: __________

Precondition: `start-receiver.ps1` running, firewall rules from `FIREWALL.md` applied,
iPad and PC on the same network, PC adapter on the Domain profile.

## T1 Discovery
1. On the iPad open Control Center → Screen Mirroring.
2. Wait up to 30 s.
3. Record whether "Command Center" appears, and how long it took.

Discovery method: [ ] UxPlay internal mDNS  [ ] Bluetooth LE beacon  [ ] other: ______
Appeared: [ ] yes [ ] no   Time to appear: ____ s
Result: ______  Notes: ______

## T2 Access control
1. Select "Command Center". Enter a WRONG password.
2. Record whether the connection is refused.
3. Select it again, enter the correct password (`-pw`) from `receiver.config.ps1`.
4. Record whether mirroring starts.

Wrong PIN rejected: [ ] yes [ ] no   Correct password accepted: [ ] yes [ ] no
Result: ______  Notes: ______

## T3 Full screen
1. With mirroring active, check the big display.
2. Record display native resolution (Windows Settings → Display), whether the mirror fills
   the screen, letterbox/pillarbox bars (iPad aspect ratio differs from 16:9), and sharpness.

Display resolution: ______  Fills screen: [ ] yes [ ] no  Bars: [ ] none [ ] sides [ ] top/bottom
Sharpness (text readable from 3 m?): ______  Result: ______

## T4 Latency
1. On the iPad, open a stopwatch app with milliseconds and start it.
2. With a phone camera, take 5 photos showing both the iPad and the big display.
3. For each photo record iPad time minus display time.

| Photo | iPad time | Display time | Difference (ms) |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

Average latency: ____ ms   Result: ______

## Further tests (not specified in full in the brief — add details here)
The original request was cut off after T4. Add any remaining tests (e.g. reconnect after
iPad sleep, 8-hour soak with `monitor.ps1`, auto-restart after killing uxplay.exe).
