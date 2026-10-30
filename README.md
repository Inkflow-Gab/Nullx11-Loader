# Nullx11

A standalone, mobile-friendly Roblox client workspace: layered charcoal surfaces, gradient accents, an original cut-stroke **N** dock, and a monospace glitch-animated title. No uploaded images, UI libraries, keys, or extra ModuleScripts are needed for the built-in tools.

## Run the full script

### External runtime / Delta

Copy the **entire contents** of [`Nullx11.client.luau`](Nullx11.client.luau) into your runtime's script editor and execute it while joined to an experience. Tap **Load** to open the tools.

The client has no dependency on an executor's `script` global or custom GUI-parenting APIs. It uses `Players.LocalPlayer.PlayerGui`, normal Roblox input events, and standard character APIs. This is compatibility-oriented implementation, **not a claim of testing in Delta**. Runtime versions and individual games may behave differently. Use only where you have permission, such as your own experience.

### Roblox Studio

1. Insert a **LocalScript** in **StarterPlayer → StarterPlayerScripts**.
2. Paste in `Nullx11.client.luau`.
3. Press **Play**, then tap **Load**.

No external executor or `loadstring` is needed in Studio. With Rojo, map the `.client.luau` file into `StarterPlayerScripts`.

## Features

| Control | Behavior |
| --- | --- |
| **Load** | Opens the built-in tools after the game is ready. Also initializes an optional Studio `App` module. |
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
| **Hide floating utilities** | Hide teleport, FPS, and coordinate panels and synchronize their toggles. |
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
- The FPS meter and title share one render connection. No GUI instances are allocated each frame.
- Animated pill switches include an ON/OFF text label, so state does not rely on color alone. Theme changes refresh switch accents as well.
- No full-screen dimmer intercepts gameplay outside the windows.

## Customize / reduced motion

Edit `CONFIG` near the top of the client:

```lua
local CONFIG = {
    Name = "Nullx11",
    Subtitle = "A quieter way to get started.",
    Accent = Color3.fromRGB(167, 146, 255),
    ReducedMotion = false,
}
```

Set `ReducedMotion = true` for a motion-free default. The Style tab can change it during a run; enabling it also switches the glitch toggle off. This is an explicit setting, not automatic OS preference detection. Other colors live in the `colors` table.

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
npm ci
npm test
```

The checks compile both Luau files and exercise deterministic API mocks for loading, tabs, themes, scaling, window locking, hotkey input filtering, live coordinates, independent bookmarks, Unicode name sanitization, live distance, animated switch states, FPS history capacity/reset/no-instance-allocation, dock edge-snapping/rotation, confirmation/recovery actions, spawn/seat guards, cooldowns, respawn, FPS sampling, reduced motion, glitch reset, dragging, resize, closing, rerunning, initializer retry, and execution without a `script` instance. Bootstrap checks cover missing capabilities, download/compile failure, and startup. GitHub Actions runs the same checks for pushes and PRs.

These mocks do not emulate Roblox physics, rendering, real touch input, or Delta. Test in Studio's **Device Emulator**, your own game, and a real device. In particular, verify short-landscape layouts, drag-vs-tap behavior on the restore icon, respawns, closing while initialization yields, and whether your game's server accepts the intended movement.

## Small next-step ideas

Keep extras opt-in: a compact changelog or real asset preloading for your own experience. Avoid cluttering the loader with unrelated gameplay controls.

## Code size

The client is intentionally kept around a thousand meaningful lines rather than inflated to 20,000 lines. The project prioritizes real behavior, shared helpers, cleanup, and reproducible tests over line-count padding. No generated filler or bundled third-party UI framework is included.
