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

## TTK Testing / +1 Money per Click

- In the wrong experience, launch each standalone bundle: require a visible
  signature mismatch notice, no module require, no game telemetry hook and no
  teleport question. Retry manually once the target experience is fully loaded.
- TTK: verify the defaults are off, RMB release and explicit Touch aim, centered
  FOV after camera/orientation changes, newest Merc rig/team/death filtering,
  and Drawing-unavailable behavior (native chams may still work). Equip a weapon,
  run explicit discovery, and test each weapon toggle individually. Confirm
  no repeated GC polling. Instant ADS must stay visibly unavailable.
- TTK: change/disable weapon options and unload the game; compare original
  fields/methods and verify all Drawing/Highlight objects and signals disappear.
  Check conflicts with another owner without overwriting its replacements.
- Money: verify the exact source Unicode Rebirth stat, suffix parsing, world
  thresholds 14/29/50, respawn/missing-stat pauses, cash-pad dwell and route
  exclusivity. Rapidly toggle modes; only one route should move the root.
- Money: **use a disposable test account in an authorized environment** before
  enabling paid eggs. Confirm server costs/arguments, client request rate,
  fairness, unavailable remotes, stop-all controls and slow InvokeServer cleanup.
  An in-flight request cannot be recalled; no guaranteed purchases/hatches.
- Browse seven cards at portrait, narrow landscape and desktop sizes. Check
  real text wrapping, category/creator searches, empty states and filter reset.
  Refresh removes stale entries; detail/confirmation remains deliberate.
- Profile native device FPS and memory with all jobs off, individual jobs on,
  crowded ESP, hidden windows and after game/loader unload. No sandbox test
  establishes zero FPS drops, Delta compatibility or server acceptance.

## Enhanced loading and StealAnEgg-CHILI recovered core

- Run the normal main URL with EnhancedWorkspace on. Confirm the opening effect
  is visible in the native GUI, not behind it. Wait and Skip should both reveal
  the new workspace only; reduced motion should reveal it without the effect.
  Check portrait/landscape, hotkeys during the effect, close and immediate rerun.
- Open/confirm a game launch. Verify the execution sheet remains above the newly
  created game GUI through Initialize, with actual stage/error text. Close must
  not unload an initialized game. Check slow/failed executor HTTP and late replies.
- CHILI: verify the recovered-core warning and unavailable list. There must be no
  initial module scan/worker/server action. Wrong-game signature must block before
  module execution. Confirm the original Egg session is not replaced/unloaded.
- In an authorized test account, compare source metadata/value estimates, rarity,
  starter exclusions and 12-stud eligibility. A rejected carry must not be shown
  as a successful steal. Missing mutation data must not generate fake estimates.
- Save a safe delivery point explicitly, then opt into return while carrying.
  Check death/respawn/anchored/no-point cases, no repeat teleport for one UID,
  and clear-stop controls. Avoid simultaneous movement jobs in the two Egg ports.
- Paid progression: verify actual live costs and request acceptance before enabling
  base/treadmill/trail jobs. Away/index requests must check real source save fields.
  Toggle off during pacing/slow methods and unload before delayed replies; ensure
  no follow-up requests. Already-sent requests cannot be recalled.
- Toggle native labels repeatedly, then stop/unload. Verify bounded label counts,
  no remaining render listener/overlay, no stale intro host after rerun, and profile
  real device frame time. Development tests are not native rendering/gameplay proof.

## NULL / YARHM / Chaos native collection

- Confirm all 14 entries retain NULL edition branding. Filter by YARHM / Chaos /
  originals, category, text, current place/universe and Universal; refresh must not
  leave stale callbacks or auto-execute. Wrong universe/place must stop before any
  new game controller work; no load-anywhere prompt or game-join action.
- Run the two Brookhaven editions together; they must have separate draggable
  workspaces/restore icons/session scopes. Loader unload leaves both alive; each
  game's Unload only removes its own work. Avoid conflicting movement settings.
- Forsaken: compare actual Ingame items, survivor/killer names, generator progress;
  test map changes/respawn and medkit priority. Check nearest unfinished generator,
  retained four-second cooldown and server acceptance, not just dispatched text.
  Verify Sprinting fields restore and no module require runs until explicit input.
- MM2: test roles from current tools/events, absent characters/backpacks, gun drop,
  trap/map changes, real Gun.Shoot/KnifeThrown argument acceptance, rejected roles,
  missing remotes and prediction. A failure must stop/reset the relevant toggle.
  Check coin tween stop/unload/death and no deleted coins/fake currency success.
- FTF: verify BeastPowers/stats fallback, PC colors, pod/exit/LOCKER tags, scan caps,
  flashlight reparenting after respawn, speed/third-person restore. Anti-PC-error
  must remain visibly unavailable; no hidden global hook is installed.
- Brookhaven: verify the 10 item paths, 61 effect choices, 22 coordinates, correct
  own house/car targeting, body/hair/RP colors, avatar copy cancellation and music.
  Check invalid/missing/removed remotes and denied gamepass requests. Dispatch is
  not proof of success; server-owned effects may persist after stopping/unload.
- Universal: test finite input bounds, unique-name selection, camera replacement,
  spectate/aim, keyboard and actual mobile thumbstick flight, Rise/Descend, respawn,
  noclip/lighting restoration and precise save/return. No global world destruction.
- Repeated toggle changes must leave at most one job/key, 64 native markers per
  active session, no post-off queued request and no leftover constraints/light/
  overlay on unload. Profile frame time/memory on real devices under load; bounds
  are not a promise of zero FPS cost. Keep this checklist unverified until tested.

## Auto Player / NULL local piano

- Verify custom opening/loading transitions, reduced motion, portrait 390×640 and
  short landscape 740×360, safe-area clamps, draggable panel/static piano dock,
  keyboard search/input and touch transport. No native render result is implied
  by the structural UI tests. Confirm every intended button is actually reachable.
- Use actual Delta APIs on-device. Test the exact Android MIDI path, relative
  MIDI fallback, custom roots, subfolders, empty/denied listing, Unicode/duplicate
  filenames, corrupt/oversized/SMPTE/format-2 files and missing file APIs. No songs
  should be invented, no entire-device scan or Lua preset execution should occur.
- Check exact tempo-change timing with a known multi-track MIDI; same pitches in
  different tracks/channels, repeated overlapping notes, CC64, note-off velocity
  zero, gate/velocity/drum filters and independent track muting.
- Input is armed on launch when an API exists, but never starts playback. Test C4 in the actual target piano, then 61-key and
  optional 88-key Ctrl extension, black keys, fast repeated notes and chords.
  Verify whether Delta really permits each backend and the game accepts it.
  Preview must be clearly labeled and never send game input. Do not infer success
  from a key request's lack of an exception. Watch for other Ctrl-bound hub menus.
- Test countdown cancellation, pause/stop/F7, typing focus, seek, speed/transpose,
  A-B marks, queue completion/advance and local-file replacement mid-parse.
  Keys/modifiers must release on every normal path; revoked permissions must show
  failures, retain release ownership and allow F7 retry rather than fake success.
- Close/rerun while reading/playing; verify no stale parse restart, held key,
  connection/overlay/tween or another game session being unloaded. Loader close
  must not stop an initialized player; its own Close must stop it.
- Stress dense MIDI, sustained/shared physical keys, large directories, frame
  stalls, hidden UI, maximum file/voice/event/bar bounds and slow native I/O.
  Profile actual device FPS/memory/input timing; no zero-cost/zero-lag guarantee.

### Auto Player black-screen regression (native follow-up)

- Freshly execute the updated main branch loader; open Scripts → NULL Studio →
  Auto Player. Confirm the loader's execution sheet hands off without obscuring
  the player's opening, and text/controls render on the actual Delta device.
- Test fast/slow/missing-folder scans, invalid MIDI and a blocked read. Hide the
  loading view, switch tabs, select a replacement file, and close during loading.
  The old phase must not reopen or leave a fullscreen/tap-blocking black layer.
- Check portrait/landscape, reduced motion, dragging/hide/restore, and Settings →
  STOP INPUT. Independently verify C4/game key acceptance and releases. Development
  queued-timer/generated-bundle tests are not native rendering/performance proof.

### Screenshot piano / keyboard acceptance

- Confirm the supplied game's `1..m` white keys and Shift black keys; keep its CAPS
  off. Use Auto Player → Keys → screenshot 61-key profile, then arm in Settings.
- Test C4/t and C#4/Shift+t on each available VIM/VK/Enum backend while paused.
  Confirm actual game sound/release, not just the player's visualization/counters.
- Verify MIDI playback only after successful manual keys. Check game chords,
  physical typing, low FPS and Android app focus. If no backend works, record the
  actual game link/place ID, Delta input API errors and white/black test results;
  do not infer a compatible game remote from a screenshot.

### Redesign / local persistence / centering

- Fresh-load with a delayed/zero initial viewport; ensure the loader and player
  appear in the middle, stay usable after rotation and preserve deliberate drags.
- Verify the bottom-center loader icon and separate player holder do not overlap;
  test holder Play/Pause/Stop/Open while the main player is hidden.
- Save/relaunch: verify screenshot profile, backend, settings, favorites, queue,
  last song, mutes/loop and normalized placement. No sound should play on restore.
- Check Arm on launch defaults, explicit opt-out, STOP staying disarmed within a
  session, missing input API, unavailable/corrupt/read-only JSON storage, Save and
  Center. Confirm actual phone rendering/input separately from development tests.
