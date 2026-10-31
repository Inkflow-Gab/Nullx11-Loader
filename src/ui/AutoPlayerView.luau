-- Bespoke NULL MIDI control room. Native geometry, no image/font downloads.
-- Static piano dock; finite opening/loading tweens; pooled waterfall and rows.
-- Ordinary Frames deliberately avoid mobile off-screen CanvasGroup textures.
return function(context)
	local tweenService = game:GetService("TweenService")
	local input = game:GetService("UserInputService")
	local view = {
		Alive = true,
		Visible = true,
		Actions = {},
		Rows = {},
		Bars = {},
		Keys = {},
		KeyCaptions = {},
		Inputs = {},
		Page = "Library",
		ReducedMotion = context.ReducedMotion,
		Tweens = {},
	}
	local color = {
		Background = Color3.fromRGB(18, 18, 22),
		Panel = Color3.fromRGB(24, 24, 30),
		Card = Color3.fromRGB(33, 33, 41),
		Border = Color3.fromRGB(57, 56, 66),
		Text = Color3.fromRGB(244, 240, 232),
		Muted = Color3.fromRGB(159, 156, 168),
		Cyan = Color3.fromRGB(230, 187, 126),
		Violet = Color3.fromRGB(174, 165, 213),
		Red = Color3.fromRGB(255, 118, 139),
	}
	local gui = Instance.new("ScreenGui")
	gui.Name = "Nullx11AutoPlayer"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.DisplayOrder = 350
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	view.Gui = gui
	-- Own the GUI before constructing any children. Failed startup cannot leave
	-- a black/orphaned host behind. Parenting can fail even if GetService works.
	context.RegisterCleanup(function()
		view.Alive = false
		for _, tween in pairs(view.Tweens) do
			pcall(tween.Cancel, tween)
		end
		table.clear(view.Tweens)
		gui:Destroy()
	end)
	local parents = {
		function()
			return type(gethui) == "function" and gethui() or nil
		end,
		function()
			return game:GetService("CoreGui")
		end,
		function()
			return game:GetService("Players").LocalPlayer
				:WaitForChild("PlayerGui", 5)
		end,
	}
	local mounted = false
	for _, resolve in ipairs(parents) do
		local success = pcall(function()
			local host = resolve()
			if host then
				gui.Parent = host
				mounted = gui.Parent == host
			end
		end)
		if success and mounted then
			break
		end
	end
	assert(
		mounted,
		"No permitted GUI host; allow CoreGui/gethui or PlayerGui access"
	)
	local function create(class, parent, props)
		local object = Instance.new(class)
		for key, value in pairs(props or {}) do
			object[key] = value
		end
		object.Parent = parent
		return object
	end
	local function corner(object, radius)
		create("UICorner", object, { CornerRadius = UDim.new(0, radius or 10) })
	end
	local function stroke(object, accent)
		create("UIStroke", object, {
			Color = accent or color.Border,
			Thickness = 1,
			Transparency = 0.55,
		})
	end
	local function frame(parent, name, shade)
		local object = create("Frame", parent, {
			Name = name,
			BackgroundColor3 = shade or color.Card,
			BorderSizePixel = 0,
		})
		corner(object)
		return object
	end
	local function label(parent, name, text, size, shade)
		return create("TextLabel", parent, {
			Name = name,
			BackgroundTransparency = 1,
			Text = text,
			TextSize = size or 14,
			TextColor3 = shade or color.Text,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
	end
	local function animate(object, duration, props)
		local previous = view.Tweens[object]
		if previous then
			pcall(previous.Cancel, previous)
		end
		local function apply()
			for key, value in pairs(props) do
				object[key] = value
			end
		end
		if view.ReducedMotion then
			apply()
			return
		end
		-- An animation is decorative, never a prerequisite for visible controls.
		local success = pcall(function()
			local tween = tweenService:Create(
				object,
				TweenInfo.new(
					duration,
					Enum.EasingStyle.Quart,
					Enum.EasingDirection.Out
				),
				props
			)
			view.Tweens[object] = tween
			tween:Play()
		end)
		if not success then
			apply()
		end
	end
	function view.Dispatch(name, ...)
		if view.Alive and view.Actions[name] then
			local success, reason = pcall(view.Actions[name], ...)
			if not success then
				view.Message(reason, true)
			end
		end
	end
	local function button(parent, name, text, action, shade)
		local object = create("TextButton", parent, {
			Name = name,
			Text = text,
			TextSize = 13,
			Font = Enum.Font.GothamBold,
			TextColor3 = shade == color.Cyan and color.Background or color.Text,
			BackgroundColor3 = shade or color.Card,
			BorderSizePixel = 0,
			AutoButtonColor = true,
		})
		corner(object, 10)
		stroke(object, shade)
		context.Connect(object.Activated, function()
			if type(action) == "function" then
				action()
			else
				view.Dispatch(action)
			end
		end)
		return object
	end
	local root = create("Frame", gui, {
		Name = "SafeArea",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})
	local panel = create("Frame", root, {
		Name = "AutoPlayerPanel",
		BackgroundColor3 = color.Background,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, -16, 1, -16),
		Position = UDim2.fromScale(0.5, 0.5),
		Visible = true,
	})
	corner(panel, 16)
	stroke(panel)
	local openingScale = create("UIScale", panel, { Scale = 0.94 })
	view.Panel = panel
	local header = frame(panel, "Header", color.Panel)
	local function pianoMark(parent, size)
		local icon = frame(parent, "StaticPianoMark", color.Card)
		icon.Size = UDim2.fromOffset(size, size)
		for index = 1, 5 do
			local key = create("Frame", icon, {
				BorderSizePixel = 0,
				BackgroundColor3 = index == 3 and color.Cyan or color.Text,
				Size = UDim2.new(0.14, 0, 0.52, 0),
				Position = UDim2.new(0.08 + (index - 1) * 0.17, 0, 0.25, 0),
			})
			corner(key, 2)
		end
		for _, index in ipairs({ 1, 2, 4 }) do
			create("Frame", icon, {
				BorderSizePixel = 0,
				BackgroundColor3 = color.Background,
				Size = UDim2.new(0.09, 0, 0.3, 0),
				Position = UDim2.new(0.18 + (index - 1) * 0.17, 0, 0.25, 0),
				ZIndex = 2,
			})
		end
		return icon
	end
	local logo = pianoMark(header, 44)
	logo.Position = UDim2.fromOffset(14, 12)
	local brand = label(header, "Brand", "NULL / PIANO PLAYER", 10, color.Cyan)
	brand.Position = UDim2.fromOffset(70, 11)
	brand.Size = UDim2.new(1, -180, 0, 17)
	local title = label(header, "Title", "Auto Player", 25)
	title.Font = Enum.Font.GothamBold
	title.Position = UDim2.fromOffset(69, 28)
	title.Size = UDim2.new(1, -180, 0, 30)
	local minimize = button(header, "Minimize", "Hide", function()
		view.SetVisible(false)
	end)
	local close = button(header, "Unload", "Close", "unload")
	local nav = create(
		"Frame",
		panel,
		{ Name = "Navigation", BackgroundTransparency = 1 }
	)
	local pages, navButtons = {}, {}
	local main =
		create("Frame", panel, { Name = "Content", BackgroundTransparency = 1 })
	local rail = frame(main, "SongRail", color.Panel)
	local listHeading =
		label(rail, "ListHeading", "YOUR LIBRARY", 11, color.Muted)
	listHeading.Position = UDim2.fromOffset(12, 8)
	listHeading.Size = UDim2.new(1, -24, 0, 24)
	local search = create("TextBox", rail, {
		Name = "SongSearch",
		Position = UDim2.fromOffset(10, 38),
		Size = UDim2.new(1, -20, 0, 36),
		Text = "",
		PlaceholderText = "Search songs or folders",
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = color.Text,
		PlaceholderColor3 = color.Muted,
		BackgroundColor3 = color.Card,
		BorderSizePixel = 0,
	})
	corner(search, 9)
	context.Connect(search:GetPropertyChangedSignal("Text"), function()
		view.Dispatch("search", search.Text)
	end)
	local list = create("ScrollingFrame", rail, {
		Name = "Songs",
		Position = UDim2.fromOffset(8, 82),
		Size = UDim2.new(1, -16, 1, -126),
		CanvasSize = UDim2.new(),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = color.Cyan,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})
	local empty = label(
		list,
		"EmptyLibrary",
		"Choose Refresh to scan your MIDI folder. No demo songs are inserted.",
		13,
		color.Muted
	)
	empty.Size = UDim2.new(1, -8, 0, 80)
	empty.TextWrapped = true
	empty.TextYAlignment = Enum.TextYAlignment.Top
	local previousPage = button(rail, "PreviousPage", "<", function()
		view.Dispatch("page", -1)
	end)
	local nextPage = button(rail, "NextPage", ">", function()
		view.Dispatch("page", 1)
	end)
	local refresh = button(rail, "RefreshFiles", "Refresh", "refresh")
	local stage = frame(main, "PianoStage", color.Panel)
	local stageTag = label(stage, "StageTag", "NOW PLAYING", 10, color.Cyan)
	stageTag.Position = UDim2.fromOffset(16, 12)
	stageTag.Size = UDim2.new(1, -32, 0, 18)
	local song = label(stage, "SongTitle", "Your next piece starts here.", 22)
	song.Position = UDim2.fromOffset(16, 35)
	song.Size = UDim2.new(1, -32, 0, 31)
	song.Font = Enum.Font.GothamBold
	local meta = label(
		stage,
		"SongMetadata",
		"SMF 0 / 1  |  Tempo maps  |  Track control",
		12,
		color.Muted
	)
	meta.Position = UDim2.fromOffset(16, 71)
	meta.Size = UDim2.new(1, -32, 0, 21)
	local roll = frame(stage, "PooledWaterfall", color.Background)
	roll.Position = UDim2.fromOffset(14, 104)
	roll.ClipsDescendants = true
	for index = 0, 7 do
		create("Frame", roll, {
			BorderSizePixel = 0,
			BackgroundColor3 = color.Border,
			BackgroundTransparency = 0.65,
			Position = UDim2.new(index / 7, 0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
		})
	end
	local hitLine = create("Frame", roll, {
		Name = "HitLine",
		BorderSizePixel = 0,
		BackgroundColor3 = color.Cyan,
		Position = UDim2.new(0, 0, 1, -2),
		Size = UDim2.new(1, 0, 0, 2),
	})
	for index = 1, 72 do
		local bar = frame(
			roll,
			"NoteBar" .. index,
			index % 2 == 0 and color.Cyan or color.Violet
		)
		corner(bar, 3)
		bar.Visible = false
		view.Bars[index] = bar
	end
	local keyboard = create("Frame", stage, {
		Name = "PianoKeyboard",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})
	local modeLabel = label(
		stage,
		"MappingLabel",
		"61-KEY VIRTUAL PIANO / C2 - C7",
		10,
		color.Muted
	)
	local audition = button(stage, "TestC4", "Test C4", "test")
	view.Stage = stage
	local function scrollPage(name)
		local page = create("ScrollingFrame", main, {
			Name = name,
			BackgroundColor3 = color.Panel,
			BorderSizePixel = 0,
			Visible = false,
			CanvasSize = UDim2.new(),
			ScrollBarThickness = 4,
		})
		corner(page)
		pages[name] = page
		return page
	end
	local mixer, settings, keysPage =
		scrollPage("Mixer"), scrollPage("Settings"), scrollPage("Keys")
	local rowHeights = { Mixer = 12, Settings = 12 }
	local function settingRow(page, heading, detail)
		local y = rowHeights[page.Name]
		rowHeights[page.Name] += 86
		local row = frame(page, heading, color.Card)
		row.Position = UDim2.fromOffset(12, y)
		row.Size = UDim2.new(1, -24, 0, 76)
		local headingLabel = label(row, "Heading", heading, 13)
		headingLabel.Position = UDim2.fromOffset(12, 8)
		headingLabel.Size = UDim2.new(1, -132, 0, 22)
		local description = label(row, "Detail", detail, 10, color.Muted)
		description.Position = UDim2.fromOffset(12, 33)
		description.Size = UDim2.new(1, -132, 0, 34)
		description.TextWrapped = true
		page.CanvasSize = UDim2.fromOffset(0, rowHeights[page.Name] + 12)
		return row
	end
	view.Settings = {}
	function view.Toggle(page, heading, detail, initial, action)
		local row = settingRow(page, heading, detail)
		local value = initial
		local control = button(
			row,
			heading .. "Toggle",
			value and "ON" or "OFF",
			function()
				view.Dispatch(action, not value)
			end
		)
		control.Size = UDim2.fromOffset(88, 40)
		control.Position = UDim2.new(1, -100, 0.5, -20)
		local function set(nextValue)
			value = nextValue
			control.Text = value and "ON" or "OFF"
			control.TextColor3 = value and color.Cyan or color.Muted
		end
		set(initial)
		view.Settings[action] = set
		return set
	end
	function view.Value(page, heading, detail, initial, action)
		local row = settingRow(page, heading, detail)
		local box = create("TextBox", row, {
			Name = heading .. "Input",
			Position = UDim2.new(1, -100, 0.5, -20),
			Size = UDim2.fromOffset(88, 40),
			BackgroundColor3 = color.Background,
			Text = tostring(initial),
			ClearTextOnFocus = false,
			TextSize = 14,
			TextColor3 = color.Cyan,
			Font = Enum.Font.GothamMedium,
			BorderSizePixel = 0,
		})
		corner(box, 8)
		context.Connect(box.FocusLost, function()
			view.Dispatch(action, box.Text)
		end)
		view.Inputs[action] = box
		return box
	end
	view.Toggle(
		mixer,
		"Honor sustain pedal",
		"CC64 pedal timing from the MIDI file.",
		true,
		"sustain"
	)
	view.Toggle(
		mixer,
		"Include channel 10",
		"Percussion is excluded by default.",
		false,
		"drums"
	)
	view.Value(
		mixer,
		"Minimum velocity",
		"Filter quiet notes: 1 through 127.",
		1,
		"velocity"
	)
	view.Value(
		mixer,
		"Gate length",
		"0.1 to 1.0 of MIDI note length.",
		1,
		"gate"
	)
	local trackStart = rowHeights.Mixer
	view.Toggle(
		settings,
		"Arm piano input",
		"Opt in before sending game key events.",
		false,
		"arm"
	)
	view.Toggle(
		settings,
		"Preview only",
		"Visual playback. Does not play the game piano.",
		false,
		"preview"
	)
	view.Toggle(
		settings,
		"88-key extension",
		"Ctrl mapping requires a compatible piano.",
		false,
		"mode88"
	)
	view.Toggle(
		settings,
		"Octave-fold range",
		"Fold out-of-range notes into this keyboard.",
		true,
		"fold"
	)
	view.Toggle(
		settings,
		"Repeat A / B",
		"Set loop bounds with the transport buttons.",
		false,
		"loop"
	)
	view.Toggle(
		settings,
		"Advance queue",
		"Only advances after explicitly started playback.",
		false,
		"advance"
	)
	view.Toggle(
		settings,
		"Include subfolders",
		"Depth 3, 32 folders, up to 512 MIDI files.",
		true,
		"recursive"
	)
	view.Toggle(
		settings,
		"Reduced motion",
		"Instant transitions; piano dock stays static.",
		view.ReducedMotion,
		"motion"
	)
	view.Value(
		settings,
		"Start delay",
		"0 through 10 seconds to focus the game piano.",
		2,
		"delay"
	)
	local footer = frame(panel, "Transport", color.Panel)
	local seek = button(footer, "SeekBar", "", function() end)
	seek.BackgroundColor3 = color.Border
	seek.Size = UDim2.new(1, -28, 0, 10)
	seek.Position = UDim2.fromOffset(14, 10)
	local seekFill = frame(seek, "SeekFill", color.Cyan)
	seekFill.Size = UDim2.fromScale(0, 1)
	context.Connect(seek.InputBegan, function(event)
		if
			event.UserInputType == Enum.UserInputType.MouseButton1
			or event.UserInputType == Enum.UserInputType.Touch
		then
			view.Dispatch(
				"seek",
				math.clamp(
					(event.Position.X - seek.AbsolutePosition.X)
						/ math.max(1, seek.AbsoluteSize.X),
					0,
					1
				)
			)
		end
	end)
	local transport = {}
	for _, spec in ipairs({
		{ "Prev", "previous" },
		{ "Play", "play" },
		{ "Pause", "pause" },
		{ "Stop", "stop" },
		{ "Next", "next" },
	}) do
		transport[#transport + 1] = button(
			footer,
			spec[2],
			spec[1],
			spec[2],
			spec[2] == "play" and color.Cyan or nil
		)
	end
	local clockLabel = label(footer, "Clock", "00:00 / 00:00", 12, color.Muted)
	local stateLabel = label(footer, "State", "DISARMED", 10, color.Violet)
	local bottom = create(
		"Frame",
		panel,
		{ Name = "SessionControls", BackgroundTransparency = 1 }
	)
	local speed = create("TextBox", bottom, {
		Name = "PlaybackSpeed",
		Text = "1.0",
		ClearTextOnFocus = false,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = color.Cyan,
		BackgroundColor3 = color.Card,
		BorderSizePixel = 0,
	})
	corner(speed, 7)
	local transpose = create("TextBox", bottom, {
		Name = "Transpose",
		Text = "0",
		ClearTextOnFocus = false,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = color.Cyan,
		BackgroundColor3 = color.Card,
		BorderSizePixel = 0,
	})
	corner(transpose, 7)
	local speedTitle = label(bottom, "SpeedCaption", "SPEED", 9, color.Muted)
	view.Profile61 = function()
		transpose.Text = "0"
	end
	local pitchTitle =
		label(bottom, "TransposeCaption", "SEMITONES", 9, color.Muted)
	context.Connect(speed.FocusLost, function()
		view.Dispatch("speed", speed.Text)
	end)
	context.Connect(transpose.FocusLost, function()
		view.Dispatch("transpose", transpose.Text)
	end)
	local addQueue = button(bottom, "QueueSelected", "+ Queue", "enqueue")
	local favorite = button(bottom, "Favorite", "Favorite", "favorite")
	local loopA = button(bottom, "LoopA", "Set A", "loopA")
	local loopB = button(bottom, "LoopB", "Set B", "loopB")
	local status = label(
		panel,
		"SessionStatus",
		"Checking local MIDI capabilities...",
		11,
		color.Muted
	)
	local dockMoved, dockPositioned = false, false
	local holder = frame(root, "AutoPlayerHolder", color.Panel)
	holder.AnchorPoint = Vector2.new(0.5, 0.5)
	holder.Position = UDim2.new(0.5, 0, 1, -116)
	holder.Size = UDim2.fromOffset(256, 80)
	holder.Visible = false
	holder.Active = true
	stroke(holder)
	view.Holder = holder
	local dock = button(holder, "PianoDock", "", function()
		if not dockMoved then
			view.SetVisible(true)
		end
	end)
	dock.Size = UDim2.fromOffset(48, 48)
	dock.Position = UDim2.fromOffset(8, 9)
	dock.Visible = false
	local dockPiano = pianoMark(dock, 36)
	dockPiano.Position = UDim2.fromOffset(6, 6)
	dockPiano.Active = false
	local miniTitle =
		label(holder, "HolderTitle", "Auto Player / NULL", 10, color.Muted)
	miniTitle.Position = UDim2.fromOffset(66, 7)
	miniTitle.Size = UDim2.fromOffset(178, 16)
	local miniPlay = button(holder, "HolderPlay", "Play", function()
		if not dockMoved then
			view.Dispatch(view.Playing and "pause" or "play")
		end
	end, color.Cyan)
	miniPlay.Position = UDim2.fromOffset(66, 28)
	miniPlay.Size = UDim2.fromOffset(90, 44)
	local miniStop = button(holder, "HolderStop", "STOP", function()
		if not dockMoved then
			view.Dispatch("panic")
		end
	end)
	miniStop.TextColor3 = color.Red
	miniStop.Position = UDim2.fromOffset(164, 28)
	miniStop.Size = UDim2.fromOffset(80, 44)
	function view.SetVisible(value)
		view.Visible = value
		panel.Visible = value
		holder.Visible = not value
		dock.Visible = not value
		if value then
			animate(openingScale, 0.3, { Scale = 1 })
			view.Dispatch("reveal")
		end
	end
	function view.Message(message, bad)
		status.Text = tostring(message):gsub("[%z\1-\8]", "")
		status.TextColor3 = bad and color.Red or color.Muted
	end
	local overlay = create("Frame", panel, {
		Name = "LoadingStage",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = color.Background,
		BorderSizePixel = 0,
		ZIndex = 20,
		Visible = true,
		Active = true,
	})
	corner(overlay, 20)
	local loadingMark = pianoMark(overlay, 72)
	loadingMark.AnchorPoint = Vector2.new(0.5, 0.5)
	loadingMark.Position = UDim2.fromScale(0.5, 0.36)
	loadingMark.ZIndex = 21
	local loadingTitle = label(overlay, "LoadingTitle", "Auto Player", 30)
	loadingTitle.Font = Enum.Font.GothamBold
	loadingTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	loadingTitle.Position = UDim2.fromScale(0.5, 0.52)
	loadingTitle.Size = UDim2.new(1, -30, 0, 44)
	loadingTitle.TextXAlignment = Enum.TextXAlignment.Center
	loadingTitle.ZIndex = 21
	local loadingText = label(
		overlay,
		"LoadingPhase",
		"NULL / LOCAL MIDI STUDIO",
		12,
		color.Cyan
	)
	loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
	loadingText.Position = UDim2.fromScale(0.5, 0.62)
	loadingText.Size = UDim2.new(1, -32, 0, 36)
	loadingText.TextWrapped = true
	loadingText.TextXAlignment = Enum.TextXAlignment.Center
	loadingText.ZIndex = 21
	local loadingDismissed = false
	local dismiss = button(
		overlay,
		"HideLoading",
		"Hide loading view",
		function()
			loadingDismissed = true
			overlay.Visible = false
			overlay.Active = false
		end
	)
	dismiss.AnchorPoint = Vector2.new(0.5, 0.5)
	dismiss.Position = UDim2.fromScale(0.5, 0.76)
	dismiss.Size = UDim2.fromOffset(170, 40)
	dismiss.ZIndex = 21
	local strip = frame(overlay, "LoadingSweepTrack", color.Card)
	strip.Size = UDim2.fromOffset(180, 3)
	strip.AnchorPoint = Vector2.new(0.5, 0.5)
	strip.Position = UDim2.fromScale(0.5, 0.68)
	strip.ClipsDescendants = true
	strip.ZIndex = 21
	local sweep = frame(strip, "DecorativeSweep", color.Cyan)
	sweep.Size = UDim2.fromScale(0.3, 1)
	sweep.ZIndex = 22
	local closeLoading =
		button(overlay, "CloseLoadingPlayer", "Close player", "unload")
	closeLoading.AnchorPoint = Vector2.new(0.5, 0.5)
	closeLoading.Position = UDim2.fromScale(0.5, 0.88)
	closeLoading.Size = UDim2.fromOffset(170, 36)
	closeLoading.ZIndex = 21
	local loadingSerial, loadingBusy, loadingOperation = 0, false, nil
	local openingUntil, shownAt = os.clock() + 0.55, os.clock()
	function view.Loading(visible, phase, operationId)
		loadingSerial += 1
		local serial = loadingSerial
		if phase then
			loadingText.Text = phase
		end
		if visible then
			if
				not loadingBusy
				or (operationId ~= nil and operationId ~= loadingOperation)
			then
				loadingDismissed = false
				shownAt = os.clock()
			end
			loadingOperation = operationId
			loadingBusy = true
			-- Phase updates must not bring back a sheet the user dismissed.
			overlay.Visible = not loadingDismissed
			overlay.Active = not loadingDismissed
			if not loadingDismissed then
				loadingMark.Position = UDim2.fromScale(0.5, 0.32)
				sweep.Position = UDim2.fromScale(-0.3, 0)
				animate(sweep, 0.9, { Position = UDim2.fromScale(1.1, 0) })
				animate(
					loadingMark,
					0.45,
					{ Position = UDim2.fromScale(0.5, 0.36) }
				)
			end
		else
			loadingBusy = false
			-- Hold a fast real operation briefly so it doesn't flash on a tap.
			-- No tween completion/texture is needed to remove the input blocker.
			local delay = view.ReducedMotion and 0
				or math.max(
					0,
					openingUntil - os.clock(),
					shownAt + 0.18 - os.clock()
				)
			local function hide()
				if view.Alive and serial == loadingSerial then
					overlay.Visible = false
					overlay.Active = false
				end
			end
			if delay == 0 then
				hide()
			else
				task.delay(delay, hide)
			end
		end
	end
	local trackRows = {}
	function view.Tracks(tracks, muted)
		rowHeights.Mixer = trackStart
		for index = 1, math.max(#trackRows, #(tracks or {})) do
			local track = tracks and tracks[index]
			local item = trackRows[index]
			if track and not item then
				local row = settingRow(mixer, "Track", "")
				local control = button(
					row,
					"Track" .. index,
					"ACTIVE",
					function()
						local active = trackRows[index].Track
						if active then
							view.Dispatch("track", active.Index)
						end
					end
				)
				control.Size = UDim2.fromOffset(88, 40)
				control.Position = UDim2.new(1, -100, 0.5, -20)
				item = { Row = row, Control = control }
				trackRows[index] = item
			end
			if item then
				item.Track = track
				item.Row.Visible = track ~= nil
				if track then
					item.Row.Position =
						UDim2.fromOffset(12, trackStart + (index - 1) * 86)
					item.Row:FindFirstChild("Heading").Text = track.Name ~= ""
							and track.Name
						or "Track " .. track.Index
					item.Row:FindFirstChild("Detail").Text = track.Notes
						.. " notes / tap to mute or unmute"
					item.Control.Text = muted[track.Index] and "MUTED"
						or "ACTIVE"
				end
			end
		end
		mixer.CanvasSize =
			UDim2.fromOffset(0, trackStart + #(tracks or {}) * 86 + 12)
	end
	function view.Files(entries, selected, queuePage, pageNumber, pageCount)
		listHeading.Text = (queuePage and "YOUR QUEUE" or "YOUR LIBRARY")
			.. " / "
			.. pageNumber
			.. "/"
			.. pageCount
		empty.Visible = #entries == 0
		empty.Text = queuePage
				and "Your queue is empty. Select a local song and choose + Queue."
			or "No matching MIDI files. Refresh or change the folder in Settings."
		for index = 1, 24 do
			local row = view.Rows[index]
			if not row then
				local object = button(list, "SongRow" .. index, "", function()
					local item = view.Rows[index].Entry
					if item then
						view.Dispatch("select", item)
					end
				end)
				object.Position = UDim2.fromOffset(0, (index - 1) * 58)
				object.Size = UDim2.new(1, -6, 0, 52)
				local name = label(object, "FileName", "", 12)
				name.Position = UDim2.fromOffset(10, 6)
				name.Size = UDim2.new(1, -20, 0, 21)
				local detail = label(object, "Folder", "", 9, color.Muted)
				detail.Position = UDim2.fromOffset(10, 29)
				detail.Size = UDim2.new(1, -20, 0, 17)
				row = { Object = object, Name = name, Detail = detail }
				view.Rows[index] = row
			end
			row.Entry = entries[index]
			row.Object.Visible = row.Entry ~= nil
			if row.Entry then
				row.Name.Text = row.Entry.Name
				row.Detail.Text = row.Entry.Folder or row.Entry.Path
				row.Object.BackgroundColor3 = selected == row.Entry.Path
						and Color3.fromRGB(69, 54, 39)
					or color.Card
			end
		end
		list.CanvasSize = UDim2.fromOffset(0, math.max(80, #entries * 58))
		list.CanvasPosition = Vector2.new(0, 0)
	end
	function view.Keyboard(mode88)
		for _, key in pairs(view.Keys) do
			key:Destroy()
		end
		table.clear(view.Keys)
		table.clear(view.KeyCaptions)
		view.KeyGeometry = {}
		local low, high = mode88 and 21 or 36, mode88 and 108 or 96
		local black =
			{ [1] = true, [3] = true, [6] = true, [8] = true, [10] = true }
		local whiteCount = 0
		for pitch = low, high do
			if not black[pitch % 12] then
				whiteCount += 1
			end
		end
		local offset = 0
		for pitch = low, high do
			local dark = black[pitch % 12]
			local key = create("Frame", keyboard, {
				Name = "Key" .. pitch,
				BackgroundColor3 = dark and color.Background or color.Text,
				BorderSizePixel = 0,
				Size = UDim2.new(
					(dark and 0.58 or 0.95) / whiteCount,
					0,
					dark and 0.62 or 1,
					0
				),
				Position = UDim2.fromScale(
					(offset - (dark and 0.29 or 0)) / whiteCount,
					0
				),
				ZIndex = dark and 3 or 2,
			})
			corner(key, 2)
			local token = context.MidiOutput and context.MidiOutput.Map(pitch)
			if token then
				local caption = label(
					key,
					"Binding",
					token.Label,
					8,
					dark and color.Text or color.Background
				)
				caption.Position = UDim2.new(0, 0, 1, -12)
				caption.Size = UDim2.new(1, 0, 0, 12)
				caption.TextXAlignment = Enum.TextXAlignment.Center
				caption.ZIndex = key.ZIndex + 1
				view.KeyCaptions[pitch] = caption
			end
			view.KeyGeometry[pitch] = {
				X = (offset - (dark and 0.29 or 0)) / whiteCount,
				Width = (dark and 0.58 or 0.95) / whiteCount,
			}
			view.Keys[pitch] = key
			key:SetAttribute("DarkKey", dark == true)
			if not dark then
				offset += 1
			end
		end
		modeLabel.Text = mode88 and "88-KEY EXTENSION / A0 - C8"
			or "61-KEY VIRTUAL PIANO / C2 - C7"
	end
	view.Keyboard(false)
	local function time(seconds)
		seconds = math.max(0, math.floor(seconds))
		return string.format(
			"%02d:%02d",
			math.floor(seconds / 60),
			seconds % 60
		)
	end
	function view.Score(score, name)
		song.Text = name
		miniTitle.Text = name
		stageTag.Text = "LOCAL MIDI / " .. #score.Tracks .. " TRACKS"
		meta.Text = #score.Notes
			.. " notes  /  "
			.. #score.Tempos
			.. " tempo markers  /  "
			.. time(score.Duration)
	end
	function view.Snapshot(player, output)
		view.Playing = player.State == "Playing"
		miniPlay.Text = view.Playing and "Pause" or "Play"
		if view.BackendStatus then
			view.BackendStatus(output)
		end
		if not view.Visible then
			return
		end
		clockLabel.Text = time(player.Position)
			.. " / "
			.. time(player.Score and player.Score.Duration or 0)
		stateLabel.Text = player.Preview and "PREVIEW / NO GAME INPUT"
			or player.Armed and "ARMED / " .. player.State:upper()
			or "INPUT OFF / " .. player.State:upper()
		seekFill.Size = UDim2.fromScale(
			player.Score
					and player.Position / math.max(0.001, player.Score.Duration)
				or 0,
			1
		)
		local pressed = {}
		for _, pitch in pairs(player.Active) do
			local token = output.Map(pitch)
			if token then
				pressed[token.Pitch] = true
			end
		end
		for _, token in pairs(output.Held or {}) do
			pressed[token.Pitch] = true
		end
		for pitch, key in pairs(view.Keys) do
			local caption = view.KeyCaptions[pitch]
			if caption then
				caption.TextColor3 = (
					pressed[pitch] or not key:GetAttribute("DarkKey")
				)
						and color.Background
					or color.Text
			end
			key.BackgroundColor3 = pressed[pitch] and color.Cyan
				or key:GetAttribute("DarkKey") and color.Background
				or color.Text
		end
		for _, bar in ipairs(view.Bars) do
			bar.Visible = false
		end
		if not player.Score then
			return
		end
		local tempos = player.Score.Tempos
		local tempoIndex, tempoHigh = 1, #tempos
		while tempoIndex < tempoHigh do
			local middle = math.ceil((tempoIndex + tempoHigh) / 2)
			if tempos[middle].Time <= player.Position then
				tempoIndex = middle
			else
				tempoHigh = middle - 1
			end
		end
		meta.Text = string.format(
			"%d notes / %.1f BPM / %.2fx / %d skipped events",
			#player.Score.Notes,
			tempos[tempoIndex].BPM,
			player.Speed,
			player.Dropped
		)
		local notes = player.Score.Notes
		local low, high = 1, #notes + 1
		while low < high do
			local middle = math.floor((low + high) / 2)
			if notes[middle].Start < player.Position - 1 then
				low = middle + 1
			else
				high = middle
			end
		end
		local count = 0
		for index = low, math.min(#notes, low + 256) do
			local note = notes[index]
			if note.Start > player.Position + 4 then
				break
			end
			local noteEnd = player.Sustain and note.End or note.RawEnd
			local effectiveEnd = note.Start
				+ (noteEnd - note.Start) * player.Gate
			if
				effectiveEnd <= player.Position
				or player.Muted[note.Track]
				or (note.Channel == 9 and not player.Drums)
				or note.Velocity < player.MinimumVelocity
			then
				continue
			end
			local token = output.Map(note.Pitch + player.Transpose)
			if token then
				count += 1
				if count > #view.Bars then
					break
				end
				local start = math.max(0, note.Start - player.Position)
				local ending = math.min(4, effectiveEnd - player.Position)
				local bar = view.Bars[count]
				local geometry = view.KeyGeometry[token.Pitch]
				bar.Position = UDim2.fromScale(geometry.X, 1 - ending / 4)
				bar.Size = UDim2.new(
					geometry.Width,
					-1,
					math.max(0.006, (ending - start) / 4),
					0
				)
				bar.Visible = true
			end
		end
	end
	function view.SetPage(name)
		view.Page = name
		rail.Visible = name == "Library" or name == "Queue"
		stage.Visible = rail.Visible
		for pageName, page in pairs(pages) do
			page.Visible = pageName == name
		end
		for pageName, object in pairs(navButtons) do
			object.TextColor3 = name == pageName and color.Text or color.Muted
			object.BackgroundColor3 = name == pageName and color.Card
				or color.Background
			local marker = object:FindFirstChild("SelectedTab")
			if marker then
				marker.Visible = name == pageName
			end
		end
		view.Dispatch("tab", name)
	end
	for index, name in ipairs({
		"Library",
		"Queue",
		"Mixer",
		"Keys",
		"Settings",
	}) do
		local object = button(nav, name, name, function()
			view.SetPage(name)
		end)
		object.Size = UDim2.new(0.2, -4, 1, 0)
		object.Position = UDim2.new((index - 1) * 0.2, 0, 0, 0)
		local outline = object:FindFirstChildOfClass("UIStroke")
		if outline then
			outline.Transparency = 1
		end
		create("Frame", object, {
			Name = "SelectedTab",
			BackgroundColor3 = color.Cyan,
			BorderSizePixel = 0,
			Position = UDim2.new(0.2, 0, 1, -2),
			Size = UDim2.new(0.6, 0, 0, 2),
			Visible = false,
		})
		navButtons[name] = object
	end
	local keyHelp = label(
		keysPage,
		"PianoKeyHelp",
		"61-key layout from your screenshot. Keep the GAME piano open and its CAPS off. White keys: 1234567890qwertyuiopasdfghjklzxcvbnm. Black keys use Shift. Tap a note below while armed/paused; it sends real input, not local demo sound.",
		12,
		color.Text
	)
	keyHelp.Position = UDim2.fromOffset(12, 8)
	keyHelp.Size = UDim2.new(1, -24, 0, 110)
	keyHelp.TextWrapped = true
	keyHelp.TextTruncate = Enum.TextTruncate.None
	local backendInfo = label(
		keysPage,
		"PianoBackendStatus",
		"Checking input APIs",
		11,
		color.Cyan
	)
	backendInfo.Position = UDim2.fromOffset(12, 120)
	backendInfo.Size = UDim2.new(1, -24, 0, 46)
	backendInfo.TextWrapped = true
	backendInfo.TextTruncate = Enum.TextTruncate.None
	local backendButtons = {}
	for index, spec in ipairs({
		{ "Auto", "Auto" },
		{ "VIM", "VIM" },
		{ "VK", "Keys / VK" },
		{ "Enum", "Keys / Enum" },
	}) do
		local control = button(
			keysPage,
			"Backend" .. spec[1],
			spec[2],
			function()
				view.Dispatch("backend", spec[1])
			end
		)
		control.Position = UDim2.new((index - 1) * 0.25, 8, 0, 174)
		control.Size = UDim2.new(0.25, -12, 0, 40)
		control.TextSize = 11
		backendButtons[spec[1]] = control
	end
	local profile = button(
		keysPage,
		"Screenshot61Profile",
		"Use screenshot's 61 keys / reset transpose",
		"profile61"
	)
	profile.Position = UDim2.fromOffset(12, 224)
	profile.Size = UDim2.new(1, -24, 0, 40)
	profile.TextSize = 11
	for pitch = 36, 96 do
		local token = context.MidiOutput and context.MidiOutput.Map(pitch)
		local text = token and (token.NoteName .. " / " .. token.Binding)
			or "MIDI " .. pitch
		local control = button(
			keysPage,
			"TryPianoKey" .. pitch,
			text,
			function()
				view.Dispatch("testnote", pitch)
			end
		)
		local index = pitch - 36
		control.Position =
			UDim2.new((index % 3) / 3, 8, 0, 278 + math.floor(index / 3) * 48)
		control.Size = UDim2.new(1 / 3, -12, 0, 40)
		control.TextSize = 11
	end
	keysPage.CanvasSize = UDim2.fromOffset(0, 278 + 21 * 48 + 12)
	view.BackendStatus = function(output)
		backendInfo.Text = (output.Backend or "Unavailable")
			.. " / "
			.. (output.Requests or 0)
			.. " API requests / "
			.. (output.Errors or 0)
			.. " errors. No sound? Try VIM, VK, then Enum."
		for mode, control in pairs(backendButtons) do
			control.TextColor3 = mode == output.Preferred and color.Cyan
				or color.Text
		end
	end
	view.Toggle(
		settings,
		"Arm on launch",
		"Ready for manual Play on launch. STOP INPUT still disarms immediately.",
		true,
		"autoarm"
	)
	local storageRow = settingRow(
		settings,
		"Your saved setup",
		"Profile, favorites, queue and placement stay on this device."
	)
	local saveButton = button(storageRow, "SavePlayerSetup", "Save", "save")
	saveButton.Position = UDim2.new(1, -100, 0.5, -20)
	saveButton.Size = UDim2.fromOffset(88, 40)
	local storageStatus = storageRow:FindFirstChild("Detail")
	view.Persistence = function(text)
		storageStatus.Text = text
	end
	local centerRow = settingRow(
		settings,
		"Window placement",
		"Return the player to the center with its holder below."
	)
	local centerButton = button(centerRow, "CenterPlayer", "Center", "center")
	centerButton.Position = UDim2.new(1, -100, 0.5, -20)
	centerButton.Size = UDim2.fromOffset(88, 40)
	local testRow = settingRow(
		settings,
		"Input test / F7 panic",
		"F8 play/pause. Never auto-resumes after text entry."
	)
	local testButton = button(testRow, "TestInput", "Test C4", "test")
	testButton.Size = UDim2.fromOffset(88, 40)
	testButton.Position = UDim2.new(1, -100, 0.5, -20)
	local panicRow = settingRow(
		settings,
		"Emergency stop",
		"Disarm and retry all owned key releases. Also available as F7."
	)
	local panicButton =
		button(panicRow, "PanicInput", "STOP INPUT", "panic", color.Red)
	panicButton.Size = UDim2.fromOffset(100, 40)
	panicButton.Position = UDim2.new(1, -112, 0.5, -20)
	local clearRow = settingRow(
		settings,
		"Saved queue",
		"Stored locally with your player setup. Songs are never modified."
	)
	local clearButton = button(clearRow, "ClearQueue", "Clear", "clearqueue")
	clearButton.Size = UDim2.fromOffset(88, 40)
	clearButton.Position = UDim2.new(1, -100, 0.5, -20)
	local folderRow = settingRow(
		settings,
		"MIDI folder",
		"Requested Android folder; relative MIDI fallback only if listing is blocked."
	)
	folderRow.Size = UDim2.new(1, -24, 0, 122)
	rowHeights.Settings += 46
	local path = create("TextBox", folderRow, {
		Name = "MidiFolder",
		Text = "/storage/emulated/0/Delta/Workspace/MIDI/",
		ClearTextOnFocus = false,
		TextSize = 11,
		TextColor3 = color.Cyan,
		Font = Enum.Font.Gotham,
		BackgroundColor3 = color.Background,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(10, 76),
		Size = UDim2.new(1, -20, 0, 36),
	})
	corner(path, 8)
	context.Connect(path.FocusLost, function()
		view.Dispatch("folder", path.Text)
	end)
	settings.CanvasSize = UDim2.fromOffset(0, rowHeights.Settings + 18)
	local savedPlacement = context.MidiPreferences or {}
	view.Preferences = function(data)
		speed.Text = tostring(data.Speed)
		transpose.Text = tostring(data.Transpose)
		path.Text = data.Folder
		for name, value in pairs({
			velocity = data.Velocity,
			gate = data.Gate,
			delay = data.Delay,
		}) do
			if view.Inputs[name] then
				view.Inputs[name].Text = tostring(value)
			end
		end
	end
	local initialized = false
	local function layout()
		if not view.Alive then
			return
		end
		local size = root.AbsoluteSize
		if size.X < 1 or size.Y < 1 then
			return
		end
		local width, height =
			math.min(960, size.X - 24), math.min(680, size.Y - 24)
		panel.Size = UDim2.fromOffset(width, height)
		do
			local saved = savedPlacement.Panel
			panel.Position = UDim2.fromOffset(
				size.X * (saved and saved.X or 0.5),
				size.Y * (saved and saved.Y or 0.5)
			)
			initialized = true
		end
		local position = panel.Position
		panel.Position = UDim2.fromOffset(
			math.clamp(position.X.Offset, width / 2, size.X - width / 2),
			math.clamp(position.Y.Offset, height / 2, size.Y - height / 2)
		)
		do
			local saved = savedPlacement.Dock
			holder.Position = UDim2.fromOffset(
				size.X * (saved and saved.X or 0.5),
				saved and size.Y * saved.Y or size.Y - 116
			)
			dockPositioned = true
		end
		holder.Position = UDim2.fromOffset(
			math.clamp(
				holder.Position.X.Offset,
				134,
				math.max(134, size.X - 134)
			),
			math.clamp(holder.Position.Y.Offset, 46, math.max(46, size.Y - 46))
		)
		header.Position = UDim2.fromOffset(8, 8)
		header.Size = UDim2.new(1, -16, 0, 68)
		minimize.Size = UDim2.fromOffset(44, 40)
		minimize.Position = UDim2.new(1, -102, 0, 14)
		close.Size = UDim2.fromOffset(44, 40)
		close.Position = UDim2.new(1, -52, 0, 14)
		nav.Position = UDim2.fromOffset(14, 84)
		nav.Size = UDim2.new(1, -28, 0, 36)
		main.Position = UDim2.fromOffset(14, 130)
		main.Size = UDim2.new(1, -28, 1, -278)
		local short = height < 520
		local contentY = short and 108 or 130
		local transportReserve = short and 148 or 170
		main.Position = UDim2.fromOffset(14, contentY)
		main.Size = UDim2.new(1, -28, 1, -contentY - transportReserve)
		local contentWidth, contentHeight =
			width - 28, height - contentY - transportReserve
		local compact = width < 700 and not short
		local railWidth = short and math.min(210, (width - 40) * 0.42) or 276
		if short then
			header.Size = UDim2.new(1, -16, 0, 54)
			logo.Position = UDim2.fromOffset(14, 5)
			brand.Position = UDim2.fromOffset(70, 4)
			title.Position = UDim2.fromOffset(69, 19)
			nav.Position = UDim2.fromOffset(14, 68)
			nav.Size = UDim2.new(1, -28, 0, 32)
		end
		if compact then
			rail.Position = UDim2.fromOffset(0, 0)
			rail.Size = UDim2.new(1, 0, 0, math.max(184, contentHeight - 128))
			stage.Position =
				UDim2.fromOffset(0, math.max(184, contentHeight - 128) + 8)
			stage.Size = UDim2.new(1, 0, 1, -math.max(192, contentHeight - 120))
			-- Portrait focuses on song selection and the visual piano, with compact
			-- metadata. Mixer/settings retain full-width scrollable touch controls.
			stageTag.Visible = false
			song.Position = UDim2.fromOffset(12, 8)
			song.TextSize = 16
			song.Size = UDim2.new(1, -24, 0, 24)
			meta.Visible = false
			roll.Position = UDim2.fromOffset(10, 40)
			roll.Size = UDim2.new(1, -20, 1, -94)
		else
			rail.Position = UDim2.fromOffset(0, 0)
			rail.Size = UDim2.new(0, railWidth, 1, 0)
			stage.Position = UDim2.fromOffset(railWidth + 12, 0)
			stage.Size = UDim2.new(1, -railWidth - 12, 1, 0)
			stageTag.Visible = true
			song.Position = UDim2.fromOffset(16, 35)
			song.TextSize = 22
			song.Size = UDim2.new(1, -32, 0, 31)
			meta.Visible = true
			roll.Position = UDim2.fromOffset(14, 104)
			roll.Size = UDim2.new(1, -28, 1, -190)
		end
		if short then
			stageTag.Visible = false
			meta.Visible = false
			song.Position = UDim2.fromOffset(10, 6)
			song.TextSize = 14
			roll.Position = UDim2.fromOffset(10, 34)
			roll.Size = UDim2.new(1, -20, 1, -70)
		end
		keyboard.Position =
			UDim2.new(0, 12, 1, short and -30 or compact and -48 or -78)
		keyboard.Size =
			UDim2.new(1, -24, 0, short and 24 or compact and 34 or 48)
		modeLabel.Position = UDim2.new(0, 12, 1, -25)
		modeLabel.Size = UDim2.new(1, -110, 0, 18)
		modeLabel.Visible = not compact and not short
		audition.Position = UDim2.new(1, -94, 1, -28)
		audition.Size = UDim2.fromOffset(82, 22)
		audition.Visible = not compact and not short
		for _, page in pairs(pages) do
			page.Size = UDim2.fromScale(1, 1)
		end
		previousPage.Position = UDim2.new(0, 10, 1, -38)
		previousPage.Size = UDim2.fromOffset(38, 30)
		nextPage.Position = UDim2.new(1, -48, 1, -38)
		nextPage.Size = UDim2.fromOffset(38, 30)
		refresh.Position = UDim2.new(0, 56, 1, -38)
		refresh.Size = UDim2.new(1, -112, 0, 30)
		listHeading.Visible = not short
		search.Visible = not short
		list.Position = UDim2.fromOffset(8, short and 6 or 82)
		list.Size = UDim2.new(1, -16, 1, short and -48 or -126)
		footer.Position = UDim2.new(0, 14, 1, short and -140 or -162)
		footer.Size = UDim2.new(1, -28, 0, short and 82 or 104)
		local controlWidth = (contentWidth - 32) / 5
		for index, object in ipairs(transport) do
			object.Position =
				UDim2.fromOffset(8 + (index - 1) * (controlWidth + 4), 28)
			object.Size = UDim2.fromOffset(controlWidth, short and 32 or 44)
		end
		clockLabel.Position = UDim2.fromOffset(12, short and 63 or 80)
		clockLabel.Size = UDim2.new(0.5, 0, 0, 16)
		stateLabel.Position = UDim2.new(0.4, 0, 0, short and 63 or 80)
		stateLabel.Size = UDim2.new(0.6, -12, 0, 16)
		stateLabel.TextXAlignment = Enum.TextXAlignment.Right
		bottom.Position = UDim2.new(0, 14, 1, -52)
		bottom.Size = UDim2.new(1, -28, 0, 30)
		speedTitle.Position = UDim2.fromOffset(0, 0)
		speedTitle.Size = UDim2.fromOffset(44, 10)
		speed.Position = UDim2.fromOffset(0, 10)
		speed.Size = UDim2.fromOffset(44, 24)
		pitchTitle.Position = UDim2.fromOffset(50, 0)
		pitchTitle.Size = UDim2.fromOffset(58, 10)
		transpose.Position = UDim2.fromOffset(50, 10)
		transpose.Size = UDim2.fromOffset(48, 24)
		local smallWidth = math.max(43, (contentWidth - 110) / 4 - 4)
		for index, object in ipairs({ addQueue, favorite, loopA, loopB }) do
			object.Position =
				UDim2.fromOffset(106 + (index - 1) * (smallWidth + 4), 4)
			object.Size = UDim2.fromOffset(smallWidth, 28)
			object.TextSize = compact and 10 or 12
		end
		status.Position = UDim2.new(0, 14, 1, -16)
		status.Size = UDim2.new(1, -28, 0, 14)
	end
	view.Placement = function()
		local size = root.AbsoluteSize
		if size.X > 0 and size.Y > 0 and view.Alive then
			view.LastPlacement = {
				Panel = {
					X = panel.Position.X.Offset / size.X,
					Y = panel.Position.Y.Offset / size.Y,
				},
				Dock = {
					X = holder.Position.X.Offset / size.X,
					Y = holder.Position.Y.Offset / size.Y,
				},
			}
		end
		if view.LastPlacement then
			savedPlacement.Panel = view.LastPlacement.Panel
			savedPlacement.Dock = view.LastPlacement.Dock
		end
		return view.LastPlacement
			or { Panel = savedPlacement.Panel, Dock = savedPlacement.Dock }
	end
	view.Center = function()
		savedPlacement.Panel, savedPlacement.Dock = nil, nil
		initialized, dockPositioned = false, false
		layout()
		view.Placement()
	end
	context.Connect(root:GetPropertyChangedSignal("AbsoluteSize"), layout)
	local dragging, dragStart, dragPosition = false, nil, nil
	context.Connect(header.InputBegan, function(event)
		if
			event.UserInputType == Enum.UserInputType.MouseButton1
			or event.UserInputType == Enum.UserInputType.Touch
		then
			dragging = event
			dragStart = event.Position
			dragPosition = panel.Position
		end
	end)
	context.Connect(input.InputChanged, function(event)
		if
			dragging
			and (
				event == dragging
				or event.UserInputType == Enum.UserInputType.MouseMovement
			)
		then
			local delta = event.Position - dragStart
			local width, height = panel.AbsoluteSize.X, panel.AbsoluteSize.Y
			panel.Position = UDim2.fromOffset(
				math.clamp(
					dragPosition.X.Offset + delta.X,
					width / 2,
					root.AbsoluteSize.X - width / 2
				),
				math.clamp(
					dragPosition.Y.Offset + delta.Y,
					height / 2,
					root.AbsoluteSize.Y - height / 2
				)
			)
		end
	end)
	context.Connect(input.InputEnded, function(event)
		if event == dragging then
			dragging = false
			view.Placement()
			view.Dispatch("placement")
		end
	end)
	local dockDrag, dockStart, dockPosition
	context.Connect(holder.InputBegan, function(event)
		if
			event.UserInputType == Enum.UserInputType.MouseButton1
			or event.UserInputType == Enum.UserInputType.Touch
		then
			dockDrag = event
			dockStart = event.Position
			dockPosition = holder.Position
			dockMoved = false
		end
	end)
	context.Connect(input.InputChanged, function(event)
		if
			dockDrag
			and (
				event == dockDrag
				or event.UserInputType == Enum.UserInputType.MouseMovement
			)
		then
			local delta = event.Position - dockStart
			if delta.Magnitude > 5 then
				dockMoved = true
			end
			if dockMoved then
				holder.Position = UDim2.fromOffset(
					math.clamp(
						dockPosition.X.Offset + delta.X,
						134,
						math.max(134, root.AbsoluteSize.X - 134)
					),
					math.clamp(
						dockPosition.Y.Offset + delta.Y,
						46,
						math.max(46, root.AbsoluteSize.Y - 46)
					)
				)
			end
		end
	end)
	context.Connect(input.InputEnded, function(event)
		if event == dockDrag then
			dockDrag = nil
			view.Placement()
			view.Dispatch("placement")
			task.delay(0.1, function()
				if view.Alive then
					dockMoved = false
				end
			end)
		end
	end)
	context.Connect(gui.Destroying, function()
		if view.Alive then
			context.Library:Unload()
		end
	end)
	layout()
	view.Placement()
	view.SetPage("Library")
	animate(openingScale, 0.6, { Scale = 1 })
	-- Standalone construction also has a finite opening, even without a scan.
	view.Loading(false)
	return view
end
