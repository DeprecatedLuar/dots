-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
-- and https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- Static snapshot of the Noctalia palette in use on paraloid at the time
-- this vanilla config was cut. No Noctalia install/generation required.
local palette = {
    primary        = "rgb(a6b3da)",
    surface        = "rgb(1a1c23)",
    on_surface     = "rgb(f2f2f3)",
    secondary      = "rgb(b3a6da)",
    on_secondary   = "rgb(1b1d22)",
    error          = "rgb(fd4663)",
    on_error       = "rgb(1b1d22)",
}

local ACTIVE_BORDER_ANGLE = 45
local ACTIVE_BORDER_ACCENT = "rgb(88C0D0)" -- Nord frost blue, middle stop (Noctalia has no distinct third hue)

local CURSOR_THEME = "breeze_cursors"
local CURSOR_SIZE  = "22"

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("XCURSOR_THEME", CURSOR_THEME)
hl.env("HYPRCURSOR_THEME", CURSOR_THEME)
hl.env("XCURSOR_SIZE", CURSOR_SIZE)
hl.env("HYPRCURSOR_SIZE", CURSOR_SIZE)

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = { top = 10, right = 12, bottom = 5, left = 12 },

        border_size = 2,

        col = {
            active_border   = { colors = { palette.primary, ACTIVE_BORDER_ACCENT, palette.secondary }, angle = ACTIVE_BORDER_ANGLE },
            inactive_border = "rgba(000000cc)",
        },

        resize_on_border = true,
        allow_tearing    = false,

        -- layout is set in layout.lua, next to the layout it selects.
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Special workspace (scratchpad): light blur plus a subtle dim behind it
        dim_special = 0.0, -- was 0.08

        active_opacity   = 0.99,
        inactive_opacity = 0.94,

        shadow = {
            enabled      = true,
            range        = 3,
            render_power = 5,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 2,
            passes   = 2,
            popups   = false,
            special  = true,
            vibrancy = 2,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/ for more
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 2,    bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2,    bezier = "almostLinear", style = "slide" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
