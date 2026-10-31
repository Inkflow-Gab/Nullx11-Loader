# Auto Player — NULL MIDI Studio

A standalone local-file **piano** player with a new native interface, also listed
in Nullx11 → Scripts → **NULL Studio → Auto Player**. No RoMidi preset Lua,
remote song catalog, upload service, announcement, decal or font download runs.

## Start on Delta / Android

1. Put your own **`.mid`**, **`.midi`** or Standard MIDI **`.smf`** files in:
   `/storage/emulated/0/Delta/Workspace/MIDI/`.
2. Open Auto Player. It scans that exact folder through Delta's `listfiles` API.
   If absolute listing is rejected, it tries workspace-relative **`MIDI`** and
   explicitly reports that fallback. It does not bypass Android/executor access
   restrictions, create folders, search the whole device or write any files.
3. If neither path works, grant file access using Delta/Android's own settings,
   or enter a permitted local folder under **Settings → MIDI folder**. Return to
   **Library → Refresh**. Folder changes do not silently start a scan or play.
4. Search, then select a song. Selection **loads but does not play**. The loading
   overlay reports real file-read/decode phases; its sweeping accent is decorative,
   not a fabricated completion percentage.
5. In a compatible virtual-piano game, open/focus its piano. In Auto Player's
   **Settings**, enable **Arm piano input**. Use **Test C4** and verify the actual
   piano responds. An available API is not proof that the game accepts key events.
6. Choose **Play**. The default two-second start delay gives you time to focus the
   game piano. Change Start delay to 0–10 seconds if necessary. Hiding the window
   leaves explicit playback running; opening text input or losing app focus
   pauses and releases keys.

If Delta has no permitted `keypress`/`keyrelease` pair or VirtualInputManager,
real playback is unavailable. **Preview only** is an explicit alternative: the
piano-roll visualization runs without playing the Roblox piano. It is labeled as
preview, never passed off as successful game input. This is not an audio synth.

## Controls and features

- **Library:** direct and optional nested files; literal song/folder search;
  paginated, pooled file cards (24/page); 512-file and 32-folder scan bounds.
- **Queue:** select a loaded song, then **+ Queue**. Prev/Next load queued songs;
  **Advance queue** optionally plays the next after an explicitly started song.
  It stops at the end, not an endless playlist. Clear under Settings. Limit 128.
- **Favorites:** toggle the loaded song; search **`fav:`** (optionally followed by
  text). Favorites/queue/loop marks are **session-only**, not persisted to disk.
- **Transport:** Play, Pause, Stop, seek by tapping the progress bar, and accurate
  elapsed/duration display. Seeking/pause releases held notes; resume starts at
  the next onset rather than replaying already-active notes.
- **Practice:** speed **0.25–2x**, transpose **−24…+24** semitones, gate length
  **0.1–1.0**, minimum velocity **1–127**, sustain-pedal handling, per-track mute
  and opt-in MIDI channel 10 percussion (off by default).
- **A–B practice:** set A/B at the current transport position, then enable Repeat
  A/B in Settings. With no B mark it repeats to the end. A must be before B.
- **Keyboard:** source-informed 61-key mapping, MIDI 36–96 (C2–C7), or opt-in
  88-key Ctrl extension, MIDI 21–108 (A0–C8). Out-of-range octave folding can be
  disabled. Different game bindings require a different mapping; none is guessed.
- **Visuals:** animated opening and file-loading stage, cyan/violet piano roll,
  live key highlights/BPM, a static graphical piano dock, draggable window/dock,
  dedicated Library/Queue/Mixer/Settings, compact portrait/landscape layouts and
  reduced-motion option. The dock icon has no idle animation or letter monogram.
- **F8:** play/pause (ignored while typing or when the game consumes input).
- **F7 / Settings → STOP INPUT:** emergency stop/disarm and retry owned key
  releases, even while typing. The Settings button is available on touch devices.
- **Close:** unload only this player, cancel pending local work and release owned
  inputs. Loader unload does not close an initialized Auto Player session.

Prefer Test C4 while paused. Avoid typing/movement while real playback is armed.
The 88-key Ctrl extension can conflict with other hubs' Ctrl menu bindings. Close
those menus or use 61-key mode. Keyboard simulation cannot encode arbitrary MIDI
velocity/timbre/pitch-bend or independent sustain for two notes sharing one
physical key. A game may limit chords or ignore these key events entirely.

## Bounds and honest limitations

SMF formats **0 and 1**, PPQ timing, running status, tempo maps, note velocity-zero
releases, channels/tracks, overlapping-note pairing and CC64 sustain are decoded.
SMPTE division and format 2 independent sequences report unsupported rather than
being played with invented timing. File parse limit 4 MiB, 64 tracks, 100,000
source events, 50,000 notes and four-hour duration. `readfile` itself may allocate
its result before the size check; the app cannot control an executor's I/O.

Playback is clock-driven, not cumulative task.wait timing. At most 128 events are
processed in one frame, with 64 active voices. Long stalls skip stale events and
release owned keys instead of sending a catch-up flood. The UI pools 72 waterfall
bars and at most 24 file rows/64 track rows; the visual roll is a bounded preview,
not every dense or long-held MIDI note drawn at once. Visual refresh is at most
20 Hz while playing and visible. No idle render-step loop is installed.

Key releases are best-effort through the executor API, with retries and retained
ownership of failures so F7 can retry. If permission is revoked, the UI reports
release failures; reset the piano manually if needed. No tool can guarantee a
revoked input API will release a game key. Requests already delivered to the game
cannot be recalled. A dropped callback/native file call may also block inside an
executor. No zero-FPS-drop, perfect timing, native Delta or game acceptance claim
is made by compilation/API-double tests. Validate on your actual device/piano.

## Black-screen / loading repair

The player and loader execution sheet now use ordinary Frames rather than
nested off-screen CanvasGroups. Controls are visible independently of tween
completion; the opening and actual file-operation sheets have finite visibility,
a **Hide loading view** action and a **Close player** action. Hiding a phase does
not cancel its filesystem work, and a decode phase does not reopen a dismissed
sheet. A new file operation can show a new loading stage.

The loader consumes the player's explicit UI-ready return value and removes its
own execution sheet immediately, instead of covering the new player's opening.
Initialization errors now propagate to the loader's failure sheet after cleaning
up the partial player; they are not logged as successful initialization. A blocked
CoreGui parent assignment also tries PlayerGui. No access restriction is bypassed.

Re-execute the **updated main loader**, then Scripts → NULL Studio → Auto Player.
Old already-running code is not hot-patched. These paths have delayed-callback,
failed-animation, parent-permission and real catalog-to-generated-bundle tests
using development API doubles; on-device Delta rendering still needs checking.
