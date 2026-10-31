# Native game-port validation

No Roblox/Delta client is available in the development sandbox. **Every item below is pending real-client observation**, not a passing test report. Only use authorized experiences/accounts and follow the game's rules.

## Main workspace / device

1. Execute the branch client on desktop and a physical mobile device. Confirm the +1-based Nullx11 workspace is the default, not the classic launch card.
2. Check short landscape and portrait layouts, readable labels, tab/group scrolling, keyboard text entry, drag-vs-tap on the static prism restore icon, scaling, hide/reopen and rapid animation reversal. Verify the icon never bobs/spins/tilts, including clicks and window animation. Toggle Reduced motion and verify title/transition motion stops.
3. Right Shift opens only the workspace; Left Control opens the selected game UI. Verify game/main restore icons are independently movable and do not overlap by default.
4. Open Visuals, Aim, Design Studio, teleport bookmarks, FPS and coordinates. Verify these are the existing live tools; their prior native checklist still applies. Reopen the main workspace without disabling an enabled effect accidentally.
5. Unload/rerun the loader with a game running: only loader GUI/tools/listeners should stop. Its executed game window and enabled workers must remain functional. Stop games only via their own Unload or the separately confirmed Session stop-games action; verify their listeners/tasks then stop.

## Unsupported-game launch behavior

For each target below, first open it from another place. Confirm no game module/remote access before explicit correct-place execution.

- Rosu: `9051087354`
- Huss Valley: `107535308163741`
- +1 Loot to Forge: `118805555015549`

- Steal An Egg: detect `Shared.Remotes`, `Shared.Save`, `Client.EggState`, `Client.PlotState`, `Client.AssetRoster`, `Data.Assets`, `Data.Rarity` ModuleScripts (no supplied place ID).

Verify there is no launcher teleport question/button or execute-on-arrival toggle, no automatic game join, and no launcher queue API call. Confirm unsupported standalone bundles offer only a compatibility notice/Close. Correct-game confirmed execution must start only the selected controller. Check missing/changed modules produce visible errors and clean up partial initialization.

## Rosu

- Autoplay must start off. In a permitted chart/session enable it deliberately.
- Check live note discovery, lane input, tap timing, hold starts/tails, timing sliders and chart restart/rescan.
- Release Inputs must release currently held keys. Disable/unload/respawn/rerun must not leave stuck inputs or render bindings.
- Record actual chart/latency/runtime results; no perfect-score guarantee is implied.

## Huss Valley

- Auto Run, gems, revives, catcher chase/tackle/melee and anti-idle must start off and show matching toggle states.
- Check actual runner/catcher role changes, map/safezone/floor detection, obstacle/edge routing, rescue cancellation, dash cooldowns and native-speed restoration.
- Enable progression/wheel/map-vote helpers individually and verify live state, server responses and disabling.
- Save/load/delete a named configuration with filesystem access; missing filesystem must report failure. No profile should silently enable automation at startup.
- Unload while role/map changes or callbacks are pending. Ensure render bindings, tracked signals, idle/poll tasks, local visuals and any speed override are cleaned up.

## +1 Loot to Forge

- Confirm every automation master and anti-idle start off; opening the UI must not silently farm, claim, sell or fight.
- Check real inventory/profile reads and missing-module/remote messages before enabling any action.
- Test selected forge/gear/pet/stage/tower/reward actions individually. Destructive inventory actions require careful review; server-side acceptance is not implied by a client request.
- Verify worker defaults, request pacing, feature timeout/stop status, cancellation while work waits, and no large original 10,000-request bursts.
- Verify movement speed, jump and 3D-rendering options restore when stopped/unloaded; test respawn while options are off.
- Server hopping must be independent of the default-off **Execute this game script after server hop** consent toggle. Inspect selected-file payload and failed-teleport behavior. Do not assume queue cancellation is possible.
- Switch themes/language and verify static neutral branding, optional local Kanit font loading/fallback, mobile controls, dialogs/configs and unload.

Record client version, device, place/version, steps and observed error text for any failure. Compilation/development fixtures do not replace this checklist.

## Steal An Egg

- Confirm the uploaded twelve tabs render through the embedded shared UI, without a remote WindUI download. All jobs, combat, anti-idle and ESP must start off.
- Test single/multi dropdown changes, refreshes, numerical controls, status paragraphs and manual config save/load/delete. No autoload should enable jobs at startup.
- Verify game module/version compatibility and test farming/inventory/event/minigame actions individually in an authorized session; server acceptance and current remote names are not certified.
- Check ESP stays within 24 live markers, clears when disabled, and handles character loss. Toggle speed/jump/invisibility and verify recorded values are restored when disabled/unloaded.
- Hide/reopen: predictors/finder work should pause while hidden, but intentionally enabled jobs continue. Unloading the loader must not stop those jobs; unloading this game must.
- Opening/closing without changing performance settings must not alter the existing HUD, render setting or FPS cap. If a cap is explicitly changed, verify restoration where the executor supplies getfpscap.
- Compare baseline versus loaded/hidden/active frame times and instance counts on desktop and physical mobile. Record device, scene population and enabled features; no zero-FPS-drop guarantee is claimed.

## stealabrainrot / execution sheet

Follow [the recovered-source review and native checklist](../docs/BRAINROT-REVIEW.md). Validate the ModuleScript/Plots signature, off defaults, missing-source notices, real controls and per-game cleanup. Never infer live success from compilation.

During confirmed launch inspect the new four-stage loading sheet on desktop/mobile. Slow HTTP should not invent byte progress. Cancel before initialization, then let the HTTP response return: the selected chunk must not execute. Induce download/size/compile/startup errors and verify visible errors. Hide during initialization: the executed script must keep running. Close/unload the loader while a game runs: only loader-owned presentation/tools should stop. Check Reduced motion, rapid reopen, short-screen scrolling and the static prism/navigation artwork. Observe real device FPS and note enabled features; no zero-drop guarantee is implied.
