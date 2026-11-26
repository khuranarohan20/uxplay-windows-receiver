# uxplay-windows-receiver

Terminal-only AirPlay screen-mirroring receiver for Windows, for internal use (iPad → command-center display).
It is **unmodified [UxPlay](https://github.com/FDH2/UxPlay)** (GPLv3) built by GitHub Actions with MSYS2,
packaged with its DLLs and GStreamer plugins so it runs from plain PowerShell, plus PowerShell wrapper scripts.

- Pinned upstream: `FDH2/UxPlay` master @ `566f3460e3cbb16c2c33a7ac607d3d2d0dd09b14` (README: 1.74 experimental).
  Reason: it has built-in mDNS, so no Apple Bonjour SDK/service is needed. The latest tag v1.73.7
  (`df67c21`) requires the Bonjour SDK, which is only available behind an Apple login.
- Build: `.github/workflows/build.yml` → artifact / Release `receiver.zip`.

## Install on the Windows PC
1. Download `receiver.zip` from the latest Release and unzip (e.g. `C:\UxPlay`).
2. Read `receiver\README.md`, change the PIN in `receiver\receiver.config.ps1`.
3. Apply firewall rules from `receiver\docs\FIREWALL.md` (admin, after review).
4. Run `receiver\start-receiver.ps1`, then follow `receiver\docs\TEST-CHECKLIST.md`.

Environment report: `receiver/env-check.ps1` (read-only).

## License
Wrapper scripts and UxPlay binaries are distributed under GPLv3 (`receiver/LICENSE`);
bundled component licenses: `THIRD_PARTY_NOTICES.md` in the release zip.
