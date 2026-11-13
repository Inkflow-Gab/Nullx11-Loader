-- Source feature adaptation: © Aetherion 2026. Native NULL collection edition.
local core = context.HubCore(context)
local players = game:GetService("Players")
local storage = game:GetService("ReplicatedStorage")
local visuals = core.Tab("Role and object ESP", "eye")
local weapons = core.Tab("Sheriff and knife tools", "target")
local navigation = core.Tab("Navigation and coins", "map")
local flags = { Players = false, Gun = false, Traps = false, HideSelf = false }
local playerData = {}
local gameplay = storage:FindFirstChild("Remotes")
gameplay = gameplay and gameplay:FindFirstChild("Gameplay")
local dataEvent = gameplay and gameplay:FindFirstChild("PlayerDataChanged")
if dataEvent and dataEvent:IsA("RemoteEvent") then
	context.Connect(dataEvent.OnClientEvent, function(data)
		if type(data) == "table" then
			playerData = data
		end
	end)
end
local function hasTool(player, name)
	local backpack = player:FindFirstChild("Backpack")
	return (player.Character and player.Character:FindFirstChild(name))
		or (backpack and backpack:FindFirstChild(name))
end
local function role(player)
	if hasTool(player, "Knife") then
		return "Murderer"
	end
	if hasTool(player, "Gun") then
		return "Sheriff / Hero"
	end
	local data = playerData[player.Name]
	if type(data) == "table" and not data.Dead then
		return data.Role or "Unknown"
	end
	return "Unknown"
end
local function findRole(name)
	for _, player in ipairs(players:GetPlayers()) do
		if role(player):find(name, 1, true) then
			return player
		end
	end
end
local function getMap()
	for _, object in ipairs(workspace:GetChildren()) do
		if
			(
				object:FindFirstChild("CoinContainer")
				and object:FindFirstChild("Spawns")
			) or object:FindFirstChild("GunDrop")
		then
			return object
		end
	end
	return nil
end
local function droppedGun()
	local level = getMap()
	return (level and level:FindFirstChild("GunDrop"))
		or workspace:FindFirstChild("GunDrop")
end
local function refresh(current)
	local records = {}
	if flags.Players then
		for _, player in ipairs(players:GetPlayers()) do
			if
				player.Character
				and not (flags.HideSelf and player == core.Player)
			then
				local label = role(player)
				local color = label == "Murderer"
						and Color3.fromRGB(255, 80, 80)
					or (
						label:find("Sheriff", 1, true)
							and Color3.fromRGB(95, 170, 255)
						or Color3.fromRGB(110, 235, 150)
					)
				table.insert(records, {
					Object = player.Character,
					Text = player.DisplayName .. " / " .. label,
					Color = color,
				})
			end
		end
	end
	if flags.Gun then
		local gun = droppedGun()
		if gun then
			table.insert(records, {
				Object = gun,
				Text = "Dropped gun",
				Color = Color3.fromRGB(255, 235, 75),
			})
		end
	end
	if flags.Traps then
		local traps = core.Scan(getMap() or workspace, function(object)
			return object.Name == "Trap"
		end, current)
		for _, trap in ipairs(traps) do
			if trap:IsA("BasePart") and trap.Transparency >= 1 then
				core.Write("traps", trap, "Transparency", 0.35)
			end
			table.insert(records, {
				Object = trap,
				Text = "Trap",
				Color = Color3.fromRGB(255, 125, 75),
			})
		end
	end
	if current() then
		core.Markers(records)
	end
end
local function update()
	local enabled = flags.Players or flags.Gun or flags.Traps
	core.Job("ESP", enabled, 0.75, refresh)
	if not enabled then
		core.ClearMarkers()
	end
end
for _, name in ipairs({ "Players", "Gun", "Traps", "HideSelf" }) do
	core.Toggle(
		visuals,
		name == "HideSelf" and "Hide my marker" or name .. " ESP",
		function(value)
			flags[name] = value
			if name == "Traps" and not value then
				core.Restore("traps")
			end
			update()
		end
	)
end
core.Button(visuals, "Identify current roles", function()
	local murderer, sheriff = findRole("Murderer"), findRole("Sheriff")
	core.Report(
		"Murderer: "
			.. (murderer and murderer.DisplayName or "unknown")
			.. " / Sheriff or hero: "
			.. (sheriff and sheriff.DisplayName or "unknown")
	)
end)
local lead = 0.15
core.Number(weapons, "Prediction lead (seconds)", 0, 1, function(value)
	lead = value
end)
local function equipped(name)
	local _, humanoid, character = core.Root()
	assert(humanoid and character, "Character is not ready")
	local tool = hasTool(core.Player, name)
	assert(tool and tool:IsA("Tool"), "You do not have the " .. name)
	if tool.Parent ~= character then
		humanoid:EquipTool(tool)
	end
	return tool, character
end
local function shoot(current)
	local murderer = findRole("Murderer")
	assert(
		murderer and murderer ~= core.Player,
		"No other murderer is identified"
	)
	local target = murderer.Character
		and murderer.Character:FindFirstChild("HumanoidRootPart")
	assert(target, "Murderer character is not ready")
	local gun, character = equipped("Gun")
	local hand = character:FindFirstChild("RightHand")
		or character:FindFirstChild("Right Arm")
		or character:FindFirstChild("HumanoidRootPart")
	assert(hand, "No firing origin")
	local position = target.Position + target.AssemblyLinearVelocity * lead
	core.Request(
		current,
		core.Path(gun, "Shoot", "RemoteEvent"),
		CFrame.new(hand.Position),
		CFrame.new(position)
	)
end
core.Button(weapons, "Shoot identified murderer", function()
	shoot(nil)
end)
core.Toggle(weapons, "Auto-shoot murderer", function(value)
	core.Job("Auto-shoot murderer", value, 1, shoot)
end)
local function throwKnife(current)
	local knife, character = equipped("Knife")
	local root = character:FindFirstChild("HumanoidRootPart")
	local nearest, distance = nil, math.huge
	for _, player in ipairs(players:GetPlayers()) do
		local target = player.Character
			and player.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = player.Character
			and player.Character:FindFirstChildOfClass("Humanoid")
		if
			player ~= core.Player
			and root
			and target
			and humanoid
			and humanoid.Health > 0
		then
			local delta = (target.Position - root.Position).Magnitude
			if delta < distance then
				nearest, distance = target, delta
			end
		end
	end
	assert(nearest and root, "No valid nearby player")
	local hand = character:FindFirstChild("RightHand")
		or character:FindFirstChild("Right Arm")
		or root
	core.Request(
		current,
		core.Path(knife, "Events.KnifeThrown", "RemoteEvent"),
		CFrame.new(hand.Position),
		CFrame.new(nearest.Position + nearest.AssemblyLinearVelocity * lead)
	)
end
core.Button(weapons, "Throw knife toward nearest player", function()
	throwKnife(nil)
end)
core.Toggle(weapons, "Auto knife throw", function(value)
	core.Job("Auto knife throw", value, 1.5, throwKnife)
end)
weapons:CreateText({
	name = "Reviewed weapon paths",
	text = "Uses the supplied Gun.Shoot and Knife.Events.KnifeThrown protocols. Missing role, tool or remote stops the feature. External AI prediction, namecall hooks, mass-kill and fling routines are not included.",
})
core.Button(navigation, "Teleport to dropped gun", function()
	local gun = droppedGun()
	assert(gun, "No dropped gun found")
	core.Teleport(gun)
end)
core.Button(navigation, "Teleport to current map", function()
	local level = getMap()
	assert(level, "No current map found")
	core.Teleport(level)
end)
local saved
core.Button(navigation, "Save return point", function()
	local root = core.Root()
	assert(root, "Character is not ready")
	saved = root.CFrame
	core.Report("Return point saved")
end)
core.Button(navigation, "Return to saved point", function()
	assert(saved, "Save a point first")
	core.Teleport(saved)
end)
local tween
local skipped = setmetatable({}, { __mode = "k" })
local function stopCoins()
	core.Stop("Collect nearby coins")
	if tween then
		tween:Cancel()
		tween = nil
	end
end
core.Toggle(navigation, "Collect nearby coins", function(value)
	stopCoins()
	if not value then
		return
	end
	core.Job("Collect nearby coins", true, 0.4, function(current)
		local root = core.Root()
		local level = getMap()
		local coins = level and level:FindFirstChild("CoinContainer")
		if not root or not coins then
			return
		end
		local nearest, target, distance = nil, nil, 500
		for index, coin in ipairs(coins:GetChildren()) do
			if index > 256 then
				break
			end
			local position = context.HubPolicy.Position(coin)
			if
				position and (not skipped[coin] or os.clock() >= skipped[coin])
			then
				local delta = (position.Position - root.Position).Magnitude
				if delta < distance then
					nearest, target, distance = coin, position, delta
				end
			end
		end
		if not nearest then
			return
		end
		tween = game:GetService("TweenService"):Create(
			root,
			TweenInfo.new(
				math.clamp(distance * 0.05, 0.1, 5),
				Enum.EasingStyle.Linear
			),
			{ CFrame = target }
		)
		tween:Play()
		while
			current()
			and root.Parent
			and tween.PlaybackState == Enum.PlaybackState.Playing
		do
			task.wait(0.05)
		end
		if tween then
			tween:Cancel()
			tween = nil
		end
		if current() then
			skipped[nearest] = os.clock() + 10
		end
	end)
end)
context.RegisterCleanup(stopCoins)
navigation:CreateText({
	name = "No fake coin collection",
	text = "Moves toward at most 256 candidates within 500 studs. Does not delete coins or claim currency; server-side collection is authoritative.",
})
return core
