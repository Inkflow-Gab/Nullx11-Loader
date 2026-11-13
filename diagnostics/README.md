# Real Roblox / Delta validation (manual)

`RobloxRuntimeCheck.client.luau` is a **native Roblox client script**, not a mock fixture. Run it after Nullx11 as a LocalScript in Studio or paste it into your client runtime. It observes actual Players, character readiness, camera type/viewport, projection, raycasting, Highlight creation, fonts, and real late-render callbacks. Results go to Output / the runtime console. It does not steer your camera, fake an enemy, download code, or claim aim accuracy.

**This environment cannot run Roblox or Delta. These device checks have not been completed here.** Compilation/Node unit checks are separate development checks, not substitutes for these observations.

## Reproduction checklist

Use an experience you control or are authorized to test. In Studio, start a **two-client local server**, not only Play Solo; these features target other real Players, not NPCs. Arrange opposing teams or disable the team filters intentionally.

- [ ] Run the full current main script. Confirm 24 orbital particles (16 on touch-enabled clients), three lens rings, central N implosion, outward shockwave, and dock-to-window entrance. Skip works even before the game is loaded. No fake asset percentage.
- [ ] Check portrait and short landscape; 14+ px baseline text, 16 px toggle headings, and scroll access to every setting. Check **Style → Pixel / Medieval**, plus Aurora / Pixel and Citadel / Gothic looks. Body text must remain readable.
- [ ] Confirm startup/main/execution are centered with no topbar offset. Check a notched device and Center loader window. Minimize, rotate while hidden, and restore: it must use the updated center or clamped explicit drag position.
- [ ] Use Scripts Prev/Next, page jumping, literal multiword search, category/collection sort and This game/Pinned/Recent views. Refresh after removing a pinned entry; no stale row may launch. In short landscape, search/results/pagination stay reachable. Separate Scripts window must also be paginated.
- [ ] Compare Auto, Balanced and Low power UI profiles on a real device. Record frame times rather than claiming an FPS boost. Hidden/user-disabled effects must stay off after recovery; low-power controls must still complete actions.
- [ ] Minimize to the dock; restore from it. Rapidly reverse the animation, rotate the device mid-animation, and drag after completion. Windows must not remain tiny, rotated, or offscreen. Reduced motion bypasses transport.
- [ ] Enable Visuals near a real opposing player. Inspect box alignment, chams, names, health, distance, and tracers. Move behind a wall, change team filtering, respawn, and leave/rejoin.
- [ ] Open Aim; enable it in **Auto** mode with a real player inside the center radius and unobstructed line of sight. Confirm local camera steering without RMB/touch hold. Increase strength to 100 and inspect snap behavior. It does not alter weapon hits or server state.
- [ ] Press **Play view / fold panels into dock** to uncover the FOV. Move the target outside the radius, behind a wall, or beyond range. No eligible player must mean no tracking.
- [ ] Choose **Hold**. Hold/release RMB or the AIM pad, including release outside the pad and window focus loss. It must stop. Confirm the pad is available even if touch detection is false.
- [ ] Typing and missing/dead local avatars pause tracking. Scripted cameras pause by default; use the explicit override only when intended, not during a cutscene.
- [ ] Press **Check live Roblox state** near the bottom of Visuals/Aim. Read the persistent report and console. If aim has no target, record the real player/filtered/FOV/obstruction counts, camera type, and local avatar readiness.
- [ ] Run the native diagnostic file and save its console output. API observations are not a rendering or aim certification.
- [ ] Open Scripts: no automatic network request. Refresh reads the repository manifest. Empty means empty. Add a reviewed entry; confirm search, place filtering, two-tap execution consent, and useful failure messages.
- [ ] End/disable clears all player effects. Main × stops camera effects immediately, folds windows, then destroys GUI/overlays/Highlights/listeners. Rerun mid-animation and close while a library request is pending; there must be no stale Nullx11 UI updates.

If a game replaces the camera after Nullx11's late update, uses a separate actor system instead of Player characters, or aims weapons independently of the camera, camera-only assist cannot guarantee compatibility. Report the actual diagnostic output instead of marking the behavior as working from unit tests.
