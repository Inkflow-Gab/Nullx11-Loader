-- Development-only contracts against the actual controllers/modules. No live
-- Roblox, executor Drawing implementation, or server success is simulated.
local Vector3 = {
	new = function(x, y, z)
		return { X = x, Y = y, Z = z }
	end,
}
local CFrame = {
	new = function(position)
		return { Position = position }
	end,
}
local Color3 = {
	fromRGB = function(...)
		return { ... }
	end,
}
Enum.UserInputType = { MouseButton2 = "RMB" }
Enum.HighlightDepthMode = { AlwaysOnTop = "top" }
local Instance = {
	new = function(class)
		local object = { ClassName = class }
		function object:Destroy()
			self.Destroyed = true
		end
		return object
	end,
}
local run, heartbeat, began, ended =
	newSignal(), newSignal(), newSignal(), newSignal()
local player = {}
local function node(class, children)
	local object = { ClassName = class, Children = children or {} }
	function object:FindFirstChild(name)
		return self.Children[name]
	end
	function object:IsA(name)
		return self.ClassName == name
	end
	return object
end
local originals = {}
local gunController = {}
for _, key in ipairs({
	"ApplyRecoil",
	"_FireScriptedRecoil",
	"GetBloomFraction",
	"GetEffectiveBloomFraction",
	"GetIdleSwayOffset",
	"GetMovementSwayOffset",
}) do
	gunController[key] = function()
		return key
	end
	originals[key] = gunController[key]
end
local cameraController = {
	Recoil = function()
		return "recoil"
	end,
	BoomKick = function()
		return "kick"
	end,
}
local throwableController = {
	GetAmmo = function()
		return 2
	end,
}
local controllers = node("Folder", {
	GunController = node("ModuleScript"),
	CameraController = node("ModuleScript"),
	ThrowableController = node("ModuleScript"),
})
controllers.GunController = controllers.Children.GunController
controllers.CameraController = controllers.Children.CameraController
controllers.ThrowableController = controllers.Children.ThrowableController
local client = node("Folder", { Controllers = controllers })
client.Controllers = controllers
local modules = node("Folder", { Client = client })
modules.Client = client
local requests = {}
local function event(name)
	local object = node("RemoteEvent")
	function object:FireServer(...)
		table.insert(requests, { Name = name, Time = now, Arguments = { ... } })
	end
	return object
end
local eggRemote = node("RemoteFunction")
local eggBlocked = false
function eggRemote:InvokeServer(...)
	table.insert(requests, { Name = "Egg", Time = now, Arguments = { ... } })
	while eggBlocked do
		coroutine.yield()
	end
	return false -- Never claim a rejected request succeeded.
end
local storage = node("ReplicatedStorage", {
	Modules = modules,
	Remotes = node("Folder", { ClickToEarn = event("Click") }),
	RebirthRemote = event("Rebirth"),
	EvolveRemote = event("Evolve"),
	Events = node("Folder", { CanOpenEgg = eggRemote }),
})
storage.Modules = modules
local workspace = node("Workspace", { MercPlayers = node("Folder") })
local services = {
	Players = { LocalPlayer = player },
	RunService = { RenderStepped = run, Heartbeat = heartbeat },
	UserInputService = { InputBegan = began, InputEnded = ended },
	ReplicatedStorage = storage,
	Workspace = workspace,
	CoreGui = {},
}
local game = {
	GetService = function(_, name)
		assert(services[name], name)
		return services[name]
	end,
}
local require = function(module)
	if module == controllers.GunController then
		return gunController
	end
	if module == controllers.CameraController then
		return cameraController
	end
	if module == controllers.ThrowableController then
		return throwableController
	end
	error("unexpected require")
end
local fireClass = {
	InitFromDef = function() end,
	Fire = function()
		return "fired"
	end,
	GetReserve = function()
		return 3
	end,
}
local oldFire, oldReserve = fireClass.Fire, fireClass.GetReserve
local camera =
	{ _recoilShakeSpring = { t = 7, p = 8 }, _recoilSpring = { t = 9, p = 10 } }
local scans = 0
local getgc = function()
	scans += 1
	return { fireClass, camera }
end
local spawned = {}
task.spawn = function(callback)
	local thread = coroutine.create(callback)
	table.insert(spawned, thread)
	return thread
end
task.wait = function(dt)
	now += dt or 0.01
	coroutine.yield()
end
local function advance(count)
	for _ = 1, count do
		local copy = table.clone(spawned)
		for _, thread in ipairs(copy) do
			if coroutine.status(thread) ~= "dead" then
				local ok, reason = coroutine.resume(thread)
				assert(ok, reason)
			end
		end
	end
end
-- @MODULES
local patches = makePatches()
local object = { Value = 4 }
patches.Write("first", object, "Value", 0)
patches.Write("second", object, "Value", 0)
patches.Restore("first")
assert(object.Value == 0, "overlapping spring layers stay active")
patches.Restore("second")
assert(object.Value == 4)
patches.Write("first", object, "Value", false)
patches.Restore("first")
assert(object.Value == 4)
patches.Write("first", object, "Missing", false)
patches.Clear()
assert(object.Missing == nil)
patches.Write("first", object, "Value", 0)
object.Value = 12
patches.Clear()
assert(object.Value == 12, "external writes win")
patches.Write("first", object, "Value", 1)
object.Value = 13
patches.Write("first", object, "Value", 1)
patches.Clear()
assert(object.Value == 13, "restore latest observed game value")
local ttkLibrary = fixtureLibrary()
local ttkContext = makeSession("ttk", ttkLibrary)
ttkContext.Adapter = makeAdapter(ttkLibrary, "TTK Testing", "TTK")
ttkContext.Patches = makePatches()
local function runTTK(context)
	-- @TTK
end
runTTK(ttkContext)
assert(
	scans == 0
		and #spawned == 0
		and gunController.ApplyRecoil == originals.ApplyRecoil,
	"no startup GC worker or method patch"
)
run:Fire()
heartbeat:Fire()
assert(scans == 0)
local function button(library, text)
	for _, control in ipairs(library.Controls) do
		if control.Kind == "Button" and control.Spec.Text == text then
			return control.Spec.Func
		end
	end
	error("missing button " .. text)
end
ttkLibrary.Controls.noRecoil:SetValue(true)
assert(gunController.ApplyRecoil ~= originals.ApplyRecoil and scans == 0)
local gun = {
	MaxMagSize = 30,
	MagAmmo = 4,
	FireRate = 0.2,
	CanFire = false,
	FireMode = "semi",
	RecoilSpring = { t = 3, p = 4 },
}
assert(gunController.ApplyRecoil(gun) == nil)
run:Fire()
assert(gun.RecoilSpring.t ~= 3)
ttkLibrary.Controls.noRecoil:SetValue(false)
assert(gun.RecoilSpring.t == 3 and gun.RecoilSpring.p == 4)
button(ttkLibrary, "Scan equipped weapon / camera")()
assert(scans == 1 and fireClass.Fire ~= oldFire)
button(ttkLibrary, "Scan equipped weapon / camera")()
assert(scans == 1, "manual scan is rate limited")
ttkLibrary.Controls.infAmmo:SetValue(true)
assert(fireClass.Fire(gun) == "fired" and gun.MagAmmo == 31)
ttkLibrary.Controls.infAmmo:SetValue(false)
assert(gun.MagAmmo == 4)
ttkLibrary.Controls.rapid:SetValue(true)
ttkLibrary.Controls.fullAuto:SetValue(true)
fireClass.Fire(gun)
heartbeat:Fire()
assert(gun.FireMode == "auto" and gun.CanFire == true)
ttkLibrary.Controls.rapid:SetValue(false)
assert(gun.FireRate == 0.2 and gun.CanFire == false and gun.FireMode == "auto")
ttkLibrary.Controls.fullAuto:SetValue(false)
assert(gun.FireMode == "semi")
local external = function()
	return "other script"
end
gunController.GetBloomFraction = external
ttkLibrary:Unload()
assert(fireClass.Fire == oldFire and fireClass.GetReserve == oldReserve)
assert(
	gunController.ApplyRecoil == originals.ApplyRecoil
		and gunController.GetBloomFraction == external
)
for _, signal in ipairs({ run, heartbeat, began, ended }) do
	for _, listener in ipairs(signal.Listeners) do
		assert(not listener.Connection.Connected)
	end
end
local data = makeMoneyData()
for text, expected in pairs({
	["1,234"] = 1234,
	["1.5K"] = 1500,
	["1,5K"] = 1500,
	["5 Dc"] = 5e33,
	["30Ud"] = 30e36,
	["1,234,567"] = 1234567,
}) do
	assert(data.Parse(text) == expected, text)
end
assert(
	data.Parse("invalid") == nil
		and data.Parse("12wat") == nil
		and data.Parse(nil) == nil
)
assert(data.RebirthPosition(0) == data.rebirthWaypoints[1].pos)
assert(
	data.RebirthPosition(70)
		== data.rebirthWaypoints[#data.rebirthWaypoints].pos
)
assert(data.CashPosition(nil, 100) == nil)
local base, _, world = data.CashPosition(14, 0)
assert(world == 2 and base == data.Bases[2])
local _, _, third = data.CashPosition(29, 0)
local _, _, fourth = data.CashPosition(50, 0)
assert(third == 3 and fourth == 4)
assert(#data.eggPrices == 16)
local stats = node("Folder", {
	["Rebirth \240\159\148\132\239\184\143"] = { Value = 14 },
	Wins = {
		Value = 0,
	},
})
local root = {}
player.Character = node("Model", { HumanoidRootPart = root })
function player:FindFirstChild(name)
	return name == "leaderstats" and stats or nil
end
local moneyLibrary = fixtureLibrary()
local moneyContext = makeSession("money", moneyLibrary)
moneyContext.Adapter = makeAdapter(moneyLibrary, "+1 Money per Click", "Money")
moneyContext.MoneyData = data
local function runMoney(context)
	-- @MONEY
end
runMoney(moneyContext)
assert(
	#spawned == 0 and #requests == 0,
	"money startup has no workers or requests"
)
local function control(library, title)
	for _, item in ipairs(library.Controls) do
		if item.Title == title then
			return item
		end
	end
	error("missing control " .. title)
end
local mode = control(moneyLibrary, "Movement mode")
local money = control(moneyLibrary, "Auto money")
mode:SetValue("Rebirths")
money:SetValue(true)
for _ = 1, 10 do
	mode:SetValue("Cash")
	mode:SetValue("Rebirths")
	money:SetValue(false)
	money:SetValue(true)
end
assert(#spawned == 2, "rapid toggles cannot duplicate either worker")
advance(4)
assert(#requests > 0 and root.CFrame.Position == data.RebirthPosition(14))
mode:SetValue("Cash")
advance(3)
assert(
	root.CFrame.Position == data.Bases[2],
	"cash mode exclusively owns movement"
)
local kept = root.CFrame
stats.Children.Wins.Value = "unreadable"
advance(2)
assert(root.CFrame == kept, "unreadable stats pause movement")
button(moneyLibrary, "Stop all farming / purchases")()
advance(2)
local stopped = #requests
advance(3)
assert(#requests == stopped)
for i = 2, #requests do
	assert(
		requests[i].Time - requests[i - 1].Time >= 0.125,
		"shared remote cap"
	)
end
local egg = control(moneyLibrary, "Common / 1 Wins")
eggBlocked = true
egg:SetValue(true)
advance(1)
assert(
	requests[#requests].Name == "Egg"
		and requests[#requests].Arguments[1] == "Common"
		and requests[#requests].Arguments[2] == 3
)
local alreadySent = #requests
moneyLibrary:Unload()
eggBlocked = false
advance(3)
assert(
	#requests == alreadySent,
	"unload cannot enqueue after a late InvokeServer response"
)
assert(ttkCompatible() and moneyCompatible())
storage.Children.EvolveRemote = nil
assert(not moneyCompatible())
storage.Children.EvolveRemote = event("Evolve")
controllers.GunController.ClassName = "Folder"
assert(not ttkCompatible())
return "PASS: actual TTK and Money controllers: off startup, explicit/rate-limited discovery, reversible/layered edits, hook ownership, exclusive routes, parser/world/egg data, duplicate-worker prevention, remote pacing, late-response cleanup and real generated signature gates (development fixtures only)"
