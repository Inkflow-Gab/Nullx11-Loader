-- Exercise the actual catalog execution path with the real stage model.
local makeModel = makeExecutionState
local scenario, latest, compiled, executed = "success", nil, 0, 0
executionFactory = function(title)
	assert(title == "Execution fixture")
	local job =
		{ Model = makeModel(function() end), Closed = false, Phases = {} }
	function job:CanContinue()
		return not self.Closed and self.Model:CanContinue()
	end
	function job:Phase(index, message)
		table.insert(self.Phases, index)
		self.Model:Phase(index, message)
		if index == 4 and scenario == "hide-initialize" then
			self.Model:Dismiss()
			self.Closed = true
		end
	end
	function job:Finish()
		self.Model:Finish()
	end
	function job:Fail(reason)
		self.Model:Fail(reason)
	end
	latest = job
	return job
end
jsonDocuments.flowManifest = {
	Version = 1,
	Scripts = {
		{
			Id = "flow",
			Name = "Execution fixture",
			Description = "Development-only execution flow",
			File = "flow.luau",
		},
	},
}
game.HttpGet = function(_, url)
	if url:find("manifest.json", 1, true) then
		return "flowManifest"
	end
	assert(url:find("flow.luau", 1, true))
	if scenario == "download-error" then
		error("fixture HTTP error")
	end
	if scenario == "cancel-download" then
		latest.Model:Dismiss()
		latest.Closed = true
	end
	return "fixture script source"
end
loadstring = function(source)
	assert(source == "fixture script source")
	compiled += 1
	if scenario == "compile-error" then
		return nil, "fixture compile error"
	end
	return function()
		if scenario == "runtime-error" then
			error("fixture initialization error")
		end
		executed += 1
	end
end
runLoader()
find("Load").Activated:Fire()
find("Scripts window").Activated:Fire()
find("RefreshScripts").Activated:Fire()
local function runCase(name)
	scenario = name
	local button = find("RunScript_flow")
	button.Activated:Fire()
	button.Activated:Fire()
	return latest
end
local success = runCase("success")
assert(success.Model.Status == "complete" and executed == 1 and compiled == 1)
assert(table.concat(success.Phases, ",") == "2,3,4")
local cancel = runCase("cancel-download")
assert(
	cancel.Model.Status == "cancelled" and compiled == 1 and executed == 1,
	"Cancelled download result must not compile or start"
)
local compileError = runCase("compile-error")
assert(
	compileError.Model.Status == "failed"
		and compileError.Model.PhaseIndex == 3
		and executed == 1
)
local runtimeError = runCase("runtime-error")
assert(
	runtimeError.Model.Status == "failed"
		and runtimeError.Model.PhaseIndex == 4
		and executed == 1
)
local httpError = runCase("download-error")
assert(
	httpError.Model.Status == "failed"
		and httpError.Model.PhaseIndex == 1
		and executed == 1
)
local hidden = runCase("hide-initialize")
assert(
	hidden.Closed and hidden.Model.Started and executed == 2,
	"Hiding initialization must not stop the game chunk"
)
find("Close").Activated:Fire()
return "PASS: actual catalog-to-stage integration, HTTP/compile/startup errors, cancelled late response and hide-without-cancelling initialized code (development fixtures only)"
