-- StealAnEgg-CHILI / Nullx11 by Gab.
-- Recovered-core adaptation, NOT a full devirtualization of the uploaded VM.
-- Original supplied Chilli SAE source/provenance: docs/CHILI-EGG-REVIEW.md.
local policy = context.ChiliPolicy
local storage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local library = context.Library
local window = context.Adapter:CreateWindow({})
local settings = {
	Carry = false,
	Return = false,
	ESP = false,
	Away = false,
	Index = false,
	Base = false,
	Treadmill = false,
	Trail = false,
	MinRank = 0,
	MinValue = 0,
	Name = "",
	Order = "Highest value",
}
local modules, controls = {}, {}
local generation = 0
local running, pending = false, nil
local entries, delivery, returnedUid = {}, nil, nil
local cooldowns, due = {}, {}
local overlay, labels, espConnection = nil, {}, nil
local scanAt = 0
local field = window:CreateTab({ name = "Recovered egg core", icon = "egg" })
local status = field:CreateText({
	name = "StealAnEgg-CHILI / recovered core",
	text = "Idle. This partial input still contains a VM. Only recovered, independently implemented controls are enabled here; no vendor loader is executed.",
})
local lastMessage = ""
local function report(message)
	if context.Alive and message ~= lastMessage then
		lastMessage = message
		status:Set({ Title = "Recovered-core status", Desc = message })
	end
end
local function getModule(path, optional)
	if modules[path] then
		return modules[path]
	end
	local node = storage
	for part in path:gmatch("[^.]+") do
		node = node and node:FindFirstChild(part)
	end
	if not node or not node:IsA("ModuleScript") then
		if optional then
			return nil
		end
		error("Required game module unavailable: " .. path)
	end
	local result = require(node)
	if not context.Alive then
		return nil
	end
	assert(type(result) == "table", "Unsupported game module: " .. path)
	modules[path] = result
	return result
end
local function root()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local part = character and character:FindFirstChild("HumanoidRootPart")
	return humanoid and humanoid.Health > 0 and part or nil
end
local function fieldRecords()
	local eggs = getModule("Client.EggState")
	if not eggs or not context.Alive then
		return {}
	end
	assert(
		type(eggs.ReadFieldEggs) == "function",
		"EggState.ReadFieldEggs unavailable"
	)
	local snapshot = eggs.ReadFieldEggs()
	assert(
		type(snapshot) == "table" and type(snapshot.Records) == "table",
		"Unsupported field-egg snapshot"
	)
	return snapshot.Records
end
local function scan(force)
	if not force and os.clock() < scanAt then
		return entries
	end
	scanAt = os.clock() + 0.5
	local records = fieldRecords()
	local assets = getModule("Data.Assets")
	local mutations = getModule("Shared.Modules.Mutations", true)
	if not context.Alive then
		return {}
	end
	local part = root()
	local fresh, visited = {}, 0
	for _, record in pairs(records) do
		visited += 1
		if visited > 512 then
			break
		end
		if
			type(record) == "table"
			and (
				record.State == nil
				or record.State == "Slot"
				or record.State == "Dropped"
			)
		then
			local info = policy.Describe(record, assets, mutations)
			if
				info
				and policy.Match(info, settings)
				and typeof(record.BottomCFrame) == "CFrame"
			then
				info.Position = record.BottomCFrame.Position
				if record.State == "Dropped" then
					local folder =
						workspace:FindFirstChild("AreaEggSlotsClient")
					local model = workspace:FindFirstChild(record.Uid)
						or (folder and folder:FindFirstChild(record.Uid))
					if model and model:IsA("Model") then
						info.Position = model:GetPivot().Position
					end
				end
				info.Distance = part
						and (info.Position - part.Position).Magnitude
					or nil
				table.insert(fresh, info)
			end
		end
	end
	entries = policy.Sort(fresh, settings.Order)
	return entries
end
local function still(token, predicate)
	return context.Alive
		and token == generation
		and (not predicate or predicate())
end
local function request(token, action, predicate)
	if not still(token, predicate) then
		return nil, "cancelled"
	end
	local packages = storage:FindFirstChild("Packages")
	local network = packages and packages:FindFirstChild("Networking")
	local remote = network and network:FindFirstChild(action.Remote)
	local class = action.Method == "InvokeServer" and "RemoteFunction"
		or "RemoteEvent"
	assert(
		remote and remote:IsA(class),
		"Unavailable game remote: " .. action.Remote
	)
	return context.SendWhen(function()
		return still(token, predicate)
	end, remote, action.Method, table.unpack(action.Args))
end
local function eggRequest(token, method, args, predicate)
	local eggs = getModule("Client.EggState")
	if not eggs or not still(token, predicate) then
		return nil, "cancelled"
	end
	assert(
		type(eggs[method]) == "function",
		"EggState." .. method .. " unavailable"
	)
	local adapter = {
		Invoke = function(_, ...)
			return eggs[method](...)
		end,
	}
	return context.SendWhen(function()
		return still(token, predicate)
	end, adapter, "Invoke", table.unpack(args))
end
local function carried()
	for _, record in pairs(fieldRecords()) do
		if
			type(record) == "table"
			and record.State == "Carried"
			and tonumber(record.CarrierUserId) == player.UserId
		then
			return record.Uid
		end
	end
end
local function returnCarried(token)
	if
		not delivery
		or not still(token, function()
			return settings.Return
		end)
	then
		return
	end
	local uid = carried()
	if not still(token, function()
		return settings.Return
	end) then
		return
	end
	if not uid then
		returnedUid = nil
		return
	end
	local part = root()
	if uid ~= returnedUid and part and not part.Anchored then
		part.CFrame = delivery
		returnedUid = uid
		report(
			"Returned to your saved delivery point with "
				.. tostring(uid)
				.. ". Waiting for the server; delivery is not assumed."
		)
	end
end
local function carryNearby(token)
	local list = scan(false)
	for uid, deadline in pairs(cooldowns) do
		if deadline < os.clock() then
			cooldowns[uid] = nil
		end
	end
	if
		not still(token, function()
			return settings.Carry
		end) or carried()
	then
		return
	end
	local part = root()
	if not part or part.Anchored then
		return
	end
	for _, info in ipairs(list) do
		if
			(info.Position - part.Position).Magnitude <= 12
			and os.clock() >= (cooldowns[info.Uid] or 0)
		then
			-- Re-read immediately before a budgeted request; do not act on stale carried eggs.
			local eligible = false
			local freshRecord
			for _, record in pairs(fieldRecords()) do
				if type(record) == "table" and record.Uid == info.Uid then
					freshRecord = record
					eligible = record.State == nil
						or record.State == "Slot"
						or record.State == "Dropped"
					break
				end
			end
			if
				not eligible
				or not still(token, function()
					return settings.Carry
				end)
			then
				return
			end
			cooldowns[info.Uid] = os.clock() + 3
			local result, reason = eggRequest(
				token,
				"CarryFieldEgg",
				policy.CarryArgs(freshRecord),
				function()
					return settings.Carry
				end
			)
			if still(token, function()
				return settings.Carry
			end) then
				report(
					result == false and ("Carry rejected: " .. tostring(reason))
						or (
							"Carry requested for "
							.. info.Name
							.. ". Field state/verdict, not pcall alone, determines the result."
						)
				)
			end
			return
		end
	end
end
local function progress(token, kind)
	local active = function()
		return settings[kind]
	end
	if not still(token, active) then
		return
	end
	if kind == "Away" then
		local summary = request(token, {
			Remote = "RF/AwayEarnings/FetchSummary",
			Method = "InvokeServer",
			Args = {},
		}, active)
		if
			still(token, active)
			and type(summary) == "table"
			and (tonumber(summary.ClaimableAmount) or 0) > 0
		then
			request(token, {
				Remote = "RF/AwayEarnings/AskCollect",
				Method = "InvokeServer",
				Args = { { Kind = "Claim" } },
			}, active)
		end
	else
		local save = getModule("Shared.Save")
		assert(save and type(save.Peek) == "function", "Save.Peek unavailable")
		local paths = {
			Base = "Data.Bases",
			Treadmill = "Data.Treadmills",
			Trail = "Data.Trails",
		}
		local data = paths[kind] and getModule(paths[kind]) or nil
		if not still(token, active) then
			return
		end
		local action = policy.Progress(kind, save.Peek(), data)
		if action then
			request(token, action, active)
		end
	end
end
local function active()
	if pending then
		return true
	end
	for _, key in ipairs({
		"Carry",
		"Return",
		"ESP",
		"Away",
		"Index",
		"Base",
		"Treadmill",
		"Trail",
	}) do
		if settings[key] then
			return true
		end
	end
	return false
end
local function start()
	if running or not context.Alive or not active() then
		return
	end
	running = true
	task.spawn(function()
		local rotation = 0
		while context.Alive and active() do
			local token = generation
			local ok, reason = pcall(function()
				if pending then
					local action = pending
					pending = nil
					if action == "Refresh" then
						local list = scan(true)
						local top = list[1]
						report(
							string.format(
								"%d matching eggs / top: %s. Values are source-formula estimates, not server quotes.",
								#list,
								top
										and (top.Name .. " / " .. string.format(
											"%.2f",
											top.Value
										) .. " per second")
									or "none"
							)
						)
					elseif action == "Drop" then
						eggRequest(token, "DropFieldEgg", { "PlayerRequest" })
						if still(token) then
							report("Drop requested. Check the server state.")
						end
					end
				end
				if not still(token) then
					return
				end
				if settings.ESP then
					scan(false)
				end
				if settings.Return then
					returnCarried(token)
				end
				if settings.Carry then
					carryNearby(token)
				end
				local kinds = { "Away", "Index", "Base", "Treadmill", "Trail" }
				for _ = 1, #kinds do
					rotation = rotation % #kinds + 1
					local kind = kinds[rotation]
					if settings[kind] and os.clock() >= (due[kind] or 0) then
						due[kind] = os.clock() + 5
						progress(token, kind)
						break
					end
				end
			end)
			if not ok then
				report("Unavailable / paused this tick: " .. tostring(reason))
			end
			task.wait(0.5)
		end
		running = false
	end)
end
local function clearESP()
	if espConnection then
		espConnection:Disconnect()
		espConnection = nil
	end
	if overlay then
		overlay:Destroy()
		overlay = nil
	end
	table.clear(labels)
end
local function setESP(value)
	if not value then
		clearESP()
		return
	end
	if espConnection then
		return
	end
	local host = library:GetOverlayHost()
	assert(host and host.Parent, "Native overlay host unavailable")
	overlay = Instance.new("ScreenGui")
	overlay.Name = "Nullx11ChiliEggESP"
	overlay.IgnoreGuiInset = true
	overlay.ResetOnSpawn = false
	overlay.DisplayOrder = 105
	overlay.Parent = host.Parent
	local nextFrame = 0
	for index = #context.Connections, 1, -1 do
		if not context.Connections[index].Connected then
			table.remove(context.Connections, index)
		end
	end
	espConnection = context.Connect(runService.RenderStepped, function()
		if os.clock() < nextFrame or not settings.ESP then
			return
		end
		nextFrame = os.clock() + 1 / 30
		local camera = workspace.CurrentCamera
		local used = 0
		if camera then
			for index = 1, math.min(24, #entries) do
				local info = entries[index]
				local point, onScreen =
					camera:WorldToViewportPoint(info.Position)
				if onScreen and point.Z > 0 then
					used += 1
					local label = labels[used]
					if not label then
						label = Instance.new("TextLabel")
						label.Name = "Egg" .. used
						label.BackgroundTransparency = 1
						label.Size = UDim2.fromOffset(240, 44)
						label.AnchorPoint = Vector2.new(0.5, 1)
						label.Font = Enum.Font.GothamMedium
						label.TextSize = 14
						label.TextColor3 = Color3.fromRGB(157, 230, 224)
						label.TextStrokeTransparency = 0.25
						label.TextWrapped = true
						label.Parent = overlay
						labels[used] = label
					end
					label.Text = info.Name
						.. " / "
						.. string.format("%.1f", info.Value)
						.. " per second"
					label.Position = UDim2.fromOffset(point.X, point.Y)
					label.Visible = true
				end
			end
		end
		for index = used + 1, #labels do
			labels[index].Visible = false
		end
	end)
end
local function toggle(tab, key, name)
	controls[key] = tab:CreateToggle({
		name = name,
		flag = "Chili" .. key,
		value = false,
		callback = function(value)
			generation += 1
			settings[key] = value
			if key == "Return" and not value then
				returnedUid = nil
			end
			if key == "ESP" then
				local ok, reason = pcall(setESP, value)
				if not ok then
					clearESP()
					report(tostring(reason))
				end
			end
			start()
		end,
	})
end
local function queue(action)
	if pending or running then
		if pending then
			report(
				"An explicit action is already pending; no extra worker queued."
			)
			return
		end
	end
	pending = action
	start()
end
field:CreateText({
	name = "Recovery boundary",
	text = "Nearby carry uses the recovered EggState method within 12 studs. It does not promise the original VM-dependent stealing/delivery modes. Use the original Steal An Egg entry separately for that port's feature set.",
})
toggle(field, "Carry", "Auto carry nearby matching eggs")
toggle(field, "Return", "Return with carried egg / needs saved point")
toggle(field, "ESP", "Field egg labels / native GUI")
field:CreateDropdown({
	name = "Priority",
	options = {
		"Highest value",
		"Lowest value",
		"Best rarity",
		"Biggest",
		"Closest",
	},
	value = "Highest value",
	callback = function(value)
		settings.Order = value
		scanAt = 0
		generation += 1
	end,
})
local rarities = { "Any" }
for _, name in ipairs(policy.Rarities) do
	table.insert(rarities, name)
end
field:CreateDropdown({
	name = "Minimum rarity",
	options = rarities,
	value = "Any",
	callback = function(value)
		settings.MinRank = table.find(policy.Rarities, value) or 0
		scanAt = 0
		generation += 1
	end,
})
field:CreateInput({
	name = "Minimum estimated value per second",
	value = "0",
	callback = function(value)
		local number = tonumber(value)
		if not number or number < 0 or number >= math.huge then
			report("Enter a finite, non-negative numeric value.")
			return
		end
		settings.MinValue = number
		scanAt = 0
		generation += 1
	end,
})
field:CreateInput({
	name = "Egg name / category contains",
	value = "",
	callback = function(value)
		settings.Name = value
		scanAt = 0
		generation += 1
	end,
})
field:CreateButton({
	name = "Refresh matching egg summary",
	callback = function()
		queue("Refresh")
	end,
})
field:CreateButton({
	name = "Save this delivery position",
	callback = function()
		local part = root()
		if not part then
			report("A live character is required to save a point.")
			return
		end
		delivery = part.CFrame
		returnedUid = nil
		report(
			"Delivery point saved for this session. Return movement is opt-in; it does not guarantee a redemption."
		)
	end,
})
field:CreateButton({
	name = "Drop carried egg / explicit request",
	callback = function()
		queue("Drop")
	end,
})
local progression =
	window:CreateTab({ name = "Recovered progression", icon = "anvil" })
progression:CreateText({
	name = "Optional jobs / spends game currency",
	text = "Each job checks source save/data fields before sending its exact recovered request. Default off, five-second per-job cooldown and a shared eight/sec routed-call budget. Trail, base and treadmill upgrades spend Money.",
})
for _, item in ipairs({
	{ "Away", "Claim available away earnings" },
	{ "Index", "Claim available basic index rewards" },
	{ "Base", "Auto upgrade base" },
	{ "Treadmill", "Auto upgrade treadmill" },
	{ "Trail", "Buy cheapest affordable unowned trail" },
}) do
	toggle(progression, item[1], item[2])
end
local function stop()
	generation += 1
	pending = nil
	for _, key in ipairs({
		"Carry",
		"Return",
		"ESP",
		"Away",
		"Index",
		"Base",
		"Treadmill",
		"Trail",
	}) do
		settings[key] = false
	end
	clearESP()
	entries = {}
	table.clear(cooldowns)
end
field:CreateButton({
	name = "Stop all recovered jobs",
	callback = function()
		stop()
		for _, control in pairs(controls) do
			control:Set(false)
		end
		report(
			"All jobs stopped. Already-sent server requests and previous movement cannot be recalled."
		)
	end,
})
local about = window:CreateTab({ name = "Recovery & credits", icon = "info" })
about:CreateText({
	name = "Not recovered / intentionally unavailable",
	text = "The remaining VM-driven event/boss chains, full steal/tween/guard routines, fuse/sell/mutation pipelines, prediction/finder/account integrations and cross-server automation are not claimed recovered. No empty feature toggles are supplied. No external Chilli API, luarmor/Venyx loader, webhook or teleport queue is executed.",
})
about:CreateText({
	name = "Source provenance",
	text = "User-supplied partial Chilli SAE artifact; Chilli authorship retained, complete license/recovery README not supplied. Nullx11 GUI and independently implemented recovered core by Gab. This is a separate session from the existing Henrik/xyzhenrik Steal An Egg port.",
})
about:CreateButton({
	name = "Unload StealAnEgg-CHILI",
	callback = function()
		library:Unload()
	end,
})
context.RegisterCleanup(function()
	stop()
	delivery = nil
	table.clear(modules)
	table.clear(due)
end)
return window
