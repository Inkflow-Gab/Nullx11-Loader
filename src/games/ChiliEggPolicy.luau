-- Readable algorithms recovered from the supplied partial SAE/Chilli source.
-- No VM dispatch, vendor account service or generated success responses.
local policy = {
	Rarities = {
		"Common",
		"Uncommon",
		"Rare",
		"Epic",
		"Legendary",
		"Mythic",
		"Cosmic",
		"Secret",
		"Eternal",
		"Divine",
	},
}
local function finite(value)
	return type(value) == "number"
		and value == value
		and math.abs(value) < math.huge
end
function policy.Mutations(record)
	local names, seen = {}, {}
	local function add(name)
		if
			type(name) == "string"
			and name ~= ""
			and name ~= "Normal"
			and name ~= "None"
			and not seen[name]
		then
			seen[name] = true
			table.insert(names, name)
		end
	end
	add(record.BaseMutation)
	if type(record.Mutations) == "table" then
		for key, value in pairs(record.Mutations) do
			add(type(key) == "string" and value == true and key or value)
		end
	end
	return names
end
function policy.Describe(record, assets, mutations)
	if
		type(record) ~= "table"
		or type(record.Uid) ~= "string"
		or record.Uid:find("^FirstAreaEgg")
	then
		return nil
	end
	local category = record.AssetCategory or record.Category
	local asset = assets and assets.Directory and assets.Directory[category]
	if type(asset) ~= "table" then
		return nil
	end
	local scale = tonumber(record.AssetScale or record.Scale) or 1
	local rate = tonumber(asset.EarningRate)
	if not finite(scale) or scale <= 0 or not finite(rate) or rate < 0 then
		return nil
	end
	local names = policy.Mutations(record)
	local multiplier = 1
	if #names > 0 then
		if not mutations or type(mutations.EarningsFor) ~= "function" then
			return nil
		end
		local ok, value = pcall(mutations.EarningsFor, names)
		if not ok or not finite(value) or value < 0 then
			return nil
		end
		multiplier = value
	end
	-- The piecewise scale/value equation is preserved from source lines 15099–15109.
	local scaled = scale > 5 and ((scale / 5) ^ 1.2) * 19.637875755794113
		or scale ^ 1.85
	local value = rate * scaled * multiplier
	if not finite(value) then
		return nil
	end
	local rarity = asset.Rarity
	local rank = type(rarity) == "table"
			and tonumber(rarity.RarityNumber or rarity.Rank)
		or table.find(policy.Rarities, rarity)
	return {
		Uid = record.Uid,
		Name = tostring(asset.DisplayName or category),
		Category = category,
		Rank = rank or 0,
		Value = value,
		Scale = scale,
		Mutations = names,
		Record = record,
	}
end
function policy.CarryArgs(record)
	local args = { record.Uid }
	local area, nest = record.AreaId, record.NestId
	if
		record.State == "Slot"
		and (type(area) == "string" or type(area) == "number")
		and (type(nest) == "string" or type(nest) == "number")
	then
		args[2] = tostring(area) .. ":" .. tostring(nest)
	end
	return args
end

function policy.Match(entry, filter)
	if
		entry.Rank < (filter.MinRank or 0)
		or entry.Value < (filter.MinValue or 0)
	then
		return false
	end
	local query = string.lower(filter.Name or "")
	return query == ""
		or string
				.lower(entry.Name .. " " .. tostring(entry.Category))
				:find(query, 1, true)
			~= nil
end
function policy.Sort(entries, order)
	table.sort(entries, function(a, b)
		local av, bv = a.Value, b.Value
		if order == "Lowest value" then
			av, bv = -av, -bv
		elseif order == "Best rarity" then
			av, bv = a.Rank, b.Rank
		elseif order == "Biggest" then
			av, bv = a.Scale, b.Scale
		elseif order == "Closest" then
			av, bv = -(a.Distance or math.huge), -(b.Distance or math.huge)
		end
		if av ~= bv then
			return av > bv
		end
		if a.Value ~= b.Value then
			return a.Value > b.Value
		end
		return a.Uid < b.Uid
	end)
	return entries
end
function policy.Progress(kind, save, data)
	if type(save) ~= "table" then
		return nil
	end
	local money = tonumber(save.Money)
	if kind == "Index" then
		local claimed = type(save.IndexClaimedCategories) == "table"
				and save.IndexClaimedCategories
			or {}
		for category, owned in
			pairs(type(save.Index) == "table" and save.Index or {})
		do
			if owned == true and claimed[category] ~= true then
				return {
					Remote = "RF/Codex/AskRedeemAll",
					Method = "InvokeServer",
					Args = {},
				}
			end
		end
	elseif kind == "Base" and finite(money) then
		local level = tonumber(save.BaseUpgradeLevel) or 1
		local nextBase = data and data.BASES and data.BASES[level + 1]
		local cost = type(nextBase) == "table" and tonumber(nextBase.Cost)
		local maxLevel = data
				and type(data.GetMaxBaseLevel) == "function"
				and data.GetMaxBaseLevel()
			or nil
		if
			finite(cost)
			and money >= cost
			and (not maxLevel or level < maxLevel)
		then
			return {
				Remote = "RE/Homestead/AskBaseTierRaise",
				Method = "FireServer",
				Args = {},
			}
		end
	elseif
		kind == "Treadmill"
		and finite(money)
		and data
		and type(data.GetByUpgradeLevel) == "function"
	then
		local nextTread = data.GetByUpgradeLevel(
			(tonumber(save.TreadmillUpgradeLevel) or 0) + 1
		)
		local price = type(nextTread) == "table" and tonumber(nextTread.Price)
		if finite(price) and money >= price and nextTread._id then
			return {
				Remote = "RF/Treadmill/AskTierRaise",
				Method = "InvokeServer",
				Args = { nextTread._id },
			}
		end
	elseif kind == "Trail" and finite(money) then
		local inventory = type(save.TrailInventory) == "table"
				and save.TrailInventory
			or {}
		local best
		for key, trail in pairs(data and data.Directory or {}) do
			local price = type(trail) == "table" and tonumber(trail.Price)
			local id = type(trail) == "table" and (trail._id or key)
			if
				finite(price)
				and price >= 0
				and price <= money
				and inventory[id] ~= true
			then
				if
					not best
					or price < best.Price
					or (
						price == best.Price
						and tostring(id) < tostring(best.Id)
					)
				then
					best = { Id = id, Price = price }
				end
			end
		end
		if best then
			return {
				Remote = "RF/Trailwear/AskPurchase",
				Method = "InvokeServer",
				Args = { best.Id },
			}
		end
	end
	return nil
end
return policy
