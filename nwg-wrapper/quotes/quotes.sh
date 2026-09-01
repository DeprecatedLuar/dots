#!/usr/bin/env bash

DIR="$HOME/.config/nwg-wrapper/quotes"
SCRIPT_PATH="$DIR/quotes.sh"
CSS_PATH="$DIR/quotes.css"
FETCH_SCRIPT="$DIR/fetch-quote.sh"

if [[ "$NWG_QUOTE_OUTPUT" == "1" ]]; then
    { read -r quote; read -r author; } < <("$FETCH_SCRIPT")
    echo "<span font='Sans 12' foreground='#f0f0f099'>\"$quote\"</span>"
    echo "<span font='Sans 9' foreground='#ffffff50'>— $author</span>"
else
    export NWG_QUOTE_OUTPUT=1
    exec nwg-wrapper -s "$SCRIPT_PATH" -c "$CSS_PATH" -a end -mb -50
fi
