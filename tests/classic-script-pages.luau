-- Run the real catalog renderer and separate window, not a rewritten policy.
local manifest = { Version = 1, Scripts = {} }
for index = 1, 64 do
	table.insert(manifest.Scripts, {
		Id = "page" .. index,
		Name = string.format("Entry %03d", index),
		Description = "Pagination fixture",
		File = "fixture.luau",
	})
end
jsonDocuments.pageManifest = manifest
local requests, compiled = 0, 0
game.HttpGet = function(_, url)
	assert(
		url:find("manifest.json", 1, true),
		"browsing can fetch only the explicit manifest"
	)
	requests += 1
	return "pageManifest"
end
loadstring = function()
	compiled += 1
	error("browsing must not compile code")
end
runLoader()
local root = find("SafeArea")
root.AbsoluteSize = Vector2.new(800, 700)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
find("Load").Activated:Fire()
find("Scripts window").Activated:Fire()
assert(requests == 0)
find("RefreshScripts").Activated:Fire()
assert(requests == 1)
local body = find("ScriptsControls")
local function liveRows()
	local rows = {}
	for _, child in ipairs(body:GetChildren()) do
		if child.Name:find("ScriptEntry_", 1, true) == 1 then
			table.insert(rows, child)
		end
	end
	return rows
end
assert(#liveRows() >= 1 and #liveRows() <= 4)
local stale = find("RunScript_page1")
for _ = 1, 70 do
	find("ScriptsNext").Activated:Fire()
	assert(
		#liveRows() >= 1 and #liveRows() <= 4,
		"live allocation stays bounded on every page"
	)
end
assert(
	find("RunScript_page64") and requests == 1 and compiled == 0,
	"last script reachable without execution"
)
stale.Activated:Fire()
assert(compiled == 0 and requests == 1, "obsolete callbacks are disconnected")
find("ScriptsSearch").Text = "Entry 001"
find("ScriptsSearch"):GetPropertyChangedSignal("Text"):Fire()
assert(#liveRows() == 1 and find("RunScript_page1"), "search resets last page")
assert(find("ScriptsPageStatus").Text == "1 / 1  /  1 scripts")
local before = #objects
find("ScriptsNext").Activated:Fire()
assert(#objects == before, "disabled boundary navigation does not rebuild rows")
find("ScriptsSearch").Text = ""
find("ScriptsSearch"):GetPropertyChangedSignal("Text"):Fire()
body.AbsoluteSize = Vector2.new(500, 1000)
body:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(#liveRows() == 4, "oversized viewport still has a four-row hard bound")
manifest.Scripts = {}
find("RefreshScripts").Activated:Fire()
assert(#liveRows() == 0 and find("ScriptsEmptyState"))
assert(find("ScriptsPageStatus").Text == "1 / 1  /  0 scripts")
find("Close").Activated:Fire()
assert(body.Destroyed and compiled == 0)
return "PASS: actual separate Scripts window: 64-entry bounded live pages, last-page access/search reset, no-op page boundary, stale disconnection, resize cap, empty refresh and no implicit execution (API doubles)"
