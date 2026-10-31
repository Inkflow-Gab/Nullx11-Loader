-- Real catalog Run path + generated Auto Player chunk + actual view/controller.
-- Only Roblox/executor IO and time are development doubles, not shipped mocks.
-- @MIDI_UI_RUNTIME
local environment = {}
local getgenv = function()
	return environment
end
local loadstring, listfiles, readfile, isfolder
local failNextPublished = false
local latest, result, failLabel, blockCore = nil, nil, false, true
services.CoreGui = Instance.new("CoreGui")
services.UserInputService.TextBoxFocused = signal()
services.RunService.Heartbeat = signal()
local requests, keys, reads = {}, {}, 0
services.VirtualInputManager = {
	SendKeyEvent = function(_, down, key)
		table.insert(keys, { Down = down, Key = key })
	end,
}
local createInstance = Instance.new
local partial
Instance.new = function(class)
	if failLabel and class == "TextLabel" then
		failLabel = false
		error("fixture child construction failed")
	end
	local object = createInstance(class)
	local meta = getmetatable(object)
	meta.__newindex = function(target, property, value)
		if
			property == "Parent"
			and target.Name == "Nullx11AutoPlayer"
			and value == services.CoreGui
			and blockCore
		then
			error("fixture CoreGui parenting denied")
		end
		rawset(target, property, value)
	end
	if class == "ScreenGui" then
		partial = object
	end
	return object
end
local function runPublishedAutoPlayer()
	local UDim2 = midiUDim2
	-- @PUBLISHED_AUTO_PLAYER
end
-- @EXECUTION_FIXTURE
local function executionFactory(title)
	latest = Library:BeginExecution(title)
	return latest
end
local function runLoader()
	-- @LOADER
end
jsonDocuments.autoManifest = {
	Version = 1,
	Scripts = { -- @AUTO_ENTRY
	},
}
local midiTrack =
	string.char(0, 0x90, 60, 100, 0x83, 0x60, 0x80, 60, 0, 0, 0xff, 0x2f, 0)
local midi = "MThd"
	.. string.char(0, 0, 0, 6, 0, 0, 0, 1, 1, 224)
	.. "MTrk"
	.. string.char(0, 0, 0, #midiTrack)
	.. midiTrack
listfiles = function(root)
	return { root .. "/test.mid" }
end
isfolder = function()
	return false
end
readfile = function()
	reads += 1
	return midi
end
game.HttpGet = function(_, url)
	table.insert(requests, url)
	if url:find("manifest.json", 1, true) then
		return "autoManifest"
	end
	assert(
		url:find(
			"/arena/bc7610cd-nullx11-loader/scripts/Nullx11-AutoPlayer.luau",
			1,
			true
		),
		"launcher resolves current published bundle"
	)
	return "published-autoplayer-marker"
end
loadstring = function(source, name)
	assert(
		source == "published-autoplayer-marker"
			and name == "Nullx11Library/Nullx11-AutoPlayer.luau"
	)
	return function()
		failLabel = failNextPublished
		failNextPublished = false
		result = runPublishedAutoPlayer()
		return result
	end
end
runLoader()
find("Load").Activated:Fire()
find("Scripts window").Activated:Fire()
find("RefreshScripts").Activated:Fire()
flushUI()
find("RunScript_autoplayer").Activated:Fire()
find("GameExecute").Activated:Fire()
assert(
	not environment.Nullx11GameSessions,
	"first tap only confirms; no hidden initialization"
)
find("GameExecute").Activated:Fire()
flushUI()
assert(result and result.Nullx11Ready and result.View.Alive)
assert(
	result.View.Gui.Parent == playerGui,
	"blocked CoreGui assignment falls back to PlayerGui"
)
assert(
	latest.Closed and latest.Model.Status == "complete",
	"loader sheet immediately hands off to initialized controls"
)
assert(
	reads == 0
		and result.View.Rows[1].Entry ~= nil
		and result.View.Rows[2].Entry == nil,
	"scan does not read or autoplay"
)
local oldView = result.View
local safe = oldView.Panel.Parent
safe.AbsoluteSize = Vector2.new(390, 640)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(oldView.Panel.Visible and oldView.Panel.ClassName == "Frame")
stepUI(0.6)
assert(not find("LoadingStage").Visible and not find("LoadingStage").Active)
find("SongRow1").Activated:Fire()
flushUI()
stepUI(0.2)
assert(
	result.Transport.State == "Ready"
		and reads == 1
		and #result.Transport.Score.Notes == 1
)
assert(find("SongTitle").Text == "test.mid")
-- Every step below goes through real buttons/TextBox FocusLost, not Dispatch.
find("Settings").Activated:Fire()
find("Start delayInput").Text = "0"
find("Start delayInput").FocusLost:Fire()
find("Preview onlyToggle").Activated:Fire()
find("play").Activated:Fire()
services.RunService.Heartbeat:Fire()
assert(
	result.Transport.State == "Playing"
		and result.Transport.Preview
		and #keys == 0
)
find("pause").Activated:Fire()
find("stop").Activated:Fire()
find("PlaybackSpeed").Text = "1.25"
find("PlaybackSpeed").FocusLost:Fire()
find("Transpose").Text = "2"
find("Transpose").FocusLost:Fire()
assert(result.Transport.Speed == 1.25 and result.Transport.Transpose == 2)
find("QueueSelected").Activated:Fire()
find("Favorite").Activated:Fire()
find("Queue").Activated:Fire()
assert(result.View.Page == "Queue" and result.View.Rows[1].Entry)
find("Mixer").Activated:Fire()
find("Track1").Activated:Fire()
assert(result.Transport.Muted[1])
find("Track1").Activated:Fire()
find("Settings").Activated:Fire()
find("Arm piano inputToggle").Activated:Fire()
assert(result.Transport.Armed and not result.Transport.Preview)
find("Keys").Activated:Fire()
assert(result.View.Page == "Keys" and find("TryPianoKey60").Text == "C4 / t")
find("Screenshot61Profile").Activated:Fire()
assert(
	not result.Output.Mode88
		and result.Transport.Transpose == 0
		and find("Transpose").Text == "0"
)
find("BackendVIM").Activated:Fire()
assert(result.Output.Preferred == "VIM")
find("BackendVK").Activated:Fire()
assert(
	result.Output.Preferred == "VIM",
	"an unavailable backend cannot replace the working one"
)
find("TryPianoKey36").Activated:Fire()
find("TryPianoKey37").Activated:Fire()
assert(next(result.Output.Held), "touch key tests send actual input")
stepUI(0.21)
assert(
	next(result.Output.Held) == nil,
	"rapid test notes have independent release identities"
)
find("Settings").Activated:Fire()
find("TestInput").Activated:Fire()
assert(#keys > 0 and keys[#keys].Down)
stepUI(0.21)
assert(not keys[#keys].Down)
find("play").Activated:Fire()
services.RunService.Heartbeat:Fire()
assert(next(result.Output.Held))
find("PanicInput").Activated:Fire()
assert(not result.Transport.Armed and next(result.Output.Held) == nil)
-- Hiding/restoring never restores a blocking loading sheet or stale state.
find("Minimize").Activated:Fire()
find("PianoDock").Activated:Fire()
assert(oldView.Panel.Visible and not find("LoadingStage").Visible)
-- A failed new startup must clean both the prior session and partial GUI,
-- propagate to the loader's error sheet, and never report successful loading.
failNextPublished = true
find("GameExecute").Activated:Fire()
find("GameExecute").Activated:Fire()
flushUI()
assert(latest.Model.Status == "failed" and not latest.Closed)
assert(latest.Model.Detail:find("fixture child construction failed", 1, true))
assert(
	oldView.Gui.Destroyed
		and partial.Destroyed
		and not environment.Nullx11GameSessions.autoplayer
)
find("ExecutionDismiss").Activated:Fire()
-- Can recover by launching again; unloading the loader keeps the player alive.
find("GameExecute").Activated:Fire()
find("GameExecute").Activated:Fire()
flushUI()
stepUI(0.6)
assert(result.View.Alive and latest.Closed)
local remaining = result.View
find("Close").Activated:Fire()
assert(remaining.Alive and not remaining.Gui.Destroyed)
find("Unload").Activated:Fire()
assert(not remaining.Alive and remaining.Gui.Destroyed)
return "PASS: real catalog-to-published Auto Player handoff, actual UI button/file/parse/preview/armed input flow, blocked GUI-parent fallback, startup error cleanup/rethrow, retry and loader-independent lifetime (development APIs only)"
