-- Run the actual new-GUI opening bridge and execution view with UI API doubles.
local Draw = {}
function Draw.New(class, properties)
	local object = Instance.new(class)
	for key, value in pairs(properties) do
		object[key] = value
	end
	return object
end
function Draw.Box(class, properties)
	return Draw.New(class, properties)
end
function Draw.Text(properties)
	return Draw.New("TextLabel", properties)
end
function Draw.Emblem(parent)
	return Draw.New("Frame", { Parent = parent })
end
local Theme = { Bind = function() end, UnbindTree = function() end }
local Anim = {
	Tween = function(object, properties)
		for key, value in pairs(properties) do
			object[key] = value
		end
	end,
}
local Library = { Hooks = {} }
function Library:OnUnload(callback)
	table.insert(self.Hooks, callback)
end
local State = {
	Gui = Draw.New(
		"ScreenGui",
		{ Parent = Instance.new("CoreGui"), DisplayOrder = 100 }
	),
}
-- @EXECUTION_MODEL
-- @EXECUTION_VIEW
local job = Library:BeginExecution("Layer fixture")
local gui = find("Nullx11ExecutionOverlay")
assert(
	find("ExecutionCard").ClassName == "Frame" and find("ExecutionCard").Visible,
	"execution sheet cannot be an empty mobile group texture"
)
assert(
	gui
		and gui.Parent == State.Gui.Parent
		and gui.DisplayOrder > State.Gui.DisplayOrder
)
local newGameGui =
	Draw.New("ScreenGui", { DisplayOrder = 100, Parent = State.Gui.Parent })
assert(
	gui.DisplayOrder > newGameGui.DisplayOrder,
	"new game window cannot cover execution sheet"
)
job:Phase(2, "real response")
job:Phase(3, "compile")
job:Phase(4, "initialize")
job:Close()
assert(
	gui.Destroyed and newGameGui.Parent and job.Model.Started,
	"hide does not remove the game GUI"
)
local handoff = Library:BeginExecution("Ready UI fixture")
handoff:Phase(4, "controls connected")
handoff:Finish(true)
assert(
	handoff.Closed and handoff.Model.Status == "complete",
	"ready UI immediately takes over; loader sheet cannot swallow its input"
)
local failure = Library:BeginExecution("Failure fixture")
failure:Fail("real runtime error")
assert(
	not find("Nullx11ExecutionOverlay").Destroyed
		and failure.Model.Status == "failed"
)
for _, callback in ipairs(Library.Hooks) do
	callback()
end
assert(failure.Closed)
return "PASS: actual execution overlay uses an independently ordered ScreenGui above new game windows; close, error persistence and owned unload do not remove game GUI (development UI doubles only)"
