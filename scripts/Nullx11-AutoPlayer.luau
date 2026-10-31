-- GENERATED from src/ by tools/build.mjs. Edit the sources, then run npm run build.
-- Auto Player / NULL. Local MIDI data only; see docs/MIDI-REVIEW.md.
local makeSession = (function()
	-- One selected game session. Bundles include this module, not the loader.
	return function(key, library)
		local context = {
			Alive = true,
			Library = library,
			Connections = {},
			Sent = 0,
			NextSend = 0,
		}
		local env = type(getgenv) == "function" and getgenv() or _G
		env.Nullx11GameSessions = env.Nullx11GameSessions or {}
		local previous = env.Nullx11GameSessions[key]
		if previous and type(previous.Unload) == "function" then
			pcall(previous.Unload)
		end
		local session = { Library = library }
		function session.Unload()
			if not context.Alive then
				return
			end
			context.Alive = false
			for _, connection in ipairs(context.Connections) do
				pcall(connection.Disconnect, connection)
			end
			table.clear(context.Connections)
			library:Unload()
			if env.Nullx11GameSessions[key] == session then
				env.Nullx11GameSessions[key] = nil
			end
		end
		function context.Connect(signal, callback)
			local connection = signal:Connect(function(...)
				if context.Alive then
					callback(...)
				end
			end)
			table.insert(context.Connections, connection)
			return connection
		end
		-- The forge source used enormous worker bursts. Serialize its explicit remote
		-- requests to at most eight a second; waiting work is cancelled on unload.
		-- A budget is not a claim that the server accepts any action.
		function context.Send(remote, method, ...)
			local function allowed()
				return context.Alive
					or context.CleanupThread
						== (coroutine.running() or context)
			end
			while allowed() and os.clock() < context.NextSend do
				task.wait(math.min(0.125, context.NextSend - os.clock()))
			end
			assert(allowed(), "Nullx11 game session stopped")
			context.NextSend = os.clock() + 0.125
			context.Sent += 1
			return remote[method](remote, ...)
		end
		-- Revalidate feature/generation after pacing waits, before sending anything.
		function context.SendWhen(predicate, remote, method, ...)
			while
				context.Alive
				and predicate()
				and os.clock() < context.NextSend
			do
				task.wait(math.min(0.125, context.NextSend - os.clock()))
			end
			if not context.Alive or not predicate() then
				return nil, "cancelled"
			end
			context.NextSend = os.clock() + 0.125
			context.Sent += 1
			return remote[method](remote, ...)
		end
		function context.RegisterCleanup(callback)
			library:OnUnload(function()
				context.CleanupThread = coroutine.running() or context
				local ok, reason = pcall(callback)
				context.CleanupThread = nil
				if not ok then
					warn("[Nullx11 cleanup] " .. tostring(reason))
				end
			end)
		end
		library:OnUnload(function()
			context.Alive = false
			for _, connection in ipairs(context.Connections) do
				pcall(connection.Disconnect, connection)
			end
			table.clear(context.Connections)
			if env.Nullx11GameSessions[key] == session then
				env.Nullx11GameSessions[key] = nil
			end
		end)
		env.Nullx11GameSessions[key] = session
		return context
	end
end)()
local midiParser = (function()
	-- NULL Auto Player: bounded SMF decoder. Source-informed replacement for the
	-- supplied RoMidi parser; no external preset execution. See MIDI-REVIEW.md.
	local parser = {
		MaxBytes = 4 * 1024 * 1024,
		MaxEvents = 100000,
		MaxTracks = 64,
		MaxNotes = 50000,
	}
	function parser.Parse(data, checkpoint)
		assert(
			type(data) == "string" and #data >= 14 and #data <= parser.MaxBytes,
			"MIDI must contain 14 bytes to 4 MiB"
		)
		local position, boundary = 1, #data + 1
		local function byte()
			assert(position < boundary, "Truncated MIDI event")
			local value = data:byte(position)
			position += 1
			return value
		end
		local function integer(size)
			local value = 0
			for _ = 1, size do
				value = value * 256 + byte()
			end
			return value
		end
		local function text(size)
			assert(
				size >= 0 and position + size <= boundary,
				"MIDI chunk exceeds file or track"
			)
			local value = data:sub(position, position + size - 1)
			position += size
			return value
		end
		local function vlq()
			local value = 0
			for _ = 1, 4 do
				local nextByte = byte()
				value = value * 128 + nextByte % 128
				if nextByte < 128 then
					return value
				end
			end
			error("Invalid MIDI variable-length number")
		end
		assert(text(4) == "MThd", "Not a Standard MIDI File (MThd missing)")
		local headerSize = integer(4)
		assert(
			headerSize >= 6 and headerSize <= 1024,
			"Invalid MIDI header length"
		)
		local format, trackCount, division = integer(2), integer(2), integer(2)
		assert(
			format == 0 or format == 1,
			"Only simultaneous SMF formats 0 and 1 are supported; format 2 is independent sequences"
		)
		assert(
			trackCount >= 1
				and trackCount <= parser.MaxTracks
				and (format ~= 0 or trackCount == 1),
			"Invalid or excessive MIDI track count"
		)
		assert(
			division > 0 and division < 32768,
			"Zero/SMPTE time division is unsupported; export as PPQ MIDI"
		)
		text(headerSize - 6)
		local events, tracks, order, lastTick, operations = {}, {}, 0, 0, 0
		local function check()
			operations += 1
			assert(
				operations <= parser.MaxEvents,
				"MIDI exceeds 100,000 events"
			)
			if checkpoint and operations % 1024 == 0 then
				checkpoint(operations)
			end
		end
		for track = 1, trackCount do
			boundary = #data + 1
			assert(text(4) == "MTrk", "Expected MIDI track chunk")
			local length = integer(4)
			assert(position + length <= boundary, "Truncated MIDI track")
			boundary = position + length
			local tick, running = 0, nil
			tracks[track] =
				{ Name = "Track " .. track, Notes = 0, Index = track }
			while position < boundary do
				check()
				tick += vlq()
				lastTick = math.max(lastTick, tick)
				assert(tick <= 2147483647, "MIDI tick count is excessive")
				local status = data:byte(position)
				assert(status, "Missing MIDI status")
				if status >= 128 then
					byte()
				else
					status = running
					assert(status, "Running status without a channel event")
				end
				order += 1
				if status == 255 then
					local kind, size = byte(), vlq()
					local payload = text(size)
					if kind == 81 then
						assert(size == 3, "Invalid tempo event")
						local a, b, c = payload:byte(1, 3)
						local tempo = a * 65536 + b * 256 + c
						assert(tempo > 0, "MIDI tempo cannot be zero")
						table.insert(events, {
							Tick = tick,
							Kind = "tempo",
							Tempo = tempo,
							Order = order,
						})
					elseif kind == 3 then
						local clean = payload:gsub("[%z\1-\31]", ""):sub(1, 64)
						tracks[track].Name = utf8.len(clean) and clean
							or "Track " .. track
					elseif kind == 47 then
						assert(size == 0, "Invalid end-of-track event")
						position = boundary
					end
				elseif status == 240 or status == 247 then
					running = nil
					text(vlq())
				else
					assert(
						status >= 128 and status <= 239,
						"Unsupported MIDI system status"
					)
					running = status
					local kind, channel = math.floor(status / 16), status % 16
					local first = byte()
					assert(first < 128, "Invalid MIDI data byte")
					local second = 0
					if kind ~= 12 and kind ~= 13 then
						second = byte()
						assert(second < 128, "Invalid MIDI data byte")
					end
					if
						kind == 8
						or kind == 9
						or (
							kind == 11
							and (first == 64 or first == 120 or first == 123)
						)
					then
						table.insert(events, {
							Tick = tick,
							Kind = kind == 11 and "control"
								or (kind == 8 or second == 0) and "off"
								or "on",
							Pitch = first,
							Velocity = second,
							Channel = channel,
							Track = track,
							Order = order,
						})
					end
				end
			end
		end
		table.sort(events, function(a, b)
			if a.Tick ~= b.Tick then
				return a.Tick < b.Tick
			end
			if (a.Kind == "tempo") ~= (b.Kind == "tempo") then
				return a.Kind == "tempo"
			end
			return a.Order < b.Order
		end)
		local score = {
			Notes = {},
			Tracks = tracks,
			Tempos = { { Time = 0, BPM = 120, Tick = 0 } },
			Division = division,
			Format = format,
		}
		local active, deferred, pedals, holding = {}, {}, {}, {}
		local seconds, previousTick, tempo = 0, 0, 500000
		local function finish(note, ending)
			note.End = math.max(note.Start + 0.005, ending)
			note.RawEnd = math.max(note.Start + 0.005, note.RawEnd or ending)
		end
		local function flush(channel, time)
			for _, note in ipairs(deferred[channel] or {}) do
				finish(note, time)
			end
			deferred[channel] = nil
		end
		for index, event in ipairs(events) do
			seconds += (event.Tick - previousTick) / division * tempo / 1000000
			previousTick = event.Tick
			assert(seconds <= 14400, "MIDI exceeds four-hour playback limit")
			if event.Kind == "tempo" then
				tempo = event.Tempo
				table.insert(score.Tempos, {
					Time = seconds,
					BPM = 60000000 / tempo,
					Tick = event.Tick,
				})
			elseif event.Kind == "control" then
				if event.Pitch == 64 then
					pedals[event.Channel] = event.Velocity >= 64
					if not pedals[event.Channel] then
						flush(event.Channel, seconds)
					end
				else
					flush(event.Channel, seconds)
					for _, note in pairs(holding[event.Channel] or {}) do
						finish(note, seconds)
					end
					holding[event.Channel] = {}
				end
			else
				local key = event.Track
					.. ":"
					.. event.Channel
					.. ":"
					.. event.Pitch
				active[key] = active[key] or { Notes = {}, Head = 1 }
				local queue = active[key]
				if event.Kind == "on" then
					assert(
						#score.Notes < parser.MaxNotes,
						"MIDI exceeds 50,000 notes"
					)
					local note = {
						Start = seconds,
						Pitch = event.Pitch,
						Velocity = event.Velocity,
						Track = event.Track,
						Channel = event.Channel,
						Id = #score.Notes + 1,
					}
					table.insert(score.Notes, note)
					table.insert(queue.Notes, note)
					holding[event.Channel] = holding[event.Channel] or {}
					holding[event.Channel][note.Id] = note
					tracks[event.Track].Notes += 1
				else
					local note
					while queue.Head <= #queue.Notes do
						local candidate = queue.Notes[queue.Head]
						queue.Notes[queue.Head] = false
						queue.Head += 1
						if not candidate.End then
							note = candidate
							break
						end
					end
					if note then
						holding[event.Channel][note.Id] = nil
						note.RawEnd = seconds
						if pedals[event.Channel] then
							deferred[event.Channel] = deferred[event.Channel]
								or {}
							table.insert(deferred[event.Channel], note)
						else
							finish(note, seconds)
						end
					end
				end
			end
			if checkpoint and index % 1024 == 0 then
				checkpoint(operations + index)
			end
		end
		seconds += (lastTick - previousTick) / division * tempo / 1000000
		assert(seconds <= 14400, "MIDI exceeds four-hour playback limit")
		local duration = seconds
		for _, note in ipairs(score.Notes) do
			if not note.End then
				finish(note, math.max(seconds, note.Start + 0.1))
			end
			duration = math.max(duration, note.End)
		end
		assert(#score.Notes > 0, "MIDI contains no piano note events")
		assert(duration <= 14400, "MIDI exceeds four-hour playback limit")
		score.Duration = duration
		table.sort(score.Notes, function(a, b)
			return a.Start == b.Start and a.Id < b.Id or a.Start < b.Start
		end)
		return score
	end
	return parser
end)()
local midiFiles = (function()
	-- Local data only. Never loads Lua presets, fetches a catalog or scans outside
	-- the requested root. Absolute Android access remains executor-controlled.
	local files = {
		AndroidRoot = "/storage/emulated/0/Delta/Workspace/MIDI",
		RelativeRoot = "MIDI",
		MaxFiles = 512,
	}
	function files.Normalize(path)
		assert(
			type(path) == "string"
				and #path > 0
				and #path <= 1024
				and not path:find("[%z\1-\31]"),
			"Invalid folder/path"
		)
		assert(not path:match("^%a[%w+.-]*:"), "Use a local folder, not a URL")
		path = path:gsub("\\", "/"):gsub("/+", "/"):gsub("/$", "")
		assert(not path:find("://", 1, true), "Use a local folder, not a URL")
		for part in path:gmatch("[^/]+") do
			assert(
				part ~= ".." and part ~= ".",
				"Parent/current-directory traversal is not allowed"
			)
		end
		assert(#path > 0, "Choose a MIDI folder, not the filesystem root")
		return path
	end
	function files.IsMidi(path)
		local lower = path:lower()
		return lower:match("%.mid$") ~= nil
			or lower:match("%.midi$") ~= nil
			or lower:match("%.smf$") ~= nil
	end
	function files.Scan(api, requested, recursive, checkpoint)
		assert(
			type(api.List) == "function" and type(api.Read) == "function",
			"Delta listfiles/readfile APIs are unavailable"
		)
		local root = files.Normalize(requested)
		local ok, entries = pcall(api.List, root)
		local fallback = false
		if
			(not ok or type(entries) ~= "table")
			and root == files.AndroidRoot
		then
			root = files.RelativeRoot
			fallback = true
			ok, entries = pcall(api.List, root)
		end
		assert(
			ok and type(entries) == "table",
			"Cannot list MIDI folder: "
				.. root
				.. ". Check Delta file permissions or use workspace-relative MIDI."
		)
		local result, seen, visited, skipped = {}, {}, 0, 0
		local function childPath(directory, entry)
			local valid, candidate = pcall(files.Normalize, entry)
			if not valid then
				return nil
			end
			if not candidate:find("/", 1, true) then
				candidate = directory .. "/" .. candidate
			end
			if candidate:sub(1, #directory + 1) == directory .. "/" then
				return candidate
			end
			-- Some executors return absolute Android paths for a relative query.
			if directory:sub(1, 1) ~= "/" then
				local absolute = "/storage/emulated/0/Delta/Workspace/"
					.. directory
				if candidate:sub(1, #absolute + 1) == absolute .. "/" then
					return candidate
				end
			end
			return nil
		end
		local function walk(directory, listing, depth)
			visited += 1
			for index, entry in ipairs(listing) do
				if index > 2048 or #result >= files.MaxFiles then
					break
				end
				local path = childPath(directory, entry)
				if path and not seen[path] then
					seen[path] = true
					if files.IsMidi(path) then
						table.insert(result, {
							Path = path,
							Name = path:match("([^/]+)$"),
							Folder = directory,
						})
					elseif
						recursive
						and depth < 3
						and visited < 32
						and type(api.IsFolder) == "function"
					then
						local folderOk, folder = pcall(api.IsFolder, path)
						if folderOk and folder then
							local listOk, children = pcall(api.List, path)
							if listOk and type(children) == "table" then
								walk(path, children, depth + 1)
							end
						end
					end
				else
					skipped += 1
				end
				if checkpoint and index % 64 == 0 then
					checkpoint()
				end
			end
		end
		walk(root, entries, 0)
		table.sort(result, function(a, b)
			return a.Name:lower() == b.Name:lower() and a.Path < b.Path
				or a.Name:lower() < b.Name:lower()
		end)
		return result,
			{
				Root = root,
				Fallback = fallback,
				Skipped = skipped,
				Capped = #result >= files.MaxFiles,
			}
	end
	return files
end)()
local makeMidiOutput = (function()
	-- Virtual-piano mapping from the supplied RoMidi source, isolated from its
	-- HTTP/preset/decal/announcement systems. NULL edition; see MIDI-REVIEW.md.
	return function(environment, vim, keyCodes, target)
		local output = {
			Mode88 = false,
			Fold = true,
			Held = {},
			References = {},
			Backend = "Unavailable",
		}
		local scale = {
			"1",
			"!",
			"2",
			"@",
			"3",
			"4",
			"$",
			"5",
			"%",
			"6",
			"^",
			"7",
			"8",
			"*",
			"9",
			"(",
			"0",
			"q",
			"Q",
			"w",
			"W",
			"e",
			"E",
			"r",
			"t",
			"T",
			"y",
			"Y",
			"u",
			"i",
			"I",
			"o",
			"O",
			"p",
			"P",
			"a",
			"s",
			"S",
			"d",
			"D",
			"f",
			"g",
			"G",
			"h",
			"H",
			"j",
			"J",
			"k",
			"l",
			"L",
			"z",
			"Z",
			"x",
			"c",
			"C",
			"v",
			"V",
			"b",
			"B",
			"n",
			"m",
		}
		local digits = {
			["0"] = "Zero",
			["1"] = "One",
			["2"] = "Two",
			["3"] = "Three",
			["4"] = "Four",
			["5"] = "Five",
			["6"] = "Six",
			["7"] = "Seven",
			["8"] = "Eight",
			["9"] = "Nine",
		}
		local symbols = {
			["!"] = "1",
			["@"] = "2",
			["$"] = "4",
			["%"] = "5",
			["^"] = "6",
			["*"] = "8",
			["("] = "9",
		}
		local extensions = {}
		for index, character in ipairs({
			"1",
			"2",
			"3",
			"4",
			"5",
			"6",
			"7",
			"8",
			"9",
			"0",
			"q",
			"w",
			"e",
			"r",
			"t",
		}) do
			extensions[20 + index] = character
		end
		for index, character in ipairs({
			"y",
			"u",
			"i",
			"o",
			"p",
			"a",
			"s",
			"d",
			"f",
			"g",
			"h",
			"j",
		}) do
			extensions[96 + index] = character
		end
		local send
		if
			type(environment.keypress) == "function"
			and type(environment.keyrelease) == "function"
		then
			output.Backend = "Executor keypress/keyrelease"
			send = function(down, key)
				if down then
					environment.keypress(key.Value)
				else
					environment.keyrelease(key.Value)
				end
			end
		elseif vim and type(vim.SendKeyEvent) == "function" then
			output.Backend = "VirtualInputManager (unverified permission)"
			send = function(down, key)
				vim:SendKeyEvent(down, key, false, target)
			end
		end
		function output.Available()
			return send ~= nil
		end
		function output.Map(pitch)
			local low, high =
				output.Mode88 and 21 or 36, output.Mode88 and 108 or 96
			if output.Fold then
				while pitch < low do
					pitch += 12
				end
				while pitch > high do
					pitch -= 12
				end
			end
			if pitch < low or pitch > high then
				return nil
			end
			local extended = output.Mode88 and extensions[pitch]
			local character = extended or scale[pitch - 36 + 1]
			if not character then
				return nil
			end
			local base = symbols[character] or character:lower()
			local key = keyCodes[digits[base] or base:upper()]
			local modifier = extended and keyCodes.LeftControl
				or (symbols[character] or character ~= character:lower()) and keyCodes.LeftShift
				or nil
			return {
				Key = key,
				Modifier = modifier,
				Pitch = pitch,
				Label = extended and "Ctrl+" .. character or character,
			}
		end
		function output.ReleaseAll()
			local failures = 0
			local function release(key)
				if not send then
					return true
				end
				for _ = 1, 3 do
					if pcall(send, false, key) then
						return true
					end
				end
				failures += 1
				return false
			end
			for key in pairs(output.References) do
				if release(key) then
					output.References[key] = nil
				end
			end
			for key in pairs(output.Modifiers or {}) do
				if release(key) then
					output.Modifiers[key] = nil
				end
			end
			for id, token in pairs(output.Held) do
				if not output.References[token.Key] then
					output.Held[id] = nil
				end
			end
			output.LastReleaseFailures = failures
			return failures == 0
		end
		function output.Off(id)
			local token = output.Held[id]
			if not token then
				return
			end
			local remaining = (output.References[token.Key] or 1) - 1
			if remaining <= 0 then
				-- Keep ownership until the release succeeds so panic can retry it.
				send(false, token.Key)
				output.References[token.Key] = nil
			else
				output.References[token.Key] = remaining
			end
			output.Held[id] = nil
		end
		function output.On(id, pitch)
			assert(
				send,
				"No usable piano input backend. Use explicit Preview only or a supported executor."
			)
			local token = output.Map(pitch)
			if not token then
				return false
			end
			output.Off(id)
			output.Modifiers = output.Modifiers or {}
			local ok, reason = pcall(function()
				if token.Modifier then
					output.Modifiers[token.Modifier] = true
					send(true, token.Modifier)
				end
				if output.References[token.Key] then
					send(false, token.Key)
				end
				-- Record before dispatch so a throwing/partially delivered down can be
				-- released by the emergency path, even if the backend never returns true.
				output.References[token.Key] = (
					output.References[token.Key] or 0
				) + 1
				output.Held[id] = token
				send(true, token.Key)
				if token.Modifier then
					send(false, token.Modifier)
					output.Modifiers[token.Modifier] = nil
				end
			end)
			if not ok then
				output.ReleaseAll()
				error("Piano input rejected: " .. tostring(reason))
			end
			return true
		end
		return output
	end
end)()
local makeMidiTransport = (function()
	-- Deterministic clock-driven transport. No Roblox dependency or hidden worker.
	return function(output, clock)
		local player = {
			State = "Empty",
			Position = 0,
			Speed = 1,
			Transpose = 0,
			Sustain = true,
			MinimumVelocity = 1,
			Drums = false,
			Muted = {},
			Armed = false,
			Preview = false,
			Loop = false,
			LoopA = 0,
			LoopB = nil,
			Gate = 1,
			Dropped = 0,
			Active = {},
			Cursor = 1,
		}
		local events = {}
		local function release()
			output.ReleaseAll()
			table.clear(player.Active)
		end
		function player.Pause()
			if player.State == "Playing" then
				player.Position = math.min(
					player.Score.Duration,
					player.BasePosition
						+ (clock() - player.BaseClock) * player.Speed
				)
			end
			release()
			player.State = player.Score and "Paused" or "Empty"
		end
		function player.Stop()
			release()
			player.Position = 0
			player.Cursor = 1
			player.State = player.Score and "Ready" or "Empty"
		end
		local function cursorAt(position)
			local low, high = 1, #events + 1
			while low < high do
				local middle = math.floor((low + high) / 2)
				if events[middle].Time < position then
					low = middle + 1
				else
					high = middle
				end
			end
			return low
		end
		function player.Rebuild()
			player.Pause()
			events = {}
			if not player.Score then
				return
			end
			for _, note in ipairs(player.Score.Notes) do
				if
					not player.Muted[note.Track]
					and (player.Drums or note.Channel ~= 9)
					and note.Velocity >= player.MinimumVelocity
				then
					local ending = player.Sustain and note.End or note.RawEnd
					table.insert(
						events,
						{ Time = note.Start, Down = true, Note = note }
					)
					table.insert(events, {
						Time = note.Start + (ending - note.Start) * player.Gate,
						Down = false,
						Note = note,
					})
				end
			end
			table.sort(events, function(a, b)
				if a.Time ~= b.Time then
					return a.Time < b.Time
				end
				if a.Down ~= b.Down then
					return not a.Down
				end
				return a.Note.Id < b.Note.Id
			end)
			player.EventCount = #events
			player.Cursor = cursorAt(player.Position)
		end
		function player.Load(score)
			player.Stop()
			player.Score = score
			player.Muted = {}
			player.LoopA = 0
			player.LoopB = nil
			player.Rebuild()
			player.State = "Ready"
			player.Dropped = 0
		end
		function player.Seek(position)
			assert(player.Score, "Select and load a MIDI first")
			local playing = player.State == "Playing"
			player.Pause()
			player.Position = math.clamp(position, 0, player.Score.Duration)
			player.Cursor = cursorAt(player.Position)
			if playing then
				player.Play()
			end
		end
		function player.SetSpeed(speed)
			assert(
				speed >= 0.25 and speed <= 2 and speed == speed,
				"Speed must be 0.25x to 2x"
			)
			local playing = player.State == "Playing"
			player.Pause()
			player.Speed = speed
			if playing then
				player.Play()
			end
		end
		function player.Play()
			assert(
				player.Preview or (output.LastReleaseFailures or 0) == 0,
				"Pending key releases failed; retry emergency stop before playback"
			)
			assert(
				player.Score and #events > 0,
				"No enabled piano notes; load a MIDI or unmute tracks"
			)
			assert(
				player.Preview or player.Armed,
				"Arm piano input first, or explicitly enable Preview only"
			)
			if player.Position >= player.Score.Duration then
				player.Position = 0
			end
			player.Cursor = cursorAt(player.Position)
			player.BasePosition = player.Position
			player.BaseClock = clock()
			player.LastClock = clock()
			player.State = "Playing"
		end
		function player.Tick()
			if player.State ~= "Playing" then
				return
			end
			if not player.Armed and not player.Preview then
				player.Pause()
				return
			end
			local now = clock()
			local destination = player.BasePosition
				+ (now - player.BaseClock) * player.Speed
			if now - player.LastClock > 0.35 then
				release()
				local nextCursor = cursorAt(destination)
				player.Dropped += math.max(0, nextCursor - player.Cursor)
				player.Cursor = nextCursor
			end
			player.LastClock = now
			local boundary = player.Loop
					and (player.LoopB or player.Score.Duration)
				or player.Score.Duration
			destination = math.min(destination, boundary)
			local processed = 0
			while
				player.Cursor <= #events
				and events[player.Cursor].Time <= destination
			do
				local event = events[player.Cursor]
				player.Cursor += 1
				processed += 1
				if processed > 128 then
					release()
					local nextCursor = cursorAt(destination + 0.000001)
					player.Dropped += math.max(0, nextCursor - player.Cursor) + 1
					player.Cursor = nextCursor
					break
				end
				local id = event.Note.Id
				if event.Down then
					local count = 0
					for _ in pairs(player.Active) do
						count += 1
					end
					if count < 64 then
						local pitch = event.Note.Pitch + player.Transpose
						if player.Preview or output.On(id, pitch) then
							player.Active[id] = pitch
						else
							player.Dropped += 1
						end
					else
						player.Dropped += 1
					end
				else
					if not player.Preview then
						output.Off(id)
					end
					player.Active[id] = nil
				end
			end
			player.Position = destination
			if destination >= boundary then
				release()
				if player.Loop then
					assert(
						player.LoopA >= 0 and player.LoopA < boundary,
						"Loop A must be before loop B"
					)
					player.Position = player.LoopA
					player.BasePosition = player.Position
					player.BaseClock = now
					player.Cursor = cursorAt(player.Position)
				else
					player.State = "Finished"
				end
			end
		end
		function player.Destroy()
			player.Armed = false
			player.Stop()
			player.State = "Destroyed"
		end
		return player
	end
end)()
local makeAutoPlayerView = (function()
	-- Bespoke NULL MIDI control room. Native geometry, no image/font downloads.
	-- Static piano dock; finite opening/loading tweens; pooled waterfall and rows.
	return function(context)
		local tweenService = game:GetService("TweenService")
		local input = game:GetService("UserInputService")
		local view = {
			Alive = true,
			Visible = true,
			Actions = {},
			Rows = {},
			Bars = {},
			Keys = {},
			Page = "Library",
			ReducedMotion = context.ReducedMotion,
			Tweens = {},
		}
		local color = {
			Background = Color3.fromRGB(8, 12, 24),
			Panel = Color3.fromRGB(15, 22, 39),
			Card = Color3.fromRGB(23, 33, 53),
			Border = Color3.fromRGB(44, 60, 86),
			Text = Color3.fromRGB(230, 242, 255),
			Muted = Color3.fromRGB(143, 164, 191),
			Cyan = Color3.fromRGB(86, 226, 234),
			Violet = Color3.fromRGB(171, 136, 255),
			Red = Color3.fromRGB(255, 118, 139),
		}
		local gui = Instance.new("ScreenGui")
		gui.Name = "Nullx11AutoPlayer"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = false
		gui.DisplayOrder = 350
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		local ok, host = pcall(function()
			if type(gethui) == "function" then
				return gethui()
			end
			return game:GetService("CoreGui")
		end)
		if not ok or not host then
			host = game:GetService("Players").LocalPlayer
				:WaitForChild("PlayerGui", 5)
		end
		assert(host, "No permitted GUI host")
		gui.Parent = host
		view.Gui = gui
		local function create(class, parent, props)
			local object = Instance.new(class)
			for key, value in pairs(props or {}) do
				object[key] = value
			end
			object.Parent = parent
			return object
		end
		local function corner(object, radius)
			create(
				"UICorner",
				object,
				{ CornerRadius = UDim.new(0, radius or 12) }
			)
		end
		local function stroke(object, accent)
			create("UIStroke", object, {
				Color = accent or color.Border,
				Thickness = 1,
				Transparency = 0.2,
			})
		end
		local function frame(parent, name, shade)
			local object = create("Frame", parent, {
				Name = name,
				BackgroundColor3 = shade or color.Card,
				BorderSizePixel = 0,
			})
			corner(object)
			return object
		end
		local function label(parent, name, text, size, shade)
			return create("TextLabel", parent, {
				Name = name,
				BackgroundTransparency = 1,
				Text = text,
				TextSize = size or 14,
				TextColor3 = shade or color.Text,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})
		end
		local function animate(object, duration, props)
			if view.ReducedMotion then
				for key, value in pairs(props) do
					object[key] = value
				end
				return
			end
			local previous = view.Tweens[object]
			if previous then
				previous:Cancel()
			end
			local tween = tweenService:Create(
				object,
				TweenInfo.new(
					duration,
					Enum.EasingStyle.Quart,
					Enum.EasingDirection.Out
				),
				props
			)
			view.Tweens[object] = tween
			tween:Play()
		end
		function view.Dispatch(name, ...)
			if view.Alive and view.Actions[name] then
				local success, reason = pcall(view.Actions[name], ...)
				if not success then
					view.Message(reason, true)
				end
			end
		end
		local function button(parent, name, text, action, shade)
			local object = create("TextButton", parent, {
				Name = name,
				Text = text,
				TextSize = 13,
				Font = Enum.Font.GothamBold,
				TextColor3 = shade == color.Cyan and color.Background
					or color.Text,
				BackgroundColor3 = shade or color.Card,
				BorderSizePixel = 0,
				AutoButtonColor = true,
			})
			corner(object, 10)
			stroke(object, shade)
			context.Connect(object.Activated, function()
				if type(action) == "function" then
					action()
				else
					view.Dispatch(action)
				end
			end)
			return object
		end
		local root = create("Frame", gui, {
			Name = "SafeArea",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})
		local panel = create("CanvasGroup", root, {
			Name = "AutoPlayerPanel",
			BackgroundColor3 = color.Background,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			GroupTransparency = 1,
		})
		corner(panel, 20)
		stroke(panel)
		create("UIGradient", panel, {
			Rotation = 30,
			Color = ColorSequence.new(
				color.Background,
				Color3.fromRGB(19, 23, 48)
			),
		})
		local openingScale = create("UIScale", panel, { Scale = 0.94 })
		view.Panel = panel
		local header = frame(panel, "Header", color.Panel)
		local function pianoMark(parent, size)
			local icon = frame(parent, "StaticPianoMark", color.Card)
			icon.Size = UDim2.fromOffset(size, size)
			for index = 1, 5 do
				local key = create("Frame", icon, {
					BorderSizePixel = 0,
					BackgroundColor3 = index == 3 and color.Cyan or color.Text,
					Size = UDim2.new(0.14, 0, 0.52, 0),
					Position = UDim2.new(0.08 + (index - 1) * 0.17, 0, 0.25, 0),
				})
				corner(key, 2)
			end
			for _, index in ipairs({ 1, 2, 4 }) do
				create("Frame", icon, {
					BorderSizePixel = 0,
					BackgroundColor3 = color.Background,
					Size = UDim2.new(0.09, 0, 0.3, 0),
					Position = UDim2.new(0.18 + (index - 1) * 0.17, 0, 0.25, 0),
					ZIndex = 2,
				})
			end
			return icon
		end
		local logo = pianoMark(header, 44)
		logo.Position = UDim2.fromOffset(14, 12)
		local brand = label(
			header,
			"Brand",
			"DEVELOPED BY NULL / MIDI STUDIO",
			10,
			color.Cyan
		)
		brand.Position = UDim2.fromOffset(70, 11)
		brand.Size = UDim2.new(1, -180, 0, 17)
		local title = label(header, "Title", "Auto Player", 25)
		title.Font = Enum.Font.GothamBold
		title.Position = UDim2.fromOffset(69, 28)
		title.Size = UDim2.new(1, -180, 0, 30)
		local minimize = button(header, "Minimize", "Hide", function()
			view.SetVisible(false)
		end)
		local close = button(header, "Unload", "Close", "unload")
		local nav = create(
			"Frame",
			panel,
			{ Name = "Navigation", BackgroundTransparency = 1 }
		)
		local pages, navButtons = {}, {}
		local main = create(
			"Frame",
			panel,
			{ Name = "Content", BackgroundTransparency = 1 }
		)
		local rail = frame(main, "SongRail", color.Panel)
		local listHeading =
			label(rail, "ListHeading", "YOUR MIDI LIBRARY", 11, color.Muted)
		listHeading.Position = UDim2.fromOffset(12, 8)
		listHeading.Size = UDim2.new(1, -24, 0, 24)
		local search = create("TextBox", rail, {
			Name = "SongSearch",
			Position = UDim2.fromOffset(10, 38),
			Size = UDim2.new(1, -20, 0, 36),
			Text = "",
			PlaceholderText = "Search songs or folders",
			ClearTextOnFocus = false,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = color.Text,
			PlaceholderColor3 = color.Muted,
			BackgroundColor3 = color.Card,
			BorderSizePixel = 0,
		})
		corner(search, 9)
		context.Connect(search:GetPropertyChangedSignal("Text"), function()
			view.Dispatch("search", search.Text)
		end)
		local list = create("ScrollingFrame", rail, {
			Name = "Songs",
			Position = UDim2.fromOffset(8, 82),
			Size = UDim2.new(1, -16, 1, -126),
			CanvasSize = UDim2.new(),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = color.Cyan,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})
		local empty = label(
			list,
			"EmptyLibrary",
			"Choose Refresh to scan your MIDI folder. No demo songs are inserted.",
			13,
			color.Muted
		)
		empty.Size = UDim2.new(1, -8, 0, 80)
		empty.TextWrapped = true
		empty.TextYAlignment = Enum.TextYAlignment.Top
		local previousPage = button(rail, "PreviousPage", "<", function()
			view.Dispatch("page", -1)
		end)
		local nextPage = button(rail, "NextPage", ">", function()
			view.Dispatch("page", 1)
		end)
		local refresh = button(rail, "RefreshFiles", "Refresh", "refresh")
		local stage = frame(main, "PianoStage", color.Panel)
		local stageTag = label(
			stage,
			"StageTag",
			"LOCAL FILE / AWAITING SELECTION",
			10,
			color.Cyan
		)
		stageTag.Position = UDim2.fromOffset(16, 12)
		stageTag.Size = UDim2.new(1, -32, 0, 18)
		local song =
			label(stage, "SongTitle", "Make room for your next piece.", 22)
		song.Position = UDim2.fromOffset(16, 35)
		song.Size = UDim2.new(1, -32, 0, 31)
		song.Font = Enum.Font.GothamBold
		local meta = label(
			stage,
			"SongMetadata",
			"SMF 0 / 1  |  Tempo maps  |  Track control",
			12,
			color.Muted
		)
		meta.Position = UDim2.fromOffset(16, 71)
		meta.Size = UDim2.new(1, -32, 0, 21)
		local roll = frame(stage, "PooledWaterfall", color.Background)
		roll.Position = UDim2.fromOffset(14, 104)
		roll.ClipsDescendants = true
		for index = 0, 7 do
			create("Frame", roll, {
				BorderSizePixel = 0,
				BackgroundColor3 = color.Border,
				BackgroundTransparency = 0.65,
				Position = UDim2.new(index / 7, 0, 0, 0),
				Size = UDim2.new(0, 1, 1, 0),
			})
		end
		local hitLine = create("Frame", roll, {
			Name = "HitLine",
			BorderSizePixel = 0,
			BackgroundColor3 = color.Cyan,
			Position = UDim2.new(0, 0, 1, -2),
			Size = UDim2.new(1, 0, 0, 2),
		})
		for index = 1, 72 do
			local bar = frame(
				roll,
				"NoteBar" .. index,
				index % 2 == 0 and color.Cyan or color.Violet
			)
			corner(bar, 3)
			bar.Visible = false
			view.Bars[index] = bar
		end
		local keyboard = create("Frame", stage, {
			Name = "PianoKeyboard",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		})
		local modeLabel = label(
			stage,
			"MappingLabel",
			"61-KEY VIRTUAL PIANO / C2 - C7",
			10,
			color.Muted
		)
		local audition = button(stage, "TestC4", "Test C4", "test")
		view.Stage = stage
		local function scrollPage(name)
			local page = create("ScrollingFrame", main, {
				Name = name,
				BackgroundColor3 = color.Panel,
				BorderSizePixel = 0,
				Visible = false,
				CanvasSize = UDim2.new(),
				ScrollBarThickness = 4,
			})
			corner(page)
			pages[name] = page
			return page
		end
		local mixer, settings = scrollPage("Mixer"), scrollPage("Settings")
		local rowHeights = { Mixer = 12, Settings = 12 }
		local function settingRow(page, heading, detail)
			local y = rowHeights[page.Name]
			rowHeights[page.Name] += 86
			local row = frame(page, heading, color.Card)
			row.Position = UDim2.fromOffset(12, y)
			row.Size = UDim2.new(1, -24, 0, 76)
			local headingLabel = label(row, "Heading", heading, 13)
			headingLabel.Position = UDim2.fromOffset(12, 8)
			headingLabel.Size = UDim2.new(1, -132, 0, 22)
			local description = label(row, "Detail", detail, 10, color.Muted)
			description.Position = UDim2.fromOffset(12, 33)
			description.Size = UDim2.new(1, -132, 0, 34)
			description.TextWrapped = true
			page.CanvasSize = UDim2.fromOffset(0, rowHeights[page.Name] + 12)
			return row
		end
		view.Settings = {}
		function view.Toggle(page, heading, detail, initial, action)
			local row = settingRow(page, heading, detail)
			local value = initial
			local control = button(
				row,
				heading .. "Toggle",
				value and "ON" or "OFF",
				function()
					view.Dispatch(action, not value)
				end
			)
			control.Size = UDim2.fromOffset(88, 40)
			control.Position = UDim2.new(1, -100, 0.5, -20)
			local function set(nextValue)
				value = nextValue
				control.Text = value and "ON" or "OFF"
				control.TextColor3 = value and color.Cyan or color.Muted
			end
			set(initial)
			view.Settings[action] = set
			return set
		end
		function view.Value(page, heading, detail, initial, action)
			local row = settingRow(page, heading, detail)
			local box = create("TextBox", row, {
				Name = heading .. "Input",
				Position = UDim2.new(1, -100, 0.5, -20),
				Size = UDim2.fromOffset(88, 40),
				BackgroundColor3 = color.Background,
				Text = tostring(initial),
				ClearTextOnFocus = false,
				TextSize = 14,
				TextColor3 = color.Cyan,
				Font = Enum.Font.GothamMedium,
				BorderSizePixel = 0,
			})
			corner(box, 8)
			context.Connect(box.FocusLost, function()
				view.Dispatch(action, box.Text)
			end)
			return box
		end
		view.Toggle(
			mixer,
			"Honor sustain pedal",
			"CC64 pedal timing from the MIDI file.",
			true,
			"sustain"
		)
		view.Toggle(
			mixer,
			"Include channel 10",
			"Percussion is excluded by default.",
			false,
			"drums"
		)
		view.Value(
			mixer,
			"Minimum velocity",
			"Filter quiet notes: 1 through 127.",
			1,
			"velocity"
		)
		view.Value(
			mixer,
			"Gate length",
			"0.1 to 1.0 of MIDI note length.",
			1,
			"gate"
		)
		local trackStart = rowHeights.Mixer
		view.Toggle(
			settings,
			"Arm piano input",
			"Opt in before sending game key events.",
			false,
			"arm"
		)
		view.Toggle(
			settings,
			"Preview only",
			"Visual playback. Does not play the game piano.",
			false,
			"preview"
		)
		view.Toggle(
			settings,
			"88-key extension",
			"Ctrl mapping requires a compatible piano.",
			false,
			"mode88"
		)
		view.Toggle(
			settings,
			"Octave-fold range",
			"Fold out-of-range notes into this keyboard.",
			true,
			"fold"
		)
		view.Toggle(
			settings,
			"Repeat A / B",
			"Set loop bounds with the transport buttons.",
			false,
			"loop"
		)
		view.Toggle(
			settings,
			"Advance queue",
			"Only advances after explicitly started playback.",
			false,
			"advance"
		)
		view.Toggle(
			settings,
			"Include subfolders",
			"Depth 3, 32 folders, up to 512 MIDI files.",
			true,
			"recursive"
		)
		view.Toggle(
			settings,
			"Reduced motion",
			"Instant transitions; piano dock stays static.",
			view.ReducedMotion,
			"motion"
		)
		view.Value(
			settings,
			"Start delay",
			"0 through 10 seconds to focus the game piano.",
			2,
			"delay"
		)
		local footer = frame(panel, "Transport", color.Panel)
		local seek = button(footer, "SeekBar", "", function() end)
		seek.BackgroundColor3 = color.Border
		seek.Size = UDim2.new(1, -28, 0, 10)
		seek.Position = UDim2.fromOffset(14, 10)
		local seekFill = frame(seek, "SeekFill", color.Cyan)
		seekFill.Size = UDim2.fromScale(0, 1)
		context.Connect(seek.InputBegan, function(event)
			if
				event.UserInputType == Enum.UserInputType.MouseButton1
				or event.UserInputType == Enum.UserInputType.Touch
			then
				view.Dispatch(
					"seek",
					math.clamp(
						(event.Position.X - seek.AbsolutePosition.X)
							/ math.max(1, seek.AbsoluteSize.X),
						0,
						1
					)
				)
			end
		end)
		local transport = {}
		for _, spec in ipairs({
			{ "Prev", "previous" },
			{ "Play", "play" },
			{ "Pause", "pause" },
			{ "Stop", "stop" },
			{ "Next", "next" },
		}) do
			transport[#transport + 1] = button(
				footer,
				spec[2],
				spec[1],
				spec[2],
				spec[2] == "play" and color.Cyan or nil
			)
		end
		local clockLabel =
			label(footer, "Clock", "00:00 / 00:00", 12, color.Muted)
		local stateLabel = label(footer, "State", "DISARMED", 10, color.Violet)
		local bottom = create(
			"Frame",
			panel,
			{ Name = "SessionControls", BackgroundTransparency = 1 }
		)
		local speed = create("TextBox", bottom, {
			Name = "PlaybackSpeed",
			Text = "1.0",
			ClearTextOnFocus = false,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextColor3 = color.Cyan,
			BackgroundColor3 = color.Card,
			BorderSizePixel = 0,
		})
		corner(speed, 7)
		local transpose = create("TextBox", bottom, {
			Name = "Transpose",
			Text = "0",
			ClearTextOnFocus = false,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextColor3 = color.Cyan,
			BackgroundColor3 = color.Card,
			BorderSizePixel = 0,
		})
		corner(transpose, 7)
		local speedTitle =
			label(bottom, "SpeedCaption", "SPEED", 9, color.Muted)
		local pitchTitle =
			label(bottom, "TransposeCaption", "SEMITONES", 9, color.Muted)
		context.Connect(speed.FocusLost, function()
			view.Dispatch("speed", speed.Text)
		end)
		context.Connect(transpose.FocusLost, function()
			view.Dispatch("transpose", transpose.Text)
		end)
		local addQueue = button(bottom, "QueueSelected", "+ Queue", "enqueue")
		local favorite = button(bottom, "Favorite", "Favorite", "favorite")
		local loopA = button(bottom, "LoopA", "Set A", "loopA")
		local loopB = button(bottom, "LoopB", "Set B", "loopB")
		local status = label(
			panel,
			"SessionStatus",
			"Checking local MIDI capabilities...",
			11,
			color.Muted
		)
		local dockMoved = false
		local dock = button(root, "PianoDock", "", function()
			if not dockMoved then
				view.SetVisible(not view.Visible)
			end
		end)
		dock.Size = UDim2.fromOffset(56, 56)
		dock.Position = UDim2.new(0, 12, 0.5, -28)
		dock.Visible = false
		local dockPiano = pianoMark(dock, 44)
		dockPiano.Position = UDim2.fromOffset(6, 6)
		dockPiano.Active = false
		function view.SetVisible(value)
			view.Visible = value
			panel.Visible = value
			dock.Visible = not value
			if value then
				animate(openingScale, 0.3, { Scale = 1 })
				animate(panel, 0.25, { GroupTransparency = 0 })
			end
		end
		function view.Message(message, bad)
			status.Text = tostring(message):gsub("[%z\1-\8]", "")
			status.TextColor3 = bad and color.Red or color.Muted
		end
		local overlay = create("CanvasGroup", panel, {
			Name = "LoadingStage",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = color.Background,
			BorderSizePixel = 0,
			ZIndex = 20,
			GroupTransparency = 0,
		})
		corner(overlay, 20)
		local loadingMark = pianoMark(overlay, 72)
		loadingMark.AnchorPoint = Vector2.new(0.5, 0.5)
		loadingMark.Position = UDim2.fromScale(0.5, 0.36)
		loadingMark.ZIndex = 21
		local loadingTitle = label(overlay, "LoadingTitle", "Auto Player", 30)
		loadingTitle.Font = Enum.Font.GothamBold
		loadingTitle.AnchorPoint = Vector2.new(0.5, 0.5)
		loadingTitle.Position = UDim2.fromScale(0.5, 0.52)
		loadingTitle.Size = UDim2.new(1, -30, 0, 44)
		loadingTitle.TextXAlignment = Enum.TextXAlignment.Center
		loadingTitle.ZIndex = 21
		local loadingText = label(
			overlay,
			"LoadingPhase",
			"NULL / LOCAL MIDI STUDIO",
			12,
			color.Cyan
		)
		loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
		loadingText.Position = UDim2.fromScale(0.5, 0.62)
		loadingText.Size = UDim2.new(1, -32, 0, 36)
		loadingText.TextWrapped = true
		loadingText.TextXAlignment = Enum.TextXAlignment.Center
		loadingText.ZIndex = 21
		local dismiss = button(
			overlay,
			"HideLoading",
			"Hide loading view",
			function()
				overlay.Visible = false
			end
		)
		dismiss.AnchorPoint = Vector2.new(0.5, 0.5)
		dismiss.Position = UDim2.fromScale(0.5, 0.76)
		dismiss.Size = UDim2.fromOffset(170, 40)
		dismiss.ZIndex = 21
		local strip = frame(overlay, "LoadingSweepTrack", color.Card)
		strip.Size = UDim2.fromOffset(180, 3)
		strip.AnchorPoint = Vector2.new(0.5, 0.5)
		strip.Position = UDim2.fromScale(0.5, 0.68)
		strip.ClipsDescendants = true
		strip.ZIndex = 21
		local sweep = frame(strip, "DecorativeSweep", color.Cyan)
		sweep.Size = UDim2.fromScale(0.3, 1)
		sweep.ZIndex = 22
		local loadingSerial = 0
		function view.Loading(visible, phase)
			loadingSerial += 1
			local serial = loadingSerial
			if phase then
				loadingText.Text = phase
			end
			if visible then
				overlay.Visible = true
				animate(overlay, 0.15, { GroupTransparency = 0 })
				loadingMark.Position = UDim2.fromScale(0.5, 0.32)
				sweep.Position = UDim2.fromScale(-0.3, 0)
				animate(sweep, 0.9, { Position = UDim2.fromScale(1.1, 0) })
				animate(
					loadingMark,
					0.45,
					{ Position = UDim2.fromScale(0.5, 0.36) }
				)
			else
				animate(overlay, 0.3, { GroupTransparency = 1 })
				task.delay(view.ReducedMotion and 0 or 0.31, function()
					if view.Alive and serial == loadingSerial then
						overlay.Visible = false
					end
				end)
			end
		end
		local trackRows = {}
		function view.Tracks(tracks, muted)
			rowHeights.Mixer = trackStart
			for index = 1, math.max(#trackRows, #(tracks or {})) do
				local track = tracks and tracks[index]
				local item = trackRows[index]
				if track and not item then
					local row = settingRow(mixer, "Track", "")
					local control = button(
						row,
						"Track" .. index,
						"ACTIVE",
						function()
							local active = trackRows[index].Track
							if active then
								view.Dispatch("track", active.Index)
							end
						end
					)
					control.Size = UDim2.fromOffset(88, 40)
					control.Position = UDim2.new(1, -100, 0.5, -20)
					item = { Row = row, Control = control }
					trackRows[index] = item
				end
				if item then
					item.Track = track
					item.Row.Visible = track ~= nil
					if track then
						item.Row.Position =
							UDim2.fromOffset(12, trackStart + (index - 1) * 86)
						item.Row:FindFirstChild("Heading").Text = track.Name
									~= ""
								and track.Name
							or "Track " .. track.Index
						item.Row:FindFirstChild("Detail").Text = track.Notes
							.. " notes / tap to mute or unmute"
						item.Control.Text = muted[track.Index] and "MUTED"
							or "ACTIVE"
					end
				end
			end
			mixer.CanvasSize =
				UDim2.fromOffset(0, trackStart + #(tracks or {}) * 86 + 12)
		end
		function view.Files(entries, selected, queuePage, pageNumber, pageCount)
			listHeading.Text = (
				queuePage and "SESSION QUEUE" or "YOUR MIDI LIBRARY"
			)
				.. " / "
				.. pageNumber
				.. "/"
				.. pageCount
			empty.Visible = #entries == 0
			empty.Text = queuePage
					and "Your queue is empty. Select a local song and choose + Queue."
				or "No matching MIDI files. Refresh or change the folder in Settings."
			for index = 1, 24 do
				local row = view.Rows[index]
				if not row then
					local object = button(
						list,
						"SongRow" .. index,
						"",
						function()
							local item = view.Rows[index].Entry
							if item then
								view.Dispatch("select", item)
							end
						end
					)
					object.Position = UDim2.fromOffset(0, (index - 1) * 58)
					object.Size = UDim2.new(1, -6, 0, 52)
					local name = label(object, "FileName", "", 12)
					name.Position = UDim2.fromOffset(10, 6)
					name.Size = UDim2.new(1, -20, 0, 21)
					local detail = label(object, "Folder", "", 9, color.Muted)
					detail.Position = UDim2.fromOffset(10, 29)
					detail.Size = UDim2.new(1, -20, 0, 17)
					row = { Object = object, Name = name, Detail = detail }
					view.Rows[index] = row
				end
				row.Entry = entries[index]
				row.Object.Visible = row.Entry ~= nil
				if row.Entry then
					row.Name.Text = row.Entry.Name
					row.Detail.Text = row.Entry.Folder or row.Entry.Path
					row.Object.BackgroundColor3 = selected == row.Entry.Path
							and Color3.fromRGB(37, 65, 81)
						or color.Card
				end
			end
			list.CanvasSize = UDim2.fromOffset(0, math.max(80, #entries * 58))
			list.CanvasPosition = Vector2.new(0, 0)
		end
		function view.Keyboard(mode88)
			for _, key in pairs(view.Keys) do
				key:Destroy()
			end
			table.clear(view.Keys)
			view.KeyGeometry = {}
			local low, high = mode88 and 21 or 36, mode88 and 108 or 96
			local black =
				{ [1] = true, [3] = true, [6] = true, [8] = true, [10] = true }
			local whiteCount = 0
			for pitch = low, high do
				if not black[pitch % 12] then
					whiteCount += 1
				end
			end
			local offset = 0
			for pitch = low, high do
				local dark = black[pitch % 12]
				local key = create("Frame", keyboard, {
					Name = "Key" .. pitch,
					BackgroundColor3 = dark and color.Background or color.Text,
					BorderSizePixel = 0,
					Size = UDim2.new(
						(dark and 0.58 or 0.95) / whiteCount,
						0,
						dark and 0.62 or 1,
						0
					),
					Position = UDim2.fromScale(
						(offset - (dark and 0.29 or 0)) / whiteCount,
						0
					),
					ZIndex = dark and 3 or 2,
				})
				corner(key, 2)
				view.KeyGeometry[pitch] = {
					X = (offset - (dark and 0.29 or 0)) / whiteCount,
					Width = (dark and 0.58 or 0.95) / whiteCount,
				}
				view.Keys[pitch] = key
				key:SetAttribute("DarkKey", dark == true)
				if not dark then
					offset += 1
				end
			end
			modeLabel.Text = mode88 and "88-KEY EXTENSION / A0 - C8"
				or "61-KEY VIRTUAL PIANO / C2 - C7"
		end
		view.Keyboard(false)
		local function time(seconds)
			seconds = math.max(0, math.floor(seconds))
			return string.format(
				"%02d:%02d",
				math.floor(seconds / 60),
				seconds % 60
			)
		end
		function view.Score(score, name)
			song.Text = name
			stageTag.Text = "LOCAL MIDI / " .. #score.Tracks .. " TRACKS"
			meta.Text = #score.Notes
				.. " notes  /  "
				.. #score.Tempos
				.. " tempo markers  /  "
				.. time(score.Duration)
		end
		function view.Snapshot(player, output)
			if not view.Visible then
				return
			end
			clockLabel.Text = time(player.Position)
				.. " / "
				.. time(player.Score and player.Score.Duration or 0)
			stateLabel.Text = player.Preview and "PREVIEW / NO GAME INPUT"
				or player.Armed and "ARMED / " .. player.State:upper()
				or "DISARMED / " .. player.State:upper()
			seekFill.Size = UDim2.fromScale(
				player.Score
						and player.Position / math.max(
							0.001,
							player.Score.Duration
						)
					or 0,
				1
			)
			local pressed = {}
			for _, pitch in pairs(player.Active) do
				local token = output.Map(pitch)
				if token then
					pressed[token.Pitch] = true
				end
			end
			for pitch, key in pairs(view.Keys) do
				key.BackgroundColor3 = pressed[pitch] and color.Cyan
					or key:GetAttribute("DarkKey") and color.Background
					or color.Text
			end
			for _, bar in ipairs(view.Bars) do
				bar.Visible = false
			end
			if not player.Score then
				return
			end
			local tempos = player.Score.Tempos
			local tempoIndex, tempoHigh = 1, #tempos
			while tempoIndex < tempoHigh do
				local middle = math.ceil((tempoIndex + tempoHigh) / 2)
				if tempos[middle].Time <= player.Position then
					tempoIndex = middle
				else
					tempoHigh = middle - 1
				end
			end
			meta.Text = string.format(
				"%d notes / %.1f BPM / %.2fx / %d skipped events",
				#player.Score.Notes,
				tempos[tempoIndex].BPM,
				player.Speed,
				player.Dropped
			)
			local notes = player.Score.Notes
			local low, high = 1, #notes + 1
			while low < high do
				local middle = math.floor((low + high) / 2)
				if notes[middle].Start < player.Position - 1 then
					low = middle + 1
				else
					high = middle
				end
			end
			local count = 0
			for index = low, math.min(#notes, low + 256) do
				local note = notes[index]
				if note.Start > player.Position + 4 then
					break
				end
				local noteEnd = player.Sustain and note.End or note.RawEnd
				local effectiveEnd = note.Start
					+ (noteEnd - note.Start) * player.Gate
				if
					effectiveEnd <= player.Position
					or player.Muted[note.Track]
					or (note.Channel == 9 and not player.Drums)
					or note.Velocity < player.MinimumVelocity
				then
					continue
				end
				local token = output.Map(note.Pitch + player.Transpose)
				if token then
					count += 1
					if count > #view.Bars then
						break
					end
					local start = math.max(0, note.Start - player.Position)
					local ending = math.min(4, effectiveEnd - player.Position)
					local bar = view.Bars[count]
					local geometry = view.KeyGeometry[token.Pitch]
					bar.Position = UDim2.fromScale(geometry.X, 1 - ending / 4)
					bar.Size = UDim2.new(
						geometry.Width,
						-1,
						math.max(0.006, (ending - start) / 4),
						0
					)
					bar.Visible = true
				end
			end
		end
		function view.SetPage(name)
			view.Page = name
			rail.Visible = name == "Library" or name == "Queue"
			stage.Visible = rail.Visible
			for pageName, page in pairs(pages) do
				page.Visible = pageName == name
			end
			for pageName, object in pairs(navButtons) do
				object.TextColor3 = name == pageName and color.Cyan
					or color.Muted
			end
			view.Dispatch("tab", name)
		end
		for index, name in ipairs({ "Library", "Queue", "Mixer", "Settings" }) do
			local object = button(nav, name, name, function()
				view.SetPage(name)
			end)
			object.Size = UDim2.new(0.25, -6, 1, 0)
			object.Position = UDim2.new((index - 1) * 0.25, 0, 0, 0)
			navButtons[name] = object
		end
		local testRow = settingRow(
			settings,
			"Input test / F7 panic",
			"F8 play/pause. Never auto-resumes after text entry."
		)
		local testButton = button(testRow, "TestInput", "Test C4", "test")
		testButton.Size = UDim2.fromOffset(88, 40)
		testButton.Position = UDim2.new(1, -100, 0.5, -20)
		local clearRow = settingRow(
			settings,
			"Session queue",
			"In memory only; no files are deleted or written."
		)
		local clearButton =
			button(clearRow, "ClearQueue", "Clear", "clearqueue")
		clearButton.Size = UDim2.fromOffset(88, 40)
		clearButton.Position = UDim2.new(1, -100, 0.5, -20)
		local folderRow = settingRow(
			settings,
			"MIDI folder",
			"Requested Android folder; relative MIDI fallback only if listing is blocked."
		)
		folderRow.Size = UDim2.new(1, -24, 0, 122)
		rowHeights.Settings += 46
		local path = create("TextBox", folderRow, {
			Name = "MidiFolder",
			Text = "/storage/emulated/0/Delta/Workspace/MIDI/",
			ClearTextOnFocus = false,
			TextSize = 11,
			TextColor3 = color.Cyan,
			Font = Enum.Font.Gotham,
			BackgroundColor3 = color.Background,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(10, 76),
			Size = UDim2.new(1, -20, 0, 36),
		})
		corner(path, 8)
		context.Connect(path.FocusLost, function()
			view.Dispatch("folder", path.Text)
		end)
		settings.CanvasSize = UDim2.fromOffset(0, rowHeights.Settings + 18)
		local initialized = false
		local function layout()
			if not view.Alive then
				return
			end
			local size = root.AbsoluteSize
			if size.X < 1 or size.Y < 1 then
				return
			end
			local width, height =
				math.min(1040, size.X - 16), math.min(750, size.Y - 16)
			panel.Size = UDim2.fromOffset(width, height)
			if not initialized then
				panel.Position = UDim2.fromOffset(size.X / 2, size.Y / 2)
				initialized = true
			end
			local position = panel.Position
			panel.Position = UDim2.fromOffset(
				math.clamp(position.X.Offset, width / 2, size.X - width / 2),
				math.clamp(position.Y.Offset, height / 2, size.Y - height / 2)
			)
			header.Position = UDim2.fromOffset(8, 8)
			header.Size = UDim2.new(1, -16, 0, 68)
			minimize.Size = UDim2.fromOffset(44, 40)
			minimize.Position = UDim2.new(1, -102, 0, 14)
			close.Size = UDim2.fromOffset(44, 40)
			close.Position = UDim2.new(1, -52, 0, 14)
			nav.Position = UDim2.fromOffset(14, 84)
			nav.Size = UDim2.new(1, -28, 0, 36)
			main.Position = UDim2.fromOffset(14, 130)
			main.Size = UDim2.new(1, -28, 1, -278)
			local short = height < 520
			local contentY = short and 108 or 130
			main.Position = UDim2.fromOffset(14, contentY)
			main.Size = UDim2.new(1, -28, 1, -contentY - 148)
			local contentWidth, contentHeight =
				width - 28, height - contentY - 148
			local compact = width < 700 and not short
			local railWidth = short and math.min(210, (width - 40) * 0.42)
				or 258
			if short then
				header.Size = UDim2.new(1, -16, 0, 54)
				logo.Position = UDim2.fromOffset(14, 5)
				brand.Position = UDim2.fromOffset(70, 4)
				title.Position = UDim2.fromOffset(69, 19)
				nav.Position = UDim2.fromOffset(14, 68)
				nav.Size = UDim2.new(1, -28, 0, 32)
			end
			if compact then
				rail.Position = UDim2.fromOffset(0, 0)
				rail.Size =
					UDim2.new(1, 0, 0, math.max(184, contentHeight * 0.42))
				stage.Position =
					UDim2.fromOffset(0, math.max(184, contentHeight * 0.42) + 8)
				stage.Size =
					UDim2.new(1, 0, 1, -math.max(192, contentHeight * 0.42 + 8))
				-- Portrait focuses on song selection and the visual piano, with compact
				-- metadata. Mixer/settings retain full-width scrollable touch controls.
				stageTag.Visible = false
				song.Position = UDim2.fromOffset(12, 8)
				song.TextSize = 16
				song.Size = UDim2.new(1, -24, 0, 24)
				meta.Visible = false
				roll.Position = UDim2.fromOffset(10, 40)
				roll.Size = UDim2.new(1, -20, 1, -94)
			else
				rail.Position = UDim2.fromOffset(0, 0)
				rail.Size = UDim2.new(0, railWidth, 1, 0)
				stage.Position = UDim2.fromOffset(railWidth + 12, 0)
				stage.Size = UDim2.new(1, -railWidth - 12, 1, 0)
				stageTag.Visible = true
				song.Position = UDim2.fromOffset(16, 35)
				song.TextSize = 22
				song.Size = UDim2.new(1, -32, 0, 31)
				meta.Visible = true
				roll.Position = UDim2.fromOffset(14, 104)
				roll.Size = UDim2.new(1, -28, 1, -190)
			end
			if short then
				stageTag.Visible = false
				meta.Visible = false
				song.Position = UDim2.fromOffset(10, 6)
				song.TextSize = 14
				roll.Position = UDim2.fromOffset(10, 34)
				roll.Size = UDim2.new(1, -20, 1, -70)
			end
			keyboard.Position =
				UDim2.new(0, 12, 1, short and -30 or compact and -48 or -78)
			keyboard.Size =
				UDim2.new(1, -24, 0, short and 24 or compact and 34 or 48)
			modeLabel.Position = UDim2.new(0, 12, 1, -25)
			modeLabel.Size = UDim2.new(1, -110, 0, 18)
			modeLabel.Visible = not compact and not short
			audition.Position = UDim2.new(1, -94, 1, -28)
			audition.Size = UDim2.fromOffset(82, 22)
			audition.Visible = not compact and not short
			for _, page in pairs(pages) do
				page.Size = UDim2.fromScale(1, 1)
			end
			previousPage.Position = UDim2.new(0, 10, 1, -38)
			previousPage.Size = UDim2.fromOffset(38, 30)
			nextPage.Position = UDim2.new(1, -48, 1, -38)
			nextPage.Size = UDim2.fromOffset(38, 30)
			refresh.Position = UDim2.new(0, 56, 1, -38)
			refresh.Size = UDim2.new(1, -112, 0, 30)
			listHeading.Visible = not short
			search.Visible = not short
			list.Position = UDim2.fromOffset(8, short and 6 or 82)
			list.Size = UDim2.new(1, -16, 1, short and -48 or -126)
			footer.Position = UDim2.new(0, 14, 1, -140)
			footer.Size = UDim2.new(1, -28, 0, 82)
			local controlWidth = (contentWidth - 32) / 5
			for index, object in ipairs(transport) do
				object.Position =
					UDim2.fromOffset(8 + (index - 1) * (controlWidth + 4), 28)
				object.Size = UDim2.fromOffset(controlWidth, 32)
			end
			clockLabel.Position = UDim2.fromOffset(12, 63)
			clockLabel.Size = UDim2.new(0.5, 0, 0, 16)
			stateLabel.Position = UDim2.new(0.4, 0, 0, 63)
			stateLabel.Size = UDim2.new(0.6, -12, 0, 16)
			stateLabel.TextXAlignment = Enum.TextXAlignment.Right
			bottom.Position = UDim2.new(0, 14, 1, -52)
			bottom.Size = UDim2.new(1, -28, 0, 30)
			speedTitle.Position = UDim2.fromOffset(0, 0)
			speedTitle.Size = UDim2.fromOffset(44, 10)
			speed.Position = UDim2.fromOffset(0, 10)
			speed.Size = UDim2.fromOffset(44, 24)
			pitchTitle.Position = UDim2.fromOffset(50, 0)
			pitchTitle.Size = UDim2.fromOffset(58, 10)
			transpose.Position = UDim2.fromOffset(50, 10)
			transpose.Size = UDim2.fromOffset(48, 24)
			local smallWidth = math.max(43, (contentWidth - 110) / 4 - 4)
			for index, object in ipairs({ addQueue, favorite, loopA, loopB }) do
				object.Position =
					UDim2.fromOffset(106 + (index - 1) * (smallWidth + 4), 4)
				object.Size = UDim2.fromOffset(smallWidth, 28)
				object.TextSize = compact and 10 or 12
			end
			status.Position = UDim2.new(0, 14, 1, -16)
			status.Size = UDim2.new(1, -28, 0, 14)
		end
		context.Connect(root:GetPropertyChangedSignal("AbsoluteSize"), layout)
		local dragging, dragStart, dragPosition = false, nil, nil
		context.Connect(header.InputBegan, function(event)
			if
				event.UserInputType == Enum.UserInputType.MouseButton1
				or event.UserInputType == Enum.UserInputType.Touch
			then
				dragging = event
				dragStart = event.Position
				dragPosition = panel.Position
			end
		end)
		context.Connect(input.InputChanged, function(event)
			if
				dragging
				and (
					event == dragging
					or event.UserInputType
						== Enum.UserInputType.MouseMovement
				)
			then
				local delta = event.Position - dragStart
				local width, height = panel.AbsoluteSize.X, panel.AbsoluteSize.Y
				panel.Position = UDim2.fromOffset(
					math.clamp(
						dragPosition.X.Offset + delta.X,
						width / 2,
						root.AbsoluteSize.X - width / 2
					),
					math.clamp(
						dragPosition.Y.Offset + delta.Y,
						height / 2,
						root.AbsoluteSize.Y - height / 2
					)
				)
			end
		end)
		context.Connect(input.InputEnded, function(event)
			if event == dragging then
				dragging = false
			end
		end)
		local dockDrag, dockStart, dockPosition
		context.Connect(dock.InputBegan, function(event)
			if
				event.UserInputType == Enum.UserInputType.MouseButton1
				or event.UserInputType == Enum.UserInputType.Touch
			then
				dockDrag = event
				dockStart = event.Position
				dockPosition = dock.AbsolutePosition
				dockMoved = false
			end
		end)
		context.Connect(input.InputChanged, function(event)
			if
				dockDrag
				and (
					event == dockDrag
					or event.UserInputType
						== Enum.UserInputType.MouseMovement
				)
			then
				local delta = event.Position - dockStart
				if delta.Magnitude > 5 then
					dockMoved = true
				end
				if dockMoved then
					dock.Position = UDim2.fromOffset(
						math.clamp(
							dockPosition.X + delta.X - root.AbsolutePosition.X,
							0,
							math.max(0, root.AbsoluteSize.X - 56)
						),
						math.clamp(
							dockPosition.Y + delta.Y - root.AbsolutePosition.Y,
							0,
							math.max(0, root.AbsoluteSize.Y - 56)
						)
					)
				end
			end
		end)
		context.Connect(input.InputEnded, function(event)
			if event == dockDrag then
				dockDrag = nil
				task.delay(0.1, function()
					if view.Alive then
						dockMoved = false
					end
				end)
			end
		end)
		context.Connect(gui.Destroying, function()
			if view.Alive then
				context.Library:Unload()
			end
		end)
		context.RegisterCleanup(function()
			view.Alive = false
			loadingSerial += 1
			for _, tween in pairs(view.Tweens) do
				pcall(tween.Cancel, tween)
			end
			table.clear(view.Tweens)
			gui:Destroy()
		end)
		layout()
		view.SetPage("Library")
		animate(panel, 0.6, { GroupTransparency = 0 })
		animate(openingScale, 0.6, { Scale = 1 })
		return view
	end
end)()
local function runGame(context)
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
	local root, recursive, advance, startDelay =
		files.AndroidRoot, true, false, 2
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
		local search = favoritesOnly and query:sub(5):match("^%s*(.-)%s*$")
			or query
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
		view.Loading(true, phase)
		operation = task.defer(function()
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
			assert(
				type(api.Read) == "function",
				"Delta readfile is unavailable"
			)
			local data = api.Read(entry.Path)
			assert(current(token), "File load cancelled")
			view.Loading(true, "Decoding MIDI tracks and tempo map")
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
			if
				continueQueue
				and advance
				and (player.Armed or player.Preview)
			then
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
			view.Message(
				"Paused because the app lost focus. Press Play to resume."
			)
		end
	end)
	context.Connect(game:GetService("RunService").Heartbeat, function()
		if countdown then
			if os.clock() >= countdown then
				countdown = nil
				local success, reason = pcall(function()
					assert(
						not input:GetFocusedTextBox(),
						"Text field is focused"
					)
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
	return { Transport = player, Output = output, View = view }
end
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local library = { Hooks = {} }
function library:OnUnload(callback)
	table.insert(self.Hooks, callback)
end
function library:Unload()
	if self.Unloaded then
		return
	end
	self.Unloaded = true
	for _, callback in ipairs(self.Hooks) do
		local ok, reason = pcall(callback)
		if not ok then
			warn("[NULL Auto Player cleanup] " .. tostring(reason))
		end
	end
	table.clear(self.Hooks)
end
local context = makeSession("autoplayer", library)
local environment = type(getgenv) == "function" and getgenv() or _G
context.ReducedMotion = environment.Nullx11ReducedMotion == true
context.MidiParser = midiParser
context.MidiFiles = midiFiles
context.MakeMidiOutput = makeMidiOutput
context.MakeMidiTransport = makeMidiTransport
context.MakeAutoPlayerView = makeAutoPlayerView
local ok, result = xpcall(function()
	return runGame(context)
end, debug.traceback)
if not ok then
	library:Unload()
	warn("[NULL Auto Player] " .. tostring(result))
end
