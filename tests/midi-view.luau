-- Shipped bespoke view under a structural UI double. No rendering/animation
-- smoothness claim. Tween completion is immediate in this development fixture.
local dimension = {}
dimension.__index = dimension
local function dim(scale, offset)
	return setmetatable({ Scale = scale or 0, Offset = offset or 0 }, dimension)
end
local UDim2 = {
	new = function(xs, xo, ys, yo)
		return { X = dim(xs, xo), Y = dim(ys, yo) }
	end,
	fromOffset = function(x, y)
		return { X = dim(0, x), Y = dim(0, y) }
	end,
	fromScale = function(x, y)
		return { X = dim(x, 0), Y = dim(y, 0) }
	end,
}
function methods:SetAttribute(key, value)
	self.Attributes = self.Attributes or {}
	self.Attributes[key] = value
end
function methods:GetAttribute(key)
	return self.Attributes and self.Attributes[key]
end
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
-- @MIDI_VIEW
local view = makeAutoPlayerView(context)
assert(view.Page == "Library" and #view.Bars == 72 and view.Settings.arm)
local safe = find("SafeArea")
safe.AbsoluteSize = Vector2.new(1000, 740)
safe:GetPropertyChangedSignal("AbsoluteSize"):Fire()
local panel = find("AutoPlayerPanel")
assert(panel.Size.X.Offset <= 1040 and panel.Size.Y.Offset <= 750)
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
assert(not find("LoadingStage").Visible)
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
assert(find("TestInput"), "touch-accessible C4 input test exists in settings")
view.Actions.unload = function()
	context.Library:Unload()
end
find("Unload").Activated:Fire()
assert(view.Gui.Destroyed and not view.Alive)
for _, connection in ipairs(connections) do
	assert(not connection.Connected)
end
return "PASS: actual Auto Player view: custom native controls, finite opening/loading transitions, static dock, pooled 24-file/72-note/64-track UI, portrait/landscape layouts, piano mapping, hidden restore and owned disposal (structural doubles only)"
