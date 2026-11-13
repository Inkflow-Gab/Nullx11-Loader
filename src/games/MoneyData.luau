-- Source routing and egg data retained from VoidScripts; see provenance.
local data = {}
data.rebirthWaypoints = {
	{ min = 0, max = 0, pos = Vector3.new(224.4, 5.9, 52.6) },
	{ min = 1, max = 2, pos = Vector3.new(201.2, 5.9, 52.2) },
	{ min = 3, max = 4, pos = Vector3.new(158.7, 5.9, 52.0) },
	{ min = 5, max = 6, pos = Vector3.new(156.9, 5.9, 52.1) },
	{ min = 7, max = 8, pos = Vector3.new(220.5, 6.7, 76.3) },
	{ min = 9, max = 10, pos = Vector3.new(202.4, 7.4, 75.4) },
	{ min = 11, max = 12, pos = Vector3.new(175.4, 7.6, 75.8) },
	{ min = 13, max = 13, pos = Vector3.new(160.6, 8.7, 74.8) },
	{ min = 14, max = 15, pos = Vector3.new(224.1, 5.9, -697.4) },
	{ min = 16, max = 17, pos = Vector3.new(203.1, 5.9, -698.1) },
	{ min = 18, max = 19, pos = Vector3.new(183.0, 5.9, -696.8) },
	{ min = 20, max = 21, pos = Vector3.new(158.5, 5.9, -698.1) },
	{ min = 22, max = 23, pos = Vector3.new(227.4, 5.9, -672.4) },
	{ min = 24, max = 25, pos = Vector3.new(201.7, 5.9, -673.0) },
	{ min = 26, max = 27, pos = Vector3.new(180.5, 5.9, -674.2) },
	{ min = 28, max = 28, pos = Vector3.new(159.7, 5.9, -674.4) },
	{ min = 29, max = 31, pos = Vector3.new(225.2, 9.2, -1443.1) },
	{ min = 32, max = 34, pos = Vector3.new(206.0, 9.0, -1440.7) },
	{ min = 35, max = 37, pos = Vector3.new(183.5, 8.9, -1440.6) },
	{ min = 38, max = 40, pos = Vector3.new(160.0, 9.3, -1439.3) },
	{ min = 41, max = 43, pos = Vector3.new(229.1, 9.2, -1417.3) },
	{ min = 44, max = 46, pos = Vector3.new(205.5, 10.0, -1421.5) },
	{ min = 47, max = 48, pos = Vector3.new(183.1, 9.4, -1419.1) },
	{ min = 49, max = 49, pos = Vector3.new(158.9, 9.4, -1417.4) },
	{ min = 50, max = 52, pos = Vector3.new(224.1, 7.8, -2193.7) },
	{ min = 53, max = 55, pos = Vector3.new(201.5, 7.8, -2193.9) },
	{ min = 56, max = 58, pos = Vector3.new(180.0, 11.2, -2194.5) },
	{ min = 59, max = 61, pos = Vector3.new(156.9, 8.6, -2191.4) },
	{ min = 62, max = 64, pos = Vector3.new(218.5, 7.8, -2170.0) },
	{ min = 65, max = 67, pos = Vector3.new(201.4, 3.1, -2175.3) },
	{ min = 68, max = 69, pos = Vector3.new(179.5, 3.1, -2175.9) },
	{ min = 70, max = math.huge, pos = Vector3.new(157.3, 3.1, -2174.9) },
}
data.w1CashWaypoints = {
	{ wins = 300e6, pos = Vector3.new(193.5, 12.6, -73.5) },
	{ wins = 75e6, pos = Vector3.new(182.9, 12.6, -73.4) },
	{ wins = 18e6, pos = Vector3.new(208.4, 9.6, -63.9) },
	{ wins = 4.5e6, pos = Vector3.new(196.1, 9.6, -63.6) },
	{ wins = 1.2e6, pos = Vector3.new(187.9, 9.6, -63.9) },
	{ wins = 300e3, pos = Vector3.new(177.0, 9.6, -63.6) },
	{ wins = 8e3, pos = Vector3.new(207.7, 6.6, -54.1) },
	{ wins = 2500, pos = Vector3.new(197.8, 6.6, -53.7) },
	{ wins = 600, pos = Vector3.new(187.4, 6.6, -53.9) },
	{ wins = 175, pos = Vector3.new(177.0, 6.6, -54.3) },
	{ wins = 40, pos = Vector3.new(207.2, 3.8, -44.7) },
	{ wins = 8, pos = Vector3.new(198.0, 3.8, -44.9) },
	{ wins = 2, pos = Vector3.new(187.7, 3.8, -45.0) },
}
data.w2CashWaypoints = {
	{ wins = 60e18, pos = Vector3.new(202.7, 12.6, -825.1) },
	{ wins = 10e18, pos = Vector3.new(192.6, 12.6, -825.1) },
	{ wins = 1.5e18, pos = Vector3.new(182.1, 12.6, -824.6) },
	{ wins = 300e15, pos = Vector3.new(207.1, 9.6, -814.7) },
	{ wins = 60e15, pos = Vector3.new(197.2, 9.6, -815.2) },
	{ wins = 10e15, pos = Vector3.new(187.8, 9.6, -815.6) },
	{ wins = 2e15, pos = Vector3.new(176.9, 9.6, -815.0) },
	{ wins = 350e12, pos = Vector3.new(206.7, 6.6, -804.6) },
	{ wins = 60e12, pos = Vector3.new(195.8, 6.6, -804.5) },
	{ wins = 12e12, pos = Vector3.new(186.2, 6.6, -804.0) },
	{ wins = 2e12, pos = Vector3.new(177.1, 6.6, -804.1) },
	{ wins = 0, pos = Vector3.new(207.4, 3.8, -795.7) },
}
data.w3CashWaypoints = {
	{ wins = 50e27, pos = Vector3.new(202.0, 12.6, -1573.4) },
	{ wins = 8e27, pos = Vector3.new(192.0, 12.6, -1574.7) },
	{ wins = 1.4e27, pos = Vector3.new(182.5, 12.6, -1575.8) },
	{ wins = 240e24, pos = Vector3.new(206.0, 9.6, -1564.3) },
	{ wins = 40e24, pos = Vector3.new(196.8, 9.6, -1563.9) },
	{ wins = 10e24, pos = Vector3.new(185.8, 9.6, -1564.4) },
	{ wins = 1.2e24, pos = Vector3.new(176.4, 9.6, -1564.0) },
	{ wins = 200e21, pos = Vector3.new(206.4, 6.6, -1555.2) },
	{ wins = 35e21, pos = Vector3.new(197.2, 6.6, -1555.7) },
	{ wins = 6e21, pos = Vector3.new(187.2, 6.6, -1555.4) },
	{ wins = 1e21, pos = Vector3.new(177.0, 6.6, -1555.5) },
	{ wins = 180e18, pos = Vector3.new(206.8, 3.8, -1545.8) },
	{ wins = 30e18, pos = Vector3.new(197.4, 3.8, -1546.2) },
	{ wins = 5e18, pos = Vector3.new(187.1, 3.8, -1545.9) },
	{ wins = 900e15, pos = Vector3.new(177.6, 3.8, -1545.5) },
}
data.w4CashWaypoints = {
	{ wins = 50e36, pos = Vector3.new(202.0, 12.6, -2324.2) },
	{ wins = 8e36, pos = Vector3.new(191.9, 12.6, -2324.7) },
	{ wins = 1.4e36, pos = Vector3.new(182.3, 12.6, -2324.9) },
	{ wins = 240e33, pos = Vector3.new(207.3, 9.6, -2315.0) },
	{ wins = 40e33, pos = Vector3.new(197.0, 9.6, -2315.2) },
	{ wins = 10e33, pos = Vector3.new(187.2, 9.6, -2315.0) },
	{ wins = 1.2e33, pos = Vector3.new(176.6, 9.6, -2314.8) },
	{ wins = 200e30, pos = Vector3.new(206.8, 6.6, -2304.6) },
	{ wins = 35e30, pos = Vector3.new(196.8, 6.6, -2305.1) },
	{ wins = 6e30, pos = Vector3.new(187.1, 6.6, -2304.9) },
	{ wins = 1e30, pos = Vector3.new(176.5, 6.6, -2305.0) },
	{ wins = 180e27, pos = Vector3.new(206.9, 3.8, -2296.3) },
	{ wins = 30e27, pos = Vector3.new(196.7, 3.8, -2295.7) },
	{ wins = 5e27, pos = Vector3.new(186.7, 3.8, -2295.4) },
	{ wins = 900e24, pos = Vector3.new(176.7, 3.8, -2295.1) },
}
data.eggPrices = {
	{ name = "Common", price = "1 Wins" },
	{ name = "Uncommon", price = "100 Wins" },
	{ name = "Rare", price = "50K Wins" },
	{ name = "Epic", price = "25M Wins" },
	{ name = "Legendary", price = "50B Wins" },
	{ name = "Mythic", price = "50T Wins" },
	{ name = "Moon", price = "10Qa Wins" },
	{ name = "Strange", price = "2Qi Wins" },
	{ name = "Phantom", price = "50Qi Wins" },
	{ name = "Dark", price = "6Sx Wins" },
	{ name = "Electric", price = "5Sp Wins" },
	{ name = "Frozen", price = "30 Oc Wins" },
	{ name = "Sand", price = "30 Oc Wins" },
	{ name = "Shell", price = "6 No Wins" },
	{ name = "Coral", price = "5 Dc Wins" },
	{ name = "Ocean", price = "30 Ud Wins" },
}
data.Bases = {
	Vector3.new(3034.8, 3.8, -16.8),
	Vector3.new(3036.1, 3.8, -768),
	Vector3.new(3034.4, 3.8, -1515.7),
	Vector3.new(3035.2, 3.8, -2268.8),
}
local suffixes = {
	k = 1e3,
	m = 1e6,
	b = 1e9,
	t = 1e12,
	qa = 1e15,
	qi = 1e18,
	sx = 1e21,
	sp = 1e24,
	oc = 1e27,
	no = 1e30,
	dc = 1e33,
	ud = 1e36,
}
function data.Parse(value)
	if type(value) == "number" then
		return value == value and math.abs(value) < math.huge and value or nil
	end
	if type(value) ~= "string" then
		return nil
	end
	local digits, suffix = value:gsub("%s", ""):match("^([%d.,]+)(%a*)$")
	if not digits then
		return nil
	end
	if digits:find(".", 1, true) then
		digits = digits:gsub(",", "")
	elseif digits:find(",", 1, true) then
		local first, rest = digits:match("^(%d+),(.*)$")
		local grouped = first and #first <= 3
		if grouped then
			for part in rest:gmatch("[^,]+") do
				if #part ~= 3 then
					grouped = false
				end
			end
		end
		digits = grouped and digits:gsub(",", "") or digits:gsub(",", ".")
	end
	local multiplier = suffix == "" and 1 or suffixes[suffix:lower()]
	local number = tonumber(digits)
	if not number or not multiplier then
		return nil
	end
	local result = number * multiplier
	return result < math.huge and result or nil
end
function data.RebirthPosition(rebirths)
	if not rebirths then
		return nil
	end
	for _, point in ipairs(data.rebirthWaypoints) do
		if rebirths >= point.min and rebirths <= point.max then
			return point.pos
		end
	end
	return nil
end
function data.CashPosition(rebirths, wins)
	if not rebirths or not wins then
		return nil
	end
	local world = rebirths >= 50 and 4
		or rebirths >= 29 and 3
		or rebirths >= 14 and 2
		or 1
	local target
	for _, point in ipairs(data["w" .. world .. "CashWaypoints"]) do
		if wins >= point.wins then
			target = point.pos
			break
		end
	end
	return data.Bases[world], target, world
end
return data
