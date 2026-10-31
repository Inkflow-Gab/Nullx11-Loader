-- Data-only workspace preferences. Never evaluates Lua or stores MIDI bytes.
return function(api, codec)
	local store = {
		Path = "Nullx11-AutoPlayer.json",
		Status = "Session only / storage unavailable",
	}
	local numbers = {
		Speed = { 0.25, 2, 1 },
		Transpose = { -24, 24, 0 },
		Velocity = { 1, 127, 1 },
		Gate = { 0.1, 1, 1 },
		Delay = { 0, 10, 2 },
		LoopA = { 0, 14400, 0 },
	}
	local booleans = {
		Sustain = true,
		Drums = false,
		Mode88 = false,
		Fold = true,
		AutoArm = true,
		Recursive = true,
		Advance = false,
		Motion = false,
		Loop = false,
	}
	local function path(value)
		if
			type(value) ~= "string"
			or #value == 0
			or #value > 1024
			or value:find("[%z\1-\31]")
			or value:find(":", 1, true)
		then
			return nil
		end
		value = value:gsub("\\", "/"):gsub("/+", "/"):gsub("/$", "")
		for part in value:gmatch("[^/]+") do
			if part == "." or part == ".." then
				return nil
			end
		end
		return #value > 0 and value or nil
	end
	function store.Clean(raw)
		raw = type(raw) == "table" and raw or {}
		local clean = {
			Version = 1,
			Profile = raw.Mode88 == true and "Extended88" or "Screenshot61",
			Favorites = {},
			Queue = {},
			Muted = {},
		}
		for key, range in pairs(numbers) do
			local value = raw[key]
			clean[key] = type(value) == "number"
					and value == value
					and value >= range[1]
					and value <= range[2]
					and value
				or range[3]
		end
		if
			type(raw.LoopB) == "number"
			and raw.LoopB == raw.LoopB
			and raw.LoopB > 0
			and raw.LoopB <= 14400
		then
			clean.LoopB = raw.LoopB
		end
		clean.Transpose = math.floor(clean.Transpose)
		clean.Velocity = math.floor(clean.Velocity)
		for key, default in pairs(booleans) do
			if type(raw[key]) == "boolean" then
				clean[key] = raw[key]
			else
				clean[key] = default
			end
		end
		clean.Folder = path(raw.Folder)
			or "/storage/emulated/0/Delta/Workspace/MIDI"
		clean.Selected = path(raw.Selected)
		clean.Backend = ({ Auto = true, VIM = true, VK = true, Enum = true })[raw.Backend]
				and raw.Backend
			or "Auto"
		clean.Page = ({
			Library = true,
			Queue = true,
			Mixer = true,
			Keys = true,
			Settings = true,
		})[raw.Page] and raw.Page or "Library"
		for _, key in ipairs({ "Favorites", "Queue" }) do
			local seen = {}
			for index, value in
				ipairs(type(raw[key]) == "table" and raw[key] or {})
			do
				if index > (key == "Queue" and 128 or 512) then
					break
				end
				local valid = path(value)
				if valid and not seen[valid] then
					seen[valid] = true
					table.insert(clean[key], valid)
				end
			end
		end
		for index, value in
			ipairs(type(raw.Muted) == "table" and raw.Muted or {})
		do
			if index > 64 then
				break
			end
			if
				type(value) == "number"
				and value % 1 == 0
				and value >= 1
				and value <= 64
			then
				table.insert(clean.Muted, value)
			end
		end
		for _, key in ipairs({ "Panel", "Dock" }) do
			local value = raw[key]
			if
				type(value) == "table"
				and type(value.X) == "number"
				and type(value.Y) == "number"
				and value.X == value.X
				and value.Y == value.Y
			then
				clean[key] = {
					X = math.clamp(value.X, 0, 1),
					Y = math.clamp(value.Y, 0, 1),
				}
			end
		end
		return clean
	end
	function store.Load()
		local defaults = store.Clean({})
		if not codec or type(api.Read) ~= "function" then
			return defaults
		end
		if type(api.Exists) == "function" then
			local ok, exists = pcall(api.Exists, store.Path)
			if ok and not exists then
				store.Status = type(api.Write) == "function"
						and "Ready / preferences save locally"
					or "Session only / writefile unavailable"
				return defaults
			end
		end
		local ok, value = pcall(function()
			local text = api.Read(store.Path)
			assert(
				type(text) == "string" and #text <= 65536,
				"Preference file exceeds 64 KiB"
			)
			local decoded = codec.Decode(text)
			assert(
				type(decoded) == "table" and decoded.Version == 1,
				"Unsupported preference version"
			)
			return store.Clean(decoded)
		end)
		store.Status = ok and "Restored / local preferences"
			or "Defaults / no readable saved preferences"
		return ok and value or defaults
	end
	function store.Save(raw)
		if not codec or type(api.Write) ~= "function" then
			store.Status = "Session only / writefile or JSON unavailable"
			return false
		end
		local ok, reason = pcall(function()
			local text = codec.Encode(store.Clean(raw))
			assert(
				type(text) == "string" and #text <= 65536,
				"Preferences exceed 64 KiB"
			)
			api.Write(store.Path, text)
		end)
		store.Status = ok and "Saved locally / Nullx11-AutoPlayer.json"
			or "Save failed / " .. tostring(reason):sub(1, 120)
		return ok
	end
	return store
end
