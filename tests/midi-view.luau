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
assert(find("EmptyPiano").Visible)
view.SetPage("Player")
find("BrowseSongs").Activated:Fire()
assert(view.Page == "Library")
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
assert(not find("EmptyPiano").Visible and find("play").Text == "Pause")
local pausedByPrimary = false
view.Actions.pause = function()
	pausedByPrimary = true
end
find("play").Activated:Fire()
assert(pausedByPrimary, "primary transport toggles Play/Pause")
assert(view.Bars[1].Position.X.Scale == view.KeyGeometry[60].X)
playback.Gate = 0.1
playback.Sustain = false
view.Snapshot(playback, output)
assert(
	not view.Bars[1].Visible,
	"roll honors the effective sustain/gate settings"
)
-- Long-held notes remain in the bounded roll after their first second.
score.Duration, score.Notes[1].End = 5, 5
view.Score(score, "Long chord")
playback.Position, playback.Gate, playback.Sustain = 2, 1, true
view.Snapshot(playback, output)
assert(view.Bars[1].Visible, "long sustained note stays visible")
playback.Gate = 0.1
view.Snapshot(playback, output)
assert(not view.Bars[1].Visible, "expired gated note is excluded")
-- Drag commits exactly one seek, and another finger cannot move it.
local seekBar, seeks, destination = find("SeekBar"), 0, nil
seekBar.AbsolutePosition, seekBar.AbsoluteSize =
	Vector2.new(100, 0), Vector2.new(200, 24)
view.Actions.seek = function(ratio)
	seeks += 1
	destination = ratio
end
local touch =
	{ UserInputType = Enum.UserInputType.Touch, Position = Vector2.new(150, 0) }
seekBar.InputBegan:Fire(touch)
inputService.InputChanged:Fire({
	UserInputType = Enum.UserInputType.Touch,
	Position = Vector2.new(300, 0),
})
assert(find("SeekFill").Size.X.Scale == 0.25 and seeks == 0)
touch.Position = Vector2.new(250, 0)
inputService.InputChanged:Fire(touch)
view.Snapshot(playback, output)
assert(
	find("SeekFill").Size.X.Scale == 0.75,
	"snapshot does not fight dragging"
)
inputService.InputEnded:Fire(touch)
assert(seeks == 1 and destination == 0.75)
local mouse = {
	UserInputType = Enum.UserInputType.MouseButton1,
	Position = Vector2.new(100, 0),
}
seekBar.InputBegan:Fire(mouse)
inputService.InputChanged:Fire({
	UserInputType = Enum.UserInputType.MouseMovement,
	Position = Vector2.new(500, 0),
})
assert(find("SeekFill").Size.X.Scale == 1, "drag clamps to song end")
mouse.Position = Vector2.new(500, 0)
inputService.InputEnded:Fire(mouse)
assert(seeks == 2 and destination == 1)
assert(
	seekBar.Size.Y.Offset >= 24,
	"touch target does not shrink to the thin track"
)
local speedBox = find("PlaybackSpeed")
speedBox.Text = "1.5" -- also covers restored preferences
speedBox.Focused:Fire()
view.Actions.speed = function()
	error("invalid speed")
end
speedBox.Text = "not a number"
speedBox.FocusLost:Fire()
assert(
	speedBox.Text == "1.5",
	"invalid input rolls back to last accepted value"
)
view.Actions.speed = function() end
speedBox.Text = "1.25"
speedBox.FocusLost:Fire()
assert(speedBox.Text == "1.25" and view.Dispatch("speed", "1.25"))
local cancelledOperation = false
view.Actions.cancel = function()
	cancelledOperation = true
	view.Loading(false)
end
view.Loading(true, "Cancelable read")
find("CancelLoading").Activated:Fire()
assert(cancelledOperation)
stepUI(0.2)
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
-- Portrait gives Songs and Piano independent full-size workspaces. Selecting
-- a song changes view, never starts playback or sends input.
view.SetPage("Library")
safe.AbsoluteSize = Vector2.new(390, 640)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(find("SongRail").Visible and not find("PianoStage").Visible)
assert(
	find("SongRail").Size.Y.Scale == 1 and find("SongRail").Size.Y.Offset == 0,
	"portrait no longer squeezes the list above a miniature piano"
)
find("SongRow3").Activated:Fire()
assert(
	view.Page == "Player"
		and find("PianoStage").Visible
		and not find("SongRail").Visible
)
assert(
	find("PianoStage").Size.X.Scale == 1
		and find("PooledWaterfall").Size.Y.Offset == -190
)
assert(
	find("LoopA").Parent.Name == "Practice loop marks",
	"advanced marks are off the transport"
)
assert(
	find("play").Size.X.Offset > find("pause").Size.X.Offset,
	"Play has a clear primary hierarchy"
)
view.SetPage("Library")
assert(find("SongRail").Visible and not find("PianoStage").Visible)
-- Short landscape uses the compact visualization rather than negative heights.
safe.AbsoluteSize = Vector2.new(740, 360)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	find("PooledWaterfall").Size.Y.Offset == -70
		and not find("StageTag").Visible
)
safe.AbsoluteSize = Vector2.new(320, 560)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
local nextControl = find("next")
assert(
	nextControl.Position.X.Offset + nextControl.Size.X.Offset
		<= find("Transport").Size.X.Offset + panel.Size.X.Offset,
	"narrow transport controls stay inside panel"
)
-- Back to desktop restores the two-pane library, including its header geometry.
safe.AbsoluteSize = Vector2.new(1000, 740)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(find("SongRail").Visible and find("PianoStage").Visible)
assert(find("StaticPianoMark").Visible)
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
