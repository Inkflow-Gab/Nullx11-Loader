-- Pure browsing policy for the native workspace game-card browser.
local model = {}
function model.Category(entry)
	return entry.Category or "Community"
end
function model.Badge(entry, place)
	if not entry.GamePlaceId then
		return "MODULE CHECK ON LAUNCH"
	end
	return entry.GamePlaceId == place and "PLACE MATCH" or "OTHER PLACE"
end
function model.Match(entry, query, category, onlyPlace, place)
	if
		category
		and category ~= "All games"
		and model.Category(entry) ~= category
	then
		return false
	end
	if onlyPlace and (not entry.GamePlaceId or entry.GamePlaceId ~= place) then
		return false
	end
	local haystack = string.lower(table.concat({
		entry.Name or "",
		entry.Description or "",
		entry.Author or "",
		entry.File or "",
		model.Category(entry),
	}, " "))
	for word in string.lower(query or ""):gmatch("%S+") do
		if not haystack:find(word, 1, true) then
			return false
		end
	end
	return true
end
function model.Categories(entries)
	local seen, list = {}, {}
	for _, entry in ipairs(entries) do
		local category = model.Category(entry)
		if not seen[category] then
			seen[category] = true
			table.insert(list, category)
		end
	end
	table.sort(list)
	table.insert(list, 1, "All games")
	return list
end
function model.Resolve(entries, id)
	for _, entry in ipairs(entries) do
		if entry.Id == id then
			return entry
		end
	end
	return nil
end
return model
