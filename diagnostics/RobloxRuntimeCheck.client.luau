--!strict
-- Run manually INSIDE ROBLOX after Nullx11, not in the Node test harness.
-- Uses actual services, real characters, raycasts and render callbacks.
-- Does not steer the camera, teleport, fetch code, fabricate targets, or grant a PASS for aim.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
assert(
	RunService:IsClient(),
	"Run this as a client LocalScript / client runtime script"
)
local player = assert(Players.LocalPlayer, "LocalPlayer unavailable")
local rows = { "NULLX11 / REAL ROBLOX RUNTIME REPORT" }
local function record(title: string, check: () -> any)
	local ok, result = pcall(check)
	table.insert(
		rows,
		title
			.. ": "
			.. (if ok then tostring(result) else "ERROR / " .. tostring(result))
	)
end
record("Other Players (NPCs excluded)", function()
	return math.max(0, #Players:GetPlayers() - 1)
end)
record("Camera", function()
	local camera = assert(Workspace.CurrentCamera, "CurrentCamera missing")
	return tostring(camera.CameraType)
		.. " / viewport "
		.. tostring(camera.ViewportSize)
end)
record("Local avatar", function()
	local character = assert(player.Character, "Character missing")
	local humanoid =
		assert(character:FindFirstChildOfClass("Humanoid"), "Humanoid missing")
	return "health "
		.. humanoid.Health
		.. " / root "
		.. tostring(
			character:FindFirstChild("HumanoidRootPart")
				or character.PrimaryPart
		)
end)
record("Built-in display fonts", function()
	return tostring(Enum.Font.Arcade)
		.. " / "
		.. tostring(Enum.Font.GrenzeGotisch)
end)
record("Highlight API", function()
	local probe = Instance.new("Highlight")
	probe.Name = "Nullx11TemporaryRuntimeProbe"
	probe.Enabled = false
	probe.Adornee = player.Character
	probe.Parent = Workspace
	probe:Destroy()
	return "created and destroyed (rendering still requires visual inspection)"
end)
record("Projection / line of sight", function()
	local camera = assert(Workspace.CurrentCamera, "Camera missing")
	for _, other in ipairs(Players:GetPlayers()) do
		if other == player or not other.Character then
			continue
		end
		local part = other.Character:FindFirstChild("Head")
			or other.Character.PrimaryPart
		if not part or not part:IsA("BasePart") then
			continue
		end
		local point, onScreen = camera:WorldToViewportPoint(part.Position)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = if player.Character
			then { player.Character, camera }
			else { camera }
		local hit = Workspace:Raycast(
			camera.CFrame.Position,
			part.Position - camera.CFrame.Position,
			params
		)
		local clear = not hit or hit.Instance:IsDescendantOf(other.Character)
		return "sample target on-screen="
			.. tostring(onScreen)
			.. " / Z="
			.. math.floor(point.Z)
			.. " / LOS="
			.. tostring(clear)
	end
	return "NO SAMPLE: run a 2-client Studio session or join another real player"
end)
-- Real late-render binding, measured across actual rendered frames, then removed.
local name = "Nullx11_RuntimeProbe_" .. tostring(os.clock())
local frames = 0
local bound, reason = pcall(function()
	RunService:BindToRenderStep(
		name,
		Enum.RenderPriority.Last.Value - 1,
		function()
			frames += 1
		end
	)
end)
if bound then
	for _ = 1, 3 do
		RunService.RenderStepped:Wait()
	end
	RunService:UnbindFromRenderStep(name)
	table.insert(
		rows,
		"Late render binding: " .. frames .. " real callbacks observed"
	)
else
	table.insert(rows, "Late render binding: ERROR / " .. tostring(reason))
end
record("Loader / text bounds", function()
	local gui = assert(
		player:WaitForChild("PlayerGui"):FindFirstChild("Nullx11Loader"),
		"Run Nullx11 first"
	)
	local clipped = 0
	for _, object in ipairs(gui:GetDescendants()) do
		if
			object:IsA("TextLabel")
			and object.Visible
			and not object.TextScaled
			and object.AbsoluteSize.Y > 0
		then
			if object.TextBounds.Y > object.AbsoluteSize.Y + 2 then
				clipped += 1
			end
		end
	end
	return "mounted / "
		.. clipped
		.. " potentially vertically clipped labels (inspect visible ancestor state)"
end)
table.insert(
	rows,
	"This reports native API observations, NOT aim accuracy, Delta certification, or server acceptance."
)
warn(table.concat(rows, "\n"))
