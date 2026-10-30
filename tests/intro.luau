runLoader()
local root = find("SafeArea")
root.AbsoluteSize = Vector2.new(400, 700)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
local intro = find("StartupWhirlpool")
assert(
	not find("Panel").Visible and not find("RestoreNullx11").Visible,
	"startup hides workspace until reveal"
)
local initial = find("WhirlpoolCenter").Size.X
advance(0.4)
assert(find("WhirlpoolCenter").Size.X < initial, "whirlpool contracts")
advance(0.7)
assert(
	not intro.Destroyed and intro.BackgroundTransparency > 0.03,
	"burst/reveal phase"
)
advance(0.4)
assert(
	intro.Destroyed and find("Panel").Visible and find("RestoreNullx11").Visible,
	"burst reveals GUI"
)
local count = #objects
advance(2)
assert(#objects == count, "intro never recreates particles after completion")
-- Skip is accessible, including on short landscape screens.
runLoader()
root = find("SafeArea")
root.AbsoluteSize = Vector2.new(700, 300)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
advance(0.05)
assert(
	find("StartupCaption").Position.Y == 62,
	"landscape labels avoid bottom skip button"
)
intro = find("StartupWhirlpool")
find("SkipStartup").Activated:Fire()
assert(intro.Destroyed and find("Panel").Visible, "skip reveals immediately")
-- Waiting is tied to actual game readiness; no fake percentage is reported.
local loaded = game.IsLoaded
game.IsLoaded = function()
	return false
end
runLoader()
root = find("SafeArea")
root.AbsoluteSize = Vector2.new(400, 700)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
intro = find("StartupWhirlpool")
advance(3)
assert(not intro.Destroyed and not find("Panel").Visible, "unloaded game waits")
assert(
	string.find(find("StartupCaption").Text, "Waiting", 1, true),
	"waiting label is honest"
)
find("SkipStartup").Activated:Fire()
assert(
	intro.Destroyed and find("Panel").Visible,
	"skip available while waiting"
)
game.IsLoaded = loaded
-- Reduced motion bypasses all spinning/burst objects.
runReducedLoader()
root = find("SafeArea")
assert(
	not root:FindFirstChild("StartupWhirlpool") and find("Panel").Visible,
	"reduced motion skips animation"
)
-- Re-execution or closing during the effect cleans its render callback and objects.
runLoader()
local old = find("StartupWhirlpool")
runLoader()
assert(old.Destroyed, "rerun destroys previous effect")
local active = find("StartupWhirlpool")
find("Close").Activated:Fire()
assert(active.Destroyed, "close during intro cleans effect")
advance(2)
assert(#warnings == 0, "intro lifecycle has no stale updates")
return "PASS: startup contraction/burst/reveal, skip, short landscape layout, actual readiness wait, reduced motion, rerun and mid-animation cleanup (mocked)"
