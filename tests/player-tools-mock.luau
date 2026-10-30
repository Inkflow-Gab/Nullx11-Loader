-- Projection/raycast/camera doubles. These do not emulate Roblox rendering or physics.
local spatial = {}
spatial.__index = function(value, key)
	if key == "Magnitude" then
		return math.sqrt(value.X ^ 2 + value.Y ^ 2 + value.Z ^ 2)
	end
	return spatial[key]
end
spatial.__add = function(a, b)
	return setmetatable(
		{ X = a.X + b.X, Y = a.Y + b.Y, Z = a.Z + b.Z },
		spatial
	)
end
spatial.__sub = function(a, b)
	return setmetatable(
		{ X = a.X - b.X, Y = a.Y - b.Y, Z = a.Z - b.Z },
		spatial
	)
end
spatial.__mul = function(a, b)
	return setmetatable({ X = a.X * b, Y = a.Y * b, Z = a.Z * b }, spatial)
end
local Vector3 = {
	new = function(x, y, z)
		return setmetatable({ X = x, Y = y, Z = z }, spatial)
	end,
}
Vector3.zero = Vector3.new(0, 0, 0)
local cameraFrame = {}
cameraFrame.__index = cameraFrame
function cameraFrame:Lerp(desired, alpha)
	return setmetatable(
		{ Position = self.Position, AimPoint = desired.AimPoint, Alpha = alpha },
		cameraFrame
	)
end
function cameraFrame:PointToWorldSpace(point)
	return self.Position + point
end
local function transform(position)
	return setmetatable({ Position = position }, cameraFrame)
end
local CFrame = {
	lookAt = function(position, target)
		return setmetatable(
			{ Position = position, AimPoint = target },
			cameraFrame
		)
	end,
}
local RaycastParams = {
	new = function()
		return {}
	end,
}
Enum.RenderPriority = { Camera = { Value = 200 }, Last = { Value = 2000 } }
local camera = Instance.new("Camera")
camera.CFrame = transform(Vector3.zero)
camera.ViewportSize = Vector2.new(800, 600)
camera.CameraType = Enum.CameraType.Custom
function camera:WorldToViewportPoint(point)
	local x = self.ViewportSize.X / 2 + point.X * 10
	local y = self.ViewportSize.Y / 2 - point.Y * 10
	return Vector3.new(x, y, point.Z),
		point.Z > 0
			and x >= 0
			and y >= 0
			and x <= self.ViewportSize.X
			and y <= self.ViewportSize.Y
end
workspaceService.CurrentCamera = camera
workspaceService.RayCount = 0
function workspaceService:Raycast(origin, direction, params)
	self.RayCount += 1
	if self.Occluder then
		return { Instance = self.Occluder }
	end
	return nil
end
function methods:GetBoundingBox()
	local part = self:FindFirstChild("HumanoidRootPart")
	return transform(part.Position), Vector3.new(4, 6, 2)
end
local function makePlayer(name, id, x, team)
	local other = Instance.new("Player")
	other.Name = name
	other.DisplayName = name .. " Display"
	other.UserId = id
	other.Team = team
	other.Neutral = false
	local model = Instance.new("Model")
	model.Name = name .. "Character"
	model.Parent = workspaceService
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Position = Vector3.new(x, 0, 50)
	rootPart.Parent = model
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Position = Vector3.new(x, 2, 50)
	head.Parent = model
	local humanoid = Instance.new("Humanoid")
	humanoid.Health = 100
	humanoid.MaxHealth = 100
	humanoid.Parent = model
	model.Pivot = transform(rootPart.Position)
	other.Character = model
	return other
end
player.UserId = 1
player.Team = "Blue"
player.Neutral = false
player.Character = makePlayer("Local", 10, 0, "Blue").Character
local enemy = makePlayer("Enemy", 2, 3, "Red")
local teammate = makePlayer("Friendly", 3, 0, "Blue")
playersService.PlayerList = { player, enemy, teammate }
inputService.TouchEnabled = true
