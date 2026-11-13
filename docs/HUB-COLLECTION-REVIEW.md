# NULL collection: Chaos and YARHM review

## Scope and authorization

On 2026-10-31 the user supplied `Chaos_Hub_Open_Source.txt` and
`YARHM_Hub_KEYLESS_2026.txt`, reported permission from their owners to adapt/use
and rebrand them, and requested NULL owner branding without optional promotion.
This is a record of the user's report, not independent verification of copyright
assignment or a new blanket license. Visible edition/owner branding is **NULL**;
the product remains **Nullx11**. Required notices and factual provenance remain.
YARHM's supplied routines say **© Aetherion 2026** and its header refers to
`https://mhi.im/tos`; that reference is preserved here, not executed or represented
as independently reviewed legal terms. Chaos's supplied UI names Luscaa/venom.
Input hashes/byte counts are in `source-inputs.json`. Raw uploads were statically
inspected, never executed and are not distributed.

**Game coverage is complete for the actual YARHM routines; feature parity is not.**
There are five YARHM entries (Universal plus four games), and a separate Chaos
Brookhaven entry. This is a clean native feature adaptation, not a claim to port
all 19,000+ uploaded lines or every source callback. Unsupported routines have no
fake success controls. The existing eight editions remain separate and intact.

## Game and feature matrix

| Entry | Gate before controller startup | Included | Explicit exclusions / changes |
| --- | --- | --- | --- |
| Universal / YARHM | Universal, explicit execution | Walk speed, jump, gravity, noclip, anti-sit; native flight with normal movement input and Rise/Descend buttons; selected-player spectate/aim; camera FOV; player ESP; reversible lighting reduction; save/return, target and cursor navigation | No AFEM/remote admin loaders, vendor GUI customization, Discord promotion, fling/anti-fling physics, irreversible map-wide FPS boost or forcefield deletion. Selected-target aim is not a new automatic centered-FOV aim engine; the existing loader aim workspace remains available. |
| Forsaken / YARHM | Universe `6331902150` | Survivor/killer, item and generator ESP; medkit priority; progress labels; nearest unfinished generator request; reversible stamina-loss, sprint-speed and stamina-gain fields | Four-second generator cooldown retained, no bypass. No recursive Changed reconnection. Sprint module required lazily only on explicit input/enable. |
| Murder Mystery 2 / YARHM | Universe `66654135` | Role/gun/trap ESP and role identification; supplied Gun.Shoot / Knife.Events.KnifeThrown paths, manual or paced jobs; simple velocity prediction; dropped-gun/map/save-return navigation; bounded nearby coin movement | Source `gameId=0` wildcard and load-anyway dialog removed. No external AI, role-copy promo/clipboard, global hooks, mass-kill, fling, kill aura, auto dropped-gun grab/bring or irreversible trap/coin deletion. Source closest-coin helper returned a pair then was used like an Instance; new route selects an actual candidate. |
| Flee the Facility / YARHM | Universe `372226183` | Player/beast, computer, pod, exit and `LOCKER`-tag ESP; optional labels; owned flashlight; reversible walk-speed lock and third-person camera | No global anti-PC-error hook. Source changes a local `antifail` but the hook reads `getgenv().antifail`; no claim that the broken control works. No off-screen arrows. |
| Brookhaven / YARHM | Place `4924922222` | Target/spectate, bounded avatar requests, RP name/bio RGB; 10 item requests, all 61 supplied effect entries; tool/own-house music IDs; own-house color/text/garage; own named vehicle speed/turbo/color; 22 source locations, save/return; local movement | No Shader world deletion/immortal sky tasks, prop orbit/anti-tools/global tool blocking, bans deletion, mass vehicle manipulation, bring-all/kill-all, forced seats, repeated garage/chat/music spam, radio/sign/cosmetic variants not in the reviewed UI. Body-copy request does not first destructively remove existing accessories. |
| Brookhaven / Chaos | Place `4924922222`, separate scope/session | English native Brookhaven tools above plus source-derived body/hair RGB; reviewed local speed/jump/gravity/anti-sit and source coordinate set | Not the full Chaos hub. No Redzhub/TurtleLib or universal external-loader tab, ScriptBlox code, black holes, mass fling/vehicles, destructive tool/camera duplication tricks, explicit/offensive tool routines or spam-heavy audio/chat. Shared Brookhaven protocols/data are reused instead of duplicating buggy loops. |

The universes above come from the supplied YARHM routines (MM2's intended ID was
commented out). Its testing universe `119460199` is not treated as a production
MM2 target. Brookhaven's raw `gameId=0` is not inherited. Brookhaven is constrained
to its known root place rather than claiming compatibility with every universe.

## Execution, ownership and limitations

- `HubPolicy.luau`: pure target gates, finite numeric limits, unique-player lookup.
- `HubCore.luau`: shared native controls, one demand-driven job per key, current-job
  predicates, session request pacing, owned instances and layered restoration.
- Five controller files and one data module implement the actual tools; both
  Brookhaven editions reuse the controller but have distinct session and GUI IDs.
- No new controller or collection helper performs HTTP, executes supplied raw
  strings, installs executor-wide hooks, queues teleports, mutates shared vendor
  globals or starts work merely by being browsed. Game module discovery is lazy.
- Trap visibility changes are reversible owned edits, not permanent transparency
  overwrites. Native ESP uses up to **64 highlights/labels**, updates only while enabled,
  reuses markers, and removes obsolete ones. Scans visit at most **6,000 nodes**,
  yield every **200**, and can have incomplete coverage. No arrow renderer is
  claimed. Marker count is a per-session limit, not an aggregate FPS guarantee.
- World ESP refreshes every 0.75–1.5 seconds, stamina every second, flight/selected
  aim at 20 Hz. RGB jobs run every two seconds rather than every rendered frame.
- Explicit remote traffic uses the existing **8/second per-session** budget;
  generation checks prevent a disabled queued job from sending after a wait.
  Every source protocol/class must exist; absence reports an error, not success.
- Coin movement considers at most 256 candidates within 500 studs, caps tween
  duration at five seconds, and temporarily skips visited candidates. It never
  deletes a coin or reports currency collection. Tween cancellation is owned.
- Local patches restore only while the property still equals the owned value;
  external changes win. Different active editions can intentionally contend for
  movement/camera settings; avoid enabling conflicting tools simultaneously.
- Server-owned avatar, house, color and tool effects may persist after stopping or
  unloading. Already-sent requests cannot be recalled. An executor/game require
  or InvokeServer may yield indefinitely; these tests do not prove server liveness.
- Loader unload does not stop these independent game sessions. Use each game's
  own Unload button. No launcher joins a game or offers teleport prompts.

## Removed vendor execution and branding

The final ScriptBlox ingest call, AdLoader, custom-module loader, AFEM loader and
all original remote UI/bootstrap execution are excluded from the collection.
Optional author/promo cards were removed from visible existing edition details;
all 14 catalog entries and their shared window subtitles identify NULL. Existing
source notices (including Rosu's no-resale notice and font OFL) remain unchanged.
Repository ownership URLs are not branding text and were not broken by renaming.

The library adds **Source collection** filtering (Nullx11 originals / YARHM /
Chaos), universe-aware match badges, a Universal badge and compatible-game
filtering. Search continues to match literal game/feature/collection/owner terms.
Cards reuse their instances and still require deliberate detail/confirmation.
The prism restore icon remains static; the existing loading/glitch effects remain.

## Validation

`tests/hub-collection-contracts.luau` runs the shipped policy, runtime, data,
controllers, catalog validator, session and patch implementations against
**development API doubles only**. It covers off/no-mutation startup, real protocol
arguments, cancellation while paced, worker replacement, overlay bounds/reuse,
scan cancellation, generator cooldown, lazy module reads, respawned flashlight,
local/external-safe restoration and independent cleanup. Browser contracts cover
collection/universe/Universal behavior. The build checks serialization of the new
boolean catalog metadata rather than silently generating an empty Lua table.

All published bundles compile, but **native Roblox/Delta rendering, touch input,
current server protocols/permissions, collection rewards and FPS remain untested**.
See `diagnostics/GAME-PORTS.md` for the client checklist. Compilation and API
contracts are not proof that a game currently accepts a request.
