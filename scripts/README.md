# Nullx11 script library

This folder is connected to **Load → Tools → Scripts window** in `Nullx11.client.luau`.

The published manifest is intentionally empty. No demo is presented as a working game script.

## Add a script later

1. Put a reviewed `.luau` file in this folder, for example `my-tool.luau`.
2. Add its metadata to `manifest.json`:

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

3. Publish both files on **`arena/d92ad2cf-nullx11-loader`**, the branch currently configured in the loader. If you later publish elsewhere, explicitly update `CONFIG.ScriptBaseURL` in the loader to that reviewed repository/branch/commit's `scripts/` URL.
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
- Manifest response: at most 128 KiB. Downloaded script: nonempty and at most 512 KiB.

Malformed manifests leave the previously loaded library intact. Refresh and confirmed Run are the only library network actions; opening the window does not fetch anything. Download/JSON/compile/runtime errors appear in the GUI and console. Destroyed/refreshed rows lose their callbacks and cached styles.

## Runtime / trust

Remote running needs a client runtime providing `game:HttpGet` and `loadstring`. Normal Studio LocalScripts do not provide unrestricted client HTTP/loadstring; keep reviewed Studio tools as LocalScripts/ModuleScripts instead. A missing capability is reported, not emulated.

Remote scripts inherit the runtime's permissions. The confirmation is consent, not a sandbox, signature, or security scan. Prefer pinning `CONFIG.ScriptBaseURL` to a reviewed commit. A script can yield, create separate UI, or run its own listeners; closing Nullx11 does **not** unload arbitrary third-party code. Each published script must implement its own cleanup and honest compatibility notes.

## Game-specific launch windows

Scripts is now an **Open library** action rather than an ON/OFF switch. To use the game-detail/teleport flow, a reviewed, working published entry can add:

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
- **Open game window** does not download or run code. The detail window asks whether to teleport when in the wrong place. Direct Execute is blocked there.
- **Teleport to game** and **Execute game script** are separate actions. Execution in the correct place still requires two-tap confirmation.
- **Execute game script after joining** starts OFF. If the runtime supplies `queue_on_teleport`, `queueonteleport`, or `syn.queue_on_teleport`, an explicit teleport can queue **only the selected game file**, with an exact target-place guard—not `Nullx11.client.luau` or another game's code.
- Queue support is not emulated. If requested queueing fails, no teleport is attempted. Without queue support, teleport-only and manual execution remain available.
- A failed teleport can leave accepted code in the runtime's queue. Nullx11 cannot universally cancel that queue; it warns, deduplicates retries, and refuses to call a subsequent same-game action “teleport-only” while it knows code may remain queued. Rerunning/closing Nullx11 does **not** clear an executor's queue. Clear it in the runtime or restart the session if necessary.
- Teleport failures are reported via both thrown errors and the actual `TeleportInitFailed` event. This is not proof of a successful join; status says “requested.” Roblox Studio may reject teleports.

See [INTEGRATION-STATUS.md](INTEGRATION-STATUS.md) for the three requested ports and missing inputs. They are not yet present in the executable manifest.
