local state = policy.New()
assert(state.Mode == "Auto" and not state.LowPower)
assert(
	not policy.Step(state, 10, 10) and not state.LowPower,
	"one hitch is not sustained low FPS"
)
policy.Step(state, 0.1, 45)
for _ = 1, 19 do
	assert(not policy.Step(state, 0.1, 25))
end
assert(
	policy.Step(state, 0.11, 25) and state.LowPower,
	"sustained low FPS lowers UI work"
)
for _ = 1, 70 do
	assert(not policy.Step(state, 0.1, 60))
end
policy.Step(state, 0.1, 45)
for _ = 1, 79 do
	assert(not policy.Step(state, 0.1, 60))
end
assert(
	policy.Step(state, 0.11, 60) and not state.LowPower,
	"recovery needs eight uninterrupted seconds"
)
assert(policy.SetMode(state, "Low power") and state.LowPower)
for _ = 1, 100 do
	assert(not policy.Step(state, 1, 120) and state.LowPower)
end
assert(policy.SetMode(state, "Balanced") and not state.LowPower)
for _ = 1, 100 do
	assert(not policy.Step(state, 1, 5) and not state.LowPower)
end
assert(not policy.SetMode(state, "invalid") and state.Mode == "Balanced")
assert(policy.SetMode(state, "Auto"))
for _, delta in ipairs({ 0, -1, math.huge, 0 / 0 }) do
	assert(not policy.Step(state, delta, 1))
end
assert(state.Slow == 0 and not state.LowPower)
return "PASS: UI budget hysteresis, one-hitch immunity, recovery dwell, explicit overrides and invalid frame samples (policy tests; no device FPS claim)"
