# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Hyprland configuration for NixOS using a modular, self-healing architecture. The setup integrates with:
- **Noctalia Shell** (quickshell-based custom UI)
- **Lushrc** (shell environment framework - see `~/.config/lushrc/CLAUDE.md`)
- **Event-driven daemons** for clipboard, media keys, and system automation

## Environment

**Platform**: NixOS with Wayland (Hyprland compositor)

**Key Dependencies**:
- `wl-clipboard` - Wayland clipboard utilities (event-based)
- `mpv` - Audio playback (use `--no-video --really-quiet` for sound effects)
- `hyprctl` - Hyprland IPC control
- `brightnessctl` - Hardware brightness control
- `hyprsunset` - Gamma/color temperature control

**Shell Conventions**:
- Shebang: `#!/usr/bin/env bash` (NEVER `#!/bin/bash` - NixOS doesn't use `/bin/bash`)
- Scripts auto-linked via self-healing system (see below)

## Configuration Structure

```
~/.config/hypr/
├── hyprland.conf           # Main config (sources others, autostart daemons)
├── keybinds.conf           # Keyboard/mouse bindings
├── hardware.conf           # Hardware-specific settings
├── hyprscrolling.conf      # Scrolling layout plugin config
├── noctalia/
│   └── noctalia-colors.conf  # Theme colors
├── scripts/
│   ├── bin/                # User-accessible scripts (auto-symlinked to ~/.local/bin)
│   │   └── sunset          # Unified brightness/gamma control
│   ├── sounds/             # Audio feedback files
│   │   └── *.ogg           # Sound effects (e.g., Minecraft sounds)
│   ├── clipboard-notify-daemon.sh  # Wayland clipboard watcher with sound feedback
│   ├── enable-nixos-plugins.sh     # NixOS Hyprland plugin loader
│   └── self-heal.sh        # Symlink synchronization utility
└── scheme/                 # Color scheme definitions
```

## Self-Healing Symlink System

**Pattern**: Scripts in `scripts/bin/` are automatically symlinked to `~/.local/bin/` for global access.

**Mechanism**: `self-heal.sh` provides idempotent symlink management:
1. Cleans broken symlinks in `~/.local/bin`
2. Makes all scripts in `scripts/bin/` executable
3. Creates symlinks: `~/.local/bin/scriptname → ~/.config/hypr/scripts/bin/scriptname`
4. Refreshes command hash

**Usage**:
```bash
# Add new user-facing script
mv new-script.sh ~/.config/hypr/scripts/bin/new-script
~/.config/hypr/scripts/self-heal.sh

# Script now available globally as: new-script
```

**Adding scripts to autostart**: Edit `hyprland.conf` `exec-once` section.

## Event-Based Architecture

### Clipboard Daemon (`clipboard-notify-daemon.sh`)

**Mechanism**: Uses `wl-paste --watch` for event-driven clipboard monitoring (NOT polling).

**How it works**:
- Monitors Wayland clipboard protocol directly
- Triggers on any clipboard write (Ctrl+C, Ctrl+Shift+C, right-click copy, programmatic)
- Zero CPU usage when idle - event-based, not polling
- Plays audio feedback via `mpv --no-video --really-quiet`

**Current behavior**: Plays Minecraft flint-and-steel sound on clipboard change (notification commented out).

**To modify**:
```bash
# Edit ~/.config/hypr/scripts/clipboard-notify-daemon.sh
# Restart daemon:
pkill wl-paste
~/.config/hypr/scripts/clipboard-notify-daemon.sh &
```

### Media Key Handling

Media keys (volume, brightness, playback) are handled by `akeyshually` daemon, NOT Hyprland bindings. The keybinds.conf media section is commented out to avoid conflicts.

## Key Utilities

### Brightness/Gamma Control (`sunset`)

Unified brightness+gamma controller in `scripts/bin/sunset`:

**Behavior**:
- **Decreasing**: Lowers hardware brightness first, then reduces gamma when brightness hits 0%
- **Increasing**: Restores gamma to 100% first, then raises hardware brightness
- Uses exponential curve (`brightnessctl -e4`) for natural perception

**Usage**:
```bash
sunset -10    # Decrease by 10% (brightness → gamma)
sunset +15    # Increase by 15% (gamma → brightness)
```

**Integration**: Called by `akeyshually` for XF86MonBrightness* keys.

### NixOS Plugin Loader (`enable-nixos-plugins.sh`)

Loads Hyprland plugins from Nix store at startup.

**Usage** (in `hyprland.conf`):
```bash
exec-once = ~/.config/hypr/scripts/enable-nixos-plugins.sh hyprscrolling hyprbars
```

**Mechanism**: Scans `/nix/store/*-${plugin}-*/lib/*.so` and loads via `hyprctl plugin load`.

## Adding Sound Effects

**Sound location**: `~/.config/hypr/scripts/sounds/`

**Playback**: Use `mpv --no-video --really-quiet path/to/sound.ogg &`
- `--no-video`: Prevents mpv window (it's a video player that also plays audio)
- `--really-quiet`: Suppresses terminal output
- Background (`&`): Non-blocking execution

**Extracting Minecraft sounds**:
```bash
# Minecraft assets at: ~/.var/app/com.atlauncher.ATLauncher/data/assets/
# Asset index: assets/indexes/17.json (or latest version)
# Find sound hash:
jq -r '.objects["minecraft/sounds/PATH/TO/SOUND.ogg"].hash' assets/indexes/17.json

# Extract (hash aa/aabbcc...):
cp assets/objects/aa/aabbcc... ~/.config/hypr/scripts/sounds/sound-name.ogg
```

**Adding to Hyprland startup**:
```bash
# In hyprland.conf:
exec-once = mpv --no-video --really-quiet ~/.config/hypr/scripts/sounds/startup.ogg
```

## Hyprland Event Hooks

**Hyprland socket**: `/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock`

**Pattern for action sounds** (window open/close, workspace change, etc.):
```bash
socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case "$line" in
        workspace,*) mpv --no-video --really-quiet ~/sounds/workspace.ogg & ;;
        openwindow,*) mpv --no-video --really-quiet ~/sounds/open.ogg & ;;
        closewindow,*) mpv --no-video --really-quiet ~/sounds/close.ogg & ;;
    esac
done
```

Add to `exec-once` for persistent event listening.

## Configuration Workflow

**Editing configs**:
```bash
# Edit main config
nvim ~/.config/hypr/hyprland.conf

# Reload Hyprland (live reload)
hyprctl reload

# Or restart Hyprland
loginctl kill-session $XDG_SESSION_ID
```

**Testing scripts before symlinking**:
```bash
# Direct execution
~/.config/hypr/scripts/bin/sunset -10

# After self-heal:
~/.config/hypr/scripts/self-heal.sh
sunset -10  # Now globally available
```

**Debugging daemons**:
```bash
# Check running clipboard daemon
ps aux | grep wl-paste

# Kill and restart
pkill wl-paste
~/.config/hypr/scripts/clipboard-notify-daemon.sh &

# View Hyprland logs
journalctl --user -u hyprland.service -f
```

## Integration Points

**Noctalia Shell**: Quickshell-based UI providing launcher, dashboard, session control
- Keybinds: `Super+Space` (launcher), `Super+D` (dashboard), `Super+Shift+Esc` (session)
- Handles notifications (may override `notify-send` timeout behavior)

**Lushrc Integration**: Shell environment ($BASHRC, $TOOLS, $WORKSPACE) and utilities (hotline, tx, pw, etc.) are available in Hyprland scripts. See `~/.config/lushrc/CLAUDE.md` for details.

**CopyQ**: Clipboard history manager runs alongside clipboard daemon (CopyQ provides history, daemon provides sound feedback).

## Common Patterns

**Adding user scripts**:
1. Create in `scripts/bin/` with `#!/usr/bin/env bash`
2. Run `self-heal.sh` to symlink to `~/.local/bin/`
3. Script now globally accessible

**Adding autostart daemons**:
1. Create daemon script in `scripts/`
2. Add `exec-once = ~/.config/hypr/scripts/daemon-name.sh` to `hyprland.conf`
3. Restart Hyprland or run manually for testing

**Sound feedback for actions**:
1. Add sound file to `scripts/sounds/`
2. Trigger with `mpv --no-video --really-quiet ~/.config/hypr/scripts/sounds/sound.ogg &`
3. For Hyprland events, use socket listener pattern (see Hyprland Event Hooks)

**Using relative paths in configs**: Hyprland's `exec-once` doesn't guarantee working directory, so always use absolute paths (`~/.config/hypr/...`) or ensure scripts resolve paths correctly.
