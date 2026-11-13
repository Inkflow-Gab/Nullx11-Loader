# stealabrainrot: supplied-source review

## Input and implementation

User supplied `StealB.deobfuscated.lua.txt` on 2026-10-31 (19,412 lines). Its header describes an analysis/recovered artifact and refers to a recovery README that was **not supplied**. Input SHA-256/size are recorded in `source-inputs.json`. The uploaded code was inspected and compiled, not executed in the development sandbox. It is not treated as a verified original release or a new license grant.

The catalog entry is named **stealabrainrot**. `src/games/StealABrainrot.luau` retains the supplied stealer/helper/player/ESP/notification/server algorithms, with the changes below; `src/ui/ChilliAdapter.luau` maps its control API onto the embedded Nullx11 GUI. The generated standalone bundle includes only this controller, the shared toolkit and its lifecycle/adapter dependencies. No Chilli GUI is downloaded or executed.

No place ID was present in the input. Before controller startup the bundle checks `ReplicatedStorage.Datas.Animals` and `ReplicatedStorage.Packages.PlayerMouse` are ModuleScripts and `workspace.Plots` exists. This is a compatibility signature, **not proof of current game/version compatibility or server acceptance**. Module errors remain visible. The original indefinite PlayerMouse dependency waits are bounded.

## Removed before publication

- The input's remote Chilli Library bootstrap and encoded bootstrap argument.
- The **entire** webhook reporting block, including player-identifying metadata, reading old Chilli configuration files, multipart attachment construction and outbound POSTs. Removing only its already-redacted URL would not have been sufficient.
- The original default-on teleport autoload switch, queue lookup, queued upstream Chilli loader and its teleport-setting flags. Explicit user-initiated same-game hop/rejoin/Job-ID actions remain, without automatic script continuation.
- The Chilli quick-bar/keybind installer and its startup profile defaults. They are not simulated by dummy state or represented as available. Nullx11's real controls/settings and manual configuration are used instead; auxiliary panel position refs are session-local.
- An unconditional startup `BlockTools` attribute-clearing listener. Opening the interface must not silently install that bypass.

No webhook credential is published. The source contains no executor request API, remote `loadstring`, old configuration-file read or queued general loader. Its remaining HTTP request is the existing explicit public-server list lookup for a user-initiated server hop.

## Ownership and defaults

- Every remaining source signal subscription (200) is tracked and guarded, and the named render binding is scoped. Spawn/defer/delay workers wait until controls have been finalized off, and are cancelled on this game's unload.
- Newly created source Instances are owned by this game only. Nine source cleanup-event callbacks are also registered directly, so restoration does not depend on Roblox delivering BindableEvent/Destroying callbacks synchronously. Source toggles are stopped before restorers, listeners, render bindings and Instances are disposed.
- Re-execution replaces only the existing `stealabrainrot` session. **Loader unload/rerun leaves executed games running**, as before.
- All toggles default off, including the supplied default-on automation, camera assist, ESP, reset, overlay and anti-idle options. No gameplay configuration is autoloaded.
- Sliders support real range updates and unit selectors; dropdowns support refresh/multi-selection; callback-suppressed `Set` is implemented rather than ignored. Parent-dependent controls use actual reactive visibility. Manual shared settings/configuration are available.
- The FPS-cap slider does not change the device cap on construction. Explicit changes restore the captured original cap on this game's unload when `getfpscap` is available.
- The supplied AP/TP/Priority tab contains only “Coming Soon” labels. These remain honest **not implemented in the supplied source** notices, not mock buttons or invented gameplay.

## Validation boundary

The source and generated bundle compile in the actual Luau compiler. Development fixtures exercise the real adapter, off defaults, state, multi-select, units/range/silent updates, real runtime ownership/restoration under deferred-event conditions, cancellation/render cleanup and the execution-stage state machine. They do **not** execute the recovered gameplay against fake game modules or establish native visual/gameplay correctness.

A Roblox/Delta client is unavailable here. Recovered local-variable/control-flow mistakes, unsupported executor-only introspection/hooks, game updates, ownership/purchase checks and server validation may still prevent individual features from working. Runtime warnings/errors are not evidence of successful gameplay. Inventory/steal/reset/kick/purchase actions should be tested deliberately on authorized accounts; floor unlocks retain their source purchase warning and require button confirmation. No zero-FPS-drop or successful-steal guarantee is made.

## Native validation to perform

1. Open from an unrelated game: no controller startup, teleport question, upstream UI or POST. Then test the module signature and missing-module error path in the intended game.
2. Confirm all feature switches are off; opening the window does not steal, reset, aim, change the FPS cap or install the removed BlockTools listener.
3. Exercise each control category individually, including K/M/B/T unit changes, range changes, toggle-dependent fields, dropdown refresh and manual config save/load/delete.
4. Test actual supported game actions and executor capability failures. Verify the three absent features remain clearly labelled unavailable.
5. Run a selected feature, unload the loader, and verify the game UI/worker remains active. Unload this game and verify source hooks/character changes, signals, source overlays, render binding and pending workers are cleaned up. Repeat while a worker is yielding.
6. On desktop and physical mobile, inspect short-screen scrolling, line icons, static restore artwork, readable text, transitions and execution-sheet errors/cancellation. Compare real frame times/instance counts with idle/hidden/enabled features separately.
