# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Goal

Rebuild the lf config so it behaves like the user's ranger setup, as closely as possible, while using modern lf features. The target is **ranger's default keymap plus the user's ranger customizations**, not a generic lf config.

## Layout

- This is the `lf` package of the `neodots` dotfiles repo. `.dots` symlinks individual files into `~/.config/lf/`, so edits here are live. New files (e.g. `previewer`, `cleaner`) need their own `.dots` entry.
- `CLAUDE.md` has `dest = "none"`, so it is never deployed.
- The ranger reference config lives at `../ranger/ranger/` (`rc.conf`, `rifle.conf`, `scope.sh`, `commands.py`).

## Ranger behavior to replicate

- `rc.conf` changes very little from ranger defaults: kitty image previews (`preview_images_method kitty`), `scope.sh` previews, `gz` → `z`, `yc` → `clipcopy`, `<C-t>` → `~/Development/bin/sync-dir %d`.
- `rifle.conf` handles opening files: `$DATA_VIEWER` (csv/tsv), `$IMAGE_VIEWER`, `$MEDIA_PLAYER`, `$AUDIO_PLAYER`, libreoffice (office docs), zathura (pdf), `$EDITOR` (code/config/text), and `~/Development/bin/multiplexer` for executables.
- `commands.py`:
  - `z <query>` cds to the output of `nav-engine.sh`. It looks for the script at `$SYSDIR/shared/`, `$BASHRC/system/shared/`, `~/.config/lushrc/system/shared/`, then `$PATH`, and shows an error notification when nothing matches.
  - `clipcopy` pipes `copy\nfile://<uri>...` to `wl-copy -t x-special/gnome-copied-files`, so files can be pasted in GTK file managers.

## Known problems in the current setup

- `set previewer`/`set cleaner` point to `~/.config/lf/previewer` and `~/.config/lf/cleaner`, which don't exist, so previews are broken.
- The lf `z` command calls `$LIBDIR/nav-engine.sh`, which doesn't exist (the real path is `~/.config/lushrc/system/shared/nav-engine.sh`), and `2>/dev/null` hides the error.
- `trash` runs `mv` into `~/.trash`, which silently overwrites files with the same name.
- `~/Development/bin/sync-dir` and `~/Development/bin/multiplexer` (referenced by ranger) don't exist.
- `open` runs `setsid $OPENER`; rifle's per-type routing hasn't been ported.

## Environment

- NixOS, Hyprland (Wayland), kitty terminal. Installed lf version: r38 (`lf -version`); nixpkgs also has 38. The latest upstream release is r42.
- Installed: `kitten`, `bat`, `zoxide`, `fzf`, `wl-copy`, imagemagick. Not installed: `chafa`, `pistol`, `ctpv`, `trash-cli`. Packages are managed in `~/.config/luxos/` (NixOS config).

## Research: lf references

- [wiki/Ranger](https://github.com/gokcehan/lf/wiki/Ranger) is the official guide for moving from ranger. It covers:
  - A `scope.sh` wrapper used as the previewer (append `|| true` so the output gets cached).
  - `rifle` as the opener: `cmd open $set -f; rifle -p 0 $fx`.
  - Other settings: `set period 1`, `dircounts`, `scrolloff 10`, `menuheaderfmt "\033[1;4m"`, a ruler showing free space and scroll %, and porting ranger's colors.
- [wiki/Tips](https://github.com/gokcehan/lf/wiki/Tips) has recipes for ranger features:
  - Rename variants `I`/`A`/`c`/`C` and bulk rename in `$EDITOR`.
  - Prompt-based mkdir/touch.
  - Adding to the copy/cut buffer, and clearing the selection after paste.
  - Following symlinks, and yanking a path to the clipboard.
  - Per-directory `setlocal`, which gives ranger-style persistent sort per folder.
  - Toggling preview while keeping the column ratios.
  - cd on exit, and CoW/backup copies.
- [wiki/Previews](https://github.com/gokcehan/lf/wiki/Previews) explains how previewers work:
  - The previewer gets `$1` path, `$2` width, `$3` height, `$4` x, `$5` y, `$6` mode (`preview`/`preload`).
  - Exit code 0 means lf caches the output. Non-zero means lf calls the previewer again next time; kitty images need this.
  - Kitty image draw: `kitten icat --stdin no --transfer-mode memory --place "${w}x${h}@${x}x${y}" "$1" </dev/null >/dev/tty`, then exit 1.
  - Kitty cleaner: `kitten icat --clear --stdin no --transfer-mode memory </dev/null >/dev/tty`.
  - ctpv/stpv break on newer lf, so don't use them.
- [wiki/Integrations](https://github.com/gokcehan/lf/wiki/Integrations) has snippets for zoxide, fzf, ripgrep+fzf, trash-cli / `gio trash`, vidir, git, ouch/atool and archivemount.
- [doc.md](https://github.com/gokcehan/lf/blob/master/doc.md) is the full reference for options, commands and hooks.
- Also on the wiki: [Ruler](https://github.com/gokcehan/lf/wiki/Ruler), [Colors-and-Icons](https://github.com/gokcehan/lf/wiki/Colors-and-Icons), [Tutorial](https://github.com/gokcehan/lf/wiki/Tutorial), [FAQ](https://github.com/gokcehan/lf/wiki/FAQ).

### Modern lf features worth using

- `visual` mode (`V`), which gives ranger-style range selection. Added in r36.
- `watch`, which refreshes listings using filesystem notifications. Added in r33.
- Hooks: `on-init`, `pre-cd`, `on-cd`, `on-select`, `on-load`, `on-redraw`, `on-focus-gained`/`on-focus-lost`, `on-quit`.
- `addcustominfo`, which adds per-file info columns (e.g. git status).
- Requires r39+: `borderstyle` (rounded borders), `mergeindicators`, `rulerfile` (replaces the deprecated `rulerfmt`/`statfmt`). Using these needs an lf upgrade beyond nixpkgs 38.

## lfrc gotchas

- Commands that run multiple statements must use the multiline `:{{ ... }}` block form. Writing them inline breaks parsing.
- `%` commands run in the status bar without redrawing the UI. `$` commands take over the screen. `!` commands wait for a keypress afterwards. `&` commands run asynchronously.
- `set shellopts '-eu'` and `set ifs "\n"` are set, so `$fx` splits on newlines. Use `set -f` in commands that use `$fx` unquoted.

## Testing

- No build step. Validate a change by launching `lf` and running `:source ~/.config/lf/lfrc` (or restart lf).
- Run `lf -doc` for the docs that match the installed version.
- Previewer scripts can be tested directly: `~/.config/lf/previewer <file> 80 40 0 0 preview`.
