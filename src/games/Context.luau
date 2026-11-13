-- One selected game session. Bundles include this module, not the loader.
return function(key, library)
	local context = {
		Alive = true,
		Library = library,
		Connections = {},
		Sent = 0,
		NextSend = 0,
	}
	local env = type(getgenv) == "function" and getgenv() or _G
	env.Nullx11GameSessions = env.Nullx11GameSessions or {}
	local previous = env.Nullx11GameSessions[key]
	if previous and type(previous.Unload) == "function" then
		pcall(previous.Unload)
	end
	local session = { Library = library }
	function session.Unload()
		if not context.Alive then
			return
		end
		context.Alive = false
		for _, connection in ipairs(context.Connections) do
			pcall(connection.Disconnect, connection)
		end
		table.clear(context.Connections)
		library:Unload()
		if env.Nullx11GameSessions[key] == session then
			env.Nullx11GameSessions[key] = nil
		end
	end
	function context.Connect(signal, callback)
		local connection = signal:Connect(function(...)
			if context.Alive then
				callback(...)
			end
		end)
		table.insert(context.Connections, connection)
		return connection
	end
	-- The forge source used enormous worker bursts. Serialize its explicit remote
	-- requests to at most eight a second; waiting work is cancelled on unload.
	-- A budget is not a claim that the server accepts any action.
	function context.Send(remote, method, ...)
		local function allowed()
			return context.Alive
				or context.CleanupThread == (coroutine.running() or context)
		end
		while allowed() and os.clock() < context.NextSend do
			task.wait(math.min(0.125, context.NextSend - os.clock()))
		end
		assert(allowed(), "Nullx11 game session stopped")
		context.NextSend = os.clock() + 0.125
		context.Sent += 1
		return remote[method](remote, ...)
	end
	-- Revalidate feature/generation after pacing waits, before sending anything.
	function context.SendWhen(predicate, remote, method, ...)
		while context.Alive and predicate() and os.clock() < context.NextSend do
			task.wait(math.min(0.125, context.NextSend - os.clock()))
		end
		if not context.Alive or not predicate() then
			return nil, "cancelled"
		end
		context.NextSend = os.clock() + 0.125
		context.Sent += 1
		return remote[method](remote, ...)
	end
	function context.RegisterCleanup(callback)
		library:OnUnload(function()
			context.CleanupThread = coroutine.running() or context
			local ok, reason = pcall(callback)
			context.CleanupThread = nil
			if not ok then
				warn("[Nullx11 cleanup] " .. tostring(reason))
			end
		end)
	end
	library:OnUnload(function()
		context.Alive = false
		for _, connection in ipairs(context.Connections) do
			pcall(connection.Disconnect, connection)
		end
		table.clear(context.Connections)
		if env.Nullx11GameSessions[key] == session then
			env.Nullx11GameSessions[key] = nil
		end
	end)
	env.Nullx11GameSessions[key] = session
	return context
end
