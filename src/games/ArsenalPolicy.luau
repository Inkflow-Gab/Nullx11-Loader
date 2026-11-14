-- NULL Arsenal: pure bounds, eligibility, source rig links and frame-rate-independent aim.
local policy = {}
policy.Place = 286090429
policy.Bones = {
	R6 = {
		{ "Head", "Torso" },
		{ "Torso", "Left Arm" },
		{ "Torso", "Right Arm" },
		{ "Torso", "Left Leg" },
		{ "Torso", "Right Leg" },
	},
	R15 = {
		{ "Head", "UpperTorso" },
		{ "UpperTorso", "LowerTorso" },
		{ "UpperTorso", "LeftUpperArm" },
		{ "LeftUpperArm", "LeftLowerArm" },
		{ "LeftLowerArm", "LeftHand" },
		{ "UpperTorso", "RightUpperArm" },
		{ "RightUpperArm", "RightLowerArm" },
		{ "RightLowerArm", "RightHand" },
		{ "LowerTorso", "LeftUpperLeg" },
		{ "LeftUpperLeg", "LeftLowerLeg" },
		{ "LeftLowerLeg", "LeftFoot" },
		{ "LowerTorso", "RightUpperLeg" },
		{ "RightUpperLeg", "RightLowerLeg" },
		{ "RightLowerLeg", "RightFoot" },
	},
}
function policy.Number(value, minimum, maximum)
	value = tonumber(value)
	assert(
		value
			and value == value
			and math.abs(value) < math.huge
			and value >= minimum
			and value <= maximum,
		"Enter a finite number from " .. minimum .. " to " .. maximum
	)
	return value
end
function policy.Enemy(localPlayer, other, teamCheck)
	if other == localPlayer then
		return false
	end
	return not teamCheck
		or localPlayer.Neutral
		or other.Neutral
		or not localPlayer.Team
		or not other.Team
		or localPlayer.Team ~= other.Team
end
function policy.Alpha(strength, delta)
	strength = policy.Number(strength, 0, 100)
	if strength == 100 then
		return 1
	end
	if delta <= 0 or delta ~= delta then
		return 0
	end
	return 1 - (1 - strength / 100) ^ (math.min(delta, 0.1) * 60)
end
function policy.InCircle(point, center, radius)
	if point.Z <= 0 then
		return false, math.huge
	end
	local x, y = point.X - center.X, point.Y - center.Y
	local distance = math.sqrt(x * x + y * y)
	return distance <= radius, distance
end
return policy
