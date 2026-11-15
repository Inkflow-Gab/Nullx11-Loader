-- Nullx11 Finish The Word / NULL edition. Based on Dave's supplied open-source
-- controller; original notices and complete dependency snapshots are retained.
-- See docs/FINISH-WORD-REVIEW.md. No vendor Lua or Discord RPC is executed.
local library = context.Library
local players, input, run, http =
	game:GetService("Players"),
	game:GetService("UserInputService"),
	game:GetService("RunService"),
	game:GetService("HttpService")
local player = players.LocalPlayer
local cfg = {
	AutoAnswer = false,
	AutoChoose = false,
	AutoLearn = true,
	AutoBlacklist = false,
	AntiAFK = false,
	ShakeHide = false,
	SpeedPreset = "Custom",
	Length = "Auto",
	Fallback = true,
	Sort = "Most common",
	PreferWhite = true,
	SuffixFallback = true,
	Endings = "",
	SuggestCount = 24,
	Instant = false,
	HumanType = true,
	FixedDelay = false,
	TypeDelay = 0.12,
	WpmMin = 45,
	WpmMax = 85,
	StartMin = 0.3,
	StartMax = 0.9,
	AnswerDelay = 0.5,
	MaxRetries = 6,
	Typos = false,
	TypoChance = 3,
	TypoWarmup = 3,
	TypoSafeLen = 5,
	ThinkCurve = false,
	ThinkDriver = "Difficulty",
	ThinkShape = "Linear",
	ThinkThreshold = 20,
	ThinkExtra = 1.5,
	ThinkCap = 3.5,
}
local focused, busy, loadGeneration, attachGeneration, nextAttach, dirty, saveAt =
	true, false, 0, 0, 0, true, nil
local manualPrefix, entry, selected, page, items, choiceToken =
	"", "", nil, 1, {}, nil
local dictionary = context.MakeFinishWordDictionary()
local patches = context.Patches
local bridge = context.MakeFinishWordBridge({
	PlayerGui = player:WaitForChild("PlayerGui"),
	GetGC = getgc,
	Alive = function()
		return context.Alive
	end,
	Instance = function(value)
		return typeof(value) == "Instance"
	end,
	Yield = function()
		task.wait()
	end,
})
local profile = "Nullx11-FinishWord-" .. tostring(player.UserId) .. ".json"
local controls, rows = {}, {}
local statusText, dataText =
	"Load word data, then attach during a round",
	"138,602-word source snapshot available / not loaded"
local engine
local wordsReady = false
local choiceRound, nextProtocolAt = 0, 0
local function safeFocus()
	return focused and not input:GetFocusedTextBox()
end
local function learned(word)
	-- Only learned/manual personal entries are persisted, never the entire base
	-- whitelist, a username directory scan, executable configs or a shared global.
	if not dictionary.Black[word] then
		dictionary.Manual[word] = true
	end
	saveAt = os.clock() + 1
	dirty = true
end
engine = context.MakeFinishWordEngine({
	Player = player,
	Alive = function()
		return context.Alive
	end,
	Attached = function()
		return bridge.Attached
	end,
	IsTurn = function()
		return player:GetAttribute("IsTurn") == true
	end,
	Focused = safeFocus,
	Clock = os.clock,
	Random = math.random,
	Prompt = bridge.Prompt,
	Read = bridge.Read,
	Fire = bridge.Fire,
	Learned = learned,
	Cutscene = function()
		local camera = workspace.CurrentCamera
		return camera and camera.CameraType == Enum.CameraType.Scriptable
	end,
}, dictionary, cfg)
local window = library:CreateWindow({
	Title = "Nullx11",
	SubTitle = "Finish The Word / NULL",
	Theme = "Nullx11",
	Intro = false,
	Watermark = false,
	MenuKey = Enum.KeyCode.LeftControl,
	ConfigFolder = "Nullx11 FinishWord",
})
local play = window:AddTab(
	"Play",
	"keyboard",
	"Live prompt, unused suggestions and explicit control"
)
local typing = window:AddTab(
	"Typing",
	"activity",
	"Speed, timing and optional typing effects"
)
local words = window:AddTab(
	"Word library",
	"book",
	"Owned data, endings and personal lists"
)
local session = window:AddTab(
	"Session",
	"settings",
	"Connection, profiles, source and cleanup"
)
local live = play:AddLeftGroupbox("Round workspace")
local status =
	live:AddParagraph({ Title = "Ready when you are", Content = statusText })
local summary = live:AddParagraph({
	Title = "Round state",
	Content = "No attached round / Auto length",
})
local suggestions = play:AddRightGroupbox("Unused words / tap to select")
local selection = suggestions:AddParagraph({
	Title = "Selected word",
	Content = "Choose a word, then Type selected",
})
local listInfo = suggestions:AddParagraph({
	Title = "Available words",
	Content = "No suggestions yet",
})
local dataBox = words:AddLeftGroupbox("Word data")
local dataLabel = dataBox:AddParagraph({
	Title = "Pinned, data-only source snapshot",
	Content = dataText,
})
local function report(text)
	statusText = tostring(text)
	engine.Status = statusText
	status:SetContent(statusText)
end
local function guard(callback)
	local ok, result = pcall(callback)
	if not ok then
		engine.Cancel(tostring(result))
		report(result)
	end
	return ok, result
end
local function saveLists()
	assert(
		type(writefile) == "function",
		"Executor writefile is unavailable; lists remain usable in memory"
	)
	local white, black = {}, {}
	for word in pairs(dictionary.Manual) do
		if #white < 1500 then
			table.insert(white, word)
		end
	end
	for word in pairs(dictionary.Black) do
		if #black < 1500 then
			table.insert(black, word)
		end
	end
	table.sort(white)
	table.sort(black)
	local text = http:JSONEncode({ Version = 1, White = white, Black = black })
	assert(#text <= 65536, "Personal word lists exceed 64 KiB")
	writefile(profile, text)
end
local function loadLists()
	assert(type(readfile) == "function", "Executor readfile unavailable")
	local text = readfile(profile)
	assert(
		type(text) == "string" and #text <= 65536,
		"Invalid or oversized personal lists"
	)
	local saved = http:JSONDecode(text)
	assert(
		type(saved) == "table"
			and saved.Version == 1
			and type(saved.White) == "table"
			and type(saved.Black) == "table",
		"Unsupported personal-list format"
	)
	for _, kind in ipairs({ "White", "Black" }) do
		for index, value in ipairs(saved[kind]) do
			if index > 1500 then
				break
			end
			local word = dictionary.Clean(value)
			if word then
				dictionary.Edit(
					word,
					kind == "White" and "whitelist" or "blacklist"
				)
			end
		end
	end
	dirty = true
end
local function stop()
	cfg.AutoAnswer, cfg.AutoChoose, cfg.AntiAFK, cfg.ShakeHide =
		false, false, false, false
	for _, name in ipairs({ "AutoAnswer", "AutoChoose", "AntiAFK", "ShakeHide" }) do
		if controls[name] then
			controls[name]:SetValue(false)
		end
	end
	engine.Cancel("Stopped / match-wide used and attempted words preserved")
	patches.Clear()
	dirty = true
end
context.RegisterCleanup(function()
	loadGeneration += 1
	attachGeneration += 1
	engine.Cancel("Unloaded")
	bridge.Detach()
	patches.Clear()
end)
local function number(box, key, caption, minimum, maximum, rounding)
	controls[key] = box:AddSlider("FTW_" .. key, {
		Text = caption,
		Min = minimum,
		Max = maximum,
		Default = cfg[key],
		Rounding = rounding or 0,
		Callback = function(value)
			value = tonumber(value)
			if
				value
				and value == value
				and value >= minimum
				and value <= maximum
			then
				cfg[key] = value
				engine.Cancel("Timing changed; resume explicitly")
				dirty = true
			end
		end,
	})
end
local function toggle(box, key, caption, callback)
	controls[key] = box:AddToggle("FTW_" .. key, {
		Text = caption,
		Default = cfg[key],
		NoSave = key == "AutoAnswer"
			or key == "AutoChoose"
			or key == "AntiAFK"
			or key == "ShakeHide",
		Callback = function(value)
			cfg[key] = value == true
			if callback then
				local ok, why = guard(function()
					callback(cfg[key])
				end)
				if not ok and cfg[key] then
					cfg[key] = false
					if controls[key] then
						controls[key]:SetValue(false)
					end
					engine.Cancel(tostring(why))
					report(why)
				end
			end
			dirty = true
		end,
	})
end
local function dropdown(box, key, caption, values)
	controls[key] = box:AddDropdown("FTW_" .. key, {
		Text = caption,
		Default = cfg[key],
		Values = values,
		Callback = function(value)
			if table.find(values, value) then
				cfg[key] = value
				engine.Cancel(
					"Selection settings changed; used-word history preserved"
				)
				selected, page, dirty = nil, 1, true
			end
		end,
	})
end
local function resume()
	assert(bridge.Attached, "Attach to the active game first")
	local prompt = bridge.Prompt()
	assert(
		prompt,
		"Gameplay UI is no longer mounted; attach again during a round"
	)
	-- Refresh the local context without clearing attempts, match words or retry
	-- count. updateRound alone defines a genuinely new turn.
	if player:GetAttribute("IsTurn") then
		engine.Turn, engine.Prefix, engine.Choices =
			player, dictionary.Clean(prompt.RequiredLetter, 16), prompt.Choices
		if
			not engine.Plan
			and not engine.Pending
			and cfg.AutoAnswer
			and engine.Prefix
		then
			local ok, reason = engine.Start()
			if not ok then
				report(reason)
			end
		end
	end
	dirty = true
end
local function round(prompt, turn)
	choiceRound += 1
	engine.Round(prompt, turn)
	selected, page, choiceToken, dirty = nil, 1, nil, true
	if
		turn == player
		and cfg.AutoAnswer
		and engine.Prefix
		and not engine.Plan
	then
		local token, roundId = engine.Token, choiceRound
		task.defer(function()
			task.wait() -- source also waits a frame for its gameplay props/input
			if
				context.Alive
				and cfg.AutoAnswer
				and bridge.Attached
				and engine.Token == token
				and choiceRound == roundId
				and not engine.Plan
				and not engine.Pending
			then
				guard(resume)
			end
		end)
	end
end
local function attach()
	assert(os.clock() >= nextAttach, "Wait before scanning again")
	nextAttach = os.clock() + 5
	stop()
	attachGeneration += 1
	local token = attachGeneration
	report("Explicit discovery / up to 100,000 GC values; no automatic rescans")
	task.defer(function()
		if not context.Alive or token ~= attachGeneration then
			return
		end
		local ok, reason = pcall(bridge.Attach, {
			Round = round,
			Correct = function(word)
				engine.Correct(word)
				if selected and engine.Used[selected] then
					selected = nil
				end
				dirty = true
			end,
			Strike = function(uid, alreadyUsed)
				engine.Strike(uid, alreadyUsed)
				dirty = true
			end,
			Damage = function(uid)
				if uid == player.UserId then
					engine.Cancel("Damage / turn action cancelled")
					dirty = true
				end
			end,
			Attack = function()
				engine.LastAttack = os.clock()
			end,
		})
		if not context.Alive or token ~= attachGeneration then
			return
		end
		if ok and bridge.Attached then
			guard(resume)
			report(
				"Source event/gameplay signatures attached / automation remains off"
			)
		else
			bridge.Detach()
			report(reason)
		end
		dirty = true
	end)
end
local function downloadData()
	assert(not busy, "A word-data load is already running")
	busy = true
	loadGeneration += 1
	local generation = loadGeneration
	engine.Cancel("Loading word data")
	dataLabel:SetContent(
		"Loading the complete pinned repository snapshot as text, not Lua"
	)
	task.defer(function()
		local ok, reason = pcall(function()
			local current = function()
				return context.Alive and loadGeneration == generation
			end
			local staged = context.MakeFinishWordDictionary()
			for _, file in ipairs({
				{ "words.txt", "words" },
				{ "whitelist.txt", "whitelist" },
				{ "frequency.txt", "frequency" },
			}) do
				if not current() then
					return
				end
				local source =
					game:HttpGet(context.FinishWordDataURL .. file[1], true)
				if not current() then
					return
				end
				assert(
					staged.Load(source, file[2], current, function()
						task.wait()
					end),
					"Data load cancelled"
				)
			end
			assert(
				staged.Count == 138602,
				"Pinned base word count did not match the captured source"
			)
			if not current() then
				return
			end
			for word in pairs(dictionary.Manual) do
				staged.Edit(word, "whitelist")
			end
			for word in pairs(dictionary.Black) do
				staged.Edit(word, "blacklist")
			end
			-- Keep object identity: the live engine and UI share this dictionary.
			for key, value in pairs(staged) do
				if type(value) ~= "function" then
					dictionary[key] = value
				end
			end
			dataText = string.format(
				"%d words / complete pinned list + whitelist + frequency / no vendor Lua",
				dictionary.Count
			)
			wordsReady = true
			dataLabel:SetContent(dataText)
			engine.Cancel("Word data ready / attach or resume explicitly")
		end)
		if context.Alive and generation == loadGeneration then
			busy = false
			if not ok then
				dataLabel:SetContent("Data load failed: " .. tostring(reason))
				report(reason)
			end
			dirty = true
		end
	end)
end
live:AddButton({
	Text = "1  Load full word data",
	Style = "Primary",
	Func = function()
		guard(downloadData)
	end,
})
live:AddButton({
	Text = "2  Attach during a round",
	Func = function()
		guard(attach)
	end,
})
toggle(live, "AutoAnswer", "Auto answer / your turn only", function(value)
	if value then
		assert(wordsReady, "Load the complete word data first")
		resume()
	else
		engine.Cancel("Auto answer off / repeat history retained")
	end
end)
toggle(
	live,
	"AutoChoose",
	"Auto pick the richest letter choice",
	function(value)
		if value then
			assert(bridge.Attached and wordsReady, "Load data and attach first")
		end
	end
)
dropdown(
	live,
	"Length",
	"Word length",
	{ "Auto", "Short", "Neutral", "Long", "Longer" }
)
toggle(live, "Fallback", "Allow nearest length if the band is exhausted")
live:AddParagraph({
	Title = "Length guide",
	Content = "Short: 1–5; Neutral: 6–8; Long: 9–12; Longer: 13+ letters. Auto adapts to typing speed and match progress. Used and attempted words remain excluded across retries, length changes and STOP. History resets only for a new match.",
})
live:AddButton({
	Text = "Resume this turn",
	Func = function()
		guard(resume)
	end,
})
live:AddButton({
	Text = "STOP typing / preserve history",
	Style = "Danger",
	Func = stop,
})
for index = 1, 12 do
	local rowIndex = index
	rows[index] = suggestions:AddButton({
		Text = "—",
		Func = function()
			local item = items[(page - 1) * 12 + rowIndex]
			if
				item
				and not engine.Used[item.Word]
				and not engine.Attempted[item.Word]
			then
				selected = item.Word
				selection:SetContent(
					"Selected: "
						.. selected
						.. " / "
						.. dictionary.Category(selected)
				)
			else
				selected = nil
			end
		end,
	})
	if rows[index].SetVisible then
		rows[index]:SetVisible(false)
	end
end
suggestions:AddButton({
	Text = "Previous suggestions",
	Func = function()
		page = math.max(1, page - 1)
		dirty = true
	end,
})
suggestions:AddButton({
	Text = "Next suggestions",
	Func = function()
		page = math.min(math.max(1, math.ceil(#items / 12)), page + 1)
		dirty = true
	end,
})
suggestions:AddButton({
	Text = "Type selected / explicit",
	Style = "Primary",
	Func = function()
		guard(function()
			assert(wordsReady, "Load the complete word data first")
			assert(selected, "Select a suggestion first")
			local ok, reason = engine.Start(selected, true)
			assert(ok, reason)
			selected, dirty = nil, true
		end)
	end,
})
local speed = typing:AddLeftGroupbox("Typing speed")
dropdown(
	speed,
	"SpeedPreset",
	"Timing preset",
	{ "Custom", "Off", "Light", "Realistic", "Paranoid" }
)
-- Set the dropdown's real initial value; applying a preset is explicit and never
-- starts automation. Source names describe timing styles, not evasion guarantees.
controls.SpeedPreset:SetValue("Custom")
number(speed, "WpmMin", "Minimum WPM", 20, 240)
number(speed, "WpmMax", "Maximum WPM", 20, 240)
toggle(speed, "FixedDelay", "Use fixed seconds per character")
number(speed, "TypeDelay", "Fixed delay / seconds", 0.04, 0.8, 2)
toggle(speed, "HumanType", "Small per-character timing variation")
toggle(speed, "Instant", "Fast mode / still capped at 30 actions per second")
number(speed, "StartMin", "Wait before typing / minimum seconds", 0, 5, 2)
number(speed, "StartMax", "Wait before typing / maximum seconds", 0, 5, 2)
number(speed, "AnswerDelay", "Wait before submit / seconds", 0, 5, 2)
number(speed, "MaxRetries", "Maximum attempts per turn", 1, 20)
speed:AddButton({
	Text = "Apply selected timing preset",
	Func = function()
		local preset = cfg.SpeedPreset
		if preset == "Off" then
			controls.FixedDelay:SetValue(true)
			controls.Typos:SetValue(false)
			controls.ThinkCurve:SetValue(false)
			return
		end
		local values = preset == "Light" and { 70, 110, 0.2, 0.5 }
			or preset == "Realistic" and { 45, 85, 0.3, 0.9 }
			or preset == "Paranoid" and { 35, 70, 0.6, 1.6 }
		if values then
			controls.FixedDelay:SetValue(false)
			controls.WpmMin:SetValue(values[1])
			controls.WpmMax:SetValue(values[2])
			controls.StartMin:SetValue(values[3])
			controls.StartMax:SetValue(values[4])
			controls.Typos:SetValue(preset ~= "Light")
			controls.ThinkCurve:SetValue(preset ~= "Light")
		end
	end,
})
local effects = typing:AddRightGroupbox("Optional typing effects")
toggle(effects, "Typos", "Insert and correct occasional neighboring-key typos")
number(effects, "TypoChance", "Typo probability / percent", 0.1, 30, 1)
number(effects, "TypoWarmup", "Accepted words before typos", 0, 20)
number(effects, "TypoSafeLen", "No typos at or below this length", 1, 12)
toggle(effects, "ThinkCurve", "Increase thinking delay with difficulty")
dropdown(
	effects,
	"ThinkDriver",
	"Thinking driver",
	{ "Difficulty", "Words used", "Turn number" }
)
dropdown(effects, "ThinkShape", "Thinking curve", { "Linear", "Exp", "Log" })
number(effects, "ThinkThreshold", "Thinking threshold", 0, 60)
number(effects, "ThinkExtra", "Additional thinking / seconds", 0, 6, 1)
number(effects, "ThinkCap", "Maximum thinking / seconds", 0.5, 10, 1)
effects:AddParagraph({
	Title = "Precise speed, not an evasion claim",
	Content = "WPM uses five characters per word. Real delays include start/submit waits and optional typo correction. One action per heartbeat, maximum 30/s; a frame hitch never causes a burst. Focus loss or turn changes cancel the typing plan.",
})
dataBox:AddButton({
	Text = "Load / reload owned word snapshot",
	Func = function()
		guard(downloadData)
	end,
})
dataBox:AddInput("FTW_ManualPrefix", {
	Text = "Preview any prefix / suggestions only",
	Default = "",
	Finished = true,
	NoSave = true,
	Callback = function(text)
		manualPrefix = dictionary.Clean(text, 16) or ""
		page, selected, dirty = 1, nil, true
	end,
})
dropdown(
	dataBox,
	"Sort",
	"Suggestion order within the length band",
	{ "Shortest", "Longest", "a-Z", "Z-a", "Most common" }
)
toggle(dataBox, "PreferWhite", "Prioritize whitelisted words")
toggle(
	dataBox,
	"SuffixFallback",
	"Use other endings when preferred endings are exhausted"
)
number(dataBox, "SuggestCount", "Suggestion pool / paged 12 at a time", 12, 100)
controls.Endings = dataBox:AddInput("FTW_Endings", {
	Text = "Preferred endings / priority order",
	Placeholder = "x, ns, y",
	Default = "",
	Finished = true,
	Callback = function(text)
		cfg.Endings = tostring(text):sub(1, 128)
		engine.Cancel("Endings changed / repeat history retained")
		page, dirty = 1, true
	end,
})
dataBox:AddButton({
	Text = "Clear ending filters",
	Func = function()
		controls.Endings:SetValue("")
	end,
})
local personal = words:AddRightGroupbox("Personal word lists")
personal:AddInput("FTW_WordEntry", {
	Text = "Single alphabetic word",
	Default = "",
	NoSave = true,
	Finished = true,
	Callback = function(text)
		entry = text
	end,
})
for _, action in ipairs({
	{ "Whitelist word", "whitelist" },
	{ "Remove personal whitelist mark", "unwhite" },
	{ "Blacklist word", "blacklist" },
	{ "Remove blacklist mark", "unblack" },
}) do
	personal:AddButton({
		Text = action[1],
		Func = function()
			guard(function()
				local word = dictionary.Edit(entry, action[2])
				engine.Cancel("Personal word list changed")
				saveAt, dirty = os.clock() + 1, true
				report(action[1] .. ": " .. word)
			end)
		end,
	})
end
toggle(personal, "AutoLearn", "Learn globally accepted words / all players")
toggle(
	personal,
	"AutoBlacklist",
	"Learn recent rejected answers / optional heuristic"
)
personal:AddButton({
	Text = "Save my lists",
	Func = function()
		guard(saveLists)
	end,
})
personal:AddButton({
	Text = "Load my lists",
	Func = function()
		guard(loadLists)
	end,
})
personal:AddParagraph({
	Title = "Account-independent, match-aware",
	Content = "Uses the executing LocalPlayer, not a fixed username. Personal files use that player's UserId. Accepted words from all players and this instance's started words are blocked. Words used before attachment are unknown until reported by the game; already-used strikes add them to the match set. No way to control another player's input is installed.",
})
local tools = session:AddLeftGroupbox("Session control")
tools:AddButton({
	Text = "Detach / stop game subscriptions",
	Func = function()
		stop()
		attachGeneration += 1
		bridge.Detach()
		report("Detached / used-word history kept")
	end,
})
tools:AddButton({
	Text = "Unload Finish The Word only",
	Func = function()
		library:Unload()
	end,
})
toggle(
	tools,
	"AntiAFK",
	"Anti-AFK / owned source threshold + idle jump",
	function(value)
		if value then
			local gameConfig = bridge.Config()
			assert(
				bridge.Attached and gameConfig and gameConfig.AFK,
				"Attach first; the source AFK configuration was not found"
			)
			patches.Write("ftw-afk", gameConfig.AFK, "Threshold", math.huge)
		else
			patches.Restore("ftw-afk")
		end
	end
)
toggle(tools, "ShakeHide", "Shake phone twice to hide / restore")
tools:AddButton({
	Text = "Save timing / interface profile",
	Func = function()
		guard(function()
			local ok, reason = library:SaveConfig("finish-word")
			assert(ok, reason)
		end)
	end,
})
tools:AddButton({
	Text = "Load profile / automation stays off",
	Func = function()
		stop()
		guard(function()
			local ok, reason = library:LoadConfig("finish-word")
			assert(ok, reason)
		end)
	end,
})
tools:AddParagraph({
	Title = "No forced dependencies",
	Content = "The full dictionary, whitelist and frequency files are mirrored as pinned text data. Obsidian UI, SaveManager, warning card and nested icon source are archived, not executed. No identity escalation, executor branding gate, Discord localhost probing, automatic teleport or executable cache. Shared Nullx11 UI/dock replaces vendor UI.",
})
local credits = session:AddRightGroupbox("Source / manual server actions")
credits:AddParagraph({
	Title = "Nullx11 edition / NULL",
	Content = "Original Finish The Word controller: Dave / ancestrychanged.com. Original header: open sourced 10/10/2026; enjoy; please don't skid. Adapted protocol, word selection, learning and timing; original contributions are not claimed as newly authored. Complete inputs and dependency audit: docs/FINISH-WORD-REVIEW.md.",
})
local confirmServer = false
local serverConsent = credits:AddToggle("FTW_ConfirmTeleport", {
	Text = "Allow the next manual server action",
	Default = false,
	NoSave = true,
	Callback = function(value)
		confirmServer = value == true
	end,
})
local function consumeServerConsent()
	assert(confirmServer, "Confirm the manual server action first")
	confirmServer = false
	serverConsent:SetValue(false)
	stop()
end
credits:AddButton({
	Text = "Rejoin this place / manual",
	Func = function()
		guard(function()
			consumeServerConsent()
			game:GetService("TeleportService")
				:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
		end)
	end,
})
credits:AddButton({
	Text = "Find another public server / manual",
	Func = function()
		guard(function()
			consumeServerConsent()
			local source = game:HttpGet(
				"https://games.roblox.com/v1/games/"
					.. tostring(game.PlaceId)
					.. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
			)
			assert(
				type(source) == "string" and #source <= 262144,
				"Invalid server response"
			)
			assert(context.Alive, "Session unloaded while finding a server")
			local data = http:JSONDecode(source)
			assert(
				type(data) == "table" and type(data.data) == "table",
				"No public server data"
			)
			for index, server in ipairs(data.data) do
				if index > 100 then
					break
				end
				if
					type(server) == "table"
					and type(server.id) == "string"
					and #server.id <= 64
					and server.id ~= game.JobId
					and tonumber(server.playing)
					and tonumber(server.maxPlayers)
					and tonumber(server.playing)
						< tonumber(server.maxPlayers)
				then
					game:GetService("TeleportService")
						:TeleportToPlaceInstance(
							game.PlaceId,
							server.id,
							player
						)
					return
				end
			end
			error("No other available public server returned")
		end)
	end,
})
local function refresh()
	local prefix = manualPrefix ~= "" and manualPrefix or engine.Prefix
	if prefix then
		local info
		items, info = engine.Candidates(prefix, cfg.SuggestCount, false)
		page = math.min(page, math.max(1, math.ceil(#items / 12)))
		listInfo:SetContent(
			string.format(
				"%s / %d unused matches%s / page %d",
				prefix:upper(),
				info.Count,
				(info.Fallback or info.EndingsFallback)
						and " / preference fallback"
					or "",
				page
			)
		)
	else
		items = {}
		listInfo:SetContent(
			engine.Choices
					and "A choice round is active / auto-choice is optional"
				or "Waiting for a round or manual preview prefix"
		)
	end
	for index, row in ipairs(rows) do
		local item = items[(page - 1) * 12 + index]
		if item then
			row:SetText(
				string.format(
					"%s  /  %d letters%s",
					item.Word,
					#item.Word,
					item.White and "  ✓" or ""
				)
			)
		end
		if row.SetVisible then
			row:SetVisible(item ~= nil)
		end
	end
	summary:SetContent(
		string.format(
			"%s / length %s → %s / %d used / %d submissions accepted",
			bridge.Attached and "Attached" or "Detached",
			cfg.Length,
			engine.Length(),
			engine.UsedCount or 0,
			engine.Accepted
		)
	)
	selection:SetContent(
		selected and "Selected: " .. selected
			or "Tap a word to select; selection alone never types"
	)
	dirty = false
end
local elapsed, displayed, lastShake, spikeStart, spikes =
	0, "", -math.huge, 0, 0
context.Connect(run.Heartbeat, function(delta)
	if bridge.LastError then
		local reason = bridge.LastError
		bridge.LastError = nil
		stop()
		report("Game callback stopped: " .. reason)
	end
	local ok, reason = pcall(function()
		local beforeRequests = engine.Requests
		if engine.Plan and os.clock() >= nextProtocolAt then
			engine.Step()
		end
		if engine.Requests ~= beforeRequests then
			nextProtocolAt = os.clock() + 1 / 30
		end
		if
			cfg.AutoChoose
			and bridge.Attached
			and engine.Turn == player
			and player:GetAttribute("IsTurn")
			and safeFocus()
			and type(engine.Choices) == "table"
			and choiceToken ~= choiceRound
			and engine.Requests == beforeRequests
			and os.clock() >= nextProtocolAt
		then
			local best, most = nil, -1
			local count = 0
			for _, value in pairs(engine.Choices) do
				count += 1
				if count > 26 then
					break
				end
				local prefix = dictionary.Clean(tostring(value), 16)
				if prefix then
					local _, info = engine.Candidates(prefix, 1, false, true)
					if info.Count > most then
						best, most = prefix, info.Count
					end
				end
			end
			if best then
				choiceToken = choiceRound
				nextProtocolAt = os.clock() + 1 / 30
				bridge.Choose(best)
				engine.Status = "Requested choice "
					.. best:upper()
					.. " / "
					.. most
					.. " unused options"
			end
		end
	end)
	if not ok then
		stop()
		report(reason)
	end
	if saveAt and os.clock() >= saveAt then
		saveAt = nil
		if type(writefile) == "function" then
			local saved, why = pcall(saveLists)
			if not saved then
				report("List save failed: " .. tostring(why))
			end
		end
	end
	elapsed += delta
	if elapsed >= 0.2 then
		elapsed = 0
		if engine.Status ~= displayed then
			displayed = engine.Status
			status:SetContent(engine.Status)
		end
		if dirty then
			refresh()
		end
	end
end)
context.Connect(input.WindowFocusReleased, function()
	focused = false
	engine.Cancel("Focus lost / no further typing")
	dirty = true
end)
context.Connect(input.WindowFocused, function()
	focused = true
end)
context.Connect(input.InputBegan, function(event, processed)
	if
		not processed
		and not input:GetFocusedTextBox()
		and event.KeyCode == Enum.KeyCode.F7
	then
		stop()
	end
end)
context.Connect(player:GetAttributeChangedSignal("InGame"), function()
	if player:GetAttribute("InGame") == true then
		engine.NewMatch()
		choiceRound += 1
		choiceToken, selected, dirty = nil, nil, true
	end
end)
context.Connect(player:GetAttributeChangedSignal("IsTurn"), function()
	if not player:GetAttribute("IsTurn") then
		engine.Cancel("Your turn ended")
		dirty = true
	elseif cfg.AutoAnswer and bridge.Attached and dictionary.Count > 0 then
		task.defer(function()
			if context.Alive and cfg.AutoAnswer and bridge.Attached then
				guard(resume)
			end
		end)
	end
end)
context.Connect(player.Idled, function()
	if cfg.AntiAFK then
		local hum = player.Character
			and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Jump = true
		end
	end
end)
if input.DeviceAccelerationChanged then
	context.Connect(input.DeviceAccelerationChanged, function(event)
		if
			not cfg.ShakeHide
			or os.clock() - lastShake < 1
			or event.Position.Magnitude < 3.5
		then
			return
		end
		local now = os.clock()
		if now - spikeStart > 0.6 then
			spikes, spikeStart = 0, now
		end
		spikes += 1
		if spikes >= 2 then
			spikes, lastShake = 0, now
			library:Toggle()
		end
	end)
end
refresh()
return {
	Nullx11Ready = true,
	Window = window,
	Engine = engine,
	Dictionary = dictionary,
	Config = cfg,
	Bridge = bridge,
}
