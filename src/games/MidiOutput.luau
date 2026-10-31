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
			output.References[token.Key] = (output.References[token.Key] or 0)
				+ 1
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
