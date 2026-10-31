# Game integrations

Fifteen editions are bundled (including the new local MIDI Auto Player): the eight prior editions (including a **partial recovered core**, not a full VM port), all five actual YARHM tool/game families, and a separate English Chaos Brookhaven reviewed subset. Game coverage is complete for YARHM; feature parity is not. NULL is the current visible owner brand. They are **real controller ports, not launch stubs**. The user supplied Rosu and +1 source files and reported permission from all three developers to modify/rebrand. Those are no longer open blockers. Original provenance and the Rosu no-resale restriction remain recorded in [SOURCE-PROVENANCE.md](../docs/SOURCE-PROVENANCE.md).

| Nullx11 workspace | Exact target place | Published file | Implementation status |
| --- | --- | --- | --- |
| Nullx11 - Rosu Mania | `9051087354` | [Nullx11-Rosu.luau](Nullx11-Rosu.luau) | Adapted note/input/timing controller; shared UI adapter; autoplay off; input-release and unload cleanup. |
| Nullx11 - hussvalley | `107535308163741` | [Nullx11-Huss.luau](Nullx11-Huss.luau) | Adapted runner/catcher/progression controller; shared UI; tracked connections; repaired configuration builder; automation off. |
| Nullx11 - +1 loot to forge | `118805555015549` | [Nullx11-Forge.luau](Nullx11-Forge.luau) | Adapted forge/gear/pet/stage/tower/session controller; full shared library; bounded requests/workers; automation off. |
| Nullx11 - Steal An Egg | Core ModuleScript signature; no supplied place ID | [Nullx11-StealAnEgg.luau](Nullx11-StealAnEgg.luau) | Uploaded twelve-tab controller; local WindUI adapter; real multi-select/manual configs; cleanup on failed initialization; capped ESP; jobs off. |
| stealabrainrot | Core ModuleScript/Plots signature; no supplied place ID | [Nullx11-StealABrainrot.luau](Nullx11-StealABrainrot.luau) | Supplied recovered Chilli controller; real Nullx11 bridge; off defaults; owned work; source telemetry/upstream loaders removed. Native gameplay unverified; [review](../docs/BRAINROT-REVIEW.md). |

| TTK Testing | MercPlayers / GunController + CameraController ModuleScript signature | [Nullx11-TTKTesting.luau](Nullx11-TTKTesting.luau) | Real visual/aim/weapon controls; explicit capped discovery; reversible owned patches. Drawing-dependent overlays; irreversible Instant ADS explicitly unavailable. |
| +1 Money per Click | Source remote/class signature; no supplied place ID | [Nullx11-MoneyPerClick.luau](Nullx11-MoneyPerClick.luau) | World 1–4 exclusive smart routes; money/rebirth/evolve; all 16 eggs; bounded fair dispatcher and independent cleanup. |

| StealAnEgg-CHILI | EggState / Save / Assets modules + Networking signature | [Nullx11-StealAnEgg-CHILI.luau](Nullx11-StealAnEgg-CHILI.luau) | **Recovered core only**: nearby carry/filter/labels, explicit saved-point return and basic progression. VM-dependent full steal/events/finder unavailable. [Recovery boundary](../docs/CHILI-EGG-REVIEW.md). |

## Shared foundation

`src/ui/Nullx11UI.luau` contains the supplied +1 UI library adapted to Nullx11: responsive tabs/groupboxes, controls, themes, vector/pixel art, dialogs/sheets, reactive state, spring motion, floating restore icon, configuration and language support. The default main workspace **actually constructs and uses this library**. It is embedded once as an inline function, not an unused source string. Mario logo assets/character sprites were removed. Header/restore branding is a static native geometric prism, not an animated icon or letter. Kanit fonts retain their OFL license. Seasonal decoration and particles default off.

Each game bundle contains this same shared library plus **only its selected game controller**. No runtime Sirius fetch, rscripts telemetry, original general-purpose loader, or main-client execution is included. Compatibility probes are not warmed automatically.

## Launch / consent

- Fifteen game/tool entries are available immediately; Refresh is optional.
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

## Chaos / YARHM additions

| Edition | Compatibility | Published file | Reviewed feature scope |
| --- | --- | --- | --- |
| Universal / YARHM | Explicit universal execution | `Nullx11-Universal-YARHM.luau` | Local movement/flight, selected camera/aim, ESP/lighting, saved navigation |
| Forsaken / YARHM | Universe `6331902150` | `Nullx11-Forsaken.luau` | Player/item/generator ESP, cooldown-controlled generator request, reversible sprint/stamina |
| Murder Mystery 2 / YARHM | Universe `66654135` | `Nullx11-MM2.luau` | Roles/gun/traps, supplied sheriff/knife paths, coin route and navigation |
| Flee the Facility / YARHM | Universe `372226183` | `Nullx11-FleeTheFacility.luau` | Players/PC/pod/exit/tagged-locker ESP, flashlight, camera and speed |
| Brookhaven / YARHM | Place `4924922222` | `Nullx11-Brookhaven-YARHM.luau` | Avatar, items/effects, own house/car, 22 locations, local movement |
| Brookhaven / Chaos | Place `4924922222`, separate scope | `Nullx11-Brookhaven-Chaos.luau` | English Brookhaven subset plus source body/hair RGB; not full Chaos parity |

No ads, external source-loader execution or final ScriptBlox ingest. Read
[the inclusion/exclusion matrix](../docs/HUB-COLLECTION-REVIEW.md), especially
FTF's unavailable broken global anti-error hook and the omitted destructive/spam
routines. Local contracts pass under doubles, not live Roblox validation.
The library now has collection and universe/Universal-aware filters and badges.

## Auto Player / NULL Studio

`Nullx11-AutoPlayer.luau` is an explicit universal local-piano tool, not a specific
game-remote port. Custom native opening/loading UI; Android/relative MIDI folder;
bounded SMF decode; manual-play keyboard output; track/tempo/practice/queue tools.
Input is armed on launch when an API exists; STOP disarms and Arm on launch can be disabled.
The redesigned centered player/mini holder persists a validated local JSON setup. File access/key simulation depend on Delta permissions and
the game's actual mapping. [Guide](../docs/AUTO-PLAYER.md),
[review](../docs/MIDI-REVIEW.md). Local contracts compile/pass under doubles;
native visuals/gameplay/device filesystem/touch remain unverified.
