package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/?.lua"
require("hyprlush")

require("noctalia").apply_theme()


-- hyprmon: managed monitor profile include
require("hyprmon")

-- Hyprcyclops auto import start
require(os.getenv("HOME") .. "/.local/share/hypr/local/monitors")
