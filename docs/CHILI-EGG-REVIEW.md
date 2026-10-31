# StealAnEgg-CHILI: partial recovery and implementation boundary

Reviewed 2026-10-31. **This is a recovered-core edition, not a claim of full
source devirtualization or native gameplay success.** It is a separate entry
and session from the existing Henrik / xyzhenrik Steal An Egg adaptation.

## Input and handling

- User upload: `steal.partial-decoded.lua.txt`, 1,740,136 bytes, 47,222 lines.
- SHA-256: `c198d8df2672e4f000c748818d6f624daadb593bf6ee3583841ab9d0d08ccdba`.
- The header explicitly says partial static recovery, not full devirtualization;
  a prior tracing run aborted in an endless loop and captured zero VM prototypes.
  Its referenced recovery README was not supplied. The remaining `:rk(...)`
  entry, buffer/bit operations and VM helper dispatch are not recovered here.
- **The raw upload was never executed.** It is not embedded in the published
  bundle, loaded as a string, or shipped as an alternate bootstrap. Readable
  algorithms/protocols were inspected and independently implemented.
- Original Chilli SAE authorship is retained. No separate license/recovery grant
  was supplied; rebranding as Nullx11/Gab does not invent one.
- External Chilli account/finder/API integrations, credential-like constants,
  webhook handling, luarmor/Venyx loaders, configuration migration/autoload and
  teleport queues are excluded. Those dependencies are not needed by the
  recovered core. This is not a claim that every vendor service is exfiltration.

## What is actually implemented

| Area | Recovery evidence in upload | Published implementation |
| --- | --- | --- |
| Egg metadata | Readable block starting ~14773: Client.EggState / Data.Assets / Shared.Modules.Mutations; rarity, mutation and income functions ~15050–15120 | `ChiliEggPolicy.luau`: mutation deduplication, rarity, exact piecewise scale formula, estimate filtering and stable priority sorting. Unknown mutated earnings are skipped instead of fabricated. |
| Nearby carry | CarryFieldEgg UID calls ~17914/18025, nearby distance check ~18022; optional AreaId:NestId key ~29104 | Within 12 studs, only Slot/Dropped/unset-state records; excludes FirstAreaEgg IDs; refreshes eligibility before request; three-second UID retry cooldown. No remote guard bypass, long-distance instant steal or VM helper is substituted. |
| Delivery movement | Source separates carry from return/delivery and uses character transforms | Nullx11 explicitly saves the user's delivery point. Return is opt-in, once per carried UID, requires a live unanchored character and server-observed CarrierUserId. **This saved-point workflow is a new integration choice**, not a reconstruction of the unresolved original delivery modes. It does not assume redemption. |
| Field labels | ReadFieldEggs records, BottomCFrame and dropped-model lookup ~18325 | Native GUI labels using recovered name/value metadata, at most 24 labels, 30Hz projection, snapshot cadence at most twice/sec. Not the entire original ESP suite. |
| Away earnings | ~23944–23951 | FetchSummary, then AskCollect with `{Kind="Claim"}` only for a positive ClaimableAmount. |
| Basic index rewards | ~23955–23964 | AskRedeemAll only for owned/unclaimed Index categories. VM-dependent limited-index merge logic is not ported. |
| Base upgrades | ~24000–24019 | Save.Money/BaseUpgradeLevel + Data.Bases.BASES/optional max level; exact AskBaseTierRaise event without invented payload. |
| Treadmill upgrades | ~24020–24031 | GetByUpgradeLevel and Price checks; exact AskTierRaise request and recovered `_id`. Does not claim the full training/movement routine. |
| Trail purchasing | ~24034–24057 | Cheapest affordable unowned source-directory trail, exact AskPurchase `_id`, once per five-second job cooldown. |

Values are **source-formula estimates**, not live quotes or server guarantees.
Rarity ranking follows source `RarityNumber`/`Rank`, with a named-rarity fallback.
Field reads visit at most 512 records per scan. Unknown or changed game schemas
produce a visible unavailable/paused status rather than fallback simulated data.

## Deliberately unavailable

The remaining VM-dependent full steal/chase/delivery/guard methods, event/boss
chains, inventory fuse/sell/mutation pipelines, full predictor/finder/account
features, invisibility/character bypasses and cross-server automation are not
advertised as working. The Recovery & credits tab states this explicitly; there
are no fake feature toggles. Do not conflate those features with the separately
ported Henrik/xyzhenrik script or the separate stealabrainrot controller.

## Safety, ownership and compatibility

- Every job starts off; no module requires, snapshots or worker starts at
  initialization. Module presence preflight checks Client.EggState, Shared.Save,
  Data.Assets ModuleScripts plus Packages.Networking without executing them.
  No numeric PlaceId is invented. Runtime methods/remotes are validated again.
- One dispatcher handles explicit actions and enabled jobs. Repeated toggles do
  not create duplicate workers. Optional progression modules load on demand.
- Routed module/remote calls share this session's eight/sec budget. Progression
  job cooldown is five seconds; carry retries are three seconds per UID.
  `SendWhen` revalidates generation/feature state after a pacing wait. It does
  not claim to count all network traffic generated internally by game modules.
- No feature turns itself on from a profile at startup. No launcher teleport
  prompt or queued auto-execution is added.
- Returning to a saved point is intentional movement and is not rolled back on
  stop. Requests already sent cannot be recalled. Trail/base/treadmill jobs can
  spend Money; no purchase/hatch/redemption is inferred from pcall success.
- Stop-all updates switches, cancels pending work and removes owned labels;
  unload disconnects the render listener, clears module caches and stops future
  work after late responses. A currently yielding game method/require cannot
  be forcibly cancelled; no new request is issued after it returns on unload.
- Loader unload still leaves executed games alive. Unload CHILI from its own
  workspace. Do not enable conflicting movement automation in two Egg ports
  simultaneously; their sessions are independent, not aggregate movement owners.
- Real Roblox/Delta rendering, device touch, performance and server acceptance
  remain unverified. Zero FPS drops cannot be guaranteed.

## Loading visibility fix

The old opening effect was explicitly gated off with EnhancedWorkspace enabled,
while the shared workspace intentionally skipped the upstream toolkit intro.
The Nullx11 gravity-well animation is now installed **after** the workspace
bridge and hosted in its actual ScreenGui. It hides/restores the native window
and static dock, temporarily elevates the host above other game GUIs, and restores
the original display order on completion; it does not reveal the classic launcher on completion. Skip,
actual game-readiness wait, viewport changes and reduced-motion bypass remain.
The dock artwork is not animated.

Execution loading now uses its own ScreenGui with DisplayOrder at least 1000,
above the known new game GUIs at 100. A frame yield before HTTP lets the sheet
appear before executor transport begins. Stage labels remain actual operations,
not invented percentages or asset download counts. HTTP transport itself may
still be blocking/non-cancellable in an executor; cancel prevents later startup.

Primary unload is now invoked explicitly before disconnecting the core loader's
listener list. Native-host/intro cleanup must not depend on the relative order
in which Destroying listeners happen to run.

## Verification

`npm test` executes the actual recovered policy/controller with development-only
API doubles, including equations, filters, source request names/payloads,
default-off initialization, worker reuse, budget-wait cancellation, saved-point
return, labels cleanup, slow response teardown, signature gate and independent
original-Egg lifetime. Actual startup code and the opening bridge are exercised
on the enhanced path; tests cover skip/readiness/reduced-motion/rerun/unload and
not revealing the classic window. Actual execution-view tests verify layer order
against a newly created game GUI and independent close/error/unload behavior.
These are **not** native rendering or successful gameplay tests.
