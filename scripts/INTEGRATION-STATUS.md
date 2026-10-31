# Game integrations

All seven supplied sources have been adapted and bundled. They are **real controller ports, not launch stubs**. The user supplied Rosu and +1 source files and reported permission from all three developers to modify/rebrand. Those are no longer open blockers. Original provenance and the Rosu no-resale restriction remain recorded in [SOURCE-PROVENANCE.md](../docs/SOURCE-PROVENANCE.md).

| Nullx11 workspace | Exact target place | Published file | Implementation status |
| --- | --- | --- | --- |
| Nullx11 - Rosu Mania | `9051087354` | [Nullx11-Rosu.luau](Nullx11-Rosu.luau) | Adapted note/input/timing controller; shared UI adapter; autoplay off; input-release and unload cleanup. |
| Nullx11 - hussvalley | `107535308163741` | [Nullx11-Huss.luau](Nullx11-Huss.luau) | Adapted runner/catcher/progression controller; shared UI; tracked connections; repaired configuration builder; automation off. |
| Nullx11 - +1 loot to forge | `118805555015549` | [Nullx11-Forge.luau](Nullx11-Forge.luau) | Adapted forge/gear/pet/stage/tower/session controller; full shared library; bounded requests/workers; automation off. |
| Nullx11 - Steal An Egg | Core ModuleScript signature; no supplied place ID | [Nullx11-StealAnEgg.luau](Nullx11-StealAnEgg.luau) | Uploaded twelve-tab controller; local WindUI adapter; real multi-select/manual configs; cleanup on failed initialization; capped ESP; jobs off. |
| stealabrainrot | Core ModuleScript/Plots signature; no supplied place ID | [Nullx11-StealABrainrot.luau](Nullx11-StealABrainrot.luau) | Supplied recovered Chilli controller; real Nullx11 bridge; off defaults; owned work; source telemetry/upstream loaders removed. Native gameplay unverified; [review](../docs/BRAINROT-REVIEW.md). |

| TTK Testing | MercPlayers / GunController + CameraController ModuleScript signature | [Nullx11-TTKTesting.luau](Nullx11-TTKTesting.luau) | Real visual/aim/weapon controls; explicit capped discovery; reversible owned patches. Drawing-dependent overlays; irreversible Instant ADS explicitly unavailable. |
| +1 Money per Click | Source remote/class signature; no supplied place ID | [Nullx11-MoneyPerClick.luau](Nullx11-MoneyPerClick.luau) | World 1–4 exclusive smart routes; money/rebirth/evolve; all 16 eggs; bounded fair dispatcher and independent cleanup. |

## Shared foundation

`src/ui/Nullx11UI.luau` contains the supplied +1 UI library adapted to Nullx11: responsive tabs/groupboxes, controls, themes, vector/pixel art, dialogs/sheets, reactive state, spring motion, floating restore icon, configuration and language support. The default main workspace **actually constructs and uses this library**. It is embedded once as an inline function, not an unused source string. Mario logo assets/character sprites were removed. Header/restore branding is a static native geometric prism, not an animated icon or letter. Kanit fonts retain their OFL license. Seasonal decoration and particles default off.

Each game bundle contains this same shared library plus **only its selected game controller**. No runtime Sirius fetch, rscripts telemetry, original general-purpose loader, or main-client execution is included. Compatibility probes are not warmed automatically.

## Launch / consent

- Seven game entries are available immediately; Refresh is optional.
- Scripts/launch windows are opening actions, never ON/OFF navigation. Opening them runs no game code.
- Wrong-place execution is blocked for the three known targets. Steal An Egg uses structural core-module detection and full required-module validation, not a fabricated place ID.
- Launcher teleport questions, destination teleports and arrival queues have been removed. Standalone incompatibility UI offers only a notice and Close.
- Default shortcuts: **Right Shift** for the loader, **Left Control** for game windows. Each has an independently movable static graphical restore icon.
- **Loader unload/rerun does not stop executed scripts.** Each game has its own cleanup; the separate confirmed stop-games action remains explicit.
- Steal An Egg configuration autoload is intentionally not offered. Manual config load/save/delete is real and reports missing filesystem capabilities.
- Idle work is reduced, but zero FPS drops are not guaranteed. Games intentionally continue their own work after loader unload.

## Validation boundary

**Implemented, compiled and development-tested; live Roblox/Delta validation is pending.** Tests exercise the actual adapter/session modules and non-rendering shared-library logic with isolated development fixtures. They do not emulate current game modules, server validation, native rendering, real teleports, touch hardware, or Delta.

Use [the game validation checklist](../diagnostics/GAME-PORTS.md) on an authorized client before relying on a feature. Game updates can invalidate remote/module names. Runtime errors are reported instead of substituting simulated gameplay.

## Latest additions and library

See [TTK/Money review](../docs/TTK-MONEY-REVIEW.md) for preserved source data, removed telemetry hook, Instant ADS boundary, request limits and native test checklist. The main Scripts page now has responsive reusable game cards, category/place filters and game/feature/creator search; the separate browser has larger branded cards and clearer launch/compatibility labels.
