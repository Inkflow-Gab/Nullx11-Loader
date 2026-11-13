-- Additional real-module contracts; fixtures model APIs, not Roblox/gameplay.
local function ref(value)
	local r = { Value = value, Watchers = {} }
	function r:Get()
		return self.Value
	end
	function r:Set(v)
		self.Value = v
		for _, watcher in ipairs(self.Watchers) do
			watcher(v)
		end
	end
	function r:Subscribe(callback, immediate)
		table.insert(self.Watchers, callback)
		if immediate then
			callback(self.Value)
		end
		return function() end
	end
	return r
end
local lib = fixtureLibrary()
lib.Ref = ref
lib.Watch = function(source, callback, options)
	assert(type(options) == "table", "Watch options must be a table")
	return source:Subscribe(callback, options.Immediate)
end
local originalCreateWindow = lib.CreateWindow
function lib:CreateWindow(spec)
	local native = originalCreateWindow(self, spec)
	function native:AddSettingsTab()
		self.SettingsBuilt = true
	end
	return native
end
-- @CHILLI_MODULE
local pending, cleanup = {}, nil
local runtime = { Ready = false, Active = true }
function runtime.Guard(callback)
	return function(...)
		if runtime.Ready and runtime.Active then
			return callback(...)
		end
	end
end
function runtime.AddCleanup(callback)
	cleanup = callback
end
function runtime.Start()
	runtime.Ready = true
	runtime.Started = true
end
local adapter = makeChilliAdapter(lib, runtime)
local window = adapter:CreateWindow({ Name = "Untrusted original window" })
assert(lib.Spec.Title == "Nullx11" and lib.Spec.Intro == false)
local tab = window:CreateTab("Stealer")
local section = tab:CreateSection({ Name = "Auto Steal" })
local values = {}
local toggle = section:CreateToggle({
	Name = "Auto Steal",
	Default = true,
	Callback = function(value)
		table.insert(values, value)
	end,
})
assert(
	toggle:Get() == false,
	"Original default-on metadata must not start automation"
)
-- Give the native fixture a real ref/visibility surface used by parent dependencies.
toggle.Native.Ref = ref(false)
local originalAddSlider = section.CreateSlider
local slider = originalAddSlider(section, {
	Name = "Distance",
	Min = 0,
	Max = 100,
	Default = 58,
	Increment = 1,
	Unit = { Default = "M/s", Options = { "K/s", "M/s" } },
})
function slider.Native:SetRange(min, max)
	self.Spec.Min, self.Spec.Max = min, max
end
assert(slider:Get() == 58 and slider:GetUnit() == "M/s")
slider:SetRange(10, 200, false)
assert(slider.Native.Spec.Min == 10 and slider.Native.Spec.Max == 200)
local dropdown = section:CreateMultiDropdown({
	Name = "Information",
	Options = { "Name", "Value" },
	Default = { "Name" },
})
assert(dropdown.Native.Spec.Multi == true)
dropdown:SetOptions({ "Name", "Rarity" }, { Rarity = true }, false)
assert(dropdown:Get().Rarity)
local capWrites = 0
section:CreateSlider({
	Name = "FPS Cap",
	Min = 30,
	Max = 1000,
	Default = 240,
	Callback = function()
		capWrites += 1
	end,
})
local state = window:CreateState({ Name = "Position", Default = { X = 10 } })
state:Set({ X = 20 })
assert(window:GetState("Position"):Get().X == 20)
adapter:Finalize({})
assert(
	runtime.Started and #values == 1 and values[1] == false and capWrites == 0
)
toggle:Set(true, true)
assert(values[#values] == true)
toggle:Set(false, false)
assert(
	values[#values] == true,
	"Silent Set must not fire the original callback"
)
cleanup()
assert(values[#values] == false and lib.Window.SettingsBuilt)

-- Owned runtime: source restoration must not depend on synchronous Destroying/Event delivery.
local work, cancelled, destroyed, invoked, restored = {}, {}, 0, 0, 0
local task = {
	spawn = function(thread)
		table.insert(work, thread)
		return thread
	end,
	defer = function(thread)
		table.insert(work, thread)
		return thread
	end,
	delay = function(_, thread)
		table.insert(work, thread)
		return thread
	end,
	wait = function()
		return 0.1
	end,
	cancel = function(thread)
		cancelled[thread] = true
	end,
}
local Instance = {
	new = function(class)
		local instance = { ClassName = class, Name = class }
		function instance:IsA(name)
			return name == class
		end
		function instance:Destroy()
			self.Destroyed = true
			destroyed += 1
		end
		-- Intentionally does not deliver cleanup events synchronously.
		function instance:Fire() end
		return instance
	end,
}
local dispose
local context = {
	RegisterCleanup = function(callback)
		dispose = callback
	end,
}
-- @OWNED_RUNTIME
local owned = makeOwnedRuntime(context)
local signal = newSignal()
local connection = owned.Track(signal:Connect(owned.Guard(function()
	invoked += 1
end)))
local cleanupSignal = owned.Instance.new("BindableEvent")
cleanupSignal.Name = "Cleanup"
owned.Cleanup(function()
	restored += 1
end)
local workerRan = false
owned.Task.spawn(function()
	workerRan = true
end)
assert(#work == 0, "Workers wait for finalized OFF defaults")
signal:Fire()
assert(invoked == 0)
owned.Start()
signal:Fire()
assert(invoked == 1 and #work == 1)
assert(coroutine.resume(work[1]))
assert(workerRan)
local pendingThread = owned.Task.delay(10, function()
	error("Must not run after unload")
end)
local renderService = { Unbound = {} }
function renderService:BindToRenderStep(name, _, callback)
	self.Name, self.Callback = name, callback
end
function renderService:UnbindFromRenderStep(name)
	self.Unbound[name] = true
end
owned.BindRender(renderService, "owned-render", 200, function()
	invoked += 1
end)
dispose()
assert(
	restored == 1
		and destroyed == 1
		and not connection.Connected
		and cancelled[pendingThread]
		and renderService.Unbound["owned-render"]
)
signal:Fire()
renderService.Callback()
assert(invoked == 1)
dispose()
assert(restored == 1 and destroyed == 1)

-- Exact execution-state module: stage changes come only from observed boundaries.
-- @EXECUTION_STATE
local renders = 0
local model = makeExecutionState(function()
	renders += 1
end)
assert(model.Completed == 0 and not model.Started)
model:Phase(2, "143 bytes")
assert(model.Completed == 1 and model.Detail == "143 bytes")
assert(not pcall(function()
	model:Phase(1)
end), "Stages cannot go backwards")
model:Dismiss()
assert(model.Status == "cancelled" and not model:CanContinue())
assert(not model:Phase(3))
local running = makeExecutionState(function() end)
running:Phase(4, "Opening actual UI")
running:Dismiss()
assert(
	running.Status == "running" and running.Started,
	"Hiding initialization is not game cancellation"
)
running:Finish()
assert(running.Completed == 4 and running.Status == "complete")
local failed = makeExecutionState(function() end)
failed:Fail("fixture compile failure")
failed:Finish()
assert(
	failed.Status == "failed"
		and failed.Completed == 0
		and failed.Detail == "fixture compile failure"
)
return "PASS: actual Chilli-shaped Nullx11 adapter, off defaults/silent updates/units/manual state, owned cleanup under deferred events, task/render disposal and truthful execution stages (development fixtures only)"
