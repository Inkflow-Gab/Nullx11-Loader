-- Local data only. Never loads Lua presets, fetches a catalog or scans outside
-- the requested root. Absolute Android access remains executor-controlled.
local files = {
	AndroidRoot = "/storage/emulated/0/Delta/Workspace/MIDI",
	RelativeRoot = "MIDI",
	MaxFiles = 512,
}
function files.Normalize(path)
	assert(
		type(path) == "string"
			and #path > 0
			and #path <= 1024
			and not path:find("[%z\1-\31]"),
		"Invalid folder/path"
	)
	assert(not path:match("^%a[%w+.-]*:"), "Use a local folder, not a URL")
	path = path:gsub("\\", "/"):gsub("/+", "/"):gsub("/$", "")
	assert(not path:find("://", 1, true), "Use a local folder, not a URL")
	for part in path:gmatch("[^/]+") do
		assert(
			part ~= ".." and part ~= ".",
			"Parent/current-directory traversal is not allowed"
		)
	end
	assert(#path > 0, "Choose a MIDI folder, not the filesystem root")
	return path
end
function files.IsMidi(path)
	local lower = path:lower()
	return lower:match("%.mid$") ~= nil
		or lower:match("%.midi$") ~= nil
		or lower:match("%.smf$") ~= nil
end
function files.Scan(api, requested, recursive, checkpoint)
	assert(
		type(api.List) == "function" and type(api.Read) == "function",
		"Delta listfiles/readfile APIs are unavailable"
	)
	local root = files.Normalize(requested)
	local ok, entries = pcall(api.List, root)
	local fallback = false
	if (not ok or type(entries) ~= "table") and root == files.AndroidRoot then
		root = files.RelativeRoot
		fallback = true
		ok, entries = pcall(api.List, root)
	end
	assert(
		ok and type(entries) == "table",
		"Cannot list MIDI folder: "
			.. root
			.. ". Check Delta file permissions or use workspace-relative MIDI."
	)
	local result, seen, visited, skipped = {}, {}, 0, 0
	local function childPath(directory, entry)
		local valid, candidate = pcall(files.Normalize, entry)
		if not valid then
			return nil
		end
		if not candidate:find("/", 1, true) then
			candidate = directory .. "/" .. candidate
		end
		if candidate:sub(1, #directory + 1) == directory .. "/" then
			return candidate
		end
		-- Some executors return absolute Android paths for a relative query.
		if directory:sub(1, 1) ~= "/" then
			local absolute = "/storage/emulated/0/Delta/Workspace/" .. directory
			if candidate:sub(1, #absolute + 1) == absolute .. "/" then
				return candidate
			end
		end
		return nil
	end
	local function walk(directory, listing, depth)
		visited += 1
		for index, entry in ipairs(listing) do
			if index > 2048 or #result >= files.MaxFiles then
				break
			end
			local path = childPath(directory, entry)
			if path and not seen[path] then
				seen[path] = true
				if files.IsMidi(path) then
					table.insert(result, {
						Path = path,
						Name = path:match("([^/]+)$"),
						Folder = directory,
					})
				elseif
					recursive
					and depth < 3
					and visited < 32
					and type(api.IsFolder) == "function"
				then
					local folderOk, folder = pcall(api.IsFolder, path)
					if folderOk and folder then
						local listOk, children = pcall(api.List, path)
						if listOk and type(children) == "table" then
							walk(path, children, depth + 1)
						end
					end
				end
			else
				skipped += 1
			end
			if checkpoint and index % 64 == 0 then
				checkpoint()
			end
		end
	end
	walk(root, entries, 0)
	table.sort(result, function(a, b)
		return a.Name:lower() == b.Name:lower() and a.Path < b.Path
			or a.Name:lower() < b.Name:lower()
	end)
	return result,
		{
			Root = root,
			Fallback = fallback,
			Skipped = skipped,
			Capped = #result >= files.MaxFiles,
		}
end
return files
