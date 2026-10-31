# Main loader / bounded Scripts browser

The main workspace keeps its dark Nullx11 skin, static draggable prism dock,
original player tools, Design Studio and independent game-window handoff. This
update changes actual native GUI construction; it is not an HTML mockup.

## Clean dark visual direction

The chosen design is neutral charcoal with restrained blue accents, modern native
Gotham text, thinner outlines and less raised-block/brick decoration. The default
workspace is 960×640 before viewport fitting, with a 180-pixel desktop sidebar.
It still keeps the static prism, optional glitch/transport effects, themes and
independent game/tool windows. This is native GUI construction, not an HTML demo.

## Card-based script selection

Use **Workspace → Open Scripts library**, the **Scripts** sidebar tab, or
**Saved & recently viewed scripts**. Main navigation now opens this card browser,
not the compact legacy list that was difficult to use.

- Click a game card or **View script** to inspect the title, full description,
  compatibility and owner/provenance **inside the browser**. Back returns to the
  same browse/filter/page context. **Continue to launch** explicitly opens the
  existing separate launch/confirmation window; a card tap itself never executes.
- Wide layouts use two columns; portrait uses full-width cards. Pagination keeps
  the catalog bounded without a long stack. The eight card slots and callbacks
  are reused, with one to eight visible cards according to viewport space.
- Names omit the redundant Nullx11 prefix on cards only; published names and the
  complete details/launch titles remain unchanged. Card hover is subtle and does
  not animate the restore icon. Long names wrap; full information is in Details.
- Search matches literal words across name, description, creator, category,
  collection and filename. **All / This game / Pinned / Recent** are quick views.
  This game includes explicit matching place/universe IDs and universal tools;
  it does not assume unknown module-signature ports are compatible.
- **Filters** opens direct **Category / Collection / Sort** choices. Tap a value
  from the list instead of repeatedly cycling a button. The choice list is lazy
  and reuses its rows. **Clear** resets the query/filters/sort/page, not history.
- **Save / Saved** marks session favorites. Recent means recently inspected
  details, not proof of execution. These are session-only and are pruned when
  entries are removed on Refresh. Refresh explicitly fetches the repository
  manifest; other browsing actions do not fetch code or probe game modules.
- Prev/Next and the editable page number reach every matching result. Rotation
  preserves the range around the first visible result. Very short landscape hides
  secondary controls and uses a compact card; rotate to change advanced filters.
- Refresh closes an obsolete selection. Continue resolves current metadata;
  removed entries cannot use an old selection to launch. No teleport is added.

The **classic launcher → Tools → Scripts window** remains a separate opening
**action**, with its existing bounded one-to-four-row pages and confirmation
flow. It remains available for compatibility, but is no longer the primary
Workspace script-picking experience.

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
the actual card/direct-choice/detail browser/model, fitting/restore code, budget policy/application,
loading layers, startup and existing game/MIDI integration contracts with API
doubles. It includes a 504-entry allocation-bound stress fixture; the production
manifest remains capped at 64 entries. This does not render Roblox or run Delta.
Native layout, notch/cutout behavior, touch targets and device frame times still
need the [manual checklist](../diagnostics/GAME-PORTS.md).
