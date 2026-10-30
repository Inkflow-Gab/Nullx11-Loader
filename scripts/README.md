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
