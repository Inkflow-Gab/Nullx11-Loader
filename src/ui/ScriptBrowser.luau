-- A real native browser, not a screenshot or a second upstream UI.
-- Cards are reused on search; refresh removes obsolete instances/subscriptions.
function Library:CreateScriptBrowser(tab, options)
	local model = makeScriptLibraryModel
	local browser = {
		Query = "",
		GlobalQuery = "",
		Category = "All games",
		Collection = "All collections",
		OnlyPlace = false,
		Cards = {},
		Matches = {},
	}
	local controls = tab:AddLeftGroupbox("Scripts / curated library", "layers")
	local summary = controls:AddLabel("Loading library", true)
	local grid = Draw.New(
		"Frame",
		{ Name = "ScriptCardGrid", BackgroundTransparency = 1 }
	)
	local empty = Draw.Text({
		Name = "ScriptsEmptyState",
		Text = "No games match. Clear search or choose All games.",
		TextWrapped = true,
		Size = UDim2.new(1, -24, 0, 70),
		Position = UDim2.fromOffset(12, 12),
		Parent = grid,
	}, "Body", 16, "SubText")
	local function copy(parent, name, text, y, height, size, token)
		return Draw.Text({
			Name = name,
			Text = text,
			Position = UDim2.fromOffset(16, y),
			Size = UDim2.new(1, -32, 0, height),
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = parent,
		}, "Body", size, token)
	end
	local function latest()
		return options.Entries()
	end
	local function layout(width)
		local columns = width >= 610 and 2 or 1
		local cardWidth = math.max(0, (width - (columns - 1) * 12) / columns)
		for index, card in ipairs(browser.Matches) do
			card.Frame.Position = UDim2.fromOffset(
				(index - 1) % columns * (cardWidth + 12),
				math.floor((index - 1) / columns) * 260
			)
			card.Frame.Size = UDim2.fromOffset(cardWidth, 248)
		end
	end
	local gridItem = tab.Left:Add(grid, {
		Height = function(width)
			local count = #browser.Matches
			return count == 0 and 90
				or math.ceil(count / (width >= 610 and 2 or 1)) * 260 - 12
		end,
		OnLayout = layout,
	})
	function browser:Filter()
		table.clear(self.Matches)
		local total = 0
		for _, entry in ipairs(latest()) do
			total += 1
			local card = self.Cards[entry.Id]
			if card then
				local show = model.Match(
					entry,
					self.Query .. " " .. self.GlobalQuery,
					self.Category,
					self.OnlyPlace,
					game.PlaceId,
					game.GameId,
					self.Collection
				)
				card.Frame.Visible = show
				if show then
					table.insert(self.Matches, card)
				end
			end
		end
		empty.Visible = #self.Matches == 0
		summary:SetText(
			string.format(
				"%d of %d games / Nullx11 by NULL",
				#self.Matches,
				total
			)
		)
		tab.Left:MarkDirty()
		tab:ApplyColumns()
	end
	local category
	function browser:Refresh()
		local present = {}
		for _, entry in ipairs(latest()) do
			present[entry.Id] = true
			local card = self.Cards[entry.Id]
			if not card then
				local frame = Draw.Box(
					"Frame",
					{ Name = "ScriptCard_" .. entry.Id, Parent = grid },
					"Panel",
					"Outline",
					14,
					1
				)
				local accent = Draw.Box("Frame", {
					Size = UDim2.new(1, -32, 0, 3),
					Position = UDim2.fromOffset(16, 0),
					Parent = frame,
				}, "Accent", nil, 2)
				local icon = Icons.Create(
					frame,
					entry.Icon or "code",
					30,
					"Accent",
					entry.Name
				)
				icon.Position = UDim2.fromOffset(16, 18)
				local genre = copy(
					frame,
					"Category",
					model.Category(entry):upper(),
					19,
					20,
					14,
					"Muted"
				)
				genre.Position = UDim2.fromOffset(58, 23)
				genre.Size = UDim2.new(1, -74, 0, 20)
				local title =
					copy(frame, "GameName", entry.Name, 59, 46, 19, "Text")
				local description = copy(
					frame,
					"GameDescription",
					entry.Description,
					112,
					57,
					14,
					"SubText"
				)
				local badge = copy(
					frame,
					"Compatibility",
					model.Badge(entry, game.PlaceId, game.GameId),
					177,
					18,
					12,
					"Muted"
				)
				local button = Draw.Box("TextButton", {
					Name = "OpenScript_" .. entry.Id,
					Position = UDim2.fromOffset(14, 204),
					Size = UDim2.new(1, -28, 0, 32),
					Parent = frame,
				}, "Element", "Outline", 8, 1)
				copy(
					button,
					"OpenLabel",
					"View details & launch",
					6,
					20,
					14,
					"Text"
				)
				local id = entry.Id
				local connection = button.Activated:Connect(function()
					local selected = model.Resolve(latest(), id)
					if not selected then
						self:Refresh()
						return
					end
					options.Open(selected)
				end)
				card = {
					Frame = frame,
					Title = title,
					Description = description,
					Genre = genre,
					Badge = badge,
					Connection = connection,
					Accent = accent,
				}
				self.Cards[entry.Id] = card
			end
			card.Title.Text = entry.Name
			card.Description.Text = entry.Description
			card.Genre.Text = model.Category(entry):upper()
			card.Badge.Text = model.Badge(entry, game.PlaceId, game.GameId)
		end
		local removed = {}
		for id, card in pairs(self.Cards) do
			if not present[id] then
				table.insert(removed, id)
				card.Connection:Disconnect()
				Theme.UnbindTree(card.Frame)
				card.Frame:Destroy()
			end
		end
		for _, id in ipairs(removed) do
			self.Cards[id] = nil
		end
		if category then
			local values = model.Categories(latest())
			category:SetValues(values)
			if not table.find(values, self.Category) then
				self.Category = "All games"
				category:SetValue("All games")
			end
		end
		self:Filter()
	end
	controls:AddInput("ScriptLibrarySearch", {
		Text = "Search library",
		Placeholder = "Game, feature or creator",
		Finished = false,
		Default = "",
		NoSave = true,
		Callback = function(value)
			browser.Query = value
			browser:Filter()
		end,
	})
	category = controls:AddDropdown("ScriptLibraryCategory", {
		Text = "Category",
		Values = model.Categories(latest()),
		Default = "All games",
		NoSave = true,
		Callback = function(value)
			browser.Category = value
			browser:Filter()
		end,
	})
	controls:AddDropdown("ScriptLibraryCollection", {
		Text = "Source collection",
		Values = {
			"All collections",
			"Nullx11 originals",
			"YARHM",
			"Chaos",
			"NULL Studio",
		},
		Default = "All collections",
		NoSave = true,
		Callback = function(value)
			browser.Collection = value
			browser:Filter()
		end,
	})
	controls:AddToggle("ScriptLibraryPlace", {
		Text = "Known compatible game or Universal",
		Default = false,
		NoSave = true,
		Callback = function(value)
			browser.OnlyPlace = value
			browser:Filter()
		end,
	})
	controls:AddButton({
		Text = "Refresh repository manifest",
		Func = options.Refresh,
	})
	local help = tab:AddLeftGroupbox("Read before launching", "info")
	help:AddParagraph({
		Title = "Browse first. Launch deliberately.",
		Content = "Cards open the existing details and confirmation window. Nothing auto-runs or joins a game. A place match is not proof of server compatibility; module-gated games are checked by their bundle before startup.",
	})
	help:AddParagraph({
		Title = "Independent workspaces",
		Content = "Executed game windows survive loader unload. Stop features or unload each game's own workspace to clean up its jobs, overlays and owned changes.",
	})
	help:AddParagraph({
		Title = "NULL ownership and source notices",
		Content = "Owner: NULL. Native Nullx11 editions use one shared interface. Required source notices and restrictions are retained in the repository; optional promotional credits are not shown here.",
	})
	tab.ApplyLibraryFilter = function(query)
		browser.GlobalQuery = query or ""
		browser:Filter()
	end
	self:OnUnload(function()
		for _, card in pairs(browser.Cards) do
			card.Connection:Disconnect()
		end
		table.clear(browser.Cards)
		table.clear(browser.Matches)
	end)
	browser:Refresh()
	return browser
end
