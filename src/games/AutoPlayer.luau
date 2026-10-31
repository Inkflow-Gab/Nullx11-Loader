-- Auto Player / NULL. Local SMF piano edition, not the supplied remote hub.
local files, parser = context.MidiFiles, context.MidiParser
local input = game:GetService("UserInputService")
local environment = { keypress = keypress, keyrelease = keyrelease }
local api = { List = listfiles, Read = readfile, IsFolder = isfolder }
local okVim, vim = pcall(game.GetService, game, "VirtualInputManager")
local output = context.MakeMidiOutput(
	environment,
	okVim and vim or nil,
	Enum.KeyCode,
	game
)
local okJson, json = pcall(game.GetService, game, "HttpService")
local store = context.MakeMidiPreferences(
	{ Read = readfile, Write = writefile, Exists = isfile },
	okJson
			and {
				Encode = function(value)
					return json:JSONEncode(value)
				end,
				Decode = function(text)
					return json:JSONDecode(text)
				end,
			}
		or nil
)
local saved = store.Load()
context.MidiPreferences = saved
local player = context.MakeMidiTransport(output, os.clock)
context.MidiOutput = output
local view = context.MakeAutoPlayerView(context)
local library, queue, favorites = {}, {}, {}
local selected, query, pageNumber = nil, "", 1
local root, recursive, advance, startDelay = files.AndroidRoot, true, false, 2
local generation, operation, countdown, renderAt = 0, nil, nil, 0
local saveSerial, autoArm, restoring, preferencesReady =
	0, saved.AutoArm, true, false
local function saveNow()
	local data = {
		Speed = player.Speed,
		Transpose = player.Transpose,
		Velocity = player.MinimumVelocity,
		Gate = player.Gate,
		Sustain = player.Sustain,
		Drums = player.Drums,
		Mode88 = output.Mode88,
		Fold = output.Fold,
		AutoArm = autoArm,
		Recursive = recursive,
		Advance = advance,
		Motion = view.ReducedMotion,
		Delay = startDelay,
		Backend = output.Preferred,
		Folder = root,
		Selected = selected and selected.Path or saved.Selected,
		Favorites = {},
		Queue = {},
		Muted = {},
		Page = view.Page,
		Loop = player.Loop,
		LoopA = player.LoopA,
		LoopB = player.LoopB,
	}
	for path, favorite in pairs(favorites) do
		if favorite then
			table.insert(data.Favorites, path)
		end
	end
	if restoring then
		data.Favorites = saved.Favorites
		data.Queue = saved.Queue
		data.Muted = saved.Muted
	end
	table.sort(data.Favorites)
	for _, entry in ipairs(queue) do
		table.insert(data.Queue, entry.Path)
	end
	for index, muted in pairs(player.Muted) do
		if muted then
			table.insert(data.Muted, index)
		end
	end
	if view.Placement then
		local positions = view.Placement()
		data.Panel = positions.Panel
		data.Dock = positions.Dock
	end
	store.Save(data)
	if view.Alive and view.Persistence then
		view.Persistence(store.Status)
	end
end
local function requestSave()
	if not preferencesReady then
		return
	end
	saveSerial += 1
	local serial = saveSerial
	task.delay(0.65, function()
		if context.Alive and saveSerial == serial then
			saveNow()
		end
	end)
end
local load

local function current(token)
	return context.Alive and generation == token
end
local function render()
	if context.Alive then
		view.Snapshot(player, output)
	end
end
local function cancelCountdown()
	countdown = nil
end
local function pause()
	cancelCountdown()
	player.Pause()
	render()
end
local function stop()
	cancelCountdown()
	player.Stop()
	render()
end
local function panic()
	cancelCountdown()
	player.Armed = false
	player.Stop()
	output.ReleaseAll()
	view.Settings.arm(false)
	view.Message(
		output.LastReleaseFailures > 0
				and "STOP / input disarmed, but key releases failed. Retry F7 or reset the game piano."
			or "Emergency stop / owned keys released / input disarmed",
		output.LastReleaseFailures > 0
	)
	render()
end
local function rows()
	local source = view.Page == "Queue" and queue or library
	local matches = {}
	local favoritesOnly = query:sub(1, 4) == "fav:"
	local search = favoritesOnly and query:sub(5):match("^%s*(.-)%s*$") or query
	for _, entry in ipairs(source) do
		if
			(not favoritesOnly or favorites[entry.Path])
			and (entry.Name .. " " .. entry.Folder)
				:lower()
				:find(search, 1, true)
		then
			table.insert(matches, entry)
		end
	end
	local pages = math.max(1, math.ceil(#matches / 24))
	pageNumber = math.clamp(pageNumber, 1, pages)
	local visible = {}
	for index = (pageNumber - 1) * 24 + 1, math.min(#matches, pageNumber * 24) do
		local entry = matches[index]
		table.insert(visible, {
			Path = entry.Path,
			Name = (favorites[entry.Path] and "FAV / " or "") .. entry.Name,
			Folder = entry.Folder,
			Original = entry,
		})
	end
	view.Files(
		visible,
		selected and selected.Path,
		view.Page == "Queue",
		pageNumber,
		pages
	)
end
local function play()
	assert(
		player.Preview or (output.LastReleaseFailures or 0) == 0,
		"Key releases failed; retry F7 before playback"
	)
	assert(not operation, "Wait for the local file operation to complete")
	assert(
		not input:GetFocusedTextBox(),
		"Leave the text field and focus the game piano first"
	)
	assert(player.Score, "Select a MIDI file first")
	assert(
		player.Preview or player.Armed,
		"Arm piano input in Settings, or explicitly select Preview only"
	)
	assert(
		player.EventCount > 0,
		"No enabled notes; check tracks, percussion and velocity filter"
	)
	if player.State == "Playing" then
		return
	end
	if countdown then
		return
	end
	if startDelay > 0 then
		countdown = os.clock() + startDelay
		view.Message(
			"Starting in "
				.. startDelay
				.. "s / focus the game piano. F7 stops."
		)
	else
		player.Play()
		view.Message(
			player.Preview and "PREVIEW ONLY / no game input"
				or "Playing via "
					.. output.Backend
					.. " / F7 emergency stop"
		)
	end
	render()
end
local function operationStart(phase, callback, complete)
	generation += 1
	local token = generation
	if operation and operation ~= coroutine.running() then
		pcall(task.cancel, operation)
	end
	operation = nil
	stop()
	view.Loading(true, phase, token)
	operation = task.defer(function()
		-- Present the real phase before a synchronous executor filesystem call.
		task.wait()
		if not current(token) then
			return
		end
		local success, result = pcall(callback, token)
		if not current(token) then
			return
		end
		operation = nil
		view.Loading(false)
		if success then
			if complete then
				local applied, reason = pcall(complete, result)
				if not applied then
					view.Message(reason, true)
				end
			end
		else
			view.Message(result, true)
		end
		render()
	end)
end
local function refresh()
	operationStart("Reading local MIDI directory", function(token)
		local entries, info = files.Scan(api, root, recursive, function()
			task.wait()
			assert(current(token), "Scan cancelled")
		end)
		assert(current(token), "Scan cancelled")
		return { Entries = entries, Info = info }
	end, function(result)
		library = result.Entries
		if restoring then
			local byPath = {}
			for _, entry in ipairs(library) do
				byPath[entry.Path] = entry
			end
			for _, path in ipairs(saved.Favorites) do
				favorites[path] = true
			end
			for _, path in ipairs(saved.Queue) do
				if byPath[path] then
					table.insert(queue, byPath[path])
				end
			end
			restoring = false
			if saved.Selected and byPath[saved.Selected] then
				task.defer(function()
					if context.Alive then
						load(byPath[saved.Selected], false)
					end
				end)
			end
		end
		pageNumber = 1
		rows()
		view.Message(
			#library
				.. " MIDI files / "
				.. result.Info.Root
				.. (result.Info.Fallback and " / Android listing blocked; using workspace fallback" or "")
				.. (result.Info.Capped and " / 512-file limit" or "")
				.. " / select a song to load"
		)
	end)
end
load = function(entry, continueQueue)
	entry = entry.Original or entry
	operationStart("Reading " .. entry.Name, function(token)
		assert(type(api.Read) == "function", "Delta readfile is unavailable")
		local data = api.Read(entry.Path)
		assert(current(token), "File load cancelled")
		view.Loading(true, "Decoding MIDI tracks and tempo map", token)
		local score = parser.Parse(data, function()
			task.wait()
			assert(current(token), "MIDI parse cancelled")
		end)
		assert(current(token), "MIDI parse cancelled")
		return score
	end, function(score)
		player.Load(score)
		if saved.Selected == entry.Path then
			for _, index in ipairs(saved.Muted) do
				if score.Tracks[index] then
					player.Muted[index] = true
				end
			end
			player.LoopA = math.min(saved.LoopA, score.Duration)
			player.LoopB = saved.LoopB and math.min(saved.LoopB, score.Duration)
				or nil
			player.Loop = saved.Loop
				and player.LoopA < (player.LoopB or score.Duration)
			view.Settings.loop(player.Loop)
			player.Rebuild()
			saved.Selected = nil
		end
		selected = entry
		view.Score(score, entry.Name)
		view.Tracks(score.Tracks, player.Muted)
		rows()
		requestSave()
		view.Message(
			"Loaded "
				.. entry.Name
				.. " / "
				.. output.Backend
				.. ". Arm input, focus the piano, then Play. F8 play/pause; F7 emergency stop."
		)
		if continueQueue and advance and (player.Armed or player.Preview) then
			play()
		end
	end)
end
local function queueStep(direction, automatic)
	assert(#queue > 0, "Add a song with + Queue first")
	local index = 0
	for position, entry in ipairs(queue) do
		if selected and entry.Path == selected.Path then
			index = position
			break
		end
	end
	local nextIndex = index + direction
	if automatic and nextIndex > #queue then
		view.Message("Queue finished")
		return
	end
	if nextIndex < 1 then
		nextIndex = #queue
	elseif nextIndex > #queue then
		nextIndex = 1
	end
	load(queue[nextIndex], automatic)
end
local function number(value, minimum, maximum, integer)
	local parsed = tonumber(value)
	assert(
		parsed
			and parsed == parsed
			and parsed >= minimum
			and parsed <= maximum
			and (not integer or parsed % 1 == 0),
		"Enter "
			.. minimum
			.. " to "
			.. maximum
			.. (integer and " (whole number)" or "")
	)
	return parsed
end
local function rebuild()
	cancelCountdown()
	player.Rebuild()
	render()
end
local testSerial = 0
local function testNote(pitch)
	assert(
		not input:GetFocusedTextBox(),
		"Leave the text field before testing piano keys"
	)
	assert(
		player.Armed and not player.Preview,
		"Arm real piano input before testing keys"
	)
	assert(
		player.State ~= "Playing" and not countdown,
		"Pause playback before testing input"
	)
	testSerial += 1
	local id = "test/" .. testSerial
	local binding = output.Map(pitch)
	assert(binding, "Key is outside the selected mapping")
	output.On(id, pitch)
	task.delay(0.2, function()
		if context.Alive then
			local success, reason = pcall(output.Off, id)
			if not success then
				panic()
				view.Message(reason, true)
			end
			render()
		end
	end)
	view.Message(
		binding.NoteName
			.. " / "
			.. binding.Binding
			.. " requested via "
			.. output.Backend
			.. ". Listen to the game piano; API success is not confirmation."
	)
	render()
end
view.Actions = {
	placement = function() end,
	autoarm = function(value)
		autoArm = value
		view.Settings.autoarm(value)
	end,
	save = saveNow,
	center = function()
		if view.Center then
			view.Center()
		end
	end,
	reveal = render,
	backend = function(mode)
		pause()
		output.SelectBackend(mode)
		view.Message(
			"Selected "
				.. output.Backend
				.. ". Test white AND black keys; if silent, try another input backend."
		)
		render()
	end,
	profile61 = function()
		pause()
		assert(output.ReleaseAll(), "Retry STOP INPUT before changing keys")
		output.Mode88 = false
		player.Transpose = 0
		view.Settings.mode88(false)
		view.Keyboard(false)
		if view.Profile61 then
			view.Profile61()
		end
		view.Message(
			"Screenshot 61-key layout: 1..m, Shift for black keys. Turn the game's CAPS off; keep the piano open. Test keys before Play."
		)
		render()
	end,
	testnote = function(pitch)
		testNote(number(pitch, 36, 96, true))
	end,
	panic = panic,
	unload = function()
		context.Library:Unload()
	end,
	refresh = refresh,
	search = function(text)
		query = text:lower()
		pageNumber = 1
		rows()
	end,
	page = function(direction)
		pageNumber += direction
		rows()
	end,
	tab = function()
		pageNumber = 1
		rows()
		render()
	end,
	select = function(entry)
		load(entry, false)
	end,
	folder = function(path)
		root = files.Normalize(path)
		view.Message("Folder set. Choose Refresh to scan: " .. root)
	end,
	play = play,
	pause = function()
		pause()
		view.Message(
			output.LastReleaseFailures > 0
					and "Paused, but input release failed. Retry F7."
				or "Paused / held keys released",
			output.LastReleaseFailures > 0
		)
	end,
	stop = function()
		stop()
		view.Message(
			output.LastReleaseFailures > 0
					and "Stopped, but input release failed. Retry F7."
				or "Stopped / held keys released",
			output.LastReleaseFailures > 0
		)
	end,
	previous = function()
		queueStep(-1, false)
	end,
	next = function()
		queueStep(1, false)
	end,
	enqueue = function()
		assert(selected, "Select a local song first")
		assert(#queue < 128, "Queue is limited to 128 songs")
		for _, entry in ipairs(queue) do
			if entry.Path == selected.Path then
				view.Message("Song is already in your queue")
				return
			end
		end
		table.insert(queue, selected)
		rows()
		view.Message("Added to session queue: " .. selected.Name)
	end,
	clearqueue = function()
		table.clear(queue)
		rows()
		view.Message("Session queue cleared")
	end,
	favorite = function()
		assert(selected, "Select a song first")
		favorites[selected.Path] = not favorites[selected.Path]
		rows()
		view.Message(
			"Favorite updated. Search fav: to show favorites. Settings shows local save status."
		)
	end,
	seek = function(ratio)
		cancelCountdown()
		player.Seek((player.Score and player.Score.Duration or 0) * ratio)
		render()
	end,
	speed = function(value)
		cancelCountdown()
		player.SetSpeed(number(value, 0.25, 2))
		render()
	end,
	transpose = function(value)
		player.Transpose = number(value, -24, 24, true)
		rebuild()
	end,
	velocity = function(value)
		player.MinimumVelocity = number(value, 1, 127, true)
		rebuild()
	end,
	gate = function(value)
		player.Gate = number(value, 0.1, 1)
		rebuild()
	end,
	sustain = function(value)
		player.Sustain = value
		rebuild()
		view.Settings.sustain(value)
	end,
	drums = function(value)
		player.Drums = value
		rebuild()
		view.Settings.drums(value)
	end,
	track = function(index)
		player.Muted[index] = not player.Muted[index]
		rebuild()
		view.Tracks(player.Score.Tracks, player.Muted)
	end,
	arm = function(value)
		pause()
		if value then
			output.ReleaseAll()
			assert(
				output.LastReleaseFailures == 0,
				"Key releases failed; retry F7 before arming"
			)
			assert(
				output.Available(),
				"No permitted key input API. Explicit Preview only is still available."
			)
		end
		player.Armed = value
		if value then
			player.Preview = false
			view.Settings.preview(false)
		end
		view.Settings.arm(value)
		view.Message(
			value
					and "Armed / " .. output.Backend .. ". Test C4 before playing; game acceptance is unverified."
				or "Input disarmed"
		)
		render()
	end,
	preview = function(value)
		pause()
		player.Preview = value
		player.Armed = false
		view.Settings.arm(false)
		view.Settings.preview(value)
		render()
	end,
	mode88 = function(value)
		pause()
		output.Mode88 = value
		view.Keyboard(value)
		view.Settings.mode88(value)
		render()
	end,
	fold = function(value)
		pause()
		output.Fold = value
		view.Settings.fold(value)
		render()
	end,
	loop = function(value)
		if value then
			assert(player.Score, "Load a MIDI before looping")
			assert(
				player.LoopA < (player.LoopB or player.Score.Duration),
				"Loop A must be before loop B"
			)
		end
		player.Loop = value
		view.Settings.loop(value)
	end,
	loopA = function()
		assert(player.Score, "Load a MIDI first")
		assert(
			player.Position < (player.LoopB or player.Score.Duration),
			"A must be before B"
		)
		player.LoopA = player.Position
		view.Message(string.format("Loop A = %.2fs", player.LoopA))
	end,
	loopB = function()
		assert(player.Score, "Load a MIDI first")
		assert(player.Position > player.LoopA, "B must be after A")
		player.LoopB = player.Position
		view.Message(string.format("Loop B = %.2fs", player.LoopB))
	end,
	advance = function(value)
		advance = value
		view.Settings.advance(value)
	end,
	recursive = function(value)
		recursive = value
		view.Settings.recursive(value)
	end,
	motion = function(value)
		view.ReducedMotion = value
		view.Settings.motion(value)
	end,
	delay = function(value)
		startDelay = number(value, 0, 10)
		cancelCountdown()
	end,
	test = function()
		testNote(60)
	end,
}
-- Save only successful user actions, coalesced off the playback clock.
for name, callback in pairs(view.Actions) do
	if name ~= "save" and name ~= "unload" and name ~= "search" then
		view.Actions[name] = function(...)
			callback(...)
			requestSave()
		end
	end
end
context.Connect(input.InputBegan, function(event, processed)
	if event.KeyCode == Enum.KeyCode.F7 then
		panic()
		return
	end
	if processed or input:GetFocusedTextBox() then
		return
	end
	if event.KeyCode == Enum.KeyCode.F8 then
		if player.State == "Playing" or countdown then
			pause()
		else
			view.Dispatch("play")
		end
	end
end)
context.Connect(input.TextBoxFocused, function()
	if player.State == "Playing" or countdown then
		pause()
		view.Message(
			"Paused for text entry / press Play after focusing the piano"
		)
	end
end)
context.Connect(input.WindowFocusReleased, function()
	if player.State == "Playing" or countdown then
		pause()
		view.Message("Paused because the app lost focus. Press Play to resume.")
	end
end)
context.Connect(game:GetService("RunService").Heartbeat, function()
	if countdown then
		if os.clock() >= countdown then
			countdown = nil
			local success, reason = pcall(function()
				assert(not input:GetFocusedTextBox(), "Text field is focused")
				player.Play()
			end)
			if not success then
				panic()
				view.Message(reason, true)
			end
		elseif os.clock() >= renderAt then
			renderAt = os.clock() + 0.1
			view.Message(
				string.format(
					"Starting in %.1fs / focus the piano. F7 stops.",
					countdown - os.clock()
				)
			)
		end
	end
	if player.State ~= "Playing" then
		return
	end
	local success, reason = pcall(player.Tick)
	if not success then
		panic()
		view.Message(reason, true)
		return
	end
	if os.clock() >= renderAt or player.State == "Finished" then
		renderAt = os.clock() + 0.05
		render()
	end
	if player.State == "Finished" then
		view.Message(
			"Playback finished / skipped events: "
				.. player.Dropped
				.. (
					player.Preview and " / PREVIEW ONLY"
					or " / keyboard requests are not proof of game acceptance"
				)
		)
		if advance and #queue > 0 then
			queueStep(1, true)
		end
	end
end)
context.RegisterCleanup(function()
	saveSerial += 1
	if preferencesReady then
		saveNow()
	end
	generation += 1
	cancelCountdown()
	if operation and operation ~= coroutine.running() then
		pcall(task.cancel, operation)
	end
	player.Destroy()
	output.ReleaseAll()
	if output.LastReleaseFailures > 0 then
		warn(
			"[NULL Auto Player] Input API refused key releases; reset the piano manually."
		)
	end
end)
root, recursive, advance, startDelay =
	saved.Folder, saved.Recursive, saved.Advance, saved.Delay
player.Speed, player.Transpose, player.MinimumVelocity, player.Gate =
	saved.Speed, saved.Transpose, saved.Velocity, saved.Gate
player.Sustain, player.Drums = saved.Sustain, saved.Drums
output.Mode88, output.Fold = saved.Mode88, saved.Fold
pcall(output.SelectBackend, saved.Backend)
player.Armed = autoArm and output.Available()
view.ReducedMotion = saved.Motion or context.ReducedMotion
for name, value in pairs({
	arm = player.Armed,
	autoarm = autoArm,
	mode88 = output.Mode88,
	fold = output.Fold,
	sustain = player.Sustain,
	drums = player.Drums,
	recursive = recursive,
	advance = advance,
	motion = view.ReducedMotion,
}) do
	if view.Settings[name] then
		view.Settings[name](value)
	end
end
view.Keyboard(output.Mode88)
if view.Preferences then
	view.Preferences(saved)
end
if view.Persistence then
	view.Persistence(store.Status)
end
view.SetPage(saved.Page)
preferencesReady = true
rows()
render()
refresh()
return { Transport = player, Output = output, View = view, Nullx11Ready = true }
