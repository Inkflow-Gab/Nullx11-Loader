-- Development-only contracts for the actual recovered core, not a Roblox
-- emulator, full VM recovery, rendered screenshot, or server acceptance proof.
local V = {}
V.__index = function(self, key)
	if key == "Magnitude" then
		return math.sqrt(self.X ^ 2 + self.Y ^ 2 + self.Z ^ 2)
	end
	return V[key]
end
V.__sub = function(a, b)
	return setmetatable({ X = a.X - b.X, Y = a.Y - b.Y, Z = a.Z - b.Z }, V)
end
local Vector3 = {
	new = function(x, y, z)
		return setmetatable({ X = x, Y = y, Z = z }, V)
	end,
}
local CFrame = {
	new = function(position)
		return { Tag = "CFrame", Position = position }
	end,
}
local typeof = function(value)
	return type(value) == "table" and value.Tag or type(value)
end
local Vector2 = {
	new = function(x, y)
		return { X = x, Y = y }
	end,
}
local UDim2 = {
	fromOffset = function(x, y)
		return { X = x, Y = y }
	end,
}
local Color3 = {
	fromRGB = function(...)
		return { ... }
	end,
}
Enum.Font = { GothamMedium = "GothamMedium" }
local made = {}
local Instance = {
	new = function(class)
		local object = { ClassName = class }
		function object:Destroy()
			self.Destroyed = true
		end
		table.insert(made, object)
		return object
	end,
}
local function node(class, children)
	local object = { ClassName = class, Children = children or {} }
	function object:FindFirstChild(name)
		return self.Children[name]
	end
	function object:FindFirstChildOfClass(name)
		for _, child in pairs(self.Children) do
			if child.ClassName == name then
				return child
			end
		end
	end
	function object:IsA(name)
		return self.ClassName == name
	end
	return object
end
local frame = newSignal()
local humanoid = { ClassName = "Humanoid", Health = 100 }
local root = {
	ClassName = "Part",
	Position = Vector3.new(0, 0, 0),
	CFrame = CFrame.new(Vector3.new(0, 0, 0)),
}
local player = {
	UserId = 7,
	Character = node("Model", { Humanoid = humanoid, HumanoidRootPart = root }),
}
local record = {
	Uid = "real-egg",
	AssetCategory = "TestEgg",
	AssetScale = 2,
	BottomCFrame = CFrame.new(Vector3.new(4, 0, 0)),
	State = "Slot",
}
local dataAssets = {
	Directory = {
		TestEgg = {
			DisplayName = "Test Egg",
			EarningRate = 10,
			Rarity = {
				Rank = 4,
			},
		},
	},
}
local requests, moduleReads = {}, 0
local modules = {}
local carryBlocked = false
modules["Client.EggState"] = {
	ReadFieldEggs = function()
		return { Records = { record } }
	end,
	CarryFieldEgg = function(uid)
		table.insert(requests, { Name = "Carry", Uid = uid, Time = now })
		while carryBlocked do
			coroutine.yield()
		end
		return false, "server refused fixture request"
	end,
	DropFieldEgg = function(reason)
		table.insert(requests, { Name = "Drop", Reason = reason, Time = now })
		return false
	end,
}
modules["Data.Assets"] = dataAssets
modules["Shared.Modules.Mutations"] = {
	EarningsFor = function()
		return 3
	end,
}
local save = {
	Money = 100,
	BaseUpgradeLevel = 1,
	TreadmillUpgradeLevel = 0,
	Index = { TestEgg = true },
	IndexClaimedCategories = {},
}
modules["Shared.Save"] = {
	Peek = function()
		return save
	end,
}
modules["Data.Bases"] = {
	BASES = { { Cost = 0 }, { Cost = 50 } },
	GetMaxBaseLevel = function()
		return 2
	end,
}
modules["Data.Treadmills"] = {
	GetByUpgradeLevel = function(level)
		assert(level == 1)
		return { _id = "tread-1", Price = 30 }
	end,
}
modules["Data.Trails"] = {
	Directory = {
		Cheap = { _id = "cheap", Price = 10 },
		Expensive = { _id = "expensive", Price = 90 },
	},
}
local storage = node("ReplicatedStorage")
for path in pairs(modules) do
	local current = storage
	local parts = path:split(".")
	for i, part in ipairs(parts) do
		if not current.Children[part] then
			current.Children[part] =
				node(i == #parts and "ModuleScript" or "Folder")
		end
		current = current.Children[part]
	end
	current.Path = path
end
local network = node("Folder")
storage.Children.Packages = node("Folder", { Networking = network })
for _, spec in ipairs({
	{ "RF/AwayEarnings/FetchSummary", "RemoteFunction" },
	{ "RF/AwayEarnings/AskCollect", "RemoteFunction" },
	{ "RF/Codex/AskRedeemAll", "RemoteFunction" },
	{ "RE/Homestead/AskBaseTierRaise", "RemoteEvent" },
	{ "RF/Treadmill/AskTierRaise", "RemoteFunction" },
	{ "RF/Trailwear/AskPurchase", "RemoteFunction" },
}) do
	local remote = node(spec[2])
	local function send(_, ...)
		table.insert(requests, { Name = spec[1], Args = { ... }, Time = now })
		if spec[1] == "RF/AwayEarnings/FetchSummary" then
			return { ClaimableAmount = 25 }
		end
		return false
	end
	remote.InvokeServer = send
	remote.FireServer = send
	network.Children[spec[1]] = remote
end
local require = function(module)
	moduleReads += 1
	assert(modules[module.Path], "unexpected require")
	return modules[module.Path]
end
local workspace = node("Workspace")
local services = {
	ReplicatedStorage = storage,
	Players = { LocalPlayer = player },
	RunService = { RenderStepped = frame },
}
local game = {
	GetService = function(_, name)
		return assert(services[name], name)
	end,
}
local threads = {}
task.spawn = function(callback)
	local thread = coroutine.create(callback)
	table.insert(threads, thread)
	return thread
end
task.wait = function(dt)
	now += dt or 0.01
	coroutine.yield()
end
local function advance(count)
	for _ = 1, count do
		for _, thread in ipairs(table.clone(threads)) do
			if coroutine.status(thread) ~= "dead" then
				local ok, reason = coroutine.resume(thread)
				assert(ok, reason)
			end
		end
	end
end
-- @CHILI_MODULES
local info = chiliPolicy.Describe(
	record,
	dataAssets,
	modules["Shared.Modules.Mutations"]
)
assert(info.Rank == 4 and math.abs(info.Value - 10 * 2 ^ 1.85) < 0.0001)
local mutated = table.clone(record)
mutated.BaseMutation = "Golden"
mutated.Mutations = { Golden = true, "Rainbow", "Normal" }
assert(#chiliPolicy.Mutations(mutated) == 2)
assert(
	chiliPolicy.Describe(mutated, dataAssets, nil) == nil,
	"unknown mutation multiplier is not invented"
)
assert(
	math.abs(
		chiliPolicy.Describe(
			mutated,
			dataAssets,
			modules["Shared.Modules.Mutations"]
		).Value - info.Value * 3
	) < 0.0001
)
local big = table.clone(record)
big.AssetScale = 10
assert(
	math.abs(
		chiliPolicy.Describe(big, dataAssets, nil).Value
			- 10 * (10 / 5) ^ 1.2 * 19.637875755794113
	) < 0.0001
)
local starter = table.clone(record)
starter.Uid = "FirstAreaEgg_abc"
assert(chiliPolicy.Describe(starter, dataAssets, nil) == nil)
assert(
	chiliPolicy.Match(info, { MinRank = 4, MinValue = 0, Name = "test" })
		and not chiliPolicy.Match(info, { MinRank = 5 })
)
local other = table.clone(info)
other.Uid = "other"
other.Value = 1
other.Distance = 2
info.Distance = 4
assert(
	chiliPolicy.Sort({ info, other }, "Lowest value")[1] == other
		and chiliPolicy.Sort({ info, other }, "Closest")[1] == other
)
assert(
	chiliPolicy.Progress("Base", save, modules["Data.Bases"]).Remote
		== "RE/Homestead/AskBaseTierRaise"
)
assert(
	chiliPolicy.Progress("Treadmill", save, modules["Data.Treadmills"]).Args[1]
		== "tread-1"
)
assert(
	chiliPolicy.Progress("Trail", save, modules["Data.Trails"]).Args[1]
		== "cheap"
)
save.TrailInventory = { cheap = true }
assert(
	chiliPolicy.Progress("Trail", save, modules["Data.Trails"]).Args[1]
		== "expensive"
)
save.Money = 0
assert(chiliPolicy.Progress("Base", save, modules["Data.Bases"]) == nil)
save.Money = 100
assert(chiliPolicy.CarryArgs({
	Uid = "a",
	State = "Slot",
	AreaId = "Zone2",
	NestId = 3,
})[2] == "Zone2:3")
local oldLibrary = fixtureLibrary()
makeSession("egg", oldLibrary)
local library = fixtureLibrary()
function library:GetOverlayHost()
	return { Parent = {} }
end
local context = makeSession("eggchili", library)
context.Adapter = makeAdapter(library, "StealAnEgg-CHILI", "Chili")
context.ChiliPolicy = chiliPolicy
local function runChili(context)
	-- @CHILI_CONTROLLER
end
runChili(context)
assert(
	moduleReads == 0 and #threads == 0 and #requests == 0,
	"no modules, scan or workers warmed at startup"
)
local function button(name)
	for _, item in ipairs(library.Controls) do
		if item.Kind == "Button" and item.Spec.Text == name then
			return item.Spec.Func
		end
	end
	error("missing button " .. name)
end
library.Controls.ChiliCarry:SetValue(true)
for _ = 1, 10 do
	library.Controls.ChiliCarry:SetValue(false)
	library.Controls.ChiliCarry:SetValue(true)
end
assert(#threads == 1, "rapid toggles reuse one dispatcher")
advance(1)
assert(
	#requests == 1
		and requests[1].Name == "Carry"
		and requests[1].Uid == record.Uid
)
button("Stop all recovered jobs")()
advance(2)
local sent = #requests
advance(3)
assert(#requests == sent)
-- A pending budget wait must not send after a feature is disabled.
context.NextSend = now + 1
library.Controls.ChiliCarry:SetValue(true)
advance(1)
library.Controls.ChiliCarry:SetValue(false)
advance(4)
assert(#requests == sent)
-- Return is opt-in and does not need or auto-enable Carry.
button("Save this delivery position")()
local saved = root.CFrame
root.CFrame = CFrame.new(Vector3.new(100, 0, 0))
record.State = "Carried"
record.CarrierUserId = player.UserId
library.Controls.ChiliReturn:SetValue(true)
advance(1)
assert(root.CFrame == saved, "return uses explicit saved point only")
button("Stop all recovered jobs")()
advance(2)
record.State = "Slot"
record.CarrierUserId = nil
library.Controls.ChiliESP:SetValue(true)
advance(1)
frame:Fire()
local overlay = made[#made]
assert(overlay.Name == "Nullx11ChiliEggESP")
library.Controls.ChiliESP:SetValue(false)
advance(2)
assert(overlay.Destroyed)
for _, listener in ipairs(frame.Listeners) do
	assert(not listener.Connection.Connected)
end
library.Controls.ChiliAway:SetValue(true)
advance(2)
assert(requests[#requests - 1].Name == "RF/AwayEarnings/FetchSummary")
assert(
	requests[#requests].Name == "RF/AwayEarnings/AskCollect"
		and requests[#requests].Args[1].Kind == "Claim"
)
button("Stop all recovered jobs")()
advance(2)
button("Drop carried egg / explicit request")()
advance(1)
assert(
	requests[#requests].Name == "Drop"
		and requests[#requests].Reason == "PlayerRequest"
)
advance(1)
assert(compatible(), "actual generated signature")
local savedClass = storage.Children.Client.Children.EggState.ClassName
storage.Children.Client.Children.EggState.ClassName = "Folder"
assert(not compatible())
storage.Children.Client.Children.EggState.ClassName = savedClass
-- A late, already-sent module request cannot enqueue anything after unload.
carryBlocked = true
library.Controls.ChiliCarry:SetValue(true)
advance(1)
local inFlight = #requests
library:Unload()
carryBlocked = false
advance(3)
assert(
	#requests == inFlight and not oldLibrary.Unloaded,
	"independent from original Egg session"
)
for i = 2, #requests do
	assert(requests[i].Time - requests[i - 1].Time >= 0.125)
end
return "PASS: actual CHILI recovered core/policy: default-off startup, source equations/filters, exact source requests, one-worker ownership, cancellation after budget waits, explicit saved-point return, native ESP cleanup, late response disposal, independent Egg lifetime and generated signature (development fixtures only)"
