package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/?.lua"
require("hyprlush")

-- Generic monitor layout: no hyprcyclops/XDG-data-dir dependency, works on
-- any machine without per-host generated state.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, disabled = false, mirror = "" })


-- For Noctalia Color templates
require("noctalia").apply_theme()
