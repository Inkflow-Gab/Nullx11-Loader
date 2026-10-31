-- Nullx11 / Gab, adapted from VoidScripts' supplied smart-farming source.
-- Two workers at most: route movement and a serialized remote dispatcher.
local data = context.MoneyData
local player = game:GetService("Players").LocalPlayer
local storage = game:GetService("ReplicatedStorage")
local window = context.Adapter:CreateWindow({})
local state =
	{ Mode = "Off", Money = false, Rebirth = false, Evolve = false, Eggs = {} }
local routeRunning, remoteRunning = false, false
local lastClaim, claimUntil, claimTarget = nil, 0, nil
local farm = window:CreateTab({ name = "Smart farming", icon = "coin" })
local status = farm:CreateText({
	name = "+1 Money per Click / Gab",
	text = "Idle. All automation starts off. Source routing covers Worlds 1–4. One route mode owns movement at a time; server acceptance is not guaranteed.",
})
local lastStatus = ""
local function message(text)
	if text ~= lastStatus and context.Alive then
		lastStatus = text
		status:Set({ Title = "Session status", Desc = text })
	end
end
local function stats()
	local folder = player:FindFirstChild("leaderstats")
	local rebirth = folder
		and folder:FindFirstChild("Rebirth \240\159\148\132\239\184\143")
	local wins = folder and folder:FindFirstChild("Wins")
	return data.Parse(rebirth and rebirth.Value),
		data.Parse(wins and wins.Value)
end
local function remote(path, class)
	local node = storage
	for part in path:gmatch("[^.]+") do
		node = node and node:FindFirstChild(part)
	end
	return node and node:IsA(class) and node or nil
end
local function hasRemoteWork()
	if
		state.Mode == "Rebirths"
		or state.Money
		or state.Rebirth
		or state.Evolve
	then
		return true
	end
	for _, enabled in pairs(state.Eggs) do
		if enabled then
			return true
		end
	end
	return false
end
local function startRoute()
	if routeRunning or state.Mode == "Off" or not context.Alive then
		return
	end
	routeRunning = true
	task.spawn(function()
		while context.Alive and state.Mode ~= "Off" do
			local ok, reason = pcall(function()
				local character = player.Character
				local root = character
					and character:FindFirstChild("HumanoidRootPart")
				local rebirths, wins = stats()
				if not root or not rebirths then
					message("Waiting for character / readable Rebirth stat.")
					return
				end
				local position
				if state.Mode == "Rebirths" then
					position = data.RebirthPosition(rebirths)
				else
					local base, pad, world = data.CashPosition(rebirths, wins)
					if not base then
						message(
							"Waiting for a readable Wins stat; movement paused."
						)
						return
					end
					if pad ~= lastClaim then
						lastClaim = pad
						claimTarget = pad
						claimUntil = os.clock() + 0.3
					end
					position = (claimTarget and os.clock() < claimUntil)
							and claimTarget
						or base
					message(
						"Cash route / World "
							.. world
							.. ". Client movement requests only."
					)
				end
				if position then
					root.CFrame = CFrame.new(position)
				end
			end)
			if not ok then
				message("Route paused this tick: " .. tostring(reason))
			end
			task.wait(0.2)
		end
		routeRunning = false
	end)
end
local function startRemotes()
	if remoteRunning or not hasRemoteWork() or not context.Alive then
		return
	end
	remoteRunning = true
	task.spawn(function()
		local due, index = {}, 0
		while context.Alive and hasRemoteWork() do
			local jobs = {
				{
					Key = "Click",
					Path = "Remotes.ClickToEarn",
					Active = state.Money or state.Mode == "Rebirths",
					Delay = 0.15,
				},
				{
					Key = "Rebirth",
					Path = "RebirthRemote",
					Active = state.Rebirth or state.Mode == "Rebirths",
					Delay = 1,
				},
				{
					Key = "Evolve",
					Path = "EvolveRemote",
					Active = state.Evolve,
					Delay = 1,
				},
			}
			for _, egg in ipairs(data.eggPrices) do
				table.insert(jobs, {
					Key = egg.name,
					Path = "Events.CanOpenEgg",
					Active = state.Eggs[egg.name],
					Delay = 0.2,
					Egg = egg.name,
				})
			end
			-- Round-robin: selected eggs cannot starve clicks, rebirths or evolution.
			for _ = 1, #jobs do
				index = index % #jobs + 1
				local job = jobs[index]
				if job.Active and os.clock() >= (due[job.Key] or 0) then
					local target = remote(
						job.Path,
						job.Egg and "RemoteFunction" or "RemoteEvent"
					)
					due[job.Key] = os.clock() + job.Delay
					if target then
						local ok, reason = pcall(function()
							-- This is the only dispatcher. There is no queued send after a toggle
							-- changes; Send enforces the independent session's eight/sec budget.
							if job.Egg then
								context.Send(target, "InvokeServer", job.Egg, 3)
							else
								context.Send(target, "FireServer")
							end
						end)
						if not ok and context.Alive then
							message("Request error: " .. tostring(reason))
						end
					else
						message(
							"Unavailable remote: "
								.. job.Path
								.. ". No replacement action sent."
						)
					end
					break
				end
			end
			task.wait(0.15)
		end
		remoteRunning = false
	end)
end
local function start()
	startRoute()
	startRemotes()
end
local mode = farm:CreateDropdown({
	name = "Movement mode",
	options = { "Off", "Rebirths", "Cash" },
	value = "Off",
	callback = function(value)
		state.Mode = value
		lastClaim = nil
		claimTarget = nil
		claimUntil = 0
		message(
			value == "Off"
					and "Movement stopped. Other explicitly enabled jobs are independent."
				or value .. " mode selected."
		)
		start()
	end,
})
farm:CreateText({
	name = "Movement ownership",
	text = "Changing modes replaces the previous route, including pending cash-pad visits. Stopping does not teleport you back or undo a server action. Missing stats pause movement rather than guessing World 1.",
})
local auto = window:CreateTab({ name = "Automation", icon = "settings" })
local toggles = {}
for _, item in ipairs({
	{ "Money", "Auto money" },
	{ "Rebirth", "Auto rebirth" },
	{ "Evolve", "Auto evolve" },
}) do
	local key = item[1]
	toggles[key] = auto:CreateToggle({
		name = item[2],
		value = false,
		callback = function(value)
			state[key] = value
			start()
		end,
	})
end
auto:CreateSection({ name = "Eggs / spends Wins" })
auto:CreateText({
	name = "Explicit purchase requests",
	text = "Each selected egg requests three opens, using the source's argument. Prices below are source references, not live server quotes. Calls are serialized and share the eight/sec session cap.",
})
for _, egg in ipairs(data.eggPrices) do
	local name = egg.name
	toggles[name] = auto:CreateToggle({
		name = name .. " / " .. egg.price,
		value = false,
		callback = function(value)
			state.Eggs[name] = value
			start()
		end,
	})
end
local function stop()
	state.Mode = "Off"
	state.Money = false
	state.Rebirth = false
	state.Evolve = false
	table.clear(state.Eggs)
	lastClaim = nil
	claimTarget = nil
end
farm:CreateButton({
	name = "Stop all farming / purchases",
	callback = function()
		stop()
		mode:Set("Off")
		for _, control in pairs(toggles) do
			control:Set(false)
		end
		message(
			"All jobs stopped. An already-sent server request cannot be recalled."
		)
	end,
})
farm:CreateText({
	name = "Source credit",
	text = "Original smart-farming controller: VoidScripts / rscripts.net/@VoidScriptsDK. Nullx11 interface, worker ownership and integration by Gab. No Rayfield download or promotional startup actions.",
})
farm:CreateButton({
	name = "Unload this game workspace",
	callback = function()
		context.Library:Unload()
	end,
})
context.RegisterCleanup(stop)
return window
