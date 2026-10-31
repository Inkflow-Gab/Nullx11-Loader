-- Observable, monotonic execution stages. No time-based/fabricated percentages.
return function(render)
	local model = {
		PhaseIndex = 1,
		Completed = 0,
		Status = "running",
		Detail = "Requesting repository source. Cancel prevents startup; the executor network request may still finish.",
		Started = false,
		Hidden = false,
	}
	function model:Phase(index, detail)
		if self.Status ~= "running" then
			return false
		end
		assert(
			index >= self.PhaseIndex and index <= 4 and index % 1 == 0,
			"Invalid execution stage"
		)
		self.PhaseIndex, self.Completed = index, index - 1
		self.Detail = tostring(detail or "")
		self.Started = index == 4
		render(self)
		return true
	end
	function model:Finish()
		if self.Status ~= "running" then
			return
		end
		self.Completed, self.Status = 4, "complete"
		self.Detail =
			"The client chunk returned. Check the game window for compatibility and feature status."
		render(self)
	end
	function model:Fail(reason)
		if self.Status ~= "running" then
			return
		end
		self.Status, self.Detail =
			"failed", string.sub(tostring(reason), 1, 700)
		render(self)
	end
	function model:Dismiss()
		self.Hidden = true
		if self.Status == "running" and not self.Started then
			self.Status = "cancelled"
		end
		render(self)
	end
	function model:CanContinue()
		return self.Status == "running"
	end
	render(model)
	return model
end
