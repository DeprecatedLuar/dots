#!/usr/bin/env bash
# Load hyprland plugins from nix store
# Usage: nix-hyprplugin.sh hyprscrolling hyprbars ...

for plugin in "$@"; do
  so=$(ls /nix/store/*-${plugin}-*/lib/*.so 2>/dev/null | head -1)
  if [[ -f "$so" ]]; then
    hyprctl plugin load "$so"
  else
    echo "error: plugin '$plugin' not found in nix store" >&2
  fi
done
