-- Premium dark card library: fixed card pool, direct-choice filters and an
-- in-place detail sheet. Launch remains a separate, explicit confirmation flow.
function Library:CreateScriptBrowser(tab, options)
	options = options or {}
	local model = makeScriptLibraryModel
	local browser = {
		Entries = {},
		Matches = {},
		Cards = {},
		Connections = {},
		Query = "",
		Category = "All games",
		Collection = "All collections",
		View = "All",
		Sort = "Name",
		Page = 1,
		PageSize = 1,
		Pages = 1,
		Pinned = {},
		Recent = {},
		Visit = 0,
		ShowFilters = false,
		Width = 600,
		Columns = 1,
		CardHeight = 164,
		SelectedId = nil,
		MenuField = "Category",
		MenuRows = {},
		Height = 400,
		Closed = false,
	}
	local surface = Draw.New("Frame", {
		Name = "ScriptLibrary",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
	})
	browser.Frame = surface
	local function listen(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(browser.Connections, connection)
		return connection
	end
	local function text(name, parent, caption, y, height, size, token)
		return Draw.Text({
			Name = name,
			Text = caption,
			Position = UDim2.fromOffset(12, y),
			Size = UDim2.new(1, -150, 0, height),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = parent,
		}, "Body", size or 12, token or "Text")
	end
	local function button(name, parent, caption, position, size, callback)
		local control = Draw.Box("TextButton", {
			Name = name,
			Position = position,
			Size = size,
			Parent = parent,
		}, "Element", "Outline", 7, 1)
		control.Text, control.TextSize, control.Font =
			caption, 12, Enum.Font.GothamMedium
		control.TextTruncate = Enum.TextTruncate.AtEnd
		Theme.Bind(control, { TextColor3 = "Text" })
		listen(control.Activated, function()
			if not browser.Closed then
				callback()
			end
		end)
		return control
	end
	local search = Draw.Box("TextBox", {
		Name = "ScriptLibrarySearch",
		Text = "",
		PlaceholderText = "Search games, features, creators...",
		ClearTextOnFocus = false,
		MultiLine = false,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -122, 0, 36),
		Parent = surface,
	}, "Element", "Outline", 7, 1)
	Draw.Padding(search, 0, 10)
	Theme.Bind(search, { TextColor3 = "Text", PlaceholderColor3 = "Muted" })
	browser.Search = search
	button(
		"ScriptClear",
		surface,
		"Clear",
		UDim2.new(1, -116, 0, 0),
		UDim2.fromOffset(50, 36),
		function()
			browser:Reset()
		end
	)
	button(
		"ScriptRefresh",
		surface,
		"Refresh",
		UDim2.new(1, -60, 0, 0),
		UDim2.fromOffset(60, 36),
		function()
			if options.Refresh then
				options.Refresh()
			end
		end
	)
	local viewButtons = {}
	for index, view in ipairs({ "All", "This game", "Pinned", "Recent" }) do
		viewButtons[view] = button(
			"ScriptView" .. index,
			surface,
			view,
			UDim2.new((index - 1) / 5, 0, 0, 44),
			UDim2.new(1 / 5, -5, 0, 32),
			function()
				browser.View, browser.Page = view, 1
				browser:Filter()
			end
		)
	end
	local filterButton = button(
		"ScriptFilters",
		surface,
		"Filters",
		UDim2.new(0.8, 0, 0, 44),
		UDim2.new(0.2, 0, 0, 32),
		function()
			browser.ShowFilters = not browser.ShowFilters
			browser.SelectedId = nil
			browser:Filter()
		end
	)
	local filters = Draw.Box("Frame", {
		Name = "ScriptFilterRow",
		Visible = false,
		ZIndex = 10,
		Position = UDim2.fromOffset(0, 84),
		Size = UDim2.new(1, 0, 1, -128),
		Parent = surface,
	}, "Panel", "Outline", 12, 1)
	local menuTabs = {}
	for index, field in ipairs({ "Category", "Collection", "Sort" }) do
		menuTabs[field] = button(
			"Script" .. field,
			filters,
			field,
			UDim2.new((index - 1) / 3, 8, 0, 8),
			UDim2.new(1 / 3, -16, 0, 34),
			function()
				browser.MenuField = field
				browser:Render()
			end
		)
		menuTabs[field].ZIndex = 11
	end
	local choices = Draw.New("ScrollingFrame", {
		Name = "ScriptChoices",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(8, 50),
		Size = UDim2.new(1, -16, 1, -58),
		ScrollBarThickness = 3,
		CanvasSize = UDim2.fromOffset(0, 0),
		ZIndex = 11,
		Parent = filters,
	})
	function browser:RenderChoices()
		local values = if self.MenuField == "Category"
			then model.Categories(self.Entries)
			elseif self.MenuField == "Collection" then self.Collections
			else { "Name", "Collection", "Recent" }
		for index, value in ipairs(values or {}) do
			local item = self.MenuRows[index]
			if not item then
				item = { Value = value }
				item.Button = button(
					"ScriptOption" .. index,
					choices,
					value,
					UDim2.fromOffset(0, (index - 1) * 40),
					UDim2.new(1, -8, 0, 36),
					function()
						self[self.MenuField] = item.Value
						self.ShowFilters, self.Page = false, 1
						self:Filter()
					end
				)
				item.Button.ZIndex = 12
				self.MenuRows[index] = item
			end
			item.Value, item.Button.Visible = value, true
			item.Button.Text = (
				self[self.MenuField] == value and "Selected / " or ""
			) .. value
		end
		for index = #(values or {}) + 1, #self.MenuRows do
			self.MenuRows[index].Button.Visible = false
		end
		choices.CanvasSize = UDim2.fromOffset(0, #(values or {}) * 40)
		for field, control in pairs(menuTabs) do
			control.BackgroundTransparency = if field == self.MenuField
				then 0
				else 0.6
		end
	end
	local rows = Draw.New("Frame", {
		Name = "ScriptRows",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = surface,
	})
	local empty = Draw.Text({
		Name = "ScriptEmpty",
		Text = "No matches. Clear filters or refresh the library.",
		Position = UDim2.fromOffset(12, 4),
		Size = UDim2.new(1, -24, 1, -8),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = rows,
	}, "Body", 13, "Muted")
	local footer = Draw.New("Frame", {
		Name = "ScriptPagination",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 36),
		Parent = surface,
	})
	local previous = button(
		"ScriptPrevious",
		footer,
		"Prev",
		UDim2.fromOffset(0, 0),
		UDim2.fromOffset(48, 36),
		function()
			browser:SetPage(browser.Page - 1)
		end
	)
	local nextPage = button(
		"ScriptNext",
		footer,
		"Next",
		UDim2.new(1, -48, 0, 0),
		UDim2.fromOffset(48, 36),
		function()
			browser:SetPage(browser.Page + 1)
		end
	)
	local jump = Draw.Box("TextBox", {
		Name = "ScriptPageJump",
		Text = "1",
		ClearTextOnFocus = false,
		MultiLine = false,
		Position = UDim2.fromOffset(54, 0),
		Size = UDim2.fromOffset(38, 36),
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		Parent = footer,
	}, "Element", "Outline", 7, 1)
	Theme.Bind(jump, { TextColor3 = "Text" })
	local status = Draw.Text({
		Name = "ScriptPageStatus",
		Position = UDim2.fromOffset(98, 0),
		Size = UDim2.new(1, -152, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = footer,
	}, "Body", 11, "Muted")
	listen(jump.FocusLost, function()
		local requested = tonumber(jump.Text)
		browser:SetPage(
			if requested and requested == requested
				then math.floor(requested)
				else browser.Page
		)
	end)
	-- Eight reusable cards, never one GUI tree per catalog entry.
	for index = 1, 8 do
		local frame = Draw.Box("TextButton", {
			Name = "ScriptSlot" .. index,
			Text = "",
			Size = UDim2.new(1, 0, 0, 152),
			Visible = false,
			Parent = rows,
		}, "Panel", "Outline", 12, 1)
		local card = { Frame = frame }
		card.Badge = text("ScriptBadge", frame, "", 12, 18, 11, "Accent")
		card.Title = text("ScriptName", frame, "", 36, 44, 17)
		card.Title.Font = Enum.Font.GothamMedium
		card.Title.TextWrapped = true
		card.Description =
			text("ScriptDescription", frame, "", 82, 34, 12, "SubText")
		card.Description.TextWrapped = true
		card.Open = button(
			"ScriptOpen" .. index,
			frame,
			"View script",
			UDim2.new(0, 12, 1, -44),
			UDim2.new(1, -88, 0, 32),
			function()
				browser:Select(card.Id)
			end
		)
		card.Pin = button(
			"ScriptPin" .. index,
			frame,
			"Save",
			UDim2.new(1, -68, 1, -44),
			UDim2.fromOffset(56, 32),
			function()
				if card.Id then
					browser.Pinned[card.Id] = not browser.Pinned[card.Id] or nil
					browser:Filter()
				end
			end
		)
		listen(frame.MouseEnter, function()
			if not browser.Closed then
				Theme.Bind(frame, { BackgroundColor3 = "Hover" })
			end
		end)
		listen(frame.MouseLeave, function()
			if not browser.Closed then
				Theme.Bind(frame, { BackgroundColor3 = "Panel" })
			end
		end)
		listen(frame.Activated, function()
			if not browser.Closed then
				browser:Select(card.Id)
			end
		end)
		browser.Cards[index] = card
	end
	local detail = Draw.Box("Frame", {
		Name = "ScriptDetail",
		Visible = false,
		Position = UDim2.fromOffset(0, 84),
		Size = UDim2.new(1, 0, 1, -84),
		ZIndex = 5,
		Parent = surface,
	}, "Panel", "Outline", 12, 1)
	local detailScroll = Draw.New("ScrollingFrame", {
		Name = "ScriptDetailBody",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 12),
		Size = UDim2.new(1, -32, 1, -74),
		CanvasSize = UDim2.fromOffset(0, 416),
		ScrollBarThickness = 3,
		ZIndex = 6,
		Parent = detail,
	})
	local detailName = text("ScriptDetailName", detailScroll, "", 0, 70, 24)
	local detailBadge =
		text("ScriptDetailBadge", detailScroll, "", 78, 40, 12, "Accent")
	local detailDescription = text(
		"ScriptDetailDescription",
		detailScroll,
		"",
		130,
		164,
		14,
		"SubText"
	)
	local detailAuthor =
		text("ScriptDetailAuthor", detailScroll, "", 304, 104, 12, "Muted")
	for _, object in ipairs({
		detailName,
		detailBadge,
		detailDescription,
		detailAuthor,
	}) do
		object.Position = UDim2.fromOffset(0, object.Position.Y.Offset)
		object.Size = UDim2.new(1, -8, 0, object.Size.Y.Offset)
		object.TextWrapped, object.TextYAlignment, object.ZIndex =
			true, Enum.TextYAlignment.Top, 7
	end
	local back = button(
		"ScriptDetailBack",
		detail,
		"Back",
		UDim2.new(0, 12, 1, -52),
		UDim2.fromOffset(70, 40),
		function()
			browser.SelectedId = nil
			browser:Render()
		end
	)
	local launch = button(
		"ScriptDetailLaunch",
		detail,
		"Continue to launch",
		UDim2.new(0, 92, 1, -52),
		UDim2.new(1, -104, 0, 40),
		function()
			local entry = model.Resolve(browser.Entries, browser.SelectedId)
			if entry and options.Open then
				options.Open(entry)
			end
		end
	)
	back.ZIndex, launch.ZIndex = 7, 7
	Theme.Bind(launch, { BackgroundColor3 = "Accent", TextColor3 = "Black" })
	function browser:Select(id)
		local entry = model.Resolve(self.Entries, id)
		if not entry or self.Closed then
			return
		end
		self.SelectedId, self.ShowFilters = id, false
		self.Visit += 1
		self.Recent[id] = self.Visit
		detailScroll.CanvasPosition = Vector2.new(0, 0)
		self:Render()
	end
	function browser:Render()
		if self.Closed then
			return
		end
		self.Pages = math.max(1, math.ceil(#self.Matches / self.PageSize))
		self.Page = math.clamp(self.Page, 1, self.Pages)
		local cardWidth = (self.Width - (self.Columns - 1) * 12) / self.Columns
		local compactCard = self.CardHeight < 112
		for index, card in ipairs(self.Cards) do
			local entry = if index <= self.PageSize
				then self.Matches[(self.Page - 1) * self.PageSize + index]
				else nil
			card.Id, card.Frame.Visible = entry and entry.Id, entry ~= nil
			card.Frame.Position = UDim2.fromOffset(
				((index - 1) % self.Columns) * (cardWidth + 12),
				math.floor((index - 1) / self.Columns) * (self.CardHeight + 12)
			)
			card.Frame.Size = UDim2.fromOffset(cardWidth, self.CardHeight)
			card.Badge.Size = UDim2.new(1, -24, 0, 18)
			card.Title.Position =
				UDim2.fromOffset(12, if compactCard then 10 else 36)
			card.Title.Size = UDim2.new(
				1,
				-24,
				0,
				if compactCard then math.max(22, self.CardHeight - 58) else 44
			)
			card.Title.TextSize = if compactCard then 15 else 17
			card.Description.Size = UDim2.new(1, -24, 0, 34)
			card.Description.Visible = self.CardHeight >= 164
			card.Badge.Visible = not compactCard
			local tiny = self.CardHeight < 88
			card.Pin.Visible = not tiny
			card.Open.Position = if tiny
				then UDim2.new(
					1,
					-80,
					0,
					math.max(0, (self.CardHeight - 32) / 2)
				)
				else UDim2.new(0, 12, 1, -44)
			card.Open.Size = if tiny
				then UDim2.fromOffset(68, 32)
				else UDim2.new(1, -88, 0, 32)
			if tiny then
				card.Title.Position = UDim2.fromOffset(12, 4)
				card.Title.Size = UDim2.new(1, -100, 0, 24)
			end
			if entry then
				card.Title.Text = entry.Name:gsub("^Nullx11%s*%-%s*", "")
				card.Description.Text = entry.Description
					or "View script information."
				card.Badge.Text = model.Category(entry)
					.. " / "
					.. (entry.Collection or "Nullx11")
				card.Pin.Text = if self.Pinned[entry.Id]
					then "Saved"
					else "Save"
			end
		end
		for view, control in pairs(viewButtons) do
			control.BackgroundTransparency = if self.View == view then 0 else 1
			control.Visible = not self.Compact
		end
		filterButton.Text = if self.ShowFilters then "Close" else "Filters"
		filterButton.Visible = not self.Compact
		filters.Visible = self.ShowFilters and not self.Compact
		if filters.Visible then
			self:RenderChoices()
		end
		local selected = model.Resolve(self.Entries, self.SelectedId)
		detail.Visible = selected ~= nil
		rows.Visible, footer.Visible = selected == nil, selected == nil
		if selected then
			detailName.Text = selected.Name
			detailBadge.Text = model.Badge(selected, game.PlaceId, game.GameId)
				.. " / "
				.. model.Category(selected)
			detailDescription.Text = selected.Description
				or "No description published."
			detailAuthor.Text = (selected.Collection or "Nullx11 originals")
				.. "\n"
				.. (selected.Author or "Owner: NULL")
				.. "\nLaunch is manual. Compatibility is checked before execution."
			-- Size the scrolling detail content for the current width. The full
			-- description/provenance must not be clipped to a compact card height.
			local chars = math.max(18, math.floor((self.Width - 48) / 8))
			local titleHeight = math.max(
				56,
				math.ceil(#selected.Name / math.max(12, chars * 0.6)) * 28
			)
			local descriptionHeight = math.max(
				64,
				(math.ceil(#detailDescription.Text / chars) + 1) * 20
			)
			local authorHeight =
				math.max(90, (math.ceil(#detailAuthor.Text / chars) + 4) * 18)
			detailName.Size = UDim2.new(1, -8, 0, titleHeight)
			detailBadge.Position = UDim2.fromOffset(0, titleHeight + 12)
			detailDescription.Position = UDim2.fromOffset(0, titleHeight + 66)
			detailDescription.Size = UDim2.new(1, -8, 0, descriptionHeight)
			detailAuthor.Position =
				UDim2.fromOffset(0, titleHeight + descriptionHeight + 86)
			detailAuthor.Size = UDim2.new(1, -8, 0, authorHeight)
			detailScroll.CanvasSize = UDim2.fromOffset(
				0,
				titleHeight + descriptionHeight + authorHeight + 98
			)
		end
		empty.Visible = #self.Matches == 0
		jump.Text = tostring(self.Page)
		status.Text =
			string.format("of %d / %d scripts", self.Pages, #self.Matches)
		previous.Active, nextPage.Active = self.Page > 1, self.Page < self.Pages
		previous.TextTransparency = if previous.Active then 0 else 0.6
		nextPage.TextTransparency = if nextPage.Active then 0 else 0.6
	end
	function browser:SetPage(page)
		if self.Closed then
			return
		end
		self.Page = math.clamp(page, 1, self.Pages)
		self:Render()
	end
	function browser:Layout(width, height)
		if self.Closed then
			return
		end
		self.Width, self.Height = width, height
		self.Compact = height < 224
		local top = if self.Compact then 44 else 84
		local available = math.max(32, height - top - 44)
		self.Columns = if width >= 540 then 2 else 1
		local rowCount = math.clamp(math.floor((available + 12) / 140), 1, 4)
		self.CardHeight =
			math.min(184, (available - (rowCount - 1) * 12) / rowCount)
		rows.Position, rows.Size =
			UDim2.fromOffset(0, top), UDim2.new(1, 0, 0, available)
		detail.Position, detail.Size =
			UDim2.fromOffset(0, top), UDim2.new(1, 0, 1, -top)
		local first = (self.Page - 1) * self.PageSize
		self.PageSize = math.min(8, rowCount * self.Columns)
		self.Page = math.floor(first / self.PageSize) + 1
		self:Render()
	end
	function browser:Filter()
		self.SelectedId = nil
		if self.Closed then
			return
		end
		table.clear(self.Matches)
		for _, entry in ipairs(self.Entries) do
			if
				model.Match(
					entry,
					self.Query,
					self.Category,
					self.View == "This game",
					game.PlaceId,
					game.GameId,
					self.Collection
				)
				and (self.View ~= "Pinned" or self.Pinned[entry.Id])
				and (self.View ~= "Recent" or self.Recent[entry.Id])
			then
				table.insert(self.Matches, entry)
			end
		end
		table.sort(self.Matches, function(a, b)
			if self.View == "Recent" or self.Sort == "Recent" then
				local ar, br = self.Recent[a.Id] or 0, self.Recent[b.Id] or 0
				if ar ~= br then
					return ar > br
				end
			elseif self.Sort == "Collection" then
				local ac, bc =
					a.Collection or "Nullx11 originals",
					b.Collection or "Nullx11 originals"
				if ac ~= bc then
					return ac < bc
				end
			end
			local an, bn = string.lower(a.Name), string.lower(b.Name)
			return if an == bn then a.Id < b.Id else an < bn
		end)
		self:Render()
	end
	function browser:Reset()
		self.ShowFilters = false
		if self.Closed then
			return
		end
		self.Query, self.Category, self.Collection, self.View, self.Sort, self.Page =
			"", "All games", "All collections", "All", "Name", 1
		search.Text = ""
		self:Filter()
	end
	function browser:Refresh()
		if self.Closed then
			return
		end
		self.Entries = options.Entries and options.Entries() or {}
		local seen, collections = {}, { "All collections" }
		for _, entry in ipairs(self.Entries) do
			local value = entry.Collection or "Nullx11 originals"
			if not seen[value] then
				seen[value] = true
				table.insert(collections, value)
			end
		end
		table.sort(collections)
		self.Collections = collections
		if not table.find(model.Categories(self.Entries), self.Category) then
			self.Category = "All games"
		end
		if not table.find(collections, self.Collection) then
			self.Collection = "All collections"
		end
		-- Metadata and session history are bounded by currently published entries.
		for _, history in ipairs({ self.Pinned, self.Recent }) do
			for id in pairs(history) do
				if not model.Resolve(self.Entries, id) then
					history[id] = nil
				end
			end
		end
		self:Filter()
	end
	listen(search:GetPropertyChangedSignal("Text"), function()
		if browser.Closed or browser.Query == search.Text then
			return
		end
		browser.Query, browser.Page = search.Text, 1
		browser:Filter()
	end)
	local applyQuery = function(query)
		if browser.Closed then
			return
		end
		tab.FilteredQuery = query or ""
		browser.Query, browser.Page = query or "", 1
		search.Text = query or ""
		browser:Filter()
	end
	if tab.Window and tab.Window.PageHost then
		listen(
			tab.Window.PageHost:GetPropertyChangedSignal("AbsoluteSize"),
			function()
				if not browser.Closed then
					tab.Left:MarkDirty()
				end
			end
		)
	end
	tab.LibraryBrowser = true
	tab.ApplyLibraryFilter = applyQuery
	tab.Left:Add(surface, {
		Height = function()
			local host = tab.Window and tab.Window.PageHost
			return math.clamp(
				(host and host.AbsoluteSize.Y or 416) - 16,
				120,
				780
			)
		end,
		OnLayout = function(width, height)
			browser:Layout(width, height)
		end,
	})
	self:OnUnload(function()
		browser.Closed = true
		for _, connection in ipairs(browser.Connections) do
			connection:Disconnect()
		end
		table.clear(browser.Connections)
		Theme.UnbindTree(surface)
		for _, card in ipairs(browser.Cards) do
			card.Id = nil
		end
		table.clear(browser.MenuRows)
		table.clear(browser.Cards)
		table.clear(browser.Matches)
		browser.Entries = {}
		table.clear(browser.Pinned)
		table.clear(browser.Recent)
		if tab.ApplyLibraryFilter == applyQuery then
			tab.ApplyLibraryFilter = nil
			tab.LibraryBrowser = nil
		end
	end)
	browser:Refresh()
	browser.CardHeight = 164
	browser:Layout(600, 400)
	return browser
end
