-- Actual shipped collection modules under deterministic development API doubles.
-- Does not establish native Roblox rendering, permissions or server acceptance.
local now, threads, cancelled, requests, objects = 0, {}, {}, {}, {}
local task = {}
function task.defer(fn)
	local thread = coroutine.create(fn)
	table.insert(threads, { Thread = thread, Wake = now })
	return thread
end
function task.cancel(thread)
	cancelled[thread] = true
end
function task.wait(dt)
	return coroutine.yield(dt or 0)
end
local os = {
	clock = function()
		return now
	end,
}
local function step(dt)
	now += dt or 0
	local count = #threads
	for index = 1, count do
		local entry = threads[index]
		if
			not cancelled[entry.Thread]
			and coroutine.status(entry.Thread) ~= "dead"
			and entry.Wake <= now
		then
			local ok, delay = coroutine.resume(entry.Thread)
			assert(ok, tostring(delay))
			entry.Wake = now + (tonumber(delay) or 0)
		end
	end
end
local function run(fn)
	local thread = task.defer(fn)
	for _ = 1, 30 do
		step(0.15)
		if coroutine.status(thread) == "dead" then
			return
		end
	end
	error("Test action did not complete")
end
local vec = {}
vec.__index = function(value, key)
	if key == "Magnitude" then
		return math.sqrt(value.X ^ 2 + value.Y ^ 2 + value.Z ^ 2)
	end
	return vec[key]
end
local Vector3 = {
	new = function(x, y, z)
		return setmetatable({ X = x, Y = y, Z = z }, vec)
	end,
}
vec.__add = function(a, b)
	return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
vec.__sub = function(a, b)
	return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
vec.__mul = function(a, b)
	return Vector3.new(a.X * b, a.Y * b, a.Z * b)
end
local cf = { TypeTag = "CFrame" }
cf.__index = cf
local CFrame = {
	new = function(x, y, z)
		return setmetatable({
			Position = type(x) == "table" and x
				or Vector3.new(x or 0, y or 0, z or 0),
		}, cf)
	end,
}
cf.__add = function(a, b)
	return CFrame.new(a.Position + b)
end
CFrame.lookAt = function(position)
	return CFrame.new(position)
end
local Color3 = {
	fromRGB = function(r, g, b)
		return { R = r / 255, G = g / 255, B = b / 255 }
	end,
}
Color3.fromHSV = function(h, s, v)
	return { H = h, S = s, V = v }
end
local UDim2 = {
	fromOffset = function(x, y)
		return { x, y }
	end,
	fromScale = function(x, y)
		return { x, y }
	end,
}
local Enum = {
	HighlightDepthMode = { AlwaysOnTop = "top" },
	Font = { GothamMedium = "font" },
	CameraMode = { Classic = "classic" },
	ActuatorRelativeTo = { World = "world" },
}
local function signal()
	local listeners = {}
	return {
		Connect = function(_, callback)
			local connection = { Connected = true }
			function connection:Disconnect()
				self.Connected = false
			end
			table.insert(listeners, { connection, callback })
			return connection
		end,
		Fire = function(_, ...)
			for _, listener in ipairs(listeners) do
				if listener[1].Connected then
					listener[2](...)
				end
			end
		end,
	}
end
local methods = {}
function methods:GetChildren()
	local result = {}
	for _, object in ipairs(objects) do
		if object.Parent == self and not object.Destroyed then
			table.insert(result, object)
		end
	end
	return result
end
function methods:GetDescendants()
	local result = {}
	for _, child in ipairs(self:GetChildren()) do
		table.insert(result, child)
		for _, descendant in ipairs(child:GetDescendants()) do
			table.insert(result, descendant)
		end
	end
	return result
end
function methods:FindFirstChild(name)
	for _, child in ipairs(self:GetChildren()) do
		if child.Name == name then
			return child
		end
	end
end
function methods:IsA(name)
	return self.ClassName == name
		or (name == "BasePart" and self.ClassName == "Part")
end
function methods:FindFirstChildOfClass(name)
	for _, child in ipairs(self:GetChildren()) do
		if child.ClassName == name then
			return child
		end
	end
end
function methods:FindFirstChildWhichIsA(name, recursive)
	for _, child in
		ipairs(recursive and self:GetDescendants() or self:GetChildren())
	do
		if child:IsA(name) then
			return child
		end
	end
end
function methods:GetPivot()
	return self.Pivot or CFrame.new()
end
function methods:Destroy()
	for _, child in ipairs(self:GetChildren()) do
		child:Destroy()
	end
	self.Destroyed = true
	self.Parent = nil
end
function methods:FireServer(...)
	table.insert(requests, { Remote = self, Args = { ... }, Time = now })
end
methods.InvokeServer = methods.FireServer
function methods:EquipTool(tool)
	tool.Parent = self.Parent
end
local function node(class, name, parent)
	local object = setmetatable(
		{ ClassName = class, Name = name or class, Parent = parent },
		{ __index = methods }
	)
	table.insert(objects, object)
	return object
end
local Instance = {
	new = function(class)
		return node(class)
	end,
}
local typeof = function(value)
	return type(value) == "table"
			and (value.TypeTag or (value.ClassName and "Instance"))
		or type(value)
end
local workspace = node("Workspace", "Workspace")
workspace.CurrentCamera = { FieldOfView = 70, CameraSubject = "original" }
local storage = node("ReplicatedStorage", "ReplicatedStorage")
local player = node("Player", "LocalUser")
player.DisplayName = "Local User"
player.CameraMode = "default"
player.CameraMaxZoomDistance = 20
local services =
	{ Players = { LocalPlayer = player }, ReplicatedStorage = storage }
function services.Players:GetPlayers()
	return self.List or { player }
end
services.CollectionService = {
	GetTagged = function()
		return {}
	end,
}
local game = {
	GetService = function(_, name)
		return assert(services[name], name)
	end,
}
local catalog = {}
-- @CATALOG_VALIDATE
local document = {
	Version = 1,
	Scripts = {
		{
			Id = "universal",
			Name = "Universal",
			Description = "Test",
			File = "universal.luau",
			Universal = true,
			Collection = "YARHM",
			Author = "Owner: NULL.",
		},
		{
			Id = "forsaken",
			Name = "Forsaken",
			Description = "Test",
			File = "forsaken.luau",
			GameUniverseId = 6331902150,
		},
	},
}
local cleaned = catalog.Validate(document)
assert(
	cleaned[1].Universal == true
		and cleaned[1].Collection == "YARHM"
		and cleaned[2].GameUniverseId == 6331902150
)
document.Scripts[1].Universal = {}
assert(not pcall(catalog.Validate, document), "reject invalid Universal types")
document.Scripts[1].Universal = true
document.Scripts[2].GameUniverseId = 0
assert(not pcall(catalog.Validate, document), "reject wildcard universe IDs")
local env = {}
local getgenv = function()
	return env
end
local warn = function() end
local requireCount = 0
local require = function(module)
	requireCount += 1
	return module.Export
end
local function character(name)
	local model = node("Model", name, workspace)
	local root = node("Part", "HumanoidRootPart", model)
	root.CFrame = CFrame.new()
	root.Position = Vector3.new(0, 0, 0)
	root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	local humanoid = node("Humanoid", "Humanoid", model)
	humanoid.Health = 100
	humanoid.WalkSpeed = 16
	humanoid.UseJumpPower = false
	humanoid.JumpPower = 40
	return model, root, humanoid
end
local character1, root1, humanoid1 = character("LocalUser")
player.Character = character1
-- @HUB_MODULES
assert(HubPolicy.Compatible("yarhm_universal", 0, 0))
assert(HubPolicy.Compatible("yarhm_forsaken", 1, 6331902150))
assert(HubPolicy.Compatible("yarhm_mm2", 1, 66654135))
assert(HubPolicy.Compatible("yarhm_ftf", 1, 372226183))
assert(HubPolicy.Compatible("yarhm_brookhaven", 4924922222, 0))
assert(HubPolicy.Compatible("chaos_brookhaven", 4924922222, 0))
for _, id in ipairs({
	"yarhm_mm2",
	"yarhm_forsaken",
	"yarhm_ftf",
	"yarhm_brookhaven",
	"chaos_brookhaven",
	"unknown",
}) do
	assert(
		not HubPolicy.Compatible(id, 1, 0),
		"never inherit source gameId=0 wildcard"
	)
end
for _, value in ipairs({ "NaN", "inf", "-1", "101" }) do
	assert(not pcall(HubPolicy.Number, value, 0, 100))
end
assert(not pcall(HubPolicy.Number, 0 / 0, 0, 100))
assert(HubPolicy.Number("26", 0, 100) == 26)
local a, b =
	{ Name = "AlexOne", DisplayName = "Alex" },
	{ Name = "AlexTwo", DisplayName = "Alex" }
assert(not pcall(HubPolicy.Player, { a, b }, "Alex"))
assert(HubPolicy.Player({ a, b }, "alexone") == a)
assert(
	#HubBrookhavenData.TELEPORTS == 22
		and #HubBrookhavenData.TOOLS_LIST == 10
		and #HubBrookhavenData.EFFECTS == 61
)
local function fixture(id, controller)
	local library = { Hooks = {}, Controls = {} }
	function library:OnUnload(callback)
		table.insert(self.Hooks, callback)
	end
	function library:Unload()
		if self.Unloaded then
			return
		end
		self.Unloaded = true
		for _, callback in ipairs(self.Hooks) do
			callback()
		end
	end
	local tab = {}
	local function widget(spec)
		local control = { Spec = spec, Value = spec.value }
		function control:Set(value)
			self.Value = value
			if type(value) ~= "table" and spec.callback then
				spec.callback(value)
			end
		end
		library.Controls[spec.name] = control
		return control
	end
	for _, name in ipairs({
		"CreateText",
		"CreateToggle",
		"CreateButton",
		"CreateInput",
		"CreateDropdown",
	}) do
		tab[name] = function(_, spec)
			return widget(spec)
		end
	end
	local window = {
		CreateTab = function()
			return tab
		end,
	}
	local context = makeSession(id, library)
	context.Entry = { Id = id, Description = "Reviewed source fixture" }
	context.Patches = makePatches()
	context.HubPolicy = HubPolicy
	context.HubCore = HubCore
	context.HubData = HubBrookhavenData
	context.Adapter = {
		CreateWindow = function()
			return window
		end,
	}
	local beforeObjects, beforeRequests, beforeRequires =
		#objects, #requests, requireCount
	local core = controller(context)
	assert(
		next(core.Jobs) == nil and next(core.Instances) == nil,
		"startup has no background jobs or overlays"
	)
	assert(
		#objects == beforeObjects
			and #requests == beforeRequests
			and requireCount == beforeRequires,
		"no startup mutations, requests or module execution"
	)
	for _, control in pairs(core.Controls) do
		assert(control.Value == false, "all feature toggles start off")
	end
	local function activate(label, value)
		local control = assert(library.Controls[label], label)
		run(function()
			if value ~= nil then
				control:Set(value)
			else
				control.Spec.callback()
			end
		end)
	end
	return core, context, library, activate
end
local universal, uc, ul, uf = fixture("yarhm_universal", HubUniversal)
local forsaken, fc, fl, ff = fixture("yarhm_forsaken", HubForsaken)
local mm2, mc, ml, mf = fixture("yarhm_mm2", HubMM2)
local ftf, tc, tl, tf = fixture("yarhm_ftf", HubFTF)
local brookhaven, bc, bl, bf = fixture("yarhm_brookhaven", HubBrookhaven)
local chaos, cc, cl, cfAction = fixture("chaos_brookhaven", HubBrookhaven)
assert(
	cl.Controls["Hair RGB"]
		and cl.Controls["Body RGB"]
		and not bl.Controls["Hair RGB"],
	"distinct Chaos edition"
)
-- Actual reversible movement controls and external-change preservation.
uf("Walk speed", "40")
assert(humanoid1.WalkSpeed == 40)
uf("Restore movement settings")
assert(humanoid1.WalkSpeed == 16)
tf("Walk speed", "35")
tf("Lock walk speed", true)
step(0.3)
assert(humanoid1.WalkSpeed == 35)
humanoid1.WalkSpeed = 29
tf("Lock walk speed", false)
assert(
	humanoid1.WalkSpeed == 29,
	"do not overwrite external changes on restore"
)
-- At most one flashlight, respawn-safe, removed immediately when disabled.
tf("Flashlight", true)
step(0.6)
assert(root1:FindFirstChildOfClass("PointLight"))
local character2, root2, humanoid2 = character("Respawned")
player.Character = character2
step(0.6)
assert(
	root2:FindFirstChildOfClass("PointLight")
		and not root1:FindFirstChildOfClass("PointLight")
)
tf("Flashlight", false)
assert(not root2:FindFirstChildOfClass("PointLight"))
-- Sprint module is only required on demand and its original fields restore.
local systems = node("Folder", "Systems", storage)
local chars = node("Folder", "Character", systems)
local gameFolder = node("Folder", "Game", chars)
local sprintModule = node("ModuleScript", "Sprinting", gameFolder)
sprintModule.Export =
	{ StaminaLossDisabled = false, SprintSpeed = 26, StaminaGain = 20 }
ff("Infinite stamina", true)
step(1.1)
assert(requireCount == 1 and sprintModule.Export.StaminaLossDisabled)
ff("Infinite stamina", false)
assert(not sprintModule.Export.StaminaLossDisabled)
ff("Sprinting speed", "60")
assert(sprintModule.Export.SprintSpeed == 60)
ff("Restore sprint settings")
assert(sprintModule.Export.SprintSpeed == 26)
-- Nearest unfinished generator and the retained four-second cooldown.
local mapRoot = node("Folder", "Map", workspace)
local ingame = node("Folder", "Ingame", mapRoot)
local level = node("Model", "Map", ingame)
local generator = node("Model", "Generator", level)
generator.Pivot = CFrame.new(5, 0, 0)
local complete = node("Model", "Generator", level)
complete.Pivot = CFrame.new(1, 0, 0)
local progress = node("NumberValue", "Progress", complete)
progress.Value = 100
local remotes = node("Folder", "Remotes", generator)
local generatorRemote = node("RemoteEvent", "RE", remotes)
local before = #requests
ff("Finish nearest generator puzzle")
ff("Finish nearest generator puzzle")
assert(
	#requests == before + 1 and requests[#requests].Remote == generatorRemote
)
-- Unknown/broken remotes never show a fake success or emit a request.
before = #requests
bf("Request Glider")
assert(#requests == before)
local re = node("Folder", "RE", storage)
local give = node("RemoteEvent", "1Playe1rTrigge1rEven1t", re)
bf("Request Glider")
assert(
	requests[#requests].Remote == give
		and requests[#requests].Args[1] == "AcceptedToolToServer"
		and requests[#requests].Args[2] == "Glider"
)
-- Actual server request pacing/cancellation while a job is queued.
local queued = node("RemoteEvent", "Queued", storage)
cc.NextSend = now + 2
before = #requests
chaos.Job("queued request", true, 1, function(current)
	chaos.Request(current, queued, "value")
end)
step(0)
chaos.Stop("queued request")
step(3)
assert(#requests == before, "off cancels a queued paced request")
-- Replacement cancels the old worker before it can run.
local oldRuns, newRuns = 0, 0
chaos.Job("replace", true, 1, function()
	oldRuns += 1
end)
chaos.Job("replace", true, 1, function()
	newRuns += 1
end)
step(0)
assert(oldRuns == 0 and newRuns == 1)
chaos.Stop("replace")
-- Source-equivalent weapon dispatch uses the actual owned gun and two CFrames.
local enemy = node("Player", "Enemy")
enemy.DisplayName = "Enemy"
enemy.Character = character("Enemy")
node("Tool", "Knife", enemy.Character)
services.Players.List = { player, enemy }
local gun = node("Tool", "Gun", player.Character)
local shootRemote = node("RemoteEvent", "Shoot", gun)
before = #requests
mf("Shoot identified murderer")
assert(
	#requests == before + 1
		and requests[#requests].Remote == shootRemote
		and #requests[#requests].Args == 2
)
gun:Destroy()
enemy.Character:FindFirstChild("Knife"):Destroy()
-- The actual flight controller owns/reclaims constraints and follows touch-style
-- Humanoid.MoveDirection; this is a data contract, not a physics/touch emulator.
humanoid2.MoveDirection = Vector3.new(1, 0, 0)
uf("Fly", true)
step(0.1)
local flightVelocity = root2:FindFirstChildOfClass("LinearVelocity")
assert(flightVelocity and flightVelocity.VectorVelocity.X == 45)
uf("Fly", false)
assert(
	not root2:FindFirstChildOfClass("LinearVelocity")
		and not root2:FindFirstChildOfClass("Attachment")
)

-- No-role auto-shoot errors turn their actual native toggle back off.
mf("Auto-shoot murderer", true)
step(0)
assert(
	not ml.Controls["Auto-shoot murderer"].Value
		and mm2.Jobs["Auto-shoot murderer"] == nil
)
-- Hidden trap visibility is reversible rather than a permanent world edit.
local trap = node("Part", "Trap", workspace)
trap.Transparency = 1
mf("Traps ESP", true)
for _ = 1, 6 do
	step(0.2)
end
assert(trap.Transparency == 0.35)
mf("Traps ESP", false)
assert(trap.Transparency == 1)
-- Native overlay ceiling, reuse, removal; never destroys a game target.
local records = {}
for index = 1, 70 do
	local object = node("Part", "Target" .. index, workspace)
	table.insert(records, { Object = object, Text = object.Name })
end
chaos.Markers(records)
local function ownedCount(class)
	local count = 0
	for object in pairs(chaos.Instances) do
		if object.ClassName == class and not object.Destroyed then
			count += 1
		end
	end
	return count
end
assert(ownedCount("Highlight") == 64 and ownedCount("BillboardGui") == 64)
local originalCount = #objects
chaos.Markers(records)
assert(#objects == originalCount, "reuse marker instances")
chaos.ClearMarkers()
assert(ownedCount("Highlight") == 0 and not records[1].Object.Destroyed)
-- Capped/yielding scan and cancellation, actual implementation.
local scanRoot = node("Folder", "Scan", workspace)
for index = 1, 500 do
	node("Folder", tostring(index), scanRoot)
end
local found
run(function()
	found = universal.Scan(scanRoot, function()
		return true
	end, nil, 211)
end)
assert(#found == 211)
local current = true
local scanThread = task.defer(function()
	found = universal.Scan(scanRoot, function()
		return true
	end, function()
		return current
	end)
end)
step(0)
current = false
step(0)
assert(coroutine.status(scanThread) == "dead" and #found == 0)
-- An independent collection edition and its cleanup must not stop the others.
uf("Walk speed", "44")
assert(humanoid2.WalkSpeed == 44)
ul:Unload()
assert(
	not uc.Alive
		and humanoid2.WalkSpeed == 16
		and fc.Alive
		and tc.Alive
		and bc.Alive
		and cc.Alive
)
chaos.Job("unload", true, 1, function()
	error("must never run after unload")
end)
cl:Unload()
step(2)
assert(next(chaos.Jobs) == nil and next(chaos.Instances) == nil)
for _, lib in ipairs({ fl, ml, tl, bl }) do
	lib:Unload()
end
return "PASS: actual six-entry collection: strict gates, default-off/no-side-effect startup, finite inputs, unique player resolution, data counts, reversible/external-safe edits, lazy stamina require, respawn light, nearest/cooldown generator, real protocol dispatch, queued cancellation, one worker/key, error toggle rollback, bounded/reused overlays and scan, independent cleanup (development doubles only)"
