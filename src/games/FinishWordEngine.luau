-- Scoped, heartbeat-driven turn machine. No unbounded typing coroutine, remote
-- guesses, synthetic user keys, usernames or automatic restart after cancellation.
return function(api, dictionary, config)
	local engine = {
		Used = {},
		Attempted = {},
		Submitted = {},
		Tried = {},
		Pending = nil,
		Plan = nil,
		Token = 0,
		Turns = 0,
		Accepted = 0,
		Requests = 0,
		Retries = 0,
		Status = "Attach during a round",
		LastAttack = -math.huge,
		Wpm = 60,
		EffectiveLength = "Neutral",
	}
	local nextSend = 0
	local function clean(word, maximum)
		return dictionary.Clean(word, maximum)
	end
	function engine.Cancel(reason)
		engine.Token += 1
		engine.Plan, engine.Pending = nil, nil
		engine.Status = reason or "Stopped"
	end
	local function localTurn()
		return api.Alive()
			and api.Attached()
			and engine.Turn == api.Player
			and api.IsTurn()
			and api.Focused()
	end
	local function promptStillCurrent()
		local prompt = api.Prompt()
		return prompt
			and not prompt.Choices
			and clean(prompt.RequiredLetter, 16) == engine.Prefix
	end
	function engine.Length()
		if config.Length ~= "Auto" then
			return config.Length
		end
		-- Start with comfortable medium words, shorten when the selected typing
		-- speed would make a longer answer slow, then move toward unused longer
		-- bands as common short/medium words are consumed. Never resets history.
		if
			config.FixedDelay and config.TypeDelay >= 0.2
			or not config.FixedDelay and config.WpmMin < 45
		then
			return "Short"
		end
		if
			engine.Turns >= 16
			or engine.UsedCount and engine.UsedCount >= 40
		then
			return "Longer"
		end
		if engine.Turns >= 7 then
			return "Long"
		end
		return "Neutral"
	end
	function engine.Candidates(prefix, limit, forTyping, ignoreSuffix)
		local options = {}
		for key, value in pairs(config) do
			options[key] = value
		end
		options.Length = engine.Length()
		engine.EffectiveLength = options.Length
		local blocked = {}
		for word in pairs(engine.Used) do
			blocked[word] = true
		end
		for word in pairs(engine.Attempted) do
			blocked[word] = true
		end
		local result, info = dictionary.Search(
			prefix,
			options,
			blocked,
			forTyping and engine.Tried or {},
			limit or 12,
			ignoreSuffix
		)
		if
			#result == 0
			and not ignoreSuffix
			and config.SuffixFallback
			and type(config.Endings) == "string"
			and config.Endings:match("[a-zA-Z]")
		then
			result, info = dictionary.Search(
				prefix,
				options,
				blocked,
				forTyping and engine.Tried or {},
				limit or 12,
				true
			)
			info.EndingsFallback = #result > 0
		end
		return result, info
	end
	local function delayForKey()
		if config.Instant then
			return 1 / 30
		end
		local delay = config.FixedDelay and config.TypeDelay
			or 60 / (engine.Wpm * 5)
		if config.HumanType then
			delay *= 0.9 + api.Random() * 0.2
		end
		return math.max(1 / 30, delay)
	end
	function engine.Start(selected, manual)
		if engine.Plan or engine.Pending then
			return false, "Already typing or awaiting an answer"
		end
		if not localTurn() or not engine.Prefix or not promptStillCurrent() then
			return false, "Not your active letter turn, or input is paused"
		end
		if not manual and not config.AutoAnswer then
			return false, "Auto answer is off"
		end
		if engine.Retries >= config.MaxRetries then
			return false, "Retry limit reached for this turn"
		end
		local candidates, info = engine.Candidates(engine.Prefix, 1, true)
		local word
		if selected ~= nil then
			word = clean(selected)
		else
			word = candidates[1] and candidates[1].Word
		end
		if not word then
			engine.Status = "No unused word matches this prefix/length/endings"
			return false, engine.Status
		end
		if
			word:sub(1, #engine.Prefix) ~= engine.Prefix
			or engine.Used[word]
			or engine.Attempted[word]
			or engine.Tried[word]
			or dictionary.Black[word]
			or not dictionary.Words[word]
		then
			return false,
				"Word was used, attempted, blocked, unknown or mismatched"
		end
		local typed = clean(api.Read(), 45)
		if not typed or typed:sub(1, #engine.Prefix) ~= engine.Prefix then
			return false, "Game input does not match the active prefix"
		end
		engine.Wpm = math.min(config.WpmMin, config.WpmMax)
			+ api.Random() * math.abs(config.WpmMax - config.WpmMin)
		local think = math.min(config.StartMin, config.StartMax)
			+ api.Random() * math.abs(config.StartMax - config.StartMin)
		if config.ThinkCurve then
			local level = config.ThinkDriver == "Words used"
					and (engine.UsedCount or 0)
				or config.ThinkDriver == "Turn number" and engine.Turns
				or 60 - math.min(info.Count or 0, 60)
			local t = math.clamp((level - config.ThinkThreshold) / 20, 0, 1)
			if config.ThinkShape == "Exp" then
				t = (math.exp(2 * t) - 1) / (math.exp(2) - 1)
			elseif config.ThinkShape == "Log" then
				t = math.log(1 + 2 * t) / math.log(3)
			end
			think = math.min(config.ThinkCap, think + config.ThinkExtra * t)
		end
		local actions = {}
		for _ = #engine.Prefix + 1, #typed do
			actions[#actions + 1] = { Value = -1 }
		end
		for index = #engine.Prefix + 1, #word do
			local char = word:sub(index, index)
			if
				not config.Instant
				and config.Typos
				and engine.Accepted >= config.TypoWarmup
				and #word > config.TypoSafeLen
				and api.Random() * 100 < config.TypoChance
			then
				-- A deterministic adjacent QWERTY neighbor, followed by an owned
				-- backspace. This is a typing effect, not an anti-detection claim.
				local neighbors = {
					q = "wa",
					w = "qeas",
					e = "wrsd",
					r = "etdf",
					t = "ryfg",
					y = "tugh",
					u = "yihj",
					i = "uojk",
					o = "ipkl",
					p = "ol",
					a = "qwsz",
					s = "awedxz",
					d = "serfcx",
					f = "drtgvc",
					g = "ftyhbv",
					h = "gyujnb",
					j = "huikmn",
					k = "jiolm",
					l = "kop",
					z = "asx",
					x = "zsdc",
					c = "xdfv",
					v = "cfgb",
					b = "vghn",
					n = "bhjm",
					m = "njk",
				}
				local choices = neighbors[char]
				if choices then
					local at = math.min(
						#choices,
						math.floor(api.Random() * #choices) + 1
					)
					actions[#actions + 1] = { Value = choices:sub(at, at) }
					actions[#actions + 1] = { Value = -1 }
				end
			end
			actions[#actions + 1] = { Value = char }
		end
		-- Attempted is match-wide: a started or submitted word is never retried,
		-- even if a mode change or another round arrives before a correct event.
		engine.Tried[word], engine.Attempted[word] = true, true
		engine.Plan = {
			Token = engine.Token,
			Word = word,
			Expected = typed,
			Actions = actions,
			Index = 1,
			Next = api.Clock() + (config.Instant and 0 or think),
			Manual = manual,
			SyncedAt = api.Clock(),
			Fallback = info.Fallback,
		}
		engine.Status = "Preparing "
			.. word
			.. (
				(info.Fallback or info.EndingsFallback)
					and " / nearest available preference"
				or ""
			)
		return true
	end
	local function used(word)
		if not engine.Used[word] then
			engine.Used[word] = true
			engine.UsedCount = (engine.UsedCount or 0) + 1
		end
	end
	function engine.Round(prompt, turn)
		engine.Cancel("Waiting for your turn")
		engine.Turn, engine.Prefix, engine.Choices =
			turn,
			clean(prompt and prompt.RequiredLetter, 16),
			prompt and prompt.Choices
		engine.Tried, engine.Retries = {}, 0
		if turn == api.Player then
			engine.Turns += 1
			engine.Status = engine.Choices and "Choose a starting letter"
				or "Your turn"
			if config.AutoAnswer and engine.Prefix then
				local ok, why = engine.Start()
				if not ok then
					engine.Status = why
				end
			end
		end
	end
	function engine.Correct(word)
		word = clean(word)
		if not word then
			return
		end
		-- The event is global: words accepted for opponents count too.
		used(word)
		if word == engine.Pending then
			engine.Accepted += 1
		end
		if config.AutoLearn and not dictionary.Black[word] then
			dictionary.White[word] = true
			dictionary.Add(word)
			api.Learned(word)
		end
		engine.Cancel("Accepted word recorded: " .. word)
	end
	function engine.Strike(uid, alreadyUsed)
		if
			uid ~= api.Player.UserId
			or not engine.Pending
			or api.Clock() - engine.LastAttack < 1.5
			or api.Cutscene()
		then
			return
		end
		local word = engine.Pending
		if alreadyUsed then
			used(word)
		end
		if
			not alreadyUsed
			and config.AutoBlacklist
			and api.Clock() - (engine.SubmittedAt or 0) < 3
		then
			dictionary.Edit(word, "blacklist")
			api.Learned(word)
		end
		engine.Cancel(
			alreadyUsed and "Server reported an already used word"
				or "Answer rejected"
		)
		engine.Retries += 1
		if config.AutoAnswer and engine.Retries < config.MaxRetries then
			engine.Start()
		end
	end
	function engine.NewMatch()
		engine.Cancel("New match / used-word history reset")
		engine.Used, engine.Attempted, engine.Submitted, engine.Tried =
			{}, {}, {}, {}
		engine.UsedCount, engine.Turns, engine.Retries = 0, 0, 0
	end
	function engine.Step()
		local plan = engine.Plan
		if not plan then
			return
		end
		if
			plan.Token ~= engine.Token
			or not localTurn()
			or not promptStillCurrent()
			or engine.Used[plan.Word]
			or engine.Submitted[plan.Word]
			or dictionary.Black[plan.Word]
			or (not plan.Manual and not config.AutoAnswer)
		then
			engine.Cancel(
				"Typing cancelled: turn, focus, settings or word changed"
			)
			return
		end
		local now = api.Clock()
		if now < plan.Next or now < nextSend then
			return
		end
		local actual = clean(api.Read(), 45)
		if actual ~= plan.Expected then
			if now - plan.SyncedAt > 0.6 then
				engine.Cancel(
					"Input changed or did not synchronize; stopped without more keystrokes"
				)
			end
			return
		end
		local action = plan.Actions[plan.Index]
		if action then
			api.Fire(
				"tryKeystroke",
				action.Value == -1 and -1 or action.Value:upper()
			)
			engine.Requests += 1
			plan.Expected = action.Value == -1 and plan.Expected:sub(1, -2)
				or plan.Expected .. action.Value
			plan.Index += 1
			plan.SyncedAt, nextSend = now, now + 1 / 30
			plan.Next = now
				+ (
					plan.Index > #plan.Actions
						and math.max(
							delayForKey(),
							config.Instant and 0 or config.AnswerDelay
						)
					or delayForKey()
				)
			engine.Status = "Typing "
				.. plan.Word
				.. " / "
				.. engine.EffectiveLength
		else
			-- Revalidate every repeat set immediately before the actual submit.
			if
				actual ~= plan.Word
				or engine.Used[actual]
				or engine.Submitted[actual]
			then
				engine.Cancel("Duplicate or changed answer blocked")
				return
			end
			engine.Submitted[actual], engine.Pending, engine.SubmittedAt =
				true, actual, now
			engine.Plan = nil
			engine.Status = "Submitted "
				.. actual
				.. " / awaiting server result"
			nextSend = now + 1 / 30
			api.Fire("tryAnswer")
			engine.Requests += 1
		end
	end
	return engine
end
