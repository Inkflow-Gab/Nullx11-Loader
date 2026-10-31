-- Actual native browser component with layout/widget API doubles, not a visual
-- rendering claim. The model and view are both the shipped implementations.
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
local Icons = {
	Create = function(parent)
		return Draw.New("Frame", { Parent = parent })
	end,
}
local unbound = 0
local Theme = {
	UnbindTree = function()
		unbound += 1
	end,
}
local makeScriptLibraryModel
-- @BROWSER_MODEL
-- @BROWSER_VIEW
local controls = {}
local group = {}
function group:AddLabel(text)
	local label = { Text = text }
	function label:SetText(value)
		self.Text = value
	end
	return label
end
for _, method in ipairs({ "AddInput", "AddDropdown", "AddToggle" }) do
	group[method] = function(_, id, spec)
		local widget = { Spec = spec, Value = spec.Default }
		function widget:SetValues(values)
			self.Values = values
		end
		function widget:SetValue(value)
			self.Value = value
			spec.Callback(value)
		end
		controls[id] = widget
		return widget
	end
end
function group:AddButton(spec)
	controls[spec.Text] = spec
end
function group:AddParagraph() end
local tab = { Left = { Items = {} } }
function tab.Left:Add(frame, spec)
	table.insert(self.Items, { Frame = frame, Spec = spec })
	return self.Items[#self.Items]
end
function tab.Left:MarkDirty()
	self.Dirty = true
end
function tab:ApplyColumns()
	self.Changed = true
end
function tab:AddLeftGroupbox()
	return group
end
function tab:AddRightGroupbox()
	error("browser must use the full responsive page width")
end
game.PlaceId = 9991
local entries = {
	{
		Id = "a",
		Name = "Alpha",
		Description = "Cash routing",
		Author = "Alice",
		File = "a.luau",
		Category = "Simulator",
		GamePlaceId = game.PlaceId,
	},
	{
		Id = "b",
		Name = "Beta",
		Description = "Aim controls",
		Author = "Bob",
		File = "b.luau",
		Category = "Shooter",
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
assert(
	#browser.Matches == 2 and opened == nil,
	"browsing never starts game code"
)
local a, b = browser.Cards.a, browser.Cards.b
local grid = tab.Left.Items[1]
assert(grid.Spec.Height(650) == 248 and grid.Spec.Height(320) == 508)
grid.Spec.OnLayout(650, 248)
assert(
	a.Frame.Position.Y == b.Frame.Position.Y
		and a.Frame.Position.X ~= b.Frame.Position.X,
	"wide: two columns"
)
grid.Spec.OnLayout(320, 508)
assert(
	a.Frame.Position.X == b.Frame.Position.X
		and a.Frame.Position.Y ~= b.Frame.Position.Y,
	"mobile: one column"
)
controls.ScriptLibrarySearch:SetValue("CASH alice")
assert(#browser.Matches == 1 and a.Frame.Visible and not b.Frame.Visible)
controls.ScriptLibrarySearch:SetValue("[")
assert(#browser.Matches == 0, "search is literal, not an injected pattern")
controls.ScriptLibrarySearch:SetValue("")
assert(browser.Cards.a == a, "search reuses cards and callbacks")
controls.ScriptLibraryCategory:SetValue("Shooter")
assert(#browser.Matches == 1 and browser.Matches[1] == b)
controls.ScriptLibraryCategory:SetValue("All games")
controls.ScriptLibraryPlace:SetValue(true)
assert(#browser.Matches == 1 and browser.Matches[1] == a)
controls.ScriptLibraryPlace:SetValue(false)
tab.ApplyLibraryFilter("Beta")
assert(#browser.Matches == 1 and browser.Matches[1] == b)
tab.ApplyLibraryFilter("")
local obsolete = a.Frame:FindFirstChild("OpenScript_a")
local updated = {
	Id = "a",
	Name = "Changed",
	Description = "Updated source",
	File = "new.luau",
	Category = "Adventure",
}
entries = { updated }
browser:Refresh()
assert(browser.Cards.b == nil and unbound == 1 and not b.Connection.Connected)
obsolete.Activated:Fire()
assert(opened == updated, "resolve current manifest entry, never stale source")
entries = {}
browser:Refresh()
opened = nil
obsolete.Activated:Fire()
assert(opened == nil and not a.Connection.Connected)
assert(
	#browser.Matches == 0
		and makeScriptLibraryModel.Badge(updated, game.PlaceId)
			== "MODULE CHECK ON LAUNCH"
)
controls["Refresh repository manifest"].Func()
assert(refreshes == 1)
for _, callback in ipairs(Library.Hooks) do
	callback()
end
assert(next(browser.Cards) == nil)
return "PASS: shipped Scripts browser/model: literal multi-word creator/feature search, category/place filters, responsive layout, pooled cards, refresh invalidation/current-entry launch and owned callback disposal (development API doubles only)"
