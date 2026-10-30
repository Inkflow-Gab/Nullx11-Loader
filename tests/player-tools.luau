runLoader()
local root = find("SafeArea")
root.AbsoluteSize = Vector2.new(800, 600)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
find("Load").Activated:Fire()
assert(
	not root:FindFirstChild("VisualsWindow")
		and not root:FindFirstChild("AimWindow"),
	"separate windows build lazily"
)
assert(
	not runService.RenderBindings or next(runService.RenderBindings) == nil,
	"disabled tools have no camera binding"
)
find("Visuals window").Activated:Fire()
assert(find("VisualsWindow").Visible, "visual settings open separately")
assert(
	not playerGui:FindFirstChild("Nullx11PlayerOverlay"),
	"opening settings does not activate ESP"
)
find("Enable visuals").Activated:Fire()
advance(0.05)
local overlay = find("Nullx11PlayerOverlay")
local record = find("PlayerOverlay_2")
assert(record:FindFirstChild("PlayerBox").Visible, "enemy box")
assert(
	not overlay:FindFirstChild("PlayerOverlay_3"),
	"teammates filtered by default"
)
assert(record:FindFirstChild("PlayerHealth").Visible, "health bar")
assert(
	string.find(
		record:FindFirstChild("PlayerTag").Text,
		"Enemy Display",
		1,
		true
	),
	"display name"
)
local highlight
for _, object in ipairs(objects) do
	if
		object.ClassName == "Highlight"
		and object.Adornee == enemy.Character
	then
		highlight = object
		break
	end
end
assert(highlight, "enemy has a pooled highlight")
assert(
	highlight.Enabled
		and highlight.DepthMode == Enum.HighlightDepthMode.Occluded,
	"occluded chams by default"
)
find("Tracer lines").Activated:Fire()
advance(0.05)
assert(record:FindFirstChild("PlayerTracer").Visible, "tracer toggle")
workspaceService.Occluder = Instance.new("Part")
advance(0.05)
assert(
	not record:FindFirstChild("PlayerBox").Visible and not highlight.Enabled,
	"line-of-sight blocks ESP by default"
)
find("Through walls").Activated:Fire()
advance(0.05)
assert(
	record:FindFirstChild("PlayerBox").Visible
		and highlight.DepthMode == Enum.HighlightDepthMode.AlwaysOnTop,
	"explicit through-wall mode"
)
find("Visual team filter").Activated:Fire()
advance(0.05)
assert(
	find("PlayerOverlay_3"):FindFirstChild("PlayerBox").Visible,
	"team filter can be changed"
)
find("HideVisuals").Activated:Fire()
assert(
	not find("VisualsWindow").Visible
		and record:FindFirstChild("PlayerBox").Visible,
	"hiding controls does not silently disable visuals"
)
-- Off-screen and dead characters do not retain overlays.
local enemyRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
enemyRoot.Position = Vector3.new(200, 0, 50)
advance(0.05)
assert(
	not record:FindFirstChild("PlayerBox").Visible,
	"off-screen overlays hidden"
)
enemyRoot.Position = Vector3.new(3, 0, 50)
enemy.Character:FindFirstChildOfClass("Humanoid").Health = 0
advance(0.05)
assert(
	not highlight.Enabled or highlight.Adornee ~= enemy.Character,
	"dead character chams hidden"
)
enemy.Character:FindFirstChildOfClass("Humanoid").Health = 100
-- Aim always requires hold input and clear line of sight, even if visual x-ray is on.
find("Aim window").Activated:Fire()
find("Show FOV circle").Activated:Fire()
advance(0.02)
local circle = find("AimFOVCircle")
assert(
	circle.Visible
		and circle.Position.X == 400
		and circle.Position.Y == 300
		and circle.Size.X == 280,
	"centered pixel-radius circle"
)
find("CycleCircleColor").Activated:Fire()
advance(0.02)
local ink = circle:FindFirstChildOfClass("UIStroke").Color
assert(math.abs(ink.G - 222 / 255) < 0.001, "independent FOV color")
find("Enable aim assist").Activated:Fire()
assert(find("MobileAimPad").Visible, "touch aim control")
advance(0.02)
assert(not camera.CFrame.AimPoint, "enable alone cannot move camera")
local mouse = {
	UserInputType = Enum.UserInputType.MouseButton2,
	Position = Vector2.new(400, 300),
}
inputService.InputBegan:Fire(mouse, true)
advance(0.02)
assert(not camera.CFrame.AimPoint, "processed input ignored")
playerGui.GuiHits = { root }
inputService.InputBegan:Fire(mouse, false)
advance(0.02)
assert(not camera.CFrame.AimPoint, "wall blocks aim regardless of visuals")
workspaceService.Occluder = nil
advance(0.02)
assert(
	camera.CFrame.AimPoint == enemy.Character:FindFirstChild("Head").Position,
	"nearest eligible enemy selected, not teammate"
)
assert(
	camera.CFrame.Alpha > 0 and camera.CFrame.Alpha < 1,
	"strength below 100 smooths"
)
local strength = find("ValueStrength")
strength.Text = "0"
strength.FocusLost:Fire()
assert(strength.Text == "50", "strength lower bound enforced")
strength.Text = "1000"
strength.FocusLost:Fire()
assert(strength.Text == "50", "strength upper bound enforced")
strength.Text = "37"
strength.FocusLost:Fire()
advance(0.02)
assert(
	strength.Text == "37" and camera.CFrame.Alpha < 1,
	"arbitrary integer strength is editable"
)
local radius = find("ValueRadius")
radius.Text = "99999"
radius.FocusLost:Fire()
assert(radius.Text == "140", "FOV radius upper bound")
radius.Text = "90"
radius.FocusLost:Fire()
advance(0.02)
assert(circle.Size.X == 180, "typed FOV radius updates circle")
find("AimStrength100").Activated:Fire()
advance(0.02)
assert(camera.CFrame.Alpha == 1, "100 snaps to target direction")
inputService.InputEnded:Fire(mouse)
local stopped = camera.CFrame
advance(0.02)
assert(camera.CFrame == stopped, "release stops camera changes")
playerGui.GuiHits = { root, find("Panel") }
inputService.InputBegan:Fire(mouse, false)
advance(0.02)
assert(camera.CFrame == stopped, "clicking own UI cannot begin tracking")
playerGui.GuiHits = { root }
inputService.InputBegan:Fire(mouse, false)
inputService.FocusedTextBox = {}
advance(0.02)
assert(camera.CFrame == stopped, "text entry pauses aim")
inputService.FocusedTextBox = nil
camera.CameraType = Enum.CameraType.Scriptable
advance(0.02)
assert(camera.CFrame == stopped, "scripted cameras respected")
camera.CameraType = Enum.CameraType.Custom
inputService.WindowFocusReleased:Fire()
advance(0.02)
assert(camera.CFrame == stopped, "focus loss releases hold")
local touch = {
	UserInputType = Enum.UserInputType.Touch,
	Position = Vector2.new(100, 100),
}
find("HoldMobileAim").InputBegan:Fire(touch)
advance(0.02)
assert(camera.CFrame ~= stopped, "mobile touch hold tracks")
inputService.InputEnded:Fire(touch)
stopped = camera.CFrame
advance(0.02)
assert(camera.CFrame == stopped, "touch release outside pad stops tracking")
-- Camera replacement, radius and player removal are handled without stale adorners.
camera.ViewportSize = Vector2.new(1000, 700)
advance(0.02)
assert(
	circle.Position.X == 500 and circle.Position.Y == 350,
	"circle follows viewport resize"
)
workspaceService.CurrentCamera = nil
advance(0.02)
assert(
	not circle.Visible and not highlight.Enabled,
	"missing camera hides overlays"
)
workspaceService.CurrentCamera = camera
advance(0.05)
assert(circle.Visible, "camera restoration")
local previousModel = enemy.Character
local replacement = makePlayer("EnemyRespawn", 2, 4, "Red")
enemy.Character = replacement.Character
previousModel:Destroy()
advance(0.05)
local respawnHighlight = false
for _, object in ipairs(objects) do
	if
		object.ClassName == "Highlight"
		and object.Adornee == enemy.Character
		and object.Enabled
	then
		respawnHighlight = true
	end
end
assert(
	respawnHighlight and not record.Destroyed,
	"respawn reuses HUD and reassigns pooled highlight"
)
local replacementCamera = Instance.new("Camera")
replacementCamera.CFrame = transform(Vector3.zero)
replacementCamera.ViewportSize = Vector2.new(800, 600)
replacementCamera.CameraType = Enum.CameraType.Custom
replacementCamera.WorldToViewportPoint = camera.WorldToViewportPoint
workspaceService.CurrentCamera = replacementCamera
camera = replacementCamera
advance(0.05)
assert(
	circle.Position.X == 400 and circle.Position.Y == 300,
	"replacement camera used immediately"
)
find("VisualsDisableAll").Activated:Fire()
assert(
	not highlight.Enabled
		and not circle.Visible
		and next(runService.RenderBindings) == nil,
	"panic action clears all and unbinds"
)
-- A per-frame visibility budget bounds target ray tests.
local extra = {}
for i = 1, 80 do
	local other = makePlayer("Extra" .. i, 100 + i, (i % 10) - 5, "Red")
	table.insert(extra, other)
	playersService.PlayerAdded:Fire(other)
end
find("Enable aim assist").Activated:Fire()
inputService.InputBegan:Fire(mouse, false)
workspaceService.Occluder = Instance.new("Part")
workspaceService.RayCount = 0
advance(0.02)
assert(workspaceService.RayCount == 8, "bounded aim visibility checks")
workspaceService.Occluder = nil
inputService.InputEnded:Fire(mouse)
find("Enable aim assist").Activated:Fire()
find("Enable visuals").Activated:Fire()
advance(0.05)
local activeHighlights = 0
local allocatedHighlights = 0
local activeBoxes = 0
for _, object in ipairs(objects) do
	if object.ClassName == "Highlight" and not object.Destroyed then
		allocatedHighlights += 1
	end
	if
		object.ClassName == "Highlight"
		and object.Enabled
		and not object.Destroyed
	then
		activeHighlights += 1
	end
	if
		object.Name == "PlayerBox"
		and object.Visible
		and not object.Destroyed
	then
		activeBoxes += 1
	end
end
assert(
	activeHighlights <= 24 and allocatedHighlights <= 24 and activeBoxes <= 32,
	"rendered player/highlight caps"
)
local allocated = #objects
for i = 1, 60 do
	advance(1 / 60)
end
assert(#objects == allocated, "steady-state overlays reuse instances")
workspaceService.Occluder = Instance.new("Part")
workspaceService.RayCount = 0
find("Through walls").Activated:Fire()
advance(0.05)
assert(
	workspaceService.RayCount == 48,
	"ESP occlusion checks are bounded on crowded servers"
)
workspaceService.Occluder = nil
find("Through walls").Activated:Fire()
advance(0.05)
local first = extra[1]
local firstOverlay = overlay:FindFirstChild("PlayerOverlay_" .. first.UserId)
playersService.PlayerRemoving:Fire(first)
assert(
	not firstOverlay or firstOverlay.Destroyed,
	"player removal cleans resources"
)
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.End }, false)
assert(next(runService.RenderBindings) == nil, "END is an emergency off switch")
root.AbsoluteSize = Vector2.new(700, 320)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	find("VisualsWindow").Size.Y <= 296 and find("AimWindow").Size.Y <= 296,
	"settings fit short landscape"
)
find("Close").Activated:Fire()
assert(overlay.Destroyed, "main close destroys independent overlay screen")
for _, object in ipairs(objects) do
	if object.ClassName == "Highlight" then
		assert(object.Destroyed, "main close removes character highlights")
	end
end
assert(
	next(runService.RenderBindings) == nil,
	"main close leaves no camera binding"
)
assert(#warnings == 0, "no rendering exceptions")
return "PASS: separate player-tool windows, ESP/chams/boxes/lines/filters, camera FOV/colors/hold/strength/guards, touch, resource caps, emergency off, and cleanup (mocked)"
