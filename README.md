# Nullx11

A standalone, mobile-friendly Roblox client workspace: layered charcoal surfaces, gradient accents, an original cut-stroke **N** dock, and a monospace glitch-animated title. No uploaded images, UI libraries, keys, or extra ModuleScripts are needed for the built-in tools.

## Run the full script

### External runtime / Delta

Copy the **entire contents** of [`Nullx11.client.luau`](Nullx11.client.luau) into your runtime's script editor and execute it while joined to an experience. The opening whirlpool contracts, bursts outward, and reveals the launcher. Tap **Skip animation** to bypass it, then **Load** to open the tools.

The client has no dependency on an executor's `script` global or custom GUI-parenting APIs. It uses `Players.LocalPlayer.PlayerGui`, normal Roblox input events, and standard character APIs. This is compatibility-oriented implementation, **not a claim of testing in Delta**. Runtime versions and individual games may behave differently. Use only where you have permission, such as your own experience.

### Roblox Studio

1. Insert a **LocalScript** in **StarterPlayer → StarterPlayerScripts**.
2. Paste in `Nullx11.client.luau`.
3. Press **Play**, then tap **Load**.

No external executor or `loadstring` is needed in Studio. With Rojo, map the `.client.luau` file into `StarterPlayerScripts`.

## Features

| Control | Behavior |
| --- | --- |
| **Startup reveal** | A 24-particle whirlpool contracts into the center, then bursts to reveal the GUI. Skip is always available; reduced-motion defaults bypass it. |
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
| **Hide floating utilities** | Hide teleport, FPS, coordinate, Visuals, and Aim panels; disable player visuals, camera assist, and the FOV circle; synchronize toggles. |
| **Clear all bookmarks** | Tap twice within three seconds to confirm deletion. |
| **Dock / Right Shift** | Toggle the dashboard. The dock is always visible until the GUI is closed; dragging it does not activate it. Right Shift is ignored while typing or when Roblox already processed the input. |
| **− on main panel** | Hide the dashboard. Enabled floating tools and the dock remain visible. |
| **×** | Closes everything and disconnects the input and rendering listeners. |

### Teleport limits

- **Three independent bookmark slots per running session**, held in memory. Select a slot before saving or teleporting. Each slot survives a character respawn, but is cleared by closing/rerunning the loader or leaving the game. It is not saved to disk or a DataStore.
- Saving and teleporting require a spawned, living character with a root part. Leave your seat before teleporting. Repeated teleports have a short cooldown.
- This uses **local `Model:PivotTo` movement**. It does not grant server permissions, change other players, switch servers, or bypass server validation. A game can reject or reset the movement. The message “local movement” means the local call completed, **not** that a server accepted it.
- Saved spots are not checked for hazards or obstacles. Use safe destinations.
- If this is a feature in your published experience, authorize and validate teleports on the server. Do not trust client-supplied positions for authoritative gameplay.

## Player Visuals and Aim

Open **Load → Tools → Visuals window** or **Aim window**. These are independent, lazy-built windows with draggable headers, hide buttons, scrollable controls, and responsive sizes up to 350 × 500. Opening a window does **not** enable its effects. The windows reuse their controls when reopened, and inherit applicable Design Studio styling even if created after Studio.

### Visuals

- Master enable; independently switch **player chams, bounding boxes, bottom-center tracer lines, display names, health bars, and camera distance**.
- Team filtering and line-of-sight filtering start enabled. **Through walls** is an explicit visual-only option, not the default.
- Choose Violet, Mint, Cyan, Red, or White; range **250–3,000 studs** (default 1,000); overlay refresh **15–60 Hz** (default 30). Numeric fields accept bounded whole numbers, with −/+ controls.
- Works with other `Players` whose live character has a Humanoid and HumanoidRootPart. It does not identify NPCs, custom actor systems, or server-only objects.
- At most **32 players are drawn simultaneously**, prioritized by camera distance. Up to **24 pooled Highlight instances** are reused; disabling chams or visuals frees those Highlight slots. The experience's own renderer limits can still affect visibility. Per-player 2D widgets are created when needed, reused, and destroyed when that player leaves.
- Occlusion checks are capped at **48 rays per visual refresh**. On crowded, heavily occluded servers this can omit farther visible players rather than perform unbounded raycasts.

### Aim / centered FOV

- Enable **Show FOV circle** independently of camera assist. It stays centered on the current camera viewport, including after camera replacement/orientation changes. Radius **50–400 pixels** (default 140), with its own five-color selector; this does not change the camera's FieldOfView property.
- Enable aim, then **hold right mouse** on desktop, or **HOLD AIM** on the touch pad. Release stops tracking. Drag the pad using its separate header; mobile-pad visibility is configurable.
- **Strength accepts every whole number from 1 to 100**, by typing or −/+. Default 50 uses time-based smoothing; **100 snaps the local camera directly to the selected target**. A dedicated strength-100 button is included.
- Choose Head or Root, team filtering, and a **250–3,000-stud** range. It picks the closest eligible target to the viewport center within the radius. Aim always requires line of sight, including when visual through-walls mode is enabled; at most eight candidate raycasts run per frame.
- Typing, processed/own-window mouse presses, scripted cameras, and a missing/dead local avatar prevent tracking. Losing window focus clears the held input. Move or minimize panels to uncover the center circle before aiming.
- This is **local camera steering only**: no auto-fire, weapon remotes, projectile redirection, hit registration changes, or server bypass. Games with custom rigs, cameras, or weapon aim rules may behave differently; “universal” is not a guarantee of compatibility with every experience.

### Disable / cleanup / persistence

Press **End** while not typing, or use **Disable visuals, aim, and circle** at the top of either window. This disables all three effects, removes Highlights, hides overlays, clears held input, and unbinds their camera-step callback. Hiding an individual settings window does not disable its effects. **Session → Hide floating utilities** also disables player tools and hides their settings. Closing the main GUI destroys the independent overlay screen, Highlight pool, and listeners. Re-execution replaces the previous instance.

Player-tool options are **session-only**, separate from Design Studio's appearance profiles/JSON. They do not auto-enable or load previous targets on execution.

## Startup animation

The decorative reveal uses 24 precreated particles, approximately **0.95 seconds of inward spiral** followed by a **0.4-second outward burst**. If `game:IsLoaded()` is false, it honestly says it is waiting; no fake percentage or asset progress is shown. Skip remains available while waiting. Completing, skipping, rerunning, or closing disconnects the temporary animation callback. Short landscape screens move labels away from the bottom skip button.

Set `CONFIG.StartupAnimation = false` to skip the decoration, or `CONFIG.ReducedMotion = true` to bypass it and disable other motion by default. The animation plays once per execution, not whenever a window is reopened. It is independent of the optional App initializer invoked by Load.

## Optional loadstring launcher

[`bootstrap.luau`](bootstrap.luau) is a small launcher for a runtime that provides **both** client `loadstring` and `game:HttpGet`. Standard Roblox LocalScripts do not provide these capabilities.

The launcher targets the public PR branch `arena/d92ad2cf-nullx11-loader`. Its source is separate from `main`; merging the PR is not required to load this branch version. Download failures are reported by the bootstrap.

For a short launcher targeting the PR branch:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/d92ad2cf-nullx11-loader/Nullx11.client.luau"))()
```

Or execute `bootstrap.luau` to get clearer download/compile/startup errors; change `SOURCE_URL` if you host your own reviewed copy. Its current URL targets the session's fixed branch `arena/d92ad2cf-nullx11-loader`, not `main`. Do not assume a file exists on `main` until it is actually merged there.

Remote code runs with the capabilities of your runtime. Review the source; ideally pin the raw URL to a reviewed commit SHA rather than a mutable branch. No auto-update or hidden network requests are included in the full client script.

## Design / mobile behavior

- Original N monogram drawn from three rounded strokes and a signature cut; no asset upload required. A gradient-backed dock, small status dot, and matching header/position icons establish the visual identity.
- A 440 × 360 launch panel expands to a dashboard up to 440 × 520. Short screens use shorter, scrollable pages instead of shrinking the entire dashboard. Position panel: 320 × 362; FPS meter: 132 × 64; coordinate HUD: 224 × 48; dock: 60 × 60, before applicable responsive scaling.
- Safe-area positioning, portrait/landscape resizing, touch/mouse dragging, edge clamping, and 44-pixel header controls before short-screen scaling.
- Normal Roblox gamepad button selection/activation; dragging uses touch or mouse.
- UI persists across respawns; rerunning replaces the prior GUI and disconnects its listeners.
- The FPS meter and title share one render connection and allocate no GUI instances per frame. Player effects use a separate after-camera callback only while needed, with lazily built, reusable widgets and bounded raycasts.
- Animated pill switches include an ON/OFF text label, so state does not rely on color alone. Theme changes refresh switch accents as well.
- After the skippable startup reveal, no full-screen dimmer intercepts gameplay outside the windows.

## Customize / reduced motion

Edit `CONFIG` near the top of the client:

```lua
local CONFIG = {
    Name = "Nullx11",
    Subtitle = "A quieter way to get started.",
    Accent = Color3.fromRGB(167, 146, 255),
    ReducedMotion = false,
    StartupAnimation = true,
}
```

Set `ReducedMotion = true` for a motion-free default. The Style tab can change it during a run; enabling it also switches the glitch toggle off. This is an explicit setting, not automatic OS preference detection. Other colors live in the `colors` table.

## Design Studio

Open **Load → Style → Open Design Studio**. The main executor script contains the entire editor; no additional files or modules are needed. Its controls are created once, on first use. Closing Studio hides it; closing the main loader destroys it.

### Six searchable categories

- **Color:** twelve accent presets, custom RGB, three/six-digit hex input, a tint/shade ladder, hue/complement adjustments, gradients, panel/dock opacity, corner roundness, borders, and an opaque-color contrast reference.
- **Type:** built-in body fonts, technical monospace preservation, text scaling, brighter secondary text, focus outlines, larger setting-row controls, descriptions, and header/footer/status visibility. A real text preview updates with the settings.
- **Layout:** preferred dashboard dimensions, interface scale, dock size/shape/monogram, caption/dot visibility, snapping, locking, alternate dashboard hotkeys, HUD width/precision, editor dimensions, arrangements, and a live normalized window map.
- **Motion:** reduced motion, easing/duration, bounded title-glitch controls, FPS graph visibility, and instrument sample windows. Five motion recipes provide quick starting points. Reduced motion takes priority over glitch requests.
- **Profiles:** eight design recipes, three named in-memory design slots, comparison against saved/default values, a settings inspector, bounded history, and JSON transfer.
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

**Generate JSON** writes a versioned appearance object into a scrollable text field. Select/copy it manually; the script never silently writes files or uses executor clipboard APIs. Paste it back and choose **Validate and import** to restore it.

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
npm run format:check
npm test
```

The checks compile both Luau files and exercise deterministic API mocks for loading, tabs, themes, scaling, window locking, hotkey input filtering, live coordinates, independent bookmarks, Unicode name sanitization, live distance, animated switch states, FPS history capacity/reset/no-instance-allocation, dock edge-snapping/rotation, confirmation/recovery actions, spawn/seat guards, cooldowns, respawn, FPS sampling, reduced motion, glitch reset, dragging, resize, closing, rerunning, initializer retry, and execution without a `script` instance. Player-tool tests cover separate/reused windows, team/visibility/death filters, bounding boxes/chams/tracers, editable numeric limits, FOV placement/color, smoothing versus strength-100 snap, hold/release and input guards, touch-pad input, camera replacement/loss, respawns, crowded-server ray/instance caps, emergency off, and teardown. Startup tests cover contraction/burst/reveal, actual readiness waiting, skip, short landscape positioning, reduced motion, rerun, and closing during animation. The Design Studio suite additionally checks lazy construction/reuse, preferences, palette/hex math, custom RGB, search, typography, motion priority, resize/locking, bounded history, quick-control synchronization, saved designs, settings validation, shortcuts, and editor safe-area clamping. Its JSON codec is mocked: tests exercise validation and transfer flow, not Roblox’s JSON parser. Bootstrap checks cover missing capabilities, download/compile failure, and startup. GitHub Actions runs formatting and the same checks for pushes and PRs. `npm run format` applies the pinned StyLua configuration.

These mocks do not emulate Roblox physics, rendering, real touch input, or Delta. Test in Studio's **Device Emulator**, your own game, and a real device. In particular, verify the startup effect, chams and box alignment, FOV centering, camera/game compatibility, real touch hold/release, short-landscape layouts, drag-vs-tap behavior on the restore icon, respawns, closing while initialization yields, and whether your game's server accepts the intended movement.

## Small next-step ideas

Keep extras opt-in: a compact changelog or real asset preloading for your own experience. Avoid adding duplicate controls or unrelated padding to meet a line count.

## Code size

The standalone main script is **6,571 lines**, including the inline Design Studio, separate Visuals/Aim tools, startup reveal, and consistent 80-column formatting. **The requested 20,000-line target is not reached**: the implementation adds functional features rather than duplicate handlers or filler. No third-party GUI framework is bundled. Development-only formatter and test dependencies are not required by the executor.
