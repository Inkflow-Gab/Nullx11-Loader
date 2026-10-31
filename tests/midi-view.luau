-- Shipped bespoke view under a structural UI double. No rendering/animation
-- smoothness claim. Delays use a real queued fixture, not inline completion.
-- @MIDI_UI_RUNTIME
local UDim2 = midiUDim2
services.CoreGui = Instance.new("CoreGui")
local hooks, connections = {}, {}
local context = { Alive = true, ReducedMotion = false, Library = {} }
function context.Library:Unload()
	if not context.Alive then
		return
	end
	context.Alive = false
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	for _, callback in ipairs(hooks) do
		callback()
	end
end
function context.Connect(event, callback)
	local connection = event:Connect(function(...)
		if context.Alive then
			callback(...)
		end
	end)
	table.insert(connections, connection)
	return connection
end
function context.RegisterCleanup(callback)
	table.insert(hooks, callback)
end
-- @MIDI_OUTPUT
context.MidiOutput = makeViewOutput({}, nil, Enum.KeyCode, game)
-- @MIDI_VIEW
local view = makeAutoPlayerView(context)
assert(view.Page == "Library" and #view.Bars == 72 and view.Settings.arm)
assert(view.Keys[60]:FindFirstChild("Binding").Text == "t")
assert(find("TryPianoKey37").Text == "C#2 / Shift+1")
assert(find("TryPianoKey60").Text == "C4 / t")
local testPitch, backend
view.Actions.testnote = function(pitch)
	testPitch = pitch
end
view.Actions.backend = function(mode)
	backend = mode
end
find("TryPianoKey61").Activated:Fire()
assert(testPitch == 61)
find("BackendVK").Activated:Fire()
assert(backend == "VK")
local safe = find("SafeArea")
safe.AbsoluteSize = Vector2.new(1000, 740)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
local panel = find("AutoPlayerPanel")
assert(
	panel.ClassName == "Frame" and panel.Visible,
	"main controls never depend on off-screen group rendering"
)
assert(find("LoadingStage").ClassName == "Frame")
stepUI(0.56)
assert(
	not find("LoadingStage").Visible and not find("LoadingStage").Active,
	"standalone opening removes its input blocker without a scan"
)
assert(panel.Size.X.Offset <= 960 and panel.Size.Y.Offset <= 680)
assert(
	panel.Position.X.Offset == 500 and panel.Position.Y.Offset == 370,
	"player opens in the true viewport center"
)
assert(
	view.Holder.Position.X.Offset == 500,
	"mini holder starts bottom-center, not in a corner"
)
local placement = view.Placement()
assert(placement.Panel.X == 0.5 and placement.Panel.Y == 0.5)
view.Center()
assert(panel.Position.X.Offset == 500)
local entries = {}
for index = 1, 24 do
	entries[index] = {
		Name = "Song " .. index,
		Path = "MIDI/" .. index .. ".mid",
		Folder = "MIDI",
	}
end
view.Files(entries, entries[1].Path, false, 1, 2)
local count = #objects
view.Files(entries, entries[1].Path, false, 1, 2)
assert(#objects == count, "24 browser rows are pooled")
local selected
view.Actions.select = function(entry)
	selected = entry
end
find("SongRow3").Activated:Fire()
assert(selected.Path == entries[3].Path)
view.Tracks({ { Index = 1, Name = "Piano", Notes = 30 } }, {})
count = #objects
view.Tracks({ { Index = 1, Name = "Piano", Notes = 30 } }, { true })
assert(
	#objects == count and find("Track1").Text == "MUTED",
	"track rows reuse controls/connections"
)
context.MidiOutput.Mode88 = true
view.Keyboard(true)
local keyCount = 0
for _ in pairs(view.Keys) do
	keyCount += 1
end
assert(keyCount == 88)
local score = {
	Duration = 1,
	Tracks = {},
	Notes = {
		{
			Id = 1,
			Pitch = 60,
			Velocity = 100,
			Start = 0,
			End = 1,
			RawEnd = 0.5,
			Track = 1,
			Channel = 0,
		},
	},
	Tempos = { { Time = 0, BPM = 120 } },
}
view.Score(score, "Actual snapshot fixture")
local playback = {
	Position = 0.2,
	State = "Playing",
	Score = score,
	Active = { [1] = 60 },
	Armed = true,
	Preview = false,
	Muted = {},
	Drums = false,
	MinimumVelocity = 1,
	Transpose = 0,
	Sustain = true,
	Gate = 1,
	Speed = 1,
	Dropped = 0,
}
local output = {
	Mode88 = true,
	Map = function(pitch)
		return { Pitch = pitch }
	end,
}
view.Snapshot(playback, output)
assert(view.Bars[1].Visible and find("Clock").Text == "00:00 / 00:01")
assert(view.Bars[1].Position.X.Scale == view.KeyGeometry[60].X)
playback.Gate = 0.1
playback.Sustain = false
view.Snapshot(playback, output)
assert(
	not view.Bars[1].Visible,
	"roll honors the effective sustain/gate settings"
)
view.Loading(true, "Reading selected file")
assert(find("LoadingStage").Visible)
view.Loading(false)
assert(
	find("LoadingStage").Visible,
	"fast reads do not produce a one-frame flash"
)
stepUI(0.19)
assert(not find("LoadingStage").Visible and not find("LoadingStage").Active)
-- A delayed completion from the previous operation cannot hide a new one.
view.Loading(true, "First read")
view.Loading(false)
view.Loading(true, "Replacement read")
stepUI(0.2)
assert(find("LoadingStage").Visible)
find("HideLoading").Activated:Fire()
assert(not find("LoadingStage").Visible and not find("LoadingStage").Active)
view.Loading(true, "Decoding same operation")
assert(
	not find("LoadingStage").Visible,
	"phase updates respect manual dismissal"
)
view.Loading(false)
stepUI(0.2)
view.Loading(true, "New read", 1)
assert(find("LoadingStage").Visible)
find("HideLoading").Activated:Fire()
view.Loading(true, "Replacement operation", 2)
assert(
	find("LoadingStage").Visible,
	"a new operation can show its own real loading stage"
)
view.Loading(false)
stepUI(0.2)
-- Even a refused tween cannot leave a transparent/black inaccessible window.
local createTween = tweenService.Create
tweenService.Create = function()
	error("fixture tween denied")
end
view.SetVisible(false)
view.SetVisible(true)
assert(panel.Visible and find("UIScale").Scale == 1)
view.Loading(true, "No tween backend")
view.Loading(false)
stepUI(0.2)
assert(not find("LoadingStage").Visible)
tweenService.Create = createTween
view.SetPage("Settings")
assert(find("Settings").Visible and not find("SongRail").Visible)
view.SetVisible(false)
assert(find("PianoDock").Visible and not panel.Visible)
find("PianoDock").Activated:Fire()
assert(view.Visible and panel.Visible)
-- Portrait library leaves at least one actual selectable row, unlike a fake
-- list whose header consumes the entire compact rail height.
safe.AbsoluteSize = Vector2.new(390, 640)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	find("SongRail").Size.Y.Offset >= 184
		and find("PooledWaterfall").Size.Y.Offset == -94
)
-- Short landscape uses the compact visualization rather than negative heights.
safe.AbsoluteSize = Vector2.new(740, 360)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	find("PooledWaterfall").Size.Y.Offset == -70
		and not find("StageTag").Visible
)
assert(find("PanicInput"), "touch emergency stop is available")
assert(find("TestInput"), "touch-accessible C4 input test exists in settings")
view.Actions.unload = function()
	context.Library:Unload()
end
find("Unload").Activated:Fire()
assert(view.Gui.Destroyed and not view.Alive)
stepUI(2)
assert(view.Gui.Destroyed, "delayed work cannot resurrect an unloaded GUI")
for _, connection in ipairs(connections) do
	assert(not connection.Connected)
end
return "PASS: actual Auto Player view: custom native controls, finite opening/loading transitions, static dock, pooled 24-file/72-note/64-track UI, portrait/landscape layouts, piano mapping, hidden restore and owned disposal (structural doubles only)"
