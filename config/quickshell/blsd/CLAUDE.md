# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

blsd is a QuickShell-based screen overlay that renders a gradient border and optional tint around the entire screen. It's controlled via a CLI that writes to a JSON config file watched by the shell.

## Architecture

**shell.qml** - QuickShell config using:
- `FileView` + `JsonAdapter` watching `/tmp/blsd.json` for live config updates
- `PanelWindow` fullscreen overlay with `mask: Region {}` for click-through
- `Shape` with `OddEvenFill` to create gradient border ring (outer - inner PathRectangle)
- Asymmetric border: `borderX` (sides) is thicker than `borderY` (top/bottom)

**blsd** - Bash CLI that manipulates `/tmp/blsd.json` via `jq`

## Running

```bash
# Start the overlay
quickshell -c blsd

# Symlink CLI to PATH
ln -s ~/.config/quickshell/blsd/blsd ~/.local/bin/blsd
```

## CLI Usage

```bash
blsd <color>        # Named: yellow, red, blue, green, orange, purple, pink, cyan, white, black
blsd "#hex"         # Custom hex color
blsd -b <px> color  # Set border then color (flag must come first)
blsd hide           # Hide overlay
blsd show           # Show overlay
blsd tint <0-1>     # Set tint opacity
blsd border <px>    # Set border (scales proportionally: X=px, Y=px/2, radius=px*2)
blsd borderx <px>   # Set side borders only
blsd bordery <px>   # Set top/bottom borders only
blsd radius <px>    # Set corner radius
```

## Config Properties (JSON)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| color | string | #1a1a1a | Primary gradient color (top-left) |
| color2 | string | #3a3a3a | Secondary gradient color (bottom-right) |
| tint | real | 0.0 | Screen tint opacity |
| borderX | int | 6 | Side border width |
| borderY | int | 3 | Top/bottom border width |
| radius | int | 12 | Corner radius |
| visible | bool | true | Overlay visibility |

## Color Presets

Each preset includes a hue-shifted gradient pair for visual depth:
- Colors go from darker/saturated (top-left) to brighter (bottom-right)
