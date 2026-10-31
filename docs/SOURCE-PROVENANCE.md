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
| User upload `StealB.deobfuscated.lua.txt` (2026-10-31) | Recovered Chilli controller; no recovery README/license grant supplied | `src/games/StealABrainrot.luau`; [review](BRAINROT-REVIEW.md) |
| User upload `dollaropen-sourcedollar-ttk-testing-…txt` (2026-10-31) | Original author unspecified; upstream VibeUI replaced | `src/games/TTKTesting.luau`; [review](TTK-MONEY-REVIEW.md) |
| User upload `smart-farmingopen-source_…txt` (2026-10-31) | VoidScripts / VoidScriptsDK | `src/games/MoneyPerClick.luau`, `MoneyData.luau`; [review](TTK-MONEY-REVIEW.md) |
| User upload `steal.partial-decoded.lua.txt` (2026-10-31) | Partial Chilli SAE recovery; complete author/license/recovery README unspecified | `src/games/StealAnEggChili.luau`, `ChiliEggPolicy.luau`; **recovered core only**, [review](CHILI-EGG-REVIEW.md) |
| `google/fonts/ofl/kanit/` | Kanit font authors; SIL Open Font License 1.1 | `assets/fonts/`; **retain `OFL.txt`** |

Input hashes are recorded in `docs/source-inputs.json`. Historical source-logo hashes are retained for provenance only; those files and their runtime references were removed at the user's request. Nullx11 now uses a static geometric prism and neutral symbols, not Mario artwork or a letter monogram. NULL is the current visible owner/edition brand; factual source authorship and required notices remain retained, not erased by rebranding. The Steal An Egg upload does not supply a separate blanket license; this adaptation does not invent one.

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

Edit `src/`, then run `npm run format`, `npm run format:check`, and `npm test`. `tools/build.mjs` creates the main client, eight bundles, and manifest deterministically. The project does not assign an unrestricted license to third-party-derived material merely by publishing generated files.

## Original Nullx11 assets and execution UI

Gab's Nullx11 integration now includes native semantic line icons (`src/ui/BrandIcons.luau`), static prism SVG references under `assets/brand/`, an event-driven execution view and a monotonic execution-stage model. These additions are distinct from the attributed supplied UI/controller implementations. There is no claim that an SVG design reference is a native Roblox screenshot or an unrestricted license to unrelated source material.

## TTK / Money additions

The two latest uploads are adapted onto the same Nullx11/Gab controls without VibeUI/Rayfield execution. Source credits remain in the catalog, controllers and review. TTK game telemetry suppression is removed; irreversible Instant ADS is explicitly unavailable. Money uses exclusive movement modes, source routing/egg data and bounded default-off jobs. Read [the detailed review and native validation limits](TTK-MONEY-REVIEW.md) before use or redistribution.

## Partial SAE/CHILI input

StealAnEgg-CHILI is an independent recovered-core entry, not a rename/replacement of Henrik/xyzhenrik Steal An Egg and not a full devirtualization. The raw VM/vendor bootstrap is never executed or distributed. Read [the exact implemented/unavailable feature boundary](CHILI-EGG-REVIEW.md); publishing this adaptation does not create a new license grant.

## Chaos / YARHM collection (2026-10-31)

The user reports permission from both source owners to adapt/rebrand these uploads,
and says their YARHM friend does not want optional promotional credit. This report
is not independent verification of a copyright transfer. The native editions use
NULL owner branding; **© Aetherion 2026** source notices and the supplied header's
`https://mhi.im/tos` reference remain recorded. Chaos's supplied UI named
Luscaa/venom. Raw uploads are not shipped or executed.

| Input | Derived implementation | Scope |
| --- | --- | --- |
| `Chaos_Hub_Open_Source.txt` | `HubBrookhaven.luau`, common policy/runtime/data | Separate English Chaos Brookhaven reviewed subset; destructive/spam/external-loader routines excluded |
| `YARHM_Hub_KEYLESS_2026.txt` | `HubUniversal`, `HubForsaken`, `HubMM2`, `HubFTF`, `HubBrookhaven`, common `Hub*` helpers | All actual game families represented, **not complete feature parity**; ads/custom loaders/final ScriptBlox ingest excluded |

See [the precise feature/exclusion matrix and test boundary](HUB-COLLECTION-REVIEW.md).
These are not independent clean-room copyright claims or a new blanket license.
Optional runtime promotions are removed; Rosu/source restrictions and font OFL
notices are retained. All previous game bundles remain available.

## Local piano / Auto Player (2026-10-31)

User upload `RoMidiFull.lua.txt` informed the virtual-piano mapping and local SMF
workflow. Original explicit author/license unspecified in the upload; source repo
references and implementation changes are recorded in [MIDI-REVIEW.md](MIDI-REVIEW.md).
NULL is the edition/developer brand, not an invented copyright assignment of the
upload or songs. New decoder/runtime/UI replace the raw hub; remote preset,
announcement, asset and uploader systems are not executed. No MIDI is uploaded
or written. [Setup and native limitations](AUTO-PLAYER.md).
