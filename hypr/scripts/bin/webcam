#!/usr/bin/env bash
# webcam: bare camera view in mpv, zoomed to fill the window.
#   left-drag pans the image, right-drag / arrows / hjkl move the view, scroll zooms, m mirrors.
#   webcam [--lock[=RATIO]] [-c|--camera CAM] [--list] [CAM]
#     CAM            device path, or a case-insensitive substring of a camera name
#                    (see --list); defaults to the first real camera found
#     --list         print the available cameras and exit
#     --lock        lock the window aspect ratio; RATIO is W:H or "square" (default)
#   Without --lock the window spawns square but can be resized freely.
set -euo pipefail

readonly CAMERA_DIR="/dev/v4l/by-id" # real capture nodes only; no virtual cams or metadata nodes
readonly CAMERA_GLOB="*-video-index0"
readonly INPUT_FORMAT="mjpeg" # YUYV at 720p is only 10 fps on this camera
readonly VIDEO_SIZE="1280x720"
readonly FRAMERATE=30
readonly APP_ID_FREE="webcam"          # matched by the hyprland window rules
readonly APP_ID_LOCKED="webcam-locked" # rules add keep_aspect_ratio for this class
readonly SQUARE_KEYWORD="square"
readonly BASE_WIDTH=500
readonly PAN_SCRIPT="${XDG_RUNTIME_DIR:-/tmp}/webcam-pan.lua"

# mpv script, materialized to PAN_SCRIPT on launch
read -r -d '' PAN_LUA <<'LUA' || true
-- Pan a zoomed (panscan) video within the window:
--   left-drag moves the image with the cursor
--   right-drag moves the image with the cursor, same as left-drag
--   arrows / hjkl move the viewport (right shows more of the right side)
--   scroll wheel zooms in/out (never below fill), m/M mirrors horizontally
local mp = require("mp")

local IMAGE_DRAG_BUTTON = "MBTN_LEFT"
local VIEW_DRAG_BUTTON = "MBTN_RIGHT"
local KEY_STEP_FRACTION = 0.05 -- of window size per key press/repeat
local ZOOM_STEP = 0.1 -- log2 units per wheel notch
local ZOOM_MAX = 3      -- log2 units, i.e. 8x on top of fill
local MIRROR_KEYS = { "m", "M" }
local VIEW_KEYS = {
    { keys = { "LEFT", "h" },  dx = -1, dy = 0 },
    { keys = { "RIGHT", "l" }, dx = 1,  dy = 0 },
    { keys = { "UP", "k" },    dx = 0,  dy = -1 },
    { keys = { "DOWN", "j" },  dx = 0,  dy = 1 },
}

local drag_sign = 0 -- 0 idle, 1 image follows cursor, -1 image moves against cursor
local last_x, last_y = 0, 0

local function clamp(v, limit)
    return math.max(-limit, math.min(limit, v))
end

-- Clamp pan (fractions of the scaled video) so the window stays covered.
local function apply_pan(px, py)
    local vp = mp.get_property_native("video-params")
    local win = mp.get_property_native("osd-dimensions")
    if not vp or not vp.w or not win or win.w == 0 or win.h == 0 then return end

    -- panscan=1 scales the video to cover the window; video-zoom is on top of that
    local scale = math.max(win.w / vp.w, win.h / vp.h) * 2 ^ mp.get_property_number("video-zoom", 0)
    local sw, sh = vp.w * scale, vp.h * scale

    -- overflow is split on both sides
    mp.set_property_number("video-pan-x", clamp(px, math.max(0, (sw - win.w) / 2 / sw)))
    mp.set_property_number("video-pan-y", clamp(py, math.max(0, (sh - win.h) / 2 / sh)))
end

-- Shift the image by (dx, dy) window pixels.
local function pan_by(dx, dy)
    local vp = mp.get_property_native("video-params")
    local win = mp.get_property_native("osd-dimensions")
    if not vp or not vp.w or not win or win.w == 0 or win.h == 0 then return end

    local scale = math.max(win.w / vp.w, win.h / vp.h) * 2 ^ mp.get_property_number("video-zoom", 0)
    apply_pan(mp.get_property_number("video-pan-x", 0) + dx / (vp.w * scale),
              mp.get_property_number("video-pan-y", 0) + dy / (vp.h * scale))
end

mp.observe_property("mouse-pos", "native", function(_, pos)
    if drag_sign == 0 or not pos then return end
    pan_by(drag_sign * (pos.x - last_x), drag_sign * (pos.y - last_y))
    last_x, last_y = pos.x, pos.y
end)

local function bind_drag(button, name, sign)
    mp.add_forced_key_binding(button, name, function(e)
        if e.event == "down" then
            local pos = mp.get_property_native("mouse-pos")
            last_x, last_y = pos.x, pos.y
            drag_sign = sign
        elseif e.event == "up" then
            drag_sign = 0
        end
    end, { complex = true })
end

bind_drag(IMAGE_DRAG_BUTTON, "cam-pan", 1)
bind_drag(VIEW_DRAG_BUTTON, "cam-view-drag", 1)

-- Moving the viewport is the inverse of moving the image.
local function view_by(dx, dy)
    local win = mp.get_property_native("osd-dimensions")
    if not win then return end
    pan_by(-dx * win.w * KEY_STEP_FRACTION, -dy * win.h * KEY_STEP_FRACTION)
end

for _, m in ipairs(VIEW_KEYS) do
    for _, key in ipairs(m.keys) do
        mp.add_forced_key_binding(key, "cam-view-" .. key, function()
            view_by(m.dx, m.dy)
        end, { repeatable = true })
    end
end

local function zoom_by(step)
    local zoom = math.max(0, math.min(ZOOM_MAX, mp.get_property_number("video-zoom", 0) + step))
    mp.set_property_number("video-zoom", zoom)
    -- zooming out shrinks the overflow, so pull the pan back inside it
    apply_pan(mp.get_property_number("video-pan-x", 0), mp.get_property_number("video-pan-y", 0))
end

mp.add_forced_key_binding("WHEEL_UP", "cam-zoom-in", function() zoom_by(ZOOM_STEP) end)
mp.add_forced_key_binding("WHEEL_DOWN", "cam-zoom-out", function() zoom_by(-ZOOM_STEP) end)

for _, key in ipairs(MIRROR_KEYS) do
    mp.add_forced_key_binding(key, "cam-mirror-" .. key, function()
        mp.commandv("vf", "toggle", "hflip")
    end)
end
LUA
readonly PAN_LUA

# write PAN_SCRIPT unless it already holds PAN_LUA
ensure_pan_script() {
    if [[ -f $PAN_SCRIPT && $(<"$PAN_SCRIPT") == "$PAN_LUA" ]]; then
        return 0
    fi
    printf '%s\n' "$PAN_LUA" > "$PAN_SCRIPT"
}

usage() {
    cat <<HELP
usage: webcam [--lock[=RATIO]] [-c|--camera CAM] [--list] [CAM]

Bare camera view, zoomed to fill the window.

options:
  CAM             device path, or a case-insensitive substring of a camera name
                  (default: the first real camera found)
  -c, --camera    same as the positional CAM
  --list          print the available cameras and exit
  --lock[=RATIO]  lock the window aspect ratio; RATIO is W:H or "$SQUARE_KEYWORD" (default: $SQUARE_KEYWORD)
  -h, --help      show this help

The window spawns square (${BASE_WIDTH}px wide) and can be resized freely unless --lock is given.

controls:
  left-drag       pan the image
  right-drag      move the view
  arrows / hjkl   move the view
  scroll          zoom in / out
  m, M            mirror horizontally
HELP
}

# list_cameras -> one CAMERA_DIR path per line
list_cameras() {
    local -a found
    shopt -s nullglob
    found=("$CAMERA_DIR"/$CAMERA_GLOB)
    shopt -u nullglob
    if (( ${#found[@]} )); then
        printf '%s\n' "${found[@]}"
    fi
}

# resolve_camera SELECTOR -> device path
# SELECTOR is empty (first camera), an absolute path, or a name substring
resolve_camera() {
    local selector="$1" cams matches line
    if [[ $selector == /* ]]; then
        printf '%s\n' "$selector"
        return 0
    fi

    cams=$(list_cameras)
    if [[ -z $cams ]]; then
        echo "webcam: no cameras found in $CAMERA_DIR" >&2
        return 1
    fi

    matches=$(grep -iF -- "$selector" <<<"$cams" || true)
    if [[ -z $matches ]]; then
        echo "webcam: no camera matches '$selector'; available:" >&2
        while read -r line; do echo "  $line" >&2; done <<<"$cams"
        return 1
    fi

    # an empty selector means "first camera"; a non-empty one must be unique
    if [[ -n $selector && $matches == *$'\n'* ]]; then
        echo "webcam: '$selector' is ambiguous:" >&2
        while read -r line; do echo "  $line" >&2; done <<<"$matches"
        return 1
    fi
    head -n1 <<<"$matches"
}

# window_size RATIO -> "WxH" at BASE_WIDTH wide, RATIO is W:H or SQUARE_KEYWORD
window_size() {
    local ratio="$1"
    [[ $ratio == "$SQUARE_KEYWORD" ]] && ratio="1:1"
    if [[ ! $ratio =~ ^([1-9][0-9]*):([1-9][0-9]*)$ ]]; then
        echo "webcam: invalid ratio '$1' (use W:H or $SQUARE_KEYWORD)" >&2
        return 1
    fi
    printf '%dx%d\n' "$BASE_WIDTH" $((BASE_WIDTH * BASH_REMATCH[2] / BASH_REMATCH[1]))
}

main() {
    local selector="" ratio="$SQUARE_KEYWORD" app_id="$APP_ID_FREE" device size

    while (( $# )); do
        case $1 in
            --lock)     app_id="$APP_ID_LOCKED" ;;
            --lock=*)   app_id="$APP_ID_LOCKED"; ratio="${1#--lock=}" ;;
            --list)     list_cameras; exit 0 ;;
            --camera=*) selector="${1#--camera=}" ;;
            -c|--camera)
                if (( $# < 2 )); then
                    echo "webcam: $1 needs a value (see --help)" >&2
                    exit 1
                fi
                selector="$2"
                shift ;;
            -h|--help)  usage; exit 0 ;;
            -*)         echo "webcam: unknown option '$1' (see --help)" >&2; exit 1 ;;
            *)          selector="$1" ;;
        esac
        shift
    done

    size=$(window_size "$ratio")
    device=$(resolve_camera "$selector")

    if [[ ! -e $device ]]; then
        echo "webcam: $device not found" >&2
        exit 1
    fi
    if ! ensure_pan_script; then
        echo "webcam: cannot write $PAN_SCRIPT" >&2
        exit 1
    fi

    exec mpv "av://v4l2:$device" \
        --wayland-app-id="$app_id" --geometry="$size" --script="$PAN_SCRIPT" \
        --demuxer-lavf-o="input_format=$INPUT_FORMAT,video_size=$VIDEO_SIZE,framerate=$FRAMERATE" \
        --profile=low-latency --untimed --no-cache \
        --panscan=1 --no-osc --no-input-default-bindings
}

main "$@"
