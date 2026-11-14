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
- **ESP:** native ScreenGui boxes, R6/R15 skeleton lines, names, distance in **studs**, health text/bar, tracers and optional Highlights. No executor Drawing dependency. Boxes now use projected corners of up to 16 named R6/R15 body parts; fixed HRP offsets, cosmetics and expanded roots no longer determine bounds. One independent no-inset pixel canvas serves boxes, labels, skeletons and tracers. Render is bound after the camera update. Optional X/Y calibration is available for executor-specific layout differences. Near-plane intersections are hidden rather than producing giant displaced boxes. These visual bounds are not physical hitboxes. Optional occlusion filter. Current camera is resolved each update.
- **Input trigger:** actual viewport-center ray must hit an eligible live character. Default interval 0.15 seconds, minimum 0.1 seconds. `Auto` selects `mouse1click` when present, otherwise VirtualInputManager. Users can explicitly choose either backend. No automatic fallback after an error, no Tool/remote enumeration, and no guessed payloads. VIM down/up is paired, failed up remains owned/retriable, errors stop trigger, and unload never sends an unowned release. Mouse coordinates refer to the center, not the user's moving pointer. Executor input may be denied or ignored; API calls do **not** establish Arsenal shots or hits.
- **Mobile-only lock auto-fire:** this opt-in uses the current Aim lock, then requires the actual center ray to hit that same living eligible enemy before sending a centered VIM click. No clicks while smoothing toward an enemy before the crosshair reaches it, through cover, after lock loss, when unfocused or while typing. VIM errors disable both firing modes. Unlike generic `mouse1click`, this does not fire at the last finger/joystick position.
- **Movement:** optional walk speed/jump power, mid-air JumpRequest, per-instance noclip, and owned flight movers. Touch movement stick plus UP/DOWN pads (legacy keyboard movement handlers remain in the source); focus/typing pauses flight movement. Old character patches/movers are released on respawn, and toggles can resume on the next live character. Server correction remains possible.
- **Lighting/view:** reversible Fullbright, classic FogStart/FogEnd removal, optional camera FOV. Atmosphere/other game post-processing is not deleted or claimed removed. Original values are captured; restoration yields to external changes instead of writing hardcoded defaults.
- **Local hitbox experiment:** optional bounded enemy root size/transparency changes. No collision or server-hit claims. Original **instances**, not player names/new respawn roots, own the patch records. Team changes, death, respawn, range/limit exclusion, disable and unload release old patches.
- **Not ported as working features:** generic source remote-spraying trigger/kill aura, local-health-write “god mode,” collision-only “shoot through walls,” and empty Auto Farm/Chest Collector callbacks. None establishes an Arsenal server protocol. Anti-AFK is restored as an opt-in `Player.Idled` jump request, without an endless timer or held synthetic mouse button. It is not a guaranteed AFK-kick bypass. No speculative weapon modules, anti-cheat bypass, no-spread or infinite-ammo claims were added.

## Preservation and source parity

The **complete byte-for-byte originals** are stored in `docs/source-archive/arsenal/Arsenal_opensrc.lua.txt` and `docs/source-archive/arsenal/GAME_OPEN_SOURCE.txt`. They are not build inputs and never auto-execute. Their hashes remain the ones recorded above. No script text from either upload has been deleted from those archives.

| Original control | Current status |
| --- | --- |
| Speed, jump power, fly | Adapted with owned restoration / touch controls |
| Noclip, infinite jump | Adapted with instance restoration / JumpRequest |
| Aim/head/smoothing/FOV/visibility/team check | Adapted with centered Auto/Hold, strength, living/ForceField/range gates |
| ESP Hitbox (visual box), skeleton, name, distance, accent | Adapted; actual body bounds, independent ESP distance and color choices |
| ESP health, tracers, wall check | Adapted; native pooled UI and capped occlusion checks |
| Fullbright, remove fog | Adapted with restoration, no forced default values |
| Triggerbot | Actual-input version; guessed RemoteEvent variants are not executed |
| Hitbox Expander | Local root-size/transparency experiment, not server-hit proof |
| Anti-AFK | Restored as an idle-event jump request; no immortal loop |
| Shoot Through Walls | Original collision-only experiment preserved in archive; changing collision is not an Arsenal wallbang protocol |
| Kill Aura | Original guessed remote attack variants preserved in archive; unsupported as a verified Arsenal mechanic |
| God Mode | Original local health-write experiment preserved in archive; not verified server invulnerability |
| Auto Farm / Chest Collector | Original callbacks were empty; preserved and documented, not falsely made into working Arsenal features |
| Original window decorations/unload | Native shared mobile GUI/dock/session cleanup replaces the leaking decoration loops; originals remain archived |

## Ownership and work budgets

This edition starts gameplay controls only on touch input with no keyboard/gamepad capability. Desktop/touchscreen-PC attempts receive only a mobile-device notice. This is a capability heuristic, not a claimed OS-attestation API. All effects start **off**, including on rerun; effect toggles are not config-autoloaded. Safety filters default on. F7/Session STOP ALL turns off effects but preserves safety filters and display preferences. Left Control or the shared movable graphical dock hides/restores the window. HOLD AIM and flight pads are part of the independent overlay, so they remain usable while the window is hidden.

One scoped session replaces only the previous `arsenal` session. Loader unload does not stop it; Arsenal unload does not stop other games. The shared context owns all event connections. Cleanup is registered before feature controls, and destroys owned overlays, rig lines, highlights and movers, restores owned properties, and attempts only owned mouse release.

Candidate refresh is 0.15 seconds, at most the first 64 players (not guaranteed coverage above that). Overlay slots are lazy/reused, maximum 32, default 24; 14 skeleton segments per slot. Default overlay refresh 30 Hz (10–60 configurable); aim runs per render while enabled. Mobile performance mode caps overlays to 12 players/15 Hz and temporarily skips skeleton/highlights without overwriting normal preferences. Up to six aim candidates and **12 shared aim/ESP visibility rays per render**, plus one paced trigger ray. Out-of-budget occlusion candidates are omitted rather than assumed visible. Character patch work is 10 Hz; noclip examines at most 96 BaseParts. FPS boost optionally traverses Workspace and Lighting incrementally, at most 60 nodes/heartbeat and 8,000 scheduled unique nodes per enable cycle, including streamed additions. It disables supported visual emitters/post-effects and shadows with owned patches, never deleting map assets or textures. It is reversible and can truncate on broad maps; no FPS cap/global quality mutation, GC searches, remote requests, perpetual tasks or load-time input tests.

## Validation boundary

`tests/arsenal.luau` exercises the actual controller, input helper, policy and shared session/patch modules using structural API doubles. The actual geometry and performance modules are also tested: body corners/canvas origin/near-plane bounds, mobile-only device and firing gates, centered paired clicks, incremental effects/streaming/restore and post-camera binding disposal. It covers off-startup laziness, aim filtering and hold/focus guards, interpolation, native overlay reuse, trigger pacing and failed release behavior, reversible edits, F7 safety-filter preservation, character removal and independent unload. The generated bundle is compiled with the rest of the published catalog, which now has 16 entries.

These are **not** native Roblox/Delta render, touch, physics, FPS or server tests. Before relying on this edition on a device:

1. Join Arsenal on a mobile touch device, execute once, verify the charcoal GUI/dock and five tabs; all effects should be off. Wrong-place execution should show only a compatibility notice; desktop attempts should show only the mobile-device notice.
2. Enable FOV and ESP; resize/rotate the device, verify its center matches the crosshair. Check respawn and camera replacement.
3. Test team/FFA, dead/protected players, visible/occluded targets, strength 0/100 and Hold release outside the button. Typing and focus loss should pause aim/input.
4. Test a single trigger backend at a slow interval. Confirm actual shot behavior separately. An API error must switch trigger off; use Retry owned mouse release/F7 if an up call is refused.
5. Inspect ESP boxes/lines/health at different distances and R6/R15 rigs. Toggle it off and confirm removal, without claiming engine Highlight limits are bypassed.
6. Test movement one option at a time and use F7; compare with original speed/jump/collision/lighting, including external game changes. Confirm mobile stick/UP/DOWN behavior; server corrections are not success.
7. Toggle FPS boost in a particle-heavy area and compare measured frame times on the same scene. Check restoration, streaming, map preservation and normal ESP settings after disabling it. Do not assume improvement or zero drops. Rerun Arsenal: only its old session should be replaced. Unload the loader: Arsenal should stay alive. Unload Arsenal: its input, overlay and movers should disappear without unloading another game.

There are no measured device FPS improvements or confirmed server hit-registration results from this workspace.
