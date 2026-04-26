# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a **NixOS configuration repository** embedded within a larger dotfiles management system. It uses a hybrid approach:
- **NixOS** for declarative system configuration (immutable)
- **Symlink-farm** for application dotfiles (mutable)

### Critical Symlinks
```
/etc/nixos → ~/.config/nixos (folder symlink)
~/.config/nixos → ~/.config/dots/config/nixos (this repository)
~/.config/nixos/*.nix → .system/machines/${hostName}/*.nix (machine files)
~/.config/nixos/${mainUser}.nix → .system/users/${mainUser}.nix (user file)
~/.config/nixos/services → .system/services (services folder)
```

The `/etc/nixos` folder symlink points to this repo, and root-level files are symlinked from `.system/` for easy access.

## Configuration Structure

### Entry Point Pattern
```
/etc/nixos → ~/.config/nixos (folder symlink)
~/.config/nixos/
├── .system/ (all infrastructure - hidden)
│   ├── machines/${hostName}/
│   ├── users/
│   ├── gui/
│   ├── services/
│   └── system.nix
├── configuration.nix → .system/machines/${hostName}/configuration.nix (symlink)
├── ${mainUser}.nix → .system/users/${mainUser}.nix (symlink)
└── services/ → .system/services/ (symlink)

configuration.nix imports:
    ├── ${sysDir}/machines/${hostName}/default.nix → imports hardware.nix
    ├── ${sysDir}/system.nix (core: packages, services, users)
    ├── ${sysDir}/gui/gui.nix (desktop environment - conditional based on compositors)
    ├── ${sysDir}/gui/gaming.nix (gaming setup)
    └── ${sysDir}/users/${mainUser}.nix (user configuration)
```

### Variable Injection Pattern
`.system/machines/${hostName}/configuration.nix` defines variables in a `let` binding:
- `mainUser`: Username for the system
- `hostName`: Machine identifier
- `compositors`: Array of enabled desktop compositors (e.g., `[ "hyprland" "niri" "xfce" ]`)
- `configDir`: Root config path (`/home/${mainUser}/.config/nixos`)
- `sysDir`: System directory path (`${configDir}/.system`)

These are passed to all modules via `_module.args = { inherit mainUser hostName compositors; }`. Child modules receive these as function parameters: `{ mainUser, hostName, compositors, ... }:`.

This allows machine-agnostic module reuse without hardcoding values.

## Common Development Commands

### Applying NixOS Changes
```bash
# Edit configuration
micro ~/.config/nixos/system.nix

# Apply immediately
sudo nixos-rebuild switch

# Test without making default
sudo nixos-rebuild test

# Build without activating
sudo nixos-rebuild build
```

### Dotfile Management
```bash
# Reload shell + regenerate all symlinks
reload

# Also sync system-level symlinks (requires sudo)
reload --system
```

The `reload` command (from lushrc framework) runs `symlink-farm.sh` which:
1. Cleans broken symlinks
2. Links scripts to `~/bin`
3. Links systemd user services
4. Links fonts, XDG configs, autostart files
5. With `--system`: Links to `/usr/local/bin`, `/etc/systemd/system`

### Querying NixOS
```bash
# List installed packages
nix-env -qa --installed

# Search for packages
nix search nixpkgs <package>

# Check what changed
nixos-rebuild dry-build
```

## Module Organization

### .system/system.nix
Core system packages, services, users, networking, bootloader.
Imports `/etc/nixos/hardware-configuration.nix` for auto-generated filesystem config.

### .system/gui/gui.nix
Uses `compositors` array for conditional logic:
- Compositor-agnostic packages always installed
- Compositor-specific packages via `lib.optionals hasHyprland [...]`
- Desktop managers enabled conditionally
- XDG portals for Flatpak

### .system/gui/gaming.nix
Steam, Gamemode, graphics drivers.

### .system/machines/${hostName}/configuration.nix
Entry point. Defines `mainUser`, `hostName`, `compositors`, `configDir`, `sysDir` variables. DO NOT import from other modules.

### .system/machines/${hostName}/default.nix
Imports machine-specific configs (hardware.nix, etc.)

### .system/machines/${hostName}/hardware.nix
Custom hardware config (GPU, power, etc.). Does NOT include filesystems.

### .system/users/${mainUser}.nix
User-specific configuration (packages, shell, etc.).

## Planned Architecture (Not Yet Implemented)

See `idea.txt` for the **systemd-to-nix** integration plan:
- Keep `.service` files as portable source of truth
- Auto-generate NixOS service configs from `~/.config/systemd/nix/*.service`
- Currently using native NixOS modules instead (e.g., `services.kanata`)

## Configuration Patterns

### Adding Packages
Add to appropriate section based on purpose:

**Compositor-agnostic packages** (.system/gui/gui.nix):
```nix
environment.systemPackages = with pkgs; [
  # Shared GUI apps (always installed when gui.nix is imported)
  mypackage
];
```

**Compositor-specific packages** (.system/gui/gui.nix):
```nix
# Add to the conditional section
++ lib.optionals hasHyprland [ hyprland-only-package ]
++ lib.optionals hasNiri [ niri-only-package ]
++ lib.optionals hasXfce [ xfce-only-package ]
```

**CLI/system packages** (.system/system.nix):
```nix
environment.systemPackages = with pkgs; [
  # System-level packages
  mypackage
];
```

### Adding System Services
Either use native NixOS module:
```nix
services.serviceName = {
  enable = true;
  # ... config
};
```

Or define custom systemd service:
```nix
systemd.services.myservice = {
  description = "My Service";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    ExecStart = "${pkgs.mypackage}/bin/mycommand";
    Restart = "always";
  };
};
```

### Adding New Machine
1. Create `machines/${newHostName}/` directory
2. Copy `machines/paraloid/configuration.nix` as template
3. Update variables in the new configuration.nix:
   - `hostName = "newHostName"`
   - `mainUser = "username"`
   - `compositors = [ "hyprland" ]` (or desired compositors)
4. Create `machines/${newHostName}/default.nix`:
   ```nix
   { ... }:
   {
     imports = [
       ./hardware.nix
     ];
   }
   ```
5. Run `nixos-generate-config --show-hardware-config` on target machine, save output to `machines/${newHostName}/hardware.nix`
6. Symlink `/etc/nixos/configuration.nix` → `~/.config/nixos/machines/${newHostName}/configuration.nix`

### Switching Compositors
Edit `machines/${hostName}/configuration.nix` and modify the `compositors` array:
```nix
compositors = [ "hyprland" ];        # Only Hyprland
compositors = [ "niri" ];            # Only Niri
compositors = [ "xfce" ];            # Only XFCE
compositors = [ "hyprland" "niri" ]; # Multiple compositors
```
Then run `sudo nixos-rebuild switch` to apply changes.

## Git Workflow

Based on commit history, changes are frequently committed with "dots push" messages. This appears automated. After making configuration changes, the workflow is:
1. Test with `sudo nixos-rebuild test`
2. Apply with `sudo nixos-rebuild switch`
3. Dotfiles sync (automated or manual `dots push`)

## Current Machine

- **Hostname**: paraloid
- **User**: luar
- **Hardware**: NVIDIA GPU (hybrid graphics), Intel CPU
- **Desktop**: XFCE, Hyprland, Niri available
