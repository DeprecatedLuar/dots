#!/usr/bin/env bash
# Gamescope + nvidia offload + FSR wrapper for Steam games
# Usage: gamescope-boost.sh <appid>
# Note: May cause stuttering on weak GPUs (MX450 etc) due to compositor overhead

RENDER_W="${STK_RENDER_W:-1280}"
RENDER_H="${STK_RENDER_H:-720}"
OUTPUT_W="${STK_OUTPUT_W:-1920}"
OUTPUT_H="${STK_OUTPUT_H:-1080}"

appid="$1"

if [[ -z "$appid" ]]; then
    echo "Usage: gamescope-boost.sh <appid>"
    exit 1
fi

exec nvidia-offload gamescope -e \
    -w "$RENDER_W" -h "$RENDER_H" \
    -W "$OUTPUT_W" -H "$OUTPUT_H" \
    -f -F fsr -- steam -tenfoot -steamos -applaunch "$appid"
