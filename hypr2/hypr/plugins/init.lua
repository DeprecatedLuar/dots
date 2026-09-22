-- split-monitor-workspaces: independent workspace numbering per monitor
-- (Hyprland's default workspace pool is global, not per-monitor).
--
-- Returns the module so keybinds.lua can `local smw = require("plugins")`
-- instead of relying on a global.

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/plugins/?.lua;" .. os.getenv("HOME") .. "/.config/hypr/plugins/?/init.lua"
local smw = require("split-monitor-workspaces")
smw.setup({ workspace_count = 10 })

return smw
