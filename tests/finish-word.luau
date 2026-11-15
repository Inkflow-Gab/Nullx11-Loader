-- Actual modules/controller against development IO doubles. No native Roblox,
-- executor getgc compatibility, server success, ranking or win claim.
-- @LIBRARY_FIXTURE
local environment = {}
local getgenv = function()
	return environment
end
local workspace = workspaceService
workspace.CurrentCamera = { CameraType = Enum.CameraType.Custom }
local deferred = {}
task.defer = function(callback)
	table.insert(deferred, callback)
end
local function flush()
	while #deferred > 0 do
		table.remove(deferred, 1)()
	end
end
-- @FTW_MODULES
-- @REAL_DATA
local dictionary = makeFinishWordDictionary()
assert(
	dictionary.Load(
		"ant\napple\nanchor\nanother\nalphabetical\naccumulations\nantidisestablishmentarianism\nbanana\nband\nxylophone\n"
	)
)
assert(dictionary.Count == 10)
assert(
	not dictionary.Clean("../evil")
		and not dictionary.Clean("abc123")
		and dictionary.Clean(" APPLE ") == "apple"
)
local options = { Length = "Short", Sort = "Shortest", Fallback = true }
local list, info = dictionary.Search("a", options, {}, {}, 12)
assert(list[1].Word == "ant" and info.Count == 7)
options.Length, options.Fallback = "Longer", false
list = dictionary.Search("a", options, {}, {}, 12)
assert(#list == 2 and dictionary.Category(list[1].Word) == "Longer")
options.Length = "Long"
list = dictionary.Search("xy", options, {}, {}, 12)
assert(#list == 1 and list[1].Word == "xylophone")
list = dictionary.Search(
	"xy",
	{ Length = "Short", Fallback = false },
	{},
	{},
	12
)
assert(#list == 0)
list, info = dictionary.Search(
	"xy",
	{ Length = "Short", Fallback = true },
	{},
	{},
	12
)
assert(#list == 1 and info.Fallback)
list = dictionary.Search(
	"a",
	{ Length = "Short", Fallback = true, Endings = "ple, nt" },
	{ apple = true },
	{},
	12
)
assert(list[1].Word == "ant")
dictionary.Edit("ant", "blacklist")
list = dictionary.Search("a", { Length = "Short", Fallback = true }, {}, {}, 12)
for _, item in ipairs(list) do
	assert(item.Word ~= "ant")
end
dictionary.Edit("ant", "unblack")
local cancelled = makeFinishWordDictionary()
assert(not cancelled.Load(string.rep("apple\n", 4001), "words", function()
	return false
end))
assert(
	cancelled.Count == 0,
	"cancelled parsing must not publish a partial dictionary"
)
local config = {
	AutoAnswer = true,
	Length = "Short",
	Fallback = true,
	Sort = "Shortest",
	PreferWhite = false,
	Endings = "",
	WpmMin = 60,
	WpmMax = 60,
	FixedDelay = false,
	TypeDelay = 0.1,
	HumanType = false,
	Instant = false,
	StartMin = 0,
	StartMax = 0,
	AnswerDelay = 0,
	MaxRetries = 6,
	Typos = false,
	TypoWarmup = 0,
	TypoSafeLen = 5,
	TypoChance = 3,
	ThinkCurve = false,
	ThinkDriver = "Difficulty",
	ThinkThreshold = 20,
	ThinkExtra = 1,
	ThinkCap = 3,
	ThinkShape = "Linear",
	AutoLearn = true,
	AutoBlacklist = false,
}
local owner, opponent = { UserId = 33 }, { UserId = 77 }
local now, text, live, focus, myTurn, cutscene, learned, sent, answers =
	0, "a", true, true, true, false, {}, {}, {}
local prompt = { RequiredLetter = "a" }
local model = makeFinishWordEngine({
	Player = owner,
	Alive = function()
		return live
	end,
	Attached = function()
		return true
	end,
	IsTurn = function()
		return myTurn
	end,
	Focused = function()
		return focus
	end,
	Clock = function()
		return now
	end,
	Random = function()
		return 0.5
	end,
	Prompt = function()
		return prompt
	end,
	Read = function()
		return text
	end,
	Learned = function(word)
		learned[word] = true
	end,
	Cutscene = function()
		return cutscene
	end,
	Fire = function(kind, value)
		table.insert(sent, { Kind = kind, Value = value, Time = now })
		if kind == "tryKeystroke" then
			text = value == -1 and text:sub(1, -2) or text .. value:lower()
		else
			table.insert(answers, text)
		end
	end,
}, dictionary, config)
local function finish()
	for _ = 1, 200 do
		now += 0.25
		model.Step()
		if not model.Plan then
			break
		end
	end
end
model.Round(prompt, owner)
assert(model.Plan and model.Plan.Word == "ant")
finish()
assert(answers[1] == "ant" and model.Pending == "ant" and model.Submitted.ant)
for index = 2, #sent do
	assert(sent[index].Time - sent[index - 1].Time >= 1 / 30)
end
model.Correct("ant")
assert(model.Used.ant and model.Accepted == 1 and learned.ant)
model.Round(prompt, opponent)
assert(not model.Plan)
model.Correct("anchor")
assert(model.Used.anchor, "opponents' accepted words must be excluded globally")
text = "a"
model.Round(prompt, owner)
assert(model.Plan.Word == "apple")
model.Cancel("length changed")
config.Length = "Auto"
assert(model.Used.ant and model.Attempted.apple)
assert(
	not model.Start("apple", true),
	"a word already started must not repeat after mode changes"
)
config.WpmMin = 30
assert(model.Length() == "Short")
config.WpmMin = 60
model.Turns = 0
assert(model.Length() == "Neutral")
model.Turns = 7
assert(model.Length() == "Long")
model.Turns = 16
assert(model.Length() == "Longer")
local candidates = model.Candidates("a", 100, true)
for _, item in ipairs(candidates) do
	assert(not model.Used[item.Word] and not model.Attempted[item.Word])
end
-- New turn/resume/STOP is not a new match. Only the source new-match signal
-- clears Used + Attempted + Submitted, not the dropdown or retry path.
model.NewMatch()
assert(not next(model.Used) and not next(model.Attempted))
config.Length = "Short"
text = "a"
model.Round(prompt, owner)
finish()
model.Strike(opponent.UserId, true)
assert(model.Pending == "ant")
model.Strike(owner.UserId, true)
assert(model.Used.ant and model.Retries == 1 and model.Plan.Word == "apple")
local retries = model.Retries
finish()
model.LastAttack = now
model.Strike(owner.UserId, false)
assert(
	model.Retries == retries and model.Pending,
	"pet/cutscene strike does not blacklist a valid word"
)
model.Cancel("stop")
assert(model.Attempted.ant and model.Attempted.apple)
model.NewMatch()
text = "a"
model.Round(prompt, owner)
local before = #sent
focus = false
now += 1
model.Step()
assert(not model.Plan and #sent == before)
focus = true
model.NewMatch()
text = "a"
model.Round(prompt, owner)
text = "manualedit"
now += 1
model.Step()
assert(
	not model.Plan and #sent == before,
	"unexpected manual input cancels without clearing the user's new text"
)
model.NewMatch()
text = "a"
model.Round(prompt, owner)
model.Correct("ant")
now += 1
model.Step()
assert(
	not model.Plan and #sent == before,
	"late accepted-word event invalidates the typing plan"
)
-- WPM and fixed delays are real per-key schedules, independent of the fast
-- mode and per-word start/submit delays. A hitch emits one action only.
model.NewMatch()
text = "a"
focus = true
config.FixedDelay, config.TypeDelay = true, 0.4
model.Round(prompt, owner)
local scheduledBefore = #sent
now += 0.01
model.Step()
assert(#sent == scheduledBefore + 1)
now += 0.1
model.Step()
assert(#sent == scheduledBefore + 1)
now += 5
model.Step()
assert(#sent == scheduledBefore + 2, "no hitch catch-up burst")
model.Cancel("timing test done")
config.FixedDelay, config.TypeDelay = false, 0.1
config.Endings, config.SuffixFallback = "zzzzzz", true
model.NewMatch()
text = "a"
model.Round(prompt, owner)
assert(
	model.Plan and model.Plan.Word,
	"source-style ending preference fallback is retained"
)
model.Cancel("strict suffix test")
config.SuffixFallback = false
model.NewMatch()
text = "a"
model.Round(prompt, owner)
assert(not model.Plan)
config.Endings, config.SuffixFallback = "", true
assert(
	not model.Start("bad123", true),
	"invalid manual input must not silently choose a different word"
)
-- Source-shaped live bridge and actual controller. Every executing LocalPlayer
-- gets their own identity/profile; no fixed author/test username is used.
local attributes = { IsTurn = true, InGame = true }
player.UserId, player.Name = 1502, "AnotherPlayer"
function player:GetAttribute(key)
	return attributes[key]
end
function player:GetAttributeChangedSignal(key)
	self.AttributeSignals = self.AttributeSignals or {}
	self.AttributeSignals[key] = self.AttributeSignals[key] or signal()
	return self.AttributeSignals[key]
end
player.Idled, inputService.WindowFocused = signal(), signal()
runService.Heartbeat = signal()
local gameText, gamePrompt, gcCalls, network, disconnected =
	"a", { RequiredLetter = "a" }, 0, {}, {}
local listeners, nextToken = {}, 0
local sourceBus = {
	ping = function() end,
	fire = function(kind, value)
		table.insert(network, { Kind = kind, Value = value, Time = clock })
		if kind == "tryKeystroke" then
			gameText = value == -1 and gameText:sub(1, -2)
				or gameText .. value:lower()
		end
	end,
	remoteFire = function(kind, value)
		table.insert(network, { Kind = kind, Value = value, Time = clock })
	end,
	remoteConnect = function(kind, callback)
		nextToken += 1
		listeners[nextToken] = { Kind = kind, Callback = callback }
		return nextToken
	end,
	disconnect = function(token)
		disconnected[token] = true
		listeners[token] = nil
	end,
}
local ui = {
	_Mounted = true,
	Instance = Instance.new("ScreenGui"),
	_Children = {
		TopBar = {
			_Children = {
				AnswerInput = {
					currentWord = function()
						return gameText
					end,
				},
			},
		},
		ChoiceList = {},
	},
}
ui.Instance.Parent = playerGui
ui._Properties = { Ui = ui, Prompt = gamePrompt, RoundEnded = false }
local afkConfig = { PET = {}, AFK = { Threshold = 120 } }
local gcSnapshot = { {}, sourceBus, ui, afkConfig }
local getgc = function()
	gcCalls += 1
	return gcSnapshot
end
local function emit(kind, ...)
	local snapshot = {}
	for token, listener in pairs(listeners) do
		snapshot[token] = listener
	end
	for token, listener in pairs(snapshot) do
		if listeners[token] and listener.Kind == kind then
			listener.Callback(...)
		end
	end
end
local disk, httpRequests = {}, {}
local writefile = function(path, value)
	disk[path] = value
end
local readfile = function(path)
	return assert(disk[path], "file missing")
end
game.HttpGet = function(_, url)
	table.insert(httpRequests, url)
	assert(
		url:find(
			"74dd400750d428e2bc76f0930a8d430055bfcb80/data/finish-word/",
			1,
			true
		),
		"only the owned pinned data path is fetched"
	)
	if url:find("frequency.txt", 1, true) then
		return fullFrequency
	end
	return fullWords
end
local lib = fixtureLibrary()
local context = makeSession("finishword", lib)
context.Patches, context.MakeFinishWordDictionary, context.MakeFinishWordBridge, context.MakeFinishWordEngine =
	makePatches(),
	makeFinishWordDictionary,
	makeFinishWordBridge,
	makeFinishWordEngine
context.FinishWordDataURL =
	"https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/74dd400750d428e2bc76f0930a8d430055bfcb80/data/finish-word/"
local function runController(context)
	-- @FTW_CONTROLLER
end
local result = runController(context)
assert(result.Nullx11Ready and #lib.Window.Tabs == 4)
assert(
	gcCalls == 0
		and #httpRequests == 0
		and #network == 0
		and not result.Config.AutoAnswer
		and not result.Config.AutoChoose
)
local function control(key, value)
	lib.Controls["FTW_" .. key]:SetValue(value)
end
local function button(caption)
	for _, control in ipairs(lib.Controls) do
		if control.Kind == "Button" and control.Spec.Text == caption then
			control.Spec.Func()
			return
		end
	end
	error("Missing actual button: " .. caption)
end
local function tick(dt)
	clock += dt
	runService.Heartbeat:Fire(dt)
end
button("1  Load full word data")
assert(#deferred == 1 and #httpRequests == 0)
flush()
assert(#httpRequests == 3 and result.Dictionary.Count == 138602)
assert(result.Dictionary.Words.xylophone and result.Dictionary.Words.zyuganov)
control("AutoAnswer", true)
assert(
	not result.Config.AutoAnswer,
	"missing attachment must roll back Auto answer"
)
button("2  Attach during a round")
button("Detach / stop game subscriptions")
flush()
assert(
	gcCalls == 0 and not result.Bridge.Attached,
	"cancelled deferred attach must not scan or subscribe"
)
tick(5.1)
button("2  Attach during a round")
assert(gcCalls == 0)
flush()
assert(
	gcCalls == 1 and result.Bridge.Attached and nextToken == 5 and #network == 0
)
control("Length", "Short")
control("Instant", true)
control("AutoAnswer", true)
assert(result.Engine.Plan and result.Engine.Plan.Word)
local ownWord = result.Engine.Plan.Word
for _ = 1, 160 do
	tick(0.04)
	if result.Engine.Pending then
		break
	end
end
assert(result.Engine.Pending == ownWord and gameText == ownWord)
local submits = 0
for _, event in ipairs(network) do
	if event.Kind == "tryAnswer" then
		submits += 1
	end
end
assert(submits == 1)
emit("correct", ownWord)
assert(result.Engine.Used[ownWord])
emit("correct", "anchor")
assert(result.Engine.Used.anchor and result.Dictionary.Manual.anchor)
tick(1.1)
assert(
	disk["Nullx11-FinishWord-1502.json"],
	"personal files are per executing UserId"
)
control("Length", "Longer")
control("WpmMin", 120)
assert(result.Engine.Used[ownWord] and result.Engine.Used.anchor)
gameText, gamePrompt = "a", { RequiredLetter = "a" }
ui._Properties.Prompt = gamePrompt
emit("updateRound", gamePrompt, nil, player)
assert(result.Engine.Plan and not result.Engine.Used[result.Engine.Plan.Word])
local startedWord = result.Engine.Plan.Word
button("STOP typing / preserve history")
assert(
	not result.Engine.Plan
		and result.Engine.Attempted[startedWord]
		and result.Engine.Used.anchor
)
local networkBefore = #network
for _ = 1, 20 do
	tick(0.1)
end
assert(#network == networkBefore)
-- Auto-choice is a separate opt-in; it does not type for other players.
control("AutoChoose", true)
local opponentPlayer = Instance.new("Player")
opponentPlayer.UserId = 999
local choices = { Choices = { "q", "a" } }
ui._Properties.Prompt = choices
emit("updateRound", choices, nil, opponentPlayer)
tick(0.1)
assert(#network == networkBefore)
emit("updateRound", choices, nil, player)
tick(0.1)
assert(
	network[#network].Kind == "chooseLetter" and network[#network].Value == "a"
)
local countAfterChoice = #network
control("Length", "Neutral")
control("WpmMin", 100)
tick(0.1)
assert(
	#network == countAfterChoice,
	"settings changes must not repeat a choice request"
)
-- Source event delivery can precede its IsTurn/UI update by a frame. One
-- guarded resume handles that ordering without clearing earlier word history.
attributes.IsTurn = false
control("AutoAnswer", true)
gameText, gamePrompt = "a", { RequiredLetter = "a" }
ui._Properties.Prompt = gamePrompt
emit("updateRound", gamePrompt, nil, player)
assert(not result.Engine.Plan and #deferred > 0)
attributes.IsTurn = true
flush()
assert(result.Engine.Plan and not result.Engine.Used[result.Engine.Plan.Word])
button("STOP typing / preserve history")
-- List edits do not resurrect a removed whitelist entry or clear used words.
control("WordEntry", "uniquepersonalword")
button("Whitelist word")
assert(result.Dictionary.Manual.uniquepersonalword)
button("Remove personal whitelist mark")
assert(not result.Dictionary.Manual.uniquepersonalword)
control("AntiAFK", true)
assert(afkConfig.AFK.Threshold == math.huge)
control("AntiAFK", false)
assert(afkConfig.AFK.Threshold == 120)
local ownCount = result.Engine.UsedCount
attributes.IsTurn = false
player:GetAttributeChangedSignal("IsTurn"):Fire()
assert(result.Engine.UsedCount == ownCount)
attributes.InGame = false
player:GetAttributeChangedSignal("InGame"):Fire()
assert(result.Engine.UsedCount == ownCount)
attributes.InGame = true
player:GetAttributeChangedSignal("InGame"):Fire()
assert(not next(result.Engine.Used) and not next(result.Engine.Attempted))
-- Detached source events and a late data response cannot revive a stopped game.
button("Load / reload owned word snapshot")
assert(#deferred > 0)
local loadedCount = #httpRequests
control("AntiAFK", true)
lib:Unload()
flush()
tick(1)
assert(
	not context.Alive
		and not result.Bridge.Attached
		and #httpRequests == loadedCount
		and afkConfig.AFK.Threshold == 120
)
assert(not next(listeners) and next(disconnected))
local finalNetwork = #network
emit("updateRound", gamePrompt, nil, player)
tick(1)
assert(#network == finalNetwork)
-- Rejected bus/mounted-game signatures never install protocol handlers.
local ambiguous = makeFinishWordBridge({
	Alive = function()
		return true
	end,
	GetGC = function()
		return { sourceBus, sourceBus, ui }
	end,
	PlayerGui = playerGui,
	Instance = function(v)
		return typeof(v) == "Instance"
	end,
	Yield = function() end,
})
assert(not pcall(ambiguous.Attach, {}))
assert(not ambiguous.Attached and #ambiguous.Tokens == 0)
local callbackBridge = makeFinishWordBridge({
	Alive = function()
		return true
	end,
	GetGC = function()
		return { sourceBus, ui }
	end,
	PlayerGui = playerGui,
	Instance = function(value)
		return typeof(value) == "Instance"
	end,
	Yield = function() end,
})
callbackBridge.Attach({
	Round = function()
		error("fixture event callback failure")
	end,
	Correct = function() end,
	Strike = function() end,
	Damage = function() end,
	Attack = function() end,
})
local callbackOK = pcall(emit, "updateRound", gamePrompt, nil, player)
assert(
	callbackOK
		and not callbackBridge.Attached
		and callbackBridge.LastError:find(
			"fixture event callback failure",
			1,
			true
		)
		and not next(listeners)
)
return "PASS: actual Finish The Word dictionary/bridge/engine/controller: complete 138,602-word pinned data, all five length modes, WPM/timing, authoritative all-player used words and match-wide started/submitted exclusions, no-repeat retries/settings/STOP, choice ownership, signature-only explicit discovery, lazy IO, per-user lists, reversible AFK, late-load cancellation and owned teardown (development APIs, not native/server/win proof)"
