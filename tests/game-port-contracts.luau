-- Development-only adapter/session/launch contracts. These fixtures never ship
-- in the client and do not demonstrate native rendering or successful gameplay.
local env = {}
local getgenv = function()
	return env
end
local Enum =
	{ KeyCode = { RightShift = "RightShift", LeftControl = "LeftControl" } }
local now = 0
local os = {
	clock = function()
		return now
	end,
}
local task = {
	wait = function(dt)
		now += dt or 0.01
	end,
}
local warnings = {}
local warn = function(message)
	table.insert(warnings, message)
end

local function newSignal()
	local signal = { Listeners = {} }
	function signal:Connect(callback)
		local connection = { Connected = true }
		function connection:Disconnect()
			self.Connected = false
		end
		table.insert(
			self.Listeners,
			{ Connection = connection, Callback = callback }
		)
		return connection
	end
	function signal:Fire(...)
		for _, listener in ipairs(self.Listeners) do
			if listener.Connection.Connected then
				listener.Callback(...)
			end
		end
	end
	return signal
end
local function fixtureLibrary()
	local lib = {
		Hooks = {},
		Controls = {},
		Themes = { "Nullx11", "Dark" },
		Notifications = {},
	}
	local group = {}
	local function control(kind, id, spec)
		local c = {
			Kind = kind,
			Spec = spec,
			Value = spec.Default,
			Values = spec.Values,
			Title = spec.Text or spec.Title,
			Content = spec.Content,
		}
		function c:SetValue(value)
			self.Value = value
			if spec.Callback then
				spec.Callback(value)
			end
		end
		function c:SetText(value)
			self.Text = value
		end
		function c:SetTitle(value)
			self.Title = value
		end
		function c:SetContent(value)
			self.Content = value
		end
		function c:SetValues(value)
			self.Values = value
		end
		if id then
			lib.Controls[id] = c
		end
		table.insert(lib.Controls, c)
		return c
	end
	function group:AddToggle(id, spec)
		return control("Toggle", id, spec)
	end
	function group:AddSlider(id, spec)
		return control("Slider", id, spec)
	end
	function group:AddDropdown(id, spec)
		return control("Dropdown", id, spec)
	end
	function group:AddInput(id, spec)
		return control("Input", id, spec)
	end
	function group:AddButton(spec)
		return control("Button", nil, spec)
	end
	function group:AddParagraph(spec)
		return control("Paragraph", nil, spec)
	end
	function group:AddLabel(text)
		return control("Label", nil, { Text = text })
	end
	function group:AddDivider()
		return control("Divider", nil, {})
	end
	local native = { Tabs = {}, Body = {} }
	function native:AddTab(name)
		local tab = { Name = name }
		function tab:AddLeftGroupbox()
			return group
		end
		function tab:AddRightGroupbox()
			return group
		end
		table.insert(native.Tabs, tab)
		return tab
	end
	function native:SelectTab(tab)
		self.ActiveTab = tab
	end
	function lib:CreateWindow(spec)
		self.Spec, self.Window = spec, native
		if spec.OnUnlocked then
			spec.OnUnlocked()
		end
		return native
	end
	function lib:SetTheme(name)
		self.Theme = name
	end
	function lib:SetMenuKey(key)
		self.MenuKey = key
	end
	function lib:Notify(...)
		table.insert(self.Notifications, { ... })
	end
	function lib:OnUnload(callback)
		table.insert(self.Hooks, callback)
	end
	function lib:Unload()
		if self.Unloaded then
			return
		end
		self.Unloaded = true
		for _, hook in ipairs(self.Hooks) do
			hook()
		end
	end
	function lib:SaveConfig(name)
		self.Saved = name
		return true
	end
	function lib:LoadConfig(name)
		self.Loaded = name
		return true
	end
	lib.Configs = {
		List = function()
			return { "one" }
		end,
		Delete = function(name)
			lib.Deleted = name
			return true
		end,
	}
	return lib
end

-- Insert the actual modules here, inside the fixture's lexical environment.
-- @PORT_MODULES

local lib = fixtureLibrary()
local bridge = makeAdapter(lib, "Nullx11 - Rosu Mania", "Nullx11 Rosu")
local window = bridge:CreateWindow({})
assert(lib.Spec.Theme == "Nullx11" and lib.Spec.ConfigFolder == "Nullx11 Rosu")
local tab = window:CreateTab({ name = "Timing", icon = "settings" })
tab:CreateSection({ name = "Precision" })
local toggled, lead, selected, typed, clicked
local toggle = tab:CreateToggle({
	name = "Autoplay",
	flag = "autoplay",
	value = false,
	callback = function(v)
		toggled = v
	end,
})
assert(
	toggle.Native.Value == false and toggled == nil,
	"construction must not enable gameplay"
)
toggle:Set(true)
assert(toggled == true and toggle.Native.Value == true)
local slider = tab:CreateSlider({
	name = "Lead",
	range = { -0.12, 0.12 },
	value = 0.005,
	increment = 0.001,
	callback = function(v)
		lead = v
	end,
})
assert(
	slider.Native.Spec.Min == -0.12
		and slider.Native.Spec.Max == 0.12
		and slider.Native.Spec.Rounding == 3
)
slider:Set(0.007)
assert(lead == 0.007)
local dropdown = tab:CreateDropdown({
	name = "Strategy",
	options = { "Auto", "Hero" },
	value = "Auto",
	callback = function(v)
		selected = v
	end,
})
dropdown:Refresh({ "Chicken" })
dropdown:Select("Chicken")
assert(selected == "Chicken" and dropdown.Native.Values[1] == "Chicken")
local input = tab:CreateInput({
	name = "Name",
	value = "one",
	callback = function(v)
		typed = v
	end,
})
input:Set("two")
assert(typed == "two")
local button = tab:CreateButton({
	name = "Release",
	callback = function()
		clicked = true
	end,
})
button.Native.Spec.Func()
assert(clicked)
local paragraph = tab:CreateText({ name = "Status", text = "Idle" })
paragraph:SetTitle("Runner")
paragraph:SetDesc("Stopped")
assert(
	paragraph.Native.Title == "Runner" and paragraph.Native.Content == "Stopped"
)
paragraph:Set({ Title = "Catcher", Desc = "Off" })
assert(
	paragraph.Native.Title == "Catcher" and paragraph.Native.Content == "Off"
)
tab:Select()
assert(window.Native.ActiveTab == tab.Native)
window:ChangeTheme("Dark")
window:SetTransparency(true)
window:SetToggleKey("Insert")
assert(
	lib.Theme == "Dark"
		and window.Native.Body.BackgroundTransparency == 0.2
		and lib.MenuKey == "Insert"
)
local config = window.ConfigManager:CreateConfig("one")
config:Register("enabled", toggle)
config:Save()
config:Load()
config:Delete()
assert(
	config.Controls.enabled == toggle.Native
		and lib.Saved == "one"
		and lib.Loaded == "one"
		and lib.Deleted == "one"
)
assert(window.ConfigManager:AllConfigs()[1] == "one")

-- Actual session cancellation and budget logic, with a deterministic local clock.
local sessionLib = fixtureLibrary()
local context = makeSession("forge", sessionLib)
local signal = newSignal()
local events = 0
local connection = context.Connect(signal, function()
	events += 1
end)
signal:Fire()
assert(events == 1)
local remote = { Times = {} }
function remote:InvokeServer(value)
	table.insert(self.Times, now)
	return value, "server fixture reply"
end
for i = 1, 20 do
	local result, reply = context.Send(remote, "InvokeServer", i)
	assert(result == i and reply == "server fixture reply")
end
for i = 2, #remote.Times do
	assert(remote.Times[i] - remote.Times[i - 1] >= 0.125)
end
local cleaned = 0
context.RegisterCleanup(function()
	cleaned += 1
	context.Send(remote, "InvokeServer", "teardown")
end)
env.Nullx11GameSessions.forge.Unload()
assert(
	not context.Alive
		and not connection.Connected
		and cleaned == 1
		and env.Nullx11GameSessions.forge == nil
)
signal:Fire()
assert(events == 1 and not pcall(context.Send, remote, "InvokeServer", "late"))
sessionLib:Unload()
assert(cleaned == 1)
local firstLib = fixtureLibrary()
local old = makeSession("rosu", firstLib)
local replacement = makeSession("rosu", fixtureLibrary())
assert(
	not old.Alive and replacement.Alive and firstLib.Unloaded,
	"rerun replaces only its game session"
)

-- Wrong-place notice has no teleport service or queue dependency.
local game = {
	GetService = function()
		error("No service may be requested by this notice")
	end,
}
local queue_on_teleport = function()
	error("No game-launch queue")
end
-- @LAUNCH_MODULE
local wrong = fixtureLibrary()
wrongPlace(wrong, {
	Id = "huss",
	Name = "Nullx11 - hussvalley",
	Author = "Original attribution",
}, "unused")
assert(#wrong.Controls == 3)
assert(wrong.Controls[1].Content:find("No teleport", 1, true))
assert(wrong.Controls[2].Content == "Original attribution")
wrong.Controls[3].Spec.Func()
assert(wrong.Unloaded)

-- @WIND_MODULE
local eggLib = fixtureLibrary()
local wind = makeWindAdapter(eggLib, makeAdapter(eggLib, "Steal An Egg", "egg"))
local eggWindow = wind:CreateWindow({})
local eggTab = eggWindow:Tab({ Title = "Inventory" })
eggTab:Select()
eggTab:Section({ Title = "Filters" })
local selected
local multi = eggTab:Dropdown({
	Title = "Rarities",
	Values = { "Rare", "Epic" },
	Multi = true,
	Value = {},
	Callback = function(value)
		selected = value
	end,
})
assert(multi.Native.Spec.Multi == true)
multi:Set({ Epic = true })
assert(#selected == 1 and selected[1] == "Epic")
multi:Refresh({ "Cosmic" })
multi:Set({ Cosmic = true })
assert(selected[1] == "Cosmic")
local speed = eggTab:Slider({
	Title = "Speed",
	Value = { Min = 10, Max = 200, Default = 120, Step = 0.5 },
})
assert(
	speed.Native.Spec.Min == 10
		and speed.Native.Spec.Max == 200
		and speed.Native.Value == 120
)
local label = eggTab:Paragraph({ Title = "Idle", Desc = "Ready" })
label:SetTitle("Active")
assert(label.Native.Title == "Active")
assert(
	eggWindow.ConfigManager:DeleteConfig("egg-save")
		and eggLib.Deleted == "egg-save"
)
local destroyed = 0
eggWindow:OnDestroy(function()
	destroyed += 1
end)
eggWindow:Destroy()
eggWindow:Destroy()
assert(eggLib.Unloaded and destroyed == 1)

-- Actual workspace teardown hook, evaluated with independent real game contexts.
local stoppedByLoader = 0
local gameLib = fixtureLibrary()
local independent = makeSession("egg", gameLib)
independent.RegisterCleanup(function()
	stoppedByLoader += 1
end)
local library = fixtureLibrary()
local gui = { Destroying = newSignal() }
local function connect(signal, callback)
	return signal:Connect(callback)
end
-- @WORKSPACE_TEARDOWN
gui.Destroying:Fire()
assert(
	library.Unloaded
		and independent.Alive
		and not gameLib.Unloaded
		and stoppedByLoader == 0,
	"Loader unload must preserve executed scripts"
)
env.Nullx11GameSessions.egg.Unload()
assert(stoppedByLoader == 1 and not independent.Alive)
return "PASS: real adapters (including multi-select), isolated sessions, pacing, explicit cleanup and no-teleport compatibility notice (development fixtures only)"
