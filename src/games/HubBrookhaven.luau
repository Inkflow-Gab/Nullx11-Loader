-- Source feature/data adaptation: © Aetherion 2026; Chaos supplied source.
-- NULL native English editions. Source notices and scope retained in docs.
local core = context.HubCore(context)
local data = context.HubData
local storage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local avatar = core.Tab("Avatar and colors", "user")
local tools = core.Tab("Items and effects", "layers")
local home = core.Tab("Own house", "home")
local vehicles = core.Tab("Own vehicle", "car")
local navigation = core.Tab("Brookhaven locations", "map")
local movement = core.Tab("Local player", "activity")
local target
local function remote(folder, name)
	return core.Path(storage, folder .. "." .. name)
end
local function re(name, current, ...)
	return core.Request(current, remote("RE", name), ...)
end
core.Input(
	avatar,
	"Target username",
	"Unique username or display-name prefix",
	function(text)
		target = context.HubPolicy.Player(players:GetPlayers(), text)
		core.Report("Target: " .. target.Name)
	end
)
core.Toggle(avatar, "Spectate target", function(value)
	if value then
		assert(target and target.Parent, "Select a target first")
	end
	core.Job("Spectate target", value, 0.25, function()
		assert(target and target.Parent, "Target left the game")
		local humanoid = target.Character
			and target.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			core.Write(
				"spectate",
				workspace.CurrentCamera,
				"CameraSubject",
				humanoid
			)
		end
	end)
	if not value then
		core.Restore("spectate")
	end
end)
core.Button(avatar, "Apply target avatar", function()
	assert(
		target and target.Parent and target.Character,
		"Select a player with a character first"
	)
	local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
	assert(humanoid, "Target humanoid is unavailable")
	local description = humanoid:GetAppliedDescription()
	core.Job("Apply target avatar", true, 1, function(current)
		local body = {
			description.Torso,
			description.RightArm,
			description.LeftArm,
			description.RightLeg,
			description.LeftLeg,
			description.Head,
		}
		if
			not core.Request(
				current,
				remote("Remotes", "ChangeCharacterBody"),
				body
			)
		then
			return
		end
		local ids = {
			description.Shirt,
			description.Pants,
			description.Face,
			description.IdleAnimation,
		}
		for _, accessory in ipairs(description:GetAccessories(true)) do
			if #ids >= 24 then
				break
			end
			table.insert(ids, accessory.AssetId)
		end
		local seen = {}
		for _, id in ipairs(ids) do
			if not current() then
				return
			end
			if type(id) == "number" and id > 0 and not seen[id] then
				seen[id] = true
				if not core.Request(current, remote("Remotes", "Wear"), id) then
					return
				end
			end
		end
		core.Report(
			"Avatar requests dispatched; acceptance depends on the server. Existing accessories were not destructively removed."
		)
		core.Stop("Apply target avatar")
	end)
end)
core.Button(avatar, "Stop avatar requests", function()
	core.Stop("Apply target avatar")
end)
core.Input(avatar, "Roleplay name", "Up to 40 characters", function(text)
	assert(#text <= 40, "Name is too long")
	re("1RPNam1eTex1t", nil, "RolePlayName", text)
end)
core.Input(avatar, "Roleplay biography", "Up to 120 characters", function(text)
	assert(#text <= 120, "Biography is too long")
	re("1RPNam1eTex1t", nil, "RolePlayBio", text)
end)
for _, spec in ipairs({
	{ "Name RGB", "PickingRPNameColor" },
	{ "Biography RGB", "PickingRPBioColor" },
}) do
	local label, command = spec[1], spec[2]
	core.Toggle(avatar, label, function(value)
		core.Job(label, value, 2, function(current)
			re(
				"1RPNam1eColo1r",
				current,
				command,
				Color3.fromHSV((os.clock() * 0.1) % 1, 1, 1)
			)
		end)
	end)
end
if context.Entry.Id == "chaos_brookhaven" then
	-- English, bounded replacements for the supplied Portuguese RGB callbacks.
	local colors = {
		"Bright red",
		"Lime green",
		"Bright blue",
		"Bright yellow",
		"Bright cyan",
		"Hot pink",
		"Royal purple",
	}
	local cursor = 0
	core.Toggle(avatar, "Body RGB", function(value)
		core.Job("Body RGB", value, 2, function(current)
			cursor = cursor % #colors + 1
			core.Request(
				current,
				remote("Remotes", "ChangeBodyColor"),
				colors[cursor]
			)
		end)
	end)
	core.Toggle(avatar, "Hair RGB", function(value)
		core.Job("Hair RGB", value, 2, function(current)
			re(
				"1Max1y",
				current,
				"ChangeHairColor2",
				Color3.fromHSV((os.clock() * 0.1) % 1, 1, 1)
			)
		end)
	end)
end
avatar:CreateText({
	name = "Server-owned appearance",
	text = "Colors and avatar requests are explicit and paced. Stopping a loop prevents new requests; it does not undo changes already accepted by the server. No ownership/gamepass bypass is promised.",
})
for _, tool in ipairs(data.TOOLS_LIST) do
	local title, name, kind = tool[1], tool[2], tool[3]
	core.Button(tools, "Request " .. title, function()
		if kind == "Function" then
			re("1Too1l", nil, "PickingTools", name)
		else
			re(
				"1Playe1rTrigge1rEven1t",
				nil,
				"AcceptedToolToServer",
				name,
				core.Player
			)
		end
	end)
end
local effects, chosen = {}, data.EFFECTS[1]
for _, effect in ipairs(data.EFFECTS) do
	table.insert(effects, effect.name)
end
tools:CreateDropdown({
	name = "Avatar effect",
	options = effects,
	value = effects[1],
	callback = function(name)
		for _, effect in ipairs(data.EFFECTS) do
			if effect.name == name then
				chosen = effect
				break
			end
		end
	end,
})
core.Button(tools, "Request selected effect", function()
	core.Request(nil, remote("Remotes", "ApplyEmmiter"), chosen.id, chosen.code)
end)
core.Input(tools, "Music asset ID", "Positive numeric asset ID", function(text)
	local id = context.HubPolicy.Number(text, 1, 9007199254740991)
	assert(id % 1 == 0, "Asset ID must be an integer")
	-- One selected context only, never a burst to every music remote.
	re("PlayerToolEvent", nil, "ToolMusicText", tostring(id))
end)
core.Button(tools, "Stop tool music", function()
	re("PlayerToolEvent", nil, "ToolMusicText", "")
end)
core.Toggle(home, "Own house RGB", function(value)
	core.Job("Own house RGB", value, 2, function(current)
		re(
			"1Player1sHous1e",
			current,
			"ColorPickHouse",
			Color3.fromHSV((os.clock() * 0.1) % 1, 1, 1)
		)
	end)
end)
core.Toggle(home, "Own house text RGB", function(value)
	core.Job("Own house text RGB", value, 2, function(current)
		re(
			"1RPHous1eEven1tColo1r",
			current,
			"PickingBusinessNameColor",
			Color3.fromHSV((os.clock() * 0.1) % 1, 1, 1)
		)
	end)
end)
core.Input(
	home,
	"Own house business text",
	"Up to 60 characters",
	function(text)
		assert(#text <= 60, "Text is too long")
		re("1RPHous1eEven1t", nil, "BusinessName", text)
	end
)
core.Button(home, "Toggle own garage door", function()
	re("1Player1sHous1e", nil, "GarageDoor")
end)
core.Input(
	home,
	"Own house music asset ID",
	"Positive numeric asset ID",
	function(text)
		local id = context.HubPolicy.Number(text, 1, 9007199254740991)
		assert(id % 1 == 0, "Asset ID must be an integer")
		re("1Player1sHous1e", nil, "PickHouseMusicText", tostring(id))
	end
)
home:CreateText({
	name = "Own-house requests only",
	text = "No house-ban deletion, cross-house raids, repeated bell/garage spam or prop deletion. Server permissions still apply.",
})
local function ownSeat()
	local folder = workspace:FindFirstChild("Vehicles")
	local car = folder and folder:FindFirstChild(core.Player.Name .. "Car")
	local seat = car and car:FindFirstChildWhichIsA("VehicleSeat", true)
	assert(seat, "Your named vehicle and seat are unavailable")
	return seat
end
core.Number(vehicles, "Own vehicle maximum speed", 1, 300, function(value)
	local seat = ownSeat()
	local property = seat:FindFirstChild("MaxSpeed")
	if property and property:IsA("NumberValue") then
		core.Write("vehicle speed", property, "Value", value)
	else
		core.Write("vehicle speed", seat, "MaxSpeed", value)
	end
end)
core.Number(vehicles, "Own vehicle turbo", 0, 30, function(value)
	local turbo = ownSeat():FindFirstChild("Turbo")
	assert(
		turbo and turbo:IsA("NumberValue"),
		"This vehicle does not expose a numeric Turbo value"
	)
	core.Write("vehicle turbo", turbo, "Value", value)
end)
core.Toggle(vehicles, "Own vehicle RGB", function(value)
	core.Job("Own vehicle RGB", value, 2, function(current)
		ownSeat()
		local event = core.Path(
			core.Player,
			"PlayerGui.MainGUIHandler.VehicleControl.UIColorPicker.SetColor",
			"RemoteEvent"
		)
		core.Request(
			current,
			event,
			Color3.fromHSV((os.clock() * 0.1) % 1, 1, 1)
		)
	end)
end)
core.Button(vehicles, "Restore local vehicle edits", function()
	core.Restore("vehicle speed")
	core.Restore("vehicle turbo")
end)
vehicles:CreateText({
	name = "No server-wide car manipulation",
	text = "Only your username-named car is edited. Bring-all, kill-all, fling and seat-forcing routines are excluded. Local edits may be overwritten by the server.",
})
local names, selected = {}, data.TELEPORTS[1]
for _, location in ipairs(data.TELEPORTS) do
	table.insert(names, location[1])
end
navigation:CreateDropdown({
	name = "Location",
	options = names,
	value = names[1],
	callback = function(name)
		for _, location in ipairs(data.TELEPORTS) do
			if location[1] == name then
				selected = location
				break
			end
		end
	end,
})
core.Button(navigation, "Teleport to selected location", function()
	core.Teleport(selected[2])
	core.Report("Moved locally to " .. selected[1])
end)
core.Button(navigation, "Teleport to selected player", function()
	assert(
		target and target.Parent and target.Character,
		"Select a target first"
	)
	core.Teleport(target.Character)
end)
local saved
core.Button(navigation, "Save return point", function()
	local root = core.Root()
	assert(root, "Character is not ready")
	saved = root.CFrame
	core.Report("Return point saved")
end)
core.Button(navigation, "Return to saved point", function()
	assert(saved, "Save a return point first")
	core.Teleport(saved)
end)
navigation:CreateText({
	name = "Source coordinates",
	text = "22 English-named Brookhaven locations from the supplied sources. Coordinates may change when the game updates. These are local character moves, not game-launch teleports.",
})
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
core.Toggle(movement, "Anti-sit", function(value)
	core.Job("Anti-sit", value, 0.2, function()
		local _, humanoid = core.Root()
		if humanoid and humanoid.Sit then
			humanoid.Sit = false
		end
	end)
end)
core.Button(movement, "Restore local movement", function()
	core.Controls["Anti-sit"]:Set(false)
	for _, key in ipairs({ "speed", "jump", "gravity" }) do
		core.Restore(key)
	end
end)
return core
