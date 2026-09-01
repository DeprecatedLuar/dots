# kanata config

Layout: `profiles/<name>/kanata.kbd`. Active profile is whatever
`~/.config/kanata/kanata.kbd` symlinks to (currently `wm+vimsanity`), set by
hand — `.profiled` just records the filename, it does not drive the symlink.

Runs via: `hotline kanata --port 5828 -c ~/.config/kanata/kanata.kbd`
(`~/.config/lushrc/bin/hotline`), a plain background process — not a
systemd unit.

**Editing the config does NOT take effect until kanata is restarted.**
Kanata has no file-watch/live-reload in the version installed here
(v1.9.0). Always validate before restarting:

```
kanata --check -c ~/.config/kanata/kanata.kbd
```

then kill the two processes (`hotline` wrapper + `kanata` itself, shown by
`ps aux | grep kanata`) and relaunch the same command in background. A
failed restart leaves the keyboard unmapped, so always `--check` first.

## `defoverrides` — what it actually is

`defoverrides` rewrites currently-**active output keycodes** into a
different output chord, "irrespective of what actions generated those
keys" (per upstream docs). It only fires if the input side is actually
present as a real emitted keycode at the moment of the match.

Concretely: it **cannot** intercept a tap-hold or layer-switch action,
because taps like `(layer-switch vim-normal)` never emit a keycode at all —
there's nothing for the override to see or replace. The existing
`(lctl caps) (caps)` / `(rctl caps) (caps)` entries only matter for the
literal `caps` keycode that the `meta-layer`'s last key already emits
(kanata.kbd:71) while a ctrl homerow-mod is bleeding through — they strip
the stray ctrl modifier, they don't create a Caps Lock trigger out of
nothing.

**Lesson (2026-08-07):** don't reach for `defoverrides` to make a
tap-hold/layer key conditionally do something else. Use `switch` instead
(see below).

## `switch` — conditional key actions

Use `(switch $check $action $post ...)` when a key's action should depend
on what else is currently held. Two check styles matter here and behave
very differently:

- `(input real lsft)` — checks the **physical** `defsrc` key only. Misses
  any shift produced by a homerow-mod tap-hold (e.g. `d^`/`k^` holding
  down to emit virtual `lsft`).
- bare `lsft` / `rsft` as a logic-check item — checks the **currently
  active output** keycode, regardless of what produced it. This is what
  you want if the config uses homerow mods, since it also catches
  `d^`/`k^` held.

## Caps key: `@wm-cap-or-caps` (wm+vimsanity profile only)

The physical Caps key normally runs `@wm-cap`
(`tap-hold-press`: tap → `(layer-switch vim-normal)`, hold → meta-layer).
Requirement (2026-08-07): holding Shift (physical *or* homerow-mod `d`/`k`)
and then tapping Caps should send a real Caps Lock instead of switching
layers.

Implemented as (kanata.kbd:36-40):

```
wm-cap-or-caps (switch
  (lsft rsft) caps break
  ((not lsft rsft)) @wm-cap break)
```

Bound in `deflayer default` in place of `@wm-cap`. Bare `lsft`/`rsft`
checks are required here specifically because of the homerow-mod case
above — `(input real lsft)` was tried first and silently failed to detect
`d`/`k`-held shift.

## Related decisions

- Physical Shift/Ctrl were briefly `XX` (disabled) in `deflayer default`
  to force homerow-mod usage. Restored to `lsft`/`rsft`/`lctl`/`rctl`
  (2026-08-07) — user wants physical modifiers usable alongside homerow
  mods, not instead of them.
