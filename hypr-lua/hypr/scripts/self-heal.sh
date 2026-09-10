#!/usr/bin/env bash
# Self-healing symlink system for Hyprland scripts
# Ensures all scripts in scripts/bin are symlinked to ~/.local/bin

SCRIPT_DIR="$HOME/.config/hypr/scripts"
BIN_DIR="$SCRIPT_DIR/bin"
TARGET_DIR="$HOME/.local/bin"

#--[CLEANUP BROKEN SYMLINKS]------------------------

cleanup_broken_links() {
    find "$TARGET_DIR" -maxdepth 1 -xtype l -delete 2>/dev/null || true
}

cleanup_broken_links

#--[MAKE SCRIPTS EXECUTABLE]------------------------

chmod +x "$BIN_DIR"/* 2>/dev/null || true

#--[SYNC SYMLINKS]----------------------------------

[ -d "$BIN_DIR" ] || exit 0

for script in "$BIN_DIR"/*; do
    [ -e "$script" ] || continue
    [ -d "$script" ] && continue
    ln -sf "$script" "$TARGET_DIR/$(basename "$script")"
done

#--[REFRESH COMMAND HASH]---------------------------

hash -r
