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
assert(browser.PageSize == 4 and browser.Pages == 1 and browser.Columns == 2)
local first = browser.Cards[1]
assert(first.Id == "a" and first.Title.Text == "Alpha")
assert(
	browser.Cards[2].Frame.Position.X.Offset > 0
		and browser.Cards[3].Frame.Position.Y.Offset > 0,
	"readable two-column card grid"
)
local function click(name)
	find(name).Activated:Fire()
end
local function query(value)
	browser.Search.Text = value
	browser.Search:GetPropertyChangedSignal("Text"):Fire()
end
layout.OnLayout(650, 300)
assert(browser.PageSize == 2 and browser.Pages == 2)
click("ScriptNext")
assert(browser.Page == 2 and browser.Cards[1].Id == "d")
click("ScriptPrevious")
query("alice cash")
assert(#browser.Matches == 1 and first.Id == "a")
query("%[")
assert(#browser.Matches == 0 and find("ScriptEmpty").Visible)
click("ScriptClear")
click("ScriptView2")
assert(
	#browser.Matches == 3,
	"strict place/universe/universal view does not assume module compatibility"
)
click("ScriptClear")
click("ScriptPin1")
click("ScriptView3")
assert(#browser.Matches == 1 and first.Pin.Text == "Saved")
click("ScriptPin1")
assert(#browser.Matches == 0)
click("ScriptClear")
click("ScriptOpen1")
assert(
	opened == nil and browser.SelectedId == "a" and find("ScriptDetail").Visible,
	"selecting a card opens local details, never launches code"
)
assert(
	find("ScriptDetailDescription").Text == "Cash routing"
		and browser.Recent.a == 1
)
click("ScriptDetailBack")
assert(not find("ScriptDetail").Visible and find("ScriptRows").Visible)
click("ScriptView4")
assert(#browser.Matches == 1 and first.Id == "a")
click("ScriptClear")
click("ScriptFilters")
assert(browser.ShowFilters)
click("ScriptCategory")
assert(
	browser.Category == "All games",
	"opening choices does not cycle or change filters"
)
click("ScriptOption2")
assert(
	browser.Category == "Community"
		and #browser.Matches == 2
		and not browser.ShowFilters,
	"choose any category directly"
)
click("ScriptClear")
click("ScriptFilters")
click("ScriptCollection")
click("ScriptOption2")
assert(
	browser.Collection == "Chaos" and #browser.Matches == 1 and first.Id == "b"
)
click("ScriptClear")
click("ScriptFilters")
click("ScriptSort")
click("ScriptOption3")
assert(browser.Sort == "Recent")
click("ScriptClear")
tab.ApplyLibraryFilter("beta")
assert(#browser.Matches == 1 and tab.FilteredQuery == "beta")
click("ScriptClear")
entries[1] = {
	Id = "a",
	Name = "Alpha revised",
	Description = "Current metadata",
	Category = "Updated",
}
browser:Refresh()
click("ScriptOpen1")
assert(opened == nil and find("ScriptDetailName").Text == "Alpha revised")
click("ScriptDetailLaunch")
assert(
	opened == entries[1],
	"only explicit Continue delegates current metadata to the existing launch gate"
)
click("ScriptDetailBack")
-- Allocate all initial filter choices before measuring paging: choice rows are
-- lazy, whereas catalog cards and their callbacks are a fixed eight-slot pool.
local allocations, connections = #objects, #browser.Connections
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
	"paging/refresh reuse cards and callbacks"
)
local jump = find("ScriptPageJump")
jump.Text = "99999"
jump.FocusLost:Fire()
assert(browser.Page == browser.Pages)
jump.Text = "-99"
jump.FocusLost:Fire()
assert(browser.Page == 1)
jump.Text = "bad"
jump.FocusLost:Fire()
assert(browser.Page == 1)
browser:SetPage(7)
local firstIndex = (browser.Page - 1) * browser.PageSize
layout.OnLayout(272, 400)
assert(
	browser.Columns == 1
		and browser.PageSize == 2
		and browser.Page == math.floor(firstIndex / 2) + 1
)
assert(first.Frame.Size.X.Offset == 272 and first.Title.Size.X.Offset == -24)
layout.OnLayout(600, 158)
assert(
	browser.PageSize == 2
		and not find("ScriptView1").Visible
		and not find("ScriptFilterRow").Visible
)
assert(
	first.Frame.Size.Y.Offset <= 158 - 44 - 44
		and first.Open.Size.Y.Offset >= 32
)
-- A refresh removes the detail selection and its authority to delegate a launch.
browser:Select(first.Id)
entries = {}
browser:Refresh()
opened = nil
click("ScriptDetailLaunch")
assert(
	opened == nil and not find("ScriptDetail").Visible,
	"removed selected metadata cannot launch"
)
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
return "PASS: shipped card/detail browser: direct choices, local selection vs explicit launch, paging/jump/rotation/short landscape, search/category/collection/place/universe, pin/recent, latest-entry resolution, 504-entry constant UI allocations and disposal (API doubles)"
