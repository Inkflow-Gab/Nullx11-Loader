-- Actual shared-window fitting/clamping logic, viewport readiness and manual moves.
local UDim2 = midiUDim2
local Config =
	{ Window = { Margin = 12, TouchMargin = 8, Shadow = 6, Topbar = 48 } }
local State =
	{ Gui = { AbsoluteSize = Vector2.new(0, 0) }, UserScale = 1, Touch = false }
local Float = { Clamp = function() end }
local Window = {}
-- @WINDOW_FIT
local window = setmetatable({
	Desired = Vector2.new(600, 400),
	Root = { Position = UDim2.fromScale(0.5, 0.5) },
}, { __index = Window })
function window:MinSize()
	return 200, 200
end
function window:ApplyLayout()
	self.Root.Size = UDim2.fromOffset(self.Size.X + 6, self.Size.Y + 6)
end
window:FitViewport()
assert(
	window.Size == nil and window.Root.Position.X.Scale == 0.5,
	"zero viewport cannot pin the loader in a corner"
)
State.Gui.AbsoluteSize = Vector2.new(1000, 700)
window:FitViewport()
assert(
	window.Root.Position.X.Scale == 0.5 and window.Root.Position.X.Offset == 0
)
assert(
	window.Root.Position.Y.Offset == -203,
	"top-anchored panel is vertically centered with its shadow"
)
State.Gui.AbsoluteSize = Vector2.new(390, 640)
window:FitViewport()
assert(
	window.Root.Position.X.Scale == 0.5 and window.Root.Position.X.Offset == 0
)
window.Visible = true
window.UserPositioned = true
window.Root.Position = UDim2.fromOffset(195, 80)
window:FitViewport()
assert(
	window.Root.Position.Y.Offset == 80,
	"viewport updates preserve an explicitly moved window"
)
-- A hidden, top-anchored window may already have animated into the dock.
-- Reflow must clamp its saved restore target, never save that dock position.
window.Visible = false
window.RestPosition = UDim2.fromOffset(195, 80)
window.Root.Position = UDim2.fromOffset(360, 600)
State.Gui.AbsoluteSize = Vector2.new(700, 390)
window:FitViewport()
assert(
	window.RestPosition.Y.Offset == 80 and window.Root.Position.Y.Offset == 80,
	"hidden manual target survives rotation instead of snapping to dock"
)
window.UserPositioned = false
State.Gui.AbsoluteSize = Vector2.new(1000, 700)
window:FitViewport()
assert(window.RestPosition.Y.Offset == -203)
State.Gui.AbsoluteSize = Vector2.new(700, 310)
window:FitViewport()
assert(
	window.RestPosition == window.Root.Position
		and window.RestPosition.Y.Offset ~= -203,
	"startup/rotation refreshes hidden restore offset before reveal"
)
return "PASS: actual loader fitting waits for valid viewport, centers the full panel, adapts portrait and preserves explicit dragging"
