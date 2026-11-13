-- NULL native collection runtime. No vendor UI, shared globals, ads or code fetches.
-- Jobs are demand-driven and generation-scoped; patches and overlays are owned.
return function(context)
	local core = {
		Context = context,
		Jobs = {},
		Controls = {},
		Instances = {},
		Generation = 0,
	}
	local policy, patches = context.HubPolicy, context.Patches
	local player = game:GetService("Players").LocalPlayer
	core.Player = player
	core.Window = context.Adapter:CreateWindow({})
	local overview =
		core.Window:CreateTab({ name = "Overview", icon = "layers" })
	core.Status = overview:CreateText({
		name = "NULL / ready",
		text = "Idle. Features start off. Requests are paced; server acceptance is not guaranteed.",
	})
	overview:CreateText({
		name = "Reviewed collection",
		text = context.Entry.Description
			.. " This is a native feature port, not execution of the entire upstream hub. See docs/HUB-COLLECTION-REVIEW.md for the inclusion/exclusion matrix.",
	})
	overview:CreateText({
		name = "Independent workspace",
		text = "This game window survives loader unload. Unload here to stop its jobs and restore owned local changes. Requests already accepted by a server cannot be undone.",
	})
	function core.Report(message)
		if context.Alive then
			core.Status:Set({
				Title = "NULL / session status",
				Desc = tostring(message),
			})
		end
	end
	function core.Guard(callback, ...)
		if not context.Alive then
			return false
		end
		local result = table.pack(pcall(callback, ...))
		if not result[1] then
			core.Report(result[2])
		end
		return table.unpack(result, 1, result.n)
	end
	function core.Tab(name, icon)
		return core.Window:CreateTab({ name = name, icon = icon or "code" })
	end
	function core.Button(tab, label, callback)
		local busy = false
		return tab:CreateButton({
			name = label,
			callback = function()
				if busy then
					core.Report("This action is already pending")
					return
				end
				busy = true
				core.Guard(callback)
				busy = false
			end,
		})
	end
	function core.Toggle(tab, label, callback)
		local control
		control = tab:CreateToggle({
			name = label,
			value = false,
			callback = function(value)
				if not context.Alive then
					return
				end
				local ok = core.Guard(callback, value)
				if not ok and value and control then
					control:Set(false)
				end
			end,
		})
		core.Controls[label] = control
		return control
	end
	function core.Input(tab, label, placeholder, callback)
		return tab:CreateInput({
			name = label,
			placeholder = placeholder,
			callback = function(text)
				core.Guard(callback, text)
			end,
		})
	end
	function core.Number(tab, label, low, high, callback)
		return core.Input(
			tab,
			label,
			tostring(low) .. " to " .. tostring(high),
			function(text)
				callback(policy.Number(text, low, high))
			end
		)
	end
	function core.Root()
		local character = player.Character
		local humanoid = character
			and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or humanoid.Health <= 0 then
			return nil, nil, nil
		end
		return root, humanoid, character
	end
	function core.Path(root, path, class)
		local node = root
		for name in path:gmatch("[^.]+") do
			node = node and node:FindFirstChild(name)
		end
		assert(
			node and (not class or node:IsA(class)),
			"Unavailable game object: " .. path
		)
		return node
	end
	function core.Write(category, object, key, value)
		assert(object, "Object is unavailable")
		patches.Write(category, object, key, value)
	end
	core.Restore = patches.Restore
	function core.Own(instance)
		core.Instances[instance] = true
		return instance
	end
	function core.Release(instance)
		if instance then
			core.Instances[instance] = nil
			instance:Destroy()
		end
	end
	function core.Stop(key)
		local job = core.Jobs[key]
		if not job then
			return
		end
		core.Jobs[key] = nil
		if job.Thread and job.Thread ~= coroutine.running() then
			pcall(task.cancel, job.Thread)
		end
	end
	function core.Job(key, enabled, interval, callback)
		core.Stop(key)
		if not enabled or not context.Alive then
			return
		end
		local job = {}
		core.Jobs[key] = job
		local function current()
			return context.Alive and core.Jobs[key] == job
		end
		job.Thread = task.defer(function()
			while current() do
				local ok = core.Guard(callback, current)
				if not ok then
					core.Stop(key)
					local control = core.Controls[key]
					if control then
						control:Set(false)
					end
					break
				end
				if current() then
					task.wait(math.max(interval, 0.05))
				end
			end
		end)
	end
	function core.Request(predicate, remote, ...)
		assert(
			remote
				and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")),
			"Expected game remote is unavailable"
		)
		local method = remote:IsA("RemoteFunction") and "InvokeServer"
			or "FireServer"
		local result, reason = context.SendWhen(predicate or function()
			return context.Alive
		end, remote, method, ...)
		if reason == "cancelled" then
			return false
		end
		core.Report("Request dispatched. Server acceptance is not verified.")
		return true, result
	end
	function core.Teleport(object)
		local root = core.Root()
		assert(root, "Character is not ready")
		local target = typeof(object) == "CFrame" and object
			or policy.Position(object)
		assert(target, "No valid destination")
		root.CFrame = typeof(object) == "CFrame" and target
			or target + Vector3.new(0, 3, 0)
	end
	-- Bounded, yielding traversal, used only by explicitly enabled tools. A scan
	-- returns partial coverage at its cap, never destroys or reparents game nodes.
	function core.Scan(root, accept, current, limit)
		local queue, found, cursor = { root }, {}, 1
		local cap = limit or 6000
		while cursor <= #queue and cursor <= cap do
			if not context.Alive or (current and not current()) then
				return {}
			end
			local object = queue[cursor]
			if object.Parent or object == root then
				if accept(object) then
					table.insert(found, object)
				end
				for _, child in ipairs(object:GetChildren()) do
					if #queue >= cap then
						break
					end
					table.insert(queue, child)
				end
			end
			if cursor % 200 == 0 then
				task.wait()
			end
			cursor += 1
		end
		return found
	end
	local overlay = nil
	local markers = {}
	function core.ClearMarkers()
		for object, item in pairs(markers) do
			core.Release(item.Highlight)
			core.Release(item.Label)
			markers[object] = nil
		end
		core.Release(overlay)
		overlay = nil
	end
	function core.Markers(records)
		local seen, count = {}, 0
		if not overlay then
			overlay = core.Own(Instance.new("Folder"))
			overlay.Name = "Nullx11OwnedMarkers"
			overlay.Parent = workspace
		end
		for _, record in ipairs(records) do
			local object = record.Object
			if not object or not object.Parent or seen[object] then
				continue
			end
			if count >= 64 then
				break
			end
			local part = object:IsA("BasePart") and object
				or object:FindFirstChild("HumanoidRootPart")
				or object:FindFirstChildWhichIsA("BasePart", true)
			if not part then
				continue
			end
			seen[object] = true
			count += 1
			local item = markers[object]
			if not item then
				local highlight = core.Own(Instance.new("Highlight"))
				highlight.Name = "NULLHighlight"
				highlight.Adornee = object
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillTransparency = 0.75
				highlight.OutlineTransparency = 0.1
				highlight.Parent = overlay
				local gui = core.Own(Instance.new("BillboardGui"))
				gui.Name = "NULLLabel"
				gui.AlwaysOnTop = true
				gui.Size = UDim2.fromOffset(170, 36)
				gui.StudsOffset = Vector3.new(0, 3, 0)
				gui.Adornee = part
				gui.Parent = overlay
				local text = Instance.new("TextLabel")
				text.Size = UDim2.fromScale(1, 1)
				text.BackgroundTransparency = 1
				text.Font = Enum.Font.GothamMedium
				text.TextSize = 13
				text.TextStrokeTransparency = 0.35
				text.Parent = gui
				item = { Highlight = highlight, Label = gui, Text = text }
				markers[object] = item
			end
			local color = record.Color or Color3.fromRGB(115, 210, 255)
			item.Highlight.FillColor = color
			item.Highlight.OutlineColor = color
			item.Label.Adornee = part
			item.Label.Enabled = record.Label ~= false
			item.Text.Text = record.Text or object.Name
			item.Text.TextColor3 = color
		end
		for object, item in pairs(markers) do
			if not seen[object] then
				core.Release(item.Highlight)
				core.Release(item.Label)
				markers[object] = nil
			end
		end
	end
	core.Button(overview, "Unload this game workspace", function()
		context.Library:Unload()
	end)
	context.RegisterCleanup(function()
		local keys = {}
		for key in pairs(core.Jobs) do
			table.insert(keys, key)
		end
		for _, key in ipairs(keys) do
			core.Stop(key)
		end
		core.ClearMarkers()
		for instance in pairs(core.Instances) do
			pcall(instance.Destroy, instance)
		end
		table.clear(core.Instances)
		patches.Clear()
	end)
	return core
end
