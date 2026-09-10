-- Converted from hyprscrolling.conf
-- Hyprland 0.53+ ships a native "scrolling" layout (general.layout = "scrolling"
-- in hyprland.lua); the old hyprscrolling plugin is no longer needed.

hl.config({
    scrolling = {
        column_width                = 0.3,
        explicit_column_widths      = "0.25, 0.33, 0.5, 0.6, 0.75, 1.0",
        follow_focus                = true,
        fullscreen_on_one_column    = false,
    },
})

--──[Hyprscrolling Keybinds]────────────────────────────────────────────────

local mainMod = "SUPER"

-- Column resizing
hl.bind(mainMod .. "+CTRL + left",  hl.dsp.layout("colresize -0.05"))
hl.bind(mainMod .. "+CTRL + right", hl.dsp.layout("colresize +0.05"))

-- Column navigation (scroll viewport)
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma",  hl.dsp.layout("move -col"))

-- Window/column management
hl.bind(mainMod .. " + O", hl.dsp.layout("promote"))
hl.bind(mainMod .. "+SHIFT + left",  hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. "+SHIFT + right", hl.dsp.layout("swapcol r"))
