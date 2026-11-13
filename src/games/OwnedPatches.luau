-- Layered reversible table edits. Shared spring fields can belong to more than
-- one feature; disabling one layer must not undo another. External changes win.
return function()
	local groups, objects = {}, {}
	local serial = 0
	local patches = {}
	function patches.Write(category, object, key, value)
		local slots = objects[object]
		if not slots then
			slots = {}
			objects[object] = slots
		end
		local entry = slots[key]
		if not entry then
			entry = {
				Object = object,
				Key = key,
				Before = object[key],
				After = object[key],
				Layers = {},
			}
			slots[key] = entry
		elseif object[key] ~= entry.After then
			entry.Before = object[key]
		end
		serial += 1
		entry.Layers[category] = { Value = value, Serial = serial }
		groups[category] = groups[category] or {}
		groups[category][entry] = true
		object[key] = value
		entry.After = value
	end
	function patches.Restore(category)
		local group = groups[category]
		if not group then
			return
		end
		for entry in pairs(group) do
			entry.Layers[category] = nil
			local last
			for _, layer in pairs(entry.Layers) do
				if not last or layer.Serial > last.Serial then
					last = layer
				end
			end
			pcall(function()
				if entry.Object[entry.Key] == entry.After then
					local value = entry.Before
					if last then
						value = last.Value
					end
					entry.Object[entry.Key] = value
					entry.After = value
				end
			end)
			if not last then
				local slots = objects[entry.Object]
				slots[entry.Key] = nil
				if next(slots) == nil then
					objects[entry.Object] = nil
				end
			end
		end
		groups[category] = nil
	end
	function patches.Clear()
		local keys = {}
		for key in pairs(groups) do
			table.insert(keys, key)
		end
		for _, key in ipairs(keys) do
			patches.Restore(key)
		end
	end
	return patches
end
