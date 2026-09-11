-- Loads every module in main/ (generic config) and local/ (host-specific
-- tweaks - device names, window rules tied to this machine's apps, the
-- monitor layout hyprmon generates) without the orchestrator naming them
-- individually. local/ is a self-healing symlink into the XDG data dir, so
-- it's per-machine state, never repo content - see ensure_local_symlink().
-- Each folder's files are require()'d in alphabetical order for determinism;
-- local/ loads after main/ so a local file can override a generic hl.config()
-- key by name.

local CONFIG_DIR = os.getenv("HOME") .. "/.config/hypr"
local LOCAL_STATE_DIR = (os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")) .. "/hypr/local"

-- Self-heals local/ as a symlink into the XDG data dir, same pattern as the
-- scripts/bin -> ~/.local/bin self-heal: local/ is machine-specific state
-- (device names, monitor layout hyprmon owns), so it never lives in the repo.
local function ensure_local_symlink()
    local link = CONFIG_DIR .. "/local"
    local test_handle = io.popen('test -L "' .. link .. '" && echo yes || echo no')
    local is_symlink = test_handle and test_handle:read("*l") or "no"
    if test_handle then test_handle:close() end

    if is_symlink == "yes" then
        return
    end

    os.execute('mkdir -p "' .. LOCAL_STATE_DIR .. '"')
    os.execute('ln -sfn "' .. LOCAL_STATE_DIR .. '" "' .. link .. '"')
end

local function list_lua_files(dir)
    local files = {}
    local handle = io.popen('ls "' .. dir .. '"/*.lua 2>/dev/null')
    if handle then
        for line in handle:lines() do
            table.insert(files, line)
        end
        handle:close()
    end
    table.sort(files)
    return files
end

local function require_folder(folder)
    for _, path in ipairs(list_lua_files(CONFIG_DIR .. "/" .. folder)) do
        local name = path:match("([^/]+)%.lua$")
        require(folder .. "." .. name)
    end
end

require_folder("main")
ensure_local_symlink()
require_folder("local")
