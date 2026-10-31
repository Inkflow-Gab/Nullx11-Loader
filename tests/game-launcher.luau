local queued, teleports, ran = {}, {}, 0
local queueFails = false
queue_on_teleport = function(source)
	if queueFails then
		error("queue denied")
	end
	table.insert(queued, source)
end
services.TeleportService = Instance.new("TeleportService")
services.TeleportService.TeleportInitFailed = signal()
function services.TeleportService:Teleport(id, who)
	assert(who == player, "local player only")
	table.insert(teleports, id)
end
local manifest = {
	Version = 1,
	Scripts = {
		{
			Id = "rosu",
			Name = "Nullx11 - Rosu Mania",
			Description = "Fixture for launch flow, not an actual port",
			File = "rosu.luau",
			GamePlaceId = 9051087354,
			Author = "Original author preserved",
			PlaceIds = { 9051087354 },
		},
		{
			Id = "huss",
			Name = "Nullx11 - Huss Valley",
			Description = "Fixture",
			File = "huss.luau",
			GamePlaceId = 107535308163741,
		},
		{
			Id = "forge",
			Name = "Nullx11 - +1 Loot to Forge",
			Description = "Fixture",
			File = "forge.luau",
			GamePlaceId = 118805555015549,
		},
	},
}
jsonDocuments.games = manifest
local requests = {}
game.HttpGet = function(self, url)
	table.insert(requests, url)
	return if string.find(url, "manifest.json", 1, true)
		then "games"
		else "reviewed game source"
end
loadstring = function(source, name)
	assert(source == "reviewed game source")
	return function()
		ran += 1
	end
end
runLoader()
local root = find("SafeArea")
root.AbsoluteSize = Vector2.new(800, 700)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
find("Load").Activated:Fire()
local navigation = find("Scripts window")
assert(
	not navigation:FindFirstChild("ToggleState"),
	"Scripts is navigation, not an ON/OFF switch"
)
navigation.Activated:Fire()
navigation.Activated:Fire()
assert(
	find("ScriptsWindow").Visible,
	"repeated action opens instead of toggling closed"
)
find("RefreshScripts").Activated:Fire()
find("ScriptsNext").Activated:Fire()
find("ScriptsNext").Activated:Fire()
assert(
	find("RunScript_forge"),
	"other-place entries are reachable by page without scrolling"
)
find("ScriptsPrevious").Activated:Fire()
find("ScriptsPrevious").Activated:Fire()
local before = #requests
find("RunScript_rosu").Activated:Fire()
assert(
	find("GameScriptWindow").Visible and #requests == before and ran == 0,
	"open game detail without downloading/executing"
)
assert(
	string.find(find("GameScriptDetails").Text, "Unsupported place", 1, true),
	"compatibility notice, not teleport question"
)
assert(
	string.find(find("GameScriptCredit").Text, "Original author", 1, true),
	"source credits retained"
)
find("GameExecute").Activated:Fire()
assert(ran == 0 and #requests == before, "wrong-place execute is blocked")
assert(
	not pcall(find, "GameTeleport") and not pcall(find, "GameExecuteOnArrival"),
	"No game teleport controls"
)
assert(#teleports == 0 and #queued == 0)
game.PlaceId = 118805555015549
find("ScriptsSearch").Text = "Forge"
find("ScriptsSearch"):GetPropertyChangedSignal("Text"):Fire()
find("RunScript_forge").Activated:Fire()
find("GameExecute").Activated:Fire()
assert(ran == 0, "first execute tap confirms only")
find("GameExecute").Activated:Fire()
assert(
	ran == 1,
	"second execute tap invokes selected game code in correct place"
)
-- Universe metadata is retained through the actual validator and blocks fetches
-- even when the source has no root-place ID.
find("ScriptsSearch").Text = ""
find("ScriptsSearch"):GetPropertyChangedSignal("Text"):Fire()
manifest.Scripts = {
	{
		Id = "universe",
		Name = "Universe test",
		Description = "Fixture",
		File = "universe.luau",
		GameUniverseId = 6331902150,
	},
}
find("RefreshScripts").Activated:Fire()
find("RunScript_universe").Activated:Fire()
assert(
	string.find(
		find("GameScriptDetails").Text,
		"Unsupported game universe",
		1,
		true
	)
)
local universeBefore = #requests
find("GameExecute").Activated:Fire()
find("GameExecute").Activated:Fire()
assert(
	#requests == universeBefore and ran == 1,
	"wrong universe blocks before code fetch"
)
-- A successful refresh invalidates the previously selected/confirmed game.
manifest.Scripts = {}
find("RefreshScripts").Activated:Fire()
local beforeRemovedExecute = ran
find("GameExecute").Activated:Fire()
assert(
	ran == beforeRemovedExecute and #teleports == 0,
	"removed stale game metadata cannot execute or teleport"
)
local gamePanel = find("GameScriptWindow")
local independentUnloads = 0
getgenv().Nullx11GameSessions =
	{ egg = {
		Unload = function()
			independentUnloads += 1
		end,
	} }
find("Close").Activated:Fire()
assert(
	gamePanel.Destroyed and independentUnloads == 0,
	"Closing loader leaves executed scripts alive"
)
return "PASS: Scripts navigation, no teleport/queue controls, compatibility blocking, confirmed execution, refreshed-selection invalidation and independent cleanup (development doubles only)"
