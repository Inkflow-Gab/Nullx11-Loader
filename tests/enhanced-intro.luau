runEnhancedLoader()
local intro = find("StartupWhirlpool")
assert(
	intro and intro.Parent.Name == "EnhancedIntroHost",
	"effect must be in actual enhanced host"
)
assert(not find("EnhancedPanel").Visible and not find("EnhancedDock").Visible)
assert(
	intro.Parent.DisplayOrder > 100 and intro.ZIndex > 60,
	"opening above other game GUIs and native notifications"
)
local initial = find("WhirlpoolCenter").Size.X
advance(0.4)
assert(find("WhirlpoolCenter").Size.X < initial)
advance(1.8)
assert(
	intro.Destroyed
		and find("EnhancedPanel").Visible
		and find("EnhancedDock").Visible
)
assert(
	not find("Panel").Visible and not find("RestoreNullx11").Visible,
	"never reveal classic panel behind enhanced GUI"
)
runEnhancedLoader()
intro = find("StartupWhirlpool")
find("SkipStartup").Activated:Fire()
assert(
	intro.Destroyed
		and find("EnhancedPanel").Visible
		and find("EnhancedDock").Visible
)
assert(
	find("EnhancedIntroHost").DisplayOrder == 100,
	"restore original display order"
)
local loaded = game.IsLoaded
game.IsLoaded = function()
	return false
end
runEnhancedLoader()
intro = find("StartupWhirlpool")
advance(3)
assert(not intro.Destroyed and not find("EnhancedPanel").Visible)
find("SkipStartup").Activated:Fire()
assert(find("EnhancedPanel").Visible)
game.IsLoaded = loaded
runEnhancedReducedLoader()
assert(
	not find("EnhancedIntroHost"):FindFirstChild("StartupWhirlpool")
		and find("EnhancedPanel").Visible,
	"reduced motion keeps direct reveal"
)
runEnhancedLoader()
local old = find("StartupWhirlpool")
runEnhancedLoader()
assert(old.Destroyed, "rerun removes old host/effect")
local active = find("StartupWhirlpool")
find("Close").Activated:Fire()
assert(active.Destroyed)
advance(3)
assert(#warnings == 0)
return "PASS: actual enhanced-path opening effect/bridge: visible host, contraction, native-window/dock reveal, skip, readiness wait, reduced motion, rerun and unload without revealing classic UI (development doubles only)"
