package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/?.lua"
require("hyprlush")

-- For Noctalia Color templates
require("noctalia").apply_theme()

-- Hyprcyclops auto import start
require(os.getenv("HOME") .. "/.local/share/hypr/local/monitors")
