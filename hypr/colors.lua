-- Reads Noctalia's generated ~/.config/hypr/noctalia.conf and applies its
-- color variables via hl.config(). Noctalia itself is untouched and keeps
-- writing hyprlang; this file is the only bridge into the Lua config.
--
-- CAVEAT: Hyprland autoreloads on changes to `source`d .conf files, but this
-- file is read via `io`, not `source`d, so a Noctalia re-theme will not be
-- picked up until the next `hyprctl reload`.

local NOCTALIA_CONF = os.getenv("HOME") .. "/.config/hypr/noctalia.conf"

local function read_vars(path)
    local file = io.open(path, "r")
    if not file then
        error("colors.lua: cannot open " .. path .. " (has Noctalia generated it yet?)")
    end

    local vars = {}
    for line in file:lines() do
        local name, value = line:match("^%$(%w+)%s*=%s*(.+)$")
        if name then
            vars[name] = value
        end
    end
    file:close()
    return vars
end

local function required(vars, name)
    local v = vars[name]
    if not v then
        error("colors.lua: expected variable $" .. name .. " in noctalia.conf, but it was not found")
    end
    return v
end

local vars = read_vars(NOCTALIA_CONF)

local primary        = required(vars, "primary")
local surface        = required(vars, "surface")
local secondary      = required(vars, "secondary")
local err             = required(vars, "error")

hl.config({
    general = {
        col = {
            active_border   = primary,
            inactive_border = surface,
        },
    },

    group = {
        col = {
            border_active          = secondary,
            border_inactive        = surface,
            border_locked_active   = err,
            border_locked_inactive = surface,
        },

        groupbar = {
            col = {
                active          = secondary,
                inactive        = surface,
                locked_active   = err,
                locked_inactive = surface,
            },
        },
    },
})
