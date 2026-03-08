#!/usr/bin/env bash
# Sets up NixOS symlinks for this machine.
# Run once on a new machine after cloning the dots repo.

set -e

NIXOS_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
MACHINES_DIR="$NIXOS_DIR/machines"
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

# ~/.config/nixos symlink (no sudo needed)
ln -sfn "$NIXOS_DIR" "$HOME/.config/nixos"
echo "  ~/.config/nixos -> $NIXOS_DIR"

# /etc/nixos/configuration.nix symlink (needs sudo)
sudo ln -sfn "$MACHINES_DIR/$MACHINE/configuration.nix" /etc/nixos/configuration.nix
echo "  /etc/nixos/configuration.nix -> $MACHINES_DIR/$MACHINE/configuration.nix"

echo ""
echo "Done. Run 'sudo nixos-rebuild test' to verify."
