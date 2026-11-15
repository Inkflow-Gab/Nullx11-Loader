# Finish The Word! — Nullx11 edition

## Scope, credits and ownership

User upload: `finishtheword.lua.txt`, **42,799 bytes**, SHA-256 `abde9b78c47ba7312b73738d8385ef8dc70ea5627ee1b2d140b11fbcc865dfc4`. The complete original is preserved byte-for-byte in `docs/source-archive/finish-word/finishtheword.lua.txt`.

The original controller identifies **Dave / ancestrychanged.com**, with the header “open sourced @ 10/10/2026”, “enjoy”, and “please don't skid”. These notices and upstream contributions are retained; **NULL identifies the Nullx11 edition**, not a transfer of Dave's copyright or newly claimed authorship of his work. The upload does not provide a blanket license for every linked component or dataset.

This edition implements the supplied event protocol, dictionary/whitelist/frequency selection, own-turn typing, learning, retries and timing controls using the shared native Nullx11 charcoal/blue GUI. No fetched Lua, executable cache, vendor UI, Discord RPC, identity escalation or unknown RemoteEvent payload is executed.

## Essential links and complete captured inputs

The essential links are **text datasets**, not an opaque executable backend. Their complete contents were retrieved by the text-only GitHub capture workflow, validated and preserved in this repository. The restricted local sandbox could not directly download the original host or Actions artifact storage; the capture workflow wrote the validated snapshots on the same working branch. It has since been reduced to manual dispatch, read-only permissions and artifact output; it no longer automatically commits or updates anything.

Runtime word data is pinned to repository commit **`74dd400750d428e2bc76f0930a8d430055bfcb80`**, under `data/finish-word/`. It is **not** replaced by a small example dictionary, an unrelated English list or a partial web-page excerpt.

| Original link | Complete captured input | Handling |
| --- | --- | --- |
| `https://ancestrychanged.com/scripts/ftw_words.txt` | `data/finish-word/words.txt`: **138,602 unique words**, 1,369,605 bytes | Pinned text-only runtime data |
| `https://ancestrychanged.com/scripts/ftw_whitelist.txt` | `data/finish-word/whitelist.txt`: **138,602 words**, 1,369,605 bytes | Pinned text-only runtime data |
| `https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt` | `data/finish-word/frequency.txt`: **9,894 ranked entries**, 75,153 bytes | Pinned text-only frequency ordering |
| `https://ancestrychanged.com/scripts/versions/ftw.json` | Archived `words-version.json` (`version: 1`) | Provenance, not a runtime updater |
| `https://ancestrychanged.com/scripts/version.json` | Archived `library-version.json` (`version: 9`) | Provenance, not a runtime updater |
| `https://ancestrychanged.com/scripts/uilib.lua` | Full archived `uilib.lua.txt` | Obsidian-derived vendor UI replaced by native shared UI |
| `https://ancestrychanged.com/scripts/savemanager.lua` | Full archived `savemanager.lua.txt` | Replaced by manual shared profiles and bounded per-user JSON lists |
| `https://ancestrychanged.com/scripts/warningcard.lua` | Full archived `warningcard.lua.txt` | Not executed; capability errors are reported in the workspace |
| `https://ancestrychanged.com/scripts/lucide-roblox-direct.lua` (nested UI dependency) | Full archived `lucide-roblox-direct.lua.txt` | Not executed; native icons used instead |

All Lua snapshots, version files and their byte counts/SHA-256 hashes are in `docs/source-archive/finish-word/dependencies/`, including `capture.json`. The two captured primary word files happen to be **identical**; this is recorded, not silently deduplicated or presented as independent server validation. A whitelist mark reflects source data/local learning, not a guarantee that the server will accept the word.

The old UI/icon/warning sources reference optional PNGs, Roblox asset IDs and mirror images. Those decorations are not runtime dependencies of this edition and are not falsely claimed as bundled assets. Source references remain in their unmodified archives.

### Licensing limits

- Obsidian upstream MIT notice is retained as `Obsidian-LICENSE.txt`.
- Lucide upstream ISC/third-party notices are retained as `Lucide-LICENSE.txt`.
- The frequency repository's actual data-use notice is retained in `data/finish-word/FREQUENCY-LICENSE.txt`: educational/personal/research permission is described there; commercial use is not recommended without appropriate corpus licensing. **This is not a new commercial-use grant.**
- The custom main word/whitelist source does not identify a separate dataset license in its response. No blanket relicensing or copyright transfer is asserted.

## Controls and source-feature parity

### Play

1. Execute `scripts/Nullx11-FinishTheWord.luau` in the intended game.
2. Choose **Load full word data**. Loading is explicit and text-only; startup does not download data or scan GC.
3. During a mounted gameplay round, choose **Attach during a round**. It requires one event bus with `fire`, `remoteFire`, `remoteConnect`, `disconnect`, `ping` and the supplied `_Properties`/`_Children`/`TopBar.AnswerInput`/`ChoiceList` gameplay signature.
4. Enable **Auto answer** if desired, or select an unused suggestion and press **Type selected**. Selection alone never types.
5. Auto letter choice is a separate optional switch. It chooses among the actual supplied choices using available unused words. It never types or chooses on an opponent's turn.

No place ID was supplied, so none is invented. The UI/manual dictionary preview can open elsewhere, but gameplay input is gated by explicit signature discovery and the executing player's actual turn. No launcher teleport, arrival queue or automatic game controller is installed.

### Word length

- **Short:** 1–5 letters.
- **Neutral:** 6–8 letters.
- **Long:** 9–12 letters.
- **Longer:** 13–45 letters (the captured base data currently reaches 32).
- **Auto:** starts with Neutral, prefers Short when WPM is below 45 or fixed delay is at least 0.2 seconds, progresses to Long after seven own turns and Longer after sixteen turns or forty observed used words. Available-word filtering happens afterward; exhausted bands can fall back to the nearest available length.

The nearest-length fallback is explicit and optional. Disable it for a strict band. Ordered ending preferences and their source-style fallback are separately configurable. Shortest/Longest/alphabetical/reverse/frequency ordering operates within preference tiers, with optional whitelist priority.

### Repeat prevention and other players

- **Used:** valid words reported through the game's global `correct` event, including **all other players' accepted words**. Already-used strikes also record the affected local pending word.
- **Attempted:** words this session has already started, even if typing is cancelled before submission.
- **Submitted:** words actually sent with `tryAnswer`, guarding against duplicate submissions.
- **Tried:** the current turn's local attempts, retained across resume/retry settings changes.

All three match-wide sets exclude candidates. Eligibility is rechecked during typing and immediately before submitting. Changing length/speed/endings, STOP, focus loss, retries, detach or profile loading **does not clear match history**. Only the source `InGame` transition into a new match clears those match-wide sets. Unloading/re-executing creates a new session and cannot reconstruct old events.

**Limit:** the source offers live accepted-word events, not a demonstrated match-history API. Words used **before attachment** cannot be known until reported by an already-used rejection or another source event. The script does not claim an impossible complete pre-attachment history or guaranteed zero server rejections.

There is no hardcoded account name. The executing `LocalPlayer`, `UserId` and own-turn attribute determine actions; personal files use `Nullx11-FinishWord-<UserId>.json`. This supports other people executing their own copies; it does **not** provide control over opponents' input or an automatic win.

### Typing, suggestions and lists

- Adjustable **20–240 WPM** (five characters per nominal word), or **0.04–0.8 seconds per character**.
- Separate start and submit waits, retries and bounded fast mode; optional timing variation, adjacent-key typo/correction and Linear/Exp/Log thinking curves.
- Source timing presets Off/Light/Realistic/Paranoid plus Custom. Names describe typing styles, **not anti-cheat evasion**.
- Up to 100 ranked suggestions, paged through **12 reused native buttons**. A manual preview prefix is suggestions-only and cannot bypass the live turn/prefix checks.
- Ordered ending filters/reset, whitelist/blacklist edits, automatic learning from global accepted words, and optional recent-rejection blacklist heuristic. The latter is off by default and respects the source's pet/cutscene exclusion.
- Per-user JSON lists: 64 KiB maximum, 1,500 personal entries per list, delayed/coalesced saves. Missing file APIs do not prevent in-memory word selection/typing. Full source dictionaries are not copied into every personal profile.
- Shared manual timing/interface profiles; automation switches are not saved and do not autoload. No executable SaveManager cache is loaded.

### Session tools

- Scoped detach/unload and F7/visible STOP preserve match-wide repeat history while alive.
- Opt-in source-shaped AFK threshold patch with owned restoration plus an idle jump request; no guaranteed AFK-kick bypass or mouse button held during unload.
- Optional double-shake phone hide/show and the shared movable graphical restore dock.
- Rejoin/server-hop are manual, separately confirmed actions only; no kick-first rejoin and no teleport on startup. A late server-list response cannot teleport an unloaded session.
- Original Discord localhost probing, external warning execution, mandatory executor aliases/filesystem/identity prerequisites and executable vendor caches are retained only as archival source, not runtime side effects.

## Work and ownership bounds

One independent `finishword` context replaces only its own previous session. Loader unload does not unload this workspace; other games are unaffected. All engine work is heartbeat-driven, **one protocol action per frame and at most 30 actions/second**. A frame hitch never catches up with a keystroke burst. Every action checks session, source attachment, own turn, focus, prompt and repeat sets. Unexpected manual input or unsynchronized input for more than 0.6 seconds cancels typing rather than overwriting it indefinitely.

Explicit discovery visits at most **100,000 GC values**, yields every 500 and is limited to one request per five seconds. `getgc` itself still allocates its executor snapshot; this is not a claim that the executor's allocation is bounded. No repeated automatic scan/hook is installed.

Each data response is capped at **8 MiB/600,000 lines**, words at 45 letters, prefixes at 16, and ending preferences at eight/128 input characters. Parsing yields every 4,000 lines, builds a staging dictionary and publishes only after all required data is ready. Search uses prefix lower bounds, scans at most 50,000 matches and retains only the best requested N. The real captured largest first-letter bucket is below that search cap. Word UI refreshes only when dirty, at most five times a second.

Generation guards reject late loads/attachments. All five source subscriptions use owned disconnect tokens; callback exceptions detach instead of breaking the game's event dispatch. There are no synthetic keys held for cleanup to release. Owned AFK edits restore only if an external writer has not changed the value.

## Validation boundary and native checklist

`tests/finish-word.luau` exercises the **actual** dictionary, bridge, engine and controller against structural Roblox/executor IO doubles, including the entire captured dictionary. It checks length/fallback modes, WPM scheduling, source gates, global opponent words, match-wide started/submitted exclusion across retry/STOP/settings, own-turn choice behavior, delayed data/attach cancellation, personal files, AFK restoration and cleanup. Node checks verify archived input hashes and data pinning. The generated standalone compiles with all 17 catalog entries.

These are not live Roblox/Delta or server proofs. On-device validation is still needed:

1. Test mobile portrait/landscape, scrollable groups, word paging and the restore dock. All actions should be off at launch.
2. Load all word data; verify the base count is 138,602. Deny network/file APIs and confirm truthful errors without code execution or automation starting.
3. Attach in a live round; outside the game/signature it should refuse gameplay input. Switch turns, respawn/rejoin and remounted gameplay UIs; reattach explicitly if the game's component instance changes.
4. Test a slow fixed delay, WPM range, fast mode and long words. Confirm actual local game input matches each keystroke and accepted results; no native timing/acceptance guarantee is inferred from doubles.
5. Observe another player's accepted word, then the same prefix on your turn. It should be omitted. Change length, STOP/resume, reject an answer and confirm the same word is not restarted. Starting mid-match has the pre-attachment limitation above.
6. Lose focus/type manually during a plan and verify it stops. Test a new `InGame` match transition and confirm history resets only then.
7. Unload the loader while this tool runs, then unload this tool alone. It should disconnect its own source tokens and restore only its AFK edit, without stopping other sessions.

No guaranteed wins, server acceptance, anti-cheat bypass or measured FPS results are claimed.
