#!/usr/bin/env bash
# One-click Grok Bot updater: reads the official release feed, downloads the current .deb, installs it.
set -euo pipefail
case "$(uname -m)" in x86_64) P=linux-x64;; aarch64|arm64) P=linux-arm64;; *) echo "Unsupported arch"; read -r; exit 1;; esac
FEED="https://api2.cursor.sh/updates/api/download/stable/$P/sand"
JSON=$(curl -fsSL "$FEED")
URL=$(printf '%s' "$JSON" | sed -n 's/.*"debUrl":"\([^"]*\)".*/\1/p')
VER=$(printf '%s' "$JSON" | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')
CUR=$(dpkg-query -W -f='${Version}' grok-bot 2>/dev/null || echo none)
echo "Installed: $CUR   Latest: $VER"
if [ "$CUR" = "$VER" ]; then echo "Already current."; read -rp "Press Enter to close"; exit 0; fi
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
curl -fL --progress-bar -o "$TMP/grok-bot.deb" "$URL"
pkill -x grok-bot || true; sleep 1
if command -v pkexec >/dev/null && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then pkexec apt-get install -y "$TMP/grok-bot.deb"; else sudo apt-get install -y "$TMP/grok-bot.deb"; fi
NEW=$(dpkg-query -W -f='${Version}' grok-bot)
if [ "$NEW" != "$VER" ]; then echo "Install FAILED: still $NEW"; read -rp "Press Enter to close"; exit 1; fi
echo "Updated to $VER."
(nohup grok-bot >/dev/null 2>&1 &) || true
read -rp "Press Enter to close"
