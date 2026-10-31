-- Native source-feature adaptation: © Aetherion 2026. NULL collection edition.
local core = context.HubCore(context)
local movement = core.Tab("Local movement", "activity")
local flight = core.Tab("Flight", "plane")
local camera = core.Tab("Camera and target", "target")
local visuals = core.Tab("ESP and lighting", "eye")
local navigation = core.Tab("Saved navigation", "map")
local players = game:GetService("Players")
local target
core.Input(
	camera,
	"Target username",
	"Unique username or display-name prefix",
	function(text)
		target = context.HubPolicy.Player(players:GetPlayers(), text)
		core.Report("Target: " .. target.Name)
	end
)
local function targetHumanoid()
	assert(target and target.Parent, "Select a target first")
	local humanoid = target.Character
		and target.Character:FindFirstChildOfClass("Humanoid")
	assert(humanoid, "Target character is not ready")
	return humanoid
end
core.Toggle(camera, "Spectate target", function(value)
	if value then
		targetHumanoid()
	end
	core.Job("Spectate target", value, 0.25, function()
		core.Write(
			"spectate",
			workspace.CurrentCamera,
			"CameraSubject",
			targetHumanoid()
		)
	end)
	if not value then
		core.Restore("spectate")
	end
end)
core.Toggle(camera, "Aim lock selected target", function(value)
	if value then
		targetHumanoid()
	end
	core.Job("Aim lock selected target", value, 0.05, function()
		targetHumanoid()
		local root = target.Character:FindFirstChild("HumanoidRootPart")
		local active = workspace.CurrentCamera
		if root and active then
			active.CFrame = CFrame.lookAt(active.CFrame.Position, root.Position)
		end
	end)
end)
core.Number(camera, "Camera field of view", 30, 120, function(value)
	core.Write("fov", workspace.CurrentCamera, "FieldOfView", value)
end)
core.Button(camera, "Restore camera settings", function()
	core.Controls["Spectate target"]:Set(false)
	core.Controls["Aim lock selected target"]:Set(false)
	core.Restore("fov")
end)
core.Number(movement, "Walk speed", 1, 150, function(value)
	local _, humanoid = core.Root()
	assert(humanoid, "Character is not ready")
	core.Write("speed", humanoid, "WalkSpeed", value)
end)
core.Number(movement, "Jump power", 0, 200, function(value)
	local _, humanoid = core.Root()
	assert(humanoid, "Character is not ready")
	core.Write("jump", humanoid, "UseJumpPower", true)
	core.Write("jump", humanoid, "JumpPower", value)
end)
core.Number(movement, "Local gravity", 0, 300, function(value)
	core.Write("gravity", workspace, "Gravity", value)
end)
core.Toggle(movement, "Noclip", function(value)
	core.Job("Noclip", value, 0.1, function()
		local _, _, character = core.Root()
		if character then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					core.Write("noclip", part, "CanCollide", false)
				end
			end
		end
	end)
	if not value then
		core.Restore("noclip")
	end
end)
core.Toggle(movement, "Anti-sit", function(value)
	core.Job("Anti-sit", value, 0.2, function()
		local _, humanoid = core.Root()
		if humanoid and humanoid.Sit then
			humanoid.Sit = false
		end
	end)
end)
core.Button(movement, "Restore movement settings", function()
	core.Controls.Noclip:Set(false)
	core.Controls["Anti-sit"]:Set(false)
	for _, key in ipairs({ "speed", "jump", "gravity" }) do
		core.Restore(key)
	end
end)
local flightSpeed, vertical, untilTime = 45, 0, 0
local attachment, velocity, activeRoot
local function stopFlight()
	core.Stop("Fly")
	core.Release(velocity)
	core.Release(attachment)
	velocity, attachment, activeRoot = nil, nil, nil
end
core.Number(flight, "Flight speed", 1, 150, function(value)
	flightSpeed = value
end)
core.Toggle(flight, "Fly", function(value)
	stopFlight()
	if not value then
		return
	end
	core.Job("Fly", true, 0.05, function()
		local root, humanoid = core.Root()
		if not root or not humanoid then
			core.Release(velocity)
			core.Release(attachment)
			velocity, attachment, activeRoot = nil, nil, nil
			return
		end
		if root ~= activeRoot then
			core.Release(velocity)
			core.Release(attachment)
			attachment = core.Own(Instance.new("Attachment"))
			attachment.Name = "NULLFlightAttachment"
			attachment.Parent = root
			velocity = core.Own(Instance.new("LinearVelocity"))
			velocity.Name = "NULLFlightVelocity"
			velocity.Attachment0 = attachment
			velocity.MaxForce = 1000000
			velocity.RelativeTo = Enum.ActuatorRelativeTo.World
			velocity.Parent = root
			activeRoot = root
		end
		velocity.VectorVelocity = humanoid.MoveDirection * flightSpeed
			+ Vector3.new(0, os.clock() < untilTime and vertical or 0, 0)
	end)
end)
core.Button(flight, "Rise briefly", function()
	assert(velocity, "Enable Fly first")
	vertical, untilTime = flightSpeed, os.clock() + 0.6
end)
core.Button(flight, "Descend briefly", function()
	assert(velocity, "Enable Fly first")
	vertical, untilTime = -flightSpeed, os.clock() + 0.6
end)
flight:CreateText({
	name = "Desktop and touch movement",
	text = "Use normal movement input or the mobile thumbstick. Rise/Descend are native touch-sized controls. Flight recreates owned constraints after respawn; no external fly script is loaded.",
})
context.RegisterCleanup(stopFlight)
core.Toggle(visuals, "Player ESP", function(value)
	core.Job("Player ESP", value, 1, function(current)
		local records = {}
		for _, player in ipairs(players:GetPlayers()) do
			if player ~= core.Player and player.Character then
				table.insert(
					records,
					{ Object = player.Character, Text = player.DisplayName }
				)
			end
		end
		if current() then
			core.Markers(records)
		end
	end)
	if not value then
		core.ClearMarkers()
	end
end)
core.Toggle(visuals, "Reduced local lighting effects", function(value)
	if value then
		local lighting = game:GetService("Lighting")
		core.Write("lighting", lighting, "GlobalShadows", false)
		for _, effect in ipairs(lighting:GetChildren()) do
			if effect:IsA("PostEffect") then
				core.Write("lighting", effect, "Enabled", false)
			end
		end
	else
		core.Restore("lighting")
	end
end)
visuals:CreateText({
	name = "Reversible performance option",
	text = "No destructive map-wide FPS boost, quality-settings overwrite or game-instance deletion. Actual FPS and mobile behavior need Roblox testing.",
})
local saved
core.Button(navigation, "Save current location", function()
	local root = core.Root()
	assert(root, "Character is not ready")
	saved = root.CFrame
	core.Report("Location saved")
end)
core.Button(navigation, "Return to saved location", function()
	assert(saved, "Save a location first")
	core.Teleport(saved)
end)
core.Button(navigation, "Teleport to selected target", function()
	targetHumanoid()
	core.Teleport(target.Character)
end)
core.Button(navigation, "Teleport to cursor or last tap", function()
	local mouse = core.Player:GetMouse()
	assert(mouse and mouse.Target, "Point at a world surface first")
	core.Teleport(mouse.Hit)
end)
navigation:CreateText({
	name = "Explicit local navigation",
	text = "Only these buttons move your character. No server hopping, automatic game joins, external admin loaders or promotional actions.",
})
return core
