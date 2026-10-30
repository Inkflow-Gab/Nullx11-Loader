-- Actual uploaded-controller helpers, isolated from the engine for idle-work checks.
local scans, destroyed, writes = 0, 0, 0
local humanoid =
	{ Parent = true, WalkSpeed = 16, JumpPower = 50, UseJumpPower = false }
local part = { Parent = true, LocalTransparencyModifier = 0.35 }
function part:IsA(name)
	return name == "BasePart"
end
local character = {}
function character:GetDescendants()
	scans += 1
	return { part }
end
local utils = {
	originals = setmetatable({}, { __mode = "k" }),
	markers = {},
	settings = { player = {}, visuals = {} },
	character = function()
		return character, humanoid, {}
	end,
}
-- @EGG_HELPERS
for _ = 1, 20 do
	utils.applyCharacter()
	assert(utils.esp() == "Off")
end
assert(
	scans == 0 and humanoid.WalkSpeed == 16,
	"Disabled defaults must not scan descendants or modify character speed"
)
utils.settings.player.Invisibility = true
utils.applyCharacter()
assert(scans == 1 and part.LocalTransparencyModifier == 1)
utils.settings.player.Invisibility = false
utils.applyCharacter()
assert(
	scans == 1 and part.LocalTransparencyModifier == 0.35,
	"Restore the game's transparency instead of forcing zero"
)
utils.settings.player.SpeedEnabled, utils.settings.player.Speed = true, 30
utils.applyCharacter()
assert(humanoid.WalkSpeed == 30)
utils.settings.player.SpeedEnabled = false
utils.applyCharacter()
assert(humanoid.WalkSpeed == 16)
local function markerPart()
	return {
		Destroy = function()
			destroyed += 1
		end,
	}
end
utils.markers.test = { Gui = markerPart(), Highlight = markerPart() }
assert(utils.esp() == "Off" and destroyed == 2 and next(utils.markers) == nil)

-- @EGG_PREFLIGHT
local nodes = {}
local game = {
	GetService = function()
		return {
			FindFirstChild = function(_, key)
				return nodes[key]
			end,
		}
	end,
}
-- @EGG_COMPATIBLE
assert(
	not compatible(),
	"Absent core modules must be rejected without require or controller startup"
)
local paths = {
	"Shared.Remotes",
	"Shared.Save",
	"Client.EggState",
	"Client.PlotState",
	"Client.AssetRoster",
	"Data.Assets",
	"Data.Rarity",
}
for _, path in ipairs(paths) do
	local parent = nodes
	for key in path:gmatch("[^.]+") do
		parent[key] = parent[key]
			or {
				Children = {},
				FindFirstChild = function(self, name)
					return self.Children[name]
				end,
				IsA = function(_, kind)
					return kind == "ModuleScript"
				end,
			}
		parent = parent[key].Children
	end
end
assert(compatible())
nodes.Data.Children.Rarity.IsA = function()
	return false
end
assert(not compatible(), "Names alone do not pass the ModuleScript gate")
return "PASS: actual Steal An Egg disabled-path scan avoidance, reversible character changes, ESP cleanup and module preflight (development fixtures only)"
