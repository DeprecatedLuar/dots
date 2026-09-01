#!/usr/bin/env bash
# Parses key names out of keybindings.conf into a single status-bar line.

awk '
	match($0, /bind-key -N "[^"]*" +([^ ]+)/, m) {
		printf "%s  ", m[1]
	}
' ~/.config/tmux/keybindings.conf
