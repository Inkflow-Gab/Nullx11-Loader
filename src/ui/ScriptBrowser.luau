-- Bounded native library: fixed row pool, viewport-sized pages, no catalog-sized
-- canvas. Opening a row still delegates to the existing details/confirmation gate.
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
			browser:Layout(browser.Width, browser.Height)
		end
	)
	local filters = Draw.New("Frame", {
		Name = "ScriptFilterRow",
		BackgroundTransparency = 1,
		Visible = false,
		Position = UDim2.fromOffset(0, 84),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = surface,
	})
	local function cycle(values, current)
		return values[(table.find(values, current) or 0) % #values + 1]
	end
	local category = button(
		"ScriptCategory",
		filters,
		"All games",
		UDim2.fromOffset(0, 0),
		UDim2.new(0.35, -5, 1, 0),
		function()
			browser.Category =
				cycle(model.Categories(browser.Entries), browser.Category)
			browser.Page = 1
			browser:Filter()
		end
	)
	local collection = button(
		"ScriptCollection",
		filters,
		"All collections",
		UDim2.fromScale(0.35, 0),
		UDim2.new(0.4, -5, 1, 0),
		function()
			browser.Collection = cycle(browser.Collections, browser.Collection)
			browser.Page = 1
			browser:Filter()
		end
	)
	local sort = button(
		"ScriptSort",
		filters,
		"Name A-Z",
		UDim2.fromScale(0.75, 0),
		UDim2.fromScale(0.25, 1),
		function()
			browser.Sort =
				cycle({ "Name", "Collection", "Recent" }, browser.Sort)
			browser.Page = 1
			browser:Filter()
		end
	)
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
	-- Eight rows is a hard allocation bound, independent of catalog size. Hidden
	-- slots have no animation, polling, or per-entry signal connections.
	for index = 1, 8 do
		local frame = Draw.Box("Frame", {
			Name = "ScriptSlot" .. index,
			Size = UDim2.new(1, 0, 0, 76),
			Visible = false,
			Parent = rows,
		}, "Panel", "Outline", 8, 1)
		local card = { Frame = frame }
		card.Title = text("ScriptName", frame, "", 7, 22, 15)
		card.Description =
			text("ScriptDescription", frame, "", 30, 19, 12, "SubText")
		card.Badge = text("ScriptBadge", frame, "", 51, 18, 11, "Muted")
		card.Pin = button(
			"ScriptPin" .. index,
			frame,
			"Pin",
			UDim2.new(1, -128, 0, 18),
			UDim2.fromOffset(48, 40),
			function()
				if card.Id then
					browser.Pinned[card.Id] = not browser.Pinned[card.Id] or nil
					browser:Filter()
				end
			end
		)
		card.Open = button(
			"ScriptOpen" .. index,
			frame,
			"Details",
			UDim2.new(1, -74, 0, 18),
			UDim2.fromOffset(64, 40),
			function()
				-- A refresh can replace metadata while this slot is visible. Resolve the
				-- current entry, never a captured executable or an obsolete table.
				local entry = model.Resolve(browser.Entries, card.Id)
				if entry and options.Open then
					browser.Visit += 1
					browser.Recent[entry.Id] = browser.Visit
					options.Open(entry)
					if not browser.Closed then
						browser:Filter()
					end
				end
			end
		)
		browser.Cards[index] = card
	end
	function browser:Render()
		if self.Closed then
			return
		end
		self.Pages = math.max(1, math.ceil(#self.Matches / self.PageSize))
		self.Page = math.clamp(self.Page, 1, self.Pages)
		for index, card in ipairs(self.Cards) do
			local entry = if index <= self.PageSize
				then self.Matches[(self.Page - 1) * self.PageSize + index]
				else nil
			card.Id, card.Frame.Visible = entry and entry.Id, entry ~= nil
			card.Frame.Position =
				UDim2.fromOffset(0, (index - 1) * ((self.RowHeight or 76) + 6))
			card.Frame.Size = UDim2.new(1, 0, 0, self.RowHeight or 76)
			card.Description.Visible = (self.RowHeight or 76) >= 64
			card.Badge.Visible = (self.RowHeight or 76) >= 76
			local actionY = math.max(0, ((self.RowHeight or 76) - 40) / 2)
			local actionHeight = math.min(40, self.RowHeight or 76)
			card.Pin.Position, card.Open.Position =
				UDim2.new(1, -128, 0, actionY), UDim2.new(1, -74, 0, actionY)
			card.Pin.Size, card.Open.Size =
				UDim2.fromOffset(48, actionHeight),
				UDim2.fromOffset(64, actionHeight)
			if self.Width < 360 and (self.RowHeight or 76) >= 76 then
				card.Pin.Position, card.Open.Position =
					UDim2.new(1, -74, 0, 40), UDim2.new(1, -74, 0, 4)
				card.Pin.Size, card.Open.Size =
					UDim2.fromOffset(64, 32), UDim2.fromOffset(64, 32)
			end
			local textInset = if self.Width < 360
					and (self.RowHeight or 76) >= 76
				then 96
				else 150
			card.Title.Size, card.Description.Size, card.Badge.Size =
				UDim2.new(1, -textInset, 0, 22),
				UDim2.new(1, -textInset, 0, 19),
				UDim2.new(1, -textInset, 0, 18)
			if entry then
				card.Title.Text = entry.Name
				card.Description.Text = entry.Description
					or "Open details for compatibility and launch information."
				card.Badge.Text = model.Badge(entry, game.PlaceId, game.GameId)
					.. " / "
					.. (entry.Collection or "Nullx11 originals")
				card.Pin.Text = if self.Pinned[entry.Id] then "Unpin" else "Pin"
			end
		end
		for view, control in pairs(viewButtons) do
			control.BackgroundTransparency = if self.View == view
				then 0
				else 0.65
			control.Visible = not self.Compact
		end
		category.Text, collection.Text = self.Category, self.Collection
		sort.Text = if self.Sort == "Name" then "Name A-Z" else self.Sort
		filterButton.Text = if self.ShowFilters then "Less" else "Filters"
		filterButton.Visible = not self.Compact
		filters.Visible, empty.Visible =
			self.ShowFilters and not self.Compact, #self.Matches == 0
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
		self.Compact = height < 204
		local top = if self.Compact
			then 44
			elseif self.ShowFilters then 124
			else 84
		local available = math.max(32, height - top - 44)
		self.RowHeight = math.min(76, available)
		rows.Position, rows.Size =
			UDim2.fromOffset(0, top), UDim2.new(1, 0, 0, available)
		local size =
			math.clamp(math.floor((available + 6) / (self.RowHeight + 6)), 1, 8)
		-- Preserve the first visible result when resizing/rotating the viewport.
		local first = (self.Page - 1) * self.PageSize
		self.PageSize = size
		self.Page = math.floor(first / size) + 1
		self:Render()
	end
	function browser:Filter()
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
	browser:Layout(600, 400)
	return browser
end
