hl.config({
    general = {
        layout = "scrolling",
    },

    scrolling = {
        column_width                = 0.3,
        explicit_column_widths      = "0.25, 0.33, 0.5, 0.6, 0.75, 1.0",
        follow_focus                = true,
        fullscreen_on_one_column    = false,
    },

    -- Inactive unless general.layout is switched
    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },
})
