# Game integrations

All three requested sources have been adapted and bundled. They are **real controller ports, not launch stubs**. The user supplied Rosu and +1 source files and reported permission from all three developers to modify/rebrand. Those are no longer open blockers. Original provenance and the Rosu no-resale restriction remain recorded in [SOURCE-PROVENANCE.md](../docs/SOURCE-PROVENANCE.md).

| Nullx11 workspace | Exact target place | Published file | Implementation status |
| --- | --- | --- | --- |
| Nullx11 - Rosu Mania | `9051087354` | [Nullx11-Rosu.luau](Nullx11-Rosu.luau) | Adapted note/input/timing controller; shared UI adapter; autoplay off; input-release and unload cleanup. |
| Nullx11 - hussvalley | `107535308163741` | [Nullx11-Huss.luau](Nullx11-Huss.luau) | Adapted runner/catcher/progression controller; shared UI; tracked connections; repaired configuration builder; automation off. |
| Nullx11 - +1 loot to forge | `118805555015549` | [Nullx11-Forge.luau](Nullx11-Forge.luau) | Adapted forge/gear/pet/stage/tower/session controller; full shared library; bounded requests/workers; automation off. |

## Shared foundation

`src/ui/Nullx11UI.luau` contains the supplied +1 UI library adapted to Nullx11: responsive tabs/groupboxes, controls, themes, vector/pixel art, dialogs/sheets, reactive state, spring motion, floating restore icon, configuration and language support. The default main workspace **actually constructs and uses this library**. It is embedded once as an inline function, not an unused source string. Original logos and Kanit fonts are vendored; the latter include their OFL license. The default skin uses a Nullx11 N emblem; original seasonal assets remain available through themes.

Each game bundle contains this same shared library plus **only its selected game controller**. No runtime Sirius fetch, rscripts telemetry, original general-purpose loader, or main-client execution is included. Compatibility probes are not warmed automatically.

## Launch / consent

- Three game entries are available immediately; Refresh is optional.
- Opening Scripts or a launch window is an action, never an ON/OFF switch, and runs no game code.
- Wrong-place execution is blocked. Teleport and Execute are distinct actions.
- Execute-after-joining starts off. If enabled, queueing references only the selected bundle and checks its exact place.
- Directly opening a bundle in the wrong game also creates a real teleport-consent window without starting its controller.
- Failed teleports may leave executor-queued code behind. Closing/rerunning does not claim to clear that queue.
- Default main shortcut: **Right Shift**. Default game shortcut: **Left Control**. Each has a draggable N restore icon and separate GUI identity.

## Validation boundary

**Implemented, compiled and development-tested; live Roblox/Delta validation is pending.** Tests exercise the actual adapter/session modules and non-rendering shared-library logic with isolated development fixtures. They do not emulate current game modules, server validation, native rendering, real teleports, touch hardware, or Delta.

Use [the game validation checklist](../diagnostics/GAME-PORTS.md) on an authorized client before relying on a feature. Game updates can invalidate remote/module names. Runtime errors are reported instead of substituting simulated gameplay.
