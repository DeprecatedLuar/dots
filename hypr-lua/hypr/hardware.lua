-- Converted from hardware.conf
-- Cursor size, input devices, and monitors.

hl.env("XCURSOR_SIZE", "17")
hl.env("HYPRCURSOR_SIZE", "17")

hl.config({
    cursor = {
        no_hardware_cursors = true,
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

-----------------
---- MONITORS ----
-----------------

-- Was sourced from ~/.local/share/hypr/monitors.conf (static; hyprmon not installed).
-- If hyprmon is reinstalled and regenerates that file, revisit this.
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "auto-left",
    scale    = 1.2,
})
