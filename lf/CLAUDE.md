# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Goal

Rebuild the lf config so it behaves like the user's ranger setup, as closely as possible, while using modern lf features. The target is **ranger's default keymap and muscle memory plus the user's ranger customizations**, not a generic lf config.

## Layout

This is the `lf` package of the `neodots` dotfiles repo. `.dots` symlinks each entry into `~/.config/lf/`, so edits here are live. A new top-level file needs its own `.dots` entry; `CLAUDE.md` has `dest = "none"`.

- `lfrc`: `set` options only, then `source`s `cmds.lf` and `keybinds.lf`. `source` needs absolute or `~` paths.
- `cmds.lf`: custom `cmd` definitions.
- `keybinds.lf`: all `map` bindings.
- `scripts/`: standalone executables that lf calls and that can be tested from the shell:
  - `open` (the rifle replacement)
  - `previewer` (kitty `icat` for images, `bat` for text, `file` for anything else)
  - `cleaner` (clears kitty images)

Ranger reference config: `../ranger/ranger/` (`rc.conf`, `rifle.conf`, `scope.sh`, `commands.py`).

## Decisions made

- Drop `scope.sh` and `rifle`. Previews come from `scripts/previewer`, and file opening from `scripts/open` (to be grown into rifle-style per-type routing).
- `dD` prefills `:trash`. Enter shows `trash N item(s)? [y/N]`, which is answered with a single key. `gio trash` uses the FreeDesktop trash.
- `dX` prefills `:delete` (permanent delete, using lf's built-in single-key confirm).
- `r` prefills `:open-with `, which runs a program in the foreground on `$fx`. Freezing lf while a GUI app runs is intended; it matches ranger.
- `gz`/`z` uses `$SYSDIR/shared/nav-engine.sh` and reports "no match" with `echoerr`.
- `set watch true` enables live filesystem refresh.
- The `statfmt` line was removed; lf's default ruler already shows the same fields.

## Ranger behavior still to port

- `rifle.conf` routing:
  - `$DATA_VIEWER` for csv/tsv
  - `$IMAGE_VIEWER`, `$MEDIA_PLAYER`, `$AUDIO_PLAYER`
  - libreoffice for office docs, zathura for pdf
  - `$EDITOR` for code/config/text
  - `~/Development/bin/multiplexer` for executables (that script doesn't exist)
- `scope.sh` previews beyond images and text: archives, pdf, video thumbnails, etc.
- `yc` → `clipcopy`: pipe `copy\nfile://<uri>...` to `wl-copy -t x-special/gnome-copied-files` so files can be pasted in GTK file managers.
- `<C-t>` → `~/Development/bin/sync-dir %d` (that script doesn't exist).
- Ranger extras from wiki/Tips: rename variants, bulk rename, yank path, `setlocal` per-directory sort.

## Environment

- NixOS, Hyprland (Wayland), kitty terminal. lf **r42**, from nixpkgs unstable. Packages are managed in `~/.config/luxos/`.
- Installed: `kitten`, `bat`, `zoxide`, `fzf`, `wl-copy`, `gio`, imagemagick. Not installed: `chafa`, `pistol`, `ctpv`, `trash-cli`.
- `$SYSDIR` (`~/.config/lushrc/system`) is exported by the lushrc shell framework.

## lf gotchas (verified on r42)

- **Key names are case-sensitive**: `<c-h>`, not `<C-h>`. A wrong case silently doesn't bind.
- **Shell command modes:**
  - `%` pipes stdin/stdout to the status line. Input is line-buffered, so `read` needs Enter, and keys pressed while a `%` command is still running go to its stdin.
  - `$` takes over the screen.
  - `!` waits for a keypress after the command finishes.
  - `&` is async and doesn't take keyboard input.
- **Single-key confirm pattern** (used by `trash`):
  1. An `&` command shows the prompt with `lf -remote "send $id echomsg ..."`.
  2. It then runs `lf -remote "send $id push <f-50>"`. `<f-50>` is a virtual prefix key, so lf now waits for the next key.
  3. `map <f-50>y <action>` and `map <f-50>n ...` handle the answer. Any other key produces an `unknown mapping` error, which works as a cancel.
  - This must use `&`, not `%`, otherwise the pushed keys are swallowed by the running command.
- Multi-statement commands need the multiline `{{ ... }}` block form; inline versions break parsing.
- `set shellopts '-eu'` and `set ifs "\n"` are set: `$fx` splits on newlines. Use `set -f` in commands that use `$fx` unquoted.
- `statfmt`/`rulerfmt` are deprecated. Customize the ruler with `rulerfile`, starting from upstream `etc/ruler.default`.
- `gio trash` refuses on system mounts such as `/tmp` (tmpfs). Use `dX` there.
- `-command` runs before the config is loaded, so user-defined commands aren't available yet.

## Testing

- `lf -doc` has the docs for the installed version.
- Scripts can be run directly, e.g. `scripts/previewer <file> 80 40 0 0 preview`.
- To run lf headlessly and drive it:
  - Start it under `script` with `-config <repo>/lfrc -log <file> -command '$echo $id > <idfile>'`.
  - Send commands with `lf -remote "send <id> ..."`, then check the log (`recv:`, `command:`, `error:` lines).
- **Always send to a specific `<id>`. Never use `lf -remote "send ..."` without one: it broadcasts to all of the user's running lf instances.**
- `push` from inside a pushed binding queues after the keys that are already pending. Send multi-step key flows as separate `push` calls with short sleeps in between.

## Research: lf references

- [wiki/Ranger](https://github.com/gokcehan/lf/wiki/Ranger): the official transition guide (scope.sh wrapper, rifle opener, trash, `period`, `dircounts`, `scrolloff`, ruler, colors).
- [wiki/Tips](https://github.com/gokcehan/lf/wiki/Tips): recipes for ranger features:
  - rename variants `I`/`A`/`c`/`C`, bulk rename
  - mkdir/touch prompts
  - adding to the copy/cut buffer, clearing the selection after paste
  - following symlinks, yanking a path
  - per-directory `setlocal`
  - toggling preview, cd on exit
- [wiki/Previews](https://github.com/gokcehan/lf/wiki/Previews): the previewer args (`$1` path, `$2` width, `$3` height, `$4` x, `$5` y, `$6` mode) and exit codes (0 = lf caches the output; non-zero = lf calls the previewer again, which kitty images need). ctpv/stpv break on newer lf.
- [wiki/Integrations](https://github.com/gokcehan/lf/wiki/Integrations): zoxide, fzf, ripgrep+fzf, trash-cli/gio, vidir, git, ouch/atool, archivemount.
- [doc.md](https://github.com/gokcehan/lf/blob/master/doc.md): the full reference. Also on the wiki: [Ruler](https://github.com/gokcehan/lf/wiki/Ruler), [Colors-and-Icons](https://github.com/gokcehan/lf/wiki/Colors-and-Icons).
- Modern features not used yet:
  - `visual` mode (`V`)
  - hooks (`on-cd`, `on-select`, `on-load`, `on-focus-gained`, `pre-cd`, …)
  - `addcustominfo` (e.g. git status)
  - `borderstyle`, `mergeindicators`, `rulerfile`
