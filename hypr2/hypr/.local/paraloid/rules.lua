-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Portal screen/window picker
hl.window_rule({
    name  = "portal-picker-float",
    match = { title = "^(Select what to share)$" },
    float = true,
})
hl.window_rule({
    name  = "portal-picker-center",
    match = { title = "^(Select what to share)$" },
    center = true,
})

-- scrcpy window
-- NOTE: min_size/max_size field names carried over 1:1 from hyprlang; unverified
-- against the Lua stub (not enumerated there). Check `hyprctl reload` for errors.
hl.window_rule({
    name    = "scrcpy-min-size",
    match   = { class = "^(.scrcpy-wrapped)$" },
    min_size = "413 1010",
})
hl.window_rule({
    name    = "scrcpy-max-size",
    match   = { class = "^(.scrcpy-wrapped)$" },
    max_size = "413 1010",
})

-- CopyQ clipboard history
hl.window_rule({
    name  = "copyq-float",
    match = { class = "^(com.github.hluk.copyq)$" },
    float = true,
})

-- swayimg image viewer
hl.window_rule({
    name  = "swayimg-float",
    match = { class = "^(swayimg)$" },
    float = true,
})
hl.window_rule({
    name     = "swayimg-min-size",
    match    = { class = "^(swayimg)$" },
    min_size = "800 600",
})

-- File picker (XDG portal)
hl.window_rule({
    name  = "xdg-portal-gtk-float",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
})
hl.window_rule({
    name   = "xdg-portal-gtk-center",
    match  = { class = "^(xdg-desktop-portal-gtk)$" },
    center = true,
})

-- webcam viewer (~/.config/hypr/bin/webcam); size comes from the launcher
hl.window_rule({
    name  = "webcam-float",
    match = { class = "^(webcam(-locked)?)$" },
    float = true,
    pin   = true,
})
hl.window_rule({
    name    = "webcam-opaque",
    match   = { class = "^(webcam(-locked)?)$" },
    opacity = "1.0 override 1.0 override",
})
hl.window_rule({
    name              = "webcam-locked-aspect",
    match             = { class = "^(webcam-locked)$" },
    keep_aspect_ratio = true,
})
