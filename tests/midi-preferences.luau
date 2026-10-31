local disk, encoded, writes = {}, {}, 0
local codec = {
	Encode = function(value)
		table.insert(encoded, value)
		return tostring(#encoded)
	end,
	Decode = function(text)
		return assert(encoded[tonumber(text)], "invalid JSON fixture")
	end,
}
local store = makePreferences({
	Exists = function(path)
		return disk[path] ~= nil
	end,
	Read = function(path)
		return disk[path]
	end,
	Write = function(path, text)
		assert(path == "Nullx11-AutoPlayer.json")
		disk[path] = text
		writes += 1
	end,
}, codec)
local defaults = store.Load()
assert(
	defaults.AutoArm
		and not defaults.Mode88
		and defaults.Transpose == 0
		and defaults.Profile == "Screenshot61"
)
assert(writes == 0, "loading never writes or starts MIDI")
assert(store.Save({
	AutoArm = false,
	Mode88 = false,
	Fold = false,
	Speed = 1.5,
	Favorites = { "MIDI/a.mid", "MIDI/a.mid", "../bad" },
	Queue = { "MIDI/a.mid" },
	Selected = "MIDI/a.mid",
	Panel = { X = 5, Y = -1 },
	Backend = "VK",
}))
local saved = store.Load()
assert(
	not saved.AutoArm
		and not saved.Fold
		and saved.Speed == 1.5
		and saved.Backend == "VK"
)
assert(
	#saved.Favorites == 1
		and saved.Selected == "MIDI/a.mid"
		and saved.Panel.X == 1
		and saved.Panel.Y == 0
)
local invalid = store.Clean({
	Speed = 0 / 0,
	Transpose = 1000,
	Folder = "https://bad",
	Backend = "Code()",
	Queue = { "MIDI/../bad" },
})
assert(
	invalid.Speed == 1
		and invalid.Transpose == 0
		and invalid.Backend == "Auto"
		and #invalid.Queue == 0
)
disk[store.Path] = string.rep("x", 65537)
assert(store.Load().AutoArm, "oversize/corrupt preferences fall back safely")
local unavailable = makePreferences({}, nil)
assert(unavailable.Load().AutoArm and not unavailable.Save({}))
local denied = makePreferences({
	Write = function()
		error("permission denied")
	end,
}, codec)
assert(not denied.Save({}) and denied.Status:find("Save failed", 1, true))
return "PASS: actual data-only MIDI preferences, default auto-arm/screenshot profile, false flags, bounded/validated paths/settings, local save/reload, corrupt/oversized/denied storage and no load-time writes"
