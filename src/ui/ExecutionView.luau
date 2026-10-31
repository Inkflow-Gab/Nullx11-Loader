-- Injected into the shared UI factory: responsive, event-driven execution sheet.
function Library:BeginExecution(title)
	if self.Unloaded then
		return nil
	end
	if self.Execution then
		self.Execution:Close()
	end
	-- Separate ScreenGui: a newly-created game UI must not cover initialization.
	local executionGui = Draw.New("ScreenGui", {
		Name = "Nullx11ExecutionOverlay",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = math.max(1000, State.Gui.DisplayOrder + 1),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = State.Gui.Parent,
	})
	local shade = Draw.New("TextButton", {
		Name = "ExecutionLoading",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.36,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 72,
		Parent = executionGui,
	})
	local card = Draw.Box("Frame", {
		Name = "ExecutionCard",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -32, 1, -32),
		Visible = true,
		ZIndex = 73,
		Parent = shade,
	}, "Panel", "Outline", 20, 1)
	Draw.New(
		"UISizeConstraint",
		{ MaxSize = Vector2.new(520, 420), Parent = card }
	)
	local scroll = Draw.New("ScrollingFrame", {
		Name = "ExecutionContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.fromOffset(0, 402),
		ScrollBarThickness = 3,
		Parent = card,
	})
	local emblem = Draw.Emblem(scroll, 48)
	emblem.Position = UDim2.fromOffset(24, 22)
	local function text(name, value, x, y, height, size, token)
		return Draw.Text({
			Name = name,
			Text = value,
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.new(1, -x - 24, 0, height),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = scroll,
		}, "Body", size, token or "Text")
	end
	text("Developer", "NULLX11 / NULL", 86, 22, 18, 14, "Muted")
	text("ScriptName", title, 86, 44, 26, 19)
	local status =
		text("ExecutionStatus", "Preparing execution", 24, 90, 26, 18)
	local detail = text("ExecutionDetail", "", 24, 120, 62, 14, "SubText")
	detail.TextWrapped, detail.TextTruncate = true, Enum.TextTruncate.None
	local track = Draw.Box("Frame", {
		Name = "ExecutionTrack",
		Position = UDim2.fromOffset(24, 198),
		Size = UDim2.new(1, -48, 0, 5),
		Parent = scroll,
	}, "Track", nil, 3)
	local fill = Draw.Box("Frame", {
		Name = "ExecutionProgress",
		Size = UDim2.fromScale(0, 1),
		Parent = track,
	}, "Accent", nil, 3)
	Draw.New("UIGradient", {
		Color = ColorSequence.new(
			Color3.fromRGB(164, 143, 255),
			Color3.fromRGB(96, 220, 224)
		),
		Parent = fill,
	})
	local labels, marks = {}, {}
	for index, name in ipairs({
		"Download",
		"Validate source",
		"Compile Luau",
		"Initialize script",
	}) do
		marks[index] = Draw.Box("Frame", {
			Position = UDim2.fromOffset(26, 221 + (index - 1) * 27),
			Size = UDim2.fromOffset(7, 7),
			Parent = scroll,
		}, "Muted", nil, 4)
		labels[index] = text(
			"ExecutionStage" .. index,
			name,
			44,
			214 + (index - 1) * 27,
			22,
			14,
			"SubText"
		)
	end
	local close = Draw.Box("TextButton", {
		Name = "ExecutionDismiss",
		Text = "Cancel download",
		AutoButtonColor = false,
		Position = UDim2.fromOffset(24, 342),
		Size = UDim2.new(1, -48, 0, 40),
		Parent = scroll,
	}, "Element", "Outline", 10, 1)
	close.Font, close.TextSize = Enum.Font.GothamMedium, 14
	Theme.Bind(close, { TextColor3 = "Text" })
	local job = { Closed = false }
	local function render(model)
		if job.Closed or not shade.Parent then
			return
		end
		local names = {
			"Downloading source",
			"Validating response",
			"Compiling Luau",
			"Initializing script",
		}
		status.Text = model.Status == "failed" and "Execution failed"
			or model.Status == "complete" and "Client initialization returned"
			or names[model.PhaseIndex]
		detail.Text = model.Detail
		close.Text = model.Status ~= "running" and "Close"
			or model.Started and "Hide / keep script running"
			or "Cancel execution"
		Anim.Tween(
			fill,
			{ Size = UDim2.fromScale(model.Completed / 4, 1) },
			0.22,
			"Out"
		)
		for index, label in ipairs(labels) do
			label.Text = (
				index <= model.Completed and "Done / "
				or index == model.PhaseIndex and "Current / "
				or "Next / "
			)
				.. ({
					"Download",
					"Validate source",
					"Compile Luau",
					"Initialize script",
				})[index]
			Theme.Bind(marks[index], {
				BackgroundColor3 = index <= model.Completed and "Accent"
					or "Muted",
			})
		end
	end
	job.Model = makeExecutionState(render)
	function job:Phase(index, message)
		return self.Model:Phase(index, message)
	end
	function job:CanContinue()
		return not self.Closed and self.Model:CanContinue()
	end
	function job:Close()
		if self.Closed then
			return
		end
		self.Model:Dismiss()
		self.Closed = true
		Theme.UnbindTree(executionGui)
		executionGui:Destroy()
		if Library.Execution == self then
			Library.Execution = nil
		end
	end
	function job:Finish(ready)
		self.Model:Finish()
		if ready then
			self:Close()
			return
		end
		task.delay(1.2, function()
			if not self.Closed then
				self:Close()
			end
		end)
	end
	function job:Fail(reason)
		self.Model:Fail(reason)
	end
	close.Activated:Connect(function()
		job:Close()
	end)
	Library.Execution = job
	if not Library.ExecutionCleanupInstalled then
		Library.ExecutionCleanupInstalled = true
		Library:OnUnload(function()
			if Library.Execution then
				Library.Execution:Close()
			end
		end)
	end
	local scale = Draw.New("UIScale", { Scale = 0.96, Parent = card })
	pcall(Anim.Tween, scale, { Scale = 1 }, 0.22, "Out")
	scale.Scale = 1
	return job
end
