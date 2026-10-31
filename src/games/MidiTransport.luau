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
		local boundary = player.Loop and (player.LoopB or player.Score.Duration)
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
