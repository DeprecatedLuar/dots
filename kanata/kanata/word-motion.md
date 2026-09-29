# WORD motion (vim `W`) via primary selection

Status: prototype validated manually (browser, VS Code). Not wired into kanata.

## Idea

`Ctrl+Right` uses each app's own word boundaries (stops at `.`, `/`, `-`).
Vim `W` is whitespace-delimited. Emulate it by reading the text after the
cursor and stepping with plain arrows:

1. `Shift+End` — select cursor → end of line
2. `wl-paste -p -n` — read the primary selection
3. `N = length of ^\S*\s*` — current WORD + trailing whitespace
4. `Left` — collapse selection back to its start
5. `Right` × N

`B`/`E` follow the same pattern (`Shift+Home`, different offset).

## Findings

- Wayland primary-selection protocol does not restrict to mouse; each app
  decides. Keyboard selection updates primary in browsers and VS Code.
- **micro** only writes primary on mouse release / double / triple click
  (`internal/action/actions.go`, `useprimary` only toggles it on/off).
  Keyboard selection never reaches primary. A micro Lua plugin implementing
  `W` directly is the better route there.
- Terminals have no text-cursor selection, so this does not work in them.
- Firefox bug 1704043: HTML inputs may not populate primary on Wayland.
- Watch whether an app updates primary:
  `wl-paste -p --watch sh -c 'echo "[$(wl-paste -p)]"'`

## Known gaps

- Last WORD on a line: stops at EOL instead of moving to the next line.
- Cursor already at EOL: nothing selected, primary holds stale content.
- Soft-wrapped text: `End` goes to the visual line end.
- `wc -m` counts codepoints; multi-codepoint emoji can be off.
- Every motion overwrites the primary selection.

## Prototype script (wtype-driven)

```bash
#!/usr/bin/env bash
set -euo pipefail

FOCUS_DELAY=3
SELECTION_DELAY=0.1

select_to_eol() { wtype -M shift -k End -m shift; }
read_selection() { wl-paste -p -n; }
word_offset() { grep -oP '^\S*\s*' <<<"$1" | tr -d '\n' | wc -m; }

move_right() {
    local args=(-k Left)
    for ((i = 0; i < $1; i++)); do args+=(-k Right); done
    wtype "${args[@]}"
}

echo "focus the target app within ${FOCUS_DELAY}s..."
sleep "$FOCUS_DELAY"

select_to_eol
sleep "$SELECTION_DELAY"
text=$(read_selection) || { echo "error: primary selection empty or unreadable" >&2; exit 1; }
n=$(word_offset "$text")
echo "selection: [$text]"
echo "offset: $n"
move_right "$n"
```

## Kanata integration plan

Goal: no `wtype`/`ydotool`; only `wl-paste`.

- `cmd-output-keys` runs a binary and types its stdout as macro syntax.
  Script prints `left rght rght ...`; kanata sends the keys.
- Kanata does the `S-end`, script only reads primary and prints keys.
- Requires the cmd-enabled build: the installed `kanata` (nixpkgs, 1.9.0)
  rejects `cmd` in `--check`. Switch to `pkgs.kanata-with-cmd` in luxos and
  add `danger-enable-cmd yes` to `defcfg`.
- `cmd` runs the binary directly, not via a shell.
- Blocks kanata until the command finishes — script needs a timeout, or a
  hang freezes the keyboard.
- Unverified: whether `cmd-output-keys` is allowed inside `macro` (needed to
  sequence `S-end` → delay → script). Check with `kanata --check`.

Alternative without the cmd build: kanata TCP server (already running,
`--port 5828`) accepts `{"ActOnFakeKey":{"name":"...","action":"Tap"}}` for
`defvirtualkeys`; bash can send it via `/dev/tcp`. Needs something else
(e.g. a Hyprland bind) to launch the script.

Reference: https://github.com/jtroo/kanata/blob/main/docs/config.adoc
(sections `cmd`, `cmd-output-keys`, `danger-enable-cmd`, TCP server).
