# Nullx11 native brand assets

Original geometric prism and brain-circuit design references for the Gab-developed Nullx11 interface. No third-party character/emoji assets are included.

- `nullx11-prism.svg`: static dark-panel/prism reference; purple-to-cyan rim, faceted center, no letter monogram.
- `brainrot.svg`: scalable line reference for the new game entry.
- `src/ui/BrandIcons.luau`: actual native renderer for the semantic home, code, layers, play, settings, player, eye, server, egg, brain, download, bolt and info assets.
- `Draw.DrawnEmblem` in `src/ui/Nullx11UI.luau`: actual native restore/header/loading insignia.

Roblox does not natively use these SVG files as ImageLabels. The interface draws their geometric design language with Frames/UIStrokes/UIGradients; it does **not** fetch or attempt to load the SVGs at runtime. Native line thickness scales with icon size, colors bind to the theme, and icon rendering has no heartbeat/particle loop. The SVGs are reference/export assets, not a claim of a Roblox-rendered screenshot.

`coin.svg`, `rhythm.svg` and `anvil.svg` are original static export references for the added native semantic line assets. The renderer draws these paths directly; it does not fetch SVGs or animate restore icons.
