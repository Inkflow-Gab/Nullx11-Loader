-- Source feature adaptation: © Aetherion 2026. Required notices retained.
-- Native NULL UI/runtime; user-reported adaptation permission, see provenance.
local core = context.HubCore(context)
local visuals = core.Tab("ESP", "eye")
local tools = core.Tab("Generator tools", "code")
local stamina = core.Tab("Sprint settings", "activity")
local flags =
	{ Players = false, Items = false, Generators = false, Medkits = false }
local storage = game:GetService("ReplicatedStorage")
local function map()
	local folder = workspace:FindFirstChild("Map")
	local ingame = folder and folder:FindFirstChild("Ingame")
	return ingame and ingame:FindFirstChild("Map")
end
local function refresh(current)
	local records = {}
	local function add(object, text, color)
		table.insert(records, { Object = object, Text = text, Color = color })
	end
	if flags.Players then
		local players = workspace:FindFirstChild("Players")
		for _, role in ipairs({ "Survivors", "Killers" }) do
			local folder = players and players:FindFirstChild(role)
			if folder then
				for _, character in ipairs(folder:GetChildren()) do
					if character ~= core.Player.Character then
						add(
							character,
							character.Name .. " / " .. role,
							role == "Killers" and Color3.fromRGB(255, 90, 90)
								or Color3.fromRGB(100, 240, 150)
						)
					end
				end
			end
		end
	end
	local level = map()
	local worldMap = workspace:FindFirstChild("Map")
	local ingame = worldMap and worldMap:FindFirstChild("Ingame")
	if flags.Items and ingame then
		for _, item in ipairs(ingame:GetChildren()) do
			if item.Name ~= "Map" then
				add(
					item,
					item.Name,
					flags.Medkits
							and item.Name == "Medkit"
							and Color3.fromRGB(255, 255, 255)
						or Color3.fromRGB(130, 210, 255)
				)
			end
		end
	end
	if level and flags.Generators then
		local objects = core.Scan(level, function(object)
			return (flags.Generators and object.Name == "Generator")
		end, current)
		for _, object in ipairs(objects) do
			if object.Name == "Generator" then
				local progress = object:FindFirstChild("Progress")
				local value = progress and tonumber(progress.Value) or 0
				add(
					object,
					"Generator / " .. math.floor(value) .. "%",
					value >= 100 and Color3.fromRGB(70, 180, 90)
						or Color3.fromRGB(255, 220, 90)
				)
			else
				add(object, object.Name, Color3.fromRGB(130, 210, 255))
			end
		end
	end
	if current() then
		core.Markers(records)
	end
end
local function update()
	local enabled = flags.Players or flags.Items or flags.Generators
	core.Job("ESP", enabled, 1, refresh)
	if not enabled then
		core.ClearMarkers()
	end
end
for _, name in ipairs({ "Players", "Items", "Generators", "Medkits" }) do
	core.Toggle(
		visuals,
		name == "Medkits" and "Prioritize medkits in item ESP" or name .. " ESP",
		function(value)
			flags[name] = value
			update()
		end
	)
end
visuals:CreateText({
	name = "Bounded overlays",
	text = "Up to 64 native markers; refreshed once per second while enabled. Generator progress is polled, not recursively reconnected.",
})
local nextSolve = 0
core.Button(tools, "Finish nearest generator puzzle", function()
	assert(
		os.clock() >= nextSolve,
		"Generator requests have a four-second cooldown"
	)
	local root = core.Root()
	assert(root, "Character is not ready")
	local level = map()
	assert(level, "No active map")
	local closest, distance = nil, math.huge
	for _, object in ipairs(level:GetChildren()) do
		if object.Name == "Generator" and object:IsA("Model") then
			local progress = object:FindFirstChild("Progress")
			local position = context.HubPolicy.Position(object)
			if position and (not progress or progress.Value < 100) then
				local delta = (position.Position - root.Position).Magnitude
				if delta < distance then
					closest, distance = object, delta
				end
			end
		end
	end
	assert(closest, "No unfinished generator found")
	local remote = core.Path(closest, "Remotes.RE", "RemoteEvent")
	nextSolve = os.clock() + 4
	core.Request(nil, remote)
end)
tools:CreateText({
	name = "Manual request only",
	text = "No cooldown bypass. The server decides whether you are solving a valid puzzle.",
})
local sprint
local function sprintModule()
	if not sprint then
		local node = core.Path(
			storage,
			"Systems.Character.Game.Sprinting",
			"ModuleScript"
		)
		local loaded = require(node)
		assert(context.Alive, "Session stopped")
		assert(type(loaded) == "table", "Unsupported Sprinting module")
		sprint = loaded
	end
	return sprint
end
core.Toggle(stamina, "Infinite stamina", function(value)
	if not value then
		core.Stop("Infinite stamina")
		core.Restore("stamina")
		return
	end
	sprintModule()
	core.Job("Infinite stamina", true, 1, function()
		core.Write("stamina", sprint, "StaminaLossDisabled", true)
	end)
end)
core.Number(stamina, "Sprinting speed", 1, 100, function(value)
	core.Write("sprint speed", sprintModule(), "SprintSpeed", value)
end)
core.Number(stamina, "Stamina gain rate", 0, 100, function(value)
	core.Write("stamina gain", sprintModule(), "StaminaGain", value)
end)
core.Button(stamina, "Restore sprint settings", function()
	local control = core.Controls["Infinite stamina"]
	control:Set(false)
	core.Restore("sprint speed")
	core.Restore("stamina gain")
end)
return core
