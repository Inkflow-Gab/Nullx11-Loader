-- Actual parser/files/output/transport and controller under deterministic API
-- doubles. Synthesized binary MIDI fixtures are test data, never shipped songs.
-- @MIDI_MODULES
local function be(value, size)
	local bytes = {}
	for index = size, 1, -1 do
		bytes[index] = string.char(value % 256)
		value = math.floor(value / 256)
	end
	return table.concat(bytes)
end
local function vlq(value)
	local bytes = { value % 128 }
	value = math.floor(value / 128)
	while value > 0 do
		table.insert(bytes, 1, value % 128 + 128)
		value = math.floor(value / 128)
	end
	for index, byte in ipairs(bytes) do
		bytes[index] = string.char(byte)
	end
	return table.concat(bytes)
end
local function event(delta, ...)
	return vlq(delta) .. string.char(...)
end
local function midi(tracks, division, format)
	local bytes = "MThd"
		.. be(6, 4)
		.. be(format or (#tracks == 1 and 0 or 1), 2)
		.. be(#tracks, 2)
		.. be(division or 480, 2)
	for _, track in ipairs(tracks) do
		track ..= event(0, 255, 47, 0)
		bytes ..= "MTrk" .. be(#track, 4) .. track
	end
	return bytes
end
local simple = midi({ event(0, 144, 60, 100) .. event(480, 128, 60, 0) })
local score = MidiParser.Parse(simple)
assert(
	#score.Notes == 1 and score.Notes[1].Pitch == 60 and score.Duration == 0.5
)
local tempoScore = MidiParser.Parse(midi({
	event(480, 255, 81, 3, 15, 66, 64),
	event(0, 144, 60, 100)
		.. event(480, 128, 60, 0)
		.. event(0, 144, 64, 90)
		.. event(480, 128, 64, 0),
}))
assert(
	tempoScore.Notes[1].End == 0.5
		and tempoScore.Notes[2].Start == 0.5
		and tempoScore.Notes[2].End == 1.5,
	"default tempo is 120, not the last tempo encountered in another track"
)
local sustained = MidiParser.Parse(midi({
	event(0, 144, 60, 100)
		.. event(120, 176, 64, 127)
		.. event(120, 128, 60, 0)
		.. event(720, 176, 64, 0),
}))
assert(sustained.Notes[1].RawEnd == 0.25 and sustained.Notes[1].End == 1)
local channels = MidiParser.Parse(midi({
	event(0, 144, 60, 100)
		.. event(0, 145, 60, 90)
		.. event(240, 128, 60, 0)
		.. event(240, 129, 60, 0),
}))
assert(
	#channels.Notes == 2
		and channels.Notes[1].End == 0.25
		and channels.Notes[2].End == 0.5
)
local repeated = MidiParser.Parse(midi({
	event(0, 144, 60, 100)
		.. event(120, 60, 90)
		.. event(120, 128, 60, 0)
		.. event(120, 60, 0),
}))
assert(
	#repeated.Notes == 2
		and repeated.Notes[1].End == 0.25
		and repeated.Notes[2].End == 0.375,
	"running status and FIFO overlapping note-off pairing"
)
local allOff = MidiParser.Parse(midi({
	event(0, 144, 60, 100)
		.. event(240, 176, 123, 0)
		.. event(0, 144, 60, 90)
		.. event(240, 128, 60, 0),
}))
assert(allOff.Notes[1].End == 0.25 and allOff.Notes[2].End == 0.5)
local sysex = MidiParser.Parse(midi({
	event(0, 240, 3, 1, 2, 3) .. event(0, 144, 60, 100) .. event(480, 60, 0),
}))
assert(#sysex.Notes == 1)
for _, bytes in ipairs({
	"",
	"not a midi file at all",
	simple:sub(1, #simple - 3),
	midi({ "" }, 0),
	midi({ "" }, 32768),
	midi({ "" }, 480, 2),
	midi({ event(0, 255, 81, 3, 0, 0, 0) }),
	midi({ event(0, 60, 100) }),
	midi({ string.char(255, 255, 255, 255, 0) }),
}) do
	assert(
		not pcall(MidiParser.Parse, bytes),
		"malformed/unsupported MIDI must fail clearly"
	)
end
-- Work and file-size limits are actual parser constants, not UI promises.
assert(
	not pcall(MidiParser.Parse, simple .. string.rep("\0", MidiParser.MaxBytes))
)
local checkpointCount = 0
local many = {}
for _ = 1, 1025 do
	table.insert(many, event(0, 144, 60, 100) .. event(1, 128, 60, 0))
end
MidiParser.Parse(midi({ table.concat(many) }), function()
	checkpointCount += 1
end)
assert(checkpointCount >= 2)
assert(not pcall(MidiParser.Parse, midi({ table.concat(many) }), function()
	error("cancelled")
end))
-- Files: exact requested path, blocked-absolute fallback, direct/nested songs,
-- lowercase suffixes, duplicate names, traversal/outside-root rejection, limits.
local listings = {
	MIDI = {
		"MIDI/a.mid",
		"MIDI/b.MIDI",
		"MIDI/a.mid",
		"MIDI/sub",
		"../escape.mid",
		"MIDI/fake.lua",
		"/outside.mid",
	},
	["MIDI/sub"] = { "MIDI/sub/a.mid", "MIDI/sub/c.smf" },
}
local listCalls = {}
local api = {
	List = function(path)
		table.insert(listCalls, path)
		assert(listings[path], "denied")
		return listings[path]
	end,
	Read = function()
		return simple
	end,
	IsFolder = function(path)
		return listings[path] ~= nil
	end,
}
local entries, info = MidiFiles.Scan(api, MidiFiles.AndroidRoot .. "/", true)
assert(
	#entries == 4
		and info.Fallback
		and info.Root == "MIDI"
		and listCalls[1] == MidiFiles.AndroidRoot
)
assert(entries[1].Path ~= entries[2].Path and info.Skipped >= 2)
local flat = MidiFiles.Scan(api, "MIDI", false)
assert(#flat == 2)
local absolute = MidiFiles.Scan({
	List = function()
		return { MidiFiles.AndroidRoot .. "/song.mid" }
	end,
	Read = function() end,
}, "MIDI", false)
assert(#absolute == 1)
for _, path in ipairs({
	"",
	"../MIDI",
	"MIDI/../x",
	"https://host/MIDI",
	"/",
	"MIDI\0evil",
}) do
	assert(not pcall(MidiFiles.Normalize, path))
end
assert(not pcall(MidiFiles.Scan, {}, "MIDI", false))
local excessive = {}
for index = 1, 600 do
	excessive[index] = "MIDI/" .. index .. ".mid"
end
local limited, capped = MidiFiles.Scan({
	List = function()
		return excessive
	end,
	Read = function() end,
}, "MIDI", false)
assert(#limited == 512 and capped.Capped)
-- Input: 61/88 maps, shared physical-key references, modifiers, rejected API
-- recovery, and retained failed releases so a later panic can retry them.
local keyCodes = setmetatable({}, {
	__index = function(self, key)
		local value = { Name = key, Value = key }
		self[key] = value
		return value
	end,
})
local keys, failUp, failDown = {}, false, false
local environment = {
	keypress = function(key)
		table.insert(keys, { Down = true, Key = key })
		if failDown then
			error("down refused")
		end
	end,
	keyrelease = function(key)
		table.insert(keys, { Down = false, Key = key })
		if failUp then
			error("up refused")
		end
	end,
}
local output = MakeMidiOutput(environment, nil, keyCodes, {})
assert(
	output.Available()
		and output.Map(36).Key == keyCodes.One
		and output.Map(60).Key == keyCodes.T
		and output.Map(96).Key == keyCodes.M
)
assert(output.Map(37).Modifier == keyCodes.LeftShift)
output.Fold = false
assert(output.Map(20) == nil)
output.Mode88 = true
assert(
	output.Map(21).Modifier == keyCodes.LeftControl
		and output.Map(108).Key == keyCodes.J
)
output.On(1, 60)
output.On(2, 60)
output.Off(1)
assert(output.References[keyCodes.T] == 1)
output.Off(2)
assert(next(output.References) == nil)
output.On(3, 37)
assert(next(output.Modifiers) == nil)
output.ReleaseAll()
assert(next(output.Held) == nil)
failDown = true
assert(not pcall(output.On, 4, 60))
assert(next(output.Held) == nil)
failDown = false
output.On(5, 60)
failUp = true
assert(not pcall(output.Off, 5) and output.References[keyCodes.T])
assert(
	not output.ReleaseAll()
		and output.LastReleaseFailures > 0
		and output.Held[5]
)
failUp = false
assert(
	output.ReleaseAll()
		and output.LastReleaseFailures == 0
		and next(output.Held) == nil
)
local unavailable = MakeMidiOutput({}, nil, keyCodes, {})
assert(not unavailable.Available() and not pcall(unavailable.On, 1, 60))
-- Transport: exact clock speed, release on pause/seek/stop, explicit arm/preview,
-- gate/sustain, filters, A-B loop, lag skip/backpressure, no replay burst.
local now = 0
local transport = MakeMidiTransport(output, function()
	return now
end)
transport.Load(score)
assert(not transport.Armed and not pcall(transport.Play))
transport.Armed = true
transport.Play()
transport.Tick()
assert(output.Held[1])
now = 0.2
transport.Tick()
transport.Pause()
assert(transport.Position == 0.2 and next(output.Held) == nil)
transport.SetSpeed(2)
transport.Play()
now += 0.1
transport.Tick()
assert(math.abs(transport.Position - 0.4) < 0.000001)
transport.Seek(0.1)
assert(next(output.Held) == nil)
transport.Stop()
assert(transport.Position == 0 and next(output.Held) == nil)
transport.Preview = true
transport.Armed = false
local before = #keys
transport.Play()
transport.Tick()
assert(#keys == before and transport.Active[1] == 60)
transport.Stop()
transport.Load(sustained)
transport.Sustain = false
transport.Rebuild()
transport.Preview = false
transport.Armed = true
transport.Play()
transport.Tick()
now += 0.26
transport.Tick()
assert(next(output.Held) == nil)
transport.Stop()
transport.Load(score)
transport.Loop = true
transport.LoopA = 0.1
transport.LoopB = 0.3
transport.Play()
now += 0.31
transport.Tick()
assert(transport.State == "Playing" and transport.Position == 0.1)
transport.Loop = false
transport.Stop()
transport.Play()
transport.Tick()
now += 1
transport.Tick()
assert(
	transport.State == "Finished"
		and next(output.Held) == nil
		and transport.Dropped > 0
)
transport.Muted[1] = true
transport.Rebuild()
assert(transport.EventCount == 0 and not pcall(transport.Play))
transport.Destroy()
assert(transport.State == "Destroyed" and next(output.Held) == nil)
-- Dense files are bounded instead of dispatching an unbounded catch-up chord.
local dense = { Duration = 1, Notes = {} }
for index = 1, 140 do
	table.insert(dense.Notes, {
		Id = index,
		Pitch = 60,
		Track = 1,
		Channel = 0,
		Velocity = 100,
		Start = 0,
		End = 1,
		RawEnd = 1,
	})
end
local densePlayer = MakeMidiTransport(output, function()
	return now
end)
densePlayer.Load(dense)
densePlayer.Armed = true
densePlayer.Play()
densePlayer.Tick()
assert(
	densePlayer.Dropped > 0 and next(output.Held) == nil,
	"128-event guard releases and skips the backlog"
)
densePlayer.Destroy()
-- Actual controller with asynchronous local operations and a UI boundary double.
local threads, cancelled = {}, {}
local task = {}
function task.defer(callback)
	local thread = coroutine.create(callback)
	table.insert(threads, { Thread = thread, Wake = now })
	return thread
end
function task.cancel(thread)
	cancelled[thread] = true
end
function task.wait(duration)
	return coroutine.yield(duration or 0)
end
function task.delay(duration, callback)
	return task.defer(function()
		task.wait(duration)
		callback()
	end)
end
local function step(duration)
	now += duration or 0
	local count = #threads
	for index = 1, count do
		local entry = threads[index]
		if
			not cancelled[entry.Thread]
			and coroutine.status(entry.Thread) ~= "dead"
			and entry.Wake <= now
		then
			local ok, delay = coroutine.resume(entry.Thread)
			assert(ok, tostring(delay))
			entry.Wake = now + (delay or 0)
		end
	end
end
local os = {
	clock = function()
		return now
	end,
}
local function signal()
	local callbacks = {}
	return {
		Connect = function(_, callback)
			local connection = { Connected = true }
			function connection:Disconnect()
				self.Connected = false
			end
			table.insert(callbacks, { connection, callback })
			return connection
		end,
		Fire = function(_, ...)
			for _, item in ipairs(callbacks) do
				if item[1].Connected then
					item[2](...)
				end
			end
		end,
	}
end
local input = {
	InputBegan = signal(),
	TextBoxFocused = signal(),
	WindowFocusReleased = signal(),
}
function input:GetFocusedTextBox()
	return self.Focus
end
local heartbeat = signal()
local game = {
	GetService = function(_, name)
		if name == "UserInputService" then
			return input
		elseif name == "RunService" then
			return { Heartbeat = heartbeat }
		else
			error("VIM unavailable in fixture")
		end
	end,
}
local Enum = { KeyCode = keyCodes }
local keypress, keyrelease = environment.keypress, environment.keyrelease
local listfiles = api.List
local blocked, reads = false, 0
local readfile = function()
	reads += 1
	while blocked do
		task.wait()
	end
	return simple
end
local isfolder = api.IsFolder
local warn = function() end
local fakeView
local function makeView()
	local view =
		{ Actions = {}, Settings = {}, Page = "Library", LoadingPhases = {} }
	for _, name in ipairs({
		"arm",
		"preview",
		"sustain",
		"drums",
		"mode88",
		"fold",
		"loop",
		"advance",
		"recursive",
		"motion",
	}) do
		view.Settings[name] = function(value)
			view[name] = value
		end
	end
	function view.Message(text, bad)
		view.LastMessage = text
		view.Bad = bad
	end
	function view.Loading(visible, phase)
		table.insert(view.LoadingPhases, { visible, phase })
	end
	function view.Files(rows)
		view.Rows = rows
	end
	function view.Score(loaded, name)
		view.Loaded = loaded
		view.Name = name
	end
	function view.Snapshot()
		view.Renders = (view.Renders or 0) + 1
	end
	function view.Tracks() end
	function view.Keyboard() end
	function view.Dispatch(action, ...)
		local ok, reason = pcall(view.Actions[action], ...)
		if not ok then
			view.Message(reason, true)
		end
	end
	fakeView = view
	return view
end
local context = {
	Alive = true,
	MidiFiles = MidiFiles,
	MidiParser = MidiParser,
	MakeMidiOutput = MakeMidiOutput,
	MakeMidiTransport = MakeMidiTransport,
	MakeAutoPlayerView = makeView,
	Hooks = {},
	Connections = {},
}
context.Library = {}
function context.Library:Unload()
	context.Alive = false
	for _, connection in ipairs(context.Connections) do
		connection:Disconnect()
	end
	for _, callback in ipairs(context.Hooks) do
		callback()
	end
end
function context.Connect(event, callback)
	local connection = event:Connect(function(...)
		if context.Alive then
			callback(...)
		end
	end)
	table.insert(context.Connections, connection)
	return connection
end
function context.RegisterCleanup(callback)
	table.insert(context.Hooks, callback)
end
-- @MIDI_CONTROLLER
local controller = runAutoPlayer(context)
step(0)
step(0)
assert(
	#fakeView.Rows == 4 and reads == 0 and not controller.Transport.Armed,
	"scan on open does not read/play a song"
)
fakeView.Dispatch("select", fakeView.Rows[1])
step(0)
step(0)
assert(reads == 1 and fakeView.Loaded and controller.Transport.State == "Ready")
fakeView.Dispatch("play")
assert(controller.Transport.State == "Ready" and fakeView.Bad)
fakeView.Dispatch("delay", "0")
fakeView.Dispatch("arm", true)
fakeView.Dispatch("play")
heartbeat:Fire()
assert(controller.Transport.State == "Playing" and next(controller.Output.Held))
input.TextBoxFocused:Fire()
assert(
	controller.Transport.State == "Paused"
		and next(controller.Output.Held) == nil
)
fakeView.Dispatch("enqueue")
fakeView.Dispatch("favorite")
fakeView.Dispatch("tab", "Queue")
fakeView.Dispatch("preview", true)
fakeView.Dispatch("play")
local count = #keys
heartbeat:Fire()
assert(#keys == count)
input.InputBegan:Fire({ KeyCode = keyCodes.F7 }, true)
assert(not controller.Transport.Armed and controller.Transport.Position == 0)
-- Late/blocked file operation is cancelled by a replacement and by unload.
blocked = true
fakeView.Dispatch("select", fakeView.Rows[1])
step(0)
step(0)
local firstRead = reads
fakeView.Dispatch("refresh")
step(0)
step(0)
blocked = false
step(0)
step(0)
assert(
	reads == firstRead,
	"old read thread is cancelled, not resumed into a stale load"
)
fakeView.Dispatch("select", fakeView.Rows[1])
step(0)
step(0)
fakeView.Dispatch("preview", false)
fakeView.Dispatch("arm", true)
fakeView.Dispatch("play")
heartbeat:Fire()
context.Library:Unload()
assert(
	controller.Transport.State == "Destroyed"
		and next(controller.Output.Held) == nil
)
heartbeat:Fire()
assert(controller.Transport.State == "Destroyed")
return "PASS: actual MIDI decoder (formats/tempo/CC64/running status/channels/bounds/cancellation), scoped filesystem scan, 61/88-key output/refcounts/modifier/error releases, clock transport/arm/preview/loops/lag/filters, and real async controller (local selection, focus pause, stale reads, independent cleanup); development doubles, not native piano proof"
