#!/usr/bin/env bash
# Assembles dist/receiver: uxplay.exe + every DLL it and the bundled GStreamer plugins need,
# so it runs from plain PowerShell without MSYS2. Run inside the MSYS2 UCRT64 shell after building.
set -euo pipefail
P=/ucrt64
OUT=dist/receiver
rm -rf dist && mkdir -p "$OUT"/{bin,lib/gstreamer-1.0,libexec/gstreamer-1.0,licenses,logs}

cp src/build/uxplay.exe "$P/bin/gst-inspect-1.0.exe" "$OUT/bin/"
cp "$P/libexec/gstreamer-1.0/gst-plugin-scanner.exe" "$OUT/libexec/gstreamer-1.0/"
# ponytail: all installed plugins (core/base/good/bad/libav); prune to a list if zip size matters
cp "$P"/lib/gstreamer-1.0/*.dll "$OUT/lib/gstreamer-1.0/"

# DLL closure: ntldd -R lists every dependency; keep the ones MSYS2 provides (system DLLs stay out).
find "$OUT" -name '*.exe' -o -name '*.dll' | while read -r f; do ntldd -R "$f" 2>/dev/null; done |
  awk '{print $1}' | sort -fu | while read -r dll; do
    [ -f "$P/bin/$dll" ] && cp -n "$P/bin/$dll" "$OUT/bin/" || true
  done

# Our scripts/docs, UxPlay's LICENSE, build log.
cp -r receiver/. "$OUT/"
cp logs/build.log "$OUT/logs/build.log"

# THIRD_PARTY_NOTICES.md: map every bundled binary to its MSYS2 package, record license, copy license files.
N="$OUT/THIRD_PARTY_NOTICES.md"
{
  echo "# Third-party notices"
  echo
  echo "## UxPlay"
  echo "- Source: https://github.com/${UXPLAY_REPO}/tree/${UXPLAY_COMMIT}"
  echo "- Commit: ${UXPLAY_COMMIT} (README title: $(head -1 src/README.md | sed 's/^# //'))"
  echo "- Version string: $(grep -m1 '#define VERSION' src/uxplay.cpp | cut -d'"' -f2)"
  echo "- License: GPL-3.0 (see LICENSE). Copyright notices are in the source files at the commit above."
  echo
  echo "## Bundled MSYS2 packages (GStreamer and dependencies)"
  echo "Generated with \`pacman -Qo\` / \`pacman -Qi\` on the build machine. License files are in \`licenses/<package>/\`."
  echo
  echo "| Package | Version | License | Bundled files |"
  echo "|---|---|---|---|"
} > "$N"
(cd "$OUT" && find bin lib libexec -type f \( -name '*.dll' -o -name '*.exe' \) ! -name uxplay.exe) | while read -r rel; do
  echo "$(pacman -Qqo "$P/$rel" 2>/dev/null || echo UNKNOWN) $rel"
done | sort | awk '{f[$1]=f[$1] (f[$1]?", ":"") $2} END {for (p in f) print p "\t" f[p]}' | sort |
while IFS=$'\t' read -r pkg files; do
  if [ "$pkg" = UNKNOWN ]; then ver="?"; lic="UNKNOWN - check manually"; else
    ver=$(pacman -Qi "$pkg" | sed -n 's/^Version *: //p')
    lic=$(pacman -Qi "$pkg" | sed -n 's/^Licenses *: //p')
    pacman -Qlq "$pkg" | grep '/share/licenses/.\+[^/]$' | while read -r lf; do
      mkdir -p "$OUT/licenses/$pkg" && cp "$lf" "$OUT/licenses/$pkg/"
    done || true
  fi
  echo "| $pkg | $ver | $lic | $files |" >> "$N"
done
echo "Packaged $(find "$OUT" -type f | wc -l) files, $(du -sh "$OUT" | cut -f1)"
