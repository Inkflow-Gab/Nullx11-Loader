-- Both shipped browser/model, with API doubles and scale-aware dimensions.
-- These are bounded-layout/lifecycle contracts, not native rendering claims.
local UDim2 = midiUDim2
local Library = { Hooks = {} }
function Library:OnUnload(callback)
	table.insert(self.Hooks, callback)
end
local Draw = {}
function Draw.New(class, properties)
	local instance = Instance.new(class)
	for key, value in pairs(properties) do
		instance[key] = value
	end
	return instance
end
function Draw.Box(class, properties)
	return Draw.New(class, properties)
end
function Draw.Text(properties)
	return Draw.New("TextLabel", properties)
end
function Draw.Padding() end
local unbound = 0
local Theme = {
	Bind = function() end,
	UnbindTree = function()
		unbound += 1
	end,
}
local makeScriptLibraryModel
-- @BROWSER_MODEL
-- @BROWSER_VIEW
local tab =
	{ Left = { Items = {} }, Window = { PageHost = Instance.new("Frame") } }
tab.Window.PageHost.AbsoluteSize = Vector2.new(650, 416)
function tab.Left:Add(frame, spec)
	table.insert(self.Items, { Frame = frame, Spec = spec })
end
function tab.Left:MarkDirty()
	self.Dirty = true
end
game.PlaceId, game.GameId = 9991, 77
local entries = {
	{
		Id = "a",
		Name = "Alpha",
		Description = "Cash routing",
		Author = "Alice",
		Collection = "YARHM",
		File = "a.luau",
		Category = "Simulator",
		GamePlaceId = game.PlaceId,
	},
	{
		Id = "b",
		Name = "Beta",
		Description = "Aim controls",
		Author = "Bob",
		Collection = "Chaos",
		File = "b.luau",
		Category = "Shooter",
	},
	{
		Id = "c",
		Name = "Gamma",
		Description = "Universal tools",
		Universal = true,
	},
	{
		Id = "d",
		Name = "Delta",
		Description = "Universe tools",
		GameUniverseId = game.GameId,
	},
}
local opened, refreshes = nil, 0
local browser = Library:CreateScriptBrowser(tab, {
	Entries = function()
		return entries
	end,
	Open = function(entry)
		opened = entry
	end,
	Refresh = function()
		refreshes += 1
	end,
})
assert(#browser.Matches == 4 and #browser.Cards == 8 and opened == nil)
assert(#tab.Left.Items == 1, "no stacked groupboxes or catalog-sized canvas")
local layout = tab.Left.Items[1].Spec
assert(layout.Height(650) == 400)
layout.OnLayout(650, 400)
assert(browser.PageSize == 3 and browser.Pages == 2)
local first = browser.Cards[1]
assert(first.Id == "a" and first.Description.Text == "Cash routing")
local allocations, connections = #objects, #browser.Connections
local function click(name)
	find(name).Activated:Fire()
end
local function query(value)
	browser.Search.Text = value
	browser.Search:GetPropertyChangedSignal("Text"):Fire()
end
click("ScriptNext")
assert(
	browser.Page == 2
		and browser.Cards[1].Id == "c"
		and not browser.Cards[2].Frame.Visible
)
click("ScriptPrevious")
query("alice cash")
assert(#browser.Matches == 1 and first.Id == "a")
query("%[")
assert(
	#browser.Matches == 0 and find("ScriptEmpty").Visible,
	"literal search, not patterns"
)
click("ScriptClear")
click("ScriptView2")
assert(
	#browser.Matches == 3,
	"this game includes matching place/universe/universal, not unknown modules"
)
click("ScriptClear")
click("ScriptPin1")
click("ScriptView3")
assert(#browser.Matches == 1 and first.Id == "a" and first.Pin.Text == "Unpin")
click("ScriptPin1")
assert(#browser.Matches == 0, "unpin clamps empty page immediately")
click("ScriptView4")
assert(#browser.Matches == 0 and opened == nil)
click("ScriptClear")
click("ScriptOpen1")
assert(
	opened == entries[1] and browser.Recent.a == 1,
	"only explicit details action delegates"
)
click("ScriptView4")
assert(#browser.Matches == 1 and first.Id == "a")
click("ScriptClear")
click("ScriptFilters")
assert(browser.ShowFilters and find("ScriptFilterRow").Visible)
click("ScriptCategory")
assert(browser.Category == "Community" and #browser.Matches == 2)
click("ScriptClear")
click("ScriptCollection")
assert(
	browser.Collection == "Chaos" and #browser.Matches == 1 and first.Id == "b"
)
click("ScriptClear")
-- Global header API still delegates; local search survives leaving/reentering an
-- unchanged global query via the normal tab FilteredQuery contract.
tab.ApplyLibraryFilter("beta")
assert(#browser.Matches == 1 and tab.FilteredQuery == "beta")
click("ScriptClear")
-- Replacement metadata is resolved at click after refresh, never a stale closure.
entries[1] = {
	Id = "a",
	Name = "Alpha revised",
	Description = "Current metadata",
	Category = "Updated",
}
browser:Refresh()
click("ScriptOpen1")
assert(opened == entries[1] and opened.Name == "Alpha revised")
if browser.ShowFilters then
	click("ScriptFilters")
end
-- A larger catalog must not allocate any more GUI objects or callbacks.
for index = 1, 500 do
	table.insert(entries, {
		Id = "extra" .. index,
		Name = string.format("Row %03d", index),
		Description = "Bounded library",
	})
end
browser:Refresh()
layout.OnLayout(650, 780)
assert(browser.PageSize == 8 and browser.Pages == 63)
for page = 1, browser.Pages do
	browser:SetPage(page)
end
assert(
	#objects == allocations and #browser.Connections == connections,
	"paging/filter/refresh reuse the fixed pool"
)
local jump = find("ScriptPageJump")
jump.Text = "99999"
jump.FocusLost:Fire()
assert(browser.Page == browser.Pages)
jump.Text = "-99"
jump.FocusLost:Fire()
assert(browser.Page == 1)
jump.Text = "not a number"
jump.FocusLost:Fire()
assert(browser.Page == 1)
browser:SetPage(7)
local firstIndex = (browser.Page - 1) * browser.PageSize
layout.OnLayout(272, 400)
assert(browser.PageSize == 3 and browser.Page == math.floor(firstIndex / 3) + 1)
assert(
	first.Pin.Position.Y.Offset == 40 and first.Pin.Size.Y.Offset == 32,
	"portrait actions stack, giving titles more width"
)
-- Short landscape removes the secondary toolbar, never overlapping the pager.
layout.OnLayout(600, 158)
assert(
	browser.PageSize == 1
		and not find("ScriptView1").Visible
		and not find("ScriptFilterRow").Visible
)
assert(
	first.Frame.Position.Y.Offset + first.Frame.Size.Y.Offset <= 158 - 44 - 44
)
assert(first.Open.Size.Y.Offset >= 32)
tab.Window.PageHost:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	tab.Left.Dirty,
	"height-only viewport changes remeasure the bounded page"
)
-- Removed entries prune session history, then empty library resets page and UI.
entries = {}
browser:Refresh()
assert(
	browser.Page == 1
		and browser.Pages == 1
		and #browser.Matches == 0
		and not first.Frame.Visible
)
assert(next(browser.Pinned) == nil and next(browser.Recent) == nil)
click("ScriptRefresh")
assert(refreshes == 1)
local oldConnections = table.clone(browser.Connections)
for _, hook in ipairs(Library.Hooks) do
	hook()
end
for _, connection in ipairs(oldConnections) do
	assert(not connection.Connected)
end
assert(
	browser.Closed
		and #browser.Cards == 0
		and tab.ApplyLibraryFilter == nil
		and unbound == 1
)
click("ScriptRefresh")
assert(
	refreshes == 1 and #entries == 0,
	"disposed controls cannot invoke callbacks or mutate catalog"
)
return "PASS: shipped bounded browser: paging/jump/rotation/short landscape, search/category/collection/place/universe, pin/recent, latest-entry resolution, 504-entry constant UI allocations and disposal (API doubles)"
