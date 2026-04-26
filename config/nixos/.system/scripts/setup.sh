#!/usr/bin/env bash
# Sets up NixOS symlinks for this machine.
# Run once on a new machine after cloning the dots repo.

set -e

NIXOS_DIR="$(cd "$(dirname "$(realpath "$0")")/../.." && pwd)"
SYS_DIR="$NIXOS_DIR/.system"
MACHINES_DIR="$SYS_DIR/machines"
USERS_DIR="$SYS_DIR/users"
HOST="$(hostname)"

# Resolve machine name
if [ -d "$MACHINES_DIR/$HOST" ]; then
  MACHINE="$HOST"
else
  echo "No machine config found for hostname '$HOST'."
  echo ""
  echo "Available machines:"
  ls "$MACHINES_DIR"
  echo ""
  read -rp "Enter machine name: " MACHINE
  if [ ! -d "$MACHINES_DIR/$MACHINE" ]; then
    echo "Error: '$MACHINE' not found in $MACHINES_DIR"
    exit 1
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

# ~/.config/nixos symlink (no sudo needed)
ln -sfn "$NIXOS_DIR" "$HOME/.config/nixos"
echo "  ~/.config/nixos -> $NIXOS_DIR"

# /etc/nixos folder symlink (needs sudo)
sudo ln -sfn "$NIXOS_DIR" /etc/nixos
echo "  /etc/nixos -> $NIXOS_DIR"

# Symlink machine files to root (except default.nix and services.nix)
echo "  Symlinking machine files..."
for file in "$MACHINES_DIR/$MACHINE"/*.nix; do
  filename=$(basename "$file")
  if [[ "$filename" != "default.nix" && "$filename" != "services.nix" ]]; then
    ln -sfn ".system/machines/$MACHINE/$filename" "$NIXOS_DIR/$filename"
    echo "    $filename -> .system/machines/$MACHINE/$filename"
  fi
done

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
