# hyprmon — diagonal slot support (design notes)

Status: **design in progress, not implemented.** Two open questions remain (§6).
Date: 2026-08-19. Hyprland 0.52.1.

## 1. Goal

Extend `hyprmon`'s slot model from 5 positions (`center`, `left`, `right`, `up`,
`down`) to a full 3x3 grid by adding the four diagonals:

```
northwest   up     northeast
   left    center     right
southwest  down    southeast
```

Aliases to accept: `northwest`/`upperleft`/`topleft`/`nw`, and so on for the
other three.

## 2. What Hyprland actually supports

From the wiki (`content/Configuring/Basics/Monitors.md`):

- `position` accepts explicit `XxY` in a virtual layout. Negative values are
  allowed. Y is inverted — negative Y is *higher*.
- Special values are **only**: `auto`, `auto-{right,left,up,down}`, and
  `auto-center-{right,left,up,down}`.
- **There are no diagonal auto keywords.** Diagonals must be explicit pixels.
- Position is computed in *scaled/transformed* resolution, not raw mode
  resolution.
- Docs claim overlapping monitors produce a warning. **This is misleading — see
  §3.**

Note: the wiki now documents Lua syntax (hyprlang deprecated in 0.55+). We are
on 0.52.1 and `hyprctl keyword monitor NAME,mode,pos,scale` remains correct.

## 3. Empirical findings

All tested live on `eDP-1` (1920x1080 @1.0) + `HDMI-A-1` (1920x1080, scale
varied).

| Test | Command | Result |
|---|---|---|
| Diagonal explicit coords | `HDMI-A-1,preferred,1920x-1080,1` | ✅ landed exactly; no warning; eDP unmoved |
| Corner-only adjacency | same as above | ✅ allowed; Hyprland does not require edge contact |
| Deliberate overlap | `HDMI-A-1,preferred,960x0,1` | ⚠️ **returned `ok`, silently moved eDP-1 from `0x0` to `2880x0`** |
| Deliberate gap | `HDMI-A-1,preferred,3000x0,1` | ⚠️ returned `ok`, silently moved eDP-1 to `4920x0` |
| Mismatched scale, batched | `eDP-1,…,0x0,1` + `HDMI-A-1,…,1920x-720,1.5` | ✅ both exact, no reflow |

### 3.1 The critical finding

**Hyprland does not warn-and-refuse on overlap. It silently relocates other
monitors** and still returns `ok`. A math bug in hyprmon will therefore not
surface as an error — it will surface as a silently rearranged desktop.

Two consequences, both settled:

1. Non-overlap must be guaranteed by hyprmon's own math or checked before push.
2. `app_apply` must **read back** `hyprctl -j monitors` after pushing and verify
   actual `x`/`y` match intent. `ok` is not evidence.

## 4. Validated math

Logical size (the units positions are expressed in):

```
logical_w = width / scale
logical_h = height / scale
# if transform is odd (1,3,5,7), swap logical_w and logical_h
```

Confirmed at scale 1.5: raw 1920x1080 → logical 1280x720, and a position of
`1920x-720` landed exactly.

Flush grid formulas, with center at `(0,0)` and size `Cw x Ch`, each slot
monitor sized `Sw x Sh`:

```
NW: (-Sw, -Sh)     N: (0,  -Sh)     NE: (Cw, -Sh)
 W: (-Sw,   0)     C: (0,    0)      E: (Cw,   0)
SW: (-Sw,  Ch)     S: (0,   Ch)     SE: (Cw,  Ch)
```

**Flush anchoring is provably non-overlapping for any monitor sizes.** Every
pair separates on at least one axis by construction: e.g. NW is entirely in
`y < 0` while W is entirely in `y >= 0`; NW is entirely in `x < 0` while N is
entirely in `x >= 0`. No collision checking required.

## 5. Decisions settled

- **Drop `auto-*` entirely once diagonals exist.** Mixing hyprmon-computed
  explicit coords with compositor-computed `auto-*` means two independent
  placers that don't coordinate, which produces overlap → silent reflow.
  One brain does the placement. `domain_desired_rule`
  (`scripts/bin/hyprmon:229-248`) becomes the single source of position math.
- **Apply must verify by read-back**, per §3.1.
- **`northeast` is a grid cell, not "right, raised."** Its vertical band must
  live above `y=0`, because `y >= 0` in the right column belongs to `right`.
  A center-aligned diagonal was tested and looks good *only while `right` is
  empty* — it squats in `right`'s territory. Same logic for the other three.
- **Geometry source.** `hyprctl -j monitors` gives live geometry for anything
  currently on. The gap is a monitor that is currently *disabled* and being
  enabled in the same batch — its resolution is unknown because the default mode
  is `preferred` and only Hyprland resolves what that means. Proposed handling
  (not yet ratified): cache last-known logical size per monitor in
  `monitors.json` on every apply; if a monitor has no cached size and is not
  currently on, do a two-step push for that monitor only (enable → re-read
  geometry → push position). Position-only changes do not trigger a modeset, so
  this costs an extra IPC round-trip but no layer-shell teardown.

## 6. Open questions

### Q1 — static grid vs adaptive grid

- **Static**: a slot's position depends only on `center` and its own size. `NE`
  is always `(Cw, -Sh)` whether or not `right`/`up` exist. Predictable,
  declarative, trivially safe. Cost: in a 2-monitor setup the diagonal touches
  only at a single corner point — looks like it's floating.
- **Adaptive**: a diagonal relaxes toward center when the neighbouring cardinal
  cell is empty (`right` empty → `NE` drops to vertical-center). Better
  ergonomics in the common 2-3 monitor case. Cost: plugging in an unrelated
  monitor silently moves an existing one, and CLAUDE.md says declarative over
  magic.
- **Third option**: static by default, plus an explicit `hyprmon compact`
  command that relaxes empty-cell gaps on demand.

User's position so far: flush "was fine"; center-aligned "makes more sense AS
LONG AS RIGHT IS ABSENT" — which is the observation that motivated the
static/adaptive split. Not yet resolved.

### Q2 — diagonal alignment within its column

When `NW` is narrower than the `left` monitor, does `NW` align to the left
monitor's **left edge** (sharing the column), or flush against **center's left
edge** (hanging over the outer end of `left`)? The flush formulas in §4 assume
the latter. User indicated "if there was a left monitor it should be above
left", which suggests the former — needs confirming.

Note that answering Q2 with "align to the left monitor's edge" makes a slot's
position depend on a *sibling* slot's size, which breaks the pure
`f(center, self)` function and weakens the §4 safety proof.

## 7. Cursor traversal

Corner-only contact (flush diagonal, single shared point) was tested live and
reported as working — the pointer was able to reach the diagonal monitor. This
was a soft confirmation, not a rigorous test; worth re-verifying before
committing to static/flush, since it is the main ergonomic argument against it.

## 8. Code touchpoints

All in `scripts/bin/hyprmon`:

- `SLOTS` constant (line 28) — extend with the four diagonals.
- `domain_normalize_direction` (line ~152) — add diagonal names and aliases.
- `domain_desired_rule` (line ~229) — replace `auto-$slot` with computed
  explicit coordinates; this is the core change.
- `app_apply` (line ~256) — add read-back verification.
- `store_ensure_initialized` (line ~97) and `store_read` backfill (line ~118) —
  add the four diagonal slot keys plus a geometry cache.
- Help text (lines ~703, ~717) and the CLI dispatch case (line ~779).

The existing state file at `$XDG_DATA_HOME/hypr/monitors.json` already carries
`slots`, `scales`, `resolutions`, `disabled`, `mirrors`, `applied`. Adding
diagonal keys is backward-compatible via the existing `//= {}` backfill.

## 9. Useful commands for resuming

```bash
# inspect live geometry incl. logical size
hyprctl -j monitors all | jq -c '.[] | {name,disabled,width,height,x,y,scale,transform,
  logical_w:(.width/.scale|round), logical_h:(.height/.scale|round)}'

# current hyprmon state
cat "${XDG_DATA_HOME:-$HOME/.local/share}/hypr/monitors.json"

# restore the baseline used during these tests
hyprctl --batch "keyword monitor eDP-1,preferred,0x0,1 ; keyword monitor HDMI-A-1,preferred,-1920x0,1"
```

Baseline during testing: `eDP-1` center @ `0x0` scale 1; `HDMI-A-1` in `left`
slot @ `-1920x0` scale 1. Restored at end of session.
