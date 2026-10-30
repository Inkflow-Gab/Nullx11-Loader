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
| Same repository `logo.png`, `logo_halloween.png` | Supplied UI's original logo assets | `assets/forge/` |
| `google/fonts/ofl/kanit/` | Kanit font authors; SIL Open Font License 1.1 | `assets/fonts/`; **retain `OFL.txt`** |

Input hashes are recorded in `docs/source-inputs.json`. Original logos/pixel motifs may include third-party character artwork; developer permission is not represented as a transfer of unrelated trademark/character rights. Nullx11 uses an N emblem as its default identity and makes no claim of original authorship of the supplied artwork.

## Adaptation changes

- Replaced remote Sirius UI with a real adapter onto the vendored +1 UI.
- Made that UI the main Nullx11 workspace, retained its full toolkit/assets, added a dark Nullx11 palette, readable text, pixel N/title styling, movable restore icons, and separate per-window identities.
- Removed rscripts telemetry and all automatic downloads of upstream UI/general loaders. Optional Thai font/theme downloads use this repository's vendored assets and are **data, not executable code**.
- Retained original game algorithms; did not fabricate alternative gameplay for missing capabilities.
- Exact-place gates and explicit, default-off selected-script-only teleport continuation; no wrong-place kick.
- Default-off automation/anti-idle; no implicit profile load that enables gameplay.
- Tracked Huss connections, stopped its polling on unload, repaired the misplaced configuration-builder invocation, and bounded dependency waits.
- Reduced Forge burst/worker defaults and routed explicit remote/bindable actions through a cancellable eight-per-second budget. This is a limit on this controller's routed calls, **not a measurement of all traffic the experience's own code can generate**. Server acceptance is not guaranteed.
- Fixed shared-library reference subscription disposal and surfaced interface-build errors.

Generated `scripts/Nullx11-*.luau` files are self-contained derivatives. `Nullx11.client.luau` is built from the loader and shared UI; it embeds the library once as working code. The build does not include tests or runtime mocks.

## Reproduction

Edit `src/`, then run `npm run format`, `npm run format:check`, and `npm test`. `tools/build.mjs` creates the main client, three bundles, and manifest deterministically. The project does not assign an unrestricted license to third-party-derived material merely by publishing generated files.
