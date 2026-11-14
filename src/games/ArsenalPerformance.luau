-- Opt-in, incremental reversible effects reduction. Never deletes map assets,
-- textures, characters or sky; no quality/FPS-cap globals or anti-cheat hooks.
return function(patches, world, lighting)
	local boost = {
		Enabled = false,
		Processed = 0,
		Limit = 8000,
		Pending = {},
		Walking = 1,
		Truncated = false,
	}
	local seen, queued = setmetatable({}, { __mode = "k" }), 0
	local function apply(object)
		if
			object:IsA("ParticleEmitter")
			or object:IsA("Trail")
			or object:IsA("Beam")
			or object:IsA("Smoke")
			or object:IsA("Fire")
			or object:IsA("Sparkles")
			or object:IsA("PostEffect")
		then
			patches.Write("performance", object, "Enabled", false)
		elseif object:IsA("BasePart") then
			patches.Write("performance", object, "CastShadow", false)
		end
	end
	function boost.Add(object)
		if not boost.Enabled then
			return
		end
		if seen[object] then
			return
		end
		if queued >= boost.Limit then
			boost.Truncated = true
			return
		end
		seen[object], queued = true, queued + 1
		table.insert(boost.Pending, object)
	end
	function boost.Set(enabled)
		boost.Enabled = enabled
		table.clear(boost.Pending)
		table.clear(seen)
		queued = 0
		boost.Walking, boost.Processed, boost.Truncated = 1, 0, false
		patches.Restore("performance")
		if enabled then
			patches.Write("performance", lighting, "GlobalShadows", false)
			boost.Add(world)
			boost.Add(lighting)
		end
	end
	function boost.Step()
		if not boost.Enabled then
			return
		end
		-- Bound both traversal and property writes per heartbeat. Broad maps are
		-- truncated visibly, not scanned synchronously with GetDescendants().
		local steps = 0
		while steps < 60 and boost.Walking <= #boost.Pending do
			local object = boost.Pending[boost.Walking]
			boost.Walking += 1
			if object == world or object == lighting or object.Parent then
				apply(object)
				for _, child in ipairs(object:GetChildren()) do
					if queued >= boost.Limit then
						boost.Truncated = true
						break
					end
					boost.Add(child)
				end
			end
			boost.Processed += 1
			steps += 1
		end
		if boost.Walking > #boost.Pending then
			table.clear(boost.Pending)
			boost.Walking = 1
		end
		-- Drop processed references when fully drained; retain a total scan cap
		-- per enable cycle so streamed objects cannot grow patch records forever.
	end
	return boost
end
