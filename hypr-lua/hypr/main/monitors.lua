-- hyprmon owns the monitor layout; it regenerates
-- ~/.local/share/hypr/local/monitors.lua on every run (machine-specific,
-- generated, not in git - lives alongside the rest of local/'s state, see
-- config-loader.lua's ensure_local_symlink()).
--
-- pcall: a plain require of a missing module would kill the rest of the config,
-- which matters on a fresh machine before hyprmon has ever written it.

local monitors_ok, monitors_err = pcall(require, os.getenv("HOME") .. "/.local/share/hypr/local/monitors")
if not monitors_ok then
    hl.notification.create({ text = "hyprmon: " .. tostring(monitors_err), timeout = 8000 })
end
