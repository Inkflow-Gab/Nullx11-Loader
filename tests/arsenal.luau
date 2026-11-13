-- Actual Arsenal controller/input/policy with structural Roblox doubles only.
-- @LIBRARY_FIXTURE
local environment = {}
local getgenv = function()
	return environment
end
-- @ARSENAL_MODULES
services.Lighting = Instance.new("Lighting")
local lighting = services.Lighting
lighting.Ambient, lighting.OutdoorAmbient, lighting.Brightness =
	"ambient", "outdoor", 1
lighting.FogStart, lighting.FogEnd = 5, 700
runService.Heartbeat, runService.Stepped = signal(), signal()
inputService.WindowFocused, inputService.JumpRequest = signal(), signal()
player.CharacterAdded, player.CharacterRemoving = signal(), signal()
function inputService:IsMouseButtonPressed()
	return self.MouseDown
end
function camera:ViewportPointToRay(x, y)
	return { Origin = self.CFrame.Position, Direction = Vector3.new(0, 0, 1) }
end
local function humanoid(model)
	return model:FindFirstChildOfClass("Humanoid")
end
local localHum = humanoid(player.Character)
localHum.WalkSpeed, localHum.JumpPower, localHum.UseJumpPower, localHum.PlatformStand =
	16, 50, false, false
localHum.MoveDirection = Vector3.zero
local root = enemy.Character:FindFirstChild("HumanoidRootPart")
root.Size, root.Transparency = Vector3.new(2, 2, 1), 1
local originalSize = root.Size
local localPart = player.Character:FindFirstChild("HumanoidRootPart")
localPart.CanCollide = true
local inputCalls, clicks = {}, 0
local mouse1click = function()
	clicks += 1
end
local failDown, failUp = false, false
services.VirtualInputManager = {
	SendMouseButtonEvent = function(_, x, y, button, down)
		table.insert(inputCalls, { Down = down, X = x, Y = y })
		if (down and failDown) or (not down and failUp) then
			error("denied input")
		end
	end,
}
local function library()
	local lib = fixtureLibrary()
	function lib:GetGuiParent()
		return playerGui
	end
	return lib
end
local lib = library()
local context = makeSession("arsenal", lib)
context.Patches, context.ArsenalPolicy, context.MakeArsenalInput =
	makePatches(), arsenalPolicy, makeArsenalInput
local function runGame(context)
	-- @ARSENAL_CONTROLLER
end
local startedObjects = #objects
local result = runGame(context)
assert(result.Nullx11Ready and #lib.Window.Tabs == 5)
local function set(key, value)
	lib.Controls["Arsenal_" .. key]:SetValue(value)
end
local function step(dt)
	clock += dt
	runService.Heartbeat:Fire(dt)
	runService.RenderStepped:Fire(dt)
end
for _ = 1, 20 do
	step(0.2)
end
assert(
	#objects == startedObjects
		and clicks == 0
		and workspaceService.RayCount == 0,
	"off startup is lazy"
)
for _, key in ipairs({
	"Aim",
	"ESP",
	"Circle",
	"Trigger",
	"Speed",
	"Jump",
	"Fly",
	"Noclip",
	"Hitbox",
	"Fullbright",
	"NoFog",
	"CameraFov",
}) do
	assert(not result.Config[key], key)
end
assert(
	arsenalPolicy.Place == 286090429
		and #arsenalPolicy.Bones.R6 == 5
		and #arsenalPolicy.Bones.R15 == 14
)
assert(not arsenalPolicy.Enemy(player, player, false))
assert(not arsenalPolicy.Enemy(player, teammate, true))
assert(arsenalPolicy.Enemy(player, enemy, true))
assert(arsenalPolicy.Alpha(100, 1 / 120) == 1)
assert(math.abs(arsenalPolicy.Alpha(50, 1 / 30) - 0.75) < 1e-9)
for _, bad in ipairs({ 0 / 0, math.huge, -1, 101 }) do
	assert(not pcall(arsenalPolicy.Number, bad, 0, 100))
end
set("Aim", true)
step(0.2)
assert(result.State.Target == "Enemy" and camera.CFrame.Alpha == 1)
set("Mode", "Hold")
step(0.2)
assert(result.State.Target == "None")
inputService.InputBegan:Fire(
	{ UserInputType = Enum.UserInputType.MouseButton2 },
	false
)
step(0.2)
assert(result.State.Target == "Enemy")
inputService.FocusedTextBox = {}
step(0.2)
assert(result.State.Target == "None")
inputService.FocusedTextBox = nil
inputService.WindowFocusReleased:Fire()
step(0.2)
assert(result.State.Target == "None")
inputService.WindowFocused:Fire()
local touchPad
for index = #objects, 1, -1 do
	if objects[index].Name == "ArsenalHoldAim" then
		touchPad = objects[index]
		break
	end
end
local finger = { UserInputType = Enum.UserInputType.Touch }
touchPad.InputBegan:Fire(finger)
step(0.2)
assert(result.State.Target == "Enemy")
inputService.InputEnded:Fire(finger)
step(0.2)
assert(result.State.Target == "None", "release outside touch pad clears hold")
set("Mode", "Auto")
local wall = Instance.new("Part")
wall.Parent = workspaceService
workspaceService.Occluder = wall
step(0.2)
assert(result.State.Target == "None")
workspaceService.Occluder = nil
humanoid(enemy.Character).Health = 0
step(0.2)
assert(result.State.Target == "None")
humanoid(enemy.Character).Health = 100
local forcefield = Instance.new("ForceField")
forcefield.Parent = enemy.Character
step(0.2)
assert(result.State.Target == "None")
forcefield:Destroy()
set("Speed", true)
set("WalkSpeed", 42)
step(0.2)
assert(localHum.WalkSpeed == 42)
set("Speed", false)
assert(localHum.WalkSpeed == 16)
set("Jump", true)
step(0.2)
assert(localHum.UseJumpPower and localHum.JumpPower == 65)
set("Jump", false)
assert(not localHum.UseJumpPower and localHum.JumpPower == 50)
set("Noclip", true)
runService.Stepped:Fire()
assert(not localPart.CanCollide)
set("Noclip", false)
assert(localPart.CanCollide)
set("Fullbright", true)
assert(lighting.Brightness == 2)
set("Fullbright", false)
assert(lighting.Brightness == 1 and lighting.Ambient == "ambient")
set("NoFog", true)
assert(lighting.FogEnd == 100001)
set("NoFog", false)
assert(lighting.FogStart == 5 and lighting.FogEnd == 700)
camera.FieldOfView = 70
set("CameraFov", true)
step(0.2)
assert(camera.FieldOfView == 80)
set("CameraFov", false)
assert(camera.FieldOfView == 70)
set("Hitbox", true)
step(0.2)
step(0.2)
assert(root.Size.X == 6)
enemy.Team = player.Team
step(0.2)
assert(root.Size == originalSize and root.Transparency == 1)
enemy.Team = "Red"
set("Hitbox", false)
set("ESP", true)
set("Circle", true)
step(0.2)
local function findObject(name)
	for index = #objects, 1, -1 do
		local o = objects[index]
		if o.Name == name and not o.Destroyed then
			return o
		end
	end
end
assert(findObject("ArsenalESP1").Visible and findObject("ArsenalFOV").Visible)
local allocations = #objects
for _ = 1, 20 do
	step(0.2)
end
assert(#objects == allocations, "overlays reuse slots")
set("ESP", false)
assert(not findObject("ArsenalESP1"))
set("Aim", false)
set("Circle", false)
set("Trigger", true)
workspaceService.Occluder = root
step(0.2)
assert(clicks == 1)
step(0.01)
assert(clicks == 1, "bounded trigger interval")
inputService.MouseDown = true
step(0.2)
assert(clicks == 1)
inputService.MouseDown = false
set("Backend", "VIM")
set("Trigger", true)
step(0.2)
assert(#inputCalls == 2 and inputCalls[1].Down and not inputCalls[2].Down)
assert(inputCalls[1].X == 400 and inputCalls[1].Y == 300)
failDown = true
step(0.2)
assert(
	not result.Config.Trigger and not inputCalls[#inputCalls].Down,
	"down error attempts release then stops"
)
failDown = false
set("Trigger", true)
failUp = true
step(0.2)
assert(not result.Config.Trigger)
failUp = false
-- A retained owned hold is retriable without firing a fresh click.
for _, control in ipairs(lib.Controls) do
	if control.Spec.Text == "Retry owned mouse release" then
		control.Spec.Func()
	end
end
assert(not inputCalls[#inputCalls].Down)
workspaceService.Occluder = nil
set("Fly", true)
step(0.2)
assert(localHum.PlatformStand and findObject("NULLArsenalFlight"))
set("Fly", false)
assert(not localHum.PlatformStand and not findObject("NULLArsenalFlight"))
set("Speed", true)
step(0.2)
player.CharacterRemoving:Fire()
assert(localHum.WalkSpeed == 16 and not findObject("ArsenalESP1"))
step(0.2)
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.F7 }, false)
assert(not result.Config.Speed and localHum.WalkSpeed == 16)
assert(
	result.Config.TeamCheck
		and result.Config.Visible
		and result.Config.Forcefield,
	"emergency stop preserves safety filters"
)
-- External changes win restoration instead of being overwritten with defaults.
set("Speed", true)
step(0.2)
localHum.WalkSpeed = 19
set("Speed", false)
assert(localHum.WalkSpeed == 19)
-- Above the display budget, candidates/rays and pooled output stay bounded.
set("Aim", true)
set("ESP", true)
set("ESPVisible", true)
local originalPlayers = playersService.PlayerList
local crowd = { player }
for index = 1, 70 do
	table.insert(crowd, makePlayer("Crowd" .. index, index + 100, 1, "Red"))
end
playersService.PlayerList = crowd
local raysBefore = workspaceService.RayCount
step(0.2)
assert(
	result.State.Candidates <= 63
		and workspaceService.RayCount - raysBefore <= 12
)
local overlays = 0
for _, object in ipairs(objects) do
	if not object.Destroyed and object.Name:match("^ArsenalESP%d+$") then
		overlays += 1
	end
end
assert(overlays <= result.Config.Budget and result.State.Errors == 0)
playersService.PlayerList = originalPlayers
set("Aim", false)
set("ESP", false)
-- Trigger's no-hit ray probes are paced too, not only successful click requests.
set("Trigger", true)
workspaceService.Occluder = nil
step(0.2)
raysBefore = workspaceService.RayCount
for _ = 1, 5 do
	step(0.01)
end
assert(workspaceService.RayCount == raysBefore)
set("Trigger", false)
local before = #inputCalls
lib:Unload()
lib:Unload()
step(0.2)
assert(
	not context.Alive
		and #inputCalls == before
		and not findObject("Nullx11ArsenalOverlay")
)
assert(#warnings == 0, "cleanup should not hide failed API work")
-- Pure input ownership: unload with no owned click must never release a user's mouse.
local output = makeArsenalInput({
	Game = game,
	Native = function()
		return services.VirtualInputManager
	end,
})
assert(output.Release() and #inputCalls == before)
output.Backend = "Mouse click"
assert(not pcall(output.Fire, 1, 2))
output.Backend = "VIM"
output.Fire(10, 20)
assert(output.Sent == 1 and not output.Held)
return "PASS: actual Arsenal controller/policy/input: lazy default-off startup, centered aim/hold/focus/team/alive/ForceField/LOS gates, bounded/reused native ESP, trigger pacing/error mouse-up ownership, reversible movement/lighting/hitboxes, respawn, F7 and independent cleanup (API doubles; not native/server proof)"
