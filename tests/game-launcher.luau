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
assert(find("RunScript_forge"), "game entries visible outside target places")
local before = #requests
find("RunScript_rosu").Activated:Fire()
assert(
	find("GameScriptWindow").Visible and #requests == before and ran == 0,
	"open game detail without downloading/executing"
)
assert(
	string.find(find("GameScriptDetails").Text, "not in this game", 1, true),
	"wrong-place prompt"
)
assert(
	string.find(find("GameScriptCredit").Text, "Original author", 1, true),
	"source credits retained"
)
find("GameExecute").Activated:Fire()
assert(ran == 0 and #requests == before, "wrong-place execute is blocked")
find("GameTeleport").Activated:Fire()
assert(
	teleports[1] == 9051087354 and #queued == 0,
	"default teleport-only action"
)
services.TeleportService.TeleportInitFailed:Fire(
	player,
	nil,
	"test failure",
	9051087354
)
find("GameExecuteOnArrival").Activated:Fire()
find("GameTeleport").Activated:Fire()
assert(#queued == 1 and #teleports == 2, "opt-in queue then teleport")
assert(
	string.find(queued[1], "9051087354", 1, true)
		and string.find(queued[1], "/scripts/rosu.luau", 1, true),
	"queue only the selected game file and exact place guard"
)
assert(
	not string.find(queued[1], "Nullx11.client.luau", 1, true),
	"never queue main loader"
)
services.TeleportService.TeleportInitFailed:Fire(
	player,
	nil,
	"test failure",
	9051087354
)
find("GameExecuteOnArrival").Activated:Fire()
find("GameTeleport").Activated:Fire()
assert(
	#teleports == 2,
	"cannot promise teleport-only while earlier selected code remains queued"
)
find("RunScript_huss").Activated:Fire()
find("GameExecuteOnArrival").Activated:Fire()
queueFails = true
find("GameTeleport").Activated:Fire()
assert(
	#teleports == 2,
	"queue failure prevents teleport when execute-on-arrival was requested"
)
queueFails = false
queue_on_teleport = nil
find("RunScript_forge").Activated:Fire()
find("GameExecuteOnArrival").Activated:Fire()
assert(
	string.find(find("GameScriptStatus").Text, "unavailable", 1, true),
	"unsupported queue is explicit"
)
game.PlaceId = 118805555015549
find("RunScript_forge").Activated:Fire()
find("GameExecute").Activated:Fire()
assert(ran == 0, "first execute tap confirms only")
find("GameExecute").Activated:Fire()
assert(
	ran == 1,
	"second execute tap invokes selected game code in correct place"
)
local gamePanel = find("GameScriptWindow")
local statusObject = find("GameScriptStatus")
local lastStatus = statusObject.Text
local failure = services.TeleportService.TeleportInitFailed
find("Close").Activated:Fire()
failure:Fire(player, nil, "late failure", 9051087354)
assert(
	gamePanel.Destroyed and statusObject.Text == lastStatus,
	"main close destroys game dialog and disconnects late teleport updates"
)
return "PASS: Scripts action/window, game-place prompts, separate teleport and execute, opt-in queue, exact selected-file payload, queue/teleport failures, credits and cleanup (development doubles only)",
	queued[1]
