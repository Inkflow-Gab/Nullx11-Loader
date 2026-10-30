# Source provenance and permissions

## Authorization record

On 2026-10-30 the user supplied the Rosu and +1 controller files and explicitly stated they obtained permission from all three developers to modify, rebrand, and use the +1 UI/assets in Nullx11. This adaptation proceeds on that reported authorization; it is not a claim of independent verification or a new blanket open-source license. The original authors' contributions remain acknowledged here and in source headers.

**Do not resell the Rosu-derived script.** Its supplied notice permits adaptation/LLM use but explicitly prohibits selling a script pasted from it. That restriction remains in `src/games/Rosu.luau` and the generated bundle. Additional rights would require an appropriate separate grant; rebranding alone does not remove restrictions.

## Inputs and derived files

| Input | Original attribution/source | Adapted source |
| --- | --- | --- |
| User upload `open-source-autoplayer-yvetzalhub_1790657706332_LjcKmjXcCh.txt` | Yvetzal Rosu; Wyrizon / Infernum references in original UI | `src/games/Rosu.luau` |
| GitHub `wyrizon/hussvalley/main.lua` | Wyrizon and the Yvetzal Team | `src/games/Huss.luau` |
| User upload `+1.txt` | xDTaraZ / Mario Hub, Loot To Forge | `src/games/Forge.luau` |
| GitHub `xDTaraZz/Roblox-Scripts/ui.lua` | xDTaraZ's +1 UI library, source build 2026-10-14 | `src/ui/Nullx11UI.luau` |
| User upload `Main.luau.txt` (2026-10-31) | Henrik / xyzhenrik, Silence Steal An Egg | `src/games/StealAnEgg.luau` |
| `google/fonts/ofl/kanit/` | Kanit font authors; SIL Open Font License 1.1 | `assets/fonts/`; **retain `OFL.txt`** |

Input hashes are recorded in `docs/source-inputs.json`. Historical source-logo hashes are retained for provenance only; those files and their runtime references were removed at the user's request. Nullx11 now uses a static geometric prism and neutral symbols, not Mario artwork or a letter monogram. Gab is credited as the Nullx11 developer; original controller/UI authorship remains credited, not reassigned. The Steal An Egg upload does not supply a separate blanket license; this adaptation does not invent one.

## Adaptation changes

- Replaced remote Sirius UI with a real adapter onto the vendored +1 UI.
- Made that UI the main Nullx11 workspace, retained its toolkit, added a dark Nullx11 palette, readable text, static geometric prism/title styling, movable restore icons, and separate per-window identities.
- Removed rscripts telemetry and all automatic downloads of upstream UI/general loaders. Optional Thai font downloads use this repository's vendored assets and are **data, not executable code**.
- Retained original game algorithms; did not fabricate alternative gameplay for missing capabilities.
- Exact-place gates for the original three ports; a structural ModuleScript gate for Steal An Egg (no supplied place ID). Unsupported-game notices never offer/perform/queue launcher teleportation; no wrong-place kick.
- Default-off automation/anti-idle; no implicit profile load that enables gameplay.
- Tracked Huss connections, stopped its polling on unload, repaired the misplaced configuration-builder invocation, and bounded dependency waits.
- Reduced Forge burst/worker defaults and routed explicit remote/bindable actions through a cancellable eight-per-second budget. This is a limit on this controller's routed calls, **not a measurement of all traffic the experience's own code can generate**. Server acceptance is not guaranteed.
- Fixed shared-library reference subscription disposal and surfaced interface-build errors.
- Ported the supplied Steal An Egg controller onto a local WindUI-shaped adapter with real multi-select/configuration controls; removed its remote UI dependency and unsupported configuration autoload control, repaired failure cleanup and bounded overlay allocation.
- Isolated loader cleanup from game-session ownership: ordinary loader unload/rerun leaves executed games running. Kept explicit game unload controls.
- Removed restore-icon animation and shipped Mario logos/character sprites; disabled idle decoration/particles by default, reused FPS sampling, and reduced hidden/unchanged UI work.

Generated `scripts/Nullx11-*.luau` files are self-contained derivatives. `Nullx11.client.luau` is built from the loader and shared UI; it embeds the library once as working code. The build does not include tests or runtime mocks.

## Reproduction

Edit `src/`, then run `npm run format`, `npm run format:check`, and `npm test`. `tools/build.mjs` creates the main client, four bundles, and manifest deterministically. The project does not assign an unrestricted license to third-party-derived material merely by publishing generated files.
