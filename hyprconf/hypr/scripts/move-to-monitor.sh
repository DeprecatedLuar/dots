#!/usr/bin/env bash
# Move active window to next/prev monitor (relative)
direction=$1  # "next" or "prev"

current=$(hyprctl activewindow -j | jq -r '.monitor')
count=$(hyprctl monitors -j | jq 'length')

if [ "$direction" = "next" ]; then
    target=$(( (current + 1) % count ))
else
    target=$(( (current - 1 + count) % count ))
fi

hyprctl dispatch movewindow mon:$target
