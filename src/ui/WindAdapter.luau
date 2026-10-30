-- WindUI-shaped bridge for the supplied Steal An Egg controller.
-- All widgets/configuration use the embedded Nullx11 toolkit; no remote UI.
return function(library, gen2)
	local wind = {}
	function wind:Notify(spec)
		library:Notify(
			spec.Title or "Steal An Egg",
			spec.Content or "",
			spec.Duration or 4
		)
	end
	function wind:CreateWindow(_spec)
		local base = gen2:CreateWindow({})
		local window = {
			Native = base.Native,
			ConfigManager = base.ConfigManager,
			Destroyed = false,
		}
		function window:Destroy()
			if self.Destroyed then
				return
			end
			self.Destroyed = true
			library:Unload()
		end
		function window:OnDestroy(callback)
			library:OnUnload(function()
				self.Destroyed = true
				callback()
			end)
		end
		function window:Tab(spec)
			local original =
				base:CreateTab({ name = spec.Title, icon = spec.Icon })
			local tab = {}
			local function options(info)
				return {
					name = info.Title,
					description = info.Desc,
					flag = info.Flag,
					value = info.Value,
					callback = info.Callback,
				}
			end
			function tab:Select()
				original:Select()
			end
			function tab:Section(info)
				return original:CreateSection({ name = info.Title })
			end
			function tab:Paragraph(info)
				local element =
					original:CreateText({ name = info.Title, text = info.Desc })
				local lastTitle = info.Title
				local setTitle = element.SetTitle
				function element:SetTitle(value)
					if value == lastTitle then
						return
					end
					lastTitle = value
					setTitle(self, value)
				end
				return element
			end
			function tab:Toggle(info)
				return original:CreateToggle(options(info))
			end
			function tab:Button(info)
				return original:CreateButton(options(info))
			end
			function tab:Input(info)
				local spec = options(info)
				spec.placeholder = info.Placeholder
				return original:CreateInput(spec)
			end
			function tab:Slider(info)
				local spec = options(info)
				spec.range = { info.Value.Min, info.Value.Max }
				spec.value = info.Value.Default
				spec.increment = info.Value.Step
				return original:CreateSlider(spec)
			end
			function tab:Dropdown(info)
				local spec = options(info)
				spec.options, spec.multi = info.Values, info.Multi == true
				if spec.multi and spec.callback then
					local callback = spec.callback
					spec.callback = function(selected)
						local values = {}
						for _, value in ipairs(spec.options or {}) do
							if selected[value] then
								table.insert(values, value)
							end
						end
						callback(values)
					end
				end
				local element = original:CreateDropdown(spec)
				local refresh = element.Refresh
				function element:Refresh(values)
					spec.options = values
					refresh(self, values)
				end
				return element
			end
			function tab:Space()
				return original:CreateDivider()
			end
			return tab
		end
		return window
	end
	return wind
end
