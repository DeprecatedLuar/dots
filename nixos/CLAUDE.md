# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a **NixOS configuration repository** using a TOML-based code generation system. Architecture:
- **machine.toml** files define machine configuration (source of truth)
- **generate-config.sh** auto-generates configuration.nix with explicit imports
- **Self-healing nixos-rebuild wrapper** ensures consistency on every rebuild
- **Modular system** with composable users, modules, and services

### Directory Structure

```
~/.config/nixos/
├── machine.toml → .system/machines/${hostName}/machine.toml (edit this!)
├── hardware.nix → .system/machines/${hostName}/hardware.nix
├── preferences.nix → .system/machines/${hostName}/preferences.nix
├── services/ → .system/services/
└── .system/
    ├── machines/${hostName}/
    │   ├── machine.toml (source of truth)
    │   ├── configuration.nix (auto-generated - DO NOT EDIT)
    │   ├── default.nix (imports hardware, preferences)
    │   ├── hardware.nix (machine-specific hardware config)
    │   ├── preferences.nix (machine preferences)
    │   └── services.nix (enabled services list)
    ├── modules/
    │   ├── gui.nix (desktop environment)
    │   └── gaming.nix (gaming setup)
    ├── users/
    │   ├── luar.nix
    │   └── user.nix
    ├── services/
    │   ├── available/ (service definitions)
    │   └── services.nix → machines/${hostName}/services.nix
    ├── scripts/
    │   ├── generate-config.sh (TOML → Nix generator)
    │   └── nixos-rebuild.sh (self-healing wrapper)
    ├── system.nix (core system config)
    └── service-loader.nix (dynamic service imports)
```

### Critical Symlinks

The self-healing script (`nixos-rebuild.sh`) automatically manages:
- `/etc/nixos/configuration.nix` → auto-generated config
- `~/.config/nixos/machine.toml` → machine-specific TOML
- `~/.config/nixos/services/` → `.system/services/`
- Machine files (hardware.nix, preferences.nix) symlinked to root

## Configuration System

### TOML-Based Configuration (Primary Workflow)

**Edit machine configuration:**
```bash
micro ~/.config/nixos/machine.toml
```

**Example machine.toml:**
```toml
# Users (first user is main user for auto-login)
users = ["luar"]
hostName = "paraloid"
timeZone = "America/Sao_Paulo"
locale = "en_US.UTF-8"

# Desktop compositors (empty for headless)
compositors = ["hyprland", "niri", "i3", "xfce"]

# Modules to import from .system/modules/
modules = ["gui", "gaming"]
```

**Apply changes:**
```bash
sudo nixos-rebuild switch
```

Behind the scenes:
1. Self-healing script runs `generate-config.sh`
2. Validates TOML structure
3. Auto-generates `configuration.nix` with explicit imports
4. Derives `mainUser` from first user in array
5. Ensures all symlinks are correct
6. Proceeds with NixOS rebuild

### Code Generation Flow

```
machine.toml (human-editable)
    ↓
generate-config.sh (bash TOML parser)
    ↓
configuration.nix (auto-generated with explicit imports)
    ↓
NixOS rebuild
```

**Generated configuration.nix structure:**
```nix
let
  mainUser = "luar";  # Derived from users[0]
  hostName = "paraloid";
  compositors = [ "hyprland" "niri" "i3" "xfce" ];
in
{
  imports = [
    ../../system.nix
    ./default.nix
    ../../users/luar.nix      # Explicit from users array
    ../../modules/gui.nix     # Explicit from modules array
    ../../modules/gaming.nix
  ];

  _module.args = { inherit mainUser hostName compositors; };
}
```

### Variable Injection Pattern

Variables are passed to all modules via `_module.args`:
- `mainUser`: First user in users array (for auto-login, home paths)
- `hostName`: Machine identifier
- `compositors`: Array of enabled compositors for conditional imports

Child modules receive these as function parameters:
```nix
{ mainUser, hostName, compositors, ... }:
```

This allows machine-agnostic module reuse without hardcoding values.

## Common Commands

### Applying NixOS Changes

```bash
# Edit configuration (RECOMMENDED)
micro ~/.config/nixos/machine.toml
sudo nixos-rebuild switch

# Test without making default (reverts on reboot)
sudo nixos-rebuild test

# Build without activating
sudo nixos-rebuild build

# Check what would change
sudo nixos-rebuild dry-build
```

### Managing Configuration

```bash
# Regenerate configuration.nix manually (usually automatic)
~/.config/nixos/.system/scripts/generate-config.sh ~/.config/nixos/.system/machines/paraloid

# Edit other configs directly
micro ~/.config/nixos/hardware.nix
micro ~/.config/nixos/.system/system.nix
micro ~/.config/nixos/.system/modules/gui.nix
```

### Querying NixOS

```bash
# List installed packages
nix-env -qa --installed

# Search for packages
nix search nixpkgs <package>

# Check syntax without building
nix-instantiate --parse <file.nix>
```

## Module Organization

### .system/system.nix
Core system configuration:
- System packages (CLI tools, dev tools)
- Core services (SSH, Docker, audio via PipeWire)
- User definitions (auto-login for mainUser)
- Boot configuration (tmpfs, zram)
- Imports hardware-configuration.nix and service-loader.nix

**Does NOT handle:**
- Module/user imports (handled by generated configuration.nix)
- Machine-specific hardware (in machines/${hostName}/default.nix)
- Networking hostname (set in generated configuration.nix)

### .system/modules/gui.nix
Desktop environment configuration using compositor-based conditional logic:
```nix
let
  hasHyprland = builtins.elem "hyprland" compositors;
  hasNiri = builtins.elem "niri" compositors;
  hasXfce = builtins.elem "xfce" compositors;
in
{
  # Compositor-agnostic packages
  environment.systemPackages = [ ... ]
  # Compositor-specific packages
  ++ lib.optionals hasHyprland [ hypridle hyprpicker ... ];

  # Enable compositor programs
  programs.hyprland.enable = hasHyprland;
  programs.niri.enable = hasNiri;
  services.xserver.desktopManager.xfce.enable = hasXfce;
}
```

### .system/modules/gaming.nix
Gaming-specific configuration:
- Steam with Proton GE
- Gamemode integration
- Kernel optimizations (swappiness, compaction)
- Graphics hardware acceleration

### .system/service-loader.nix
Dynamic service import system:
1. Reads `services/services.nix` for `enabledServices` list
2. Maps service names to `services/available/*.nix`
3. Dynamically imports enabled services

### .system/machines/${hostName}/
Machine-specific configuration:
- **machine.toml**: Source of truth (edit this)
- **configuration.nix**: Auto-generated entry point (DO NOT EDIT)
- **default.nix**: Imports hardware.nix and preferences.nix
- **hardware.nix**: Custom hardware config (GPU, power, etc.)
- **preferences.nix**: Machine-specific settings
- **services.nix**: Defines `enabledServices = [ "service1" "service2" ]`

### .system/users/${username}.nix
User-specific configuration:
```nix
{ pkgs, mainUser, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" ];
    packages = with pkgs; [ ... ];
    openssh.authorizedKeys.keys = [ ... ];
  };
}
```

## Configuration Patterns

### Adding Packages

**System packages** (.system/system.nix):
```nix
environment.systemPackages = with pkgs; [
  git wget curl
];
```

**Compositor-specific** (.system/modules/gui.nix):
```nix
++ lib.optionals hasHyprland [ hyprland-package ]
++ lib.optionals hasNiri [ niri-package ]
```

**User packages** (.system/users/username.nix):
```nix
users.users.username = {
  packages = with pkgs; [ firefox brave ];
};
```

### Adding a New Module

1. Create `.system/modules/mymodule.nix`:
```nix
{ config, pkgs, lib, mainUser, compositors, ... }:
{
  environment.systemPackages = with pkgs; [ mypackage ];
  services.myservice.enable = true;
}
```

2. Add to machine.toml:
```toml
modules = ["gui", "gaming", "mymodule"]
```

3. Rebuild:
```bash
sudo nixos-rebuild switch
```

### Adding a New User

1. Create `.system/users/newuser.nix`:
```nix
{ pkgs, ... }:
{
  users.users.newuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ ... ];
  };
}
```

2. Add to machine.toml:
```toml
users = ["luar", "newuser"]
```

### Adding a New Machine

1. Create machine directory:
```bash
mkdir ~/.config/nixos/.system/machines/newmachine
```

2. Generate template:
```bash
~/.config/nixos/.system/scripts/generate-config.sh ~/.config/nixos/.system/machines/newmachine
# This creates machine.toml with auto-discovered modules/users
```

3. Edit machine.toml:
```toml
users = ["username"]
hostName = "newmachine"
compositors = []  # Or ["hyprland"] for desktop
modules = []      # Or ["gui"] for desktop
```

4. Create default.nix:
```nix
{ ... }:
{
  imports = [
    ./hardware.nix
    ./preferences.nix
  ];
}
```

5. Generate hardware config on target machine:
```bash
sudo nixos-generate-config --show-hardware-config > hardware.nix
```

6. On first boot, `/etc/nixos/configuration.nix` will be auto-symlinked by the self-healing wrapper

### Template Auto-Discovery

When generating a new machine template, the script auto-discovers available options:

```toml
# Users to import from .system/users/
# Available:
#   - luar
#   - user
users = []

# Modules to import from .system/modules/
# Available:
#   - gaming
#   - gui
modules = []
```

### Switching Compositors

Edit machine.toml:
```toml
compositors = ["hyprland"]           # Only Hyprland
compositors = ["hyprland", "niri"]   # Multiple
compositors = []                     # Headless
```

Rebuild to apply.

## Self-Healing System

The custom `nixos-rebuild` wrapper (`.system/scripts/nixos-rebuild.sh`) automatically:

1. **Generates configuration.nix** from machine.toml
2. **Validates** TOML structure
3. **Ensures /etc/nixos/configuration.nix** symlink exists
4. **Symlinks machine.toml** to root for easy access
5. **Manages service symlinks** (machines/${hostName}/services/*.nix → services/available/)
6. **Calls real nixos-rebuild** with all flags passed through

**Bypass self-healing** (for debugging):
```bash
sudo nixos-rebuild --bypass switch
```

**Enable dead man's switch** (auto-rollback on failure):
```bash
sudo nixos-rebuild --meltdown switch
```

## Services System

Services use a symlink-farm pattern:

1. Define service in `.system/machines/${hostName}/services/myservice.nix`
2. Self-healing script symlinks to `.system/services/available/local_myservice.nix`
3. Enable in `.system/machines/${hostName}/services.nix`:
```nix
{
  enabledServices = [
    "local_myservice"
  ];
}
```
4. service-loader.nix dynamically imports enabled services

## Current Machines

- **paraloid**: Desktop (NVIDIA GPU, Hyprland/Niri/XFCE/i3, user: luar)
- **ae**: Headless server (user: user)
- **nuremberg**: Headless server (user: luar)

## Important Notes

- **Never edit configuration.nix directly** - it's auto-generated from machine.toml
- **First user in users array** becomes mainUser (auto-login, home paths)
- **Compositors array** controls desktop environment via conditional imports
- **Self-healing runs on every rebuild** - symlinks and configs auto-fixed
- **TOML validation** ensures required keys exist before generation
