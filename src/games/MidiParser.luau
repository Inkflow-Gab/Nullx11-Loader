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
	assert(headerSize >= 6 and headerSize <= 1024, "Invalid MIDI header length")
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
		assert(operations <= parser.MaxEvents, "MIDI exceeds 100,000 events")
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
		tracks[track] = { Name = "Track " .. track, Notes = 0, Index = track }
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
			table.insert(
				score.Tempos,
				{ Time = seconds, BPM = 60000000 / tempo, Tick = event.Tick }
			)
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
						deferred[event.Channel] = deferred[event.Channel] or {}
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
