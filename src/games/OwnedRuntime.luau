-- Owns only the selected controller's work; never registered with loader cleanup.
-- Source callbacks, tasks, render bindings and newly-created Instances are scoped here.
return function(context)
	local realTask, realInstance = task, Instance
	local runtime = {
		Alive = true,
		Ready = false,
		Connections = {},
		Threads = {},
		Pending = {},
		Instances = setmetatable({}, { __mode = "k" }),
		Cleanups = {},
		Restores = {},
		RenderNames = {},
	}
	local function allowed()
		return runtime.Alive
			or (
				runtime.CleanupThread ~= nil
				and runtime.CleanupThread
					== (coroutine.running() or runtime)
			)
	end
	function runtime.Guard(callback)
		assert(type(callback) == "function", "Invalid controller callback")
		return function(...)
			if
				not allowed()
				or (not runtime.Ready and not runtime.CleanupThread)
			then
				return
			end
			local thread = coroutine.running()
			local wasTracked = thread and runtime.Threads[thread]
			if thread then
				runtime.Threads[thread] = true
			end
			local result = table.pack(pcall(callback, ...))
			if thread and not wasTracked then
				runtime.Threads[thread] = nil
			end
			if not result[1] then
				if runtime.Alive then
					warn("[Nullx11 stealabrainrot] " .. tostring(result[2]))
				end
				return
			end
			return table.unpack(result, 2, result.n)
		end
	end
	function runtime.Track(connection)
		if not runtime.Alive then
			connection:Disconnect()
			return connection
		end
		-- Prune disconnected source listeners; do not retain every historical ESP listener.
		for tracked in pairs(runtime.Connections) do
			if not tracked.Connected then
				runtime.Connections[tracked] = nil
			end
		end
		runtime.Connections[connection] = true
		return connection
	end
	local function launch(mode, delay, callback, ...)
		if not allowed() then
			return nil
		end
		local args = table.pack(...)
		local thread = coroutine.create(function()
			local ok, reason = pcall(callback, table.unpack(args, 1, args.n))
			runtime.Threads[coroutine.running()] = nil
			if not ok and runtime.Alive then
				warn("[Nullx11 stealabrainrot worker] " .. tostring(reason))
			end
		end)
		runtime.Threads[thread] = true
		local function start()
			if not runtime.Alive or coroutine.status(thread) == "dead" then
				runtime.Threads[thread] = nil
				return
			end
			if mode == "delay" then
				realTask.delay(delay, thread)
			elseif mode == "defer" then
				realTask.defer(thread)
			else
				realTask.spawn(thread)
			end
		end
		if runtime.Ready then
			start()
		else
			table.insert(runtime.Pending, start)
		end
		return thread
	end
	runtime.Task = setmetatable({
		spawn = function(callback, ...)
			return launch("spawn", 0, callback, ...)
		end,
		defer = function(callback, ...)
			return launch("defer", 0, callback, ...)
		end,
		delay = function(delay, callback, ...)
			return launch("delay", delay, callback, ...)
		end,
		wait = function(delay)
			assert(allowed(), "Game session stopped")
			local elapsed = realTask.wait(delay)
			assert(allowed(), "Game session stopped")
			return elapsed
		end,
		cancel = function(thread)
			runtime.Threads[thread] = nil
			return realTask.cancel(thread)
		end,
	}, { __index = realTask })
	runtime.Instance = {
		new = function(class, parent)
			assert(allowed(), "Game session stopped")
			local instance = realInstance.new(class, parent)
			runtime.Instances[instance] = true
			return instance
		end,
	}
	function runtime.BindRender(service, name, priority, callback)
		runtime.RenderNames[name] = service
		service:BindToRenderStep(name, priority, runtime.Guard(callback))
	end
	function runtime.Start()
		runtime.Ready = true
		local pending = runtime.Pending
		runtime.Pending = {}
		for _, start in ipairs(pending) do
			start()
		end
	end
	function runtime.Cleanup(callback)
		table.insert(runtime.Restores, callback)
		return runtime.Guard(callback)
	end
	function runtime.AddCleanup(callback)
		table.insert(runtime.Cleanups, callback)
	end
	function runtime.Destroy()
		if not runtime.Alive then
			return
		end
		runtime.Alive = false
		runtime.CleanupThread = coroutine.running() or runtime
		-- Disable controls and run the source's restoration hooks before disconnecting.
		for i = #runtime.Cleanups, 1, -1 do
			pcall(runtime.Cleanups[i])
		end
		for i = #runtime.Restores, 1, -1 do
			pcall(runtime.Restores[i])
		end
		for instance in pairs(runtime.Instances) do
			if instance:IsA("BindableEvent") and instance.Name == "Cleanup" then
				pcall(function()
					instance:Fire()
				end)
			end
		end
		for name, service in pairs(runtime.RenderNames) do
			pcall(function()
				service:UnbindFromRenderStep(name)
			end)
		end
		for connection in pairs(runtime.Connections) do
			pcall(function()
				connection:Disconnect()
			end)
		end
		for thread in pairs(runtime.Threads) do
			if thread ~= coroutine.running() then
				pcall(realTask.cancel, thread)
			end
		end
		for instance in pairs(runtime.Instances) do
			pcall(function()
				instance:Destroy()
			end)
		end
		table.clear(runtime.Pending)
		table.clear(runtime.Connections)
		table.clear(runtime.Threads)
		table.clear(runtime.Instances)
		runtime.CleanupThread = nil
	end
	context.RegisterCleanup(runtime.Destroy)
	return runtime
end
