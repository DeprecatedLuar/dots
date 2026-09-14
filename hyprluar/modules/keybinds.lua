-- Converted from keybinds.conf
-- NOTE: multi-mod bind strings ("SUPER+SHIFT + key") follow the space-separated
-- mod convention shown in the shipped example (hl.bind(mainMod .. " + Q", ...)).
-- Verify against `hyprctl binds` after reload; adjust separator if Hyprland rejects it.

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- split-monitor-workspaces: needed below for per-monitor workspace binds.
local smw = require("plugins")

local terminal    = os.getenv("TERMINAL")
local fileManager = os.getenv("FILEMANAGER")
local browser      = os.getenv("BROWSER")
local imageViewer   = os.getenv("IMAGE_VIEWER")

--──[Launchers]---------------------------------------------------------------

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. "+SHIFT + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("thunderbird"))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("flatpak run com.rtosta.zapzap"))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("copyq toggle"))

-- Tap-and-release SUPER alone
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("hotline"), { release = true })

--──[Window Management]--------------------------------------------------------

-- Window controls
hl.bind(mainMod .. " + Q",       hl.dsp.window.close())
hl.bind(mainMod .. "+SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + M",       hl.dsp.window.fullscreen({ action = "toggle" }))
-- NOTE: fullscreen_state's arg shape isn't enumerated in the Lua stub (was
-- `fullscreenstate, 0 2` in hyprlang); {internal=,client=} is a guess by analogy
-- with hl.dsp.window.fullscreen({action=...}). Check `hyprctl reload` for errors.
hl.bind("F11",                   hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
hl.bind(mainMod .. " + Z",       hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + X",       hl.dsp.exec_cmd("hyprctl -i 0 kill"))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle

-- Focus movement
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Column navigation (scroll viewport, scrolling layout)
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma",  hl.dsp.layout("move -col"))

-- Move windows (left/right taken by column swap below, not window.move)
hl.bind(mainMod .. "+SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. "+SHIFT + up",   hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+SHIFT + left",  hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. "+SHIFT + right", hl.dsp.layout("swapcol r"))

-- I: pulls the next (right) column's top window into the current column, stacking it
hl.bind(mainMod .. " + I", hl.dsp.layout("consume"), { repeating = true })

-- U: no native "consume from previous column" message exists, so fake it by
-- hopping left, consuming (which always pulls from the right), then hopping back
hl.bind(mainMod .. " + U", function()
    hl.dispatch(hl.dsp.layout("focus l"))
    hl.dispatch(hl.dsp.layout("consume"))
    hl.dispatch(hl.dsp.layout("focus r"))
end, { repeating = true })

-- O: promote current window into its own column (takes the slot window.move({left}) would have used)
hl.bind(mainMod .. " + O", hl.dsp.layout("promote"))

hl.bind(mainMod .. "+ALT + right",  hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. "+ALT + left",   hl.dsp.window.move({ monitor = "-1" }))

-- Resize windows (left/right taken by column resize below, not window.resize)
hl.bind(mainMod .. "+CTRL + up",   hl.dsp.window.resize({ x = 0, y = 70, relative = true }))
hl.bind(mainMod .. "+CTRL + down", hl.dsp.window.resize({ x = 0, y = -70, relative = true }))
hl.bind(mainMod .. "+CTRL + left",  hl.dsp.layout("colresize -0.05"))
hl.bind(mainMod .. "+CTRL + right", hl.dsp.layout("colresize +0.05"))

-- Mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--──[Workspaces]----------------------------------------------------------------

-- Switch workspaces with mainMod + [0-9], independently per monitor
-- (split-monitor-workspaces: each monitor keeps its own workspace 1-10,
-- instead of Hyprland's default global workspace pool).
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, smw.get_amount_of_workspaces() do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         smw.workspace(tostring(i)))
    hl.bind(mainMod .. "+SHIFT + " .. key,   smw.move_to_workspace_silent(tostring(i)))
end

-- Scroll through workspaces on the focused monitor
hl.bind(mainMod .. " + mouse_down", smw.cycle_workspaces("+1"))
hl.bind(mainMod .. " + mouse_up",   smw.cycle_workspaces("-1"))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + space",       hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. "+SHIFT + space", hl.dsp.window.move({ workspace = "special:magic" }))

--──[Media Keys]------------------------------------------------------------

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { repeating = true, locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true })

-- Microphone
hl.bind("CTRL + XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),  { locked = true })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+"),   { repeating = true, locked = true })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"),   { repeating = true, locked = true })

-- Brightness / gamma
hl.bind("XF86MonBrightnessUp",        hl.dsp.exec_cmd("sunset +5"),        { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown",      hl.dsp.exec_cmd("sunset -5"),        { repeating = true, locked = true })
hl.bind("CTRL + XF86MonBrightnessUp", hl.dsp.exec_cmd("sunset temp -250"), { repeating = true, locked = true })
hl.bind("CTRL + XF86MonBrightnessDown", hl.dsp.exec_cmd("sunset temp +250"), { repeating = true, locked = true })

-- Media playback
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Push-to-mute passthrough for meeting apps
hl.bind("SHIFT + XF86AudioMute", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "M" }))

--──[Mouse Emulation]-------------------------------------------------------

-- Coarse pointer jumps
hl.bind("ALT + H", hl.dsp.exec_cmd("ydotool mousemove -x -200 -y 0"))
hl.bind("ALT + J", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y 200"))
hl.bind("ALT + K", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y -200"))
hl.bind("ALT + L", hl.dsp.exec_cmd("ydotool mousemove -x 200 -y 0"))

-- Fine pointer movement (repeats while held)
hl.bind("ALT+SHIFT + H", hl.dsp.exec_cmd("ydotool mousemove -x -7 -y 0"), { repeating = true })
hl.bind("ALT+SHIFT + J", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y 5"),  { repeating = true })
hl.bind("ALT+SHIFT + K", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y -5"), { repeating = true })
hl.bind("ALT+SHIFT + L", hl.dsp.exec_cmd("ydotool mousemove -x 7 -y 0"),  { repeating = true })

-- Clicks
hl.bind("ALT + F", hl.dsp.exec_cmd("ydotool click 0xC0"))
hl.bind("ALT + D", hl.dsp.exec_cmd("ydotool click 0xC1"))

--──[Screenshots & Utils]---------------------------------------------------

hl.env("SLURP_ARGS", "-b 00000066 -c 20202033") -- selection overlay style for grimblast/slurp

hl.bind("Print",       hl.dsp.exec_cmd("grimblast -f -n copysave area ~/Media/screenshots/latest.png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast -f -n -o save area"))
hl.bind(mainMod .. " + P",      hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. "+CTRL + P", hl.dsp.exec_cmd("grimblast -f -n copysave area"))
hl.bind(mainMod .. "+SHIFT + P", hl.dsp.exec_cmd(imageViewer .. " ~/Media/screenshots/latest.png"))

hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("bash -c 'yap toggle & sleep 3 && tcpeek reconnect'"))
