-- Deterministic UI clock/coroutines: delayed callbacks do NOT complete inline.
local dimension = {}
dimension.__index = dimension
local function dim(scale, offset)
	return setmetatable({ Scale = scale or 0, Offset = offset or 0 }, dimension)
end
local midiUDim2 = {
	new = function(xs, xo, ys, yo)
		return { X = dim(xs, xo), Y = dim(ys, yo) }
	end,
	fromOffset = function(x, y)
		return { X = dim(0, x), Y = dim(0, y) }
	end,
	fromScale = function(x, y)
		return { X = dim(x, 0), Y = dim(y, 0) }
	end,
}
function methods:SetAttribute(key, value)
	self.Attributes = self.Attributes or {}
	self.Attributes[key] = value
end
function methods:GetAttribute(key)
	return self.Attributes and self.Attributes[key]
end

local scheduled, cancelled = {}, {}
local task = {}
local function schedule(callback, wake)
	local thread = coroutine.create(callback)
	table.insert(scheduled, { Thread = thread, Wake = wake })
	return thread
end
function task.defer(callback)
	return schedule(callback, clock)
end
function task.spawn(callback)
	return schedule(callback, clock)
end
function task.delay(delay, callback)
	return schedule(callback, clock + delay)
end
function task.wait(delay)
	return coroutine.yield(math.max(delay or 0.001, 0.001))
end
function task.cancel(thread)
	cancelled[thread] = true
end
local function stepUI(delta)
	clock += delta or 0
	for _, item in ipairs(scheduled) do
		if
			not cancelled[item.Thread]
			and coroutine.status(item.Thread) ~= "dead"
			and item.Wake <= clock
		then
			local success, delay = coroutine.resume(item.Thread)
			assert(success, tostring(delay))
			item.Wake = clock + (delay or 0)
		end
	end
end
local function flushUI()
	for _ = 1, 6 do
		stepUI(0.01)
	end
end
