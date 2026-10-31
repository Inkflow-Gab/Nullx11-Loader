-- Exercise the actual budget application and animation-group/particle gates,
-- isolated from Roblox rendering. No game or frame-rate outcome is simulated.
local State = {
	Performance = uiPerformance.New(),
	ReducedMotion = false,
	LowPower = false,
	Window = { Visible = true },
}
local Library = {}
local plays, pauses, completed, resumes = 0, 0, 0, 0
local function entry()
	return {
		Inst = { Parent = {} },
		Playing = true,
		Tween = {
			Play = function()
				plays += 1
			end,
			Pause = function()
				pauses += 1
			end,
		},
	}
end
local Anim = {
	Loops = { Shown = { entry() }, Hidden = { entry() } },
	GroupState = {},
	GroupRequested = {},
	NoopTween = {},
}
-- @GROUP_GATE
local Particles = { Enabled = true, Layer = { Visible = true } }
-- @PARTICLES_GATE
function Particles.Resume()
	if Particles.Active() then
		resumes += 1
	end
end
function Particles.SetEnabled(enabled)
	Particles.Enabled = enabled
	Particles.Layer.Visible = enabled
end
local target = { Value = 1 }
local Motion = {
	Springs = { { Inst = target, Prop = "Value", Kind = "number", Goal = 9 } },
}
function Motion.Unpack(_, goal)
	return goal
end
function Motion.Remove(spring, complete)
	assert(spring == Motion.Springs[#Motion.Springs] and complete)
	table.remove(Motion.Springs)
	completed += 1
end
-- @BUDGET_METHODS
Anim.SetGroupActive("Shown", true)
Anim.SetGroupActive("Hidden", false)
assert(pauses == 1 and Particles.Active())
Library:SetPerformanceMode("Low power")
assert(
	State.LowPower and not Particles.Active() and not Particles.Layer.Visible
)
assert(target.Value == 9 and completed == 1 and pauses == 2)
assert(Anim.GroupRequested.Shown and not Anim.GroupRequested.Hidden)
Library:SetPerformanceMode("Balanced")
assert(not State.LowPower and Particles.Layer.Visible and resumes == 1)
assert(
	plays == 1
		and Anim.Loops.Shown[1].Playing
		and not Anim.Loops.Hidden[1].Playing,
	"budget recovery never wakes a hidden group"
)
Library:SetPerformanceMode("Low power")
Library:SetReducedMotion(true)
Library:SetPerformanceMode("Balanced")
assert(
	not Particles.Enabled
		and not Particles.Layer.Visible
		and not Particles.Active()
)
assert(Library:GetPerformanceStatus() == "Balanced / reduced motion")
assert(
	not Anim.Loops.Shown[1].Playing,
	"budget recovery cannot override user reduced motion"
)
Library:SetReducedMotion(false)
assert(Anim.Loops.Shown[1].Playing and not Anim.Loops.Hidden[1].Playing)
assert(
	not Particles.Enabled,
	"user-disabled particles are not re-enabled by budget recovery"
)
State.Window.Visible = false
assert(not Particles.Active())
-- @TWEEN_GATE
local inst = { Value = 4 }
State.LowPower = true
Anim.Tween(inst, { Value = 10 }, 1, "Out", 0, true)
assert(inst.Value == 4, "suppressed round trips keep their original position")
Anim.Tween(inst, { Value = 10 }, 1, "Out")
assert(inst.Value == 10, "one-way UI transitions still reach their destination")
return "PASS: actual UI budget application: requested-vs-visible groups, hidden/reduced-motion recovery, particle preference, spring completion and round-trip/instant transition gates (API doubles)"
