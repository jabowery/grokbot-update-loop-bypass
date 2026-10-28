#!/usr/bin/env bash
set -e
D="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.local/bin ~/.local/share/applications
install -m755 "$D/grok-bot-update.sh" ~/.local/bin/
sed "s|\$HOME|$HOME|" "$D/grok-bot-update.desktop" > ~/.local/share/applications/grok-bot-update.desktop
[ -d ~/Desktop ] && cp ~/.local/share/applications/grok-bot-update.desktop ~/Desktop/ && chmod +x ~/Desktop/grok-bot-update.desktop && (gio set ~/Desktop/grok-bot-update.desktop metadata::trusted true 2>/dev/null || true)
echo "Installed. Look for 'Update Grok Bot' in your app menu or on your desktop."
