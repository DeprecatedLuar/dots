# kanata config

Layout: `profiles/<name>/kanata.kbd`. Active profile is whatever
`~/.config/kanata/kanata.kbd` symlinks to (`wm+vimsanity`), set by
hand — `.profiled` just records the filename, it does not drive the symlink.

The `wm+vimsanity` profile includes `vimsanity.kbd` from the **repo root**
(`~/.config/kanata/vimsanity.kbd`). `profiles/wm+vimsanity/vimsanity.kbd` is
not loaded. Confirm what gets read with:

```
strace -f -e trace=openat kanata --check -c ~/.config/kanata/kanata.kbd 2>&1 | grep '\.kbd'
```

Runs as the systemd user unit `kanata.service`
(`kanata --port 5828`, no `-c`, so it loads the default
`~/.config/kanata/kanata.kbd`).

**Editing the config does NOT take effect until kanata is restarted.**
Kanata has no file-watch/live-reload in the version installed here
(v1.9.0). Always validate before restarting:

```
kanata --check -c ~/.config/kanata/kanata.kbd
systemctl --user restart kanata.service
```

A failed restart leaves the keyboard unmapped, so always `--check` first.

## `defoverrides` — what it actually is

`defoverrides` rewrites currently-**active output keycodes** into a
different output chord, "irrespective of what actions generated those
keys" (per upstream docs). It only fires if the input side is actually
present as a real emitted keycode at the moment of the match.

It **cannot** intercept a tap-hold or layer-switch action, because taps
like `(layer-switch vim-normal)` never emit a keycode at all — there's
nothing for the override to see or replace. The `(lctl caps) (caps)` /
`(rctl caps) (caps)` entries only matter for the literal `caps` keycode
that the `meta-layer`'s last key emits while a ctrl homerow-mod is
bleeding through — they strip the stray ctrl modifier, they don't create
a Caps Lock trigger out of nothing.

To make a tap-hold/layer key conditionally do something else, use
`switch`, not `defoverrides`.

## `switch` — conditional key actions

Use `(switch $check $action $post ...)` when a key's action should depend
on what else is currently held. Two check styles behave very differently:

- `(input real lsft)` — checks the **physical** `defsrc` key only. Misses
  any shift produced by a homerow-mod tap-hold (e.g. `d^`/`k^` holding
  down to emit virtual `lsft`).
- bare `lsft` / `rsft` as a logic-check item — checks the **currently
  active output** keycode, regardless of what produced it. Use this with
  homerow mods, since it also catches `d^`/`k^` held.

## Caps key: `@wm-cap-or-caps` (wm+vimsanity profile only)

The physical Caps key normally runs `@wm-cap`
(`tap-hold-press`: tap → `(layer-switch vim-normal)`, hold → meta-layer).
Holding Shift (physical *or* homerow-mod `d`/`k`) and then tapping Caps
sends a real Caps Lock instead of switching layers. Holding Ctrl (physical
or homerow-mod `f`/`j`) and tapping Caps switches to the `escape` layer:

```
wm-cap-or-caps (switch
  (lsft rsft) caps break
  (lctl rctl) (layer-switch escape) break
  ((not lsft rsft lctl rctl)) @wm-cap break)
```

Bound in `deflayer default` in place of `@wm-cap`. Bare `lsft`/`rsft`/
`lctl`/`rctl` checks are required to detect homerow-mod modifiers. The
escape action is inline because `@escaps` is declared later in
`vimsanity.kbd` and aliases must be declared before use.

In the `escape` layer, Ctrl+Caps returns to `default`; a plain Caps tap
sends Esc.

## `@cap-hold` — profile-provided Caps hold action

`vimsanity.kbd` never defines what holding Caps does; every vimsanity
Caps binding (`cap`, `pac`, `cap-esc`, `vmeta`) uses `@cap-hold`. Any
profile including `vimsanity.kbd` must declare `cap-hold` in its
`defalias` **before** the `include`, or `--check` fails. `wm+vimsanity`
sets it to `(multi lmet (layer-while-held meta-layer))`; a profile
without a meta layer would use plain `lmet`. This keeps vimsanity
unaware of `meta-layer`.

## Modifiers

Physical Shift/Ctrl stay mapped (`lsft`/`rsft`/`lctl`/`rctl`) in
`deflayer default` — they are meant to be usable alongside homerow mods,
not replaced by them.
