# grokbot-update-loop-bypass

One-click updater for **Grok Bot on Debian/Ubuntu** that escapes the update loop where:

- the app shows **"Update required — Grok Bot X.Y.Z is no longer supported"**, and
- `sudo apt update && sudo apt install --only-upgrade grok-bot` says you're **already at the newest version**,

because the apt repository hasn't received the new release yet.

## How it works

It skips the apt repo. `grok-bot-update.sh` reads Grok Bot's official release feed:

```
https://api2.cursor.sh/updates/api/download/stable/linux-x64/sand    # or linux-arm64
```

takes `version` and `debUrl` from it, compares that with the installed version (`dpkg-query`), downloads the `.deb` from `downloads.cursor.com`, and installs it with `apt-get install` (graphical password prompt through `pkexec`, falling back to `sudo`). Then it relaunches Grok Bot.

## Install

```bash
git clone https://github.com/jabowery/grokbot-update-loop-bypass
cd grokbot-update-loop-bypass
./install.sh
```

That adds an **Update Grok Bot** launcher to your app menu and your desktop. When the update screen shows up again, click it.

To run it once without installing:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jabowery/grokbot-update-loop-bypass/main/grok-bot-update.sh)
```

## Files

- `grok-bot-update.sh` is the updater itself.
- `grok-bot-update.desktop` is the launcher. If `x-terminal-emulator` isn't set up on your system, edit its `Exec=` line, for example to `gnome-terminal --`.
- `install.sh` copies the script to `~/.local/bin` and puts the launcher in the app menu and on the desktop.

Not affiliated with xAI, SpaceXAI, or Cursor. Every download comes straight from the official CDN.
