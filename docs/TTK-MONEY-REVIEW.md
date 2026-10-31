# TTK Testing / +1 Money per Click source review

Reviewed 2026-10-31. These are real client-controller adaptations, not verified
Roblox/Delta gameplay or claims that a server accepts client requests. Input
byte hashes are in `source-inputs.json`; raw uploads are not distributed.

## TTK Testing

Input: user-supplied `dollaropen-sourcedollar-ttk-testing-inf-ammo-no-recoil-rapid-fire-max_1793372509440_zi8bj2WeI6.txt`.
The upload contains an rscripts unverified-risk notice but no reliable original
author identification or blanket license. Nullx11/Gab branding does not transfer
ownership of the original logic or invent a license.

### Retained and changed

- Merc hitbox discovery uses `MercHitboxes_`, OwnerUserId, BuiltAt, death/ragdoll
  attributes and team filtering. Keeps the newest rig per player. The prefix
  is **13 characters**, so the supplied substring comparison is correct.
- Boxes, names, distances (now accurately labeled **studs**, not meters), head
  markers, native Highlight chams, centered configurable FOV, head/body aim and
  RMB hold. Explicit continuous Touch aim is available; it is not enabled by
  simply touching the screen. Strength defaults to 100; all master switches
  start off. Detail preferences being selected does not enable ESP or aim.
- Gun/camera/throwable module wrappers preserve recoil, spread, sway, reserve,
  magazine, reload, rapid-fire, full-auto and throwable controls. Camera-shake
  and firearm-object features need the explicit **Scan equipped weapon / camera**
  action after equipping a weapon. Module-only features do not need getgc.
- Replaced VibeUI with the shared embedded Nullx11 controls. No upstream UI
  download, bootstrap or original settings/autoload execution remains.
- **Removed the unconditional SessionTelemetry suppression hook.** It replaced
  RemoteEvent.FireServer and filtered game telemetry even with every toggle off.
  It was not an exfiltration finding; Nullx11 does not install that hook.
- Removed endless getgc polling, fixed global render-step names and unowned
  signal/overlay lifetimes. One explicit scan examines up to 50,000 returned
  objects; scans are rate-limited to five seconds. `getgc(true)` itself can be
  expensive and is executor-dependent; no claim of cost-free discovery is made.
- Target discovery is cached for 250ms; overlay refresh is capped at 30Hz, with
  at most 24 target slots and 24 collected parts per target. Model boxes use
  eight bounding-box projections; non-Model fallback projects at most eight
  parts. These are deliberate crowded-server limits, not unlimited ESP coverage.
- Removed hidden aim-to-sway coupling. Spring rest handles Vector3 and scalar
  values; unknown spring representations are left alone.
- **Instant ADS is unavailable, visibly labeled.** The supplied setter
  `setStiffness(500, 1)` has no known reversible getter. No original constants
  are invented, and no unsupported permanent spring edit is performed.
- Drawing-based overlays require executor Drawing. Chams use native Highlights.
  Drawing unavailability does not produce fake boxes/FOV. Touch aim and actual
  overlay rendering require device validation.

### Ownership and limitations

`OwnedPatches.luau` layers reversible table changes by feature, including shared
spring slots. Disabling a feature restores its layer; unloading restores owned
methods only while each slot still contains the last owned write. Observed
external game changes become the restoration baseline. Foreign replacements
are not overwritten. Identical-value foreign writes cannot be distinguished
from owned writes. Original server state, shots, purchases and arbitrary game
side effects cannot be rolled back by this client helper.

Module wrappers install only after an explicit weapon option/scan action;
there is no startup GC scan or telemetry hook. All callbacks disconnect and
allocated Drawing/Highlight objects are disposed on this game's unload. A
third-party wrapper retaining our callback sees its feature flags turned off.

Preflight requires MercPlayers plus GunController and CameraController
ModuleScripts under ReplicatedStorage.Modules.Client.Controllers. It does not
invent a place ID, require those modules in the launcher, or guarantee the
current game's internal table layouts.

## +1 Money per Click

Input: `smart-farmingopen-source_1793302893383_MCFPAlb4zl.txt`; original attribution
**VoidScripts**, `https://rscripts.net/@VoidScriptsDK`. The supplied community
invite was `https://discord.gg/fuECzR3dM3`; retained here as provenance, not an
automatic browser/clipboard action. No independent license grant is invented.

- Replaced Rayfield with embedded Nullx11 controls; removed remote UI execution,
  promotional copy buttons and original marketing. Retained source credits.
- Retained **all** supplied Rebirth waypoints, four world base positions, cash
  thresholds/positions, sixteen egg names and source price references in
  `MoneyData.luau`. World boundaries remain 14, 29 and 50 Rebirths.
- Rebirth/Cash are exclusive movement modes, not competing teleport loops.
  Route movement is capped at five updates/sec, with one bounded cash-pad visit
  per changed eligible pad. Rebirth mode also explicitly requests clicks and
  rebirths, as in the source. Cash mode does not silently enable purchases.
- Auto money, rebirth, evolve and each egg start off. Eggs request three opens
  using the original InvokeServer argument; **they spend Wins**. UI prices are
  source references, not live server quotes or guaranteed successful hatches.
- At most two workers: movement and a serialized fair remote dispatcher. Rapid
  off/on changes reuse the current workers instead of spawning duplicates.
  No worker starts at initialization or remains polling once jobs are off.
- Routed calls share the session's eight/sec budget; dispatcher cadence further
  limits it to at most one call per 150ms. Rebirth/evolve have one-second job
  cooldowns. This reduces the source's request frequency intentionally.
- Exact source remotes/classes are checked before startup. All lookups are
  non-waiting; missing remotes report an unavailable action instead of hanging
  on WaitForChild. The exact source Rebirth stat name (including its Unicode
  suffix) is retained; no emoji is introduced as interface artwork.
- The number parser supports the source's K through Ud suffixes and both decimal
  and grouped comma forms. Three-digit comma groups are treated as thousands.
  Invalid/missing stats pause movement, not a guessed World 1 route. Luau number
  precision at very large values is not exact integer arithmetic.
- Stop all updates the controls and worker state. Unload prevents additional
  requests, including after a delayed InvokeServer response. An already-sent
  request cannot be recalled; previous movement/purchases are not undone.

Preflight requires ClickToEarn, RebirthRemote, EvolveRemote RemoteEvents and the
CanOpenEgg RemoteFunction at their supplied paths. No numeric place ID was
provided. This structural signature is a boundary check, not proof of gameplay.

## Scripts/asset enhancement

The main Scripts page uses actual native reusable cards, one column on narrow
pages and two on wide pages. Search supports literal words across game names,
features, category and creator; category and exact-place filters are explicit.
Unknown place IDs are **not** asserted compatible. Detail buttons resolve the
latest manifest entry; refresh removes obsolete cards and callbacks and updates
the workspace. Existing separate browser controls retain their tested launch
flow with larger cards, clearer hierarchy, compatibility labels and creator
search. Static semantic coin, rhythm and anvil icons join the existing original
line assets. No animated restore icon, remote thumbnails, fake popularity,
ratings, FPS results or compatibility certifications are added.

## Verification boundary

`npm test` compiles every generated bundle and the main client. Actual controller
contracts cover default-off/no-worker initialization, module hooks, explicit GC
discovery/rate limits, overlapping property restoration, foreign-hook ownership,
exclusive routes, worker reuse, parser/world boundaries, source egg arguments,
request pacing, stop/unload and late responses. Browser contracts cover the real
model/view, filtering, responsive geometry, card reuse, refreshed-entry launch
and callback disposal. These use **development-only API doubles** and are not
shipped. Test them on an authorized native client; rendering, touch, FPS and
server validation cannot be established in this sandbox.
