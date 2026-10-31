-- UI-only budget policy. Hysteresis prevents one hitch from toggling effects or
-- repeatedly rebuilding UI. Never changes game graphics, physics, ESP or workers.
local policy = {}
function policy.New()
	return { Mode = "Auto", LowPower = false, Slow = 0, Healthy = 0 }
end
function policy.SetMode(state, mode)
	if mode ~= "Auto" and mode ~= "Balanced" and mode ~= "Low power" then
		return false
	end
	if state.Mode == mode then
		return false
	end
	state.Mode, state.Slow, state.Healthy = mode, 0, 0
	state.LowPower = mode == "Low power"
	return true
end
function policy.Step(state, delta, fps)
	if
		state.Mode ~= "Auto"
		or delta <= 0
		or delta ~= delta
		or delta == math.huge
	then
		return false
	end
	-- A single multi-second stall counts as at most one second of evidence.
	delta = math.min(delta, 1)
	if fps < 35 then
		state.Slow += delta
		state.Healthy = 0
	elseif fps > 50 then
		state.Healthy += delta
		state.Slow = 0
	else
		state.Slow, state.Healthy = 0, 0
	end
	local before = state.LowPower
	if not before and state.Slow >= 2 then
		state.LowPower, state.Slow = true, 0
	elseif before and state.Healthy >= 8 then
		state.LowPower, state.Healthy = false, 0
	end
	return state.LowPower ~= before
end
return policy
