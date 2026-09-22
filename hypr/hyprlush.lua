local CONFIG_DIR = os.getenv("HOME") .. "/.config/hypr"

package.path = package.path .. ";" .. CONFIG_DIR .. "/?.lua;" .. CONFIG_DIR .. "/?/init.lua"

--[[ Self-heal: keep ~/.local/bin symlinks and local/ override stubs in sync ]]

local SELF_HEAL_SCRIPT = [==[
SCRIPTS_BIN_DIR="$CONFIG_DIR/scripts/bin"
LOCAL_BIN_DIR="$HOME/.local/bin"
LOCAL_DIR="$CONFIG_DIR/local"
LOCAL_STATE_DIR="$CONFIG_DIR/.local/$(hostname)"

cleanup_broken_links() {
    find "$LOCAL_BIN_DIR" -maxdepth 1 -xtype l -delete 2>/dev/null || true
}

cleanup_broken_links

mkdir -p "$LOCAL_BIN_DIR" || {
    printf 'self-heal: cannot create script target directory: %s\n' "$LOCAL_BIN_DIR" >&2
    exit 1
}

ensure_local_symlink() {
    mkdir -p "$LOCAL_STATE_DIR" || {
        printf 'self-heal: cannot create local state directory: %s\n' "$LOCAL_STATE_DIR" >&2
        return 1
    }

    if [ -L "$LOCAL_DIR" ] && [ "$(readlink -f "$LOCAL_DIR")" = "$(readlink -f "$LOCAL_STATE_DIR")" ]; then
        return 0
    fi

    if [ -e "$LOCAL_DIR" ] && [ ! -L "$LOCAL_DIR" ]; then
        printf 'self-heal: refusing to replace non-symlink: %s\n' "$LOCAL_DIR" >&2
        return 1
    fi

    ln -sfn "$LOCAL_STATE_DIR" "$LOCAL_DIR"
}

ensure_local_symlink || exit 1

# ensure_local_stubs() {
#     [ -d "$LOCAL_DIR" ] || {
#         printf 'self-heal: local directory is unavailable: %s\n' "$LOCAL_DIR" >&2
#         return 1
#     }
#
#     for root_dir in "$CONFIG_DIR"/*; do
#         [ -d "$root_dir" ] || continue
#
#         name="$(basename -- "$root_dir")"
#         [ "$name" = "local" ] && continue
#
#         mkdir -p "$LOCAL_DIR/$name" || {
#             printf 'self-heal: cannot create local stub: %s\n' "$LOCAL_DIR/$name" >&2
#             return 1
#         }
#     done
# }
#
# ensure_local_stubs || exit 1

chmod +x "$SCRIPTS_BIN_DIR"/* 2>/dev/null || true

if [ -d "$SCRIPTS_BIN_DIR" ]; then
    for script in "$SCRIPTS_BIN_DIR"/*; do
        [ -e "$script" ] || continue
        [ -d "$script" ] && continue

        target="$LOCAL_BIN_DIR/$(basename "$script")"
        if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$script")" ]; then
            continue
        fi

        ln -sf "$script" "$target" || {
            printf 'self-heal: cannot link script: %s\n' "$target" >&2
            exit 1
        }
    done
fi

hash -r
]==]

local function run_self_heal()
    local proc = io.popen("bash", "w")
    if not proc then
        io.stderr:write("hyprlush: cannot spawn self-heal shell\n")
        return
    end
    proc:write('CONFIG_DIR="' .. CONFIG_DIR .. '"\n')
    proc:write(SELF_HEAL_SCRIPT)
    proc:close()
end

local function import_root_modules()
    local handle = io.popen(
        'find -L "' .. CONFIG_DIR .. '" -mindepth 2 -maxdepth 2 ' ..
        '-type f -name "init.lua" -print | sort'
    )

    if not handle then
        error("hyprlush: cannot find root module initializers")
    end

    for path in handle:lines() do
        local module = path:match("/([^/]+)/init%.lua$")
        if module then
            require(module)
        end
    end
end

run_self_heal()
import_root_modules()
