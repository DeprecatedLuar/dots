#!/usr/bin/env bash
# Monitor sync daemon
# Hyprland fully removes and re-adds a monitor when it comes back from a
# prolonged DPMS-off cycle (hypridle) or a real hotplug — and falls back to
# its own default position/scale for that output, silently drifting away
# from what hyprmon last applied. hyprmon has no way to notice this on its
# own (it only diffs against its own cache), so this daemon listens for the
# monitoraddedv2 event and reconciles the live compositor state against
# ~/.local/share/hypr/monitors.json via `hyprmon apply --force`.

DEBOUNCE_DIR="/tmp/monitor-sync-debounce"

rmdir "$DEBOUNCE_DIR" 2>/dev/null

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
socat -U - UNIX-CONNECT:"${RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do
    case "$line" in
        monitoraddedv2\>\>*)
            mkdir "$DEBOUNCE_DIR" 2>/dev/null || continue
            (sleep 0.5 && rmdir "$DEBOUNCE_DIR" 2>/dev/null && hyprmon apply --force >/dev/null 2>&1) &
            ;;
    esac
done
