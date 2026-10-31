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
   restrictions, create folders, search the whole device or modify song files. One optional workspace JSON stores your setup.
3. If neither path works, grant file access using Delta/Android's own settings,
   or enter a permitted local folder under **Settings → MIDI folder**. Return to
   **Library → Refresh**. Folder changes do not silently start a scan or play.
4. Search, then select a song. Selection **loads but does not play**. The loading
   overlay reports real file-read/decode phases; its sweeping accent is decorative,
   not a fabricated completion percentage.
5. Open/focus the game piano first. **Arm on launch** is now enabled by default
   when an input API is available; **Play is still manual**. STOP INPUT disarms
   until you re-arm or start a new session. In **Keys**, choose the **61-key screenshot profile** for
   the supplied `1…m` layout and leave the game's **CAPS off**. Test both
   **C4 / t** and **C#4 / Shift+t**: the actual game must sound both notes.
   API availability and the player's key highlights are not proof of game input.
   If silent, choose **VIM**, **Keys / VK**, or **Keys / Enum** explicitly and test
   again while paused. Do not start a MIDI until the game piano responds.
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
  text). Favorites, queue and last-song loop marks save locally when storage is available.
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
- **Visuals:** animated opening and file-loading stage, warm amber/lavender piano roll,
  live key highlights/BPM, a static graphical piano icon in a movable mini holder, centered window,
  dedicated Library/Queue/Mixer/Keys/Settings, compact portrait/landscape layouts and
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

## Matching the supplied 61-key piano screenshot

The screenshot's white-key labels are:
`1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l z x c v b n m`.
Black keys use Shift plus their base key (`!` = Shift+1, `T` = Shift+t, etc.).
The supplied RoMidi C2–C7 mapping matches that character layout. The image alone
does not establish the game's place ID, absolute tuning, or mobile input handler.
The Keys profile selects 61-key mode and resets transpose to zero; it does not
invent a game-specific remote or operate the game's Exit/Sheets/CAPS controls.

**Keys** provides all 61 note-name/binding buttons for real armed, paused testing,
plus mapping labels on the visual piano. Test buttons use independent release
IDs and refuse to send keys while typing, playing, counting down or disarmed.
They do not generate local demo audio. MIDI preview remains visual only.

- **Auto** prefers VIM if its method exists, otherwise executor VK. This checks
  API presence, not permission or game acceptance. It does not silently change
  backends midway through a note.
- **VIM** sends Roblox `Enum.KeyCode` objects through `SendKeyEvent`.
- **Keys / VK** sends numeric virtual-key codes to `keypress`/`keyrelease`:
  T = 84, M = 77, Shift = 16, Ctrl = 17. Roblox's T value 116 is **not** VK_T.
- **Keys / Enum** is an explicit alternative for executors that expect Roblox
  enum numbers instead. It is not presented as the same format as VK.

Changing a backend pauses and releases owned keys through the old backend first.
If that release fails, switching is blocked: use STOP INPUT; if permission is
permanently denied, exit/reset the game piano and rerun the player, selecting a
different backend **before** testing again. API request/error counters are
provided; a zero-error request can still be ignored by an Android game.

If every available backend remains silent, supply the **Roblox game link/place
ID** and the observed white/black key test results. A screenshot is not enough to
verify that game's input code; some mobile games do not accept injected keyboard
input at all. No unreviewed remote calls or guessed UI-coordinate clicks are used.

## Saved setup and redesigned holder

The default is the supplied screenshot's 61-key layout with zero transpose. The
updated UI uses charcoal panels, ivory text, warm accents, a distinct selected tab,
clearer now-playing/library separation and a compact portrait player. The minimized
holder sits bottom-center above the loader icon and provides **Open**, **Play/Pause**
and **STOP**, without an animated icon. Drag its background to move it.

Successful user changes coalesce into workspace **`Nullx11-AutoPlayer.json`**.
Settings → **Your saved setup** reports Saved, Session only or an actual save error;
**Save** flushes immediately. The JSON remembers folder, backend, speed, transpose,
velocity/gate/sustain/drums, 61/88 mode, octave folding, countdown, recursive scan,
queue advance, reduced motion, arm-on-launch preference, favorites, queue, last
song, that song's track mutes/A–B loop and normalized window/holder positions.
The last song is restored only if found in the scanned library, and is loaded
without playback. Playback position, actual held keys, preview state and temporary
emergency disarm are not resumed from disk. No source Lua or MIDI bytes are stored.

**Center** brings the window to the middle and resets the mini holder. Preferences
are bounded to 64 KiB, schema-checked and data-only; missing/corrupt/denied storage
falls back to defaults/session controls. The app cannot grant Android permissions.
No external upload or whole-device scan is added. **Arm on launch** may be disabled
and saved if you prefer; unavailable input APIs remain unarmed. Automatic arming
is readiness, not proof of game acceptance and never automatic playback.
