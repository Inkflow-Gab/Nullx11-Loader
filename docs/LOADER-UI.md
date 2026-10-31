# Main loader / bounded Scripts browser

The main workspace keeps its dark Nullx11 skin, static draggable prism dock,
original player tools, Design Studio and independent game-window handoff. This
update changes actual native GUI construction; it is not an HTML mockup.

## Finding a script without a catalog-length scroll

Use the **Scripts** sidebar tab or **Workspace → Browse pinned / recent scripts**.

- Search by game, feature, creator, collection, category or filename. Multiple
  words are literal AND matches; search text is never a Lua pattern or code.
- **All / This game / Pinned / Recent** are instant views. This game includes
  explicit matching place IDs, matching universe IDs and universal tools. It does
  **not** guess that an unknown module-signature port is compatible. Its details
  and standalone preflight still check compatibility.
- **Filters** expands one compact row. Tap category/collection to cycle available
  values; sort cycles Name A–Z, Collection and Recently viewed. **Clear** resets
  the query, view, category, collection, sort and page, not your pins/history.
- Rows show a name, description, collection/compatibility badge, Pin and Details.
  Narrow portrait stacks the actions to keep more width for names. Details still
  opens the existing independent launch/confirmation window. Browsing, pinning,
  filtering and paging never fetch or execute scripts, require game modules, or
  teleport the player. Refresh explicitly requests the repository manifest.
- **Prev / Next** and the editable page number reach every matching entry. The
  footer reports total pages and matching scripts. Resizing preserves the range
  around the first visible result and clamps pages when results disappear.
- Only **eight row slots** are constructed, with **one to eight visible rows**
  determined by the available viewport. Filtering, refreshing and paging reuse
  the slots and callbacks. The canvas does not grow with the catalog.
- Very short landscape hides the secondary toolbar and reduces row detail so
  search, a result, and page navigation remain reachable. Rotate to a taller
  layout to change advanced filters. Long names/descriptions truncate; the full
  information remains in Details.
- Pins and **recently viewed details** are session-only. They are not proof that a
  script ran, and are not saved to disk. Refresh prunes history for removed IDs.

**Open Scripts library** still opens the separate classic Scripts window as an
action, not an on/off toggle. That window now creates only **one to four compact
rows** per page, with search, Prev/Next and result counts. It may still need a
small local scroll on extremely short screens, but never renders the full catalog
as a long stack. Its original place filtering and confirmation gates remain.

## Centering and restoration

Classic loader, native workspace and execution overlay explicitly use full
viewport coordinates (`IgnoreGuiInset = true`, `ScreenInsets.None`). This removes
the topbar safe-inset mismatch between layers. The execution card anchors at
`(0.5, 0.5)` with no pixel center offsets; its size remains constrained for mobile.

The top-anchored main window centers its complete panel including shadow once
both viewport dimensions are available. A hidden resize/rotation now refreshes
the **restore target**, instead of reopening at the old height or saving the dock
animation's destination. Explicitly dragged windows retain their saved position
and are clamped back into view. **Workspace → Center loader window** returns to
automatic centering without changing game sessions or other tool windows.

## Lower UI work

**Session tools → UI performance profile**:

| Profile | Behavior |
| --- | --- |
| Auto (default) | Uses the existing smoothed client-frame estimate. Below 35 FPS for two consecutive seconds lowers UI work; above 50 FPS for eight consecutive seconds recovers it. A single long stall is insufficient. Mid-band samples reset the dwell timer. |
| Balanced | Keeps ordinary UI motion; never automatically changes it due to FPS. |
| Low power | Instant one-way UI transitions, no spring impulses, title waves, ripple/bump/shake effects or count-up animations; decorative loop groups/particles paused. |

Recovery respects hidden groups and the user's Reduced motion / particle choices;
it does not blindly resume every animation. Spring completions still run so
controls do not get stuck. The session readout reports the current profile and
motion state, and is only updated while the Workspace page is visible.

The finite startup gravity well now uses **24 precreated particles**, or **16
on touch-enabled clients**, rather than 48. Decorative property writes run at
most about 30 times per second; the 1.25-second contraction and 0.7-second reveal
still use elapsed time. Skip, waiting for real game readiness, reduced-motion
bypass, rerun and early-unload cleanup remain. The static restore icon does not
animate. Disabling startup/reduced motion before execution is still the way to
bypass the initial effect entirely; changing the profile later does not replay it.

This is a **UI work budget**, not a graphics/physics hack, world optimization,
automation throttle, or FPS guarantee. It does not change ESP/aim behavior,
launched game workers or the Auto Player transport. Games keep their independent
lifetimes after loader unload.

## Verification boundary

The automated suite compiles the generated main and all fifteen bundles and runs
the actual browser/model, fitting/restore code, budget policy/application,
loading layers, startup and existing game/MIDI integration contracts with API
doubles. It includes a 504-entry allocation-bound stress fixture; the production
manifest remains capped at 64 entries. This does not render Roblox or run Delta.
Native layout, notch/cutout behavior, touch targets and device frame times still
need the [manual checklist](../diagnostics/GAME-PORTS.md).
