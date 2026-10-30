-- Exercise the actual supplied/adapted library's non-rendering APIs. Services
-- are development doubles; this is not a native Roblox rendering test.
services.TextService = {}
services.CoreGui = Instance.new("CoreGui")
services.Stats = {}
-- @SHARED_UI
local library = createNullx11UI({ Id = "CoreContracts" })
assert(
	type(library.CreateWindow) == "function"
		and type(library.Gui.Button) == "function"
)
assert(
	type(library.Motion) == "table" and type(library.Icons.Vector) == "function"
)
assert(
	library.Themes[1] == "Nullx11" and table.find(library.Themes, "Halloween")
)
local value = library.Ref(2)
local doubled = library.Computed(function()
	return value.Value * 2
end)
assert(value:Get() == 2 and doubled:Get() == 4)
local observed, previous
local stopWatching = library.Watch(value, function(current, old)
	observed, previous = current, old
end, { Immediate = true })
assert(observed == 2 and previous == nil)
value:Set(5)
assert(doubled:Get() == 10 and observed == 5 and previous == 2)
stopWatching()
value:Set(7)
assert(doubled:Get() == 14 and observed == 5)
local other = library.Ref(1)
local runs, total = 0, 0
local stopEffect = library.Effect(function()
	runs += 1
	total = value:Get() + other:Get()
end)
assert(runs == 1 and total == 8)
library.Batch(function()
	value:Set(9)
	other:Set(3)
end)
assert(total == 12 and runs == 2, "batch must coalesce effect updates")
stopEffect()
other:Set(8)
assert(runs == 2)
local store = library.Store({ Enabled = false, Count = 1 })
local counts = 0
store:Watch("Count", function(v)
	counts = v
end, true)
assert(counts == 1 and store.State.Enabled == false)
store.State.Count = 4
store:Update("Count", function(v)
	return v + 1
end)
assert(counts == 5 and store:Get("Count") == 5)
local ok, reason = library:SaveConfig("one")
assert(
	not ok and type(reason) == "string",
	"missing file capability must not report a fake save"
)
local unloaded = 0
library:OnUnload(function()
	unloaded += 1
end)
library:Unload()
library:Unload()
assert(unloaded == 1 and library.Unloaded)
value:Set(10)
store.State.Count = 99
assert(
	doubled:Get() == 18 and counts == 5,
	"unload must dispose effects and reference subscriptions"
)
return "PASS: actual shared-UI reactive/computed/watch/batch/store APIs, theme exports, file-capability failure and idempotent disposal (non-rendering development checks)"
