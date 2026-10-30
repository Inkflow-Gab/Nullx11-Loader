-- Development-only deterministic checks. Production and runtime diagnostic contain no mocks.
local pending = {}
task.delay = function(seconds, callback)
	table.insert(pending, { At = clock + seconds, Callback = callback })
end
local frame = advance
advance = function(dt)
	frame(dt)
	local again = true
	while again do
		again = false
		for index = #pending, 1, -1 do
			if pending[index].At <= clock then
				local callback = table.remove(pending, index).Callback
				callback()
				again = true
			end
		end
	end
end
runLoader()
local root = find("SafeArea")
root.AbsoluteSize = Vector2.new(1000, 800)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
find("Load").Activated:Fire()
local panel = find("Panel")
local originalPosition = panel.Position
assert(find("Title").TextSize >= 21, "larger title")
find("Minimize").Activated:Fire()
assert(panel.Visible, "window remains mounted during suction")
advance(0.1)
find("RestoreNullx11").Activated:Fire()
advance(0.5)
assert(
	panel.Visible and panel.Position.X == originalPosition.X,
	"rapid reversal cancels stale hide callback"
)
find("Minimize").Activated:Fire()
advance(0.5)
assert(
	not panel.Visible and find("RestoreNullx11").Visible,
	"suctions into persistent dock"
)
find("RestoreNullx11").Activated:Fire()
advance(0.5)
assert(panel.Visible, "ejects from dock")
find("Visuals window").Activated:Fire()
root.AbsoluteSize = Vector2.new(700, 320)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	find("VisualsWindow").Size.Y <= 296,
	"resize settles then clamps portal animation"
)
find("HideVisuals").Activated:Fire()
assert(find("VisualsWindow").Visible, "secondary windows also animate closing")
advance(0.5)
assert(not find("VisualsWindow").Visible, "secondary close finishes")
find("TabStyle").Activated:Fire()
find("QuickFont_Pixel").Activated:Fire()
assert(find("Title").Font == Enum.Font.Arcade, "native pixel display font")
assert(
	find("DesignTypeBody").Font == Enum.Font.Gotham,
	"body stays readable in pixel style"
)
find("QuickFont_Medieval").Activated:Fire()
assert(
	find("Title").Font == Enum.Font.GrenzeGotisch,
	"native medieval-style display font"
)
find("QuickFont_Gotham").Activated:Fire()
assert(
	find("Title").Font == Enum.Font.Code,
	"modern preserves technical monospace"
)
find("QuickLook_Pixel").Activated:Fire()
assert(find("Title").Font == Enum.Font.Arcade, "Aurora / Pixel signature look")
find("QuickLook_Citadel").Activated:Fire()
assert(
	find("Title").Font == Enum.Font.GrenzeGotisch,
	"Citadel / Gothic signature look"
)
-- Library requests are explicit, bounded, atomic and repository-relative.
find("TabTools").Activated:Fire()
local requests, ran, compiled = {}, 0, 0
local manifest = { Version = 1, Scripts = {} }
jsonDocuments.catalog = manifest
game.PlaceId = 999
game.HttpGet = function(self, url)
	table.insert(requests, url)
	if string.find(url, "manifest.json", 1, true) then
		return "catalog"
	end
	assert(
		string.find(url, "/scripts/demo.luau", 1, true),
		"only repository-relative script URL"
	)
	return "return 'reviewed test source'"
end
loadstring = function(source, name)
	assert(
		source == "return 'reviewed test source'"
			and string.find(name, "demo.luau", 1, true)
	)
	compiled += 1
	return function()
		ran += 1
	end
end
find("Scripts window").Activated:Fire()
assert(#requests == 0, "opening library does not fetch or execute")
find("RefreshScripts").Activated:Fire()
assert(
	#requests == 1
		and string.find(find("ScriptsStatus").Text, "0 published", 1, true),
	"real empty manifest state"
)
manifest.Scripts = {
	{
		Id = "demo",
		Name = "Demo",
		Description = "Reviewed test fixture",
		File = "demo.luau",
		PlaceIds = {},
	},
	{
		Id = "elsewhere",
		Name = "Other place",
		Description = "Not for this place",
		File = "other.luau",
		PlaceIds = { 123 },
	},
}
find("RefreshScripts").Activated:Fire()
local row = find("ScriptEntry_demo")
assert(
	not row.Parent:FindFirstChild("ScriptEntry_elsewhere"),
	"place filtering"
)
local run = find("RunScript_demo")
local before = #requests
run.Activated:Fire()
assert(ran == 0 and #requests == before, "first tap only confirms")
run.Activated:Fire()
assert(
	ran == 1 and compiled == 1 and #requests == before + 1,
	"second tap downloads, compiles, and invokes"
)
manifest.Scripts[1].File = "../escape.luau"
find("RefreshScripts").Activated:Fire()
assert(
	not row.Destroyed
		and string.find(find("ScriptsStatus").Text, "Refresh failed", 1, true),
	"malformed manifest retains previous library atomically"
)
manifest.Scripts[1].File = "demo.luau"
find("RefreshScripts").Activated:Fire()
assert(row.Destroyed, "refresh replaces old rows")
before = #requests
run.Activated:Fire()
run.Activated:Fire()
assert(#requests == before, "destroyed rows have no remaining run callbacks")
find("ScriptsSearch").Text = "no-match"
find("ScriptsSearch"):GetPropertyChangedSignal("Text"):Fire()
assert(
	string.find(find("ScriptsEmptyState").Text, "No scripts match", 1, true),
	"plain-text library search"
)
find("ScriptsSearch").Text = ""
find("ScriptsSearch"):GetPropertyChangedSignal("Text"):Fire()
-- Auto really steers without a held input; Hold remains separately selectable.
find("Aim window").Activated:Fire()
inputService.TouchEnabled = false
local targetRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
targetRoot.Name = "Torso"
camera.CFrame = transform(Vector3.zero)
find("Enable aim assist").Activated:Fire()
advance(0.03)
assert(
	camera.CFrame.AimPoint == enemy.Character:FindFirstChild("Head").Position,
	"default Auto tracks real player records without RMB; torso fallback"
)
assert(
	find("MobileAimPad").Visible and find("HoldMobileAim").Text == "STOP AUTO",
	"pad does not depend on touch detection"
)
assert(find("AimFOVCircle").Visible, "enabling aim shows its actual radius")
find("CheckAimRuntime").Activated:Fire()
local liveDetails = find("AimRuntimeDetails").Text
advance(0.03)
assert(
	string.find(liveDetails, "LIVE", 1, true)
		and find("AimRuntimeDetails").Text == liveDetails,
	"actual runtime report stays readable after frame status updates"
)

find("CycleAimActivation").Activated:Fire()
local stopped = camera.CFrame
advance(0.03)
assert(camera.CFrame == stopped, "Hold mode waits for explicit held input")
find("CycleAimActivation").Activated:Fire()
camera.CameraType = Enum.CameraType.Scriptable
advance(0.03)
assert(
	camera.CFrame == stopped,
	"scripted cameras paused unless explicitly overridden"
)
find("Scripted camera override").Activated:Fire()
advance(0.03)
assert(
	camera.CFrame ~= stopped,
	"explicit scripted-camera override is functional"
)
find("EnterAimView").Activated:Fire()
advance(0.5)
assert(
	not panel.Visible
		and not find("AimWindow").Visible
		and find("AimFOVCircle").Visible,
	"play view folds controls without disabling effects"
)
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.End }, false)
-- A native binding failure uses a real event fallback; an update error stops effects.
local bind = runService.BindToRenderStep
runService.BindToRenderStep = function()
	error("binding denied in test runtime")
end
find("Enable aim assist").Activated:Fire()
camera.CFrame = transform(Vector3.zero)
advance(0.03)
assert(
	camera.CFrame.AimPoint,
	"RenderStepped fallback executes when binding unavailable"
)
local project = camera.WorldToViewportPoint
camera.WorldToViewportPoint = function()
	error("projection unavailable")
end
advance(0.03)
assert(
	string.find(find("AimStatus").Text, "Runtime error", 1, true),
	"render errors surface instead of silently breaking"
)
camera.WorldToViewportPoint = project
runService.BindToRenderStep = bind
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.End }, false)
find("RestoreNullx11").Activated:Fire()
advance(0.5)
find("Close").Activated:Fire()
assert(not find("Nullx11Loader").Destroyed, "close animates before teardown")
advance(0.5)
assert(
	panel.Destroyed and next(runService.RenderBindings) == nil,
	"animated teardown releases callbacks"
)
return "PASS: portal lifetime/reversal/resize, readable native display fonts, explicit library fetch/validation/search/confirmation/cleanup, Auto/Hold, root fallback, camera override, play view, render fallback/error reporting (development API doubles only)"
