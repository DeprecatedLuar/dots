#!/bin/bash
# Run from ~/.config/krita after cloning the repo there

KRITA_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.bak"
        echo "backed up $dst"
    fi
    ln -sf "$src" "$dst"
    echo "linked $dst -> $src"
}

link "$KRITA_DIR/kritarc"        "$HOME/.config/kritarc"
link "$KRITA_DIR/kritadisplayrc" "$HOME/.config/kritadisplayrc"
link "$KRITA_DIR/share"          "$HOME/.local/share/krita"
