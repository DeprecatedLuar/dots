#!/usr/bin/env bash
# Sets up NixOS symlinks for this machine.
# Run once on a new machine after cloning the dots repo.
# If the machine is unknown, offers to scaffold a new machine (and user).
#
# Usage: setup.sh [--dry-run]
#   --dry-run  Scaffold/resolve the machine, then stop before any sudo or
#              symlink changes. Prints what it *would* link. Nothing outside
#              the repo's machines/ and users/ is touched. Safe to test with.

set -e

DRY_RUN=""
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=1
  echo "[dry-run] No sudo or symlink changes will be made."
fi

NIXOS_DIR="$(cd "$(dirname "$(realpath "$0")")/../.." && pwd)"
SYS_DIR="$NIXOS_DIR/.system"
MACHINES_DIR="$SYS_DIR/machines"
USERS_DIR="$SYS_DIR/users"
MODULES_DIR="$SYS_DIR/modules"
GENERATE_CONFIG="$SYS_DIR/scripts/generate-config.sh"
USER_TEMPLATE="$USERS_DIR/user.nix"
HOST="$(hostname)"

# Defaults for scaffolded machines
DEFAULT_LOCALE="en_US.UTF-8"
COMPOSITOR_OPTIONS="hyprland niri xfce i3 openbox"

# Timezone menu (first entry is the default)
TIMEZONES=(
  "America/Sao_Paulo"
  "Europe/London"
  "UTC"
  "America/New_York"
  "Europe/Berlin"
)

#──[Helpers]──────────────────────────────────────────────────────────────────

# Convert a space-separated list into a TOML array body: a b -> "a", "b"
to_toml_array() {
  local out="" item
  for item in $1; do
    if [ -n "$out" ]; then out="$out, "; fi
    out="$out\"$item\""
  done
  echo "$out"
}

# List available module basenames (e.g. "gui gaming")
discover_modules() {
  local f names=""
  for f in "$MODULES_DIR"/*.nix; do
    [ -e "$f" ] || continue
    names="$names $(basename "$f" .nix)"
  done
  echo "${names# }"
}

# Prompt for a timezone from the numbered menu; echoes the chosen zone.
prompt_timezone() {
  local i choice
  {
    echo "  Timezone:"
    for i in "${!TIMEZONES[@]}"; do
      if [ "$i" -eq 0 ]; then
        echo "    $((i + 1))) ${TIMEZONES[$i]}  (default)"
      else
        echo "    $((i + 1))) ${TIMEZONES[$i]}"
      fi
    done
  } >&2
  read -rp "  Select [1]: " choice
  choice="${choice:-1}"
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#TIMEZONES[@]}" ]; then
    echo "${TIMEZONES[$((choice - 1))]}"
  else
    echo "${TIMEZONES[0]}"
  fi
}

# Scaffold a new user file from the template, swapping in the username.
create_user() {
  local name="$1"
  sed "s/users\.users\.user =/users.users.$name =/" "$USER_TEMPLATE" > "$USERS_DIR/$name.nix"
  echo "  Created user: $USERS_DIR/$name.nix"
  echo "    (edit groups / packages / ssh key before building)"
}

# Ensure a user file exists, offering to scaffold one if not.
resolve_user() {
  local name="$1"
  if [ -f "$USERS_DIR/$name.nix" ]; then
    return 0
  fi
  echo "  User '$name' has no config in $USERS_DIR." >&2
  read -rp "  Create it from template? [Y/n] " reply
  if [[ "$reply" =~ ^[Nn]$ ]]; then
    echo "  Error: cannot continue without a user config for '$name'." >&2
    exit 1
  fi
  create_user "$name" >&2
}

# Scaffold a new machine directory, then generate its configuration.nix.
create_machine() {
  local machine="$1"
  local dir="$MACHINES_DIR/$machine"

  if [ -d "$dir" ]; then
    echo "Error: machine '$machine' already exists at $dir"
    exit 1
  fi

  echo "Creating new machine: $machine"

  # hostName == machine name (dir name is the network hostname)
  local host_name="$machine"

  # main user (scaffold if missing)
  read -rp "  Main user [$(whoami)]: " user_in
  local main_user="${user_in:-$(whoami)}"
  resolve_user "$main_user"

  # compositors (space-separated, empty = headless)
  echo "  Compositors (space-separated, blank for headless)"
  echo "    Options: $COMPOSITOR_OPTIONS"
  read -rp "  > " compositors_in

  # modules (space-separated, empty = none)
  local available_modules
  available_modules="$(discover_modules)"
  echo "  Modules (space-separated, blank for none)"
  echo "    Available: ${available_modules:-none}"
  read -rp "  > " modules_in

  # timezone
  local time_zone
  time_zone="$(prompt_timezone)"

  mkdir -p "$dir"

  # machine.toml (source of truth)
  cat > "$dir/machine.toml" << EOF
# NixOS Machine Configuration - $machine

# Users to import (first user is main user)
users = ["$main_user"]
hostName = "$host_name"
timeZone = "$time_zone"
locale = "$DEFAULT_LOCALE"

# Desktop compositors
compositors = [$(to_toml_array "$compositors_in")]

# Modules to import
modules = [$(to_toml_array "$modules_in")]
EOF

  # default.nix
  cat > "$dir/default.nix" << 'EOF'
{ ... }:

{
  imports = [
    ./hardware.nix
    ./preferences.nix
  ];
}
EOF

  # preferences.nix (minimal, networking enabled so the box is reachable)
  cat > "$dir/preferences.nix" << 'EOF'
{ pkgs, ... }:

{
  #──[Packages]───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Machine-specific packages
  ];

  #──[Network]────────────────────────────────────────────────────────────────
  networking.networkmanager.enable = true;
}
EOF

  # services.nix
  cat > "$dir/services.nix" << 'EOF'
{ ... }:

{
  enabledServices = [];
}
EOF

  # hardware.nix stub (base hardware comes from /etc/nixos/hardware-configuration.nix)
  cat > "$dir/hardware.nix" << 'EOF'
{ ... }:

{
  # Machine-specific hardware overrides only.
  # Base hardware (filesystems, kernel modules, CPU, swap) comes from
  # /etc/nixos/hardware-configuration.nix (auto-generated by nixos-generate-config),
  # imported in system.nix. Add GPU / power / peripheral tweaks here.

  #──[Bootloader]────────────────────────────────────────────────────────────
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
EOF

  # Generate configuration.nix from the toml
  "$GENERATE_CONFIG" "$dir"

  echo "Machine '$machine' scaffolded."
}

#──[Resolve machine]──────────────────────────────────────────────────────────

if [ -d "$MACHINES_DIR/$HOST" ]; then
  MACHINE="$HOST"
else
  echo "No machine config found for hostname '$HOST'."
  echo ""
  echo "Available machines:"
  ls "$MACHINES_DIR"
  echo ""
  read -rp "Create a new machine config? [Y/n] " reply
  if [[ "$reply" =~ ^[Nn]$ ]]; then
    read -rp "Enter existing machine name: " MACHINE
    if [ ! -d "$MACHINES_DIR/$MACHINE" ]; then
      echo "Error: '$MACHINE' not found in $MACHINES_DIR"
      exit 1
    fi
  else
    read -rp "New machine name [$HOST]: " MACHINE
    MACHINE="${MACHINE:-$HOST}"
    create_machine "$MACHINE"
  fi
fi

echo "Setting up for machine: $MACHINE"

# Parse mainUser from configuration.nix
MAIN_USER=$(awk '/mainUser = / {match($0, /"([^"]+)"/, arr); print arr[1]}' "$MACHINES_DIR/$MACHINE/configuration.nix")
if [ -z "$MAIN_USER" ]; then
  echo "Error: Could not parse mainUser from configuration.nix"
  exit 1
fi

echo "  Main user: $MAIN_USER"

# Determine target home directory based on who's running the script
if [ "$EUID" -eq 0 ]; then
  # Running as root - set up for mainUser
  TARGET_HOME="/home/$MAIN_USER"
  echo "  Running as root. Setting up for user: $MAIN_USER"
else
  # Running as regular user - set up for current user
  TARGET_HOME="$HOME"
  CURRENT_USER="$(whoami)"
  if [ "$CURRENT_USER" != "$MAIN_USER" ]; then
    echo "  Warning: Current user ($CURRENT_USER) doesn't match mainUser ($MAIN_USER) from config"
    read -p "  Continue anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
fi

if [ -n "$DRY_RUN" ]; then
  echo ""
  echo "[dry-run] Machine '$MACHINE' resolved. Would apply (skipped):"
  echo "  link $TARGET_HOME/.config/nixos -> $NIXOS_DIR"
  echo "  link /etc/nixos/configuration.nix -> $MACHINES_DIR/$MACHINE/configuration.nix"
  echo "  link machine *.nix (except default.nix, services.nix) + machine.toml into $NIXOS_DIR"
  echo "  link .system/users/$MAIN_USER.nix and .system/services into $NIXOS_DIR"
  echo ""
  echo "[dry-run] Done. Only the repo's machines/ and users/ were written."
  exit 0
fi

# Create target .config directory if it doesn't exist
mkdir -p "$TARGET_HOME/.config"

# Create symlink in target home directory
ln -sfn "$NIXOS_DIR" "$TARGET_HOME/.config/nixos"
echo "  $TARGET_HOME/.config/nixos -> $NIXOS_DIR"

# Ensure /etc/nixos is a real directory with only configuration.nix symlinked
# If /etc/nixos is a symlink (old behavior), remove it
if [ -L "/etc/nixos" ]; then
  echo "  Converting /etc/nixos from symlink to real directory..."
  sudo rm -f /etc/nixos
fi

# Ensure /etc/nixos exists as a real directory
if [ ! -d "/etc/nixos" ]; then
  echo "  Creating /etc/nixos directory..."
  sudo mkdir -p /etc/nixos
fi

# Symlink only configuration.nix to the machine-specific config
echo "  Symlinking /etc/nixos/configuration.nix -> $MACHINES_DIR/$MACHINE/configuration.nix"
sudo rm -f /etc/nixos/configuration.nix
sudo ln -sf "$MACHINES_DIR/$MACHINE/configuration.nix" /etc/nixos/configuration.nix

# Symlink machine files to root (except default.nix and services.nix)
echo "  Symlinking machine files..."
for file in "$MACHINES_DIR/$MACHINE"/*.nix; do
  filename=$(basename "$file")
  if [[ "$filename" != "default.nix" && "$filename" != "services.nix" ]]; then
    ln -sfn ".system/machines/$MACHINE/$filename" "$NIXOS_DIR/$filename"
    echo "    $filename -> .system/machines/$MACHINE/$filename"
  fi
done

# Symlink machine.toml to root (the edit path: micro ~/.config/nixos/machine.toml)
ln -sfn ".system/machines/$MACHINE/machine.toml" "$NIXOS_DIR/machine.toml"
echo "    machine.toml -> .system/machines/$MACHINE/machine.toml"

# Symlink user file to root
if [ -f "$USERS_DIR/$MAIN_USER.nix" ]; then
  ln -sfn ".system/users/$MAIN_USER.nix" "$NIXOS_DIR/$MAIN_USER.nix"
  echo "    $MAIN_USER.nix -> .system/users/$MAIN_USER.nix"
fi

# Symlink services folder to root
ln -sfn ".system/services" "$NIXOS_DIR/services"
echo "    services/ -> .system/services/"

echo ""
echo "Done. Run 'sudo nixos-rebuild test' to verify."
