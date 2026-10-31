-- Source feature adaptation: © Aetherion 2026. See retained source notices.
local core = context.HubCore(context)
local visuals = core.Tab("ESP", "eye")
local movement = core.Tab("Movement and light", "activity")
local flags = {
	Players = false,
	PCs = false,
	Pods = false,
	Exits = false,
	Lockers = false,
	Labels = false,
}
local function refresh(current)
	local records = {}
	local function add(object, text, color)
		table.insert(records, {
			Object = object,
			Text = text,
			Color = color,
			Label = flags.Labels,
		})
	end
	if flags.Players then
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player ~= core.Player and player.Character then
				local stats = player:FindFirstChild("TempPlayerStatsModule")
				local beast = stats and stats:FindFirstChild("IsBeast")
				local isBeast = player.Character:FindFirstChild("BeastPowers")
						~= nil
					or (beast and beast.Value)
				add(
					player.Character,
					player.DisplayName
						.. (isBeast and " / Beast" or " / Survivor"),
					isBeast and Color3.fromRGB(255, 85, 85)
						or Color3.fromRGB(90, 235, 130)
				)
			end
		end
	end
	if flags.Lockers then
		for _, locker in
			ipairs(game:GetService("CollectionService"):GetTagged("LOCKER"))
		do
			add(locker, "Locker", Color3.fromRGB(255, 100, 175))
		end
	end
	local wanted = {
		ComputerTable = flags.PCs,
		FreezePod = flags.Pods,
		ExitDoor = flags.Exits,
	}
	if flags.PCs or flags.Pods or flags.Exits then
		local objects = core.Scan(workspace, function(object)
			return wanted[object.Name] == true
		end, current)
		for _, object in ipairs(objects) do
			local color = Color3.fromRGB(100, 210, 255)
			if object.Name == "ComputerTable" then
				local screen = object:FindFirstChild("Screen")
				color = screen and screen:IsA("BasePart") and screen.Color
					or color
			elseif object.Name == "ExitDoor" then
				color = Color3.fromRGB(255, 220, 80)
			end
			add(object, object.Name, color)
		end
	end
	if current() then
		core.Markers(records)
	end
end
local function update()
	local enabled = flags.Players
		or flags.PCs
		or flags.Pods
		or flags.Exits
		or flags.Lockers
	core.Job("ESP", enabled, 1.5, refresh)
	if not enabled then
		core.ClearMarkers()
	end
end
for _, name in ipairs({ "Players", "PCs", "Pods", "Exits", "Lockers" }) do
	core.Toggle(visuals, name .. " ESP", function(value)
		flags[name] = value
		update()
	end)
end
core.Toggle(visuals, "Show labels", function(value)
	flags.Labels = value
	update()
end)
visuals:CreateText({
	name = "Scan limits",
	text = "Native highlights, at most 64 markers and 6,000 visited world nodes per scan; yields every 200 nodes. No off-screen arrow renderer is loaded.",
})
local light
core.Toggle(movement, "Flashlight", function(value)
	core.Stop("Flashlight")
	core.Release(light)
	light = nil
	if value then
		core.Job("Flashlight", true, 0.5, function()
			local root = core.Root()
			if root and (not light or light.Parent ~= root) then
				core.Release(light)
				light = core.Own(Instance.new("PointLight"))
				light.Name = "NULLFlashlight"
				light.Brightness = 2.5
				light.Range = 60
				light.Parent = root
			end
		end)
	end
end)
local speed = 18
core.Number(movement, "Walk speed", 1, 100, function(value)
	speed = value
end)
core.Toggle(movement, "Lock walk speed", function(value)
	core.Job("Lock walk speed", value, 0.2, function()
		local _, humanoid = core.Root()
		if humanoid then
			core.Write("speed", humanoid, "WalkSpeed", speed)
		end
	end)
	if not value then
		core.Restore("speed")
	end
end)
core.Toggle(movement, "Third-person camera", function(value)
	if value then
		core.Write("camera", core.Player, "CameraMode", Enum.CameraMode.Classic)
		core.Write("camera", core.Player, "CameraMaxZoomDistance", 400)
	else
		core.Restore("camera")
	end
end)
movement:CreateText({
	name = "Anti-PC error not ported",
	text = "The supplied implementation installs a process-wide namecall hook and checks a different variable than its control changes. No global hook or fake-success replacement is installed here.",
})
return core
