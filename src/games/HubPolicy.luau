-- Reviewed source families, not a remote loader registry.
local policy = {}
policy.Universes =
	{ yarhm_forsaken = 6331902150, yarhm_mm2 = 66654135, yarhm_ftf = 372226183 }
function policy.Compatible(id, place, universe)
	if id == "yarhm_universal" then
		return true
	end
	if id == "yarhm_brookhaven" or id == "chaos_brookhaven" then
		return place == 4924922222
	end
	return policy.Universes[id] ~= nil and universe == policy.Universes[id]
end
function policy.Number(value, minimum, maximum)
	local number = tonumber(value)
	assert(
		number
			and number == number
			and math.abs(number) < math.huge
			and number >= minimum
			and number <= maximum,
		"Enter a finite number from " .. minimum .. " to " .. maximum
	)
	return number
end
function policy.Player(players, text)
	text = string.lower(tostring(text)):match("^%s*(.-)%s*$")
	assert(#text > 0, "Enter a player name")
	local matches = {}
	for _, player in ipairs(players) do
		if string.lower(player.Name) == text then
			return player
		end
		if
			string.lower(player.Name):sub(1, #text) == text
			or string.lower(player.DisplayName):sub(1, #text) == text
		then
			table.insert(matches, player)
		end
	end
	assert(
		#matches == 1,
		#matches == 0 and "No matching player"
			or "Ambiguous name; enter the full username"
	)
	return matches[1]
end
function policy.Position(object)
	if object and object:IsA("BasePart") then
		return object.CFrame
	end
	if object and object:IsA("Model") then
		return object:GetPivot()
	end
	return nil
end
return policy
