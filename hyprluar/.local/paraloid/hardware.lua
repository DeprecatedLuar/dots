-- Converted from hardware.conf
-- Cursor size, input devices, and monitors.

hl.env("XCURSOR_SIZE", "17")
hl.env("HYPRCURSOR_SIZE", "17")

hl.config({
    cursor = {
        no_hardware_cursors = true,
        default_monitor     = "",
        enable_hyprcursor   = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 2,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Wacom Tablet - Map to main monitor only
hl.device({
    name   = "wacom-one-by-wacom-s-pen",
    output = "eDP-1",
})

hl.device({
    name   = "tablet-monitor-pen",
    output = "DP-1",
})

-- Monitor layout is owned by hyprcyclops; see the require in hyprland.lua and
-- ~/.local/share/hypr/monitors.lua (machine-specific, generated, not in git).
