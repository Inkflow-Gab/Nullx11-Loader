-- Actual forge arrival-preparation function, exercised without running a game.
local State = { Alive = true, HopQueued = false }
local context = { Alive = true }
local Config =
	{ ExecuteAfterHop = false, ReloadSource = "selected-forge-fixture" }
local env = {}
local getgenv = function()
	return env
end
local queue_on_teleport, queueonteleport, syn
local Nullx11Forge = { Session = {} }
-- @FORGE_ARRIVAL
local prepare = Nullx11Forge.Session.PrepareArrival
assert(prepare(), "teleport-only requires no queue capability")
Config.ExecuteAfterHop = true
assert(
	not pcall(prepare),
	"unsupported opted-in execution must not silently teleport"
)
queue_on_teleport = function()
	error("queue denied")
end
assert(
	not pcall(prepare) and not State.HopQueued,
	"failed queue must remain unaccepted"
)
local queued = {}
queue_on_teleport = function(payload)
	table.insert(queued, payload)
end
assert(prepare() and #queued == 1 and queued[1] == Config.ReloadSource)
assert(prepare() and #queued == 1, "retry must not duplicate queue code")
Config.ExecuteAfterHop = false
assert(not pcall(prepare), "known stale code prevents claiming teleport-only")
State.Alive = false
assert(
	not prepare(),
	"late auto-rejoin callback after unload must not request teleport"
)
State.Alive = true
context.Alive = false
assert(not prepare())
return "PASS: actual forge teleport-only/queue capability/failure/deduplication/stale-code/late-unload guards (development fixture)"
