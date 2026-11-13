# Arsenal / NULL — supplied-source review

## Inputs and scope

Two user-uploaded client scripts were reviewed as text, never executed as upstream code:

| Input | Bytes | SHA-256 |
| --- | ---: | --- |
| `Arsenal_opensrc.lua.txt` (`arsenal_ui.lua` header) | 34,651 | `3563b9e059a5aa22a96c77bab34009c259ab48991df5a5d4ec82b27891b6a12d` |
| `GAME_OPEN_SOURCE.txt` (generic combat/movement UI) | 38,422 | `ee8bca30475f172f61ae0bb987341bfb05187ae092d591c465a4885d8a42a280` |

Neither input identifies an author or a license grant in its header. The user describes them as open source. That description is not independent license verification or a copyright transfer. NULL is the Nullx11 edition owner/developer brand; supplied-source contributions are not claimed as newly authored. No new rights claim or repeated permission request is made.

`src/games/Arsenal.luau`, `ArsenalPolicy.luau`, and `ArsenalInput.luau` implement the reviewed adaptation. `scripts/Nullx11-Arsenal.luau` is generated, self-contained and contains the shared native charcoal/blue GUI, not the main loader or an upstream loader. Its public Arsenal place gate is **286090429**; elsewhere it only shows the manual compatibility notice. No teleport or arrival execution is installed. Other Arsenal places are not guessed.

## Feature decisions

- **Camera aim:** nearest eligible projected target in a configurable viewport-center circle; head/root selection; Auto or RMB/touch Hold activation. Strength 0–100 uses delta-time-adjusted interpolation, with 100 snapping. Team, health, ForceField, range and optional visibility checks; typing, focus loss, local death and scriptable cameras pause aim. This is camera steering, not silent aim or a shot protocol.
- **ESP:** native ScreenGui boxes, R6/R15 skeleton lines, names, distance in **studs**, health text/bar, tracers and optional Highlights. No executor Drawing dependency. Classic source approximate 2D boxes are visual indicators, not physical hitboxes. Optional occlusion filter. Current camera is resolved each update.
- **Input trigger:** actual viewport-center ray must hit an eligible live character. Default interval 0.15 seconds, minimum 0.1 seconds. `Auto` selects `mouse1click` when present, otherwise VirtualInputManager. Users can explicitly choose either backend. No automatic fallback after an error, no Tool/remote enumeration, and no guessed payloads. VIM down/up is paired, failed up remains owned/retriable, errors stop trigger, and unload never sends an unowned release. Mouse coordinates refer to the center, not the user's moving pointer. Executor input may be denied or ignored; API calls do **not** establish Arsenal shots or hits.
- **Movement:** optional walk speed/jump power, mid-air JumpRequest, per-instance noclip, and owned flight movers. Desktop WASD/Space/Shift and touch movement stick plus UP/DOWN pads; focus/typing pauses flight movement. Old character patches/movers are released on respawn, and toggles can resume on the next live character. Server correction remains possible.
- **Lighting/view:** reversible Fullbright, classic FogStart/FogEnd removal, optional camera FOV. Atmosphere/other game post-processing is not deleted or claimed removed. Original values are captured; restoration yields to external changes instead of writing hardcoded defaults.
- **Local hitbox experiment:** optional bounded enemy root size/transparency changes. No collision or server-hit claims. Original **instances**, not player names/new respawn roots, own the patch records. Team changes, death, respawn, range/limit exclusion, disable and unload release old patches.
- **Not ported as working features:** generic source remote-spraying trigger/kill aura, local-health-write “god mode,” collision-only “shoot through walls,” and empty Auto Farm/Chest Collector callbacks. None establishes an Arsenal server protocol. The generic timed anti-AFK worker was not retained; there is no keep-alive loop or AFK guarantee. No speculative weapon modules, anti-cheat bypass, no-spread or infinite-ammo claims were added.

## Ownership and work budgets

All effects start **off**, including on rerun; effect toggles are not config-autoloaded. Safety filters default on. F7/Session STOP ALL turns off effects but preserves safety filters and display preferences. Left Control or the shared movable graphical dock hides/restores the window. HOLD AIM and flight pads are part of the independent overlay, so they remain usable while the window is hidden.

One scoped session replaces only the previous `arsenal` session. Loader unload does not stop it; Arsenal unload does not stop other games. The shared context owns all event connections. Cleanup is registered before feature controls, and destroys owned overlays, rig lines, highlights and movers, restores owned properties, and attempts only owned mouse release.

Candidate refresh is 0.15 seconds, at most the first 64 players (not guaranteed coverage above that). Overlay slots are lazy/reused, maximum 32, default 24; 14 skeleton segments per slot. Default overlay refresh 30 Hz (10–60 configurable); aim runs per render while enabled. Up to six aim candidates and **12 shared aim/ESP visibility rays per render**, plus one paced trigger ray. Out-of-budget occlusion candidates are omitted rather than assumed visible. Character patch work is 10 Hz; noclip examines at most 96 BaseParts. No world-wide scans, remote requests, GC searches, perpetual tasks or load-time input tests.

## Validation boundary

`tests/arsenal.luau` exercises the actual controller, input helper, policy and shared session/patch modules using structural API doubles. It covers off-startup laziness, aim filtering and hold/focus guards, interpolation, native overlay reuse, trigger pacing and failed release behavior, reversible edits, F7 safety-filter preservation, character removal and independent unload. The generated bundle is compiled with the rest of the published catalog, which now has 16 entries.

These are **not** native Roblox/Delta render, touch, physics, FPS or server tests. Before relying on this edition on a device:

1. Join Arsenal, execute once, verify the charcoal GUI/dock and five tabs; all effects should be off. Wrong-place execution should show only a compatibility notice.
2. Enable FOV alone; resize/rotate the device, verify its center matches the crosshair. Check respawn and camera replacement.
3. Test team/FFA, dead/protected players, visible/occluded targets, strength 0/100 and Hold release outside the button. Typing and focus loss should pause aim/input.
4. Test a single trigger backend at a slow interval. Confirm actual shot behavior separately. An API error must switch trigger off; use Retry owned mouse release/F7 if an up call is refused.
5. Inspect ESP boxes/lines/health at different distances and R6/R15 rigs. Toggle it off and confirm removal, without claiming engine Highlight limits are bypassed.
6. Test movement one option at a time and use F7; compare with original speed/jump/collision/lighting, including external game changes. Confirm mobile stick/UP/DOWN behavior; server corrections are not success.
7. Rerun Arsenal: only its old session should be replaced. Unload the loader: Arsenal should stay alive. Unload Arsenal: its input, overlay and movers should disappear without unloading another game.

There are no measured device FPS improvements or confirmed server hit-registration results from this workspace.
