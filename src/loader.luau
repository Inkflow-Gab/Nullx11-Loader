--!strict
-- Nullx11 • Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Built-in session tools; optional ModuleScript child "App". See README.md.

-- @NULLX11_UI_FACTORY

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CONFIG = {
	Name = "Nullx11",
	Subtitle = "Developed by Gab.",
	Accent = Color3.fromRGB(167, 146, 255),
	ReducedMotion = false,
	StartupAnimation = true,
	EnhancedWorkspace = true,
	ScriptBaseURL = "https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/scripts/",
}

-- External runtimes may not provide the LocalScript instance.
local appContainer = if typeof(script) == "Instance" then script else nil
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- Re-running the script closes its previous instance and its connections.
local previous = playerGui:FindFirstChild("Nullx11Loader")
if previous then
	previous:Destroy()
end

local colors = {
	Panel = Color3.fromRGB(12, 16, 28),
	Surface = Color3.fromRGB(23, 29, 46),
	Border = Color3.fromRGB(60, 75, 104),
	Text = Color3.fromRGB(242, 241, 249),
	Muted = Color3.fromRGB(178, 190, 211),
	Error = Color3.fromRGB(255, 151, 160),
	Success = Color3.fromRGB(143, 221, 182),
}

-- Runtime appearance bridge. The optional Design Studio updates only UI state.
local appearance = {
	Width = 440,
	Height = 520,
	Duration = 1,
	Easing = Enum.EasingStyle.Quint,
	GlitchInterval = 3.6,
	GlitchDuration = 0.14,
	GlitchOffset = 2,
	FPSInterval = 0.5,
	TelemetryInterval = 0.5,
	FPSGraph = true,
	FPSHeight = 64,
	HUDWidth = 224,
	CoordinateFormat = "X %.1f  Y %.1f  Z %.1f",
	ToggleKey = Enum.KeyCode.RightShift,
	DockOpacity = 100,
}
local studioBridge: { [string]: any } = {}
local playerToolsBridge: { [string]: any } = {}
local dashboardOpen = false
local interfaceScale = 1
local windowsPinned = false
local snapDockToEdge = false
local alive = true
local connections: { RBXScriptConnection } = {}
local themeRefreshers: { () -> () } = {}
local activeTweens: { [Instance]: { [string]: Tween } } = {}
local function connect(
	signal: RBXScriptSignal,
	callback: any
): RBXScriptConnection
	local connection = signal:Connect(callback)
	table.insert(connections, connection)
	return connection
end

local function create(
	className: string,
	properties: { [string]: any },
	parent: Instance?
): any
	if properties.TextSize then
		properties.TextSize = math.max(14, properties.TextSize)
	end
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

local function tween(
	object: Instance,
	properties: { [string]: any },
	duration: number?,
	easing: Enum.EasingStyle?
)
	if not alive then
		return
	end
	-- Cancel overlapping animations so rapid taps never fight previous tweens.
	local running = activeTweens[object]
	if not running then
		running = {}
		activeTweens[object] = running
	end
	for property in pairs(properties) do
		local prior = running[property]
		if prior then
			prior:Cancel()
		end
	end
	local animation = TweenService:Create(
		object,
		TweenInfo.new(
			if CONFIG.ReducedMotion
				then 0
				else (duration or 0.18) * appearance.Duration,
			easing or appearance.Easing,
			Enum.EasingDirection.Out
		),
		properties
	)
	for property in pairs(properties) do
		running[property] = animation
	end
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
	Name = "SafeArea",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
}, gui)

local card = create("Frame", {
	Name = "Panel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(440, 360),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
}, root)
corner(card, 20)
create("UIGradient", {
	Color = ColorSequence.new(colors.Panel, Color3.fromRGB(26, 26, 37)),
	Rotation = 115,
}, card)
create(
	"UIStroke",
	{ Color = colors.Border, Transparency = 0.2, Thickness = 1 },
	card
)
local responsiveScale = create("UIScale", { Scale = 1 }, card)

local function label(
	parent: Instance,
	text: string,
	size: number,
	color: Color3
): TextLabel
	return create("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = size,
		TextColor3 = color,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, parent)
end

local header = create("Frame", {
	Name = "DragHandle",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -112, 0, 78),
	Position = UDim2.fromOffset(0, 0),
	Active = true,
}, card)
local mark = create("Frame", {
	Position = UDim2.fromOffset(24, 26),
	Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
}, header)
corner(mark, 9)
create("UIGradient", {
	Name = "BrandGradient",
	Color = ColorSequence.new(CONFIG.Accent, Color3.fromRGB(112, 113, 221)),
	Rotation = 45,
}, mark)
-- Original geometric N mark, drawn from UI primitives (no uploaded asset).
local function drawIcon(
	parent: Instance,
	ink: Color3,
	position: UDim2,
	size: number
)
	local icon = create("Frame", {
		Name = "Nullx11Icon",
		BackgroundTransparency = 1,
		Position = position,
		Size = UDim2.fromOffset(size, size),
	}, parent)
	for strokeIndex, geometry in ipairs({
		{ 0.35, 0.28, 0.1, 0.42, 55 },
		{ 0.65, 0.28, 0.1, 0.42, -55 },
		{ 0.35, 0.72, 0.1, 0.42, -55 },
		{ 0.65, 0.72, 0.1, 0.42, 55 },
		{ 0.18, 0.50, 0.08, 0.36, 0 },
		{ 0.82, 0.50, 0.08, 0.36, 0 },
		{ 0.50, 0.50, 0.21, 0.21, 45 },
	}) do
		local line = create("Frame", {
			Name = "BrandStroke" .. strokeIndex,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(geometry[1], geometry[2]),
			Size = UDim2.fromScale(geometry[3], geometry[4]),
			Rotation = geometry[5],
			BackgroundColor3 = ink,
			BorderSizePixel = 0,
		}, icon)
		corner(line, 2)
	end
	return icon
end
drawIcon(mark, colors.Panel, UDim2.fromOffset(3, 3), 24)
local title = label(header, CONFIG.Name, 21, colors.Text)
title.Name = "Title"
title.Font = Enum.Font.Code
title.Position = UDim2.fromOffset(65, 26)
title.Size = UDim2.new(1, -65, 0, 30)
local edition = label(header, "DEVELOPED BY GAB", 8, colors.Muted)
edition.Font = Enum.Font.Code
edition.Position = UDim2.fromOffset(65, 55)
edition.Size = UDim2.new(1, -65, 0, 13)

local function iconButton(
	text: string,
	x: number,
	description: string
): TextButton
	local button = create("TextButton", {
		Name = description,
		Text = text,
		TextSize = 22,
		Font = Enum.Font.Gotham,
		TextColor3 = colors.Muted,
		AutoButtonColor = false,
		BackgroundColor3 = colors.Surface,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, x, 0, 19),
		Size = UDim2.fromOffset(44, 44),
	}, card)
	corner(button, 12)
	connect(button.MouseEnter, function()
		tween(button, { BackgroundTransparency = 0 })
	end)
	connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = 1 })
	end)
	connect(button.SelectionGained, function()
		tween(button, { BackgroundTransparency = 0 })
	end)
	connect(button.SelectionLost, function()
		tween(button, { BackgroundTransparency = 1 })
	end)
	return button
end
local minimize = iconButton("−", -108, "Minimize")
local close = iconButton("×", -60, "Close")

create("Frame", {
	BackgroundColor3 = colors.Border,
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(24, 81),
	Size = UDim2.new(1, -48, 0, 1),
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
	Name = "Load",
	Position = UDim2.fromOffset(24, 212),
	Size = UDim2.new(1, -48, 0, 50),
	BackgroundColor3 = CONFIG.Accent,
	Text = "Load  →",
	TextColor3 = colors.Panel,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	BorderSizePixel = 0,
}, card)
corner(launch, 12)
local progressTrack = create("Frame", {
	Position = UDim2.fromOffset(24, 280),
	Size = UDim2.new(1, -48, 0, 3),
	BackgroundColor3 = colors.Surface,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, card)
corner(progressTrack, 2)
local progressFill = create("Frame", {
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
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
	Name = "RestoreNullx11",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(60, 60),
	BackgroundColor3 = colors.Panel,
	TextColor3 = CONFIG.Accent,
	Text = "",
	TextSize = 15,
	Font = Enum.Font.Code,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Visible = true,
}, root)
corner(mini, 19)
create(
	"UIGradient",
	{ Color = ColorSequence.new(colors.Surface, colors.Panel), Rotation = 110 },
	mini
)
drawIcon(mini, Color3.fromRGB(150, 238, 226), UDim2.fromOffset(15, 12), 30)
local dockCaption = label(mini, "11 /", 8, colors.Muted)
dockCaption.Name = "DockCaption"
dockCaption.TextSize = 14
dockCaption.Font = Enum.Font.Code
dockCaption.Position = UDim2.fromOffset(0, 43)
dockCaption.Size = UDim2.new(1, 0, 0, 16)
dockCaption.TextXAlignment = Enum.TextXAlignment.Center
local dockDot = create("Frame", {
	Name = "DockStatus",
	Position = UDim2.new(1, -11, 0, 7),
	Size = UDim2.fromOffset(4, 4),
	BackgroundColor3 = colors.Success,
	BorderSizePixel = 0,
}, mini)
corner(dockDot, 4)
create("UIStroke", { Color = CONFIG.Accent, Transparency = 0.45 }, mini)

-- Real TweenService window transport. One cancellable token per window.
local portal: { [string]: any } = { Jobs = {} }
do
	local halo = create("Frame", {
		Name = "DockPortalHalo",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(54, 54),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, mini)
	corner(halo, 100)
	local haloStroke = create("UIStroke", {
		Color = Color3.fromRGB(115, 235, 224),
		Thickness = 1.5,
		Transparency = 0.65,
	}, halo)
	local rim = create("Frame", {
		Name = "DockCrystalRim",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.77, 0.77),
		BackgroundTransparency = 1,
		Rotation = 45,
		BorderSizePixel = 0,
	}, mini)
	corner(rim, 12)
	create(
		"UIStroke",
		{ Color = CONFIG.Accent, Transparency = 0.65, Thickness = 1 },
		rim
	)
	for index = 1, 4 do
		local tick = create("Frame", {
			Name = "DockRune" .. index,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(
				if index % 2 == 0 then 0.87 else 0.13,
				if index <= 2 then 0.17 else 0.83
			),
			Size = UDim2.fromOffset(3, 3),
			Rotation = 45,
			BackgroundColor3 = Color3.fromRGB(115, 235, 224),
			BorderSizePixel = 0,
		}, mini)
		corner(tick, 1)
	end
	function portal.CancelTweens(target: GuiObject)
		for _, object in ipairs({
			target,
			target:FindFirstChildOfClass("UIScale"),
		}) do
			for property, animation in pairs(activeTweens[object] or {}) do
				if
					property == "Position"
					or property == "Rotation"
					or property == "Scale"
				then
					animation:Cancel()
				end
			end
		end
	end
	function portal.Play(target: GuiObject, show: boolean, done: (() -> ())?)
		local previousJob = portal.Jobs[target]
		if not previousJob and target.Visible == show then
			if done then
				done()
			end
			return
		end
		local scale = target:FindFirstChildOfClass("UIScale")
			or create("UIScale", { Name = "PortalScale", Scale = 1 }, target)
		local pose = if previousJob
			then previousJob.Pose
			else {
				Position = target.Position,
				Scale = scale.Scale,
				Rotation = target.Rotation or 0,
			}
		local job = { Pose = pose, Show = show, Done = done }
		portal.Jobs[target] = job
		local function finish()
			if not alive or portal.Jobs[target] ~= job then
				return
			end
			portal.Jobs[target] = nil
			portal.CancelTweens(target)
			target.Visible = show
			target.Position = pose.Position
			target.Rotation = pose.Rotation
			scale.Scale = pose.Scale
			if done then
				done()
			end
		end
		if CONFIG.ReducedMotion then
			finish()
			return
		end
		target.Visible = true
		if show and not previousJob then
			target.Position = mini.Position
			target.Rotation = -16
			scale.Scale = pose.Scale * 0.08
		end
		local duration = 0.42
		tween(
			target,
			{
				Position = if show then pose.Position else mini.Position,
				Rotation = if show then pose.Rotation else 18,
			},
			duration,
			if show then Enum.EasingStyle.Back else Enum.EasingStyle.Quint
		)
		tween(
			scale,
			{ Scale = pose.Scale * (if show then 1 else 0.06) },
			duration,
			if show then Enum.EasingStyle.Back else Enum.EasingStyle.Quint
		)
		-- The restore icon is intentionally static, including while windows move.
		task.delay(duration * appearance.Duration, finish)
	end
	function portal.Settle()
		for target, job in pairs(portal.Jobs) do
			portal.Jobs[target] = nil
			portal.CancelTweens(target)
			target.Visible = job.Show
			target.Position = job.Pose.Position
			target.Rotation = job.Pose.Rotation
			local scale = target:FindFirstChildOfClass("UIScale")
			if scale then
				scale.Scale = job.Pose.Scale
			end
			if job.Done then
				job.Done()
			end
		end
	end
end

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
-- Snap only the dock to the nearest horizontal edge; preserve its vertical position.
local function snapDock(animated: boolean)
	local viewport = root.AbsoluteSize
	if not miniCenter or viewport.X <= 0 or viewport.Y <= 0 then
		return
	end
	miniCenter = clampCenter(
		Vector2.new(
			if miniCenter.X < viewport.X / 2 then 0 else viewport.X,
			miniCenter.Y
		),
		mini.AbsoluteSize
	)
	local destination = UDim2.fromOffset(miniCenter.X, miniCenter.Y)
	if animated then
		tween(mini, { Position = destination }, 0.22)
	else
		mini.Position = destination
	end
end
local extraCenters: { [GuiObject]: Vector2 } = {}
local layoutExtras: (() -> ())? = nil
local function layout()
	local viewport = root.AbsoluteSize
	if viewport.X <= 0 or viewport.Y <= 0 then
		return
	end
	for _, target in ipairs({ card, mini }) do
		local animations = activeTweens[target]
		if animations and animations.Position and not portal.Jobs[target] then
			animations.Position:Cancel()
		end
	end
	local height = if dashboardOpen
		then math.min(
			appearance.Height,
			math.max(240, (viewport.Y - 24) / interfaceScale)
		)
		else 360
	local scale =
		math.min(interfaceScale, math.max(0.1, (viewport.Y - 24) / height))
	if not portal.Jobs[card] then
		responsiveScale.Scale = scale
	end
	local width =
		math.min(appearance.Width, math.max(1, (viewport.X - 24) / scale))
	card.Size = UDim2.fromOffset(width, height)
	panelCenter = clampCenter(
		panelCenter or viewport / 2,
		Vector2.new(width, height) * scale
	)
	miniCenter = clampCenter(
		miniCenter
			or Vector2.new(
				if viewport.X > viewport.Y then viewport.X - 48 else 48,
				viewport.Y - 46
			),
		mini.AbsoluteSize
	)
	if not portal.Jobs[card] then
		card.Position = UDim2.fromOffset(panelCenter.X, panelCenter.Y)
	end
	mini.Position = UDim2.fromOffset(miniCenter.X, miniCenter.Y)
	if snapDockToEdge then
		snapDock(false)
	end
	if layoutExtras then
		layoutExtras()
	end
end
connect(root:GetPropertyChangedSignal("AbsoluteSize"), function()
	portal.Settle()
	if alive then
		layout()
	end
end)
layout()

-- One input path for touch and mouse; no per-frame polling or mouse-only dragging.
local drag: {
	input: InputObject,
	start: Vector2,
	center: Vector2,
	target: GuiObject,
	moved: boolean,
}? =
	nil
local suppressRestoreUntil = 0
local function draggable(handle: GuiObject, target: GuiObject)
	connect(handle.InputBegan, function(input: InputObject)
		if
			drag
			or portal.Jobs[target]
			or transitioning
			or (windowsPinned and target ~= mini)
		then
			return
		end
		if
			input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		local animations = activeTweens[target]
		if animations and animations.Position then
			animations.Position:Cancel()
		end
		drag = {
			input = input,
			start = Vector2.new(input.Position.X, input.Position.Y),
			center = target.AbsolutePosition
				- root.AbsolutePosition
				+ target.AbsoluteSize / 2,
			target = target,
			moved = false,
		}
	end)
end
draggable(header, card)
draggable(mini, mini)
connect(UserInputService.InputChanged, function(input: InputObject)
	local current = drag
	if not current then
		return
	end
	if
		input ~= current.input
		and not (
			current.input.UserInputType == Enum.UserInputType.MouseButton1
			and input.UserInputType == Enum.UserInputType.MouseMovement
		)
	then
		return
	end
	local delta = Vector2.new(input.Position.X, input.Position.Y)
		- current.start
	if delta.Magnitude > 6 then
		current.moved = true
	end
	if not current.moved then
		return
	end
	if current.target == mini then
		suppressRestoreUntil = os.clock() + 0.3
	end
	local center =
		clampCenter(current.center + delta, current.target.AbsoluteSize)
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
		if drag.target == mini and drag.moved then
			suppressRestoreUntil = os.clock() + 0.3
			if snapDockToEdge then
				snapDock(true)
			end
		end
		drag = nil
	end
end)
connect(UserInputService.WindowFocusReleased, function()
	drag = nil
end)

local function setExpanded(value: boolean)
	if value == expanded then
		return
	end
	transitioning = true
	drag = nil
	expanded = value
	mini.Visible = true
	dockDot.BackgroundColor3 = if value then colors.Success else CONFIG.Accent
	layout()
	portal.Play(card, value, function()
		transitioning = false
	end)
end

connect(minimize.Activated, function()
	setExpanded(false)
end)
connect(mini.Activated, function()
	if os.clock() >= suppressRestoreUntil then
		setExpanded(not expanded)
	end
end)
connect(close.Activated, function()
	if portal.Closing then
		return
	end
	portal.Closing = true
	if playerToolsBridge.Stop then
		playerToolsBridge.Stop()
	end
	if card.Visible then
		for _, window in ipairs(root:GetChildren()) do
			if
				window ~= card
				and window ~= mini
				and window:IsA("GuiObject")
				and window.Visible
			then
				portal.Play(window, false)
			end
		end
	end
	portal.Play(card, false, function()
		if alive then
			gui:Destroy()
		end
	end)
end)
connect(mini.MouseButton1Down, function()
	tween(mini, {
		BackgroundTransparency = math.min(
			1,
			1 - appearance.DockOpacity / 100 + 0.15
		),
	}, 0.1)
end)
connect(mini.MouseButton1Up, function()
	tween(
		mini,
		{ BackgroundTransparency = 1 - appearance.DockOpacity / 100 },
		0.1
	)
end)
connect(mini.MouseLeave, function()
	tween(
		mini,
		{ BackgroundTransparency = 1 - appearance.DockOpacity / 100 },
		0.1
	)
end)

-- Built-in tools: toggles live in the main panel; each utility floats separately.
local tools = create("ScrollingFrame", {
	Name = "Tools",
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(24, 152),
	Size = UDim2.new(1, -48, 1, -234),
	CanvasSize = UDim2.fromOffset(0, 232),
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
	Visible = false,
}, card)
local function toggleRow(
	name: string,
	hint: string,
	y: number,
	initial: boolean,
	changed: (boolean) -> (),
	parent: Instance?
): (boolean) -> ()
	local enabled = initial
	local row = create("TextButton", {
		Name = name,
		Text = "",
		AutoButtonColor = false,
		Position = UDim2.fromOffset(0, y),
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = colors.Surface,
		BorderSizePixel = 0,
	}, parent or tools)
	corner(row, 10)
	local heading = label(row, name, 16, colors.Text)
	heading.Position = UDim2.fromOffset(12, 6)
	heading.Size = UDim2.new(1, -104, 0, 20)
	heading.Font = Enum.Font.GothamMedium
	local description = label(row, hint, 10, colors.Muted)
	description.Position = UDim2.fromOffset(12, 30)
	description.Size = UDim2.new(1, -104, 0, 22)
	description.TextTruncate = Enum.TextTruncate.AtEnd
	local indicator = label(row, "", 9, CONFIG.Accent)
	indicator.Name = "ToggleState"
	indicator.Font = Enum.Font.Code
	indicator.Position = UDim2.new(1, -91, 0, 0)
	indicator.Size = UDim2.fromOffset(30, 50)
	indicator.TextXAlignment = Enum.TextXAlignment.Center
	local track = create("Frame", {
		Name = "SwitchTrack",
		Position = UDim2.new(1, -56, 0, 13),
		Size = UDim2.fromOffset(44, 24),
		BackgroundColor3 = colors.Border,
		BorderSizePixel = 0,
	}, row)
	corner(track, 12)
	local thumb = create("Frame", {
		Name = "SwitchThumb",
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = colors.Muted,
		BorderSizePixel = 0,
	}, track)
	corner(thumb, 9)
	local function paint()
		tween(track, {
			BackgroundColor3 = if enabled then CONFIG.Accent else colors.Border,
		})
		tween(thumb, {
			Position = UDim2.fromOffset(if enabled then 23 else 3, 3),
			BackgroundColor3 = if enabled then colors.Panel else colors.Muted,
		})
		indicator.Text = if enabled then "ON" else "OFF"
		indicator.TextColor3 = if enabled then CONFIG.Accent else colors.Muted
	end
	paint()
	table.insert(themeRefreshers, paint)
	local function setEnabled(value: boolean)
		enabled = value
		paint()
		changed(enabled)
	end
	connect(row.Activated, function()
		setEnabled(not enabled)
	end)
	return setEnabled
end

local teleportPanel = create("Frame", {
	Name = "TeleportPanel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(320, 362),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
	Visible = false,
}, root)
corner(teleportPanel, 16)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, teleportPanel)
local teleportScale = create("UIScale", { Scale = 1 }, teleportPanel)
local teleportHeader = create("Frame", {
	Name = "TeleportDragHandle",
	BackgroundTransparency = 1,
	Active = true,
	Size = UDim2.new(1, -60, 0, 56),
}, teleportPanel)
drawIcon(teleportHeader, CONFIG.Accent, UDim2.fromOffset(16, 17), 22)
local teleportTitle = label(teleportHeader, "POSITION", 13, colors.Text)
teleportTitle.Font = Enum.Font.Code
teleportTitle.Position = UDim2.fromOffset(48, 0)
teleportTitle.Size = UDim2.new(1, -48, 1, 0)
local teleportHide = create("TextButton", {
	Name = "HideTeleport",
	Text = "−",
	TextSize = 22,
	TextColor3 = colors.Muted,
	Font = Enum.Font.Code,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -52, 0, 6),
	Size = UDim2.fromOffset(44, 44),
}, teleportPanel)
-- Hiding keeps the bookmark; the main toggle can reopen this utility.
local setTeleportEnabled: ((boolean) -> ())? = nil
connect(teleportHide.Activated, function()
	if setTeleportEnabled then
		setTeleportEnabled(false)
	end
end)
local coordinates = label(teleportPanel, "No position saved", 12, colors.Muted)
coordinates.Name = "Coordinates"
coordinates.Font = Enum.Font.Code
coordinates.Position = UDim2.fromOffset(16, 151)
coordinates.Size = UDim2.new(1, -32, 0, 28)
coordinates.TextScaled = true
create(
	"UITextSizeConstraint",
	{ MinTextSize = 9, MaxTextSize = 12 },
	coordinates
)
local teleportStatus =
	label(teleportPanel, "Save a spot, then return to it.", 11, colors.Muted)
teleportStatus.Name = "TeleportStatus"
teleportStatus.Position = UDim2.fromOffset(16, 313)
teleportStatus.Size = UDim2.new(1, -32, 0, 38)
teleportStatus.TextWrapped = true
local function utilityButton(
	name: string,
	text: string,
	position: UDim2,
	size: UDim2,
	primary: boolean
): TextButton
	local button = create("TextButton", {
		Name = name,
		Text = text,
		Position = position,
		Size = size,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		AutoButtonColor = false,
		TextColor3 = if primary then colors.Panel else colors.Text,
		BackgroundColor3 = if primary then CONFIG.Accent else colors.Surface,
		BorderSizePixel = 0,
	}, teleportPanel)
	corner(button, 10)
	connect(button.MouseButton1Down, function()
		tween(button, { BackgroundTransparency = 0.25 }, 0.1)
	end)
	connect(button.MouseButton1Up, function()
		tween(button, { BackgroundTransparency = 0 }, 0.1)
	end)
	connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = 0 }, 0.1)
	end)
	return button
end
local savePosition = utilityButton(
	"SavePosition",
	"Save position",
	UDim2.fromOffset(16, 206),
	UDim2.new(0.5, -20, 0, 46),
	false
)
local clearPosition = utilityButton(
	"ClearPosition",
	"Clear",
	UDim2.new(0.5, 4, 0, 206),
	UDim2.new(0.5, -20, 0, 46),
	false
)
local goPosition = utilityButton(
	"TeleportToPosition",
	"Teleport to saved spot  →",
	UDim2.fromOffset(16, 260),
	UDim2.new(1, -32, 0, 46),
	true
)
local savedPivot: CFrame? = nil
local savedPivots: { [number]: CFrame } = {}
local selectedSlot = 1
local slotButtons: { TextButton } = {}
local bookmarkNames = { "Spot 1", "Spot 2", "Spot 3" }
local nameInput = create("TextBox", {
	Name = "BookmarkName",
	Text = bookmarkNames[1],
	PlaceholderText = "Name this spot",
	ClearTextOnFocus = false,
	MultiLine = false,
	TextSize = 13,
	Font = Enum.Font.GothamMedium,
	TextColor3 = colors.Text,
	PlaceholderColor3 = colors.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundColor3 = colors.Surface,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(16, 105),
	Size = UDim2.new(1, -32, 0, 40),
}, teleportPanel)
corner(nameInput, 10)
create(
	"UIPadding",
	{ PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) },
	nameInput
)
local distanceText =
	label(teleportPanel, "Save a spot to measure distance", 10, colors.Muted)
distanceText.Name = "BookmarkDistance"
distanceText.Font = Enum.Font.Code
distanceText.Position = UDim2.fromOffset(16, 179)
distanceText.Size = UDim2.new(1, -32, 0, 18)
local updateDistance: (() -> ())? = nil
local function commitBookmarkName()
	if not alive then
		return
	end
	-- Bound user text by Unicode codepoints, not bytes; never evaluate or persist it.
	local value = string.gsub(nameInput.Text, "%c", " ")
	value = string.match(value, "^%s*(.-)%s*$") or ""
	local length = utf8.len(value)
	if not length or length == 0 then
		value = "Spot " .. selectedSlot
	elseif length > 24 then
		local boundary = utf8.offset(value, 25)
		if boundary then
			value = string.sub(value, 1, boundary - 1)
		end
	end
	bookmarkNames[selectedSlot] = value
	nameInput.Text = value
end
connect(nameInput.FocusLost, commitBookmarkName)
local function refreshSlots()
	for i, button in ipairs(slotButtons) do
		button.Text = string.format(
			"%02d  %s",
			i,
			if savedPivots[i] then "SAVED" else "EMPTY"
		)
		button.TextColor3 = if i == selectedSlot
			then colors.Panel
			else colors.Muted
		button.BackgroundColor3 = if i == selectedSlot
			then CONFIG.Accent
			else colors.Surface
	end
end
local function refreshCoordinates()
	if savedPivot then
		local position = savedPivot.Position
		coordinates.Text = string.format(
			"X %.1f   Y %.1f   Z %.1f",
			position.X,
			position.Y,
			position.Z
		)
	else
		coordinates.Text = "No position saved"
	end
end
for i = 1, 3 do
	local index = i
	local button = utilityButton(
		"Slot" .. i,
		"",
		UDim2.new((i - 1) / 3, 16 - (i - 1) * 8, 0, 58),
		UDim2.new(1 / 3, -16, 0, 38),
		false
	)
	button.Font = Enum.Font.Code
	button.TextSize = 10
	table.insert(slotButtons, button)
	connect(button.Activated, function()
		commitBookmarkName()
		selectedSlot = index
		nameInput.Text = bookmarkNames[index]
		savedPivot = savedPivots[index]
		refreshSlots()
		refreshCoordinates()
		if updateDistance then
			updateDistance()
		end
		teleportStatus.Text = "Selected " .. bookmarkNames[index] .. "."
		teleportStatus.TextColor3 = colors.Muted
	end)
end
refreshSlots()
local teleporting = false
local lastTeleport = -math.huge
local function characterReady(): Model?
	local character = player.Character
	if not character or not character.Parent then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if
		not humanoid
		or humanoid.Health <= 0
		or not character:FindFirstChild("HumanoidRootPart")
	then
		return nil
	end
	return character
end
updateDistance = function()
	local character = characterReady()
	if not savedPivot then
		distanceText.Text = "Save a spot to measure distance"
	elseif not character then
		distanceText.Text = "Distance available after spawning"
	else
		local current = character:GetPivot().Position
		local saved = savedPivot.Position
		local x, y, z =
			current.X - saved.X, current.Y - saved.Y, current.Z - saved.Z
		distanceText.Text =
			string.format("%.0f studs away", math.sqrt(x * x + y * y + z * z))
	end
end
local function reportPosition(message: string, failed: boolean?)
	teleportStatus.Text = message
	teleportStatus.TextColor3 = if failed then colors.Error else colors.Muted
end
connect(savePosition.Activated, function()
	local character = characterReady()
	if not character then
		reportPosition("Wait for your character to spawn.", true)
		return
	end
	commitBookmarkName()
	savedPivot = character:GetPivot()
	savedPivots[selectedSlot] = savedPivot
	refreshSlots()
	refreshCoordinates()
	if updateDistance then
		updateDistance()
	end
	reportPosition(bookmarkNames[selectedSlot] .. " saved for this session.")
end)
connect(clearPosition.Activated, function()
	savedPivot = nil
	savedPivots[selectedSlot] = nil
	refreshSlots()
	coordinates.Text = "No position saved"
	if updateDistance then
		updateDistance()
	end
	reportPosition("Bookmark cleared.")
end)
connect(goPosition.Activated, function()
	if teleporting or os.clock() - lastTeleport < 0.8 then
		return
	end
	local destination = savedPivot
	if not destination then
		reportPosition("Save a position first.", true)
		return
	end
	local character = characterReady()
	if not character then
		reportPosition("Wait for your character to spawn.", true)
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.SeatPart then
		reportPosition("Leave your seat before teleporting.", true)
		return
	end
	teleporting = true
	lastTeleport = os.clock()
	local ok = pcall(function()
		-- Local character movement, not a server permission or anticheat bypass.
		character:PivotTo(destination)
		local part = character:FindFirstChild("HumanoidRootPart")
			or character.PrimaryPart
			or character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
		if part and part:IsA("BasePart") then
			part.AssemblyLinearVelocity = Vector3.zero
			part.AssemblyAngularVelocity = Vector3.zero
		end
	end)
	teleporting = false
	reportPosition(
		if ok
			then "Returned to saved spot (local movement)."
			else "Could not move your character.",
		not ok
	)
end)

local fpsPanel = create("Frame", {
	Name = "FPSMeter",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(132, appearance.FPSHeight),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
}, root)
corner(fpsPanel, 12)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, fpsPanel)
for i = 1, 3 do
	local bar = create("Frame", {
		Position = UDim2.fromOffset(14 + (i - 1) * 5, 32 - i * 5),
		Size = UDim2.fromOffset(3, i * 5),
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
	}, fpsPanel)
	corner(bar, 1)
end
local fpsScale = create("UIScale", { Scale = 1 }, fpsPanel)
local fpsText = label(fpsPanel, "— FPS", 14, colors.Text)
fpsText.Name = "FPSValue"
fpsText.Font = Enum.Font.Code
fpsText.Position = UDim2.fromOffset(38, 0)
fpsText.Size = UDim2.new(1, -44, 0, 36)
local fpsHistory: { number } = {}
local fpsBars: { Frame } = {}
for i = 1, 12 do
	local bar = create("Frame", {
		Name = "FPSHistory" .. i,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromOffset(14 + (i - 1) * 9, 54),
		Size = UDim2.fromOffset(6, 2),
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		Visible = false,
	}, fpsPanel)
	corner(bar, 2)
	table.insert(fpsBars, bar)
end

local coordinatePanel = create("Frame", {
	Name = "CoordinateHUD",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(appearance.HUDWidth, 48),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
}, root)
corner(coordinatePanel, 12)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, coordinatePanel)
local coordinateScale = create("UIScale", { Scale = 1 }, coordinatePanel)
local coordinateText =
	label(coordinatePanel, "Waiting for character…", 11, colors.Text)
coordinateText.Name = "LiveCoordinates"
coordinateText.Font = Enum.Font.Code
coordinateText.Position = UDim2.fromOffset(12, 0)
coordinateText.Size = UDim2.new(1, -24, 1, 0)
local hudEnabled = false
local updateSession: ((number) -> ())? = nil
local sessionTime, telemetryTime = 0, 0

layoutExtras = function()
	local viewport = root.AbsoluteSize
	local scale = math.min(
		interfaceScale,
		math.max(0.1, (viewport.X - 24) / 320),
		math.max(0.1, (viewport.Y - 24) / 362)
	)
	teleportScale.Scale = scale
	fpsScale.Scale = math.min(
		interfaceScale,
		math.max(0.1, (viewport.X - 24) / 132),
		math.max(0.1, (viewport.Y - 24) / appearance.FPSHeight)
	)
	coordinateScale.Scale = math.min(
		interfaceScale,
		math.max(0.1, (viewport.X - 24) / appearance.HUDWidth),
		math.max(0.1, (viewport.Y - 24) / 48)
	)
	for _, floating in ipairs({ teleportPanel, fpsPanel, coordinatePanel }) do
		local size = if floating == teleportPanel
			then Vector2.new(320, 362) * scale
			elseif floating == fpsPanel then Vector2.new(
				132,
				appearance.FPSHeight
			) * fpsScale.Scale
			else Vector2.new(appearance.HUDWidth, 48) * coordinateScale.Scale
		local preferred = if floating == teleportPanel
			then Vector2.new(
				math.min(viewport.X - 170, viewport.X / 2 + 210),
				viewport.Y / 2
			)
			elseif floating == fpsPanel then Vector2.new(
				viewport.X - 82,
				40
			)
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
local ghosts: { TextLabel } = {}
for _, tint in ipairs({
	Color3.fromRGB(109, 225, 242),
	Color3.fromRGB(245, 120, 189),
}) do
	local ghost = label(header, CONFIG.Name, 19, tint)
	ghost.Name = "GlitchLayer"
	ghost.TextSize = title.TextSize
	ghost.Font = Enum.Font.Code
	ghost.Position = title.Position
	ghost.Size = title.Size
	ghost.TextTransparency = 1
	ghost.ZIndex = title.ZIndex + 1
	table.insert(ghosts, ghost)
end
local function resetTitle()
	title.Text = CONFIG.Name
	for _, ghost in ipairs(ghosts) do
		ghost.TextTransparency = 1
	end
end
setTeleportEnabled = toggleRow(
	"Teleport tools",
	"Three bookmarks · save & return",
	0,
	false,
	function(enabled)
		layout()
		portal.Play(teleportPanel, enabled)
	end
)
local setFPSEnabled = toggleRow(
	"FPS meter",
	"Floating · drag to reposition",
	58,
	false,
	function(enabled)
		fpsEnabled = enabled

		fpsFrames, fpsElapsed = 0, 0
		fpsText.Text = "— FPS"
		table.clear(fpsHistory)
		for _, bar in ipairs(fpsBars) do
			bar.Visible = false
		end
		layout()
		portal.Play(fpsPanel, enabled)
	end
)
local setGlitchEnabled = toggleRow(
	"Glitch title",
	"Subtle RGB split · monospace",
	116,
	glitchEnabled,
	function(enabled)
		glitchEnabled = enabled
		glitchClock, glitchRemaining = 0, 0
		resetTitle()
		if studioBridge.Sync then
			studioBridge.Sync()
		end
	end
)
local setHUDEnabled = toggleRow(
	"Position HUD",
	"Live coordinates · draggable",
	174,
	false,
	function(enabled)
		hudEnabled = enabled
		layout()
		portal.Play(coordinatePanel, enabled)
	end
)
-- One render connection; telemetry is sampled twice a second, not every frame.
connect(RunService.RenderStepped, function(dt: number)
	sessionTime += dt
	telemetryTime += dt
	if telemetryTime >= appearance.TelemetryInterval then
		telemetryTime = 0
		if teleportPanel.Visible and updateDistance then
			updateDistance()
		end
		if hudEnabled then
			local character = characterReady()
			if character then
				local position = character:GetPivot().Position
				coordinateText.Text = string.format(
					appearance.CoordinateFormat,
					position.X,
					position.Y,
					position.Z
				)
			else
				coordinateText.Text = "Waiting for character…"
			end
		end
		if updateSession then
			updateSession(sessionTime)
		end
	end
	if fpsEnabled then
		fpsFrames += 1
		fpsElapsed += dt
		if fpsElapsed >= appearance.FPSInterval then
			local fps = math.floor(fpsFrames / fpsElapsed + 0.5)
			table.insert(fpsHistory, fps)
			if #fpsHistory > 12 then
				table.remove(fpsHistory, 1)
			end
			for i, bar in ipairs(fpsBars) do
				local sample = fpsHistory[i]
				bar.Visible = appearance.FPSGraph and sample ~= nil
				if sample then
					bar.Size = UDim2.fromOffset(
						6,
						math.clamp(sample / 120, 0.1, 1) * 12
					)
					bar.BackgroundColor3 = if sample < 30
						then colors.Error
						else CONFIG.Accent
				end
			end
			fpsText.Text = string.format("%d FPS", fps)
			fpsText.TextColor3 = if fps < 30
				then colors.Error
				elseif fps < 50 then CONFIG.Accent
				else colors.Success
			fpsFrames, fpsElapsed = 0, 0
		end
	end
	if not glitchEnabled or CONFIG.ReducedMotion or not card.Visible then
		if glitchRemaining > 0 then
			resetTitle()
		end
		glitchRemaining = 0
		return
	end
	glitchClock += dt
	if glitchClock >= appearance.GlitchInterval then
		glitchClock = 0
		glitchRemaining = appearance.GlitchDuration
	end
	if glitchRemaining > 0 then
		glitchRemaining = math.max(0, glitchRemaining - dt)
		if glitchRemaining == 0 then
			resetTitle()
			return
		end
		local shift = if math.floor(glitchRemaining * 60) % 2 == 0
			then appearance.GlitchOffset
			else -appearance.GlitchOffset
		for i, ghost in ipairs(ghosts) do
			ghost.TextTransparency = 0.55
			ghost.Position = title.Position
				+ UDim2.fromOffset(if i == 1 then shift else -shift, 0)
		end
		if #CONFIG.Name > 0 then
			local index = math.random(1, #CONFIG.Name)
			title.Text = string.sub(CONFIG.Name, 1, index - 1)
				.. "_"
				.. string.sub(CONFIG.Name, index + 1)
		end
	end
end)
local showDashboard: (() -> ())? = nil
local function showTools()
	dashboardOpen = true
	if studioBridge.ResizeGrip then
		studioBridge.ResizeGrip.Visible = true
	end
	if showDashboard then
		showDashboard()
	end
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
		Name = "Navigation",
		BackgroundColor3 = colors.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(24, 94),
		Size = UDim2.new(1, -48, 0, 44),
		Visible = false,
	}, card)
	corner(tabs, 12)
	local function page(name: string, contentHeight: number)
		return create("ScrollingFrame", {
			Name = name,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = tools.Position,
			Size = tools.Size,
			Visible = false,
			CanvasSize = UDim2.fromOffset(0, contentHeight),
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, card)
	end
	local stylePage = page("StylePage", 650)
	local sessionPage = page("SessionPage", 370)
	local pages = { tools, stylePage, sessionPage }
	local tabButtons: { TextButton } = {}
	local function selectPage(index: number)
		for i, view in ipairs(pages) do
			view.Visible = i == index
			tween(tabButtons[i], {
				BackgroundTransparency = if i == index then 0 else 1,
				TextColor3 = if i == index then colors.Text else colors.Muted,
			})
		end
	end
	for i, name in ipairs({ "Tools", "Style", "Session" }) do
		local index = i
		local button = create("TextButton", {
			Name = "Tab" .. name,
			Text = name,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.new((i - 1) / 3, 4, 0, 4),
			Size = UDim2.new(1 / 3, -8, 1, -8),
			TextColor3 = colors.Muted,
			BackgroundColor3 = Color3.fromRGB(43, 43, 58),
			BorderSizePixel = 0,
			AutoButtonColor = false,
		}, tabs)
		corner(button, 9)
		table.insert(tabButtons, button)
		connect(button.Activated, function()
			selectPage(index)
		end)
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
	local function action(
		parent: Instance,
		name: string,
		text: string,
		position: UDim2,
		size: UDim2,
		callback: () -> ()
	)
		local button = create("TextButton", {
			Name = name,
			Text = text,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			Position = position,
			Size = size,
			BorderSizePixel = 0,
			AutoButtonColor = false,
		}, parent)
		corner(button, 10)
		connect(button.Activated, callback)
		connect(button.MouseEnter, function()
			tween(button, { BackgroundTransparency = 0.2 })
		end)
		connect(button.MouseLeave, function()
			tween(button, { BackgroundTransparency = 0 })
		end)
		return button
	end
	local function applyTheme(accent: Color3, name: string)
		local previousAccent = CONFIG.Accent
		CONFIG.Accent = accent
		-- Recolor only objects using the old accent, never unrelated status colors.
		for _, object in ipairs(gui:GetDescendants()) do
			if object:IsA("GuiObject") then
				if object.BackgroundColor3 == previousAccent then
					object.BackgroundColor3 = accent
				end
				if
					(object:IsA("TextLabel") or object:IsA("TextButton"))
					and string.sub(object.Name, 1, 5) ~= "Theme"
					and object.TextColor3 == previousAccent
				then
					object.TextColor3 = accent
				end
				if
					object:IsA("ScrollingFrame")
					and object.ScrollBarImageColor3 == previousAccent
				then
					object.ScrollBarImageColor3 = accent
				end
			elseif
				object:IsA("UIStroke") and object.Color == previousAccent
			then
				object.Color = accent
			elseif
				object:IsA("UIGradient") and object.Name == "BrandGradient"
			then
				object.Color =
					ColorSequence.new(accent, Color3.fromRGB(112, 113, 221))
			end
		end
		for _, refresh in ipairs(themeRefreshers) do
			refresh()
		end
		refreshSlots()
		status.Text = name .. " accent selected."
		if studioBridge.Sync then
			studioBridge.Sync()
		end
	end
	studioBridge.Accent = applyTheme
	section(stylePage, "01 / ACCENT", 0)
	for i, theme in ipairs({
		{ Name = "Violet", Color = Color3.fromRGB(167, 146, 255) },
		{ Name = "Mint", Color = Color3.fromRGB(126, 222, 185) },
		{ Name = "Ice", Color = Color3.fromRGB(129, 200, 255) },
	}) do
		local choice = theme
		local button = action(
			stylePage,
			"Theme" .. theme.Name,
			theme.Name,
			UDim2.new((i - 1) / 3, 0, 0, 27),
			UDim2.new(1 / 3, -6, 0, 44),
			function()
				applyTheme(choice.Color, choice.Name)
			end
		)
		button.TextColor3 = theme.Color
	end
	studioBridge.Motion = toggleRow(
		"Reduced motion",
		"Disable transitions and title glitch",
		86,
		CONFIG.ReducedMotion,
		function(enabled)
			CONFIG.ReducedMotion = enabled
			if playerToolsBridge.ReducedMotion then
				playerToolsBridge.ReducedMotion(enabled)
			end
			if enabled then
				setGlitchEnabled(false)
				resetTitle()
			end
			if studioBridge.Sync then
				studioBridge.Sync()
			end
		end,
		stylePage
	)
	studioBridge.Lock = toggleRow(
		"Lock windows",
		"Dock stays movable for easy recovery",
		144,
		false,
		function(enabled)
			windowsPinned = enabled
			if enabled then
				drag = nil
			end
			if studioBridge.Sync then
				studioBridge.Sync()
			end
		end,
		stylePage
	)
	studioBridge.Snap = toggleRow(
		"Snap dock",
		"Snap to nearest side after dragging",
		202,
		false,
		function(enabled)
			snapDockToEdge = enabled
			if enabled then
				snapDock(true)
			end
			if studioBridge.Sync then
				studioBridge.Sync()
			end
		end,
		stylePage
	)
	section(stylePage, "02 / INTERFACE SIZE", 269)
	for i, size in ipairs({
		{ "Small", 0.85 },
		{ "Default", 1 },
		{ "Large", 1.1 },
	}) do
		local factor = size[2] :: number
		action(
			stylePage,
			"Scale" .. size[1],
			size[1] :: string,
			UDim2.new((i - 1) / 3, 0, 0, 297),
			UDim2.new(1 / 3, -6, 0, 44),
			function()
				interfaceScale = factor
				layout()
				status.Text = "Interface size updated."
				if studioBridge.Sync then
					studioBridge.Sync()
				end
			end
		)
	end
	local motionHint = label(
		stylePage,
		"Preferences last for this run. No files are written.",
		10,
		colors.Muted
	)
	motionHint.Position = UDim2.fromOffset(0, 352)
	motionHint.Size = UDim2.new(1, -4, 0, 28)
	motionHint.TextWrapped = true

	action(
		stylePage,
		"OpenDesignStudio",
		"Open Design Studio  →",
		UDim2.fromOffset(0, 401),
		UDim2.new(1, -4, 0, 48),
		function()
			if studioBridge.Open then
				studioBridge.Open()
			end
		end
	)
	section(stylePage, "03 / DISPLAY TYPE", 464)
	for index, name in ipairs({ "Gotham", "Pixel", "Medieval" }) do
		local fontName = name
		action(
			stylePage,
			"QuickFont_" .. name,
			if name == "Gotham" then "Modern" else name,
			UDim2.new((index - 1) / 3, 0, 0, 492),
			UDim2.new(1 / 3, -6, 0, 44),
			function()
				if studioBridge.Font then
					studioBridge.Font(fontName)
				end
			end
		)
	end

	section(stylePage, "04 / SIGNATURE LOOKS", 554)
	for index, name in ipairs({ "Pixel", "Citadel" }) do
		local look = name
		action(
			stylePage,
			"QuickLook_" .. look,
			if look == "Pixel" then "Aurora / Pixel" else "Citadel / Gothic",
			UDim2.new((index - 1) / 2, 0, 0, 582),
			UDim2.new(0.5, -6, 0, 48),
			function()
				if studioBridge.Look then
					studioBridge.Look(look)
				end
			end
		)
	end

	section(sessionPage, "LOCAL SESSION", 0)
	local identity =
		label(sessionPage, "@" .. (player.Name or "Player"), 16, colors.Text)
	identity.Font = Enum.Font.GothamBold
	identity.Position = UDim2.fromOffset(0, 28)
	identity.Size = UDim2.new(1, 0, 0, 26)
	local sessionStats =
		label(sessionPage, "00:00  /  0 of 3 bookmarks", 12, CONFIG.Accent)
	sessionStats.Name = "SessionStats"
	sessionStats.Font = Enum.Font.Code
	sessionStats.Position = UDim2.fromOffset(0, 64)
	sessionStats.Size = UDim2.new(1, 0, 0, 26)
	updateSession = function(elapsed: number)
		if not sessionPage.Visible then
			return
		end
		local count = 0
		for _ in pairs(savedPivots) do
			count += 1
		end
		local seconds = math.floor(elapsed)
		sessionStats.Text = string.format(
			"%02d:%02d  /  %d of 3 bookmarks",
			math.floor(seconds / 60),
			seconds % 60,
			count
		)
	end
	action(
		sessionPage,
		"ResetLayout",
		"Recenter all windows",
		UDim2.fromOffset(0, 108),
		UDim2.new(1, -4, 0, 46),
		function()
			panelCenter = nil
			miniCenter = nil
			table.clear(extraCenters)
			drag = nil
			layout()
			status.Text = "Window positions reset."
		end
	)
	action(
		sessionPage,
		"HideUtilities",
		"Hide floating utilities",
		UDim2.fromOffset(0, 164),
		UDim2.new(1, -4, 0, 46),
		function()
			if setTeleportEnabled then
				setTeleportEnabled(false)
			end
			setFPSEnabled(false)
			setHUDEnabled(false)
			if playerToolsBridge.HideWindows then
				playerToolsBridge.HideWindows()
			end
			status.Text = "Floating utilities hidden; player tools off."
		end
	)
	local clearDeadline = 0
	local clearAll: TextButton? = nil
	clearAll = action(
		sessionPage,
		"ClearBookmarks",
		"Clear all bookmarks",
		UDim2.fromOffset(0, 220),
		UDim2.new(1, -4, 0, 46),
		function()
			local button = clearAll
			if not button then
				return
			end
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
			if updateDistance then
				updateDistance()
			end
			button.Text = "Clear all bookmarks"
			status.Text = "All bookmarks cleared."
		end
	)
	local hint = label(
		sessionPage,
		"RIGHT SHIFT toggles the dashboard.\nDrag the dock to move it; tap to show or hide.\nTeleports are local and can be reset by the server.",
		11,
		colors.Muted
	)
	hint.Position = UDim2.fromOffset(0, 282)
	hint.Size = UDim2.new(1, -4, 0, 74)
	hint.TextWrapped = true
	connect(
		UserInputService.InputBegan,
		function(input: InputObject, processed: boolean)
			if processed or UserInputService:GetFocusedTextBox() then
				return
			end
			if
				input.KeyCode == appearance.ToggleKey
				and not playerToolsBridge.PrimaryActive
			then
				setExpanded(not expanded)
			end
		end
	)
end

-- The resize grip uses the same safe-area layout as orientation changes.
do
	local resizeInput: InputObject? = nil
	local origin = Vector2.new(0, 0)
	local startSize = Vector2.new(440, 520)
	local grip = create("TextButton", {
		Name = "ResizeDashboard",
		Text = "↘",
		TextSize = 19,
		Font = Enum.Font.Code,
		TextColor3 = colors.Muted,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -44, 1, -44),
		Size = UDim2.fromOffset(44, 44),
		Visible = false,
	}, card)
	studioBridge.ResizeGrip = grip
	connect(grip.InputBegan, function(input: InputObject)
		if windowsPinned or transitioning then
			return
		end
		if
			input.UserInputType ~= Enum.UserInputType.Touch
			and input.UserInputType ~= Enum.UserInputType.MouseButton1
		then
			return
		end
		resizeInput = input
		origin = Vector2.new(input.Position.X, input.Position.Y)
		startSize = Vector2.new(appearance.Width, appearance.Height)
		drag = nil
	end)
	connect(UserInputService.InputChanged, function(input: InputObject)
		if not resizeInput or windowsPinned then
			return
		end
		local matchesMouse = resizeInput.UserInputType
				== Enum.UserInputType.MouseButton1
			and input.UserInputType == Enum.UserInputType.MouseMovement
		if input ~= resizeInput and not matchesMouse then
			return
		end
		local delta = (Vector2.new(input.Position.X, input.Position.Y) - origin)
			/ responsiveScale.Scale
		appearance.Width = math.clamp(startSize.X + delta.X, 280, 720)
		appearance.Height = math.clamp(startSize.Y + delta.Y, 320, 720)
		layout()
	end)
	connect(UserInputService.InputEnded, function(input: InputObject)
		if input ~= resizeInput then
			return
		end
		resizeInput = nil
		if studioBridge.Resized then
			studioBridge.Resized(appearance.Width, appearance.Height)
		end
	end)
	connect(UserInputService.WindowFocusReleased, function()
		resizeInput = nil
	end)
end

-- Lazy, self-contained Design Studio. No assets, files, or network calls.
do
	local studio: { [string]: any } = {}
	studio.SchemaVersion = 1
	studio.HistoryLimit = 24
	studio.InputLimit = 8192
	studio.Themes = {
		{
			Name = "Violet",
			Description = "The original Nullx11 signature.",
			RGB = {
				167,
				146,
				255,
			},
		},
		{
			Name = "Mint",
			Description = "A calm green accent for dark surfaces.",
			RGB = {
				126,
				222,
				185,
			},
		},
		{
			Name = "Ice",
			Description = "Crisp blue with a cool technical feel.",
			RGB = {
				129,
				200,
				255,
			},
		},
		{
			Name = "Rose",
			Description = "Soft pink for a warmer workspace.",
			RGB = {
				247,
				153,
				189,
			},
		},
		{
			Name = "Amber",
			Description = "A warm, readable golden highlight.",
			RGB = {
				246,
				194,
				107,
			},
		},
		{
			Name = "Coral",
			Description = "An energetic peach-red accent.",
			RGB = {
				246,
				153,
				130,
			},
		},
		{
			Name = "Lavender",
			Description = "A lighter, understated purple.",
			RGB = {
				197,
				173,
				246,
			},
		},
		{
			Name = "Cyan",
			Description = "Bright aqua for a clean instrument panel.",
			RGB = {
				108,
				221,
				225,
			},
		},
		{
			Name = "Lime",
			Description = "A soft botanical green, not neon.",
			RGB = {
				186,
				219,
				128,
			},
		},
		{
			Name = "Pearl",
			Description = "A near-neutral monochrome accent.",
			RGB = {
				218,
				220,
				234,
			},
		},
		{
			Name = "Orchid",
			Description = "Pink-purple for a more expressive look.",
			RGB = {
				222,
				155,
				237,
			},
		},
		{
			Name = "Sky",
			Description = "A soft blue-violet alternative.",
			RGB = {
				160,
				183,
				249,
			},
		},
	}
	studio.Schema = {
		{
			Key = "Theme",
			Page = "Color",
			Kind = "choice",
			Title = "Accent library",
			Hint = "Select a preset; custom RGB takes priority when enabled.",
			Default = "Violet",
			Options = {
				"Violet",
				"Mint",
				"Ice",
				"Rose",
				"Amber",
				"Coral",
				"Lavender",
				"Cyan",
				"Lime",
				"Pearl",
				"Orchid",
				"Sky",
			},
		},
		{
			Key = "CustomAccent",
			Page = "Color",
			Kind = "toggle",
			Title = "Use custom RGB",
			Hint = "Use the three channel controls below instead of a preset.",
			Default = false,
		},
		{
			Key = "Red",
			Page = "Color",
			Kind = "number",
			Title = "Red channel",
			Hint = "Each channel is clamped to the standard 0–255 RGB range.",
			Default = 167,
			Minimum = 0,
			Maximum = 255,
			Step = 5,
			Unit = "",
		},
		{
			Key = "Green",
			Page = "Color",
			Kind = "number",
			Title = "Green channel",
			Hint = "Each channel is clamped to the standard 0–255 RGB range.",
			Default = 146,
			Minimum = 0,
			Maximum = 255,
			Step = 5,
			Unit = "",
		},
		{
			Key = "Blue",
			Page = "Color",
			Kind = "number",
			Title = "Blue channel",
			Hint = "Each channel is clamped to the standard 0–255 RGB range.",
			Default = 255,
			Minimum = 0,
			Maximum = 255,
			Step = 5,
			Unit = "",
		},
		{
			Key = "PanelOpacity",
			Page = "Color",
			Kind = "number",
			Title = "Window opacity",
			Hint = "Backgrounds only; text and controls stay readable.",
			Default = 100,
			Minimum = 65,
			Maximum = 100,
			Step = 5,
			Unit = "%",
		},
		{
			Key = "DockOpacity",
			Page = "Color",
			Kind = "number",
			Title = "Dock opacity",
			Hint = "Tune the floating launcher independently of other windows.",
			Default = 100,
			Minimum = 60,
			Maximum = 100,
			Step = 5,
			Unit = "%",
		},
		{
			Key = "CornerScale",
			Page = "Color",
			Kind = "number",
			Title = "Corner roundness",
			Hint = "Scale existing corners without changing layout dimensions.",
			Default = 1,
			Minimum = 0,
			Maximum = 1.5,
			Step = 0.1,
			Unit = "×",
		},
		{
			Key = "BorderWeight",
			Page = "Color",
			Kind = "number",
			Title = "Border weight",
			Hint = "Zero hides outlines; other values scale their baseline thickness.",
			Default = 1,
			Minimum = 0,
			Maximum = 2.5,
			Step = 0.25,
			Unit = "×",
		},
		{
			Key = "Gradients",
			Page = "Color",
			Kind = "toggle",
			Title = "Surface gradients",
			Hint = "Switch decorative UI gradients on or off.",
			Default = true,
		},
		{
			Key = "HighContrast",
			Page = "Type",
			Kind = "toggle",
			Title = "Brighter secondary text",
			Hint = "Increase muted-text contrast against the dark background.",
			Default = false,
		},
		{
			Key = "Font",
			Page = "Type",
			Kind = "choice",
			Title = "Body typeface",
			Hint = "Choose a built-in Roblox font; no external assets are fetched.",
			Default = "Gotham",
			Options = {
				"Gotham",
				"SourceSans",
				"Arial",
				"Code",
				"Pixel",
				"Medieval",
			},
		},
		{
			Key = "TextScale",
			Page = "Type",
			Kind = "number",
			Title = "Text size",
			Hint = "Scale baseline text sizes with sensible readability limits.",
			Default = 1,
			Minimum = 0.9,
			Maximum = 1.25,
			Step = 0.05,
			Unit = "×",
		},
		{
			Key = "PreserveMono",
			Page = "Type",
			Kind = "toggle",
			Title = "Keep technical text monospace",
			Hint = "Preserve Code-font titles, coordinates, and FPS labels.",
			Default = true,
		},
		{
			Key = "HeaderTag",
			Page = "Type",
			Kind = "toggle",
			Title = "Header edition label",
			Hint = "Show the small CLIENT / WORKSPACE label beneath the title.",
			Default = true,
		},
		{
			Key = "Footer",
			Page = "Type",
			Kind = "toggle",
			Title = "Workspace footer",
			Hint = "Show the small identity label at the bottom of the dashboard.",
			Default = true,
		},
		{
			Key = "Status",
			Page = "Type",
			Kind = "toggle",
			Title = "Loading and status strip",
			Hint = "Show status messages and the progress line on the dashboard.",
			Default = true,
		},
		{
			Key = "Hints",
			Page = "Type",
			Kind = "toggle",
			Title = "Setting descriptions",
			Hint = "Show explanatory text beneath Design Studio setting titles.",
			Default = true,
		},
		{
			Key = "FocusOutlines",
			Page = "Type",
			Kind = "toggle",
			Title = "Keyboard focus outline",
			Hint = "Highlight selected Studio buttons for keyboard and gamepad navigation.",
			Default = true,
		},
		{
			Key = "LargeTargets",
			Page = "Type",
			Kind = "toggle",
			Title = "Larger Studio controls",
			Hint = "Increase Studio button height from 44 to 52 pixels.",
			Default = false,
		},
		{
			Key = "Scale",
			Page = "Layout",
			Kind = "number",
			Title = "Interface scale",
			Hint = "Safe-area clamping still limits the effective on-screen size.",
			Default = 1,
			Minimum = 0.75,
			Maximum = 1.2,
			Step = 0.05,
			Unit = "×",
		},
		{
			Key = "Width",
			Page = "Layout",
			Kind = "number",
			Title = "Preferred dashboard width",
			Hint = "The resize grip changes the same setting. Small screens still clamp it.",
			Default = 440,
			Minimum = 280,
			Maximum = 720,
			Step = 20,
			Unit = " px",
		},
		{
			Key = "Height",
			Page = "Layout",
			Kind = "number",
			Title = "Preferred dashboard height",
			Hint = "Scrollable pages remain usable when the viewport is shorter.",
			Default = 520,
			Minimum = 320,
			Maximum = 720,
			Step = 20,
			Unit = " px",
		},
		{
			Key = "DockSize",
			Page = "Layout",
			Kind = "number",
			Title = "Floating dock size",
			Hint = "Keep the launcher at least 48 pixels wide for touch.",
			Default = 60,
			Minimum = 48,
			Maximum = 80,
			Step = 4,
			Unit = " px",
		},
		{
			Key = "DockShape",
			Page = "Layout",
			Kind = "choice",
			Title = "Dock silhouette",
			Hint = "Change only the launcher corner shape.",
			Default = "Squircle",
			Options = {
				"Square",
				"Squircle",
				"Round",
			},
		},
		{
			Key = "IconStyle",
			Page = "Layout",
			Kind = "choice",
			Title = "Monogram treatment",
			Hint = "Cut includes the signature slash; Split emphasizes twin pillars.",
			Default = "Cut",
			Options = {
				"Cut",
				"Plain",
				"Split",
			},
		},
		{
			Key = "DockCaption",
			Page = "Layout",
			Kind = "toggle",
			Title = "Dock micro-label",
			Hint = "Show the small 11 / caption below the icon.",
			Default = true,
		},
		{
			Key = "DockDot",
			Page = "Layout",
			Kind = "toggle",
			Title = "Dock status dot",
			Hint = "Keep the small dashboard-open indicator visible.",
			Default = true,
		},
		{
			Key = "Snap",
			Page = "Layout",
			Kind = "toggle",
			Title = "Snap dock to a side",
			Hint = "Snap to the nearest left/right safe-area edge after a drag.",
			Default = false,
		},
		{
			Key = "Locked",
			Page = "Layout",
			Kind = "toggle",
			Title = "Lock window dragging",
			Hint = "Lock panels and the resize grip; the recovery dock stays movable.",
			Default = false,
		},
		{
			Key = "Hotkey",
			Page = "Layout",
			Kind = "choice",
			Title = "Dashboard shortcut",
			Hint = "Ignored while typing or after Roblox processes the key.",
			Default = "RightShift",
			Options = {
				"RightShift",
				"LeftAlt",
				"F4",
				"Home",
			},
		},
		{
			Key = "HUDWidth",
			Page = "Layout",
			Kind = "number",
			Title = "Coordinate HUD width",
			Hint = "Give long coordinates more horizontal space.",
			Default = 224,
			Minimum = 200,
			Maximum = 360,
			Step = 16,
			Unit = " px",
		},
		{
			Key = "CoordinatePrecision",
			Page = "Layout",
			Kind = "number",
			Title = "Coordinate decimals",
			Hint = "Choose how many decimal places the live HUD displays.",
			Default = 1,
			Minimum = 0,
			Maximum = 2,
			Step = 1,
			Unit = "",
		},
		{
			Key = "StudioWidth",
			Page = "Layout",
			Kind = "number",
			Title = "Design Studio width",
			Hint = "A preference, not a forced size; it always fits the safe area.",
			Default = 620,
			Minimum = 320,
			Maximum = 900,
			Step = 40,
			Unit = " px",
		},
		{
			Key = "StudioHeight",
			Page = "Layout",
			Kind = "number",
			Title = "Design Studio height",
			Hint = "The setting pages scroll independently of the window.",
			Default = 600,
			Minimum = 320,
			Maximum = 800,
			Step = 40,
			Unit = " px",
		},
		{
			Key = "RestorePage",
			Page = "Layout",
			Kind = "toggle",
			Title = "Remember Studio category",
			Hint = "Reopen the last category during this run.",
			Default = true,
		},
		{
			Key = "ReducedMotion",
			Page = "Motion",
			Kind = "toggle",
			Title = "Reduced motion",
			Hint = "Disable tween duration and turn off the glitch title.",
			Default = false,
		},
		{
			Key = "Glitch",
			Page = "Motion",
			Kind = "toggle",
			Title = "Glitch title",
			Hint = "Short RGB-split bursts; requires reduced motion to be off.",
			Default = true,
		},
		{
			Key = "MotionSpeed",
			Page = "Motion",
			Kind = "number",
			Title = "Transition duration",
			Hint = "A multiplier, not an artificial loading delay.",
			Default = 1,
			Minimum = 0.5,
			Maximum = 1.75,
			Step = 0.25,
			Unit = "×",
		},
		{
			Key = "Easing",
			Page = "Motion",
			Kind = "choice",
			Title = "Transition easing",
			Hint = "All transitions keep the same outward easing direction.",
			Default = "Quint",
			Options = {
				"Quint",
				"Quad",
				"Cubic",
				"Sine",
				"Linear",
			},
		},
		{
			Key = "GlitchInterval",
			Page = "Motion",
			Kind = "number",
			Title = "Time between glitches",
			Hint = "Longer intervals keep the title quieter.",
			Default = 3.6,
			Minimum = 2,
			Maximum = 10,
			Step = 0.4,
			Unit = " s",
		},
		{
			Key = "GlitchDuration",
			Page = "Motion",
			Kind = "number",
			Title = "Glitch burst length",
			Hint = "Bounded short bursts rather than a constant animation.",
			Default = 0.14,
			Minimum = 0.06,
			Maximum = 0.22,
			Step = 0.02,
			Unit = " s",
		},
		{
			Key = "GlitchOffset",
			Page = "Motion",
			Kind = "number",
			Title = "RGB split distance",
			Hint = "Horizontal displacement of the two colored text layers.",
			Default = 2,
			Minimum = 1,
			Maximum = 4,
			Step = 1,
			Unit = " px",
		},
		{
			Key = "FPSGraph",
			Page = "Motion",
			Kind = "toggle",
			Title = "FPS history bars",
			Hint = "Keep the FPS number while optionally hiding its graph.",
			Default = true,
		},
		{
			Key = "FPSInterval",
			Page = "Motion",
			Kind = "number",
			Title = "FPS sample window",
			Hint = "A smaller interval refreshes faster but gives a noisier reading.",
			Default = 0.5,
			Minimum = 0.25,
			Maximum = 1,
			Step = 0.25,
			Unit = " s",
		},
		{
			Key = "TelemetryInterval",
			Page = "Motion",
			Kind = "number",
			Title = "Coordinate sample window",
			Hint = "Controls live-coordinate, distance, and session-label refreshes.",
			Default = 0.5,
			Minimum = 0.25,
			Maximum = 1,
			Step = 0.25,
			Unit = " s",
		},
	}
	studio.Presets = {
		{
			Name = "Signature",
			Description = "Original violet with balanced dimensions.",
			Values = {
				Theme = "Violet",
				CustomAccent = false,
				Font = "Gotham",
				TextScale = 1,
				Scale = 1,
				CornerScale = 1,
				Gradients = true,
				ReducedMotion = false,
				Glitch = true,
			},
		},
		{
			Name = "Quiet",
			Description = "Less motion and less decoration.",
			Values = {
				Theme = "Pearl",
				CustomAccent = false,
				Gradients = false,
				ReducedMotion = true,
				Glitch = false,
				DockCaption = false,
				HeaderTag = false,
				BorderWeight = 0.75,
			},
		},
		{
			Name = "Touch",
			Description = "Larger touch controls and readable text.",
			Values = {
				Theme = "Mint",
				CustomAccent = false,
				LargeTargets = true,
				TextScale = 1.1,
				DockSize = 72,
				StudioWidth = 480,
				Width = 400,
				Snap = true,
			},
		},
		{
			Name = "Terminal",
			Description = "Monospace text with sharp, restrained surfaces.",
			Values = {
				Theme = "Lime",
				CustomAccent = false,
				Font = "Code",
				CornerScale = 0.2,
				Gradients = false,
				Glitch = false,
				BorderWeight = 0.75,
			},
		},
		{
			Name = "Contrast",
			Description = "Brighter labels, clear outlines, and no motion.",
			Values = {
				Theme = "Ice",
				CustomAccent = false,
				HighContrast = true,
				TextScale = 1.1,
				BorderWeight = 1.5,
				ReducedMotion = true,
				Glitch = false,
				LargeTargets = true,
			},
		},
		{
			Name = "Compact",
			Description = "A smaller workspace that leaves room for the game.",
			Values = {
				Theme = "Sky",
				CustomAccent = false,
				Scale = 0.85,
				Width = 360,
				Height = 440,
				DockSize = 48,
				HeaderTag = false,
				Footer = false,
			},
		},
		{
			Name = "Soft",
			Description = "Rounded surfaces with gentle transitions.",
			Values = {
				Theme = "Rose",
				CustomAccent = false,
				CornerScale = 1.4,
				BorderWeight = 0.5,
				Easing = "Sine",
				MotionSpeed = 1.25,
				Glitch = false,
			},
		},
		{
			Name = "Instrument",
			Description = "Frequent instrument refreshes and a wider HUD.",
			Values = {
				Theme = "Cyan",
				CustomAccent = false,
				FPSGraph = true,
				FPSInterval = 0.25,
				TelemetryInterval = 0.25,
				HUDWidth = 280,
				CoordinatePrecision = 2,
				Glitch = false,
			},
		},
		{
			Name = "Pixel",
			Description = "Aurora cyan, crisp pixel headings, readable modern body.",
			Values = {
				Theme = "Cyan",
				CustomAccent = false,
				Font = "Pixel",
				HighContrast = true,
				CornerScale = 0.6,
				BorderWeight = 1.25,
				TextScale = 1.1,
				Gradients = true,
			},
		},
		{
			Name = "Citadel",
			Description = "Amber-lit gothic headings over obsidian surfaces.",
			Values = {
				Theme = "Amber",
				CustomAccent = false,
				Font = "Medieval",
				HighContrast = true,
				CornerScale = 0.7,
				BorderWeight = 1.25,
				TextScale = 1.1,
				Gradients = true,
			},
		},
	}

	studio.ByKey = {}
	studio.Defaults = {}
	studio.Settings = {}
	studio.UndoStack = {}
	studio.RedoStack = {}
	studio.Saved = {}
	studio.Rows = {}
	studio.Pages = {}
	studio.Refreshers = {}
	studio.StyleCache = {}
	studio.FocusStrokes = {}
	studio.Built = false
	studio.ActivePage = "Color"
	studio.Query = ""
	studio.Applying = false
	studio.Fonts = {
		Gotham = Enum.Font.Gotham,
		SourceSans = Enum.Font.SourceSans,
		Arial = Enum.Font.Arial,
		Code = Enum.Font.Code,
		Pixel = Enum.Font.Arcade,
		Medieval = Enum.Font.GrenzeGotisch,
	}
	studio.Easings = {
		Quint = Enum.EasingStyle.Quint,
		Quad = Enum.EasingStyle.Quad,
		Cubic = Enum.EasingStyle.Cubic,
		Sine = Enum.EasingStyle.Sine,
		Linear = Enum.EasingStyle.Linear,
	}
	studio.Keys = {
		RightShift = Enum.KeyCode.RightShift,
		LeftAlt = Enum.KeyCode.LeftAlt,
		F4 = Enum.KeyCode.F4,
		Home = Enum.KeyCode.Home,
	}
	for _, field in ipairs(studio.Schema) do
		studio.ByKey[field.Key] = field
		studio.Defaults[field.Key] = field.Default
		studio.Settings[field.Key] = field.Default
	end

	function studio.Copy(values: { [string]: any }): { [string]: any }
		local result = {}
		for key, value in pairs(values) do
			result[key] = value
		end
		return result
	end

	function studio.Same(
		left: { [string]: any },
		right: { [string]: any }
	): boolean
		for _, field in ipairs(studio.Schema) do
			if left[field.Key] ~= right[field.Key] then
				return false
			end
		end
		return true
	end

	function studio.Theme(name: string): any
		for _, theme in ipairs(studio.Themes) do
			if theme.Name == name then
				return theme
			end
		end
		return studio.Themes[1]
	end

	function studio.Accent(values: { [string]: any }): Color3
		if values.CustomAccent then
			return Color3.fromRGB(values.Red, values.Green, values.Blue)
		end
		local theme = studio.Theme(values.Theme)
		return Color3.fromRGB(theme.RGB[1], theme.RGB[2], theme.RGB[3])
	end

	function studio.SameColor(left: Color3, right: Color3): boolean
		local tolerance = 1 / 510
		return math.abs(left.R - right.R) < tolerance
			and math.abs(left.G - right.G) < tolerance
			and math.abs(left.B - right.B) < tolerance
	end

	function studio.Message(text: string, failed: boolean?)
		if not alive then
			return
		end
		if studio.MessageLabel then
			studio.MessageLabel.Text = text
			studio.MessageLabel.TextColor3 = if failed
				then colors.Error
				else colors.Muted
		end
	end

	function studio.Validate(patch: any): (boolean, any)
		if type(patch) ~= "table" then
			return false, "Settings must be an object."
		end
		local clean = {}
		local count = 0
		for key, value in pairs(patch) do
			if type(key) ~= "string" then
				return false, "Setting names must be strings."
			end
			local field = studio.ByKey[key]
			if not field then
				return false, "Unknown setting: " .. key
			end
			if field.Kind == "toggle" then
				if type(value) ~= "boolean" then
					return false, field.Title .. " must be true or false."
				end
			elseif field.Kind == "number" then
				if
					type(value) ~= "number"
					or value ~= value
					or math.abs(value) == math.huge
				then
					return false, field.Title .. " needs a finite number."
				end
				if value < field.Minimum or value > field.Maximum then
					return false,
						string.format(
							"%s must be between %s and %s.",
							field.Title,
							field.Minimum,
							field.Maximum
						)
				end
				-- Pixel counts, channels, and precision must remain integral.
				if field.Step >= 1 and value % 1 ~= 0 then
					return false, field.Title .. " needs a whole number."
				end
			elseif field.Kind == "choice" then
				local recognized = false
				for _, option in ipairs(field.Options) do
					if value == option then
						recognized = true
						break
					end
				end
				if not recognized then
					return false, "Unsupported " .. field.Title .. " value."
				end
			end
			clean[key] = value
			count += 1
		end
		if count == 0 then
			return false, "There are no settings to apply."
		end
		return true, clean
	end

	function studio.CaptureStyles()
		for _, object in ipairs(gui:GetDescendants()) do
			if studio.StyleCache[object] then
				continue
			end
			local baseline = {}
			if
				object:IsA("TextLabel")
				or object:IsA("TextButton")
				or object:IsA("TextBox")
			then
				baseline.TextSize = object.TextSize
				baseline.Font = object.Font
			elseif object:IsA("UICorner") then
				baseline.Radius = object.CornerRadius.Offset
			elseif object:IsA("UIStroke") then
				baseline.Thickness = object.Thickness
			elseif object:IsA("UIGradient") then
				baseline.Enabled = object.Enabled
			else
				continue
			end
			studio.StyleCache[object] = baseline
		end
	end

	function studio.ReadRuntime()
		local values = studio.Settings
		values.Scale = interfaceScale
		values.Width = math.floor(appearance.Width + 0.5)
		values.Height = math.floor(appearance.Height + 0.5)
		values.Locked = windowsPinned
		values.Snap = snapDockToEdge
		values.ReducedMotion = CONFIG.ReducedMotion
		values.Glitch = glitchEnabled and not CONFIG.ReducedMotion
		if not studio.SameColor(studio.Accent(values), CONFIG.Accent) then
			values.Red = math.floor(CONFIG.Accent.R * 255 + 0.5)
			values.Green = math.floor(CONFIG.Accent.G * 255 + 0.5)
			values.Blue = math.floor(CONFIG.Accent.B * 255 + 0.5)
			values.CustomAccent = true
			for _, theme in ipairs(studio.Themes) do
				local color =
					Color3.fromRGB(theme.RGB[1], theme.RGB[2], theme.RGB[3])
				if studio.SameColor(color, CONFIG.Accent) then
					values.Theme = theme.Name
					values.CustomAccent = false
					break
				end
			end
		end
	end

	function studio.RecolorMuted(brighter: boolean)
		local old = colors.Muted
		local target = if brighter
			then Color3.fromRGB(195, 197, 214)
			else Color3.fromRGB(178, 190, 211)
		if studio.SameColor(old, target) then
			return
		end
		colors.Muted = target
		for _, object in ipairs(gui:GetDescendants()) do
			if
				object:IsA("TextLabel")
				or object:IsA("TextButton")
				or object:IsA("TextBox")
			then
				if object.TextColor3 == old then
					object.TextColor3 = target
				end
				if
					object:IsA("TextBox")
					and object.PlaceholderColor3 == old
				then
					object.PlaceholderColor3 = target
				end
			end
		end
	end

	function studio.Render(values: { [string]: any })
		if not alive then
			return
		end
		local accent = studio.Accent(values)
		if
			not studio.SameColor(accent, CONFIG.Accent) and studioBridge.Accent
		then
			studioBridge.Accent(
				accent,
				if values.CustomAccent then "Custom RGB" else values.Theme
			)
		end
		studio.RecolorMuted(values.HighContrast)
		for object, baseline in pairs(studio.StyleCache) do
			if object.Parent == nil then
				continue
			end
			if baseline.TextSize then
				object.TextSize =
					math.clamp(baseline.TextSize * values.TextScale, 14, 40)
				if values.Font == "Pixel" or values.Font == "Medieval" then
					object.Font = if baseline.TextSize >= 18
						then studio.Fonts[values.Font]
						else Enum.Font.Gotham
				elseif
					values.PreserveMono and baseline.Font == Enum.Font.Code
				then
					object.Font = Enum.Font.Code
				elseif
					values.Font == "Gotham"
					and baseline.Font ~= Enum.Font.Code
				then
					object.Font = baseline.Font
				else
					object.Font = studio.Fonts[values.Font]
				end
			elseif baseline.Radius then
				object.CornerRadius = UDim.new(
					0,
					math.clamp(baseline.Radius * values.CornerScale, 0, 36)
				)
			elseif baseline.Thickness then
				if object.Name == "StudioFocus" then
					object.Thickness = baseline.Thickness
					if not values.FocusOutlines then
						object.Transparency = 1
					end
				else
					object.Thickness = baseline.Thickness * values.BorderWeight
				end
			elseif baseline.Enabled ~= nil then
				object.Enabled = values.Gradients and baseline.Enabled
			end
		end
		for _, window in ipairs({
			card,
			teleportPanel,
			fpsPanel,
			coordinatePanel,
			studio.Window,
		}) do
			window.BackgroundTransparency = 1 - values.PanelOpacity / 100
		end
		appearance.DockOpacity = values.DockOpacity
		if playerToolsBridge.Style then
			playerToolsBridge.Style(values)
		end
		mini.BackgroundTransparency = 1 - values.DockOpacity / 100
		mini.Size = UDim2.fromOffset(values.DockSize, values.DockSize)
		local dockCorner = mini:FindFirstChildOfClass("UICorner")
		if dockCorner then
			local radius = if values.DockShape == "Round"
				then values.DockSize / 2
				elseif values.DockShape == "Square" then 7
				else values.DockSize * 0.32
			dockCorner.CornerRadius = UDim.new(0, radius)
		end
		for _, icon in ipairs(gui:GetDescendants()) do
			if icon:IsA("Frame") and icon.Name == "Nullx11Icon" then
				if icon.Parent == mini then
					icon.Position = UDim2.fromOffset(
						(values.DockSize - 30) / 2,
						(values.DockSize - 30) / 2 - 3
					)
				end
				for _, stroke in ipairs(icon:GetChildren()) do
					if
						stroke:IsA("GuiObject")
						and stroke.Name == "SignatureCut"
					then
						stroke.Visible = values.IconStyle == "Cut"
					elseif
						stroke:IsA("GuiObject")
						and stroke.Name == "BrandStroke2"
					then
						stroke.Visible = values.IconStyle ~= "Split"
					end
				end
			end
		end
		dockCaption.Position = UDim2.new(0, 0, 1, -17)
		dockCaption.Visible = values.DockCaption
		dockDot.Visible = values.DockDot
		edition.Visible = values.HeaderTag
		footer.Visible = values.Footer
		status.Visible = values.Status
		progressTrack.Visible = values.Status
		interfaceScale = values.Scale
		appearance.Width = values.Width
		appearance.Height = values.Height
		appearance.Duration = values.MotionSpeed
		appearance.Easing = studio.Easings[values.Easing]
		appearance.ToggleKey = studio.Keys[values.Hotkey]
		appearance.GlitchInterval = values.GlitchInterval
		appearance.GlitchDuration = values.GlitchDuration
		appearance.GlitchOffset = values.GlitchOffset
		appearance.FPSInterval = values.FPSInterval
		appearance.TelemetryInterval = values.TelemetryInterval
		appearance.FPSGraph = values.FPSGraph
		appearance.FPSHeight = if values.FPSGraph then 64 else 48
		appearance.HUDWidth = values.HUDWidth
		local decimals = tostring(values.CoordinatePrecision)
		appearance.CoordinateFormat = "X %."
			.. decimals
			.. "f  Y %."
			.. decimals
			.. "f  Z %."
			.. decimals
			.. "f"
		fpsPanel.Size = UDim2.fromOffset(132, appearance.FPSHeight)
		coordinatePanel.Size = UDim2.fromOffset(appearance.HUDWidth, 48)
		for i, bar in ipairs(fpsBars) do
			bar.Visible = values.FPSGraph
				and fpsEnabled
				and fpsHistory[i] ~= nil
		end
		if
			CONFIG.ReducedMotion ~= values.ReducedMotion and studioBridge.Motion
		then
			studioBridge.Motion(values.ReducedMotion)
		end
		if glitchEnabled ~= values.Glitch then
			setGlitchEnabled(values.Glitch)
		end
		if windowsPinned ~= values.Locked and studioBridge.Lock then
			studioBridge.Lock(values.Locked)
		end
		if snapDockToEdge ~= values.Snap and studioBridge.Snap then
			studioBridge.Snap(values.Snap)
		end
		if studio.Settings.ReducedMotion then
			resetTitle()
		end
		layout()
		if studio.Relayout then
			studio.Relayout()
		end
		for _, refresh in ipairs(studio.Refreshers) do
			refresh()
		end
		studio.Filter()
	end

	function studio.Apply(patch: any, reason: string): boolean
		if not alive or studio.Applying then
			return false
		end
		local valid, clean = studio.Validate(patch)
		if not valid then
			studio.Message(clean, true)
			return false
		end
		local previous = studio.Copy(studio.Settings)
		local nextValues = studio.Copy(previous)
		for key, value in pairs(clean) do
			nextValues[key] = value
		end
		if clean.Theme ~= nil and clean.CustomAccent == nil then
			nextValues.CustomAccent = false
		end
		if nextValues.ReducedMotion then
			if clean.Glitch == true then
				studio.Message(
					"Turn reduced motion off before enabling the glitch title.",
					true
				)
				return false
			end
			nextValues.Glitch = false
		end
		if studio.Same(previous, nextValues) then
			studio.Message("Already using those values.")
			return true
		end
		studio.Applying = true
		studio.Settings = nextValues
		local ok, issue = pcall(studio.Render, nextValues)
		if not ok then
			studio.Settings = previous
			pcall(studio.Render, previous)
			studio.Applying = false
			studio.Message(
				"Could not apply this change; previous settings restored.",
				true
			)
			warn("[Nullx11] Design Studio: " .. tostring(issue))
			return false
		end
		table.insert(studio.UndoStack, {
			Name = reason,
			Values = previous,
		})
		if #studio.UndoStack > studio.HistoryLimit then
			table.remove(studio.UndoStack, 1)
		end
		table.clear(studio.RedoStack)
		studio.Applying = false
		studio.UpdateHistoryButtons()
		studio.Message(reason)
		return true
	end

	function studio.TravelHistory(backward: boolean)
		if studio.Applying then
			return
		end
		local source = if backward then studio.UndoStack else studio.RedoStack
		local target = if backward then studio.RedoStack else studio.UndoStack
		if #source == 0 then
			studio.Message(
				if backward then "Nothing to undo." else "Nothing to redo."
			)
			return
		end
		local entry = source[#source]
		local previous = studio.Copy(studio.Settings)
		studio.Settings = studio.Copy(entry.Values)
		studio.Applying = true
		local ok, issue = pcall(studio.Render, studio.Settings)
		if not ok then
			studio.Settings = previous
			pcall(studio.Render, previous)
			studio.Applying = false
			studio.Message("History change could not be applied.", true)
			warn("[Nullx11] History: " .. tostring(issue))
			return
		end
		table.remove(source)
		table.insert(target, {
			Name = entry.Name,
			Values = previous,
		})
		studio.Applying = false
		studio.UpdateHistoryButtons()
		studio.Message(
			(if backward then "Undid: " else "Redid: ") .. entry.Name
		)
	end

	function studio.Export(): string?
		local service = game:GetService("HttpService")
		local ok, encoded = pcall(function()
			return service:JSONEncode({
				Version = studio.SchemaVersion,
				Settings = studio.Copy(studio.Settings),
			})
		end)
		if not ok then
			studio.Message("Could not encode this design.", true)
			return nil
		end
		return encoded
	end

	function studio.Import(source: string): boolean
		if #source == 0 or #source > studio.InputLimit then
			studio.Message("Paste a design between 1 and 8192 bytes.", true)
			return false
		end
		local service = game:GetService("HttpService")
		local ok, decoded = pcall(function()
			return service:JSONDecode(source)
		end)
		if not ok or type(decoded) ~= "table" then
			studio.Message("That is not a valid design JSON object.", true)
			return false
		end
		for key in pairs(decoded) do
			if key ~= "Version" and key ~= "Settings" then
				studio.Message(
					"Unexpected design field: " .. tostring(key),
					true
				)
				return false
			end
		end
		if decoded.Version ~= studio.SchemaVersion then
			studio.Message(
				"This design uses an unsupported format version.",
				true
			)
			return false
		end
		return studio.Apply(decoded.Settings, "Imported design settings.")
	end

	function studio.Focusable(button: GuiObject)
		local outline = create("UIStroke", {
			Name = "StudioFocus",
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = CONFIG.Accent,
			Thickness = 1.5,
			Transparency = 1,
		}, button)
		studio.FocusStrokes[button] = outline
		connect(button.SelectionGained, function()
			if studio.Settings.FocusOutlines then
				outline.Color = CONFIG.Accent
				tween(outline, {
					Transparency = 0,
				})
			end
		end)
		connect(button.SelectionLost, function()
			tween(outline, {
				Transparency = 1,
			})
		end)
		if button:IsA("TextBox") then
			connect(button.Focused, function()
				if studio.Settings.FocusOutlines then
					outline.Color = CONFIG.Accent
					outline.Transparency = 0
				end
			end)
			connect(button.FocusLost, function()
				outline.Transparency = 1
			end)
		end
	end

	function studio.Button(
		parent: Instance,
		name: string,
		text: string,
		position: UDim2,
		size: UDim2,
		callback: () -> ()
	): TextButton
		local button = create("TextButton", {
			Name = name,
			Text = text,
			TextSize = 12,
			TextWrapped = true,
			Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Position = position,
			Size = size,
		}, parent)
		corner(button, 9)
		studio.Focusable(button)
		connect(button.Activated, function()
			if alive then
				callback()
			end
		end)
		connect(button.MouseEnter, function()
			tween(button, {
				BackgroundTransparency = 0.2,
			})
		end)
		connect(button.MouseLeave, function()
			tween(button, {
				BackgroundTransparency = 0,
			})
		end)
		return button
	end

	function studio.Text(
		parent: Instance,
		name: string,
		text: string,
		size: number,
		position: UDim2,
		bounds: UDim2
	): TextLabel
		local textLabel = label(parent, text, size, colors.Text)
		textLabel.Name = name
		textLabel.Position = position
		textLabel.Size = bounds
		textLabel.TextWrapped = true
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		return textLabel
	end

	function studio.Input(
		parent: Instance,
		name: string,
		placeholder: string,
		position: UDim2,
		size: UDim2
	): TextBox
		local box = create("TextBox", {
			Name = name,
			Text = "",
			PlaceholderText = placeholder,
			TextColor3 = colors.Text,
			PlaceholderColor3 = colors.Muted,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			ClearTextOnFocus = false,
			MultiLine = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = position,
			Size = size,
		}, parent)
		corner(box, 9)
		create("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}, box)
		studio.Focusable(box)
		return box
	end

	function studio.Row(
		pageName: string,
		key: string,
		titleText: string,
		hintText: string,
		controlRows: number
	): any
		local page = studio.Pages[pageName]
		local row = create("Frame", {
			Name = "DesignRow_" .. key,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -4, 0, 120),
		}, page.Body)
		local heading = studio.Text(
			row,
			"DesignTitle_" .. key,
			titleText,
			13,
			UDim2.fromOffset(0, 0),
			UDim2.new(1, 0, 0, 22)
		)
		heading.Font = Enum.Font.GothamMedium
		local hint = studio.Text(
			row,
			"DesignHint_" .. key,
			hintText,
			10,
			UDim2.fromOffset(0, 24),
			UDim2.new(1, 0, 0, 36)
		)
		hint.TextColor3 = colors.Muted
		local holder = create("Frame", {
			Name = "DesignControls_" .. key,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 64),
			Size = UDim2.new(1, 0, 0, controlRows * 50),
		}, row)
		local metadata = {
			Key = key,
			Page = pageName,
			Search = string.lower(titleText .. " " .. hintText .. " " .. key),
			Frame = row,
			Heading = heading,
			Hint = hint,
			Holder = holder,
			ControlRows = controlRows,
			Controls = {},
			Paragraph = false,
		}
		table.insert(studio.Rows, metadata)
		return metadata
	end

	function studio.Control(
		metadata: any,
		object: GuiObject,
		rowIndex: number,
		columnIndex: number,
		columns: number
	)
		table.insert(metadata.Controls, {
			Object = object,
			Row = rowIndex,
			Column = columnIndex,
			Columns = columns,
		})
	end

	function studio.Format(field: any, value: number): string
		local shown = string.format("%.2f", value)
		shown = string.gsub(shown, "0+$", "")
		shown = string.gsub(shown, "%.$", "")
		return shown .. (field.Unit or "")
	end

	function studio.NumberField(field: any)
		local metadata =
			studio.Row(field.Page, field.Key, field.Title, field.Hint, 1)
		local down = studio.Button(
			metadata.Holder,
			"DesignMinus_" .. field.Key,
			"−",
			UDim2.fromOffset(0, 0),
			UDim2.fromOffset(44, 44),
			function()
				local value = math.max(
					field.Minimum,
					studio.Settings[field.Key] - field.Step
				)
				value = math.floor(value * 1000 + 0.5) / 1000
				studio.Apply(
					{ [field.Key] = value },
					field.Title .. " decreased."
				)
			end
		)
		local valueText = studio.Text(
			metadata.Holder,
			"DesignValue_" .. field.Key,
			"",
			14,
			UDim2.fromOffset(52, 12),
			UDim2.new(1, -104, 0, 24)
		)
		valueText.Font = Enum.Font.Code
		valueText.TextXAlignment = Enum.TextXAlignment.Center
		local up = studio.Button(
			metadata.Holder,
			"DesignPlus_" .. field.Key,
			"+",
			UDim2.new(1, -44, 0, 0),
			UDim2.fromOffset(44, 44),
			function()
				local value = math.min(
					field.Maximum,
					studio.Settings[field.Key] + field.Step
				)
				value = math.floor(value * 1000 + 0.5) / 1000
				studio.Apply(
					{ [field.Key] = value },
					field.Title .. " increased."
				)
			end
		)
		metadata.Stepper = {
			Down = down,
			Up = up,
			Value = valueText,
		}
		table.insert(studio.Refreshers, function()
			local value = studio.Settings[field.Key]
			valueText.Text = studio.Format(field, value)
			down.TextColor3 = if value <= field.Minimum
				then colors.Muted
				else colors.Text
			up.TextColor3 = if value >= field.Maximum
				then colors.Muted
				else colors.Text
		end)
	end

	function studio.ChoiceField(field: any)
		local columns = math.min(3, #field.Options)
		local rows = math.ceil(#field.Options / columns)
		local metadata =
			studio.Row(field.Page, field.Key, field.Title, field.Hint, rows)
		local buttons = {}
		for index, option in ipairs(field.Options) do
			local value = option
			local button = studio.Button(
				metadata.Holder,
				"DesignChoice_" .. field.Key .. "_" .. value,
				value,
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					studio.Apply(
						{ [field.Key] = value },
						field.Title .. ": " .. value
					)
				end
			)
			studio.Control(
				metadata,
				button,
				math.floor((index - 1) / columns),
				(index - 1) % columns,
				columns
			)
			buttons[value] = button
		end
		table.insert(studio.Refreshers, function()
			for value, button in pairs(buttons) do
				local selected = studio.Settings[field.Key] == value
				button.BackgroundColor3 = if selected
					then CONFIG.Accent
					else colors.Surface
				button.TextColor3 = if selected
					then colors.Panel
					else colors.Text
				if field.Key == "Theme" and studio.Settings.CustomAccent then
					button.BackgroundColor3 = colors.Surface
					button.TextColor3 = colors.Text
				end
			end
		end)
	end

	function studio.ToggleField(field: any)
		local metadata =
			studio.Row(field.Page, field.Key, field.Title, field.Hint, 1)
		local button = studio.Button(
			metadata.Holder,
			"DesignToggle_" .. field.Key,
			"",
			UDim2.fromOffset(0, 0),
			UDim2.new(1, 0, 0, 44),
			function()
				local value = not studio.Settings[field.Key]
				studio.Apply(
					{ [field.Key] = value },
					field.Title .. (if value then " enabled." else " disabled.")
				)
			end
		)
		studio.Control(metadata, button, 0, 0, 1)
		table.insert(studio.Refreshers, function()
			local enabled = studio.Settings[field.Key]
			button.Text = if enabled
				then "ON  /  tap to disable"
				else "OFF  /  tap to enable"
			button.TextColor3 = if enabled then CONFIG.Accent else colors.Muted
		end)
	end

	function studio.Paragraph(
		pageName: string,
		key: string,
		titleText: string,
		bodyText: string,
		height: number
	)
		local metadata = studio.Row(pageName, key, titleText, bodyText, 0)
		metadata.Paragraph = true
		metadata.ParagraphHeight = height
		metadata.Hint.Size = UDim2.new(1, 0, 0, height - 30)
		metadata.Hint.TextSize = 12
		metadata.Hint.TextColor3 = colors.Muted
		metadata.Holder.Visible = false
	end

	function studio.Action(
		pageName: string,
		key: string,
		titleText: string,
		hintText: string,
		caption: string,
		callback: () -> ()
	): TextButton
		local metadata = studio.Row(pageName, key, titleText, hintText, 1)
		local button = studio.Button(
			metadata.Holder,
			"DesignAction_" .. key,
			caption,
			UDim2.fromOffset(0, 0),
			UDim2.new(1, 0, 0, 44),
			callback
		)
		studio.Control(metadata, button, 0, 0, 1)
		return button
	end

	function studio.Filter()
		if not studio.Built then
			return
		end
		local query = string.lower(studio.Query)
		for name, page in pairs(studio.Pages) do
			local cursor = 0
			local matches = 0
			for _, metadata in ipairs(studio.Rows) do
				if metadata.Page ~= name then
					continue
				end
				local show = query == ""
					or string.find(metadata.Search, query, 1, true) ~= nil
				metadata.Frame.Visible = show
				if not show then
					continue
				end
				local controlHeight = if studio.Settings.LargeTargets
					then 52
					else 44
				local hintSpace = if studio.Settings.Hints then 64 else 30
				local height = hintSpace
					+ metadata.ControlRows * (controlHeight + 6)
					+ 14
				metadata.Hint.Visible = studio.Settings.Hints
					or metadata.Paragraph
				if metadata.Paragraph then
					height = metadata.ParagraphHeight + 16
				end
				metadata.Frame.Position = UDim2.fromOffset(0, cursor)
				metadata.Frame.Size = UDim2.new(1, -4, 0, height)
				metadata.Holder.Position = UDim2.fromOffset(0, hintSpace)
				metadata.Holder.Size = UDim2.new(
					1,
					0,
					0,
					metadata.ControlRows * (controlHeight + 6)
				)
				for _, control in ipairs(metadata.Controls) do
					control.Object.Position = UDim2.new(
						control.Column / control.Columns,
						0,
						0,
						control.Row * (controlHeight + 6)
					)
					control.Object.Size =
						UDim2.new(1 / control.Columns, -6, 0, controlHeight)
				end
				if metadata.Stepper then
					metadata.Stepper.Down.Size =
						UDim2.fromOffset(controlHeight, controlHeight)
					metadata.Stepper.Up.Position =
						UDim2.new(1, -controlHeight, 0, 0)
					metadata.Stepper.Up.Size =
						UDim2.fromOffset(controlHeight, controlHeight)
					metadata.Stepper.Value.Position =
						UDim2.fromOffset(controlHeight + 6, 12)
					metadata.Stepper.Value.Size =
						UDim2.new(1, -2 * (controlHeight + 6), 0, 26)
				end
				cursor += height
				matches += 1
			end
			page.Body.CanvasSize = UDim2.fromOffset(0, cursor + 8)
			page.Empty.Visible = matches == 0
			page.Count = matches
		end
	end

	function studio.Select(pageName: string)
		if not studio.Pages[pageName] then
			return
		end
		studio.ActivePage = pageName
		for name, page in pairs(studio.Pages) do
			local selected = name == pageName
			page.Body.Visible = selected
			page.Button.BackgroundColor3 = if selected
				then CONFIG.Accent
				else colors.Surface
			page.Button.TextColor3 = if selected
				then colors.Panel
				else colors.Muted
		end
		studio.Filter()
		if studio.UpdateMap then
			studio.UpdateMap()
		end
	end

	function studio.UpdateHistoryButtons()
		if not studio.UndoButton then
			return
		end
		studio.UndoButton.Text = "Undo " .. #studio.UndoStack
		studio.RedoButton.Text = "Redo " .. #studio.RedoStack
		studio.UndoButton.TextColor3 = if #studio.UndoStack > 0
			then colors.Text
			else colors.Muted
		studio.RedoButton.TextColor3 = if #studio.RedoStack > 0
			then colors.Text
			else colors.Muted
		if studio.RefreshDiagnostics then
			studio.RefreshDiagnostics()
		end
	end

	function studio.BuildWindow()
		studio.Window = create("Frame", {
			Name = "DesignStudio",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(620, 600),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			Visible = false,
		}, root)
		corner(studio.Window, 18)
		create("UIStroke", {
			Name = "StudioBorder",
			Color = colors.Border,
			Thickness = 1,
		}, studio.Window)
		create("UIGradient", {
			Color = ColorSequence.new(colors.Panel, Color3.fromRGB(28, 27, 39)),
			Rotation = 120,
		}, studio.Window)
		local handle = create("Frame", {
			Name = "DesignDragHandle",
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, -64, 0, 66),
		}, studio.Window)
		drawIcon(handle, CONFIG.Accent, UDim2.fromOffset(18, 20), 26)
		local titleLabel = studio.Text(
			handle,
			"DesignHeading",
			"Design Studio",
			18,
			UDim2.fromOffset(56, 17),
			UDim2.new(1, -56, 0, 26)
		)
		titleLabel.Font = Enum.Font.GothamBold
		local subtitleLabel = studio.Text(
			handle,
			"DesignSubheading",
			"NULLX11 / MAKE IT YOURS",
			9,
			UDim2.fromOffset(56, 45),
			UDim2.new(1, -56, 0, 16)
		)
		subtitleLabel.TextColor3 = colors.Muted
		subtitleLabel.Font = Enum.Font.Code
		studio.Button(
			studio.Window,
			"DesignClose",
			"×",
			UDim2.new(1, -58, 0, 12),
			UDim2.fromOffset(44, 44),
			function()
				portal.Play(studio.Window, false)
			end
		)
		local navigation = create("ScrollingFrame", {
			Name = "DesignNavigation",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(18, 74),
			Size = UDim2.new(1, -36, 0, 46),
			CanvasSize = UDim2.fromOffset(606, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, studio.Window)
		for index, name in ipairs({
			"Color",
			"Type",
			"Layout",
			"Motion",
			"Profiles",
			"Help",
		}) do
			local pageName = name
			local button = studio.Button(
				navigation,
				"DesignTab_" .. pageName,
				pageName,
				UDim2.fromOffset((index - 1) * 102, 0),
				UDim2.fromOffset(96, 42),
				function()
					studio.Select(pageName)
				end
			)
			local body = create("ScrollingFrame", {
				Name = "DesignPage_" .. pageName,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(18, 184),
				Size = UDim2.new(1, -36, 1, -266),
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = CONFIG.Accent,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = false,
			}, studio.Window)
			local empty = studio.Text(
				body,
				"DesignEmpty_" .. pageName,
				"No settings match. Try a shorter search.",
				12,
				UDim2.fromOffset(0, 8),
				UDim2.new(1, -8, 0, 48)
			)
			empty.TextColor3 = colors.Muted
			empty.Visible = false
			studio.Pages[pageName] = {
				Button = button,
				Body = body,
				Empty = empty,
				Count = 0,
			}
		end
		studio.Search = studio.Input(
			studio.Window,
			"DesignSearch",
			"Search this category…",
			UDim2.fromOffset(18, 130),
			UDim2.new(1, -36, 0, 42)
		)
		connect(studio.Search:GetPropertyChangedSignal("Text"), function()
			-- Bounded plain substring matching: user input is never a Lua pattern.
			studio.Query = string.sub(studio.Search.Text, 1, 80)
			studio.Filter()
		end)
		create("Frame", {
			BackgroundColor3 = colors.Border,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 18, 1, -72),
			Size = UDim2.new(1, -36, 0, 1),
		}, studio.Window)
		studio.MessageLabel = studio.Text(
			studio.Window,
			"DesignMessage",
			"Changes stay in memory until you export them.",
			10,
			UDim2.new(0, 18, 1, -62),
			UDim2.new(1, -210, 0, 50)
		)
		studio.MessageLabel.TextColor3 = colors.Muted
		studio.UndoButton = studio.Button(
			studio.Window,
			"DesignUndo",
			"Undo 0",
			UDim2.new(1, -184, 1, -58),
			UDim2.fromOffset(78, 44),
			function()
				studio.TravelHistory(true)
			end
		)
		studio.RedoButton = studio.Button(
			studio.Window,
			"DesignRedo",
			"Redo 0",
			UDim2.new(1, -98, 1, -58),
			UDim2.fromOffset(78, 44),
			function()
				studio.TravelHistory(false)
			end
		)
		local previousExtras = layoutExtras
		studio.Relayout = function()
			local viewport = root.AbsoluteSize
			if viewport.X <= 0 or viewport.Y <= 0 then
				return
			end
			local width = math.min(
				studio.Settings.StudioWidth,
				math.max(1, viewport.X - 24)
			)
			local height = math.min(
				studio.Settings.StudioHeight,
				math.max(1, viewport.Y - 24)
			)
			studio.Window.Size = UDim2.fromOffset(width, height)
			local center = clampCenter(
				extraCenters[studio.Window] or viewport / 2,
				Vector2.new(width, height)
			)
			extraCenters[studio.Window] = center
			studio.Window.Position = UDim2.fromOffset(center.X, center.Y)
		end
		layoutExtras = function()
			if previousExtras then
				previousExtras()
			end
			studio.Relayout()
		end
		draggable(handle, studio.Window)
	end

	function studio.Editor(
		pageName: string,
		key: string,
		titleText: string,
		hintText: string,
		rows: number,
		editable: boolean
	): TextBox
		local metadata = studio.Row(pageName, key, titleText, hintText, rows)
		local scroller = create("ScrollingFrame", {
			Name = "DesignEditorScroll_" .. key,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, -6),
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, metadata.Holder)
		local box = studio.Input(
			scroller,
			"DesignEditor_" .. key,
			if editable then "Paste or type here…" else "Nothing to show yet.",
			UDim2.fromOffset(0, 0),
			UDim2.new(1, -6, 1, -6)
		)
		box.AutomaticSize = Enum.AutomaticSize.Y
		box.Size = UDim2.new(1, -8, 0, math.max(44, rows * 50 - 6))
		box.MultiLine = true
		box.TextEditable = editable
		box.TextWrapped = true
		box.TextYAlignment = Enum.TextYAlignment.Top
		box.TextSize = 11
		box.Font = Enum.Font.Code
		create("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		}, box)
		return box
	end

	function studio.Differences(
		left: { [string]: any },
		right: { [string]: any }
	): string
		local differences = {}
		for _, field in ipairs(studio.Schema) do
			local from = left[field.Key]
			local to = right[field.Key]
			if from ~= to then
				table.insert(
					differences,
					string.format(
						"%s: %s → %s",
						field.Title,
						tostring(from),
						tostring(to)
					)
				)
			end
		end
		if #differences == 0 then
			return "No differences."
		end
		return table.concat(differences, "\n")
	end

	function studio.BuildInspector()
		local summary = studio.Editor(
			"Profiles",
			"Inspector",
			"Current design summary",
			"Read-only values. No player identity, locations, or game data are exported.",
			4,
			false
		)
		table.insert(studio.Refreshers, function()
			local lines = {}
			for _, field in ipairs(studio.Schema) do
				table.insert(
					lines,
					field.Title .. ": " .. tostring(studio.Settings[field.Key])
				)
			end
			summary.Text = table.concat(lines, "\n")
		end)
		local history = studio.Editor(
			"Profiles",
			"History",
			"Recent changes",
			"Undo history is capped at 24 snapshots; a new change clears redo.",
			3,
			false
		)
		studio.HistoryEditor = history
		studio.Action(
			"Profiles",
			"RefreshHistory",
			"Review undo history",
			"The newest reversible change is listed first.",
			"Refresh change list",
			function()
				local entries = {}
				for index = #studio.UndoStack, 1, -1 do
					table.insert(entries, studio.UndoStack[index].Name)
				end
				history.Text = if #entries > 0
					then table.concat(entries, "\n")
					else "No Studio changes recorded."
			end
		)
	end

	function studio.BuildColorPreview()
		local metadata = studio.Row(
			"Color",
			"Preview",
			"Live accent preview",
			"Changes below affect your existing windows, not a separate mockup.",
			2
		)
		local sample = create("Frame", {
			Name = "DesignPreview",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, -6),
		}, metadata.Holder)
		corner(sample, 12)
		local tile = create("Frame", {
			Name = "DesignSwatch",
			BackgroundColor3 = CONFIG.Accent,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.fromOffset(46, 46),
		}, sample)
		corner(tile, 13)
		drawIcon(tile, colors.Panel, UDim2.fromOffset(8, 8), 30)
		local name = studio.Text(
			sample,
			"DesignPreviewName",
			CONFIG.Name,
			18,
			UDim2.fromOffset(74, 14),
			UDim2.new(1, -88, 0, 26)
		)
		name.Font = Enum.Font.Code
		local channels = studio.Text(
			sample,
			"DesignPreviewRGB",
			"",
			11,
			UDim2.fromOffset(74, 47),
			UDim2.new(1, -88, 0, 38)
		)
		channels.TextColor3 = colors.Muted
		channels.Font = Enum.Font.Code
		table.insert(studio.Refreshers, function()
			local accent = studio.Accent(studio.Settings)
			tile.BackgroundColor3 = accent
			channels.Text = string.format(
				"RGB %d / %d / %d",
				math.floor(accent.R * 255 + 0.5),
				math.floor(accent.G * 255 + 0.5),
				math.floor(accent.B * 255 + 0.5)
			)
		end)
	end

	function studio.BuildPresetLibrary()
		studio.Paragraph(
			"Profiles",
			"PresetIntro",
			"Start with a design recipe",
			"Recipes change only the listed style preferences. Your bookmarks, running tools, and window positions are not deleted. Undo restores the previous settings.",
			124
		)
		for _, preset in ipairs(studio.Presets) do
			local recipe = preset
			studio.Action(
				"Profiles",
				"Preset_" .. recipe.Name,
				recipe.Name,
				recipe.Description,
				"Apply " .. recipe.Name,
				function()
					studio.Apply(
						recipe.Values,
						recipe.Name .. " recipe applied."
					)
				end
			)
		end
	end

	function studio.CleanName(source: string, fallback: string): string
		local value = string.gsub(source, "%c", " ")
		value = string.match(value, "^%s*(.-)%s*$") or ""
		local length = utf8.len(value)
		if not length or length == 0 then
			return fallback
		end
		if length > 24 then
			local boundary = utf8.offset(value, 25)
			if boundary then
				value = string.sub(value, 1, boundary - 1)
			end
		end
		return value
	end

	function studio.SaveSlot(index: number, name: string)
		studio.Saved[index] = {
			Name = studio.CleanName(name, "Design " .. index),
			Values = studio.Copy(studio.Settings),
		}
		studio.Message(name .. " saved in memory.")
	end

	function studio.LoadSlot(index: number)
		local entry = studio.Saved[index]
		if not entry then
			studio.Message("Save a design in this slot first.", true)
			return
		end
		studio.Apply(entry.Values, "Loaded " .. entry.Name .. ".")
	end

	function studio.BuildMemorySlots()
		studio.Paragraph(
			"Profiles",
			"MemoryIntro",
			"Three local design slots",
			"These hold appearance settings, not teleport positions. Slots stay available while the loader is running and are cleared when it closes. Export JSON if you want to keep a design outside this run.",
			144
		)
		for index = 1, 3 do
			local slotIndex = index
			local metadata = studio.Row(
				"Profiles",
				"SlotName" .. index,
				"Design slot " .. index,
				"Give this in-memory design a short name before saving.",
				1
			)
			local name = studio.Input(
				metadata.Holder,
				"DesignSlotName" .. index,
				"Design name",
				UDim2.fromOffset(0, 0),
				UDim2.new(1, -6, 0, 44)
			)
			name.Text = "Design " .. index
			studio.Control(metadata, name, 0, 0, 1)
			connect(name.FocusLost, function()
				name.Text = studio.CleanName(name.Text, "Design " .. slotIndex)
			end)
			local actions = studio.Row(
				"Profiles",
				"SlotActions" .. index,
				"Save, load, or compare slot " .. index,
				"Compare shows differences without applying them.",
				1
			)
			local save = studio.Button(
				actions.Holder,
				"DesignSave" .. index,
				"Save",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local caption =
						studio.CleanName(name.Text, "Design " .. slotIndex)
					studio.SaveSlot(slotIndex, caption)
				end
			)
			studio.Control(actions, save, 0, 0, 3)
			local load = studio.Button(
				actions.Holder,
				"DesignLoad" .. index,
				"Load",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					studio.LoadSlot(slotIndex)
				end
			)
			studio.Control(actions, load, 0, 1, 3)
			local compare = studio.Button(
				actions.Holder,
				"DesignCompare" .. index,
				"Compare",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local entry = studio.Saved[slotIndex]
					if not entry then
						studio.Message("This design slot is empty.", true)
						return
					end
					studio.Comparison.Text =
						studio.Differences(studio.Settings, entry.Values)
					studio.Message(
						"Comparison generated; scroll to the comparison panel."
					)
				end
			)
			studio.Control(actions, compare, 0, 2, 3)
		end
		studio.Comparison = studio.Editor(
			"Profiles",
			"Comparison",
			"Design comparison",
			"Current values are on the left; saved values are on the right.",
			4,
			false
		)
	end

	function studio.BuildTransfer()
		studio.Transfer = studio.Editor(
			"Profiles",
			"Transfer",
			"Design JSON",
			"Select/copy the text manually. Import accepts settings only, never code or remote URLs.",
			5,
			true
		)
		studio.Action(
			"Profiles",
			"Export",
			"Export current design",
			"Writes a versioned settings object into the text field above. Nothing is written to disk or clipboard automatically.",
			"Generate JSON",
			function()
				local encoded = studio.Export()
				if encoded then
					studio.Transfer.Text = encoded
					studio.Message(
						"Design generated. Select the JSON text to copy it."
					)
				end
			end
		)
		studio.Action(
			"Profiles",
			"Import",
			"Import design JSON",
			"All fields are checked before a change is applied. Unknown settings, bad versions, and out-of-range values are rejected.",
			"Validate and import",
			function()
				studio.Import(studio.Transfer.Text)
			end
		)
		studio.Action(
			"Profiles",
			"CompareDefaults",
			"Compare against defaults",
			"Review what you changed without resetting anything.",
			"Show default differences",
			function()
				studio.Comparison.Text =
					studio.Differences(studio.Defaults, studio.Settings)
				studio.Message("Default comparison generated.")
			end
		)
		local resetUntil = 0
		local resetButton: TextButton? = nil
		resetButton = studio.Action(
			"Profiles",
			"ResetAll",
			"Reset all appearance settings",
			"Tap twice within three seconds. Bookmarks and saved design slots are not deleted. This reset can be undone.",
			"Reset appearance",
			function()
				if not resetButton then
					return
				end
				if resetUntil == 0 or os.clock() > resetUntil then
					resetUntil = os.clock() + 3
					resetButton.Text = "Tap again within 3 seconds"
					studio.Message(
						"Confirm reset, or wait three seconds to cancel."
					)
					return
				end
				resetUntil = 0
				resetButton.Text = "Reset appearance"
				studio.Apply(studio.Defaults, "Appearance reset to defaults.")
			end
		)
	end

	function studio.Arrange(mode: string)
		local viewport = root.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
		local center = viewport / 2
		if mode == "Left" then
			panelCenter = Vector2.new(card.AbsoluteSize.X / 2 + 12, center.Y)
		elseif mode == "Right" then
			panelCenter =
				Vector2.new(viewport.X - card.AbsoluteSize.X / 2 - 12, center.Y)
		elseif mode == "Stack" then
			extraCenters[fpsPanel] = Vector2.new(viewport.X - 90, 48)
			extraCenters[coordinatePanel] = Vector2.new(viewport.X - 140, 120)
			extraCenters[teleportPanel] = Vector2.new(viewport.X - 180, 340)
		else
			panelCenter = nil
			miniCenter = nil
			table.clear(extraCenters)
		end
		drag = nil
		layout()
		studio.Message(
			"Window arrangement updated; small screens may overlap panels."
		)
	end

	function studio.BuildArrangements()
		studio.Action(
			"Layout",
			"ArrangeLeft",
			"Dashboard on the left",
			"Keep the main panel toward the left safe-area edge.",
			"Align dashboard left",
			function()
				studio.Arrange("Left")
			end
		)
		studio.Action(
			"Layout",
			"ArrangeRight",
			"Dashboard on the right",
			"Keep the main panel toward the right safe-area edge.",
			"Align dashboard right",
			function()
				studio.Arrange("Right")
			end
		)
		studio.Action(
			"Layout",
			"ArrangeStack",
			"Utility stack",
			"Place FPS, coordinates, and bookmarks down the right side. This does not enable disabled utilities.",
			"Stack floating utilities",
			function()
				studio.Arrange("Stack")
			end
		)
		studio.Action(
			"Layout",
			"ArrangeReset",
			"Recover window positions",
			"Recenter panels and restore the default dock position without altering their dimensions.",
			"Recover all windows",
			function()
				studio.Arrange("Reset")
			end
		)
	end

	function studio.Luminance(color: Color3): number
		local function linear(channel: number): number
			if channel <= 0.04045 then
				return channel / 12.92
			end
			return ((channel + 0.055) / 1.055) ^ 2.4
		end
		return 0.2126 * linear(color.R)
			+ 0.7152 * linear(color.G)
			+ 0.0722 * linear(color.B)
	end

	function studio.Contrast(first: Color3, second: Color3): number
		local a = studio.Luminance(first)
		local b = studio.Luminance(second)
		return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05)
	end

	function studio.HSV(color: Color3): (number, number, number)
		local maximum = math.max(color.R, color.G, color.B)
		local minimum = math.min(color.R, color.G, color.B)
		local delta = maximum - minimum
		local saturation = if maximum == 0 then 0 else delta / maximum
		local hue = 0
		if delta > 0 then
			if maximum == color.R then
				hue = ((color.G - color.B) / delta) % 6
			elseif maximum == color.G then
				hue = (color.B - color.R) / delta + 2
			else
				hue = (color.R - color.G) / delta + 4
			end
			hue = (hue / 6) % 1
		end
		return hue, saturation, maximum
	end

	function studio.FromHSV(
		hue: number,
		saturation: number,
		value: number
	): Color3
		hue = hue % 1
		saturation = math.clamp(saturation, 0, 1)
		value = math.clamp(value, 0, 1)
		local sector = math.floor(hue * 6)
		local fraction = hue * 6 - sector
		local low = value * (1 - saturation)
		local falling = value * (1 - fraction * saturation)
		local rising = value * (1 - (1 - fraction) * saturation)
		local red, green, blue
		if sector == 0 then
			red, green, blue = value, rising, low
		elseif sector == 1 then
			red, green, blue = falling, value, low
		elseif sector == 2 then
			red, green, blue = low, value, rising
		elseif sector == 3 then
			red, green, blue = low, falling, value
		elseif sector == 4 then
			red, green, blue = rising, low, value
		else
			red, green, blue = value, low, falling
		end
		return Color3.new(red, green, blue)
	end

	function studio.UseColor(color: Color3, reason: string)
		studio.Apply({
			CustomAccent = true,
			Red = math.floor(color.R * 255 + 0.5),
			Green = math.floor(color.G * 255 + 0.5),
			Blue = math.floor(color.B * 255 + 0.5),
		}, reason)
	end

	function studio.BuildColorTools()
		local metadata = studio.Row(
			"Color",
			"Tints",
			"Tint and shade ladder",
			"Choose a related custom accent. The middle swatch is the current accent.",
			2
		)
		local tintButtons = {}
		local strengths = { -0.3, -0.15, 0, 0.15, 0.3 }
		for index, amount in ipairs(strengths) do
			local strength = amount
			local button = studio.Button(
				metadata.Holder,
				"DesignTint" .. index,
				if amount == 0
					then "Current"
					else string.format("%+d%%", amount * 100),
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local accent = studio.Accent(studio.Settings)
					local target = if strength < 0
						then Color3.new(0, 0, 0)
						else Color3.new(1, 1, 1)
					studio.UseColor(
						accent:Lerp(target, math.abs(strength)),
						"Related accent selected."
					)
				end
			)
			studio.Control(
				metadata,
				button,
				math.floor((index - 1) / 3),
				(index - 1) % 3,
				3
			)
			tintButtons[index] = button
		end
		table.insert(studio.Refreshers, function()
			local accent = studio.Accent(studio.Settings)
			for index, amount in ipairs(strengths) do
				local target = if amount < 0
					then Color3.new(0, 0, 0)
					else Color3.new(1, 1, 1)
				local mixed = accent:Lerp(target, math.abs(amount))
				tintButtons[index].BackgroundColor3 = mixed
				tintButtons[index].TextColor3 = if studio.Contrast(
						mixed,
						colors.Panel
					) >= 4.5
					then colors.Panel
					else colors.Text
			end
		end)
		local harmony = studio.Row(
			"Color",
			"Harmony",
			"Hue adjustments",
			"Rotate the current hue while retaining saturation and brightness.",
			1
		)
		for index, adjustment in ipairs({
			{
				Name = "WarmTurn",
				Caption = "−30°",
				Delta = -1 / 12,
			},
			{
				Name = "Complement",
				Caption = "+180°",
				Delta = 0.5,
			},
			{
				Name = "CoolTurn",
				Caption = "+30°",
				Delta = 1 / 12,
			},
		}) do
			local change = adjustment
			local button = studio.Button(
				harmony.Holder,
				"DesignHue_" .. change.Name,
				change.Caption,
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local hue, saturation, value =
						studio.HSV(studio.Accent(studio.Settings))
					studio.UseColor(
						studio.FromHSV(hue + change.Delta, saturation, value),
						"Accent hue rotated."
					)
				end
			)
			studio.Control(harmony, button, 0, index - 1, 3)
		end
		studio.Action(
			"Color",
			"SoftenAccent",
			"Soften the current accent",
			"Reduce saturation by ten percent without changing hue or brightness.",
			"Reduce saturation",
			function()
				local hue, saturation, value =
					studio.HSV(studio.Accent(studio.Settings))
				studio.UseColor(
					studio.FromHSV(hue, saturation - 0.1, value),
					"Accent softened."
				)
			end
		)
	end

	function studio.BuildContrastReadout()
		local box = studio.Editor(
			"Color",
			"Contrast",
			"Contrast reference",
			"Calculated against opaque base colors. Transparent backgrounds and gameplay can change actual contrast.",
			4,
			false
		)
		table.insert(studio.Refreshers, function()
			local accent = studio.Accent(studio.Settings)
			local readings = {
				{
					Name = "Accent / panel",
					First = accent,
					Second = colors.Panel,
				},
				{
					Name = "Accent / surface",
					First = accent,
					Second = colors.Surface,
				},
				{
					Name = "Primary text / panel",
					First = colors.Text,
					Second = colors.Panel,
				},
				{
					Name = "Secondary text / panel",
					First = colors.Muted,
					Second = colors.Panel,
				},
			}
			local lines = {}
			for _, reading in ipairs(readings) do
				local ratio = studio.Contrast(reading.First, reading.Second)
				local note = if ratio >= 4.5
					then ">= 4.5 reference"
					else "below 4.5 reference"
				table.insert(
					lines,
					string.format("%s: %.2f:1 (%s)", reading.Name, ratio, note)
				)
			end
			table.insert(
				lines,
				"Reference only; not an accessibility certification."
			)
			box.Text = table.concat(lines, "\n")
		end)
	end

	function studio.BuildTypographyPreview()
		local metadata = studio.Row(
			"Type",
			"TypographyPreview",
			"Reading preview",
			"Font and text scale apply to these real labels as well as your workspace.",
			4
		)
		local surface = create("Frame", {
			Name = "DesignTypePreview",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, -6),
		}, metadata.Holder)
		corner(surface, 12)
		local heading = studio.Text(
			surface,
			"DesignTypeHeading",
			"Aa Bb Cc 123",
			22,
			UDim2.fromOffset(14, 14),
			UDim2.new(1, -28, 0, 40)
		)
		heading.Font = Enum.Font.GothamBold
		studio.Text(
			surface,
			"DesignTypeBody",
			"A quiet interface should remain easy to read while the game is moving behind it.",
			13,
			UDim2.fromOffset(14, 62),
			UDim2.new(1, -28, 0, 64)
		)
		local technical = studio.Text(
			surface,
			"DesignTypeCode",
			"X 128.4  Y 32.0  Z -64.2\n60 FPS / LOCAL SESSION",
			12,
			UDim2.fromOffset(14, 138),
			UDim2.new(1, -28, 0, 54)
		)
		technical.Font = Enum.Font.Code
		technical.TextColor3 = CONFIG.Accent
	end

	function studio.BuildDiagnostics()
		local diagnostics = studio.Editor(
			"Help",
			"Diagnostics",
			"Interface diagnostics",
			"A local snapshot of UI dimensions and settings, not an executor or server capability test.",
			4,
			false
		)
		studio.RefreshDiagnostics = function()
			if not studio.Window then
				return
			end
			local viewport = root.AbsoluteSize
			local changed = 0
			for _, field in ipairs(studio.Schema) do
				if studio.Settings[field.Key] ~= studio.Defaults[field.Key] then
					changed += 1
				end
			end
			diagnostics.Text = table.concat({
				string.format(
					"Safe area: %.0f x %.0f px",
					viewport.X,
					viewport.Y
				),
				string.format(
					"Dashboard: %.0f x %.0f px",
					card.AbsoluteSize.X,
					card.AbsoluteSize.Y
				),
				string.format(
					"Studio: %.0f x %.0f px",
					studio.Window.AbsoluteSize.X,
					studio.Window.AbsoluteSize.Y
				),
				string.format(
					"Changed settings: %d / %d",
					changed,
					#studio.Schema
				),
				string.format(
					"Undo: %d / %d",
					#studio.UndoStack,
					studio.HistoryLimit
				),
				string.format("GUI descendants: %d", #gui:GetDescendants()),
				"No filesystem or clipboard permissions are requested.",
			}, "\n")
		end
		table.insert(studio.Refreshers, studio.RefreshDiagnostics)
		studio.Action(
			"Help",
			"RefreshDiagnostics",
			"Refresh diagnostic snapshot",
			"Useful after rotating the device or moving panels. No network requests are made.",
			"Refresh local UI information",
			function()
				studio.RefreshDiagnostics()
				studio.Message("Local UI snapshot refreshed.")
			end
		)
	end

	function studio.BuildMotionRecipes()
		local recipes = {
			{
				Name = "Instant",
				Description = "No animated transitions or title glitches.",
				Values = {
					ReducedMotion = true,
					Glitch = false,
				},
			},
			{
				Name = "Snappy",
				Description = "Short cubic transitions without title distortion.",
				Values = {
					ReducedMotion = false,
					Glitch = false,
					MotionSpeed = 0.5,
					Easing = "Cubic",
				},
			},
			{
				Name = "Gentle",
				Description = "Longer sine easing and a calm, undistorted title.",
				Values = {
					ReducedMotion = false,
					Glitch = false,
					MotionSpeed = 1.5,
					Easing = "Sine",
				},
			},
			{
				Name = "Signature",
				Description = "The original short RGB split with quint easing.",
				Values = {
					ReducedMotion = false,
					Glitch = true,
					MotionSpeed = 1,
					Easing = "Quint",
					GlitchInterval = 3.6,
					GlitchDuration = 0.14,
					GlitchOffset = 2,
				},
			},
			{
				Name = "Occasional",
				Description = "An infrequent, small split for a quieter title.",
				Values = {
					ReducedMotion = false,
					Glitch = true,
					MotionSpeed = 1,
					Easing = "Quad",
					GlitchInterval = 8,
					GlitchDuration = 0.08,
					GlitchOffset = 1,
				},
			},
		}
		for _, recipe in ipairs(recipes) do
			local preset = recipe
			studio.Action(
				"Motion",
				"Motion_" .. preset.Name,
				preset.Name .. " motion",
				preset.Description,
				"Use " .. preset.Name,
				function()
					studio.Apply(
						preset.Values,
						preset.Name .. " motion applied."
					)
				end
			)
		end
	end

	function studio.BuildHexInput()
		local metadata = studio.Row(
			"Color",
			"HexInput",
			"Hexadecimal accent",
			"Accepts RGB or RRGGBB, with or without a leading #. Apply explicitly after editing.",
			1
		)
		local box = studio.Input(
			metadata.Holder,
			"DesignHexInput",
			"#A792FF",
			UDim2.fromOffset(0, 0),
			UDim2.new(1, -6, 0, 44)
		)
		box.Font = Enum.Font.Code
		studio.Control(metadata, box, 0, 0, 1)
		studio.Action(
			"Color",
			"ApplyHex",
			"Apply hex accent",
			"A malformed color leaves your existing design unchanged.",
			"Validate and use hex",
			function()
				local value = string.match(box.Text, "^%s*(.-)%s*$") or ""
				value = string.gsub(value, "^#", "")
				if not string.match(value, "^[%da-fA-F]+$") then
					studio.Message(
						"Use hexadecimal digits only, such as #A792FF.",
						true
					)
					return
				end
				if #value == 3 then
					value = string.sub(value, 1, 1)
						.. string.sub(value, 1, 1)
						.. string.sub(value, 2, 2)
						.. string.sub(value, 2, 2)
						.. string.sub(value, 3, 3)
						.. string.sub(value, 3, 3)
				elseif #value ~= 6 then
					studio.Message("Use exactly three or six hex digits.", true)
					return
				end
				local red = tonumber(string.sub(value, 1, 2), 16)
				local green = tonumber(string.sub(value, 3, 4), 16)
				local blue = tonumber(string.sub(value, 5, 6), 16)
				if not red or not green or not blue then
					studio.Message("Could not read that color.", true)
					return
				end
				studio.UseColor(
					Color3.fromRGB(red, green, blue),
					"Hex accent applied."
				)
			end
		)
		studio.Action(
			"Color",
			"ReadHex",
			"Read current accent as hex",
			"Writes the current accent into the input without changing any settings.",
			"Read accent",
			function()
				local color = studio.Accent(studio.Settings)
				box.Text = string.format(
					"#%02X%02X%02X",
					math.floor(color.R * 255 + 0.5),
					math.floor(color.G * 255 + 0.5),
					math.floor(color.B * 255 + 0.5)
				)
				studio.Message("Current accent copied into the hex input.")
			end
		)
	end

	function studio.BuildLayoutMap()
		local metadata = studio.Row(
			"Layout",
			"WindowMap",
			"Live window map",
			"A normalized safe-area diagram. Dim rectangles represent hidden panels. This preview does not capture the game screen.",
			5
		)
		local map = create("Frame", {
			Name = "DesignWindowMap",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.new(1, -6, 1, -6),
			ClipsDescendants = true,
		}, metadata.Holder)
		corner(map, 12)
		local safe = create("Frame", {
			Name = "DesignMapBounds",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(8, 8),
			Size = UDim2.new(1, -16, 1, -16),
		}, map)
		create("UIStroke", {
			Color = colors.Border,
			Thickness = 1,
		}, safe)
		local rectangles = {}
		for _, item in ipairs({
			{
				Name = "Dashboard",
				Target = card,
				Caption = "UI",
			},
			{
				Name = "Bookmarks",
				Target = teleportPanel,
				Caption = "SPOT",
			},
			{
				Name = "FPS",
				Target = fpsPanel,
				Caption = "FPS",
			},
			{
				Name = "Coordinates",
				Target = coordinatePanel,
				Caption = "XYZ",
			},
			{
				Name = "Dock",
				Target = mini,
				Caption = "N",
			},
		}) do
			local rectangle = create("Frame", {
				Name = "DesignMap_" .. item.Name,
				BackgroundColor3 = CONFIG.Accent,
				BackgroundTransparency = 0.4,
				BorderSizePixel = 0,
			}, safe)
			corner(rectangle, 3)
			local caption = studio.Text(
				rectangle,
				"DesignMapCaption_" .. item.Name,
				item.Caption,
				8,
				UDim2.fromScale(0, 0),
				UDim2.fromScale(1, 1)
			)
			caption.TextColor3 = colors.Panel
			caption.TextXAlignment = Enum.TextXAlignment.Center
			caption.TextYAlignment = Enum.TextYAlignment.Center
			table.insert(rectangles, {
				Target = item.Target,
				Rectangle = rectangle,
			})
		end
		studio.UpdateMap = function()
			if
				not studio.Window
				or not studio.Window.Visible
				or studio.ActivePage ~= "Layout"
			then
				return
			end
			local viewport = root.AbsoluteSize
			if viewport.X <= 0 or viewport.Y <= 0 then
				return
			end
			for _, entry in ipairs(rectangles) do
				local target = entry.Target
				local position = target.AbsolutePosition - root.AbsolutePosition
				local size = target.AbsoluteSize
				entry.Rectangle.Position = UDim2.fromScale(
					position.X / viewport.X,
					position.Y / viewport.Y
				)
				entry.Rectangle.Size =
					UDim2.fromScale(size.X / viewport.X, size.Y / viewport.Y)
				entry.Rectangle.BackgroundColor3 = CONFIG.Accent
				entry.Rectangle.BackgroundTransparency = if target.Visible
					then 0.35
					else 0.82
			end
		end
		for _, entry in ipairs(rectangles) do
			connect(
				entry.Target:GetPropertyChangedSignal("AbsolutePosition"),
				studio.UpdateMap
			)
			connect(
				entry.Target:GetPropertyChangedSignal("AbsoluteSize"),
				studio.UpdateMap
			)
			connect(
				entry.Target:GetPropertyChangedSignal("Visible"),
				studio.UpdateMap
			)
		end
		table.insert(studio.Refreshers, studio.UpdateMap)
	end

	function studio.BuildSlotManagement()
		studio.Paragraph(
			"Profiles",
			"SlotManagement",
			"Manage saved designs",
			"Deleting a design slot does not change your active appearance. The design-slot contents are separate from undo history and teleport bookmarks.",
			132
		)
		for index = 1, 3 do
			local slotIndex = index
			local deadline = 0
			local button: TextButton? = nil
			button = studio.Action(
				"Profiles",
				"DeleteSlot" .. index,
				"Delete design slot " .. index,
				"Confirm with a second tap within three seconds. This deletion cannot be undone.",
				"Delete slot " .. index,
				function()
					if not button then
						return
					end
					if not studio.Saved[slotIndex] then
						studio.Message("This design slot is already empty.")
						return
					end
					if deadline == 0 or os.clock() > deadline then
						deadline = os.clock() + 3
						button.Text = "Tap again within 3 seconds"
						return
					end
					deadline = 0
					studio.Saved[slotIndex] = nil
					button.Text = "Delete slot " .. slotIndex
					studio.Message(
						"Saved design slot " .. slotIndex .. " deleted."
					)
				end
			)
		end
	end

	function studio.BuildKeyboardShortcuts()
		studio.Paragraph(
			"Help",
			"StudioShortcuts",
			"Studio keyboard shortcuts",
			"When Studio is visible and no text field is focused: Ctrl+Z undoes, Ctrl+Y redoes, and Escape hides Studio. Processed input is ignored. The dashboard shortcut remains separate.",
			148
		)
		connect(
			UserInputService.InputBegan,
			function(input: InputObject, processed: boolean)
				if
					processed
					or not studio.Window
					or not studio.Window.Visible
				then
					return
				end
				if UserInputService:GetFocusedTextBox() then
					return
				end
				if input.KeyCode == Enum.KeyCode.Escape then
					portal.Play(studio.Window, false)
					return
				end
				local control = UserInputService:IsKeyDown(
					Enum.KeyCode.LeftControl
				) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
				if not control then
					return
				end
				if input.KeyCode == Enum.KeyCode.Z then
					studio.TravelHistory(true)
				elseif input.KeyCode == Enum.KeyCode.Y then
					studio.TravelHistory(false)
				end
			end
		)
	end

	studio.Guide = {
		{
			Key = "Welcome",
			Title = "A workspace, not a framework dependency",
			Body = "Design Studio edits the GUI already running in your PlayerGui. It uses Roblox UI primitives and built-in fonts. There are no hidden asset downloads, keys, or third-party UI libraries.",
			Height = 148,
		},
		{
			Key = "Navigation",
			Title = "Categories and search",
			Body = "Drag the header to move this window. Swipe the category strip horizontally on narrow phones. Search filters the current category by plain text; characters such as brackets and dots are not interpreted as patterns.",
			Height = 156,
		},
		{
			Key = "SafeAreas",
			Title = "Why a preferred size may look different",
			Body = "Width, height, and scale are preferences. The safe-area layout limits their effective size so controls stay reachable. Phone notches, top bars, orientation, and short landscape screens can reduce the available space.",
			Height = 156,
		},
		{
			Key = "Resize",
			Title = "Resize the main dashboard",
			Body = "After Load, drag the diagonal grip at the bottom-right of the dashboard with a mouse or finger. Window locking disables the grip. Preferred width and height update together; Studio can undo a completed resize after it has been opened.",
			Height = 164,
		},
		{
			Key = "Colors",
			Title = "Preset accents and custom RGB",
			Body = "Choose an accent preset or enable custom RGB. Channels remain in the standard 0–255 range. Selecting a named accent turns custom RGB off but keeps its stored channel values for later use.",
			Height = 148,
		},
		{
			Key = "Opacity",
			Title = "Readable transparency",
			Body = "Window opacity affects backgrounds, not text. Controls keep their own surfaces so labels remain legible against gameplay. The launcher has a separate opacity preference. Increasing transparency can reduce contrast in bright scenes.",
			Height = 156,
		},
		{
			Key = "Typography",
			Title = "Fonts and text scaling",
			Body = "Body fonts are built into Roblox. Keep technical text monospace to preserve the visual rhythm of coordinates and FPS. Large text may wrap; if a narrow label feels cramped, use a wider panel or reduce text scale.",
			Height = 156,
		},
		{
			Key = "Accessibility",
			Title = "Readability without relying on color",
			Body = "Brighter secondary text increases muted-label contrast. Focus outlines highlight selected Studio controls. The main switches keep ON/OFF labels, bookmark slots show EMPTY/SAVED, and large targets increase Studio button height.",
			Height = 164,
		},
		{
			Key = "Motion",
			Title = "Reduced motion has priority",
			Body = "Enabling reduced motion turns the glitch title off and makes future tweens immediate. Turn reduced motion off before enabling glitches again. Transition duration changes animations only; it never adds a loading delay.",
			Height = 156,
		},
		{
			Key = "Profiles",
			Title = "Recipes versus saved design slots",
			Body = "Recipes modify a specific subset of settings. A saved design slot stores the complete current appearance. Design slots are independent of teleport bookmarks and last only for the current running loader.",
			Height = 148,
		},
		{
			Key = "Undo",
			Title = "Bounded undo and redo",
			Body = "Studio retains at most 24 appearance snapshots. Undo restores one snapshot; redo reapplies it. A new successful Studio edit clears redo. Window dragging and utility activation are not appearance history entries.",
			Height = 156,
		},
		{
			Key = "Import",
			Title = "Settings data, never executable code",
			Body = "Import accepts a versioned JSON object up to 8192 bytes. Only known settings with valid types, choices, and ranges are accepted. It does not call loadstring, fetch URLs, execute functions, or import locations.",
			Height = 164,
		},
		{
			Key = "Persistence",
			Title = "What survives closing a window",
			Body = "Closing Studio hides its window and preserves its controls, history, and design slots for this run. Closing the main loader destroys everything. Copy exported JSON manually if you want to keep a design for a later run.",
			Height = 156,
		},
		{
			Key = "Performance",
			Title = "Update frequency and cost",
			Body = "FPS samples count real rendered frames. Smaller sample windows react faster but fluctuate more. Coordinate sampling also updates distance and the session label. No GUI objects are created by the frame-sampling callbacks.",
			Height = 156,
		},
		{
			Key = "Recovery",
			Title = "Recovering a busy layout",
			Body = "The dock remains draggable when windows are locked. Use the Session page or Layout recovery action to recenter windows. On small screens, arrangements may overlap; drag, hide, or close a utility to free space.",
			Height = 156,
		},
		{
			Key = "Runtime",
			Title = "Executor and Studio limits",
			Body = "The full script can run as a normal Studio LocalScript without an executor. External runtime compatibility depends on that runtime and the experience. Visuals, real touch input, and server acceptance of movement still require device testing.",
			Height = 164,
		},
	}

	function studio.BuildHelp()
		for _, guide in ipairs(studio.Guide) do
			studio.Paragraph(
				"Help",
				"Guide_" .. guide.Key,
				guide.Title,
				guide.Body,
				guide.Height
			)
		end
	end

	function studio.BuildCategoryResets()
		for _, pageName in ipairs({ "Color", "Type", "Layout", "Motion" }) do
			local category = pageName
			studio.Action(
				category,
				"ResetCategory_" .. category,
				"Reset " .. category .. " preferences",
				"Reset only this category. The change can be undone.",
				"Reset " .. category,
				function()
					local patch = {}
					for _, field in ipairs(studio.Schema) do
						if field.Page == category then
							patch[field.Key] = field.Default
						end
					end
					studio.Apply(patch, category .. " preferences reset.")
				end
			)
		end
	end

	function studio.Build()
		if studio.Built then
			return
		end
		studio.ReadRuntime()
		studio.BuildWindow()
		studio.BuildColorPreview()
		studio.BuildColorTools()
		studio.BuildHexInput()
		studio.BuildContrastReadout()
		studio.BuildTypographyPreview()
		for _, field in ipairs(studio.Schema) do
			if field.Kind == "number" then
				studio.NumberField(field)
			elseif field.Kind == "choice" then
				studio.ChoiceField(field)
			elseif field.Kind == "toggle" then
				studio.ToggleField(field)
			end
		end
		studio.BuildLayoutMap()
		studio.BuildArrangements()
		studio.BuildMotionRecipes()
		studio.BuildPresetLibrary()
		studio.BuildMemorySlots()
		studio.BuildTransfer()
		studio.BuildInspector()
		studio.BuildHelp()
		studio.BuildDiagnostics()
		studio.BuildSlotManagement()
		studio.BuildKeyboardShortcuts()
		studio.BuildCategoryResets()
		studio.Built = true
		studio.CaptureStyles()
		studio.Render(studio.Settings)
		studio.UpdateHistoryButtons()
		studio.Select("Color")
	end

	-- Mirror quick controls after the editor exists, without recursive updates.
	studioBridge.Sync = function()
		if not studio.Built or studio.Applying or studio.Synchronizing then
			return
		end
		studio.Synchronizing = true
		if CONFIG.ReducedMotion and glitchEnabled then
			setGlitchEnabled(false)
		end
		local previous = studio.Copy(studio.Settings)
		studio.ReadRuntime()
		local nextValues = studio.Copy(studio.Settings)
		studio.Settings = previous
		studio.Synchronizing = false
		if not studio.Same(previous, nextValues) then
			studio.Apply(nextValues, "Quick style controls updated.")
		end
	end

	function studio.Open()
		if not alive then
			return
		end
		studio.Build()
		studio.ReadRuntime()
		studio.Render(studio.Settings)
		studio.Relayout()
		portal.Play(studio.Window, true)
		studio.Select(
			if studio.Settings.RestorePage then studio.ActivePage else "Color"
		)
		studio.Message("Design Studio ready. Changes stay local to this run.")
	end

	studioBridge.Look = function(name: string)
		for _, preset in ipairs(studio.Presets) do
			if preset.Name == name then
				studio.Build()
				studio.Apply(preset.Values, name .. " signature look applied.")
				return
			end
		end
	end
	studioBridge.Font = function(name: string)
		if studio.Fonts[name] then
			studio.Build()
			studio.Apply(
				{ Font = name },
				name .. " type style applied. Body text stays readable."
			)
		end
	end
	studioBridge.ForgetUI = function(target: Instance)
		studio.StyleCache[target] = nil
		for _, object in ipairs(target:GetDescendants()) do
			studio.StyleCache[object] = nil
		end
	end
	studioBridge.RegisterUI = function()
		if studio.Built and alive then
			studio.CaptureStyles()
			studio.Render(studio.Settings)
		end
	end
	studioBridge.Open = studio.Open
	studioBridge.Resized = function(width: number, height: number)
		if not studio.Built then
			return
		end
		studio.Apply({
			Width = math.floor(width + 0.5),
			Height = math.floor(height + 0.5),
		}, "Dashboard resized.")
	end
	studioBridge.Destroy = function()
		studio.Built = false
		studio.Window = nil
		table.clear(studio.StyleCache)
		table.clear(studio.Refreshers)
		table.clear(studio.FocusStrokes)
		table.clear(studio.Pages)
		table.clear(studio.Rows)
		table.clear(studio.UndoStack)
		table.clear(studio.RedoStack)
		table.clear(studio.Saved)
	end
end

-- Local player tools. No remote events, automatic firing, or server modifications.
do
	local toolsState: { [string]: any } = {
		Visuals = false,
		Chams = true,
		Boxes = true,
		Lines = false,
		Names = true,
		Health = true,
		Distance = true,
		ThroughWalls = false,
		VisualTeamCheck = true,
		VisualDistance = 1000,
		VisualColor = "Violet",
		VisualRate = 30,
		Aim = false,
		Activation = "Auto",
		ScriptedCamera = false,
		Circle = false,
		Radius = 140,
		Strength = 50,
		AimDistance = 1000,
		AimTeamCheck = true,
		AimPart = "Head",
		CircleColor = "Violet",
		TouchPad = true,
	}
	local engine: { [string]: any } = {
		Workspace = game:GetService("Workspace"),
		Records = {},
		Highlights = {},
		Windows = {},
		Setters = {},
		Bound = false,
		BindName = "Nullx11_PlayerTools",
		VisualClock = 0,
		MouseHeld = false,
		TouchInput = nil,
		MaxOverlays = 32,
		MaxHighlights = 24,
		MaxVisualRays = 48,
		Palette = {
			Violet = Color3.fromRGB(167, 146, 255),
			Mint = Color3.fromRGB(126, 222, 185),
			Cyan = Color3.fromRGB(108, 221, 225),
			Red = Color3.fromRGB(255, 133, 145),
			White = Color3.fromRGB(242, 241, 249),
		},
	}

	function engine.Status(windowName: string, message: string)
		local window = engine.Windows[windowName]
		if window and window.Status.Text ~= message then
			window.Status.Text = message
		end
	end

	function engine.Hide(record: any)
		if record.Box then
			record.Box.Visible = false
			record.Line.Visible = false
			record.NameLabel.Visible = false
			record.HealthBar.Visible = false
		end
		if record.Highlight then
			record.Highlight.Enabled = false
		end
	end

	function engine.Remove(other: Player)
		local record = engine.Records[other]
		if not record then
			return
		end
		if record.Container then
			record.Container:Destroy()
		end
		if record.Highlight then
			record.Highlight.Enabled = false
			record.Highlight.Adornee = nil
		end
		engine.Records[other] = nil
	end

	function engine.EnsureOverlay()
		if engine.Overlay then
			return
		end
		engine.Overlay = create("ScreenGui", {
			Name = "Nullx11PlayerOverlay",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ScreenInsets = Enum.ScreenInsets.None,
			DisplayOrder = 90,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, playerGui)
		engine.HighlightFolder = create(
			"Folder",
			{ Name = "Nullx11HighlightPool" },
			engine.Workspace
		)
		engine.Circle = create("Frame", {
			Name = "AimFOVCircle",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
		}, engine.Overlay)
		create("UICorner", { CornerRadius = UDim.new(1, 0) }, engine.Circle)
		engine.CircleStroke = create("UIStroke", {
			Color = engine.Palette.Violet,
			Thickness = 1.5,
			Transparency = 0.15,
		}, engine.Circle)
	end

	function engine.EnsureRecord(record: any)
		if record.Container then
			return
		end
		engine.EnsureOverlay()
		record.Container = create("Frame", {
			Name = "PlayerOverlay_" .. tostring(record.Player.UserId),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, engine.Overlay)
		record.Box = create("Frame", {
			Name = "PlayerBox",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
		}, record.Container)
		record.BoxStroke = create("UIStroke", {
			Color = engine.Palette.Violet,
			Thickness = 1.25,
		}, record.Box)
		record.Line = create("Frame", {
			Name = "PlayerTracer",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Visible = false,
		}, record.Container)
		record.NameLabel = label(record.Container, "", 12, colors.Text)
		record.NameLabel.Name = "PlayerTag"
		record.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
		record.NameLabel.TextStrokeTransparency = 0.35
		record.NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		record.NameLabel.Visible = false
		record.HealthBar = create("Frame", {
			Name = "PlayerHealth",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Visible = false,
		}, record.Container)
		record.HealthFill = create("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			BackgroundColor3 = colors.Success,
			BorderSizePixel = 0,
		}, record.HealthBar)
	end

	function engine.Finite(value: number): boolean
		return value == value and math.abs(value) < math.huge
	end

	function engine.PositionValid(position: Vector3): boolean
		return engine.Finite(position.X)
			and engine.Finite(position.Y)
			and engine.Finite(position.Z)
	end

	function engine.Character(other: Player, teamCheck: boolean): any
		if other == player then
			return nil
		end
		if
			teamCheck
			and not player.Neutral
			and not other.Neutral
			and player.Team ~= nil
			and player.Team == other.Team
		then
			return nil
		end
		local character = other.Character
		if not character or not character.Parent then
			return nil
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local part = character:FindFirstChild("HumanoidRootPart")
			or character.PrimaryPart
			or character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
		if
			not humanoid
			or humanoid.Health <= 0
			or not part
			or not part:IsA("BasePart")
		then
			return nil
		end
		if
			not engine.Finite(humanoid.Health)
			or not engine.Finite(humanoid.MaxHealth)
			or not engine.PositionValid(part.Position)
		then
			return nil
		end
		return { Model = character, Humanoid = humanoid, Root = part }
	end

	function engine.Visible(
		camera: Camera,
		model: Model,
		position: Vector3
	): boolean
		if not engine.RayParams then
			engine.RayParams = RaycastParams.new()
			engine.RayParams.FilterType = Enum.RaycastFilterType.Exclude
			engine.RayParams.IgnoreWater = true
		end
		engine.RayParams.FilterDescendantsInstances = if player.Character
			then { player.Character, camera }
			else { camera }
		local origin = camera.CFrame.Position
		local result = engine.Workspace:Raycast(
			origin,
			position - origin,
			engine.RayParams
		)
		return result == nil or result.Instance:IsDescendantOf(model)
	end

	function engine.Bounds(camera: Camera, model: Model): any
		local ok, transform, size = pcall(model.GetBoundingBox, model)
		if not ok or not engine.PositionValid(size) then
			return nil
		end
		local minimumX, minimumY = math.huge, math.huge
		local maximumX, maximumY = -math.huge, -math.huge
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local point = transform:PointToWorldSpace(
						Vector3.new(
							size.X * x / 2,
							size.Y * y / 2,
							size.Z * z / 2
						)
					)
					local projected = camera:WorldToViewportPoint(point)
					-- Never stretch a box across the camera's near plane.
					if
						not engine.PositionValid(projected)
						or projected.Z <= 0.1
					then
						return nil
					end
					minimumX = math.min(minimumX, projected.X)
					minimumY = math.min(minimumY, projected.Y)
					maximumX = math.max(maximumX, projected.X)
					maximumY = math.max(maximumY, projected.Y)
				end
			end
		end
		local viewport = camera.ViewportSize
		minimumX = math.clamp(minimumX, 0, viewport.X)
		minimumY = math.clamp(minimumY, 0, viewport.Y)
		maximumX = math.clamp(maximumX, 0, viewport.X)
		maximumY = math.clamp(maximumY, 0, viewport.Y)
		if maximumX - minimumX < 2 or maximumY - minimumY < 2 then
			return nil
		end
		return {
			X = minimumX,
			Y = minimumY,
			Width = maximumX - minimumX,
			Height = maximumY - minimumY,
		}
	end

	function engine.Draw(
		record: any,
		info: any,
		camera: Camera,
		distance: number,
		index: number
	)
		local ink = engine.Palette[toolsState.VisualColor]
		local box = engine.Bounds(camera, info.Model)
		if not box then
			engine.Hide(record)
			return false
		end
		engine.EnsureRecord(record)
		record.Box.Position = UDim2.fromOffset(box.X, box.Y)
		record.Box.Size = UDim2.fromOffset(box.Width, box.Height)
		record.Box.Visible = toolsState.Boxes
		record.BoxStroke.Color = ink
		local rootPosition = camera:WorldToViewportPoint(info.Root.Position)
		local start =
			Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y - 8)
		local finish = Vector2.new(rootPosition.X, rootPosition.Y)
		local delta = finish - start
		record.Line.Position =
			UDim2.fromOffset((start.X + finish.X) / 2, (start.Y + finish.Y) / 2)
		record.Line.Size = UDim2.fromOffset(delta.Magnitude, 1.5)
		record.Line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		record.Line.BackgroundColor3 = ink
		record.Line.Visible = toolsState.Lines
		local caption = if toolsState.Names
			then record.Player.DisplayName
			else ""
		if toolsState.Distance then
			caption ..= string.format("  %.0f st", distance)
		end
		record.NameLabel.Text = caption
		record.NameLabel.Position =
			UDim2.fromOffset(box.X - 40, math.max(0, box.Y - 20))
		record.NameLabel.Size = UDim2.fromOffset(box.Width + 80, 18)
		record.NameLabel.TextColor3 = ink
		record.NameLabel.Visible = toolsState.Names or toolsState.Distance
		record.HealthBar.Position =
			UDim2.fromOffset(math.max(0, box.X - 6), box.Y)
		record.HealthBar.Size = UDim2.fromOffset(3, box.Height)
		record.HealthBar.Visible = toolsState.Health
		local fraction = math.clamp(
			info.Humanoid.Health / math.max(1, info.Humanoid.MaxHealth),
			0,
			1
		)
		record.HealthFill.Size = UDim2.fromScale(1, fraction)
		record.HealthFill.BackgroundColor3 = if fraction < 0.3
			then colors.Error
			else colors.Success
		if toolsState.Chams and index <= engine.MaxHighlights then
			if not engine.Highlights[index] then
				engine.Highlights[index] = create(
					"Highlight",
					{ Name = "Nullx11Chams" .. index },
					engine.HighlightFolder
				)
			end
			record.Highlight = engine.Highlights[index]
			record.Highlight.Adornee = info.Model
			record.Highlight.FillColor = ink
			record.Highlight.OutlineColor = ink
			record.Highlight.FillTransparency = 0.65
			record.Highlight.OutlineTransparency = 0.1
			record.Highlight.DepthMode = if toolsState.ThroughWalls
				then Enum.HighlightDepthMode.AlwaysOnTop
				else Enum.HighlightDepthMode.Occluded
			record.Highlight.Enabled = true
		end
		return true
	end

	function engine.ClearHighlights()
		for _, highlight in pairs(engine.Highlights) do
			highlight.Enabled = false
			highlight:Destroy()
		end
		table.clear(engine.Highlights)
		for _, record in pairs(engine.Records) do
			record.Highlight = nil
		end
	end

	function engine.UpdateVisuals(camera: Camera)
		local candidates = {}
		for _, highlight in pairs(engine.Highlights) do
			highlight.Enabled = false
			highlight.Adornee = nil
		end
		for _, record in pairs(engine.Records) do
			engine.Hide(record)
			record.Highlight = nil
			local info =
				engine.Character(record.Player, toolsState.VisualTeamCheck)
			if not info then
				continue
			end
			local distance = (info.Root.Position - camera.CFrame.Position).Magnitude
			local projected, onScreen =
				camera:WorldToViewportPoint(info.Root.Position)
			if
				distance <= toolsState.VisualDistance
				and onScreen
				and projected.Z > 0
			then
				table.insert(
					candidates,
					{ Record = record, Info = info, Distance = distance }
				)
			end
		end
		table.sort(candidates, function(a, b)
			return a.Distance < b.Distance
		end)
		local shown = 0
		local tested = 0
		for _, entry in ipairs(candidates) do
			if shown >= engine.MaxOverlays then
				break
			end
			if not toolsState.ThroughWalls then
				if tested >= engine.MaxVisualRays then
					break
				end
				tested += 1
			end
			if
				not toolsState.ThroughWalls
				and not engine.Visible(
					camera,
					entry.Info.Model,
					entry.Info.Root.Position
				)
			then
				continue
			end
			if
				engine.Draw(
					entry.Record,
					entry.Info,
					camera,
					entry.Distance,
					shown + 1
				)
			then
				shown += 1
			end
		end
		engine.Status(
			"Visuals",
			string.format(
				"Visuals ON / %d players / %d Hz",
				shown,
				toolsState.VisualRate
			)
		)
	end

	function engine.SelectTarget(camera: Camera): any
		local center = camera.ViewportSize / 2
		local candidates = {}
		local scan =
			{ Players = 0, Filtered = 0, Range = 0, FOV = 0, Blocked = 0 }
		engine.LastScan = scan
		for _, record in pairs(engine.Records) do
			scan.Players += 1
			local info =
				engine.Character(record.Player, toolsState.AimTeamCheck)
			if not info then
				scan.Filtered += 1
				continue
			end
			local part = if toolsState.AimPart == "Head"
				then info.Model:FindFirstChild("Head")
				else info.Root
			if not part or not part:IsA("BasePart") then
				part = info.Root
			end
			if not engine.PositionValid(part.Position) then
				continue
			end
			local distance = (part.Position - camera.CFrame.Position).Magnitude
			if distance < 0.01 or distance > toolsState.AimDistance then
				scan.Range += 1
				continue
			end
			local projected, onScreen =
				camera:WorldToViewportPoint(part.Position)
			if not onScreen or projected.Z <= 0 then
				scan.FOV += 1
				continue
			end
			local score = (Vector2.new(projected.X, projected.Y) - center).Magnitude
			if score > toolsState.Radius then
				scan.FOV += 1
			end
			if score <= toolsState.Radius then
				table.insert(candidates, {
					Score = score,
					Part = part,
					Model = info.Model,
					Player = record.Player,
				})
			end
		end
		table.sort(candidates, function(a, b)
			return a.Score < b.Score
		end)
		-- Bound expensive ray tests even on large servers.
		for index = 1, math.min(8, #candidates) do
			local candidate = candidates[index]
			if
				engine.Visible(camera, candidate.Model, candidate.Part.Position)
			then
				return candidate
			end
			scan.Blocked += 1
		end
		return nil
	end

	function engine.Step(dt: number)
		local camera = engine.Workspace.CurrentCamera
		if
			not camera
			or camera.ViewportSize.X <= 0
			or camera.ViewportSize.Y <= 0
			or not engine.PositionValid(camera.CFrame.Position)
		then
			for _, record in pairs(engine.Records) do
				engine.Hide(record)
			end
			if engine.Circle then
				engine.Circle.Visible = false
			end
			engine.Status("Aim", "Waiting for a camera.")
			return
		end
		if toolsState.Circle then
			engine.EnsureOverlay()
			engine.Circle.Position = UDim2.fromOffset(
				camera.ViewportSize.X / 2,
				camera.ViewportSize.Y / 2
			)
			engine.Circle.Size =
				UDim2.fromOffset(toolsState.Radius * 2, toolsState.Radius * 2)
			engine.CircleStroke.Color = engine.Palette[toolsState.CircleColor]
			engine.Circle.Visible = true
		end
		engine.UpdateAim(camera, dt)
		if toolsState.Visuals then
			engine.VisualClock += dt
			if engine.VisualClock >= 1 / toolsState.VisualRate then
				engine.VisualClock = 0
				engine.UpdateVisuals(camera)
			end
		end
	end

	function engine.UpdateAim(camera: Camera, dt: number)
		if not toolsState.Aim then
			return
		end
		if UserInputService:GetFocusedTextBox() then
			engine.Status("Aim", "Paused while typing.")
			return
		end
		if
			toolsState.Activation == "Hold"
			and not engine.MouseHeld
			and not engine.TouchInput
		then
			engine.Status(
				"Aim",
				"Hold RMB / touch AIM. Move panels off-center."
			)
			return
		end
		if
			camera.CameraType == Enum.CameraType.Scriptable
			and not toolsState.ScriptedCamera
		then
			engine.Status(
				"Aim",
				"Scripted camera / enable camera override if intended."
			)
			return
		end
		local character = player.Character
		local humanoid = if character
			then character:FindFirstChildOfClass("Humanoid")
			else nil
		local rootPart = if character
			then character:FindFirstChild("HumanoidRootPart")
				or character.PrimaryPart
				or character:FindFirstChild("UpperTorso")
				or character:FindFirstChild("Torso")
			else nil
		if
			not character
			or not character.Parent
			or not humanoid
			or humanoid.Health <= 0
			or not engine.Finite(humanoid.Health)
			or not rootPart
			or not rootPart:IsA("BasePart")
		then
			engine.Status("Aim", "Wait for your character to spawn.")
			return
		end
		local target = engine.SelectTarget(camera)
		if not target then
			local scan = engine.LastScan or {}
			engine.Status(
				"Aim",
				string.format(
					"No target / %d players / %d team or rig / %d FOV / %d blocked",
					scan.Players or 0,
					scan.Filtered or 0,
					scan.FOV or 0,
					scan.Blocked or 0
				)
			)
			return
		end
		local alpha = if toolsState.Strength >= 100
			then 1
			else 1 - math.exp(
				-(2 + toolsState.Strength * 0.7) * math.min(dt, 0.1)
			)
		local desired =
			CFrame.lookAt(camera.CFrame.Position, target.Part.Position)
		camera.CFrame = camera.CFrame:Lerp(desired, alpha)
		engine.Status(
			"Aim",
			"Tracking "
				.. target.Player.DisplayName
				.. " / "
				.. toolsState.Strength
				.. "%"
		)
	end

	function engine.SafeStep(dt: number)
		local ok, reason = pcall(engine.Step, dt)
		if not ok then
			engine.DisableAll()
			engine.Status(
				"Aim",
				"Runtime error / " .. string.sub(tostring(reason), 1, 110)
			)
			engine.Status("Visuals", "Runtime error / see console.")
			warn("[Nullx11 player tools] " .. tostring(reason))
		end
	end
	function engine.Schedule()
		local needed = toolsState.Visuals or toolsState.Aim or toolsState.Circle
		if needed and not engine.Bound then
			local ok, reason = pcall(function()
				RunService:BindToRenderStep(
					engine.BindName,
					Enum.RenderPriority.Last.Value - 1,
					engine.SafeStep
				)
			end)
			if ok then
				engine.Backend = "late camera binding"
			else
				engine.Fallback =
					RunService.RenderStepped:Connect(engine.SafeStep)
				engine.Backend = "RenderStepped fallback"
				warn(
					"[Nullx11] Camera binding failed; using RenderStepped: "
						.. tostring(reason)
				)
			end
			engine.Bound = true
		elseif not needed and engine.Bound then
			if engine.Fallback then
				engine.Fallback:Disconnect()
				engine.Fallback = nil
			else
				RunService:UnbindFromRenderStep(engine.BindName)
			end
			engine.Bound = false
			engine.Backend = "renderer idle"
		end

		if not toolsState.Visuals then
			engine.ClearHighlights()
			for _, record in pairs(engine.Records) do
				engine.Hide(record)
			end
			engine.Status("Visuals", "Visuals OFF / enable to draw players.")
		end
		if not toolsState.Chams then
			engine.ClearHighlights()
		end
		if not toolsState.Circle and engine.Circle then
			engine.Circle.Visible = false
		end
		if not toolsState.Aim then
			engine.MouseHeld = false
			engine.TouchInput = nil
			engine.Status(
				"Aim",
				if toolsState.Circle
					then "FOV preview on / move panels away from center."
					else "Aim OFF / camera untouched."
			)
		end
		if not toolsState.TouchPad then
			engine.TouchInput = nil
		end
		if engine.TouchPad then
			local hold = engine.TouchPad:FindFirstChild("HoldMobileAim")
			if hold then
				hold.Text = if toolsState.Activation == "Auto"
					then "STOP AUTO"
					else "HOLD AIM"
			end
			engine.TouchPad.Visible = toolsState.Aim and toolsState.TouchPad
		end
	end

	function engine.DisableAll()
		for _, key in ipairs({ "Visuals", "Aim", "Circle" }) do
			toolsState[key] = false
			if engine.Setters[key] then
				engine.Setters[key](false)
			end
		end
		engine.MouseHeld = false
		engine.TouchInput = nil
		engine.Schedule()
	end

	function engine.Window(name: string): any
		local window = { Kind = name }
		window.Panel = create("Frame", {
			Name = name .. "Window",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(390, 540),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			Visible = false,
		}, root)
		corner(window.Panel, 16)
		create(
			"UIStroke",
			{ Color = colors.Border, Thickness = 1 },
			window.Panel
		)
		local handle = create("Frame", {
			Name = name .. "DragHandle",
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, -64, 0, 64),
		}, window.Panel)
		drawIcon(handle, CONFIG.Accent, UDim2.fromOffset(18, 20), 26)
		local heading = label(
			handle,
			string.upper(name)
				.. (if name == "Scripts" then " / LIBRARY" else " / LOCAL"),
			18,
			colors.Text
		)
		heading.Font = Enum.Font.Code
		heading.Position = UDim2.fromOffset(56, 20)
		heading.Size = UDim2.new(1, -56, 0, 28)
		local hide = create("TextButton", {
			Name = "Hide" .. name,
			Text = "−",
			TextSize = 22,
			Font = Enum.Font.Code,
			TextColor3 = colors.Muted,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -56, 0, 12),
			Size = UDim2.fromOffset(44, 44),
		}, window.Panel)
		connect(hide.Activated, function()
			engine.WindowSetters[name](false)
		end)
		window.Body = create("ScrollingFrame", {
			Name = name .. "Controls",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(16, 72),
			Size = UDim2.new(1, -32, 1, -128),
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, window.Panel)
		window.Status = label(window.Panel, name .. " OFF", 10, colors.Muted)
		window.Status.Name = name .. "Status"
		window.Status.Position = UDim2.new(0, 16, 1, -44)
		window.Status.Size = UDim2.new(1, -32, 0, 32)
		window.Status.TextWrapped = true
		window.Cursor = 0
		engine.Windows[name] = window
		draggable(handle, window.Panel)
		return window
	end

	function engine.Toggle(
		window: any,
		key: string,
		title: string,
		hint: string
	)
		engine.Setters[key] = toggleRow(
			title,
			hint,
			window.Cursor,
			toolsState[key],
			function(value)
				toolsState[key] = value
				if key == "Aim" and value and engine.Setters.Circle then
					engine.Setters.Circle(true)
				end
				engine.Schedule()
			end,
			window.Body
		)
		window.Cursor += 58
	end

	function engine.Button(
		window: any,
		name: string,
		caption: string,
		callback: () -> ()
	)
		local button = create("TextButton", {
			Name = name,
			Text = caption,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Position = UDim2.fromOffset(0, window.Cursor),
			Size = UDim2.new(1, -4, 0, 44),
		}, window.Body)
		corner(button, 10)
		connect(button.Activated, callback)
		window.Cursor += 52
		return button
	end

	function engine.Number(
		window: any,
		key: string,
		title: string,
		minimum: number,
		maximum: number,
		step: number
	)
		local heading = label(window.Body, title, 11, colors.Muted)
		heading.Position = UDim2.fromOffset(0, window.Cursor)
		heading.Size = UDim2.new(1, -4, 0, 22)
		local box = create("TextBox", {
			Name = "Value" .. key,
			Text = tostring(toolsState[key]),
			ClearTextOnFocus = false,
			MultiLine = false,
			Font = Enum.Font.Code,
			TextSize = 14,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, window.Cursor + 24),
			Size = UDim2.new(1, -116, 0, 44),
		}, window.Body)
		corner(box, 9)
		engine.NumberRefresh = engine.NumberRefresh or {}
		engine.NumberRefresh[key] = function()
			box.Text = tostring(toolsState[key])
		end
		connect(box.FocusLost, function()
			local value = tonumber(box.Text)
			if
				not value
				or value ~= value
				or value % 1 ~= 0
				or value < minimum
				or value > maximum
			then
				engine.Status(
					window.Kind,
					string.format(
						"Enter a whole number from %d to %d.",
						minimum,
						maximum
					)
				)
			else
				toolsState[key] = value
				engine.Schedule()
			end
			engine.NumberRefresh[key]()
		end)
		for _, direction in ipairs({ -1, 1 }) do
			local change = direction
			local button = create("TextButton", {
				Name = (if change < 0 then "Decrease" else "Cycle") .. key,
				Text = if change < 0 then "−" else "+",
				TextSize = 20,
				Font = Enum.Font.Code,
				TextColor3 = colors.Text,
				BackgroundColor3 = colors.Surface,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Position = UDim2.new(
					1,
					if change < 0 then -104 else -48,
					0,
					window.Cursor + 24
				),
				Size = UDim2.fromOffset(44, 44),
			}, window.Body)
			corner(button, 9)
			connect(button.Activated, function()
				toolsState[key] = math.clamp(
					toolsState[key] + change * step,
					minimum,
					maximum
				)
				engine.NumberRefresh[key]()
			end)
		end
		window.Cursor += 80
	end

	function engine.Color(window: any, key: string, title: string)
		local names = { "Violet", "Mint", "Cyan", "Red", "White" }
		local button: TextButton? = nil
		button = engine.Button(
			window,
			"Cycle" .. key,
			title .. ": " .. toolsState[key],
			function()
				local current = table.find(names, toolsState[key]) or 1
				toolsState[key] = names[current % #names + 1]
				if button then
					button.Text = title .. ": " .. toolsState[key]
					button.TextColor3 = engine.Palette[toolsState[key]]
				end
			end
		)
	end

	function engine.RuntimeReport()
		local camera = engine.Workspace.CurrentCamera
		local char = player.Character
		local humanoid = if char
			then char:FindFirstChildOfClass("Humanoid")
			else nil
		local rootPart = if char
			then char:FindFirstChild("HumanoidRootPart")
				or char.PrimaryPart
				or char:FindFirstChild("UpperTorso")
				or char:FindFirstChild("Torso")
			else nil
		local ready = char
			and char.Parent
			and humanoid
			and humanoid.Health > 0
			and rootPart
			and rootPart:IsA("BasePart")
		local others = math.max(0, #Players:GetPlayers() - 1)
		local message = string.format(
			"LIVE / %d other players / local avatar %s / camera %s / %s / %s mode",
			others,
			if ready then "ready" else "not ready",
			if camera then tostring(camera.CameraType) else "missing",
			engine.Backend or "renderer idle",
			toolsState.Activation
		)
		if others == 0 then
			message ..= ". Other players are required; NPCs are not targets."
		end
		for _, name in ipairs({ "Aim", "Visuals" }) do
			local window = engine.Windows[name]
			if window and window.Diagnostics then
				window.Diagnostics.Text = message
			end
		end
		engine.Status("Aim", message)
		engine.Status("Visuals", message)
		warn("[Nullx11 live runtime report] " .. message)
	end
	function engine.Diagnostics(window: any, id: string)
		engine.Button(
			window,
			id,
			"Check live Roblox state",
			engine.RuntimeReport
		)
		window.Diagnostics = label(
			window.Body,
			"Live checks use the current Roblox services, not simulated targets. Tap Check to inspect avatar, camera, player count, and renderer.",
			14,
			colors.Muted
		)
		window.Diagnostics.Name = window.Kind .. "RuntimeDetails"
		window.Diagnostics.Position = UDim2.fromOffset(4, window.Cursor)
		window.Diagnostics.Size = UDim2.new(1, -12, 0, 132)
		window.Diagnostics.TextWrapped = true
		window.Cursor += 144
	end

	function engine.BuildVisuals()
		if engine.Windows.Visuals then
			return
		end
		local window = engine.Window("Visuals")
		engine.Button(
			window,
			"VisualsDisableAll",
			"Disable visuals, aim, and circle",
			engine.DisableAll
		)
		engine.Toggle(
			window,
			"Visuals",
			"Enable visuals",
			"Off by default / nearest 32 on-screen players"
		)
		engine.Toggle(
			window,
			"Chams",
			"Player chams",
			"Local highlights / at most 24 active"
		)
		engine.Toggle(
			window,
			"Boxes",
			"Player boxes",
			"Projected character bounding boxes"
		)
		engine.Toggle(
			window,
			"Lines",
			"Tracer lines",
			"Bottom-center to player root"
		)
		engine.Toggle(
			window,
			"Names",
			"Player names",
			"Display names above the box"
		)
		engine.Toggle(window, "Health", "Health bars", "Living characters only")
		engine.Toggle(
			window,
			"Distance",
			"Player distance",
			"Camera distance in studs"
		)
		engine.Toggle(
			window,
			"ThroughWalls",
			"Through walls",
			"Off: require a clear line of sight"
		)
		engine.Toggle(
			window,
			"VisualTeamCheck",
			"Visual team filter",
			"Skip non-neutral teammates"
		)
		engine.Number(
			window,
			"VisualDistance",
			"Visual range (studs)",
			250,
			3000,
			250
		)
		engine.Number(window, "VisualRate", "Overlay rate (Hz)", 15, 60, 15)
		engine.Color(window, "VisualColor", "Overlay color")
		engine.Diagnostics(window, "CheckVisualsRuntime")
		window.Body.CanvasSize = UDim2.fromOffset(0, window.Cursor)
		if studioBridge.RegisterUI then
			studioBridge.RegisterUI()
		end
	end

	function engine.BuildAim()
		if engine.Windows.Aim then
			return
		end
		local window = engine.Window("Aim")
		engine.Button(
			window,
			"AimDisableAll",
			"Disable visuals, aim, and circle",
			engine.DisableAll
		)
		engine.Toggle(
			window,
			"Aim",
			"Enable aim assist",
			"Auto tracks immediately / Hold mode is optional"
		)
		engine.Toggle(
			window,
			"Circle",
			"Show FOV circle",
			"Pixels around the center of the viewport"
		)
		local activation: TextButton? = nil
		activation = engine.Button(
			window,
			"CycleAimActivation",
			"Activation: Auto / enabled = tracking",
			function()
				toolsState.Activation = if toolsState.Activation == "Auto"
					then "Hold"
					else "Auto"
				engine.MouseHeld = false
				engine.TouchInput = nil
				if activation then
					activation.Text = if toolsState.Activation == "Auto"
						then "Activation: Auto / enabled = tracking"
						else "Activation: Hold RMB / AIM pad"
				end
				engine.Schedule()
			end
		)
		engine.Button(
			window,
			"EnterAimView",
			"Play view / fold panels into dock",
			function()
				for _, name in ipairs({
					"Aim",
					"Visuals",
					"Scripts",
					"GameScript",
				}) do
					engine.WindowSetters[name](false)
				end
				setExpanded(false)
			end
		)
		engine.Toggle(
			window,
			"ScriptedCamera",
			"Scripted camera override",
			"Optional / can conflict with game cutscenes"
		)
		engine.Number(window, "Strength", "Aim strength", 1, 100, 1)
		engine.Number(window, "Radius", "FOV radius (px)", 50, 400, 25)
		engine.Number(
			window,
			"AimDistance",
			"Aim range (studs)",
			250,
			3000,
			250
		)
		engine.Toggle(
			window,
			"AimTeamCheck",
			"Aim team filter",
			"Skip non-neutral teammates"
		)
		engine.Toggle(
			window,
			"TouchPad",
			"Mobile aim pad",
			"Separate draggable touch-hold control"
		)
		local part: TextButton? = nil
		part = engine.Button(
			window,
			"CycleAimPart",
			"Target part: " .. toolsState.AimPart,
			function()
				toolsState.AimPart = if toolsState.AimPart == "Head"
					then "Root"
					else "Head"
				if part then
					part.Text = "Target part: " .. toolsState.AimPart
				end
			end
		)
		engine.Color(window, "CircleColor", "FOV circle color")
		engine.Button(
			window,
			"AimStrength100",
			"Set strength to 100 (snap)",
			function()
				toolsState.Strength = 100
				engine.NumberRefresh.Strength()
			end
		)
		engine.Diagnostics(window, "CheckAimRuntime")
		window.Body.CanvasSize = UDim2.fromOffset(0, window.Cursor)
		engine.TouchPad = create("Frame", {
			Name = "MobileAimPad",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(116, 104),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			Visible = false,
		}, root)
		corner(engine.TouchPad, 14)
		local handle = create("Frame", {
			Name = "AimPadDragHandle",
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, 0, 0, 44),
		}, engine.TouchPad)
		local caption = label(handle, "DRAG / AIM", 9, colors.Muted)
		caption.Size = UDim2.fromScale(1, 1)
		caption.TextXAlignment = Enum.TextXAlignment.Center
		local hold = create("TextButton", {
			Name = "HoldMobileAim",
			Text = "HOLD AIM",
			TextSize = 12,
			Font = Enum.Font.GothamBold,
			TextColor3 = colors.Panel,
			BackgroundColor3 = CONFIG.Accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -16, 0, 48),
			Position = UDim2.fromOffset(8, 48),
		}, engine.TouchPad)
		corner(hold, 10)
		connect(hold.InputBegan, function(input: InputObject)
			if
				toolsState.Aim
				and (
					input.UserInputType == Enum.UserInputType.Touch
					or input.UserInputType
						== Enum.UserInputType.MouseButton1
				)
			then
				engine.TouchInput = input
			end
		end)
		connect(hold.Activated, function()
			if toolsState.Activation == "Auto" and engine.Setters.Aim then
				engine.Setters.Aim(false)
			end
		end)
		draggable(handle, engine.TouchPad)
		if studioBridge.RegisterUI then
			studioBridge.RegisterUI()
		end
	end

	engine.WindowSetters = {}
	engine.WindowSetters.Visuals = toggleRow(
		"Visuals window",
		"Chams / boxes / tracer lines",
		232,
		false,
		function(show)
			if show then
				engine.BuildVisuals()
			end
			layout()
			if engine.Windows.Visuals then
				portal.Play(engine.Windows.Visuals.Panel, show)
			end
		end
	)
	engine.WindowSetters.Aim = toggleRow(
		"Aim window",
		"FOV / strength / touch hold",
		290,
		false,
		function(show)
			if show then
				engine.BuildAim()
			end
			layout()
			if engine.Windows.Aim then
				portal.Play(engine.Windows.Aim.Panel, show)
			end
		end
	)
	-- Repository game bundles are seeded at build time; Refresh can replace them.
	local catalog: { [string]: any } =
		{ Entries = {}, Loaded = false, Busy = false, Rows = {}, Confirm = nil }
	catalog.RowConnections = {}
	function catalog.Message(message: string, failed: boolean?)
		if catalog.GameWindow and catalog.GameWindow.Panel.Visible then
			engine.Status("GameScript", message)
		end
		engine.Status("Scripts", message)
		if catalog.Window then
			catalog.Window.Status.TextColor3 = if failed
				then colors.Error
				else colors.Muted
		end
	end
	function catalog.Validate(document: any): { any }
		assert(
			type(document) == "table" and document.Version == 1,
			"Unsupported manifest version"
		)
		local entries = document.Scripts
		assert(
			type(entries) == "table" and #entries <= 64,
			"Manifest needs at most 64 scripts"
		)
		for key in pairs(entries) do
			assert(
				type(key) == "number"
					and key % 1 == 0
					and key >= 1
					and key <= #entries,
				"Scripts must be an array"
			)
		end
		local clean, seen = {}, {}
		for _, entry in ipairs(entries) do
			assert(type(entry) == "table", "Invalid script entry")
			assert(
				type(entry.Id) == "string"
					and #entry.Id > 0
					and #entry.Id <= 48
					and not seen[entry.Id],
				"Script IDs must be unique"
			)
			assert(
				type(entry.Name) == "string"
					and #entry.Name > 0
					and #entry.Name <= 80,
				"Invalid script name"
			)
			assert(
				type(entry.Description) == "string"
					and #entry.Description <= 240,
				"Invalid description"
			)
			if entry.GamePlaceId ~= nil then
				assert(
					type(entry.GamePlaceId) == "number"
						and entry.GamePlaceId > 0
						and entry.GamePlaceId <= 9007199254740991
						and entry.GamePlaceId % 1 == 0,
					"Invalid game place ID"
				)
			end
			if entry.Author ~= nil then
				assert(
					type(entry.Author) == "string" and #entry.Author <= 160,
					"Invalid source credit"
				)
			end
			local file = entry.File
			assert(
				type(file) == "string"
					and #file <= 160
					and string.match(file, "^[%w_/%-%.]+%.luau$")
					and string.sub(file, 1, 1) ~= "/"
					and not string.find(file, "..", 1, true),
				"Use a relative .luau path inside scripts/"
			)
			local places = {}
			if entry.PlaceIds ~= nil then
				assert(
					type(entry.PlaceIds) == "table" and #entry.PlaceIds <= 100,
					"Invalid PlaceIds array"
				)
				for key, id in pairs(entry.PlaceIds) do
					assert(
						type(key) == "number"
							and key % 1 == 0
							and key >= 1
							and key <= #entry.PlaceIds,
						"Invalid PlaceIds array"
					)
					assert(
						type(id) == "number"
							and id > 0
							and id < math.huge
							and id % 1 == 0,
						"Invalid place ID"
					)
					table.insert(places, id)
				end
			end
			seen[entry.Id] = true
			table.insert(clean, {
				Id = entry.Id,
				Name = entry.Name,
				Description = entry.Description,
				File = file,
				GamePlaceId = entry.GamePlaceId,
				Author = entry.Author,
				PlaceIds = places,
			})
		end
		return clean
	end
	-- @NULLX11_CATALOG
	function catalog.GameMessage(message: string)
		engine.Status("GameScript", message)
		engine.Status("Scripts", message)
	end
	function catalog.OpenGame(entry: any)
		if catalog.Busy then
			return
		end
		catalog.Selected = entry
		catalog.Confirm = nil
		if not engine.Windows.GameScript then
			local window = engine.Window("GameScript")
			catalog.GameWindow = window
			local function detail(
				name: string,
				height: number,
				size: number,
				color: Color3
			)
				local text = label(window.Body, "", size, color)
				text.Name = name
				text.Position = UDim2.fromOffset(4, window.Cursor)
				text.Size = UDim2.new(1, -12, 0, height)
				text.TextWrapped = true
				window.Cursor += height + 12
				return text
			end
			catalog.GameTitle = detail("GameScriptTitle", 52, 21, colors.Text)
			catalog.GameDetails =
				detail("GameScriptDetails", 100, 14, colors.Muted)
			catalog.GameCredit =
				detail("GameScriptCredit", 50, 14, colors.Muted)
			catalog.ExecuteButton = engine.Button(
				window,
				"GameExecute",
				"Execute game script",
				function()
					local selected = catalog.Selected
					if not selected then
						return
					end
					if
						selected.GamePlaceId
						and game.PlaceId ~= selected.GamePlaceId
					then
						catalog.GameMessage(
							"Unsupported place. Join the game manually; no teleport was requested."
						)
						return
					end
					catalog.Run(selected, catalog.ExecuteButton)
				end
			)
			window.Body.CanvasSize = UDim2.fromOffset(0, window.Cursor)
			if studioBridge.RegisterUI then
				studioBridge.RegisterUI()
			end
		end
		catalog.GameTitle.Text = entry.Name
		catalog.GameDetails.Text = entry.Description
			.. "\n\n"
			.. (
				if not entry.GamePlaceId
					then "Game modules are checked before startup."
					elseif
						game.PlaceId == entry.GamePlaceId
					then "Target game detected. Confirm execution below."
					else "Unsupported place. Join the game manually to use this script."
			)
		catalog.GameCredit.Text = "Source credits: "
			.. (
				entry.Author
				or "See the reviewed script source; original attribution must be retained."
			)
		catalog.ExecuteButton.Text = "Execute game script"
		catalog.GameMessage(
			"No game teleport prompts or queued auto-execution. Executed scripts survive loader unload."
		)
		layout()
		portal.Play(catalog.GameWindow.Panel, true)
	end
	engine.WindowSetters.GameScript = function(show: boolean)
		if catalog.GameWindow then
			layout()
			portal.Play(catalog.GameWindow.Panel, show)
		end
	end
	function catalog.Run(entry: any, button: TextButton)
		if catalog.Busy then
			return
		end
		if entry.GamePlaceId and game.PlaceId ~= entry.GamePlaceId then
			catalog.Message(
				"Unsupported place. Join the game manually; no code was downloaded.",
				true
			)
			return
		end
		if
			not catalog.Confirm
			or catalog.Confirm.Id ~= entry.Id
			or os.clock() > catalog.Confirm.Deadline
		then
			local confirmation = { Id = entry.Id, Deadline = os.clock() + 5 }
			catalog.Confirm = confirmation
			button.Text = "Confirm run / " .. entry.Name
			catalog.Message(
				"Runs remote code from scripts/"
					.. entry.File
					.. ". Tap again within 5s only if trusted."
			)
			task.delay(5, function()
				if
					alive
					and button.Parent
					and catalog.Confirm == confirmation
					and os.clock() >= confirmation.Deadline
				then
					catalog.Confirm = nil
					button.Text = if entry.GamePlaceId
						then "Execute game script"
						else "Run / " .. entry.Name
				end
			end)
			return
		end
		catalog.Confirm = nil
		catalog.Busy = true
		button.Text = "Downloading…"
		catalog.Message("Fetching scripts/" .. entry.File)
		local progress = playerToolsBridge.BeginExecution
			and playerToolsBridge.BeginExecution(entry.Name)
		task.spawn(function()
			local ok, reason = pcall(function()
				assert(
					type(loadstring) == "function",
					"Client loadstring unavailable; run reviewed scripts as Studio LocalScripts instead"
				)
				local source =
					game:HttpGet(CONFIG.ScriptBaseURL .. entry.File, true)
				if progress then
					if not progress:CanContinue() then
						return
					end
					progress:Phase(
						2,
						"HTTP response received / "
							.. tostring(
								type(source) == "string" and #source or 0
							)
							.. " bytes"
					)
				end
				assert(
					type(source) == "string"
						and #source > 0
						and #source <= 2097152,
					"Script is empty or exceeds 2 MiB"
				)
				if not alive then
					return
				end
				if progress then
					progress:Phase(
						3,
						"Compiling the selected source locally; no game feature is enabled by the loader."
					)
				end
				-- Let the stage render once; this is not a timed/fake progress animation.
				if progress then
					task.wait()
				end
				if not alive or (progress and not progress:CanContinue()) then
					return
				end
				local execute, compileError =
					loadstring(source, "Nullx11Library/" .. entry.File)
				assert(execute, compileError or "Script compilation failed")
				if not alive then
					return
				end
				if progress then
					if not progress:CanContinue() then
						return
					end
					progress:Phase(
						4,
						"Opening the selected game UI. Hiding this screen will not stop an initialized script."
					)
				end
				button.Text = "Running…"
				execute()
			end)
			catalog.Busy = false
			if progress then
				if not ok then
					progress:Fail(reason)
				elseif progress:CanContinue() then
					progress:Finish()
				end
			end
			if not alive or not button.Parent then
				return
			end
			button.Text = if entry.GamePlaceId
				then "Execute game script"
				else "Run / " .. entry.Name
			if
				progress
				and progress.Model
				and progress.Model.Status == "cancelled"
			then
				catalog.Message(
					"Cancelled before initialization. The selected script was not started."
				)
			elseif ok then
				catalog.Message(
					"Client call returned: "
						.. entry.Name
						.. ". External scripts manage their own cleanup."
				)
			else
				catalog.Message(
					"Run failed: " .. string.sub(tostring(reason), 1, 105),
					true
				)
				warn("[Nullx11 Scripts] " .. tostring(reason))
			end
		end)
	end
	function catalog.Render()
		if not catalog.Window then
			return
		end
		for _, connection in ipairs(catalog.RowConnections) do
			connection:Disconnect()
		end
		table.clear(catalog.RowConnections)
		for _, row in ipairs(catalog.Rows) do
			if studioBridge.ForgetUI then
				studioBridge.ForgetUI(row)
			end
			row:Destroy()
		end
		table.clear(catalog.Rows)
		catalog.Confirm = nil
		local window = catalog.Window
		local query = string.lower(catalog.Search.Text)
		local cursor = 116
		local count = 0
		for _, entry in ipairs(catalog.Entries) do
			local matchesPlace = entry.GamePlaceId ~= nil
				or #entry.PlaceIds == 0
			for _, id in ipairs(entry.PlaceIds) do
				if id == game.PlaceId then
					matchesPlace = true
					break
				end
			end
			if
				not matchesPlace
				or not string.find(
					string.lower(
						entry.Name
							.. " "
							.. entry.Description
							.. " "
							.. entry.File
					),
					query,
					1,
					true
				)
			then
				continue
			end
			local row = create("Frame", {
				Name = "ScriptEntry_" .. entry.Id,
				BackgroundColor3 = colors.Surface,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, cursor),
				Size = UDim2.new(1, -4, 0, 156),
			}, window.Body)
			corner(row, 12)
			table.insert(catalog.Rows, row)
			local heading = label(row, entry.Name, 18, colors.Text)
			heading.Position = UDim2.fromOffset(12, 8)
			heading.Size = UDim2.new(1, -24, 0, 24)
			heading.TextTruncate = Enum.TextTruncate.AtEnd
			local description = label(row, entry.Description, 14, colors.Muted)
			description.Position = UDim2.fromOffset(12, 36)
			description.Size = UDim2.new(1, -24, 0, 40)
			description.TextWrapped = true
			local path = label(row, "scripts/" .. entry.File, 14, CONFIG.Accent)
			path.Position = UDim2.fromOffset(12, 78)
			path.Size = UDim2.new(1, -24, 0, 22)
			path.TextTruncate = Enum.TextTruncate.AtEnd
			local run = create("TextButton", {
				Name = "RunScript_" .. entry.Id,
				Text = if entry.GamePlaceId
					then "Open game window"
					else "Run / " .. entry.Name,
				TextSize = 15,
				Font = Enum.Font.GothamMedium,
				TextColor3 = colors.Panel,
				BackgroundColor3 = CONFIG.Accent,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(10, 104),
				Size = UDim2.new(1, -20, 0, 44),
			}, row)
			corner(run, 9)
			table.insert(
				catalog.RowConnections,
				run.Activated:Connect(function()
					if entry.GamePlaceId then
						catalog.OpenGame(entry)
					else
						catalog.Run(entry, run)
					end
				end)
			)
			cursor += 166
			count += 1
		end
		if count == 0 then
			local empty = label(
				window.Body,
				if not catalog.Loaded
					then "Library not loaded. Refresh to read the GitHub scripts/ manifest."
					elseif
						#catalog.Entries == 0
					then "No scripts published yet.\nAdd reviewed .luau files and manifest entries to the GitHub scripts/ folder, then Refresh."
					else "No scripts match this search / place.",
				15,
				colors.Muted
			)
			empty.Name = "ScriptsEmptyState"
			empty.Position = UDim2.fromOffset(8, cursor)
			empty.Size = UDim2.new(1, -20, 0, 118)
			empty.TextWrapped = true
			table.insert(catalog.Rows, empty)
			cursor += 126
		end
		window.Body.CanvasSize = UDim2.fromOffset(0, cursor)
		if studioBridge.RegisterUI then
			studioBridge.RegisterUI()
		end
	end
	function catalog.Refresh()
		if catalog.Busy then
			return
		end
		catalog.Busy = true
		catalog.Message("Fetching the GitHub manifest…")
		task.spawn(function()
			local ok, result = pcall(function()
				local source =
					game:HttpGet(CONFIG.ScriptBaseURL .. "manifest.json", true)
				assert(
					type(source) == "string" and #source <= 131072,
					"Manifest exceeds 128 KiB"
				)
				return catalog.Validate(
					game:GetService("HttpService"):JSONDecode(source)
				)
			end)
			catalog.Busy = false
			if progress then
				if not ok then
					progress:Fail(reason)
				elseif progress:CanContinue() then
					progress:Finish()
				end
			end
			if not alive then
				return
			end
			if ok then
				-- A refresh invalidates old detail/confirmation state, including removed entries.
				catalog.Selected = nil
				catalog.Confirm = nil
				if catalog.GameWindow then
					portal.Play(catalog.GameWindow.Panel, false)
				end
				catalog.Entries = result
				catalog.Loaded = true
				catalog.Render()
				catalog.Message(
					string.format(
						"GitHub manifest loaded / %d published scripts.",
						#result
					)
				)
			else
				catalog.Message(
					"Refresh failed: " .. string.sub(tostring(result), 1, 100),
					true
				)
				warn("[Nullx11 Scripts] " .. tostring(result))
			end
		end)
	end
	function engine.BuildScripts()
		if engine.Windows.Scripts then
			return
		end
		local window = engine.Window("Scripts")
		catalog.Window = window
		engine.Button(
			window,
			"RefreshScripts",
			"Refresh from GitHub",
			catalog.Refresh
		)
		catalog.Search = create("TextBox", {
			Name = "ScriptsSearch",
			Text = "",
			PlaceholderText = "Search published scripts…",
			ClearTextOnFocus = false,
			MultiLine = false,
			Font = Enum.Font.Gotham,
			TextSize = 16,
			TextColor3 = colors.Text,
			PlaceholderColor3 = colors.Muted,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 58),
			Size = UDim2.new(1, -4, 0, 44),
		}, window.Body)
		corner(catalog.Search, 10)
		connect(catalog.Search:GetPropertyChangedSignal("Text"), catalog.Render)
		catalog.Render()
		catalog.Message(
			if catalog.Loaded
				then "Bundled entries ready. Refresh to read the latest GitHub library."
				else "No network request yet. Refresh to read the GitHub library."
		)
	end
	-- Navigation is an action, not an ON/OFF feature switch.
	engine.WindowSetters.Scripts = function(show: boolean)
		if show then
			engine.BuildScripts()
		end
		layout()
		if engine.Windows.Scripts then
			portal.Play(engine.Windows.Scripts.Panel, show)
		end
	end
	local scriptsButton = create("TextButton", {
		Name = "Scripts window",
		Text = "Open Scripts library",
		TextSize = 16,
		Font = Enum.Font.GothamMedium,
		TextColor3 = colors.Text,
		BackgroundColor3 = colors.Surface,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Position = UDim2.fromOffset(0, 348),
		Size = UDim2.new(1, 0, 0, 50),
	}, tools)
	corner(scriptsButton, 10)
	-- Original folder mark built from UI primitives; no emoji or copied asset.
	local folder = create("Frame", {
		Name = "ScriptsFolderAsset",
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 20),
		Size = UDim2.fromOffset(22, 16),
	}, scriptsButton)
	corner(folder, 3)
	create("Frame", {
		Name = "FolderTab",
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(1, -5),
		Size = UDim2.fromOffset(10, 7),
	}, folder)
	connect(scriptsButton.Activated, function()
		engine.WindowSetters.Scripts(true)
	end)

	tools.CanvasSize = UDim2.fromOffset(0, 406)
	local previousLayout = layoutExtras
	layoutExtras = function()
		if previousLayout then
			previousLayout()
		end
		local viewport = root.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
		for _, window in pairs(engine.Windows) do
			local size = Vector2.new(
				math.min(390, viewport.X - 24),
				math.min(540, viewport.Y - 24)
			)
			window.Panel.Size = UDim2.fromOffset(size.X, size.Y)
			local center =
				clampCenter(extraCenters[window.Panel] or viewport / 2, size)
			extraCenters[window.Panel] = center
			if not portal.Jobs[window.Panel] then
				window.Panel.Position = UDim2.fromOffset(center.X, center.Y)
			end
		end
		if engine.TouchPad then
			local center = clampCenter(
				extraCenters[engine.TouchPad]
					or Vector2.new(viewport.X - 72, viewport.Y - 110),
				Vector2.new(116, 104)
			)
			extraCenters[engine.TouchPad] = center
			engine.TouchPad.Position = UDim2.fromOffset(center.X, center.Y)
		end
		engine.Schedule()
	end
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			engine.Records[other] = { Player = other }
		end
	end
	connect(Players.PlayerAdded, function(other: Player)
		if other ~= player then
			engine.Records[other] = { Player = other }
		end
	end)
	connect(Players.PlayerRemoving, engine.Remove)
	connect(
		UserInputService.InputBegan,
		function(input: InputObject, processed: boolean)
			if processed or UserInputService:GetFocusedTextBox() then
				return
			end
			if input.KeyCode == Enum.KeyCode.End then
				engine.DisableAll()
				return
			end
			if
				input.UserInputType == Enum.UserInputType.MouseButton2
				and toolsState.Aim
			then
				local ok, hits = pcall(function()
					return playerGui:GetGuiObjectsAtPosition(
						input.Position.X,
						input.Position.Y
					)
				end)
				if ok then
					for _, object in ipairs(hits) do
						if object ~= root and object:IsDescendantOf(gui) then
							return
						end
					end
				end

				engine.MouseHeld = true
			end
		end
	)
	connect(UserInputService.InputEnded, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			engine.MouseHeld = false
		end
		if input == engine.TouchInput then
			engine.TouchInput = nil
		end
	end)
	connect(UserInputService.WindowFocusReleased, function()
		engine.MouseHeld = false
		engine.TouchInput = nil
	end)
	playerToolsBridge.FoldWindows = function()
		engine.WindowSetters.Visuals(false)
		engine.WindowSetters.Aim(false)
		engine.WindowSetters.Scripts(false)
		engine.WindowSetters.GameScript(false)
	end
	playerToolsBridge.Catalog = catalog
	playerToolsBridge.OpenVisuals = function()
		engine.WindowSetters.Visuals(true)
	end
	playerToolsBridge.OpenAim = function()
		engine.WindowSetters.Aim(true)
	end
	playerToolsBridge.OpenScripts = function()
		engine.WindowSetters.Scripts(true)
	end
	playerToolsBridge.Stop = engine.DisableAll
	playerToolsBridge.HideWindows = function()
		engine.DisableAll()
		engine.WindowSetters.Visuals(false)
		engine.WindowSetters.Aim(false)
		engine.WindowSetters.Scripts(false)
		engine.WindowSetters.GameScript(false)
	end
	playerToolsBridge.Style = function(values: { [string]: any })
		for _, window in pairs(engine.Windows) do
			window.Panel.BackgroundTransparency = 1 - values.PanelOpacity / 100
		end
		if engine.TouchPad then
			engine.TouchPad.BackgroundTransparency = 1
				- values.PanelOpacity / 100
		end
	end
	playerToolsBridge.Destroy = function()
		for _, connection in ipairs(catalog.RowConnections) do
			connection:Disconnect()
		end
		table.clear(catalog.RowConnections)
		if engine.Fallback then
			engine.Fallback:Disconnect()
			engine.Fallback = nil
		elseif engine.Bound then
			RunService:UnbindFromRenderStep(engine.BindName)
		end
		for other in pairs(engine.Records) do
			engine.Remove(other)
		end
		engine.ClearHighlights()
		if engine.HighlightFolder then
			engine.HighlightFolder:Destroy()
		end
		if engine.Overlay then
			engine.Overlay:Destroy()
		end
		engine.MouseHeld = false
		engine.TouchInput = nil
	end
end

local busy = false
local loaded = false
local function buttonColor(hovered: boolean)
	if busy or loaded then
		return
	end
	tween(launch, {
		BackgroundColor3 = if hovered
			then CONFIG.Accent:Lerp(Color3.new(1, 1, 1), 0.16)
			else CONFIG.Accent,
	})
end
connect(launch.MouseEnter, function()
	buttonColor(true)
end)
connect(launch.MouseLeave, function()
	buttonColor(false)
end)
connect(launch.SelectionGained, function()
	buttonColor(true)
end)
connect(launch.SelectionLost, function()
	buttonColor(false)
end)

connect(launch.Activated, function()
	if busy or loaded or not alive then
		return
	end
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
			if not alive then
				return false
			end
			task.wait(0.1)
		end
		if not alive then
			return false
		end
		tween(progressFill, { Size = UDim2.fromScale(0.2, 1) })
		local app = if appContainer
			then appContainer:FindFirstChild("App")
			else nil
		if not app then
			return false
		end
		assert(app:IsA("ModuleScript"), "App must be a ModuleScript")
		status.Text = "Starting your app…"
		local initialize = require(app)
		assert(type(initialize) == "function", "App must return a function")
		if not alive then
			return false
		end
		initialize({
			Player = player,
			-- Report real work completed: 0 to 1, not an estimated timer.
			SetProgress = function(fraction: number, message: string?)
				if not alive then
					return
				end
				assert(
					type(fraction) == "number" and fraction == fraction,
					"Progress must be a number"
				)
				tween(progressFill, {
					Size = UDim2.fromScale(
						0.2 + math.clamp(fraction, 0, 1) * 0.8,
						1
					),
				})
				if message then
					status.Text = message
				end
			end,
			IsCancelled = function(): boolean
				return not alive
			end,
		})
		return true
	end)
	if not alive then
		return
	end
	busy = false
	launch.Selectable = true
	if ok then
		loaded = true
		launch.Text = "Ready  ✓"
		status.Text = if result
			then "App and tools ready."
			else "Tools ready. Make yourself at home."
		showTools()
		status.TextColor3 = colors.Success
		tween(
			progressFill,
			{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = colors.Success }
		)
	else
		launch.Text = "Try again  →"
		status.Text = "Could not start. See Output for details."
		status.TextColor3 = colors.Error
		tween(
			progressFill,
			{ Size = UDim2.fromScale(0, 1), BackgroundColor3 = colors.Error }
		)
		warn("[Nullx11] App failed: " .. tostring(result))
	end
end)

connect(gui.Destroying, function()
	alive = false
	table.clear(portal.Jobs)
	if playerToolsBridge.Destroy then
		playerToolsBridge.Destroy()
	end
	if studioBridge.Destroy then
		studioBridge.Destroy()
	end
	drag = nil
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	table.clear(connections)
	table.clear(themeRefreshers)
	for _, animations in pairs(activeTweens) do
		for _, animation in pairs(animations) do
			animation:Cancel()
		end
	end
	table.clear(activeTweens)
end)

-- Native-UI gravity well: concentric lenses, orbital dust, implosion, shockwave.
do
	if
		CONFIG.StartupAnimation
		and not CONFIG.ReducedMotion
		and not CONFIG.EnhancedWorkspace
	then
		card.Visible = false
		mini.Visible = false
		local intro = create("Frame", {
			Name = "StartupWhirlpool",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(8, 12, 24),
			BackgroundTransparency = 0.03,
			BorderSizePixel = 0,
			ZIndex = 50,
			Active = true,
			ClipsDescendants = true,
		}, root)
		create("UIGradient", {
			Color = ColorSequence.new(
				Color3.fromRGB(14, 18, 38),
				Color3.fromRGB(7, 19, 28)
			),
			Rotation = 38,
		}, intro)
		local lenses = {}
		for index = 1, 3 do
			local lens = create("Frame", {
				Name = "GravityLens" .. index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Rotation = -24 + index * 17,
			}, intro)
			corner(lens, 1000)
			local outline = create("UIStroke", {
				Color = if index == 2
					then Color3.fromRGB(120, 238, 226)
					else CONFIG.Accent,
				Thickness = if index == 2 then 2 else 1,
				Transparency = 0.4 + index * 0.1,
			}, lens)
			table.insert(lenses, { Frame = lens, Stroke = outline })
		end
		local particles = {}
		for index = 1, 48 do
			local particle = create("Frame", {
				Name = "WhirlpoolParticle" .. index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(2 + index % 3, 8 + index % 5 * 3),
				BackgroundColor3 = if index % 3 == 0
					then Color3.fromRGB(128, 240, 228)
					elseif index % 7 == 0 then Color3.fromRGB(
						255,
						218,
						157
					)
					else CONFIG.Accent,
				BorderSizePixel = 0,
			}, intro)
			corner(particle, 3)
			table.insert(particles, particle)
		end
		local center = create("Frame", {
			Name = "WhirlpoolCenter",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(80, 80),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			ZIndex = 3,
		}, intro)
		corner(center, 24)
		local coreStroke = create(
			"UIStroke",
			{ Color = CONFIG.Accent, Thickness = 2, Transparency = 0.1 },
			center
		)
		local insignia = drawIcon(
			center,
			Color3.fromRGB(164, 244, 233),
			UDim2.fromScale(0.2, 0.2),
			48
		)
		insignia.Size = UDim2.fromScale(0.6, 0.6)
		local wordmark = label(intro, "NULLX11", 27, colors.Text)
		wordmark.Name = "StartupWordmark"
		wordmark.Font = Enum.Font.Arcade
		wordmark.ZIndex = 5
		wordmark.AnchorPoint = Vector2.new(0.5, 0.5)
		wordmark.Size = UDim2.fromOffset(320, 40)
		wordmark.TextXAlignment = Enum.TextXAlignment.Center
		local caption =
			label(intro, "GRAVITY CORE / OPENING WORKSPACE", 14, colors.Muted)
		caption.Name = "StartupCaption"
		caption.ZIndex = 5
		caption.AnchorPoint = Vector2.new(0.5, 0.5)
		caption.Size = UDim2.new(1, -32, 0, 30)
		caption.TextXAlignment = Enum.TextXAlignment.Center
		local skip = create("TextButton", {
			Name = "SkipStartup",
			Text = "Skip animation  →",
			Font = Enum.Font.GothamMedium,
			TextSize = 16,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -18),
			Size = UDim2.fromOffset(190, 46),
			ZIndex = 6,
		}, intro)
		corner(skip, 13)
		local elapsed, rotation = 0, 0
		local finished = false
		local animation: RBXScriptConnection? = nil
		local function finish(immediate: boolean?)
			if finished or not alive then
				return
			end
			finished = true
			if animation then
				animation:Disconnect()
			end
			intro:Destroy()
			mini.Visible = true
			layout()
			if immediate then
				card.Visible = expanded
			elseif expanded then
				portal.Play(card, true)
			end
		end
		connect(skip.Activated, function()
			finish(true)
		end)
		animation = connect(RunService.RenderStepped, function(dt: number)
			if finished or not alive then
				return
			end
			local viewport = root.AbsoluteSize
			local short = viewport.Y > 0 and viewport.Y < 420
			wordmark.Position = if short
				then UDim2.new(0.5, 0, 0, 30)
				else UDim2.new(0.5, 0, 0.5, 126)
			caption.Position = if short
				then UDim2.new(0.5, 0, 0, 62)
				else UDim2.new(0.5, 0, 0.5, 166)
			rotation += math.min(dt, 0.1) * 3.2
			if game:IsLoaded() then
				elapsed += dt
				caption.Text = "GRAVITY CORE / OPENING WORKSPACE"
			else
				caption.Text = "Waiting for the game / Skip is available"
			end
			local pull = math.clamp(elapsed / 1.25, 0, 1)
			local burst = math.clamp((elapsed - 1.25) / 0.7, 0, 1)
			local collapsing = elapsed < 1.25
			local baseRadius =
				math.clamp(math.min(viewport.X, viewport.Y) * 0.48, 90, 220)
			for index, lens in ipairs(lenses) do
				local diameter = if collapsing
					then (baseRadius * 2 + index * 26) * (1 - pull ^ 2) + 10
					else 10 + burst * (baseRadius * 3 + index * 80)
				lens.Frame.Size =
					UDim2.fromOffset(diameter, diameter * (0.42 + index * 0.12))
				lens.Frame.Rotation = -24
					+ index * 17
					+ math.deg(rotation)
						* 0.1
						* (if index % 2 == 0 then -1 else 1)
				lens.Stroke.Transparency = if collapsing
					then 0.35 + index * 0.12
					else math.clamp(0.25 + burst * 0.75, 0, 1)
			end
			local core = if collapsing
				then 80 * (1 - pull) ^ 0.7 + 5
				else 5 + burst * 100
			center.Size = UDim2.fromOffset(core, core)
			center.Rotation = if collapsing
				then -pull * 100
				else -100 + burst * 145
			center.BackgroundTransparency = if collapsing then 0.05 else burst
			coreStroke.Transparency = if collapsing then 0.1 else burst
			wordmark.TextTransparency = math.clamp((pull - 0.65) / 0.35, 0, 1)
			for index, particle in ipairs(particles) do
				local angle = index * 2.399963
					+ rotation * (0.75 + index % 3 * 0.2)
					+ pull * 8
				local radius = if collapsing
					then (baseRadius + index % 5 * 12) * (1 - pull) ^ 1.6
					else burst * (baseRadius * 1.4 + index % 5 * 28)
				particle.Position = UDim2.new(
					0.5,
					math.cos(angle) * radius,
					0.5,
					math.sin(angle) * radius * 0.65
				)
				particle.Rotation = math.deg(angle) + 90
				particle.BackgroundTransparency = if collapsing
					then 0.15 + pull * 0.2
					else burst
			end
			intro.BackgroundTransparency = if collapsing
				then 0.03
				else 0.03 + burst * 0.97
			if elapsed >= 1.95 then
				finish()
			end
		end)
	end
end

-- @NULLX11_WORKSPACE
