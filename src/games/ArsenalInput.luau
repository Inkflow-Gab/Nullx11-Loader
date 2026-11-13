-- Scoped real click input. No remote guessing, key hooks, silent backend fallback
-- or unowned mouse-up on unload. API availability is not game acceptance proof.
return function(api)
	local input = { Held = false, Sent = 0, Errors = 0, Backend = "Auto" }
	local vim
	local function native()
		if not vim then
			vim = api.Native()
		end
		assert(
			vim and type(vim.SendMouseButtonEvent) == "function",
			"VirtualInputManager mouse API unavailable"
		)
		return vim
	end
	function input.Release()
		if not input.Held then
			return true
		end
		local ok = pcall(function()
			native():SendMouseButtonEvent(
				input.X,
				input.Y,
				0,
				false,
				api.Game,
				0
			)
		end)
		if ok then
			input.Held = false
		else
			input.Errors += 1
		end
		return ok
	end
	function input.Fire(x, y)
		assert(
			not input.Held,
			"Previous mouse release failed; use Retry release / F7"
		)
		local mode = input.Backend
		if mode == "Auto" then
			mode = type(api.Click) == "function" and "Mouse click" or "VIM"
		end
		if mode == "Mouse click" then
			assert(type(api.Click) == "function", "mouse1click API unavailable")
			local ok, reason = pcall(api.Click)
			if not ok then
				input.Errors += 1
				error(reason, 0)
			end
		else
			assert(mode == "VIM", "Unknown input backend")
			local service = native()
			input.X, input.Y, input.Held = x, y, true
			local ok, reason = pcall(function()
				service:SendMouseButtonEvent(x, y, 0, true, api.Game, 0)
			end)
			local released = input.Release()
			if not ok then
				input.Errors += 1
				error(reason, 0)
			end
			assert(
				released,
				"Mouse-up refused; trigger stopped. Retry release / F7"
			)
		end
		input.Sent += 1
		return mode
	end
	return input
end
