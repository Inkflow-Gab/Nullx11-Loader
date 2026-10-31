# Nullx11 script library

This folder is connected to **Workspace → Scripts / Open Scripts library** in `Nullx11.client.luau` (also available through classic Tools).

The manifest publishes the five adapted Rosu, Huss Valley, +1 Loot to Forge, Steal An Egg and stealabrainrot bundles. They use the shared +1-derived Nullx11 UI and contain real controller code. Implementation/compilation is complete; live gameplay validation is pending. See [integration status](INTEGRATION-STATUS.md).

## Add a script later

1. Put a reviewed `.luau` file in this folder, for example `my-tool.luau`.
2. Add its metadata to **`src/games/catalog.json`**, the source of generated `manifest.json`:

```json
{
  "Version": 1,
  "Scripts": [
    {
      "Id": "my-tool",
      "Name": "My tool",
      "Description": "Describe exactly what this client script does.",
      "File": "my-tool.luau",
      "PlaceIds": []
    }
  ]
}
```

3. Run `npm run build`, `npm run format:check` and `npm test` (update catalog expectations if adding entries), then publish both files on **`arena/bc7610cd-nullx11-loader`**, the branch currently configured in the loader. If you later publish elsewhere, explicitly update `CONFIG.ScriptBaseURL` in the loader to that reviewed repository/branch/commit's `scripts/` URL.
4. In the loader, press **Refresh from GitHub**. Search and place filtering use the fetched manifest.
5. Review the source yourself. Tap **Run**, then confirm within five seconds. The first tap does not fetch or execute script code.

`PlaceIds` omitted or `[]` means show everywhere. A nonempty array restricts visibility to those exact numeric `game.PlaceId` values. The loader does not infer compatibility or certify the script.

## Supported data / limits

- `Version`: `1`; `Scripts`: an array of at most 64 entries.
- `Id`: unique nonempty string, at most 48 bytes.
- `Name`: nonempty string, at most 80 bytes.
- `Description`: string, at most 240 bytes.
- `File`: at most 160 bytes; ASCII letters/digits/underscores/hyphens/dots/slashes, ending in `.luau`. No leading slash, `..`, URL, query string, or path outside this folder.
- `PlaceIds`: optional array of at most 100 positive whole numbers.
- Manifest response: at most 128 KiB. Downloaded script: nonempty and at most 2 MiB.

Malformed manifests leave the previously loaded library intact. Refresh and confirmed Run are the only library network actions; opening the window does not fetch anything. Download/JSON/compile/runtime errors appear in the GUI and console. Destroyed/refreshed rows lose their callbacks and cached styles.

## Runtime / trust

Remote running needs a client runtime providing `game:HttpGet` and `loadstring`. Normal Studio LocalScripts do not provide unrestricted client HTTP/loadstring; keep reviewed Studio tools as LocalScripts/ModuleScripts instead. A missing capability is reported, not emulated.

Remote scripts inherit the runtime's permissions. The confirmation is consent, not a sandbox, signature, or security scan. Prefer pinning `CONFIG.ScriptBaseURL` to a reviewed commit. A script can yield, create separate UI, or run its own listeners; closing Nullx11 does **not** unload arbitrary third-party code. Each published script must implement its own cleanup and honest compatibility notes.

## Game-specific launch windows

Scripts is now an **Open library** action rather than an ON/OFF switch. To use the game-detail/compatibility flow, a reviewed, working published entry can add:

```json
{
  "Id": "my-game",
  "Name": "Nullx11 - My game",
  "Description": "Describe the reviewed game-specific features.",
  "File": "my-game.luau",
  "GamePlaceId": 123456789,
  "Author": "Original source author / Nullx11 integration"
}
```

- `GamePlaceId`: optional positive integer up to JavaScript/Luau's exact integer limit (9,007,199,254,740,991). This is a specific **place ID**, not a universe ID. Such entries remain visible outside their game, even if legacy `PlaceIds` filters were also specified.
- `Author`: optional string up to 160 bytes, displayed as source credit. Preserve the actual original attribution.
- **Open game window** does not download or run code. Unsupported places show a compatibility notice; direct Execute is blocked. No teleport question, game join or arrival queue exists in the launcher.
- **Execute game script** requires two-tap confirmation. Existing explicit in-game server-hop/rejoin tools remain separate features, not launcher prompts.
- Steal An Egg omits `GamePlaceId` because the uploaded source provides none. Its bundle validates core ModuleScript paths before initializing the actual controller. Do not fabricate a place ID.
- Ordinary loader unload/rerun leaves executed scripts running. Stop a bundled game through its own Unload control, or the loader's separately confirmed stop-all-game-scripts action.

See [INTEGRATION-STATUS.md](INTEGRATION-STATUS.md) for all five implemented ports and the remaining native-runtime validation boundary.

## Build and cleanup

`Nullx11-Rosu.luau`, `Nullx11-Huss.luau`, `Nullx11-Forge.luau` and `manifest.json` are generated by `tools/build.mjs`. Edit their `src/` inputs, not the bundles. Other reviewed script files can be added directly with catalog metadata.

Each generated bundle has a separate UI identity and default **Left Control** shortcut. Controllers register with `Nullx11GameSessions`; their own Unload and the main workspace's registered-session cleanup stop them. UI hide/close-to-icon does not stop an enabled feature. Other externally added scripts are not assumed to support this registry.

The built-in catalog is usable without a network Refresh. Refresh replaces it atomically and invalidates stale selected-game state. Optional theme/font downloads are data, not another executable UI library. Original source and redistribution restrictions are documented in [SOURCE-PROVENANCE.md](../docs/SOURCE-PROVENANCE.md).
