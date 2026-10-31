# Nullx11

A mobile-friendly Roblox workspace with **NULL** owner branding, branded **Nullx11**, now built on the full supplied **+1 Loot UI library**. The default interface now uses a clean charcoal/blue design, modern readable typography, thinner borders, a movable static prism restore icon, responsive tabs/groupboxes, themes, dialogs and configuration. Optional classic looks remain available. Existing native player tools and Design Studio remain available.

**Five adapted game controllers are included**, not just launch placeholders:

| Game workspace | Exact place | Standalone bundle |
| --- | --- | --- |
| Nullx11 - Rosu Mania | `9051087354` | [Rosu](scripts/Nullx11-Rosu.luau) |
| Nullx11 - hussvalley | `107535308163741` | [Huss](scripts/Nullx11-Huss.luau) |
| Nullx11 - +1 loot to forge | `118805555015549` | [Forge](scripts/Nullx11-Forge.luau) |
| Nullx11 - Steal An Egg | Core ModuleScript signature (no supplied place ID) | [Steal An Egg](scripts/Nullx11-StealAnEgg.luau) |
| stealabrainrot | `Datas.Animals`, `Packages.PlayerMouse`, `workspace.Plots` signature | [stealabrainrot](scripts/Nullx11-StealABrainrot.luau) |

Sources were adapted using the user's reported developer permissions. See [provenance/restrictions](docs/SOURCE-PROVENANCE.md), [implementation status](scripts/INTEGRATION-STATUS.md), and [pending native validation](diagnostics/GAME-PORTS.md). **Compilation and development checks pass; live Roblox/Delta gameplay is not certified.**

## Run the full script

### External runtime / Delta

Copy the **entire contents** of [`Nullx11.client.luau`](Nullx11.client.luau) into your runtime's editor and execute while joined, or use the loadstring entry below. The shared workspace opens directly; **Load is not required** to browse its tabs. Open **Scripts**, choose a game, and use its separate launch window. Automation starts off.

**Right Shift** toggles the main workspace; **Left Control** is the default for game windows. Each has its own movable static prism restore icon. The classic launcher/App hook is still available through Workspace.

The main client does not require an executor's `script` global. The shared UI prefers a supported hidden/CoreGui parent and falls back to PlayerGui; native tools use PlayerGui. The UI library is embedded as code, not downloaded from another UI host. This is compatibility-oriented implementation, **not a claim of testing in Delta**. Runtime versions and individual games may behave differently. Use only where you have permission, such as your own experience.

### Roblox Studio

1. Insert a **LocalScript** in **StarterPlayer → StarterPlayerScripts**.
2. Paste in `Nullx11.client.luau`.
3. Press **Play**. The shared workspace opens directly; use its window actions. The optional `App` hook is reached through the classic launcher and **Load**.

No external executor or `loadstring` is needed in Studio. With Rojo, map the `.client.luau` file into `StarterPlayerScripts`.

## Shared workspace

- **Workspace:** live session/FPS/player/place and UI-budget readout; quick access to pinned/recent and current-game scripts, Center loader window, Visuals, Aim, Design Studio and the classic launcher.
- **Scripts:** all fifteen entries available without Refresh; a responsive game-card grid, in-place details, direct-choice category/collection filters, literal search, sorting, session saves/recent views and page jumping. Separate game windows retain compatibility notices and confirmed execution. No game-launch teleports or arrival queues.
- **Session tools:** save/return window, floating FPS and coordinates, title glitch, reduced motion, Auto/Balanced/Low power UI budgets, and unloading registered game sessions.
- **Settings:** full +1-derived themes, scaling, language, menu key, floating icon, particles and configuration controls. The static geometric prism is drawn locally; no Mario logo or letter monogram is used. Seasonal decoration and ambient particles are off by default. Optional Thai fonts use vendored repository assets.
- **Game windows:** the original controllers adapted to this same UI. Each selected bundle contains its own shared library and only its game controller, and does not depend on the main loader remaining open.

Design Studio's detailed appearance profiles continue to style the **classic/native tool panels**; shared workspace skin/scale/language are controlled in its own Settings. Game controls have independent configurations. No automatic gameplay profile is loaded at startup.

See [the loader/browser guide](docs/LOADER-UI.md) for paging, session pins/recent views, centering/hidden-restore fixes and UI performance policy. All loader layers now share full-viewport coordinates; native notch/touch/frame-time checks remain pending.

## Classic / native tool features

| Control | Behavior |
| --- | --- |
| **Classic startup reveal** | In `EnhancedWorkspace = false` mode, a 24-particle gravity well (16 on touch clients) with three orbital lenses contracts into the central N, expands into a shockwave, then throws the GUI out of the dock. Skip is always available; reduced-motion defaults bypass it. |
| **Scripts window** | Separate paginated, searchable GitHub library with compact rows and counts. Explicit Refresh and two-tap Run confirmation; no scripts auto-run. |
| **Pixel / Medieval / signature looks** | Quick choices on Style; native Arcade and GrenzeGotisch headings, readable modern body text, aurora-cyan or amber/gothic looks. |
| **Visuals window / Aim window** | Separate draggable, scrollable settings panels under Tools. Effects are OFF until explicitly enabled. |
| **Load** | Opens the built-in tools after the game is ready. Also initializes an optional Studio `App` module. |
| **Open Design Studio** | From Style, open the lazy-built appearance editor with six categories and 46 preferences. |
| **Resize grip ↘** | After Load, drag the dashboard’s bottom-right grip. Lock windows disables resizing. |
| **Tools / Style / Session** | Switch between utilities, appearance controls, and session/recovery actions. Pages scroll on short screens. |
| **Teleport tools** | Opens a separate draggable position panel. Turning it off hides the panel without losing bookmarks. |
| **01 / 02 / 03** | Select one of three independent bookmark slots. EMPTY / SAVED indicates slot state. |
| **Bookmark name** | Edit the selected slot name. Names are trimmed, control characters are removed, and length is capped at 24 Unicode codepoints on commit. |
| **Distance** | Shows the live straight-line distance to the selected saved pivot in studs, sampled twice a second. |
| **Save position** | Saves your current character pivot, including orientation, and displays its coordinates. |
| **Teleport to saved spot** | Moves your current character back to that pivot and clears root-part velocity. |
| **Clear** | Deletes the saved position. |
| **− on position panel** | Hides the utility and synchronizes its main toggle to OFF. |
| **FPS meter** | Shows a draggable floating meter, sampled from actual rendered frames every half second. Color changes below 50 and 30 FPS. A bounded twelve-sample history graph shows recent performance; graph height caps at 120 FPS while the number remains uncapped. |
| **Glitch title** | Toggles short RGB-split / scrambled-text bursts on the `Nullx11` title every 3.6 seconds. Uses Roblox's built-in `Code` monospace font. |
| **Position HUD** | Shows a separate draggable live-coordinate readout, sampled twice a second. |
| **Violet / Mint / Ice** | Recolor accents in the current interface. |
| **Reduced motion** | Disable transitions and turn off the glitch title immediately. |
| **Lock windows** | Prevent accidental dragging of the dashboard and utilities. The dock remains movable. |
| **Snap dock** | Optionally snap the icon to the nearest left/right safe-area edge on release; it adapts to orientation changes and does not count dragging as a tap. |
| **Small / Default / Large** | Set interface scale to 85%, 100%, or 110%, limited by available screen space. |
| **Session** | Show active session time, your local player name, and bookmark count. |
| **Recenter all windows** | Recover/reset positions without deleting bookmarks or changing preferences. |
| **Hide floating utilities** | Hide teleport, FPS, coordinate, Visuals, Aim, and Scripts panels; disable player visuals, camera assist, and the FOV circle; synchronize toggles. |
| **Clear all bookmarks** | Tap twice within three seconds to confirm deletion. |
| **Dock / Right Shift** | Toggle the dashboard. The dock is always visible until the GUI is closed; dragging it does not activate it. Right Shift is ignored while typing or when Roblox already processed the input. |
| **− on main panel** | Hide the dashboard. Enabled floating tools and the dock remain visible. |
| **×** | Stops player effects immediately, folds visible windows into the dock, then destroys the UI and disconnects listeners. It cannot unload arbitrary external scripts. |

### Teleport limits

- **Three independent bookmark slots per running session**, held in memory. Select a slot before saving or teleporting. Each slot survives a character respawn, but is cleared by closing/rerunning the loader or leaving the game. It is not saved to disk or a DataStore.
- Saving and teleporting require a spawned, living character with a root part. Leave your seat before teleporting. Repeated teleports have a short cooldown.
- This uses **local `Model:PivotTo` movement**. It does not grant server permissions, change other players, switch servers, or bypass server validation. A game can reject or reset the movement. The message “local movement” means the local call completed, **not** that a server accepted it.
- Saved spots are not checked for hazards or obstacles. Use safe destinations.
- If this is a feature in your published experience, authorize and validate teleports on the server. Do not trust client-supplied positions for authoritative gameplay.

## Player Visuals and Aim

Open **Workspace → Open Visuals / ESP** or **Open Aim / FOV** (also available from classic **Load → Tools**). These are independent, lazy-built windows with draggable headers, hide buttons, scrollable controls, and responsive sizes up to 390 × 540. Opening a window does **not** enable its effects. The windows reuse their controls when reopened, and inherit applicable Design Studio styling even if created after Studio.

### Visuals

- Master enable; independently switch **player chams, bounding boxes, bottom-center tracer lines, display names, health bars, and camera distance**.
- Team filtering and line-of-sight filtering start enabled. **Through walls** is an explicit visual-only option, not the default.
- Choose Violet, Mint, Cyan, Red, or White; range **250–3,000 studs** (default 1,000); overlay refresh **15–60 Hz** (default 30). Numeric fields accept bounded whole numbers, with −/+ controls.
- Works with other `Players` whose live character has a Humanoid and a HumanoidRootPart, PrimaryPart, UpperTorso, or Torso root fallback. It does not identify NPCs, custom actor systems, or server-only objects.
- At most **32 players are drawn simultaneously**, prioritized by camera distance. Up to **24 pooled Highlight instances** are reused; disabling chams or visuals frees those Highlight slots. The experience's own renderer limits can still affect visibility. Per-player 2D widgets are created when needed, reused, and destroyed when that player leaves.
- Occlusion checks are capped at **48 rays per visual refresh**. On crowded, heavily occluded servers this can omit farther visible players rather than perform unbounded raycasts.

### Aim / centered FOV

- Enable **Show FOV circle** independently of camera assist. It stays centered on the current camera viewport, including after camera replacement/orientation changes. Radius **50–400 pixels** (default 140), with its own five-color selector; this does not change the camera's FieldOfView property.
- **Auto is the default activation mode**: once you explicitly enable aim, it tracks eligible players without a held gesture. Enabling also turns on the FOV circle. **STOP AUTO** or End disables tracking.
- Choose **Hold** for the previous behavior: hold right mouse or **HOLD AIM**, release to stop. The configurable, draggable pad is available on desktop and mobile; unreliable touch detection no longer hides it.
- **Play view / fold panels into dock** hides settings and the dashboard without disabling enabled effects, leaving the center visible.
- **Strength accepts every whole number from 1 to 100**, by typing or −/+. Default 50 uses time-based smoothing; **100 snaps the local camera directly to the selected target**. A dedicated strength-100 button is included.
- Choose Head or Root, team filtering, and a **250–3,000-stud** range. It picks the closest eligible target to the viewport center within the radius. Aim always requires line of sight, including when visual through-walls mode is enabled; at most eight candidate raycasts run per frame.
- Typing and missing/dead/partially spawned local avatars pause tracking. Hold input ignores processed/own-window presses and clears on focus loss. Scripted cameras pause by default; **Scripted camera override** is an explicit opt-in that can interfere with cutscenes.
- Tracking runs near the end of the render priority order, after ordinary camera updates. If native binding fails, a real RenderStepped event is used; errors stop effects and appear in the status/console rather than silently repeating.
- No target? The status reports real player, team/rig-filter, FOV, and obstruction counts. **Check live Roblox state** near the bottom of Visuals/Aim provides a persistent report of real avatar/camera/player/renderer state. NPCs are not targets. On same-team games, disable the team filter only if intended.
- This is **local camera steering only**: no auto-fire, weapon remotes, projectile redirection, hit registration changes, or server bypass. Games with custom rigs, cameras, or weapon aim rules may behave differently; “universal” is not a guarantee of compatibility with every experience.

### Disable / cleanup / persistence

Press **End** while not typing, or use **Disable visuals, aim, and circle** at the top of either window. This disables all three effects, removes Highlights, hides overlays, clears held input, and unbinds their camera-step callback. Hiding an individual settings window does not disable its effects. **Session → Hide floating utilities** also disables player tools and hides their settings. Closing the main GUI destroys the independent overlay screen, Highlight pool, and listeners. Re-execution replaces the previous instance.

Player-tool options are **session-only**, separate from Design Studio's appearance profiles/JSON. They do not auto-enable or load previous targets on execution.

## Startup animation

The default shared workspace uses the supplied library's decorative entrance and N-icon window transport. These are presentation animations, not network/gameplay progress measurements. `StartupAnimation = false` bypasses the entrance; Reduced motion suppresses transitions, title motion and particles. With `EnhancedWorkspace = false`, the preserved classic reveal is available:

Decorative writes are capped around 30 Hz while phase timing remains elapsed-time based. The decorative reveal uses **24 precreated particles (16 on touch-enabled clients), three rotating elliptical lenses, a central geometric prism, and a pixel wordmark**: approximately **1.25 seconds of inward spiral/implosion**, then a **0.7-second outward shockwave**, followed by a dock-to-window entrance. If `game:IsLoaded()` is false, it honestly says it is waiting; no fake percentage or asset progress is shown. Skip remains available while waiting. Completing, skipping, rerunning, or closing disconnects the temporary animation callback. Short landscape screens move labels away from the bottom skip button.

Set `CONFIG.StartupAnimation = false` to skip the decoration, or `CONFIG.ReducedMotion = true` to bypass it and disable other motion by default. The animation plays once per execution, not whenever a window is reopened. It is independent of the optional App initializer invoked by Load.

## Game ports / Scripts library

**Workspace → Scripts** has all 15 entries (eight earlier editions, five YARHM game/tool entries, a separate Chaos Brookhaven edition, and Auto Player) immediately. **Open Scripts library** is an ordinary action, not an ON/OFF toggle. A game's detail window shows its description, target and provenance. Opening it performs no download or execution.

- Unsupported place: direct Execute is blocked for the three exact-place ports. Join the game manually; the launcher never asks to teleport, teleports automatically or queues arrival code.
- Steal An Egg has no place ID in the uploaded source. Its standalone bundle checks seven core ModuleScript paths before initializing its controller, then validates every required game module. No destination ID is invented. Game updates can break this signature.
- Execute requires a second confirmation within five seconds before downloading/compiling/invoking the selected source.
- Directly opening a standalone bundle in an unsupported game displays only a compatibility notice and Close, without starting gameplay.
- Successful manifest Refresh invalidates stale game selection/confirmation, including removed entries.

**Refresh from GitHub** replaces the built-in catalog with [`scripts/manifest.json`](scripts/manifest.json). Search/path/place validation remains available. Published scripts may be at most **2 MiB**, enough for their complete embedded UI. Source-relative paths and metadata are validated; failures are visible, not replaced with simulated gameplay. See [library schema](scripts/README.md).

Remote execution requires client HTTP/loadstring; normal Studio LocalScripts cannot use that download path. The main UI/native tools do not depend on it. **Unloading or rerunning the loader leaves executed game scripts running.** Each bundled game has its own Unload action. The separate, confirmed **Unload launched game scripts** control deliberately stops registered games; ordinary loader Unload does not. Arbitrary external scripts still own their cleanup. Review code and prefer a commit-pinned URL.

Forge's explicit routed remote/bindable calls are paced at most eight per second with cancellation and reduced worker/burst defaults. This does not certify server acceptance or bound all traffic generated internally by the game's own modules. Large original burst defaults were not retained. Automation and anti-idle start off; saved gameplay profiles load only through explicit user actions.

## New: stealabrainrot and execution presentation

**Scripts → stealabrainrot** opens the supplied recovered controller through **our embedded Nullx11 GUI**, not the original Chilli UI. Stealer/helper/player/ESP/server controls, live units/ranges, multi-selects and manual shared settings are integrated. Automation starts off. The source's AP/TP/Priority placeholders remain explicitly unavailable; see the [source/security review](docs/BRAINROT-REVIEW.md) for recovery limitations and the removed webhook/config exfiltration and upstream loaders.

The shared interface now uses original semantic line assets, a richer static purple/cyan prism, and short content transitions without bouncing navigation art. The restore icon is still static. [Brand references](assets/brand/) are SVG exports; Roblox draws the actual assets natively without image downloads.

Confirmed execution opens a responsive, scrollable Nullx11 loading sheet: **Download → Validate → Compile → Initialize**. Stages advance at actual client boundaries; the byte count is shown only after HTTP returns, with no fake timer percentage. The bar indicates completed stages, not bytes downloaded. Cancel before initialization prevents later compilation/startup; it cannot interrupt the executor's HTTP transport. Once initialization has begun, Hide closes only the sheet and does not stop the executed script. Errors stay visible. The final message means the client chunk returned, **not that gameplay succeeded**. Transitions respect Reduced motion and use no permanent loading-animation loop. Classic-only mode retains its status/button reporting.

## Idle-work and ownership changes

The restore/header insignia is a static, native geometric prism (not a letter or Mario asset). Decorative seasonal loops and ambient particles default off, main/game intros are skipped, and the workspace reuses the shared FPS sampler instead of installing another RenderStepped listener. Title glitch remains a separate optional title effect.

Steal An Egg retains its supplied gameplay implementation and twelve tabs, now through the local WindUI-shaped adapter. UI construction yields between groups of tabs; unchanged status labels are not rewritten; predictors/finder work pauses while its window is hidden; inactive combat polls less frequently. All automation/ESP starts off, disabled ESP exits before reading game snapshots, and overlays are limited to 24 markers. Character overrides restore their recorded values when disabled, and cleanup does not set an FPS cap or force the HUD on if those settings were never changed. Saved configurations are **manual only**: loading one can enable features, so review it first.

These are source-level resource reductions, **not a measured FPS benchmark or a zero-drop guarantee**. Existing scripts continue consuming their own resources after loader Unload, intentionally. Test on the actual target device/game; see [native validation](diagnostics/GAME-PORTS.md).

## Window transport / readability

The dashboard, teleport/FPS/coordinate utilities, Design Studio, Visuals, Aim, and Scripts use actual TweenService position/rotation/UIScale transport: close contracts toward the dock, open ejects outward with an overshoot/settle. The restore icon itself stays static; it does not bob, spin, tilt or play click effects. Per-window tokens cancel stale completions during rapid reversal; viewport changes settle/cancel transport before clamping the layout. Reduced motion bypasses it.

Baseline text is now **at least 14 px**, toggle headings 16 px, and the main title 21 px before responsive UI scaling. Secondary text is brighter, toggle rows are taller, and player/library panels are wider. Style has direct **Modern / Pixel / Medieval** controls and **Aurora / Pixel** / **Citadel / Gothic** signature looks. Pixel and gothic styles use native `Arcade` and `GrenzeGotisch` for larger display text, keeping small body text modern/readable. No uploaded font or image asset is required.

## Optional loadstring launcher

[`bootstrap.luau`](bootstrap.luau) is a small launcher for a runtime that provides **both** client `loadstring` and `game:HttpGet`. Standard Roblox LocalScripts do not provide these capabilities.

The launcher targets the public PR branch `arena/bc7610cd-nullx11-loader`. Its source is separate from `main`; merging the PR is not required to load this branch version. Download failures are reported by the bootstrap.

For a short launcher targeting the PR branch:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/Nullx11.client.luau"))()
```

Or execute `bootstrap.luau` to get clearer download/compile/startup errors; change `SOURCE_URL` if you host your own reviewed copy. Its current URL targets the session's fixed branch `arena/bc7610cd-nullx11-loader`, not `main`. Do not assume a file exists on `main` until it is actually merged there.

Remote code runs with the capabilities of your runtime. Review the source; ideally pin the raw URL to a reviewed commit SHA rather than a mutable branch. There is no remote executable UI download at startup. Refresh fetches catalog data; confirmed Run fetches game code. Optional Thai fonts fetch data assets from this repository. Forge can request Roblox public-server data for an explicitly enabled server-hop flow.

## Classic/native panel design and mobile behavior

The shared front-end has its own responsive +1-derived layout (820 × 560 preferred desktop size, compact/touch layouts, floating icon and configurable scale). The details below describe the preserved classic/native panels.

- Original N monogram drawn from rounded strokes, a cyan crystal rim, orbit halo, corner runes, gradient surface, and status dot; no asset upload required.
- A 440 × 360 launch panel expands to a dashboard up to 440 × 520. Short screens use shorter, scrollable pages instead of shrinking the entire dashboard. Position panel: 320 × 362; FPS meter: 132 × 64; coordinate HUD: 224 × 48; dock: 60 × 60, before applicable responsive scaling.
- Safe-area positioning, portrait/landscape resizing, touch/mouse dragging, edge clamping, and 44-pixel header controls before short-screen scaling.
- Normal Roblox gamepad button selection/activation; dragging uses touch or mouse.
- UI persists across respawns; rerunning replaces the prior GUI and disconnects its listeners.
- The FPS meter and title share one render connection and allocate no GUI instances per frame. Player effects use a separate after-camera callback only while needed, with lazily built, reusable widgets and bounded raycasts.
- Animated pill switches include an ON/OFF text label, so state does not rely on color alone. Theme changes refresh switch accents as well.
- After the skippable startup reveal, no full-screen dimmer intercepts gameplay outside the windows.

## Customize / reduced motion

Edit `CONFIG` in `src/loader.luau`, then run `npm run build` (or locate the table following the embedded UI factory in the generated client):

```lua
local CONFIG = {
    Name = "Nullx11",
    Subtitle = "A quieter way to get started.",
    Accent = Color3.fromRGB(167, 146, 255),
    ReducedMotion = false,
    StartupAnimation = true,
    EnhancedWorkspace = true,
}
```

Set `ReducedMotion = true` for a motion-free default. The Style tab can change it during a run; enabling it also switches the glitch toggle off. This is an explicit setting, not automatic OS preference detection. Other colors live in the `colors` table.

## Design Studio

Open **Workspace → Open Design Studio**, or classic **Load → Style → Open Design Studio**. The main executor script contains the entire editor; no additional files or modules are needed. Its controls are created once, on first use. Closing Studio hides it; closing the main loader destroys it.

### Six searchable categories

- **Color:** twelve accent presets, custom RGB, three/six-digit hex input, a tint/shade ladder, hue/complement adjustments, gradients, panel/dock opacity, corner roundness, borders, and an opaque-color contrast reference.
- **Type:** modern built-in body fonts plus native pixel/gothic display styles, technical monospace preservation, text scaling, brighter secondary text, focus outlines, larger setting-row controls, descriptions, and header/footer/status visibility. A real text preview updates with the settings.
- **Layout:** preferred dashboard dimensions, interface scale, dock size/shape/monogram, caption/dot visibility, snapping, locking, alternate dashboard hotkeys, HUD width/precision, editor dimensions, arrangements, and a live normalized window map.
- **Motion:** reduced motion, easing/duration, bounded title-glitch controls, FPS graph visibility, and instrument sample windows. Five motion recipes provide quick starting points. Reduced motion takes priority over glitch requests.
- **Profiles:** ten design recipes, three named in-memory design slots, comparison against saved/default values, a settings inspector, bounded history, and JSON transfer.
- **Help:** searchable usage guidance, Studio shortcut information, and a refreshable local diagnostic snapshot. It does not test or fingerprint the executor or server.

Search filters each category using plain substring matching, not Lua patterns. Horizontal category navigation and vertical pages scroll on small screens. Layout preferences always yield to the safe area; arrangements may overlap on small phones.

### History and quick controls

Studio retains up to **24 undo snapshots**. A new change clears redo. After Studio has been opened, the quick Style controls synchronize into the editor and its history. Completed dashboard resizes are also recorded. Ordinary dragging, utility activation, profile-slot saves/deletions, and arrangement actions are not appearance-history entries.

While Studio is visible and no text field is focused:

- **Ctrl+Z:** undo.
- **Ctrl+Y:** redo.
- **Escape:** hide Studio.

Processed input is ignored. The dashboard shortcut defaults to Right Shift and can be changed separately in Layout.

### Settings-only export/import

**Generate JSON** writes a versioned appearance object into a scrollable text field. Select/copy it manually; the classic Studio transfer UI does not silently write files or use executor clipboard APIs. The shared UI and game configuration tools separately support executor filesystem storage through their explicit controls; optional assets may be cached locally. Paste it back and choose **Validate and import** to restore it.

Import is limited to **8192 bytes** and known settings with valid types, choices, finite numbers, and bounded ranges. The full patch is validated before application. Unsupported versions, extra fields, unknown settings, and invalid values are rejected. Imported data is never executed or fetched as a URL. Export does not include player identity, teleport locations, profile names, or game state.

Saved designs and bookmarks are distinct. Both are session-only unless you manually retain an exported appearance JSON. JSON transfers appearance only, not bookmarks. Resetting appearance preserves bookmarks and saved design slots; deleting a saved design does not alter the active design.

The contrast reference uses opaque base colors and standard relative-luminance math. Gameplay behind transparent windows can change actual contrast; this readout is **not an accessibility certification**.

## Optional Studio app hook

Built-in tools work without this. To initialize your own game UI as well, add a **ModuleScript named `App` as a child of the loader LocalScript**:

```lua
return function(context)
    if context.IsCancelled() then return end
    context.SetProgress(0, "Preparing your interface…")

    -- Initialize your own UI or local systems here.
    -- Report real completed work, not an artificial loading timer.

    if context.IsCancelled() then return end
    context.SetProgress(1, "Interface ready")
end
```

`context` provides `Player`, `SetProgress(fraction, message?)`, and `IsCancelled()`. Initializer errors are logged to Output / your runtime console and leave **Try again** available. Initialization runs once on success. Make app initialization idempotent, clean up partially created objects after errors, and check cancellation after yielding. Closing the loader cannot forcibly terminate arbitrary app code or unload other UI created by the app.

## Checks

Development checks only; npm is **not** required to run the Roblox script:

```sh
npm ci --ignore-scripts
npm run build:check
npm run format:check
npm test
```

The checks verify reproducible generated artifacts, all 15 bundles/place-or-universe-or-module gates/defaults/dependencies/size limits and font licensing; exercise actual shared reactive APIs and actual adapter/session/standalone launch modules with development fixtures; and compile the main, bootstrap, and native diagnostic Luau files (the native diagnostic is not executed here), parse the real repository manifest JSON, compile any published library scripts, and exercise deterministic development API doubles for loading, tabs, themes, scaling, window locking, hotkey input filtering, live coordinates, independent bookmarks, Unicode name sanitization, live distance, animated switch states, FPS history capacity/reset/no-instance-allocation, dock edge-snapping/rotation, confirmation/recovery actions, spawn/seat guards, cooldowns, respawn, FPS sampling, reduced motion, glitch reset, dragging, resize, closing, rerunning, initializer retry, and execution without a `script` instance. Player-tool tests cover separate/reused windows, team/visibility/death filters, bounding boxes/chams/tracers, editable numeric limits, FOV placement/color, smoothing versus strength-100 snap, hold/release and input guards, touch-pad input, camera replacement/loss, respawns, crowded-server ray/instance caps, emergency off, and teardown. New polish checks cover animation token lifetime/reversal/resize, native font choices/looks, Auto/Hold, root fallbacks, explicit camera override, play view, render fallback/error reporting, and library path validation/search/confirmation/refreshed-row cleanup. They do not prove rendered motion or real HTTP. Startup tests cover contraction/burst/reveal, actual readiness waiting, skip, short landscape positioning, reduced motion, rerun, and closing during animation. The Design Studio suite additionally checks lazy construction/reuse, preferences, palette/hex math, custom RGB, search, typography, motion priority, resize/locking, bounded history, quick-control synchronization, saved designs, settings validation, shortcuts, and editor safe-area clamping. Its JSON codec is mocked: tests exercise validation and transfer flow, not Roblox’s JSON parser. Bootstrap checks cover missing capabilities, download/compile failure, and startup. GitHub Actions runs formatting and the same checks for pushes and PRs. `npm run format` applies the pinned StyLua configuration.

These mocks do not emulate Roblox physics, rendering, real touch input, or Delta. Test in Studio's **Device Emulator**, your own game, and a real device. In particular, verify the startup effect, chams and box alignment, FOV centering, camera/game compatibility, real touch hold/release, short-landscape layouts, drag-vs-tap behavior on the restore icon, respawns, closing while initialization yields, and whether your game's server accepts the intended movement.

## Native runtime validation

The shipped runtime does **not** use fake Players, simulated targets, mock HTTP, or fabricated success messages. Development doubles remain isolated under `tests/`. For actual observations, run [`diagnostics/RobloxRuntimeCheck.client.luau`](diagnostics/RobloxRuntimeCheck.client.luau) inside Roblox after the loader, and follow the [real device/two-client checklist](diagnostics/README.md). It uses real services, projection, raycasts, Highlight creation, and render callbacks—not a Node emulator. **It has not been run in Roblox/Delta here**, and does not certify rendering, aim accuracy, or server behavior.

## Small next-step ideas

Keep extras opt-in: a compact changelog or real asset preloading for your own experience. Avoid adding duplicate controls or unrelated padding to meet a line count.

## Source / build / code size

The generated standalone main is **22,264 lines**, exceeding the current **15,000-line** requirement. Its substantial +1 UI library is embedded **once as a working factory and used by the default workspace**. Existing player tools, Studio and launch flows remain functional code; there are no repeated dummy controls or unused source-string blobs to pad the count.

- Edit `src/loader.luau`, `src/ui/`, `src/games/` and `src/games/catalog.json`.
- `npm run format` formats sources and builds the main, game bundles and manifest.
- `npm run build` regenerates outputs; `npm run build:check` rejects stale generated files.
- Do not hand-edit generated `Nullx11.client.luau` or `scripts/Nullx11-*.luau`.
- Formatter/compiler/test packages are development-only and are not required by Delta or Roblox.

The fifteen standalone bundles intentionally each include the shared UI so that **selected-script-only execution is self-contained**. They do not embed other game controllers or the main client. See [source provenance](docs/SOURCE-PROVENANCE.md) before redistribution; Rosu-derived material is not for resale.

## TTK Testing / +1 Money per Click and Scripts refresh

Both supplied scripts now use Nullx11/NULL controls, with required source notices retained in the repository. **TTK Testing** includes visual/aim/weapon controls and explicit equipped-weapon discovery; **+1 Money per Click** includes exclusive World 1–4 Rebirth/Cash routing, money/rebirth/evolve and sixteen egg choices. Defaults are off. Instant ADS is explicitly unavailable because the supplied setter cannot safely restore its original spring settings; Drawing-based TTK overlays require executor support. See [source review and native boundaries](docs/TTK-MONEY-REVIEW.md).

**Workspace → Scripts** now has native reusable cards, responsive one/two-column layout, game/feature/creator search, category and exact-place filters, visible launch requirements and detail-first actions. Refresh updates the workspace too. The separate browser also has larger, clearer branded cards and compatibility labels. New original coin, rhythm and anvil vectors remain static. No fake ratings, compatibility badges or performance guarantees are used.

## Enhanced-GUI loading fix / StealAnEgg-CHILI

The opening gravity-well effect now runs with the enhanced workspace too, inside
its actual GUI host. It reveals that workspace rather than the hidden classic
launcher. Skip, readiness waiting, reduced motion and cleanup remain supported;
the restore icon stays static. Execution loading has its own higher-order GUI
so a newly opened game window does not cover the Initialize stage.

**StealAnEgg-CHILI** is the eighth entry: a **recovered-core edition**, not a full
devirtualization of the partial upload. Implemented: filtered nearby egg carry,
opt-in saved-point return, native field labels and basic away/index/base/treadmill/
trail progression. The original Steal An Egg remains separate. Unresolved VM/event/
full-steal/fuse/finder features are explicitly unavailable, not empty toggles.
See [recovery review and validation limits](docs/CHILI-EGG-REVIEW.md). No raw VM,
vendor account API, remote UI/loader, webhook or teleport queue is run. Native
Roblox/Delta rendering, FPS and server acceptance still require device testing.

## NULL collection: English Chaos and all YARHM game families

The Scripts library now includes **Universal / YARHM**, **Forsaken / YARHM**,
**Murder Mystery 2 / YARHM**, **Flee the Facility / YARHM**, **Brookhaven / YARHM**
and a separate **Brookhaven / Chaos**. Use the new **Source collection** filter
to find them. Universe/place badges are informative; confirmation and the bundle's
actual compatibility check still run before controller startup.

These are native reviewed-feature editions, **not full upstream feature parity**.
Chaos is English. NULL owner branding applies to all 14 existing/new editions.
Optional promotional UI is removed; required notices and factual provenance stay.
No ScriptBlox ingest, ad/custom-module execution or source UI loader is included.
Default-off jobs, paced requests, capped native overlays and local patch cleanup
are shared; native Roblox/Delta gameplay/touch/FPS still require validation.
See the [feature/exclusion matrix](docs/HUB-COLLECTION-REVIEW.md),
[integration status](scripts/INTEGRATION-STATUS.md) and
[client checklist](diagnostics/GAME-PORTS.md).

## Auto Player / NULL MIDI Studio

**Scripts → NULL Studio → Auto Player** opens a new animated local-piano interface.
It reads `.mid`/`.midi`/`.smf` files from
`/storage/emulated/0/Delta/Workspace/MIDI/`, with a reported `MIDI` workspace-relative
fallback if Delta blocks absolute listing. Custom folders are configurable; no
filesystem restriction is bypassed and no demo songs are inserted.

Features: searchable/paginated library, locally saved queue/favorites, a pooled piano
roll and live keyboard, tempo maps, track mixer, speed/transposition, 61/88-key
mapping, sustain, gate/velocity filters, seek, A–B loops, countdown, focus-pause,
F8 play/pause and F7 emergency stop/disarm. Input is **armed on launch** when an API is present; Play is always manual.
STOP INPUT disarms immediately. Explicit Preview sends no game input. Opening/file-load stages animate, while the
movable bottom-center piano holder keeps its graphical icon static. No raw hub, online presets or asset fetches run.

Read the [setup/features guide](docs/AUTO-PLAYER.md) and
[source/native-validation boundary](docs/MIDI-REVIEW.md). The phone path and game
key acceptance still require testing in Delta on your actual device/piano.

### Auto Player piano keys

For the supplied `1…m` piano layout, Auto Player's **Keys** tab now has 61 labeled
real-input tests, a screenshot-layout profile and explicit VIM/VK/enum backends.
Executor virtual-key values are no longer confused with Roblox enum numbers.
Arm input and confirm white/black notes in the actual game before MIDI playback.
See [the piano setup guide](docs/AUTO-PLAYER.md#matching-the-supplied-61-key-piano-screenshot).

### Auto Player redesign and saved setup

The player now shares the clean charcoal/blue design. Desktop has a song rail and piano workspace; mobile uses full-size Songs and Piano screens instead of a squeezed stacked view. Play is the primary control, Queue/Favorite have room to breathe, and loop markers live under Setup. Modern typography and quieter borders replace the previous warm/pixel styling.
The main loader centers after a real viewport is available instead of settling in
a corner. Its restore icon starts bottom-center. Auto Player has a separate movable
mini holder above it, with Open, Play/Pause and emergency Stop.

`Nullx11-AutoPlayer.json` stores the screenshot keyboard setup, input backend,
practice settings, queue/favorites, last song and player/holder placement locally.
Settings shows save status and offers **Save**, **Center**, and **Arm on launch**.
Last-song restoration loads only; it never presses Play. Missing/denied file APIs
keep a usable session-only player. Native Delta rendering and game key acceptance
still need testing on the actual phone/piano.
