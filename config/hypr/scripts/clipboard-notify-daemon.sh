#!/usr/bin/env bash
# Clipboard notification on copy
# Monitors Wayland clipboard and triggers notification/sound on changes

rm -f /tmp/clipboard-daemon-started
rmdir /tmp/clipboard-debounce 2>/dev/null

wl-paste --watch sh -c '
    if [ ! -f /tmp/clipboard-daemon-started ]; then
        touch /tmp/clipboard-daemon-started
        exit 0
    fi
    mkdir /tmp/clipboard-debounce 2>/dev/null || exit 0
    (sleep 0.5 && rmdir /tmp/clipboard-debounce) &
    # content=$(wl-paste | head -c 200)
    # notify-send -t 1500 "Clipboard" "$content"
    mpv --no-video --really-quiet ~/.config/hypr/sounds/flint-and-steel.ogg &
'
