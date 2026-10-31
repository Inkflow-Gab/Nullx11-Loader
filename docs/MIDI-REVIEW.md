# RoMidi upload / NULL Auto Player source review

The user supplied `RoMidiFull.lua.txt` on 2026-10-31 and requested a new NULL-branded
local MIDI piano GUI reading `/storage/emulated/0/Delta/Workspace/MIDI/`.
The upload is 7,169 newline-counted lines; exact size/hash is recorded in
`source-inputs.json`. It was **statically inspected, not executed/distributed**.
No independent author/license grant was included in the file; source references
include `VBfHKC86WxpXyIgr/RoMiidi` and `wownskdo/TestForApi`. This records factual
provenance, not a claim that NULL authored every original source contribution or
that MIDI compositions become NULL property. NULL is the edition/developer brand.

## Derived implementation

- `MidiOutput.luau`: isolated source-informed virtual-piano scale and 88-key Ctrl
  extension; new owned voice/reference/modifier handling, paired backend selection,
  error propagation and key-release retries. Source network/preset code is absent.
- `MidiParser.luau`: a bounded replacement for the source decoder. The original
  parser could initialize the whole song with the last tempo event read, lost
  track/channel identity in pairing and had permissive/truncated chunk handling.
  The replacement validates SMF chunks/data/VLQs, defaults to 120 BPM, converts
  using the global tempo map, pairs FIFO per track/channel/pitch, handles CC64 and
  CC120/123 and preserves raw/pedal note ends. Queue heads avoid quadratic removal.
- `MidiFiles.luau`: explicit scoped directory listing, absolute-to-relative Delta
  fallback only on failed listing, strict local paths, nested scan bounds and no
  Lua-preset execution. Empty folders do not trigger scans elsewhere.
- `MidiTransport.luau`: injected clock/output, opt-in arm/preview, release on pause/
  seek/stop/rebuild/unload, track/percussion/velocity filters, tempo-aware notes,
  speed, transposition, gate and A–B loops. Stalls drop stale events, not spam keys.
- `AutoPlayer.luau`: async generation-owned scans/parses, local library/queue/
  favorites, countdown, real API status, focus-pause, F8/F7 and independent session.
- `AutoPlayerView.luau`: newly made native cyan/violet studio; no source GUI/decal
  download. Opening/loading tweens are finite and cancel on unload. File/track/
  waterfall rows are pooled. Static draggable piano dock. Reduced motion honored.
- `tools/build.mjs`: separate lightweight standalone bundle, not the whole generic
  game UI or main loader repeated inside this music player. The existing shared
  session helper still governs rerun/unload; the library catalog points to it.

This is the requested **local piano edition**, not a claim to port the uploaded
hub's drum/guitar modes, recording, humanization, remote presets/catalogs, uploader,
announcements, online caches or every source feature. No HTTP/loadstring occurs
inside the resulting bundle; the outer loadstring only downloads reviewed code.
No local MIDI is uploaded or written, and no game remote names are guessed.

## Tests / remaining native work

`midi-contracts.luau` runs the actual decoder, filesystem policy, output adapter,
transport and async controller under deterministic development doubles. Synthetic
binary fixtures cover format/tempo/PPQ, running status, channel pairing, overlap,
sustain/all-notes-off/SysEx, malformed/bounded inputs, cancellation, scoped scan/
fallback, 61/88 mapping, reference/modifier handling, partial input failure and
release retry, real/preview separation, filters, clock/loop/lag behavior, focus
pause, stale local responses and cleanup.

`midi-view.luau` exercises the shipped view structurally with UI/tween doubles:
controls, pooled rows, track reuse, 61/88 keys, portrait/landscape dimensions,
opening/loading transitions, dock restore and disposal. These are **not screenshots,
native animation quality, touch hardware, filesystem access or successful gameplay
proof**. Use [the user guide](AUTO-PLAYER.md) and [native checklist](../diagnostics/GAME-PORTS.md).

### Follow-up: black loading/launcher handoff

Removed off-screen CanvasGroups from the player, execution card and legacy intro
card. Auto Player controls do not require opacity tweens to become visible. The
finite loading state uses operation generations, minimum display time, explicit
hide/close and deterministic delayed-hide ownership; stale callbacks cannot hide
a newer operation, and phase updates respect a manual dismissal. GUI ownership is
registered before construction, parent *assignment* failures trigger fallback,
and startup failures clean up and rethrow to the loader. A returned
`Nullx11Ready` marker hands off the loader's sheet only after controls are wired.

New `midi-loader-integration.luau` executes the actual catalog Run path and the
actual generated chunk with its real view/controller/parser. It exercises local
selection, queue/favorite, track mute, speed/transpose, preview, armed key requests,
C4 release, touch panic, minimize/restore, parent fallback, startup failure/retry
and independent loader unload. `midi-view.luau` now uses queued timers and checks
stale operations, denied tweens and permanent blocker removal. These are not GPU,
physical-touch, native executor or accepted-game-input proofs.

### Follow-up: screenshot keyboard and executor code conventions

Compared the user's 2026-10-31 piano screenshot with the 61-key character layout.
The white/Shifted black labels match; the game's identity and input acceptance
cannot be inferred from the image. Fixed the executor path's use of Roblox enum
numbers as virtual-key codes (T: enum 116 versus VK 84). Added explicit Auto/VIM/
VK/enum modes, protected method discovery, dispatch-refusal reporting and counters.
Auto chooses VIM on method presence, otherwise VK; no partial-chord auto-fallback.
Backend changes retain failed release ownership and cannot discard stuck keys.

Added a Keys tab with all 61 actual-input test buttons, on-piano bindings, a 61-key/
zero-transpose profile and CAPS-off guidance; test releases have independent IDs.
No game identity, remote protocol, mobile acceptance or absolute tuning is claimed
from the screenshot. Development tests now use realistic enum values, independently
check every screenshot binding, verify Shift/VK numbers and native Enum dispatch,
old-backend release ownership, failed switching, unsupported/refused APIs and the
published chunk's actual Keys/profile/backend/manual-test controls.
