# Requested game integrations — not yet ported

The loader now supports **Open Scripts library** as an action, game-detail windows, wrong-place prompts, separate Teleport/Execute actions, optional queue-on-arrival, retained source credits, and original vector UI assets. This is launch infrastructure, **not a completed port of the three game scripts**. The executable manifest remains empty rather than publish nonfunctional stubs or unreviewed third-party code.

| Requested Nullx11 title | Target place ID (provided by user) | Source/review status |
| --- | --- | --- |
| Nullx11 - Rosu Mania | 9051087354 | rscripts.net source inaccessible in this environment; upload source and license/permission. |
| Nullx11 - Huss Valley | 107535308163741 | GitHub source inspected; header credits Wyrizon and the Yvetzal Team. Repository declares no license. Await permission/license for a derivative, or specify a clean-room feature rebuild. |
| Nullx11 - +1 Loot to Forge | 118805555015549 | Pastebin source inaccessible in this environment; upload source and license/permission. Its GUI/assets have not been viewed or copied. |

Sources supplied by the user:
- Rosu Mania: https://rscripts.net/raw/open-source-autoplayer-yvetzalhub_1790657706332_LjcKmjXcCh.txt
- Huss Valley: https://github.com/wyrizon/hussvalley/blob/main/main.lua
- +1 Loot to Forge: https://pastebin.com/raw/L38rsf3f

No third-party source or asset has been vendored. Nullx11 branding can describe the integration/UI; it must not falsely replace the original authors' attribution. The folder/tab assets shipped in this change are drawn from original Roblox Frame geometry, not emoji or copied assets.

## Finish a port

1. Supply the actual blocked `.lua`/`.luau` files and their license or modification permission. Public availability or an “open-source” URL title is not itself a license.
2. Review the complete dependency/HTTP chain and gameplay hooks. For Huss Valley this includes a remote UI dependency and game-specific ReplicatedStorage modules; do not just rename its labels or blindly execute it.
3. Build/rewrite the approved game controller and its standalone Nullx11-style GUI; preserve required credits, implement cleanup, and gate game-specific initialization by target place.
4. Test in the actual authorized experience/device. No Roblox/Delta runtime is available here.
5. Publish the reviewed game file with `GamePlaceId`/`Author` metadata as documented in README.md, then Refresh the library. No main-loader execution should be queued on teleport.
