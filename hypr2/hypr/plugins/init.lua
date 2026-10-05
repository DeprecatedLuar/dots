-- split-monitor-workspaces: per-monitor workspace numbering

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/plugins/?.lua;" .. os.getenv("HOME") .. "/.config/hypr/plugins/?/init.lua"
local smw = require("split-monitor-workspaces")
smw.setup({ workspace_count = 10 })

return smw
