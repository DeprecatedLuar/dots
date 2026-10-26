-- Window and layer rules
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Screen-share picker: ensure it always floats and centers
hl.window_rule({
    name   = "share-picker-class-float",
    match  = { class = "^(hyprland-share-picker)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name   = "share-picker-title-float",
    match  = { title = "^(Select what to share)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name   = "preview-share-picker-float",
    match  = { class = "^(hyprland-preview-share-picker)$" },
    float  = true,
    center = true,
})
