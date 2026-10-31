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
local player = context.MakeMidiTransport(output, os.clock)
local view = context.MakeAutoPlayerView(context)
local library, queue, favorites = {}, {}, {}
local selected, query, pageNumber = nil, "", 1
local root, recursive, advance, startDelay = files.AndroidRoot, true, false, 2
local generation, operation, countdown, renderAt = 0, nil, nil, 0
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
local function load(entry, continueQueue)
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
		selected = entry
		view.Score(score, entry.Name)
		view.Tracks(score.Tracks, player.Muted)
		rows()
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
view.Actions = {
	reveal = render,
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
			"Session favorite updated. Search fav: to show favorites. Favorites are not written to disk."
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
		assert(
			player.Armed and not player.Preview,
			"Arm real piano input before testing C4"
		)
		assert(
			player.State ~= "Playing" and not countdown,
			"Pause playback before testing input"
		)
		output.On("test", 60)
		task.delay(0.2, function()
			if context.Alive then
				local success, reason = pcall(output.Off, "test")
				if not success then
					panic()
					view.Message(reason, true)
				end
			end
		end)
		view.Message(
			"C4 key request dispatched. Confirm the game piano actually played it."
		)
	end,
}
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
rows()
render()
refresh()
return { Transport = player, Output = output, View = view, Nullx11Ready = true }
