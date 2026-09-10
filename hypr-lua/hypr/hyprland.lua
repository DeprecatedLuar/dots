-- Converted from hyprland.conf (+ keybinds.conf, hardware.conf, hyprscrolling.conf,
-- noctalia.conf). Hyprland deprecated hyprlang (.conf) in favor of Lua as of 0.55;
-- this machine runs 0.56.2. The old .conf files are left in place for reference /
-- rollback and are no longer read by Hyprland once this file exists.
--
-- Reference: /nix/store/.../hyprland-0.56.2/share/hypr/hyprland.lua (shipped example)
--            /nix/store/.../hyprland-0.56.2/share/hypr/stubs/hl.meta.lua (full API)

require("keybinds")
require("hardware")
require("scrolling")

-- hyprmon owns the monitor layout; it regenerates this file on every run.
-- pcall: a plain require of a missing module would kill the rest of this file,
-- which matters on a fresh machine before hyprmon has ever written it.
local monitors_ok, monitors_err = pcall(require, os.getenv("HOME") .. "/.local/share/hypr/monitors")
if not monitors_ok then
    hl.notification.create({ text = "hyprmon: " .. tostring(monitors_err), timeout = 8000 })
end

--──[Autostart]---------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpolkitagent")
    -- was "xec-once" (missing leading e) in the old .conf - self-heal never ran. Fixed here.
    hl.exec_cmd("~/.config/hypr/scripts/self-heal.sh")
    hl.exec_cmd("~/.config/hypr/scripts/clipboard-notify-daemon.sh")

    hl.exec_cmd("mpv ~/.config/hypr/sounds/startup-sound-fast.mp3")
    hl.exec_cmd("ydotoold")
    -- hl.exec_cmd("quickshell -p /home/luar/.config/quickshell/noctalia-shell/")
    hl.exec_cmd("sleep 5 && systemctl --user restart xdg-desktop-portal")
    -- hl.exec_cmd("noctalia")
    -- hl.exec_cmd("ambxst")
    -- hl.exec_cmd("~/.config/nwg-wrapper/quotes/quotes.sh")
    -- hl.exec_cmd("sleep 4 && kbstart")
end)

--──[Environment]---------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("SLURP_ARGS", "-b 00000066 -c 20202033")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GTK_THEME", "adw-gtk3-dark")

--──[Permissions]----------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Require a Hyprland restart and are not applied on-the-fly

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

--──[Appearance]------------------------------------------------------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 17,

        border_size = 2,

        col = {
            active_border   = "rgba(88C0D0ee)", -- Nord frost blue
            inactive_border = "rgba(4C566Aaa)", -- Nord polar night gray
        },

        resize_on_border = true,
        allow_tearing    = false,

        layout = "scrolling",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

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
            size     = 10,
            passes   = 2,
            xray     = true,
            popups   = false,
            vibrancy = 1,
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

-- pseudotile is no longer a dwindle option; it's per-window now via the "pseudo" windowrule effect / dispatcher (mainMod + P)
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper   = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo     = false, -- If true disables the random hyprland logo / anime girl background. :(
        key_press_enables_dpms    = true,
        mouse_move_enables_dpms   = false,
        animate_manual_resizes    = true,  -- Smooth out keybind-driven resizes (hl.dsp.window.resize)
    },

    cursor = {
        no_hardware_cursors = true,
        default_monitor     = "",
        enable_hyprcursor   = true,
    },
})

--──[Window Rules]-----------------------------------------------------------------
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

-- Was: source = ~/.config/hypr/noctalia/noctalia-colors.conf
-- That file does not exist (dead source line in the old .conf) - dropped.

-- Applies Noctalia's generated colors (~/.config/hypr/noctalia.conf) on top of
-- the base appearance above. Required last so it wins.
-- Disabled: Noctalia no longer autostarts, so noctalia.conf is never
-- regenerated and this bridge just errors out on missing file.
-- require("colors")

-- For Noctalia Color templates
-- require("noctalia").apply_theme()

