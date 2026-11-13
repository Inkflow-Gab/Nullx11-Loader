-- Arsenal / NULL. Reviewed adaptation of the two user-supplied client scripts.
-- See docs/ARSENAL-REVIEW.md: no source remote guesses or claimed server bypasses.
local library, patches, policy =
	context.Library, context.Patches, context.ArsenalPolicy
local Players, RunService =
	game:GetService("Players"), game:GetService("RunService")
local UIS, World, Lighting =
	game:GetService("UserInputService"),
	game:GetService("Workspace"),
	game:GetService("Lighting")
local LP = Players.LocalPlayer
local cfg = {
	Aim = false,
	Mode = "Auto",
	Part = "Head",
	Strength = 100,
	Radius = 150,
	Range = 2000,
	TeamCheck = true,
	Visible = true,
	Forcefield = true,
	Circle = false,
	Trigger = false,
	Interval = 0.15,
	ESP = false,
	Boxes = true,
	Names = true,
	Distance = true,
	Health = true,
	Tracers = false,
	Skeleton = true,
	Chams = false,
	ESPVisible = false,
	Budget = 24,
	Refresh = 30,
	Color = "Blue",
	Speed = false,
	WalkSpeed = 24,
	Jump = false,
	JumpPower = 65,
	Fly = false,
	FlySpeed = 50,
	Noclip = false,
	MultiJump = false,
	Hitbox = false,
	HitboxSize = 6,
	Fullbright = false,
	NoFog = false,
	CameraFov = false,
	FieldOfView = 80,
}
local controls, records, slots, hitboxes = {}, {}, {}, {}
local state = {
	Focused = true,
	Held = false,
	TouchHeld = false,
	Up = false,
	Down = false,
	Candidates = 0,
	Target = "None",
	Rays = 0,
	Errors = 0,
}
local colors = {
	Blue = Color3.fromRGB(104, 155, 250),
	Mint = Color3.fromRGB(110, 222, 182),
	Rose = Color3.fromRGB(249, 133, 166),
	Gold = Color3.fromRGB(236, 195, 114),
}
local input = context.MakeArsenalInput({
	Game = game,
	Click = mouse1click,
	Native = function()
		local ok, value = pcall(game.GetService, game, "VirtualInputManager")
		return ok and value or nil
	end,
})
local window = library:CreateWindow({
	Title = "Nullx11",
	SubTitle = "Arsenal / NULL",
	Theme = "Nullx11",
	Intro = false,
	Watermark = false,
	MenuKey = Enum.KeyCode.LeftControl,
	ConfigFolder = "Nullx11 Arsenal",
})
local aimTab =
	window:AddTab("Aim", "target", "Centered FOV / opt-in camera steering")
local espTab =
	window:AddTab("ESP", "eye", "Native overlays / no Drawing API required")
local movementTab =
	window:AddTab("Movement", "activity", "Local, reversible character tools")
local worldTab =
	window:AddTab("Environment", "sun", "Owned lighting and camera changes")
local sessionTab =
	window:AddTab("Session", "settings", "Status, source boundary and cleanup")
local reportLabel = sessionTab
	:AddLeftGroupbox("Live diagnostics")
	:AddLabel("All effects off / ready")
local function report(message)
	reportLabel:SetText(tostring(message))
end
local function character()
	local model = LP.Character
	local hum = model and model:FindFirstChildOfClass("Humanoid")
	local root = model and model:FindFirstChild("HumanoidRootPart")
	return model, hum, root
end
local function safeFocus()
	local _, hum = character()
	return state.Focused
		and hum
		and hum.Health > 0
		and not UIS:GetFocusedTextBox()
end
local function eligible(other)
	if not policy.Enemy(LP, other, cfg.TeamCheck) then
		return nil
	end
	local model = other.Character
	local hum = model and model:FindFirstChildOfClass("Humanoid")
	local root = model and model:FindFirstChild("HumanoidRootPart")
	if
		not hum
		or hum.Health <= 0
		or not root
		or not root:IsA("BasePart")
		or (cfg.Forcefield and model:FindFirstChildOfClass("ForceField"))
	then
		return nil
	end
	return model, hum, root
end
local overlay, circle, circleStroke, touchAim, upButton, downButton
local function make(class, parent, props)
	local object = Instance.new(class)
	for key, value in pairs(props or {}) do
		object[key] = value
	end
	object.Parent = parent
	return object
end
local function text(parent, size)
	return make("TextLabel", parent, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		TextSize = size,
		TextColor3 = Color3.fromRGB(242, 244, 248),
		TextStrokeTransparency = 0.4,
		Size = UDim2.fromOffset(230, 18),
		AnchorPoint = Vector2.new(0.5, 1),
	})
end
local function line(parent)
	return make("Frame", parent, {
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = colors[cfg.Color],
		Visible = false,
	})
end
local function drawLine(object, first, last, thickness)
	local delta = last - first
	object.Position =
		UDim2.fromOffset((first.X + last.X) / 2, (first.Y + last.Y) / 2)
	object.Size = UDim2.fromOffset(delta.Magnitude, thickness or 1)
	object.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	object.BackgroundColor3, object.Visible = colors[cfg.Color], true
end
local function host()
	if overlay then
		return
	end
	overlay = make("ScreenGui", library:GetGuiParent(), {
		Name = "Nullx11ArsenalOverlay",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		DisplayOrder = 90,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
end
local function pad(name, caption, x, y, press, release)
	host()
	local button = make("TextButton", overlay, {
		Name = name,
		Text = caption,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		BackgroundColor3 = Color3.fromRGB(28, 31, 38),
		TextColor3 = colors[cfg.Color],
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(76, 48),
		Position = UDim2.new(1, x, 1, y),
		Visible = false,
	})
	make("UICorner", button, { CornerRadius = UDim.new(0, 10) })
	local held
	context.Connect(button.InputBegan, function(event)
		if
			event.UserInputType == Enum.UserInputType.MouseButton1
			or event.UserInputType == Enum.UserInputType.Touch
		then
			held = event
			press()
		end
	end)
	context.Connect(UIS.InputEnded, function(event)
		if event == held then
			held = nil
			release()
		end
	end)
	return button
end
local function ensurePads()
	if touchAim then
		return
	end
	touchAim = pad("ArsenalHoldAim", "HOLD AIM", -96, -180, function()
		state.TouchHeld = true
	end, function()
		state.TouchHeld = false
	end)
	upButton = pad("ArsenalFlyUp", "UP", -180, -124, function()
		state.Up = true
	end, function()
		state.Up = false
	end)
	downButton = pad("ArsenalFlyDown", "DOWN", -96, -124, function()
		state.Down = true
	end, function()
		state.Down = false
	end)
end
local function hideSlot(item)
	item.Root.Visible = false
	item.Highlight.Enabled = false
end
local function clearVisuals()
	for _, item in ipairs(slots) do
		item.Root:Destroy()
		item.Highlight:Destroy()
	end
	table.clear(slots)
end
local function slot(index)
	if slots[index] then
		return slots[index]
	end
	host()
	local item = {
		Root = make("Frame", overlay, {
			Name = "ArsenalESP" .. index,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
		}),
		Bones = {},
	}
	item.Box = make(
		"Frame",
		item.Root,
		{ BackgroundTransparency = 1, BorderSizePixel = 0 }
	)
	item.Stroke = make(
		"UIStroke",
		item.Box,
		{ Thickness = 1.5, Color = colors[cfg.Color] }
	)
	item.Name, item.Info = text(item.Root, 13), text(item.Root, 11)
	item.Health = make("Frame", item.Root, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(20, 22, 26),
		Size = UDim2.fromOffset(3, 50),
	})
	item.Fill = make("Frame", item.Health, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(110, 222, 150),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
	})
	item.Tracer = line(item.Root)
	for indexBone = 1, 14 do
		item.Bones[indexBone] = line(item.Root)
	end
	item.Highlight = make("Highlight", overlay, {
		Name = "NULLArsenalHighlight",
		Enabled = false,
		FillTransparency = 0.8,
		OutlineTransparency = 0.1,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	})
	slots[index] = item
	return item
end
local function visible(camera, record, position)
	if state.Rays >= 12 then
		return false
	end
	state.Rays += 1
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local excluded = { camera }
	if LP.Character then
		table.insert(excluded, LP.Character)
	end
	params.FilterDescendantsInstances = excluded
	local hit = World:Raycast(
		camera.CFrame.Position,
		position - camera.CFrame.Position,
		params
	)
	return not hit
		or (hit.Instance and hit.Instance:IsDescendantOf(record.Model))
end
local function collect()
	table.clear(records)
	local camera = World.CurrentCamera
	if not camera then
		return
	end
	for index, other in ipairs(Players:GetPlayers()) do
		if index > 64 then
			break
		end
		local model, hum, root = eligible(other)
		if model then
			local distance = (root.Position - camera.CFrame.Position).Magnitude
			if distance <= cfg.Range then
				local head = model:FindFirstChild("Head")
				local links = {}
				local rig = model:FindFirstChild("UpperTorso") and "R15" or "R6"
				for _, pair in ipairs(policy.Bones[rig]) do
					table.insert(links, {
						model:FindFirstChild(pair[1]),
						model:FindFirstChild(pair[2]),
					})
				end
				table.insert(records, {
					Player = other,
					Model = model,
					Humanoid = hum,
					Root = root,
					Head = head,
					Distance = distance,
					Links = links,
				})
			end
		end
	end
	table.sort(records, function(a, b)
		return a.Distance < b.Distance
	end)
	state.Candidates = #records
end
local function current(record)
	local model, _, root = eligible(record.Player)
	return model == record.Model and root == record.Root and model.Parent ~= nil
end
local function renderESP(camera)
	local used = 0
	for _, record in ipairs(records) do
		if used >= cfg.Budget then
			break
		end
		if not current(record) then
			continue
		end
		local position = record.Root.Position
		local top, on =
			camera:WorldToViewportPoint(position + Vector3.new(0, 3, 0))
		local bottom =
			camera:WorldToViewportPoint(position - Vector3.new(0, 3, 0))
		if not on or top.Z <= 0 or bottom.Z <= 0 then
			continue
		end
		if cfg.ESPVisible and not visible(camera, record, position) then
			continue
		end
		used += 1
		local item = slot(used)
		local h = math.abs(bottom.Y - top.Y)
		local width = h * 0.55
		item.Root.Visible = true
		item.Box.Position, item.Box.Size =
			UDim2.fromOffset(top.X - width / 2, top.Y),
			UDim2.fromOffset(width, h)
		item.Box.Visible, item.Stroke.Color = cfg.Boxes, colors[cfg.Color]
		item.Name.Text, item.Name.Position, item.Name.Visible =
			record.Player.DisplayName,
			UDim2.fromOffset(top.X, top.Y - 3),
			cfg.Names
		local info = {}
		if cfg.Distance then
			table.insert(info, math.floor(record.Distance) .. " studs")
		end
		if cfg.Health then
			table.insert(info, math.floor(record.Humanoid.Health) .. " HP")
		end
		item.Info.Text, item.Info.Position, item.Info.Visible =
			table.concat(info, " / "),
			UDim2.fromOffset(top.X, bottom.Y + 18),
			#info > 0
		item.Health.Visible, item.Health.Position, item.Health.Size =
			cfg.Health,
			UDim2.fromOffset(top.X - width / 2 - 6, top.Y),
			UDim2.fromOffset(3, h)
		item.Fill.Size = UDim2.fromScale(
			1,
			math.clamp(
				record.Humanoid.Health / math.max(1, record.Humanoid.MaxHealth),
				0,
				1
			)
		)
		item.Tracer.Visible = false
		if cfg.Tracers then
			drawLine(
				item.Tracer,
				Vector2.new(
					camera.ViewportSize.X / 2,
					camera.ViewportSize.Y - 6
				),
				Vector2.new(top.X, bottom.Y)
			)
		end
		for indexBone, bone in ipairs(item.Bones) do
			bone.Visible = false
			local link = cfg.Skeleton and record.Links[indexBone]
			if
				link
				and link[1]
				and link[2]
				and link[1]:IsA("BasePart")
				and link[2]:IsA("BasePart")
			then
				local a, aOn = camera:WorldToViewportPoint(link[1].Position)
				local b, bOn = camera:WorldToViewportPoint(link[2].Position)
				if aOn and bOn and a.Z > 0 and b.Z > 0 then
					drawLine(bone, Vector2.new(a.X, a.Y), Vector2.new(b.X, b.Y))
				end
			end
		end
		item.Highlight.Adornee, item.Highlight.Enabled = record.Model, cfg.Chams
		item.Highlight.FillColor, item.Highlight.OutlineColor =
			colors[cfg.Color], colors[cfg.Color]
	end
	for index = used + 1, #slots do
		hideSlot(slots[index])
	end
end
local lastTrigger, scanElapsed, espElapsed, workElapsed, statusElapsed =
	-math.huge, 0, 0, 0, 0
local function aim(camera, delta)
	state.Target = "None"
	if
		not cfg.Aim
		or not safeFocus()
		or camera.CameraType == Enum.CameraType.Scriptable
		or (cfg.Mode == "Hold" and not state.Held and not state.TouchHeld)
	then
		return
	end
	local center = camera.ViewportSize / 2
	local candidates = {}
	for _, record in ipairs(records) do
		if not current(record) then
			continue
		end
		local part = cfg.Part == "Head" and record.Head or record.Root
		if not part or not part:IsA("BasePart") then
			continue
		end
		local point, on = camera:WorldToViewportPoint(part.Position)
		local inside, distance = policy.InCircle(point, center, cfg.Radius)
		if on and inside then
			table.insert(
				candidates,
				{ Record = record, Part = part, Distance = distance }
			)
		end
	end
	table.sort(candidates, function(a, b)
		return a.Distance < b.Distance
	end)
	for index, target in ipairs(candidates) do
		if index > 6 then
			break
		end
		if
			not cfg.Visible
			or visible(camera, target.Record, target.Part.Position)
		then
			state.Target = target.Record.Player.Name
			local alpha = policy.Alpha(cfg.Strength, delta)
			if alpha > 0 then
				camera.CFrame = camera.CFrame:Lerp(
					CFrame.lookAt(camera.CFrame.Position, target.Part.Position),
					alpha
				)
			end
			break
		end
	end
end
local function trigger(camera)
	if
		not cfg.Trigger
		or not safeFocus()
		or camera.CameraType == Enum.CameraType.Scriptable
		or os.clock() - lastTrigger < cfg.Interval
		or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	then
		return
	end
	lastTrigger = os.clock()
	local center = camera.ViewportSize / 2
	local ray = camera:ViewportPointToRay(center.X, center.Y)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { LP.Character, camera }
	local hit = World:Raycast(ray.Origin, ray.Direction * cfg.Range, params)
	if not hit or not hit.Instance then
		return
	end
	for _, record in ipairs(records) do
		if current(record) and hit.Instance:IsDescendantOf(record.Model) then
			local ok, reason = pcall(input.Fire, center.X, center.Y)
			if not ok then
				controls.Trigger:SetValue(false)
				report("Trigger stopped: " .. tostring(reason))
			end
			break
		end
	end
end
local flight
local function stopFlight()
	if flight then
		flight.Velocity:Destroy()
		flight.Gyro:Destroy()
		flight = nil
	end
	patches.Restore("flight")
	state.Up, state.Down = false, false
end
local function flyStep(camera)
	local _, hum, root = character()
	if not root or not hum or hum.Health <= 0 or not camera then
		stopFlight()
		return
	end
	if flight and flight.Root ~= root then
		stopFlight()
	end
	if not flight then
		flight = {
			Root = root,
			Velocity = make("BodyVelocity", root, {
				Name = "NULLArsenalFlight",
				MaxForce = Vector3.new(100000, 100000, 100000),
				P = 10000,
				Velocity = Vector3.zero,
			}),
			Gyro = make("BodyGyro", root, {
				Name = "NULLArsenalOrientation",
				MaxTorque = Vector3.new(100000, 100000, 100000),
				P = 10000,
				CFrame = root.CFrame,
			}),
		}
		patches.Write("flight", hum, "PlatformStand", true)
	end
	local direction = Vector3.zero
	if safeFocus() then
		direction = hum.MoveDirection
		if direction.Magnitude == 0 then
			if UIS:IsKeyDown(Enum.KeyCode.W) then
				direction += camera.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				direction -= camera.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				direction += camera.CFrame.RightVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				direction -= camera.CFrame.RightVector
			end
		end
		if state.Up or UIS:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.new(0, 1, 0)
		end
		if state.Down or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			direction -= Vector3.new(0, 1, 0)
		end
	end
	if direction.Magnitude > 1 then
		direction = direction.Unit
	end
	flight.Velocity.Velocity = direction * cfg.FlySpeed
	flight.Gyro.CFrame = camera.CFrame
end
local function movement()
	local _, hum = character()
	if hum and hum.Health > 0 then
		if cfg.Speed then
			patches.Write("speed", hum, "WalkSpeed", cfg.WalkSpeed)
		end
		if cfg.Jump then
			patches.Write("jump", hum, "UseJumpPower", true)
			patches.Write("jump", hum, "JumpPower", cfg.JumpPower)
		end
	end
end
local function noclip()
	local model = LP.Character
	if not cfg.Noclip or not model then
		return
	end
	local count = 0
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			patches.Write("noclip", part, "CanCollide", false)
			count += 1
			if count >= 96 then
				break
			end
		end
	end
end
local function hitboxStep()
	local seen = {}
	if cfg.Hitbox then
		for index, record in ipairs(records) do
			if index > cfg.Budget then
				break
			end
			if current(record) then
				local root = record.Root
				seen[root], hitboxes[root] = true, true
				patches.Write(
					root,
					root,
					"Size",
					Vector3.new(cfg.HitboxSize, cfg.HitboxSize, cfg.HitboxSize)
				)
				patches.Write(root, root, "Transparency", 0.75)
			end
		end
	end
	for root in pairs(hitboxes) do
		if not seen[root] then
			patches.Restore(root)
			hitboxes[root] = nil
		end
	end
end
local function off()
	for _, key in ipairs({
		"Aim",
		"Trigger",
		"ESP",
		"Circle",
		"Speed",
		"Jump",
		"Fly",
		"Noclip",
		"MultiJump",
		"Hitbox",
		"Fullbright",
		"NoFog",
		"CameraFov",
	}) do
		if controls[key] and cfg[key] then
			controls[key]:SetValue(false)
		end
	end
	stopFlight()
	patches.Clear()
	clearVisuals()
	table.clear(records)
	table.clear(hitboxes)
	if circle then
		circle.Visible = false
	end
	if touchAim then
		touchAim.Visible, upButton.Visible, downButton.Visible =
			false, false, false
	end
	state.Held, state.TouchHeld, state.Up, state.Down =
		false, false, false, false
	local released = input.Release()
	report(
		released and "All Arsenal effects off / owned changes restored"
			or "Effects stopped; mouse release refused. Retry release / F7"
	)
end
context.RegisterCleanup(function()
	stopFlight()
	patches.Clear()
	input.Release()
	clearVisuals()
	if overlay then
		overlay:Destroy()
	end
	table.clear(records)
	table.clear(hitboxes)
end)
local function toggle(box, key, caption, callback)
	controls[key] = box:AddToggle("Arsenal_" .. key, {
		Text = caption,
		Default = cfg[key],
		NoSave = true,
		Callback = function(value)
			cfg[key] = value == true
			local ok, reason = pcall(function()
				if callback then
					callback(cfg[key])
				end
			end)
			if not ok then
				cfg[key] = false
				if controls[key] then
					controls[key]:SetValue(false)
				end
				report("Unavailable: " .. tostring(reason))
			end
		end,
	})
end
local function slider(box, key, caption, minimum, maximum, rounding)
	box:AddSlider("Arsenal_" .. key, {
		Text = caption,
		Min = minimum,
		Max = maximum,
		Default = cfg[key],
		Rounding = rounding or 0,
		Callback = function(value)
			cfg[key] = policy.Number(value, minimum, maximum)
		end,
	})
end
local function dropdown(box, key, caption, values)
	box:AddDropdown("Arsenal_" .. key, {
		Text = caption,
		Values = values,
		Default = cfg[key],
		Callback = function(value)
			if table.find(values, value) then
				cfg[key] = value
			end
		end,
	})
end
local aimGroup, aimOptions =
	aimTab:AddLeftGroupbox("Camera aim"),
	aimTab:AddRightGroupbox("Target and input")
toggle(aimGroup, "Aim", "Enable aim assist", function(value)
	if not value then
		state.TouchHeld = false
		if touchAim then
			touchAim.Visible = false
		end
	end
end)
dropdown(aimGroup, "Mode", "Activation", { "Auto", "Hold" })
dropdown(aimGroup, "Part", "Target part", { "Head", "Root" })
slider(aimGroup, "Strength", "Aim strength / 100 = snap", 0, 100)
slider(aimGroup, "Radius", "Centered FOV radius / pixels", 20, 500)
toggle(aimGroup, "Circle", "Show centered FOV", function(value)
	if value then
		host()
	end
	if circle then
		circle.Visible = value
	end
end)
slider(aimOptions, "Range", "Maximum range / studs", 100, 5000)
toggle(aimOptions, "TeamCheck", "Skip teammates")
toggle(aimOptions, "Visible", "Aim visibility check")
toggle(aimOptions, "Forcefield", "Skip ForceFields")
toggle(aimOptions, "Trigger", "Crosshair trigger / real input", function(value)
	if not value then
		input.Release()
	end
end)
slider(aimOptions, "Interval", "Trigger interval / seconds", 0.1, 1, 2)
aimOptions:AddDropdown("Arsenal_Backend", {
	Text = "Click backend (API support varies)",
	Values = { "Auto", "Mouse click", "VIM" },
	Default = "Auto",
	NoSave = true,
	Callback = function(value)
		if table.find({ "Auto", "Mouse click", "VIM" }, value) then
			controls.Trigger:SetValue(false)
			if input.Release() then
				input.Backend = value
			else
				report("Release pending; backend unchanged")
			end
		end
	end,
})
aimOptions:AddParagraph({
	Title = "Actual input, not confirmed shots",
	Content = "Trigger clicks only a living eligible character under the actual center ray, at most 10/s. An API may exist but be rejected by Delta or the game. Errors stop trigger; no silent fallback. RMB or HOLD AIM activates Hold mode; typing/focus loss pauses aim/input.",
})
local espGroup, espOptions =
	espTab:AddLeftGroupbox("Player overlays"),
	espTab:AddRightGroupbox("Display budget")
toggle(espGroup, "ESP", "Enable ESP", function(value)
	if not value then
		clearVisuals()
	end
end)
for _, spec in ipairs({
	{ "Boxes", "2D character boxes" },
	{ "Skeleton", "R6 / R15 skeleton" },
	{ "Names", "Player names" },
	{ "Distance", "Distance in studs" },
	{ "Health", "Health bars and HP" },
	{ "Tracers", "Bottom-center tracers" },
	{ "Chams", "Character highlights" },
	{ "ESPVisible", "ESP visibility check" },
}) do
	toggle(espGroup, spec[1], spec[2])
end
slider(espOptions, "Budget", "Maximum visible players", 1, 32)
slider(espOptions, "Refresh", "Overlay refresh / Hz", 10, 60)
dropdown(
	espOptions,
	"Color",
	"Overlay color",
	{ "Blue", "Mint", "Rose", "Gold" }
)
espOptions:AddParagraph({
	Title = "Bounded, native rendering",
	Content = "No Drawing API required. Up to 64 player candidates, 32 overlay slots, 14 rig lines/slot and 12 visibility rays/render. Occlusion caps may omit targets. Character refs and camera are refreshed; no map-wide scan or UI color animation worker.",
})
local moveGroup, flyGroup =
	movementTab:AddLeftGroupbox("Character"),
	movementTab:AddRightGroupbox("Flight")
toggle(moveGroup, "Speed", "Enable walk speed", function(value)
	if not value then
		patches.Restore("speed")
	end
end)
slider(moveGroup, "WalkSpeed", "Walk speed", 8, 150)
toggle(moveGroup, "Jump", "Enable jump power", function(value)
	if not value then
		patches.Restore("jump")
	end
end)
slider(moveGroup, "JumpPower", "Jump power", 20, 200)
toggle(moveGroup, "MultiJump", "Mid-air jump requests")
toggle(moveGroup, "Noclip", "Local character noclip", function(value)
	if not value then
		patches.Restore("noclip")
	end
end)
toggle(flyGroup, "Fly", "Enable flight", function(value)
	if value then
		ensurePads()
	else
		stopFlight()
		if upButton then
			upButton.Visible, downButton.Visible = false, false
		end
	end
end)
slider(flyGroup, "FlySpeed", "Flight speed", 10, 150)
flyGroup:AddParagraph({
	Title = "Desktop and touch",
	Content = "Use WASD or the mobile movement stick, Space/UP to ascend, Shift/DOWN to descend. Input pauses while typing/unfocused. Local movement and hitbox edits can be corrected or rejected by the game; they do not bypass server validation.",
})
local localGroup = worldTab:AddLeftGroupbox("Lighting and view")
toggle(localGroup, "Fullbright", "Fullbright", function(value)
	if value then
		patches.Write(
			"bright",
			Lighting,
			"Ambient",
			Color3.fromRGB(200, 200, 200)
		)
		patches.Write(
			"bright",
			Lighting,
			"OutdoorAmbient",
			Color3.fromRGB(200, 200, 200)
		)
		patches.Write("bright", Lighting, "Brightness", 2)
	else
		patches.Restore("bright")
	end
end)
toggle(localGroup, "NoFog", "Remove classic fog", function(value)
	if value then
		patches.Write("fog", Lighting, "FogStart", 100000)
		patches.Write("fog", Lighting, "FogEnd", 100001)
	else
		patches.Restore("fog")
	end
end)
toggle(localGroup, "CameraFov", "Override camera field of view", function(value)
	if not value then
		patches.Restore("camera")
	end
end)
slider(localGroup, "FieldOfView", "Camera field of view", 40, 120)
local hitGroup = worldTab:AddRightGroupbox("Client hitbox experiment")
toggle(hitGroup, "Hitbox", "Expand enemy root parts locally", function(value)
	if not value then
		hitboxStep()
	end
end)
slider(hitGroup, "HitboxSize", "Root-part size / studs", 2, 12)
hitGroup:AddParagraph({
	Title = "No hit-registration guarantee",
	Content = "The generic source only resized replicated root parts on this client. This does not prove Arsenal accepts larger hitboxes. Changes are bounded and restored per original instance on disable, respawn, team change or unload.",
})
local safety = sessionTab:AddRightGroupbox("Session control")
safety:AddButton({ Text = "STOP ALL / F7", Style = "Danger", Func = off })
safety:AddButton({
	Text = "Retry owned mouse release",
	Func = function()
		report(
			input.Release() and "No pending input"
				or "Mouse release still refused"
		)
	end,
})
safety:AddButton({
	Text = "Unload Arsenal only",
	Func = function()
		library:Unload()
	end,
})
safety:AddParagraph({
	Title = "Source boundary",
	Content = "No guessed remote spam, claimed wallbang, kill aura, health-write god mode, placeholder Auto Farm or Chest Collector. These were not demonstrated Arsenal mechanics. No anti-cheat bypass or server-hit claims. Owner: NULL; supplied-source provenance retained.",
})
local function resetCharacter()
	stopFlight()
	patches.Restore("speed")
	patches.Restore("jump")
	patches.Restore("noclip")
	for root in pairs(hitboxes) do
		patches.Restore(root)
	end
	table.clear(hitboxes)
	table.clear(records)
	clearVisuals()
	state.Held, state.TouchHeld = false, false
	input.Release()
end
context.Connect(LP.CharacterAdded, resetCharacter)
context.Connect(LP.CharacterRemoving, resetCharacter)
context.Connect(Players.PlayerRemoving, function(other)
	for index = #records, 1, -1 do
		if records[index].Player == other then
			local record = table.remove(records, index)
			patches.Restore(record.Root)
			hitboxes[record.Root] = nil
		end
	end
	clearVisuals()
end)
context.Connect(UIS.InputBegan, function(event, processed)
	if processed or UIS:GetFocusedTextBox() then
		return
	end
	if event.UserInputType == Enum.UserInputType.MouseButton2 then
		state.Held = true
	end
	if event.KeyCode == Enum.KeyCode.F7 then
		off()
	end
end)
context.Connect(UIS.InputEnded, function(event)
	if event.UserInputType == Enum.UserInputType.MouseButton2 then
		state.Held = false
	end
end)
context.Connect(UIS.WindowFocusReleased, function()
	state.Focused, state.Held, state.TouchHeld, state.Up, state.Down =
		false, false, false, false, false
	input.Release()
end)
context.Connect(UIS.WindowFocused, function()
	state.Focused = true
end)
context.Connect(UIS.JumpRequest, function()
	if cfg.MultiJump and safeFocus() then
		local _, hum = character()
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
context.Connect(RunService.Stepped, function()
	if cfg.Noclip then
		local ok, reason = pcall(noclip)
		if not ok then
			off()
			report(reason)
		end
	end
end)
context.Connect(RunService.Heartbeat, function(delta)
	workElapsed += delta
	statusElapsed += delta
	if workElapsed >= 0.1 then
		workElapsed = 0
		local ok, reason = pcall(function()
			if cfg.Speed or cfg.Jump then
				movement()
			end
			if cfg.Hitbox or next(hitboxes) then
				hitboxStep()
			end
			if cfg.CameraFov then
				local camera = World.CurrentCamera
				if camera then
					patches.Write(
						"camera",
						camera,
						"FieldOfView",
						cfg.FieldOfView
					)
				end
			end
		end)
		if not ok then
			state.Errors += 1
			off()
			report("Character feature stopped: " .. tostring(reason))
		end
	end
	if
		statusElapsed >= 1
		and window.Visible
		and window.ActiveTab == sessionTab
	then
		statusElapsed = 0
		report(
			string.format(
				"%d candidates / %s target / %d overlays / %d click requests / %d input errors. APIs do not prove game acceptance.",
				state.Candidates,
				state.Target,
				#slots,
				input.Sent,
				input.Errors
			)
		)
	end
end)
context.Connect(RunService.RenderStepped, function(delta)
	if
		not (
			cfg.Aim
			or cfg.Trigger
			or cfg.ESP
			or cfg.Hitbox
			or cfg.Circle
			or cfg.Fly
		)
	then
		return
	end
	local ok, reason = pcall(function()
		local camera = World.CurrentCamera
		if not camera then
			return
		end
		state.Rays = 0
		scanElapsed += delta
		if
			scanElapsed >= 0.15
			and (cfg.Aim or cfg.Trigger or cfg.ESP or cfg.Hitbox)
		then
			scanElapsed = 0
			collect()
		end
		if cfg.Fly then
			flyStep(camera)
		end
		if cfg.Aim then
			aim(camera, delta)
		end
		if cfg.Trigger then
			trigger(camera)
		end
		if cfg.Circle then
			host()
			if not circle then
				circle = make("Frame", overlay, {
					Name = "ArsenalFOV",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				})
				make("UICorner", circle, { CornerRadius = UDim.new(1, 0) })
				circleStroke = make("UIStroke", circle, {
					Name = "FOVStroke",
					Color = colors[cfg.Color],
					Thickness = 1.5,
				})
			end
			circle.Visible, circle.Size =
				true, UDim2.fromOffset(cfg.Radius * 2, cfg.Radius * 2)
			circleStroke.Color = colors[cfg.Color]
		end
		if cfg.Aim or cfg.Fly then
			ensurePads()
		end
		if touchAim then
			touchAim.Visible = cfg.Aim and cfg.Mode == "Hold"
			upButton.Visible, downButton.Visible = cfg.Fly, cfg.Fly
		end
		espElapsed += delta
		if cfg.ESP and espElapsed >= 1 / cfg.Refresh then
			espElapsed = 0
			renderESP(camera)
		end
	end)
	if not ok then
		state.Errors += 1
		off()
		report("Render feature stopped: " .. tostring(reason))
	end
end)
return { Nullx11Ready = true, Window = window, Config = cfg, State = state }
