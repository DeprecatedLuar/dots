-- Hyprland 0.53+ ships a native "scrolling" layout (no plugin required as of
-- 0.56.2 - confirmed via `hyprctl plugin list` => "no plugins loaded" while
-- `general:layout` reports "scrolling"). This file owns layout selection and
-- every layout's config; binds live in keybinds.lua.

-- pseudotile is no longer a dwindle option; it's per-window now via the "pseudo" windowrule effect / dispatcher (mainMod + P)
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

    -- Dead while general.layout = "scrolling"; kept in case of a future switch.
    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },
})
