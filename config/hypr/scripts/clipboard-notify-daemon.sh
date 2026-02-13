#!/usr/bin/env bash
# Clipboard notification on copy
# Monitors Wayland clipboard and triggers notification/sound on changes

wl-paste --watch sh -c '
    # content=$(wl-paste | head -c 200)
    # notify-send -t 1500 "Clipboard" "$content"
    mpv --no-video --really-quiet ~/.config/hypr/sounds/flint-and-steel.ogg &
'
