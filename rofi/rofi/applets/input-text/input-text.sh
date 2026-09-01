#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$DIR/input-text.rasi"

MODE="${1:-normal}"
PROMPT="${2:-}"

if [[ "$MODE" == "password" ]]; then
    rofi -dmenu -password -theme "$THEME" -p "$PROMPT"
else
    rofi -dmenu -theme "$THEME" -p "$PROMPT"
fi
