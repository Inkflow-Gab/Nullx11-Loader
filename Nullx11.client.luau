--!strict
-- Nullx11 • Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Built-in session tools; optional ModuleScript child "App". See README.md.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CONFIG = {
	Name = "Nullx11",
	Subtitle = "A quieter way to get started.",
	Accent = Color3.fromRGB(167, 146, 255),
	ReducedMotion = false,
}

-- External runtimes may not provide the LocalScript instance.
local appContainer = if typeof(script) == "Instance" then script else nil
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- Re-running the script closes its previous instance and its connections.
local previous = playerGui:FindFirstChild("Nullx11Loader")
if previous then previous:Destroy() end

local colors = {
	Panel = Color3.fromRGB(20, 21, 27),
	Surface = Color3.fromRGB(29, 30, 39),
	Border = Color3.fromRGB(54, 55, 68),
	Text = Color3.fromRGB(242, 241, 249),
	Muted = Color3.fromRGB(151, 151, 170),
	Error = Color3.fromRGB(255, 151, 160),
	Success = Color3.fromRGB(143, 221, 182),
}

local dashboardOpen = false
local interfaceScale = 1
local windowsPinned = false
local alive = true
local connections: {RBXScriptConnection} = {}
local activeTweens: {[Instance]: {[string]: Tween}} = {}
local function connect(signal: RBXScriptSignal, callback: any): RBXScriptConnection
	local connection = signal:Connect(callback)
	table.insert(connections, connection)
	return connection
end

local function create(className: string, properties: {[string]: any}, parent: Instance?): any
	local object = Instance.new(className)
	for key, value in pairs(properties) do
		(object :: any)[key] = value
	end
	object.Parent = parent
	return object
end

local function corner(parent: Instance, radius: number)
	create("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function tween(object: Instance, properties: {[string]: any}, duration: number?)
	if not alive then return end
	-- Cancel overlapping animations so rapid taps never fight previous tweens.
	local running = activeTweens[object]
	if not running then
		running = {}
		activeTweens[object] = running
	end
	for property in pairs(properties) do
		local prior = running[property]
		if prior then prior:Cancel() end
	end
	local animation = TweenService:Create(object, TweenInfo.new(
		if CONFIG.ReducedMotion then 0 else (duration or 0.18),
		Enum.EasingStyle.Quint, Enum.EasingDirection.Out
	), properties)
	for property in pairs(properties) do running[property] = animation end
	animation:Play()
end

local gui = create("ScreenGui", {
	Name = "Nullx11Loader",
	ResetOnSpawn = false,
	IgnoreGuiInset = false,
	ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 100,
}, playerGui)

-- This frame uses the device's safe area, not the entire screen/notch region.
local root = create("Frame", {
	Name = "SafeArea", Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
}, gui)

local card = create("Frame", {
	Name = "Panel", AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(440, 360),
	BackgroundColor3 = colors.Panel, BorderSizePixel = 0,
}, root)
corner(card, 20)
create("UIGradient", {
	Color = ColorSequence.new(colors.Panel, Color3.fromRGB(26, 26, 37)), Rotation = 115,
}, card)
create("UIStroke", { Color = colors.Border, Transparency = 0.2, Thickness = 1 }, card)
local responsiveScale = create("UIScale", { Scale = 1 }, card)

local function label(parent: Instance, text: string, size: number, color: Color3): TextLabel
	return create("TextLabel", {
		BackgroundTransparency = 1, Text = text, TextSize = size,
		TextColor3 = color, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, parent)
end

local header = create("Frame", {
	Name = "DragHandle", BackgroundTransparency = 1,
	Size = UDim2.new(1, -112, 0, 78), Position = UDim2.fromOffset(0, 0),
	Active = true,
}, card)
local mark = create("Frame", {
	Position = UDim2.fromOffset(24, 26), Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0,
}, header)
corner(mark, 9)
create("UIGradient", { Name = "BrandGradient", Color = ColorSequence.new(CONFIG.Accent, Color3.fromRGB(112, 113, 221)), Rotation = 45 }, mark)
-- Original geometric N mark, drawn from UI primitives (no uploaded asset).
local function drawIcon(parent: Instance, ink: Color3, position: UDim2, size: number)
	local icon = create("Frame", {
		Name = "Nullx11Icon", BackgroundTransparency = 1,
		Position = position, Size = UDim2.fromOffset(size, size),
	}, parent)
	for _, geometry in ipairs({
		{0.22, 0.5, 0.14, 0.64, 0},
		{0.5, 0.5, 0.14, 0.76, -36},
		{0.78, 0.5, 0.14, 0.64, 0},
	}) do
		local line = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(geometry[1], geometry[2]),
			Size = UDim2.fromScale(geometry[3], geometry[4]), Rotation = geometry[5],
			BackgroundColor3 = ink, BorderSizePixel = 0,
		}, icon)
		corner(line, 2)
	end
	local cut = create("Frame", {
		Name = "SignatureCut", Position = UDim2.fromScale(0.74, 0.05),
		Size = UDim2.fromScale(0.2, 0.07), Rotation = -36,
		BackgroundColor3 = ink, BackgroundTransparency = 0.25, BorderSizePixel = 0,
	}, icon)
	corner(cut, 2)
	return icon
end
drawIcon(mark, colors.Panel, UDim2.fromOffset(3, 3), 24)
local title = label(header, CONFIG.Name, 19, colors.Text)
title.Name = "Title"
title.Font = Enum.Font.Code
title.Position = UDim2.fromOffset(65, 26)
title.Size = UDim2.new(1, -65, 0, 30)

local function iconButton(text: string, x: number, description: string): TextButton
	local button = create("TextButton", {
		Name = description, Text = text, TextSize = 22, Font = Enum.Font.Gotham,
		TextColor3 = colors.Muted, AutoButtonColor = false,
		BackgroundColor3 = colors.Surface, BackgroundTransparency = 1,
		Position = UDim2.new(1, x, 0, 19), Size = UDim2.fromOffset(44, 44),
	}, card)
	corner(button, 12)
	connect(button.MouseEnter, function() tween(button, { BackgroundTransparency = 0 }) end)
	connect(button.MouseLeave, function() tween(button, { BackgroundTransparency = 1 }) end)
	connect(button.SelectionGained, function() tween(button, { BackgroundTransparency = 0 }) end)
	connect(button.SelectionLost, function() tween(button, { BackgroundTransparency = 1 }) end)
	return button
end
local minimize = iconButton("−", -108, "Minimize")
local close = iconButton("×", -60, "Close")

create("Frame", {
	BackgroundColor3 = colors.Border, BackgroundTransparency = 0.4, BorderSizePixel = 0,
	Position = UDim2.fromOffset(24, 81), Size = UDim2.new(1, -48, 0, 1),
}, card)
local eyebrow = label(card, "LESS NOISE. MORE PLAY.", 10, CONFIG.Accent)
eyebrow.Font = Enum.Font.GothamBold
eyebrow.Position = UDim2.fromOffset(24, 102)
eyebrow.Size = UDim2.new(1, -48, 0, 18)
local welcome = label(card, "Make yourself at home.", 23, colors.Text)
welcome.Font = Enum.Font.GothamBold
welcome.Position = UDim2.fromOffset(24, 128)
welcome.Size = UDim2.new(1, -48, 0, 32)
welcome.TextScaled = true
create("UITextSizeConstraint", { MinTextSize = 16, MaxTextSize = 23 }, welcome)
local subtitle = label(card, CONFIG.Subtitle, 13, colors.Muted)
subtitle.Position = UDim2.fromOffset(24, 167)
subtitle.Size = UDim2.new(1, -48, 0, 24)
subtitle.TextWrapped = true

local launch = create("TextButton", {
	Name = "Load", Position = UDim2.fromOffset(24, 212),
	Size = UDim2.new(1, -48, 0, 50), BackgroundColor3 = CONFIG.Accent,
	Text = "Load  →", TextColor3 = colors.Panel, TextSize = 15,
	Font = Enum.Font.GothamBold, AutoButtonColor = false, BorderSizePixel = 0,
}, card)
corner(launch, 12)
local progressTrack = create("Frame", {
	Position = UDim2.fromOffset(24, 280), Size = UDim2.new(1, -48, 0, 3),
	BackgroundColor3 = colors.Surface, BorderSizePixel = 0, ClipsDescendants = true,
}, card)
corner(progressTrack, 2)
local progressFill = create("Frame", {
	Size = UDim2.fromScale(0, 1), BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0,
}, progressTrack)
corner(progressFill, 2)
local status = label(card, "Ready when you are", 12, colors.Muted)
status.Position = UDim2.fromOffset(24, 297)
status.Size = UDim2.new(1, -48, 0, 22)
status.TextTruncate = Enum.TextTruncate.AtEnd
local footer = label(card, "NULLX11  /  CLIENT", 9, colors.Muted)
footer.Position = UDim2.fromOffset(24, 330)
footer.Size = UDim2.new(1, -48, 0, 14)

local mini = create("TextButton", {
	Name = "RestoreNullx11", AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(60, 60),
	BackgroundColor3 = colors.Panel, TextColor3 = CONFIG.Accent,
	Text = "", TextSize = 15, Font = Enum.Font.Code,
	BorderSizePixel = 0, AutoButtonColor = false, Visible = true,
}, root)
corner(mini, 19)
create("UIGradient", { Color = ColorSequence.new(colors.Surface, colors.Panel), Rotation = 110 }, mini)
drawIcon(mini, CONFIG.Accent, UDim2.fromOffset(15, 12), 30)
local dockCaption = label(mini, "11 /", 8, colors.Muted)
dockCaption.Font = Enum.Font.Code
dockCaption.Position = UDim2.fromOffset(0, 43)
dockCaption.Size = UDim2.new(1, 0, 0, 12)
dockCaption.TextXAlignment = Enum.TextXAlignment.Center
local dockDot = create("Frame", {
	Name = "DockStatus", Position = UDim2.new(1, -11, 0, 7), Size = UDim2.fromOffset(4, 4),
	BackgroundColor3 = colors.Success, BorderSizePixel = 0,
}, mini)
corner(dockDot, 4)
create("UIStroke", { Color = CONFIG.Accent, Transparency = 0.45 }, mini)

local expanded = true
local transitioning = false
local panelCenter: Vector2? = nil
local miniCenter: Vector2? = nil
local function clampCenter(position: Vector2, size: Vector2): Vector2
	local viewport = root.AbsoluteSize
	local margin = 8
	local half = size / 2
	local minX = math.min(half.X + margin, viewport.X / 2)
	local minY = math.min(half.Y + margin, viewport.Y / 2)
	return Vector2.new(
		math.clamp(position.X, minX, math.max(minX, viewport.X - minX)),
		math.clamp(position.Y, minY, math.max(minY, viewport.Y - minY))
	)
end
local extraCenters: {[GuiObject]: Vector2} = {}
local layoutExtras: (() -> ())? = nil
local function layout()
	local viewport = root.AbsoluteSize
	if viewport.X <= 0 or viewport.Y <= 0 then return end
	local animations = activeTweens[card]
	if animations and animations.Position then animations.Position:Cancel() end
	local height = if dashboardOpen then math.min(520, math.max(240, (viewport.Y - 24) / interfaceScale)) else 360
	local scale = math.min(interfaceScale, math.max(0.1, (viewport.Y - 24) / height))
	responsiveScale.Scale = scale
	local width = math.min(440, math.max(1, (viewport.X - 24) / scale))
	card.Size = UDim2.fromOffset(width, height)
	panelCenter = clampCenter(panelCenter or viewport / 2, Vector2.new(width, height) * scale)
	miniCenter = clampCenter(miniCenter or Vector2.new(if viewport.X > viewport.Y then viewport.X - 48 else 48, viewport.Y - 46), mini.AbsoluteSize)
	card.Position = UDim2.fromOffset(panelCenter.X, panelCenter.Y)
	mini.Position = UDim2.fromOffset(miniCenter.X, miniCenter.Y)
	if layoutExtras then layoutExtras() end
end
connect(root:GetPropertyChangedSignal("AbsoluteSize"), layout)
layout()

-- One input path for touch and mouse; no per-frame polling or mouse-only dragging.
local drag: {input: InputObject, start: Vector2, center: Vector2, target: GuiObject, moved: boolean}? = nil
local suppressRestoreUntil = 0
local function draggable(handle: GuiObject, target: GuiObject)
	connect(handle.InputBegan, function(input: InputObject)
		if drag or transitioning or (windowsPinned and target ~= mini) then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local animations = activeTweens[target]
		if animations and animations.Position then animations.Position:Cancel() end
		drag = {
			input = input, start = Vector2.new(input.Position.X, input.Position.Y),
			center = target.AbsolutePosition - root.AbsolutePosition + target.AbsoluteSize / 2,
			target = target, moved = false,
		}
	end)
end
draggable(header, card)
draggable(mini, mini)
connect(UserInputService.InputChanged, function(input: InputObject)
	local current = drag
	if not current then return end
	if input ~= current.input and not (current.input.UserInputType == Enum.UserInputType.MouseButton1
		and input.UserInputType == Enum.UserInputType.MouseMovement) then return end
	local delta = Vector2.new(input.Position.X, input.Position.Y) - current.start
	if delta.Magnitude > 6 then current.moved = true end
	if not current.moved then return end
	if current.target == mini then suppressRestoreUntil = os.clock() + 0.3 end
	local center = clampCenter(current.center + delta, current.target.AbsoluteSize)
	current.target.Position = UDim2.fromOffset(center.X, center.Y)
	if current.target == card then
		panelCenter = center
	elseif current.target == mini then
		miniCenter = center
	else
		extraCenters[current.target] = center
	end
end)
connect(UserInputService.InputEnded, function(input: InputObject)
	if drag and input == drag.input then
		if drag.target == mini and drag.moved then suppressRestoreUntil = os.clock() + 0.3 end
		drag = nil
	end
end)
connect(UserInputService.WindowFocusReleased, function() drag = nil end)

local function setExpanded(value: boolean)
	if transitioning or value == expanded then return end
	transitioning = true
	drag = nil
	expanded = value
	-- A short, subtle settle animation; panel position survives minimizing.
	card.Visible = value
	mini.Visible = true
	dockDot.BackgroundColor3 = if value then colors.Success else CONFIG.Accent
	layout()
	if value then
		local destination = card.Position
		card.Position = destination + UDim2.fromOffset(0, 8)
		tween(card, { Position = destination }, 0.24)
	else
		tween(mini, { BackgroundColor3 = colors.Surface }, 0.15)
	end
	task.delay(if CONFIG.ReducedMotion then 0 else 0.25, function()
		transitioning = false
	end)
end
connect(minimize.Activated, function() setExpanded(false) end)
connect(mini.Activated, function()
	if os.clock() >= suppressRestoreUntil then setExpanded(not expanded) end
end)
connect(close.Activated, function() gui:Destroy() end)
connect(mini.MouseButton1Down, function() tween(mini, { BackgroundTransparency = 0.15 }, 0.1) end)
connect(mini.MouseButton1Up, function() tween(mini, { BackgroundTransparency = 0 }, 0.1) end)
connect(mini.MouseLeave, function() tween(mini, { BackgroundTransparency = 0 }, 0.1) end)

-- Built-in tools: toggles live in the main panel; each utility floats separately.
local tools = create("ScrollingFrame", {
	Name = "Tools", BackgroundTransparency = 1,
	Position = UDim2.fromOffset(24, 152), Size = UDim2.new(1, -48, 1, -234),
	CanvasSize = UDim2.fromOffset(0, 232), ScrollBarThickness = 2,
	ScrollBarImageColor3 = CONFIG.Accent, BorderSizePixel = 0,
	Visible = false,
}, card)
local function toggleRow(name: string, hint: string, y: number, initial: boolean, changed: (boolean) -> (), parent: Instance?): (boolean) -> ()
	local enabled = initial
	local row = create("TextButton", {
		Name = name, Text = "", AutoButtonColor = false,
		Position = UDim2.fromOffset(0, y), Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = colors.Surface, BorderSizePixel = 0,
	}, parent or tools)
	corner(row, 10)
	local heading = label(row, name, 13, colors.Text)
	heading.Position = UDim2.fromOffset(12, 6)
	heading.Size = UDim2.new(1, -78, 0, 20)
	heading.Font = Enum.Font.GothamMedium
	local description = label(row, hint, 10, colors.Muted)
	description.Position = UDim2.fromOffset(12, 27)
	description.Size = UDim2.new(1, -78, 0, 16)
	description.TextTruncate = Enum.TextTruncate.AtEnd
	local indicator = label(row, "", 11, CONFIG.Accent)
	indicator.Name = "ToggleState"
	indicator.Font = Enum.Font.Code
	indicator.Position = UDim2.new(1, -57, 0, 0)
	indicator.Size = UDim2.fromOffset(45, 50)
	indicator.TextXAlignment = Enum.TextXAlignment.Center
	local function paint()
		indicator.Text = if enabled then "ON" else "OFF"
		indicator.TextColor3 = if enabled then CONFIG.Accent else colors.Muted
	end
	paint()
	local function setEnabled(value: boolean)
		enabled = value
		paint()
		changed(enabled)
	end
	connect(row.Activated, function() setEnabled(not enabled) end)
	return setEnabled
end

local teleportPanel = create("Frame", {
	Name = "TeleportPanel", AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(320, 306), BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0, Visible = false,
}, root)
corner(teleportPanel, 16)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, teleportPanel)
local teleportScale = create("UIScale", { Scale = 1 }, teleportPanel)
local teleportHeader = create("Frame", {
	Name = "TeleportDragHandle", BackgroundTransparency = 1, Active = true,
	Size = UDim2.new(1, -60, 0, 56),
}, teleportPanel)
drawIcon(teleportHeader, CONFIG.Accent, UDim2.fromOffset(16, 17), 22)
local teleportTitle = label(teleportHeader, "POSITION", 13, colors.Text)
teleportTitle.Font = Enum.Font.Code
teleportTitle.Position = UDim2.fromOffset(48, 0)
teleportTitle.Size = UDim2.new(1, -48, 1, 0)
local teleportHide = create("TextButton", {
	Name = "HideTeleport", Text = "−", TextSize = 22, TextColor3 = colors.Muted,
	Font = Enum.Font.Code, BackgroundTransparency = 1,
	Position = UDim2.new(1, -52, 0, 6), Size = UDim2.fromOffset(44, 44),
}, teleportPanel)
-- Hiding keeps the bookmark; the main toggle can reopen this utility.
local setTeleportEnabled: ((boolean) -> ())? = nil
connect(teleportHide.Activated, function()
	if setTeleportEnabled then setTeleportEnabled(false) end
end)
local coordinates = label(teleportPanel, "No position saved", 12, colors.Muted)
coordinates.Name = "Coordinates"
coordinates.Font = Enum.Font.Code
coordinates.Position = UDim2.fromOffset(16, 105)
coordinates.Size = UDim2.new(1, -32, 0, 28)
coordinates.TextScaled = true
create("UITextSizeConstraint", { MinTextSize = 9, MaxTextSize = 12 }, coordinates)
local teleportStatus = label(teleportPanel, "Save a spot, then return to it.", 11, colors.Muted)
teleportStatus.Name = "TeleportStatus"
teleportStatus.Position = UDim2.fromOffset(16, 254)
teleportStatus.Size = UDim2.new(1, -32, 0, 38)
teleportStatus.TextWrapped = true
local function utilityButton(name: string, text: string, position: UDim2, size: UDim2, primary: boolean): TextButton
	local button = create("TextButton", {
		Name = name, Text = text, Position = position, Size = size,
		TextSize = 12, Font = Enum.Font.GothamMedium, AutoButtonColor = false,
		TextColor3 = if primary then colors.Panel else colors.Text,
		BackgroundColor3 = if primary then CONFIG.Accent else colors.Surface, BorderSizePixel = 0,
	}, teleportPanel)
	corner(button, 10)
	connect(button.MouseButton1Down, function() tween(button, { BackgroundTransparency = 0.25 }, 0.1) end)
	connect(button.MouseButton1Up, function() tween(button, { BackgroundTransparency = 0 }, 0.1) end)
	connect(button.MouseLeave, function() tween(button, { BackgroundTransparency = 0 }, 0.1) end)
	return button
end
local savePosition = utilityButton("SavePosition", "Save position", UDim2.fromOffset(16, 147), UDim2.new(0.5, -20, 0, 46), false)
local clearPosition = utilityButton("ClearPosition", "Clear", UDim2.new(0.5, 4, 0, 147), UDim2.new(0.5, -20, 0, 46), false)
local goPosition = utilityButton("TeleportToPosition", "Teleport to saved spot  →", UDim2.fromOffset(16, 201), UDim2.new(1, -32, 0, 46), true)
local savedPivot: CFrame? = nil
local savedPivots: {[number]: CFrame} = {}
local selectedSlot = 1
local slotButtons: {TextButton} = {}
local function refreshSlots()
	for i, button in ipairs(slotButtons) do
		button.Text = string.format("%02d  %s", i, if savedPivots[i] then "SAVED" else "EMPTY")
		button.TextColor3 = if i == selectedSlot then colors.Panel else colors.Muted
		button.BackgroundColor3 = if i == selectedSlot then CONFIG.Accent else colors.Surface
	end
end
local function refreshCoordinates()
	if savedPivot then
		local position = savedPivot.Position
		coordinates.Text = string.format("X %.1f   Y %.1f   Z %.1f", position.X, position.Y, position.Z)
	else
		coordinates.Text = "No position saved"
	end
end
for i = 1, 3 do
	local index = i
	local button = utilityButton("Slot" .. i, "", UDim2.new((i - 1) / 3, 16 - (i - 1) * 8, 0, 58), UDim2.new(1 / 3, -16, 0, 38), false)
	button.Font = Enum.Font.Code
	button.TextSize = 10
	table.insert(slotButtons, button)
	connect(button.Activated, function()
		selectedSlot = index
		savedPivot = savedPivots[index]
		refreshSlots()
		refreshCoordinates()
		teleportStatus.Text = "Selected bookmark " .. index .. "."
		teleportStatus.TextColor3 = colors.Muted
	end)
end
refreshSlots()
local teleporting = false
local lastTeleport = -math.huge
local function characterReady(): Model?
	local character = player.Character
	if not character or not character.Parent then return nil end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 or not character:FindFirstChild("HumanoidRootPart") then return nil end
	return character
end
local function reportPosition(message: string, failed: boolean?)
	teleportStatus.Text = message
	teleportStatus.TextColor3 = if failed then colors.Error else colors.Muted
end
connect(savePosition.Activated, function()
	local character = characterReady()
	if not character then reportPosition("Wait for your character to spawn.", true) return end
	savedPivot = character:GetPivot()
	savedPivots[selectedSlot] = savedPivot
	refreshSlots()
	refreshCoordinates()
	reportPosition("Bookmark " .. selectedSlot .. " saved for this session.")
end)
connect(clearPosition.Activated, function()
	savedPivot = nil
	savedPivots[selectedSlot] = nil
	refreshSlots()
	coordinates.Text = "No position saved"
	reportPosition("Bookmark cleared.")
end)
connect(goPosition.Activated, function()
	if teleporting or os.clock() - lastTeleport < 0.8 then return end
	local destination = savedPivot
	if not destination then reportPosition("Save a position first.", true) return end
	local character = characterReady()
	if not character then reportPosition("Wait for your character to spawn.", true) return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.SeatPart then reportPosition("Leave your seat before teleporting.", true) return end
	teleporting = true
	lastTeleport = os.clock()
	local ok = pcall(function()
		-- Local character movement, not a server permission or anticheat bypass.
		character:PivotTo(destination)
		local part = character:FindFirstChild("HumanoidRootPart")
		if part and part:IsA("BasePart") then
			part.AssemblyLinearVelocity = Vector3.zero
			part.AssemblyAngularVelocity = Vector3.zero
		end
	end)
	teleporting = false
	reportPosition(if ok then "Returned to saved spot (local movement)." else "Could not move your character.", not ok)
end)

local fpsPanel = create("Frame", {
	Name = "FPSMeter", AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(132, 48), BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0, Active = true, Visible = false,
}, root)
corner(fpsPanel, 12)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, fpsPanel)
for i = 1, 3 do
	local bar = create("Frame", {
		Position = UDim2.fromOffset(14 + (i - 1) * 5, 32 - i * 5),
		Size = UDim2.fromOffset(3, i * 5), BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0,
	}, fpsPanel)
	corner(bar, 1)
end
local fpsScale = create("UIScale", { Scale = 1 }, fpsPanel)
local fpsText = label(fpsPanel, "— FPS", 14, colors.Text)
fpsText.Name = "FPSValue"
fpsText.Font = Enum.Font.Code
fpsText.Position = UDim2.fromOffset(38, 0)
fpsText.Size = UDim2.new(1, -44, 1, 0)

local coordinatePanel = create("Frame", {
	Name = "CoordinateHUD", AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(224, 48), BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0, Active = true, Visible = false,
}, root)
corner(coordinatePanel, 12)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, coordinatePanel)
local coordinateScale = create("UIScale", { Scale = 1 }, coordinatePanel)
local coordinateText = label(coordinatePanel, "Waiting for character…", 11, colors.Text)
coordinateText.Name = "LiveCoordinates"
coordinateText.Font = Enum.Font.Code
coordinateText.Position = UDim2.fromOffset(12, 0)
coordinateText.Size = UDim2.new(1, -24, 1, 0)
local hudEnabled = false
local updateSession: ((number) -> ())? = nil
local sessionTime, telemetryTime = 0, 0

layoutExtras = function()
	local viewport = root.AbsoluteSize
	local scale = math.min(interfaceScale, math.max(0.1, (viewport.X - 24) / 320), math.max(0.1, (viewport.Y - 24) / 306))
	teleportScale.Scale = scale
	fpsScale.Scale = math.min(interfaceScale, math.max(0.1, (viewport.X - 24) / 132), math.max(0.1, (viewport.Y - 24) / 48))
	coordinateScale.Scale = math.min(interfaceScale, math.max(0.1, (viewport.X - 24) / 224), math.max(0.1, (viewport.Y - 24) / 48))
	for _, floating in ipairs({teleportPanel, fpsPanel, coordinatePanel}) do
		local size = if floating == teleportPanel then Vector2.new(320, 306) * scale
			elseif floating == fpsPanel then Vector2.new(132, 48) * fpsScale.Scale
			else Vector2.new(224, 48) * coordinateScale.Scale
		local preferred = if floating == teleportPanel then Vector2.new(math.min(viewport.X - 170, viewport.X / 2 + 210), viewport.Y / 2)
			elseif floating == fpsPanel then Vector2.new(viewport.X - 82, 40)
			else Vector2.new(viewport.X - 128, 96)
		local center = clampCenter(extraCenters[floating] or preferred, size)
		extraCenters[floating] = center
		floating.Position = UDim2.fromOffset(center.X, center.Y)
	end
end
layout()
draggable(teleportHeader, teleportPanel)
draggable(fpsPanel, fpsPanel)
draggable(coordinatePanel, coordinatePanel)

local glitchEnabled = not CONFIG.ReducedMotion
local fpsEnabled = false
local fpsFrames, fpsElapsed = 0, 0
local glitchClock, glitchRemaining = 0, 0
local ghosts: {TextLabel} = {}
for _, tint in ipairs({Color3.fromRGB(109, 225, 242), Color3.fromRGB(245, 120, 189)}) do
	local ghost = label(header, CONFIG.Name, 19, tint)
	ghost.Name = "GlitchLayer"
	ghost.Font = Enum.Font.Code
	ghost.Position = title.Position
	ghost.Size = title.Size
	ghost.TextTransparency = 1
	ghost.ZIndex = title.ZIndex + 1
	table.insert(ghosts, ghost)
end
local function resetTitle()
	title.Text = CONFIG.Name
	for _, ghost in ipairs(ghosts) do ghost.TextTransparency = 1 end
end
setTeleportEnabled = toggleRow("Teleport tools", "Three bookmarks · save & return", 0, false, function(enabled)
	teleportPanel.Visible = enabled
	layout()
end)
local setFPSEnabled = toggleRow("FPS meter", "Floating · drag to reposition", 58, false, function(enabled)
	fpsEnabled = enabled
	fpsPanel.Visible = enabled
	fpsFrames, fpsElapsed = 0, 0
	fpsText.Text = "— FPS"
	layout()
end)
local setGlitchEnabled = toggleRow("Glitch title", "Subtle RGB split · monospace", 116, glitchEnabled, function(enabled)
	glitchEnabled = enabled
	glitchClock, glitchRemaining = 0, 0
	resetTitle()
end)
local setHUDEnabled = toggleRow("Position HUD", "Live coordinates · draggable", 174, false, function(enabled)
	hudEnabled = enabled
	coordinatePanel.Visible = enabled
	layout()
end)
-- One render connection; telemetry is sampled twice a second, not every frame.
connect(RunService.RenderStepped, function(dt: number)
	sessionTime += dt
	telemetryTime += dt
	if telemetryTime >= 0.5 then
		telemetryTime = 0
		if hudEnabled then
			local character = characterReady()
			if character then
				local position = character:GetPivot().Position
				coordinateText.Text = string.format("X %.1f  Y %.1f  Z %.1f", position.X, position.Y, position.Z)
			else
				coordinateText.Text = "Waiting for character…"
			end
		end
		if updateSession then updateSession(sessionTime) end
	end
	if fpsEnabled then
		fpsFrames += 1
		fpsElapsed += dt
		if fpsElapsed >= 0.5 then
			local fps = math.floor(fpsFrames / fpsElapsed + 0.5)
			fpsText.Text = string.format("%d FPS", fps)
			fpsText.TextColor3 = if fps < 30 then colors.Error elseif fps < 50 then CONFIG.Accent else colors.Success
			fpsFrames, fpsElapsed = 0, 0
		end
	end
	if not glitchEnabled or CONFIG.ReducedMotion or not card.Visible then
		if glitchRemaining > 0 then resetTitle() end
		glitchRemaining = 0
		return
	end
	glitchClock += dt
	if glitchClock >= 3.6 then glitchClock = 0 glitchRemaining = 0.14 end
	if glitchRemaining > 0 then
		glitchRemaining = math.max(0, glitchRemaining - dt)
		if glitchRemaining == 0 then resetTitle() return end
		local shift = if math.floor(glitchRemaining * 60) % 2 == 0 then 2 else -2
		for i, ghost in ipairs(ghosts) do
			ghost.TextTransparency = 0.55
			ghost.Position = title.Position + UDim2.fromOffset(if i == 1 then shift else -shift, 0)
		end
		if #CONFIG.Name > 0 then
			local index = math.random(1, #CONFIG.Name)
			title.Text = string.sub(CONFIG.Name, 1, index - 1) .. "_" .. string.sub(CONFIG.Name, index + 1)
		end
	end
end)
local showDashboard: (() -> ())? = nil
local function showTools()
	dashboardOpen = true
	if showDashboard then showDashboard() end
	progressTrack.Position = UDim2.new(0, 24, 1, -72)
	status.Position = UDim2.new(0, 24, 1, -56)
	footer.Position = UDim2.new(0, 24, 1, -26)
	layout()
	welcome.Visible = false
	subtitle.Visible = false
	eyebrow.Visible = false
	launch.Visible = false
	tools.Visible = true
	footer.Text = "NULLX11  /  PERSONAL WORKSPACE"
end

-- Keep secondary pages in a local scope; callbacks retain only their own state.
do
	local tabs = create("Frame", {
		Name = "Navigation", BackgroundColor3 = colors.Surface, BorderSizePixel = 0,
		Position = UDim2.fromOffset(24, 94), Size = UDim2.new(1, -48, 0, 44), Visible = false,
	}, card)
	corner(tabs, 12)
	local function page(name: string, contentHeight: number)
		return create("ScrollingFrame", {
			Name = name, BackgroundTransparency = 1, BorderSizePixel = 0,
			Position = tools.Position, Size = tools.Size, Visible = false,
			CanvasSize = UDim2.fromOffset(0, contentHeight), ScrollBarThickness = 2,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, card)
	end
	local stylePage = page("StylePage", 330)
	local sessionPage = page("SessionPage", 370)
	local pages = {tools, stylePage, sessionPage}
	local tabButtons: {TextButton} = {}
	local function selectPage(index: number)
		for i, view in ipairs(pages) do
			view.Visible = i == index
			tween(tabButtons[i], {
				BackgroundTransparency = if i == index then 0 else 1,
				TextColor3 = if i == index then colors.Text else colors.Muted,
			})
		end
	end
	for i, name in ipairs({"Tools", "Style", "Session"}) do
		local index = i
		local button = create("TextButton", {
			Name = "Tab" .. name, Text = name, TextSize = 12, Font = Enum.Font.GothamMedium,
			Position = UDim2.new((i - 1) / 3, 4, 0, 4), Size = UDim2.new(1 / 3, -8, 1, -8),
			TextColor3 = colors.Muted, BackgroundColor3 = Color3.fromRGB(43, 43, 58),
			BorderSizePixel = 0, AutoButtonColor = false,
		}, tabs)
		corner(button, 9)
		table.insert(tabButtons, button)
		connect(button.Activated, function() selectPage(index) end)
	end
	showDashboard = function()
		tabs.Visible = true
		selectPage(1)
	end
	local function section(parent: Instance, text: string, y: number)
		local heading = label(parent, text, 10, colors.Muted)
		heading.Font = Enum.Font.Code
		heading.Position = UDim2.fromOffset(0, y)
		heading.Size = UDim2.new(1, 0, 0, 20)
	end
	local function action(parent: Instance, name: string, text: string, position: UDim2, size: UDim2, callback: () -> ())
		local button = create("TextButton", {
			Name = name, Text = text, TextSize = 12, Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text, BackgroundColor3 = colors.Surface,
			Position = position, Size = size, BorderSizePixel = 0, AutoButtonColor = false,
		}, parent)
		corner(button, 10)
		connect(button.Activated, callback)
		connect(button.MouseEnter, function() tween(button, { BackgroundTransparency = 0.2 }) end)
		connect(button.MouseLeave, function() tween(button, { BackgroundTransparency = 0 }) end)
		return button
	end
	local function applyTheme(accent: Color3, name: string)
		local previousAccent = CONFIG.Accent
		CONFIG.Accent = accent
		-- Recolor only objects using the old accent, never unrelated status colors.
		for _, object in ipairs(gui:GetDescendants()) do
			if object:IsA("GuiObject") then
				if object.BackgroundColor3 == previousAccent then object.BackgroundColor3 = accent end
				if (object:IsA("TextLabel") or object:IsA("TextButton"))
					and string.sub(object.Name, 1, 5) ~= "Theme" and object.TextColor3 == previousAccent then
					object.TextColor3 = accent
				end
				if object:IsA("ScrollingFrame") and object.ScrollBarImageColor3 == previousAccent then
					object.ScrollBarImageColor3 = accent
				end
			elseif object:IsA("UIStroke") and object.Color == previousAccent then
				object.Color = accent
			elseif object:IsA("UIGradient") and object.Name == "BrandGradient" then
				object.Color = ColorSequence.new(accent, Color3.fromRGB(112, 113, 221))
			end
		end
		refreshSlots()
		status.Text = name .. " accent selected."
	end
	section(stylePage, "01 / ACCENT", 0)
	for i, theme in ipairs({
		{ Name = "Violet", Color = Color3.fromRGB(167, 146, 255) },
		{ Name = "Mint", Color = Color3.fromRGB(126, 222, 185) },
		{ Name = "Ice", Color = Color3.fromRGB(129, 200, 255) },
	}) do
		local choice = theme
		local button = action(stylePage, "Theme" .. theme.Name, theme.Name,
			UDim2.new((i - 1) / 3, 0, 0, 27), UDim2.new(1 / 3, -6, 0, 44), function()
				applyTheme(choice.Color, choice.Name)
			end)
		button.TextColor3 = theme.Color
	end
	toggleRow("Reduced motion", "Disable transitions and title glitch", 86, CONFIG.ReducedMotion, function(enabled)
		CONFIG.ReducedMotion = enabled
		if enabled then setGlitchEnabled(false) resetTitle() end
	end, stylePage)
	toggleRow("Lock windows", "Dock stays movable for easy recovery", 144, false, function(enabled)
		windowsPinned = enabled
		if enabled then drag = nil end
	end, stylePage)
	section(stylePage, "02 / INTERFACE SIZE", 211)
	for i, size in ipairs({{ "Small", 0.85 }, { "Default", 1 }, { "Large", 1.1 }}) do
		local factor = size[2] :: number
		action(stylePage, "Scale" .. size[1], size[1] :: string,
			UDim2.new((i - 1) / 3, 0, 0, 239), UDim2.new(1 / 3, -6, 0, 44), function()
				interfaceScale = factor
				layout()
				status.Text = "Interface size updated."
			end)
	end
	local motionHint = label(stylePage, "Preferences last for this run. No files are written.", 10, colors.Muted)
	motionHint.Position = UDim2.fromOffset(0, 294)
	motionHint.Size = UDim2.new(1, -4, 0, 28)
	motionHint.TextWrapped = true

	section(sessionPage, "LOCAL SESSION", 0)
	local identity = label(sessionPage, "@" .. (player.Name or "Player"), 16, colors.Text)
	identity.Font = Enum.Font.GothamBold
	identity.Position = UDim2.fromOffset(0, 28)
	identity.Size = UDim2.new(1, 0, 0, 26)
	local sessionStats = label(sessionPage, "00:00  /  0 of 3 bookmarks", 12, CONFIG.Accent)
	sessionStats.Name = "SessionStats"
	sessionStats.Font = Enum.Font.Code
	sessionStats.Position = UDim2.fromOffset(0, 64)
	sessionStats.Size = UDim2.new(1, 0, 0, 26)
	updateSession = function(elapsed: number)
		if not sessionPage.Visible then return end
		local count = 0
		for _ in pairs(savedPivots) do count += 1 end
		local seconds = math.floor(elapsed)
		sessionStats.Text = string.format("%02d:%02d  /  %d of 3 bookmarks", math.floor(seconds / 60), seconds % 60, count)
	end
	action(sessionPage, "ResetLayout", "Recenter all windows", UDim2.fromOffset(0, 108), UDim2.new(1, -4, 0, 46), function()
		panelCenter = nil
		miniCenter = nil
		table.clear(extraCenters)
		drag = nil
		layout()
		status.Text = "Window positions reset."
	end)
	action(sessionPage, "HideUtilities", "Hide floating utilities", UDim2.fromOffset(0, 164), UDim2.new(1, -4, 0, 46), function()
		if setTeleportEnabled then setTeleportEnabled(false) end
		setFPSEnabled(false)
		setHUDEnabled(false)
		status.Text = "Floating utilities hidden."
	end)
	local clearDeadline = 0
	local clearAll: TextButton? = nil
	clearAll = action(sessionPage, "ClearBookmarks", "Clear all bookmarks", UDim2.fromOffset(0, 220), UDim2.new(1, -4, 0, 46), function()
		local button = clearAll
		if not button then return end
		if clearDeadline == 0 or os.clock() > clearDeadline then
			clearDeadline = os.clock() + 3
			button.Text = "Tap again within 3s to clear"
			return
		end
		clearDeadline = 0
		table.clear(savedPivots)
		savedPivot = nil
		refreshCoordinates()
		refreshSlots()
		button.Text = "Clear all bookmarks"
		status.Text = "All bookmarks cleared."
	end)
	local hint = label(sessionPage, "RIGHT SHIFT toggles the dashboard.\nDrag the dock to move it; tap to show or hide.\nTeleports are local and can be reset by the server.", 11, colors.Muted)
	hint.Position = UDim2.fromOffset(0, 282)
	hint.Size = UDim2.new(1, -4, 0, 74)
	hint.TextWrapped = true
	connect(UserInputService.InputBegan, function(input: InputObject, processed: boolean)
		if processed or UserInputService:GetFocusedTextBox() then return end
		if input.KeyCode == Enum.KeyCode.RightShift then setExpanded(not expanded) end
	end)
end

local busy = false
local loaded = false
local function buttonColor(hovered: boolean)
	if busy or loaded then return end
	tween(launch, { BackgroundColor3 = if hovered then CONFIG.Accent:Lerp(Color3.new(1, 1, 1), 0.16) else CONFIG.Accent })
end
connect(launch.MouseEnter, function() buttonColor(true) end)
connect(launch.MouseLeave, function() buttonColor(false) end)
connect(launch.SelectionGained, function() buttonColor(true) end)
connect(launch.SelectionLost, function() buttonColor(false) end)

connect(launch.Activated, function()
	if busy or loaded or not alive then return end
	busy = true
	launch.Text = "Loading…"
	launch.Selectable = false
	status.TextColor3 = colors.Muted
	progressFill.BackgroundColor3 = CONFIG.Accent
	tween(launch, { BackgroundColor3 = CONFIG.Accent })
	tween(progressFill, { Size = UDim2.fromScale(0, 1) }, 0)

	-- No downloaded code, artificial loading delays, or simulated network checks.
	local ok, result = pcall(function(): boolean
		status.Text = "Waiting for the game…"
		while not game:IsLoaded() do
			if not alive then return false end
			task.wait(0.1)
		end
		if not alive then return false end
		tween(progressFill, { Size = UDim2.fromScale(0.2, 1) })
		local app = if appContainer then appContainer:FindFirstChild("App") else nil
		if not app then return false end
		assert(app:IsA("ModuleScript"), "App must be a ModuleScript")
		status.Text = "Starting your app…"
		local initialize = require(app)
		assert(type(initialize) == "function", "App must return a function")
		if not alive then return false end
		initialize({
			Player = player,
			-- Report real work completed: 0 to 1, not an estimated timer.
			SetProgress = function(fraction: number, message: string?)
				if not alive then return end
				assert(type(fraction) == "number" and fraction == fraction, "Progress must be a number")
				tween(progressFill, { Size = UDim2.fromScale(0.2 + math.clamp(fraction, 0, 1) * 0.8, 1) })
				if message then status.Text = message end
			end,
			IsCancelled = function(): boolean return not alive end,
		})
		return true
	end)
	if not alive then return end
	busy = false
	launch.Selectable = true
	if ok then
		loaded = true
		launch.Text = "Ready  ✓"
		status.Text = if result then "App and tools ready." else "Tools ready. Make yourself at home."
		showTools()
		status.TextColor3 = colors.Success
		tween(progressFill, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = colors.Success })
	else
		launch.Text = "Try again  →"
		status.Text = "Could not start. See Output for details."
		status.TextColor3 = colors.Error
		tween(progressFill, { Size = UDim2.fromScale(0, 1), BackgroundColor3 = colors.Error })
		warn("[Nullx11] App failed: " .. tostring(result))
	end
end)

connect(gui.Destroying, function()
	alive = false
	drag = nil
	for _, connection in ipairs(connections) do connection:Disconnect() end
	table.clear(connections)
	for _, animations in pairs(activeTweens) do
		for _, animation in pairs(animations) do animation:Cancel() end
	end
	table.clear(activeTweens)
end)

-- AbsoluteSize can be zero until Roblox's first layout pass. In that case,
-- the size-change listener above positions the panel once safe bounds exist.
-- Never wait for a render frame in a way that leaves stale tasks on reruns.
if panelCenter then
	local destination = UDim2.fromOffset(panelCenter.X, panelCenter.Y)
	card.Position = destination + UDim2.fromOffset(0, 8)
	tween(card, { Position = destination }, 0.3)
end
