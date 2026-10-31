-- Bespoke NULL MIDI control room. Native geometry, no image/font downloads.
-- Static piano dock; finite opening/loading tweens; pooled waterfall and rows.
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
		Page = "Library",
		ReducedMotion = context.ReducedMotion,
		Tweens = {},
	}
	local color = {
		Background = Color3.fromRGB(8, 12, 24),
		Panel = Color3.fromRGB(15, 22, 39),
		Card = Color3.fromRGB(23, 33, 53),
		Border = Color3.fromRGB(44, 60, 86),
		Text = Color3.fromRGB(230, 242, 255),
		Muted = Color3.fromRGB(143, 164, 191),
		Cyan = Color3.fromRGB(86, 226, 234),
		Violet = Color3.fromRGB(171, 136, 255),
		Red = Color3.fromRGB(255, 118, 139),
	}
	local gui = Instance.new("ScreenGui")
	gui.Name = "Nullx11AutoPlayer"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.DisplayOrder = 350
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local ok, host = pcall(function()
		if type(gethui) == "function" then
			return gethui()
		end
		return game:GetService("CoreGui")
	end)
	if not ok or not host then
		host = game:GetService("Players").LocalPlayer
			:WaitForChild("PlayerGui", 5)
	end
	assert(host, "No permitted GUI host")
	gui.Parent = host
	view.Gui = gui
	local function create(class, parent, props)
		local object = Instance.new(class)
		for key, value in pairs(props or {}) do
			object[key] = value
		end
		object.Parent = parent
		return object
	end
	local function corner(object, radius)
		create("UICorner", object, { CornerRadius = UDim.new(0, radius or 12) })
	end
	local function stroke(object, accent)
		create("UIStroke", object, {
			Color = accent or color.Border,
			Thickness = 1,
			Transparency = 0.2,
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
		if view.ReducedMotion then
			for key, value in pairs(props) do
				object[key] = value
			end
			return
		end
		local previous = view.Tweens[object]
		if previous then
			previous:Cancel()
		end
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
	local panel = create("CanvasGroup", root, {
		Name = "AutoPlayerPanel",
		BackgroundColor3 = color.Background,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		GroupTransparency = 1,
	})
	corner(panel, 20)
	stroke(panel)
	create("UIGradient", panel, {
		Rotation = 30,
		Color = ColorSequence.new(color.Background, Color3.fromRGB(19, 23, 48)),
	})
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
	local brand = label(
		header,
		"Brand",
		"DEVELOPED BY NULL / MIDI STUDIO",
		10,
		color.Cyan
	)
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
		label(rail, "ListHeading", "YOUR MIDI LIBRARY", 11, color.Muted)
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
	local stageTag = label(
		stage,
		"StageTag",
		"LOCAL FILE / AWAITING SELECTION",
		10,
		color.Cyan
	)
	stageTag.Position = UDim2.fromOffset(16, 12)
	stageTag.Size = UDim2.new(1, -32, 0, 18)
	local song = label(stage, "SongTitle", "Make room for your next piece.", 22)
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
	local mixer, settings = scrollPage("Mixer"), scrollPage("Settings")
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
	local dockMoved = false
	local dock = button(root, "PianoDock", "", function()
		if not dockMoved then
			view.SetVisible(not view.Visible)
		end
	end)
	dock.Size = UDim2.fromOffset(56, 56)
	dock.Position = UDim2.new(0, 12, 0.5, -28)
	dock.Visible = false
	local dockPiano = pianoMark(dock, 44)
	dockPiano.Position = UDim2.fromOffset(6, 6)
	dockPiano.Active = false
	function view.SetVisible(value)
		view.Visible = value
		panel.Visible = value
		dock.Visible = not value
		if value then
			animate(openingScale, 0.3, { Scale = 1 })
			animate(panel, 0.25, { GroupTransparency = 0 })
		end
	end
	function view.Message(message, bad)
		status.Text = tostring(message):gsub("[%z\1-\8]", "")
		status.TextColor3 = bad and color.Red or color.Muted
	end
	local overlay = create("CanvasGroup", panel, {
		Name = "LoadingStage",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = color.Background,
		BorderSizePixel = 0,
		ZIndex = 20,
		GroupTransparency = 0,
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
	local dismiss = button(
		overlay,
		"HideLoading",
		"Hide loading view",
		function()
			overlay.Visible = false
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
	local loadingSerial = 0
	function view.Loading(visible, phase)
		loadingSerial += 1
		local serial = loadingSerial
		if phase then
			loadingText.Text = phase
		end
		if visible then
			overlay.Visible = true
			animate(overlay, 0.15, { GroupTransparency = 0 })
			loadingMark.Position = UDim2.fromScale(0.5, 0.32)
			sweep.Position = UDim2.fromScale(-0.3, 0)
			animate(sweep, 0.9, { Position = UDim2.fromScale(1.1, 0) })
			animate(
				loadingMark,
				0.45,
				{ Position = UDim2.fromScale(0.5, 0.36) }
			)
		else
			animate(overlay, 0.3, { GroupTransparency = 1 })
			task.delay(view.ReducedMotion and 0 or 0.31, function()
				if view.Alive and serial == loadingSerial then
					overlay.Visible = false
				end
			end)
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
		listHeading.Text = (
			queuePage and "SESSION QUEUE" or "YOUR MIDI LIBRARY"
		)
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
						and Color3.fromRGB(37, 65, 81)
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
		stageTag.Text = "LOCAL MIDI / " .. #score.Tracks .. " TRACKS"
		meta.Text = #score.Notes
			.. " notes  /  "
			.. #score.Tempos
			.. " tempo markers  /  "
			.. time(score.Duration)
	end
	function view.Snapshot(player, output)
		if not view.Visible then
			return
		end
		clockLabel.Text = time(player.Position)
			.. " / "
			.. time(player.Score and player.Score.Duration or 0)
		stateLabel.Text = player.Preview and "PREVIEW / NO GAME INPUT"
			or player.Armed and "ARMED / " .. player.State:upper()
			or "DISARMED / " .. player.State:upper()
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
		for pitch, key in pairs(view.Keys) do
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
			object.TextColor3 = name == pageName and color.Cyan or color.Muted
		end
		view.Dispatch("tab", name)
	end
	for index, name in ipairs({ "Library", "Queue", "Mixer", "Settings" }) do
		local object = button(nav, name, name, function()
			view.SetPage(name)
		end)
		object.Size = UDim2.new(0.25, -6, 1, 0)
		object.Position = UDim2.new((index - 1) * 0.25, 0, 0, 0)
		navButtons[name] = object
	end
	local testRow = settingRow(
		settings,
		"Input test / F7 panic",
		"F8 play/pause. Never auto-resumes after text entry."
	)
	local testButton = button(testRow, "TestInput", "Test C4", "test")
	testButton.Size = UDim2.fromOffset(88, 40)
	testButton.Position = UDim2.new(1, -100, 0.5, -20)
	local clearRow = settingRow(
		settings,
		"Session queue",
		"In memory only; no files are deleted or written."
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
			math.min(1040, size.X - 16), math.min(750, size.Y - 16)
		panel.Size = UDim2.fromOffset(width, height)
		if not initialized then
			panel.Position = UDim2.fromOffset(size.X / 2, size.Y / 2)
			initialized = true
		end
		local position = panel.Position
		panel.Position = UDim2.fromOffset(
			math.clamp(position.X.Offset, width / 2, size.X - width / 2),
			math.clamp(position.Y.Offset, height / 2, size.Y - height / 2)
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
		main.Position = UDim2.fromOffset(14, contentY)
		main.Size = UDim2.new(1, -28, 1, -contentY - 148)
		local contentWidth, contentHeight = width - 28, height - contentY - 148
		local compact = width < 700 and not short
		local railWidth = short and math.min(210, (width - 40) * 0.42) or 258
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
			rail.Size = UDim2.new(1, 0, 0, math.max(184, contentHeight * 0.42))
			stage.Position =
				UDim2.fromOffset(0, math.max(184, contentHeight * 0.42) + 8)
			stage.Size =
				UDim2.new(1, 0, 1, -math.max(192, contentHeight * 0.42 + 8))
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
		footer.Position = UDim2.new(0, 14, 1, -140)
		footer.Size = UDim2.new(1, -28, 0, 82)
		local controlWidth = (contentWidth - 32) / 5
		for index, object in ipairs(transport) do
			object.Position =
				UDim2.fromOffset(8 + (index - 1) * (controlWidth + 4), 28)
			object.Size = UDim2.fromOffset(controlWidth, 32)
		end
		clockLabel.Position = UDim2.fromOffset(12, 63)
		clockLabel.Size = UDim2.new(0.5, 0, 0, 16)
		stateLabel.Position = UDim2.new(0.4, 0, 0, 63)
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
		end
	end)
	local dockDrag, dockStart, dockPosition
	context.Connect(dock.InputBegan, function(event)
		if
			event.UserInputType == Enum.UserInputType.MouseButton1
			or event.UserInputType == Enum.UserInputType.Touch
		then
			dockDrag = event
			dockStart = event.Position
			dockPosition = dock.AbsolutePosition
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
				dock.Position = UDim2.fromOffset(
					math.clamp(
						dockPosition.X + delta.X - root.AbsolutePosition.X,
						0,
						math.max(0, root.AbsoluteSize.X - 56)
					),
					math.clamp(
						dockPosition.Y + delta.Y - root.AbsolutePosition.Y,
						0,
						math.max(0, root.AbsoluteSize.Y - 56)
					)
				)
			end
		end
	end)
	context.Connect(input.InputEnded, function(event)
		if event == dockDrag then
			dockDrag = nil
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
	context.RegisterCleanup(function()
		view.Alive = false
		loadingSerial += 1
		for _, tween in pairs(view.Tweens) do
			pcall(tween.Cancel, tween)
		end
		table.clear(view.Tweens)
		gui:Destroy()
	end)
	layout()
	view.SetPage("Library")
	animate(panel, 0.6, { GroupTransparency = 0 })
	animate(openingScale, 0.6, { Scale = 1 })
	return view
end
