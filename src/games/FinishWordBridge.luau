-- Source-evidenced protocol only. Explicit capped discovery; no UI vendor,
-- executor identity escalation, metatable hook or guessed RemoteEvent payloads.
return function(api)
	local bridge = { Attached = false, Tokens = {}, Generation = 0 }
	local bus, gameplay, gameInput, gameConfig
	local function read(candidate)
		if type(candidate) ~= "table" then
			return nil
		end
		local props, children, instance =
			rawget(candidate, "_Properties"),
			rawget(candidate, "_Children"),
			rawget(candidate, "Instance")
		if
			type(props) ~= "table"
			or type(children) ~= "table"
			or rawget(props, "Ui") ~= candidate
			or type(rawget(props, "Prompt")) ~= "table"
			or rawget(props, "RoundEnded")
			or not api.Instance(instance)
			or instance.Parent ~= api.PlayerGui
		then
			return nil
		end
		local top = rawget(children, "TopBar")
		local topChildren = type(top) == "table" and rawget(top, "_Children")
		local input = type(topChildren) == "table"
			and rawget(topChildren, "AnswerInput")
		if
			not rawget(children, "ChoiceList")
			or type(input) ~= "table"
			or type(input.currentWord) ~= "function"
		then
			return nil
		end
		return rawget(props, "Prompt"), input
	end
	function bridge.Detach()
		bridge.Generation += 1
		bridge.Attached = false
		for _, token in ipairs(bridge.Tokens) do
			if bus and type(bus.disconnect) == "function" then
				pcall(bus.disconnect, token)
			end
		end
		table.clear(bridge.Tokens)
		bus, gameplay, gameInput, gameConfig = nil, nil, nil, nil
	end
	function bridge.Prompt()
		local prompt, input = read(gameplay)
		gameInput = input
		return prompt
	end
	function bridge.Read()
		assert(
			bridge.Attached and bridge.Prompt() and gameInput,
			"Game input is no longer mounted"
		)
		return gameInput:currentWord()
	end
	function bridge.Fire(kind, value)
		assert(
			bridge.Attached and api.Alive(),
			"Finish The Word session is detached"
		)
		assert(
			kind == "tryKeystroke" or kind == "tryAnswer",
			"Unsupported source event"
		)
		if kind == "tryKeystroke" then
			assert(
				value == -1
					or type(value) == "string" and value:match("^[A-Z]$"),
				"Invalid keystroke"
			)
		end
		if kind == "tryAnswer" then
			return bus.fire(kind)
		end
		return bus.fire(kind, value)
	end
	function bridge.Choose(letter)
		assert(bridge.Attached and api.Alive(), "Session detached")
		assert(
			type(letter) == "string"
				and #letter <= 16
				and letter:match("^[a-z]+$"),
			"Invalid choice prefix"
		)
		return bus.remoteFire("chooseLetter", letter)
	end
	function bridge.Config()
		return gameConfig
	end
	function bridge.Attach(callbacks)
		bridge.Detach()
		assert(
			type(api.GetGC) == "function",
			"This executor does not expose getgc; suggestions from manual prefixes still work"
		)
		local generation = bridge.Generation
		local snapshot = api.GetGC(true)
		assert(type(snapshot) == "table", "getgc did not return a table")
		local visited, buses = 0, {}
		for _, candidate in pairs(snapshot) do
			visited += 1
			if visited > 100000 then
				break
			end
			if not api.Alive() or bridge.Generation ~= generation then
				return false
			end
			if type(candidate) == "table" then
				if
					type(rawget(candidate, "fire")) == "function"
					and type(rawget(candidate, "remoteFire")) == "function"
					and type(rawget(candidate, "remoteConnect")) == "function"
					and type(rawget(candidate, "disconnect")) == "function"
					and rawget(candidate, "ping")
				then
					table.insert(buses, candidate)
				end
				if rawget(candidate, "_Mounted") and read(candidate) then
					gameplay = candidate
				end
				local afk = rawget(candidate, "AFK")
				if
					rawget(candidate, "PET")
					and type(afk) == "table"
					and type(rawget(afk, "Threshold")) == "number"
				then
					gameConfig = candidate
				end
			end
			if visited % 500 == 0 then
				api.Yield()
			end
		end
		assert(
			#buses == 1 and gameplay,
			"Expected one source event bus and mounted gameplay signature; join a round and attach again"
		)
		bus = buses[1]
		local function subscribe(name, callback)
			local token = bus.remoteConnect(name, function(...)
				if
					bridge.Attached
					and bridge.Generation == generation
					and api.Alive()
				then
					local ok, reason = pcall(callback, ...)
					if not ok then
						bridge.LastError = tostring(reason)
						bridge.Detach()
					end
				end
			end)
			assert(
				token ~= nil,
				"Game subscription returned no ownership token"
			)
			table.insert(bridge.Tokens, token)
		end
		bridge.Attached = true
		local ok, reason = pcall(function()
			subscribe("updateRound", function(prompt, _, turn)
				if type(prompt) == "table" then
					callbacks.Round(prompt, turn)
				end
			end)
			subscribe("correct", callbacks.Correct)
			subscribe("strike", function(uid, _, alreadyUsed)
				callbacks.Strike(uid, alreadyUsed)
			end)
			subscribe("takeDamage", callbacks.Damage)
			subscribe("attack", callbacks.Attack)
		end)
		if not ok then
			bridge.Detach()
			error(reason, 0)
		end
		return true, visited
	end
	return bridge
end
