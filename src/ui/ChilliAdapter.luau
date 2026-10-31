-- API bridge for the supplied recovered controller, rendered ONLY by Nullx11.
-- Chilli's downloaded UI, quick-bar bootstrap, profile autoload and telemetry are not used.
return function(library, runtime)
	local adapter = {}
	local controls, states, sequence = {}, {}, 0
	local window
	adapter.Notify = function(title, content, duration)
		library:Notify(title, content, duration or 5)
	end
	function adapter:CreateWindow(_spec)
		local native = library:CreateWindow({
			Title = "Nullx11",
			SubTitle = "stealabrainrot / Gab",
			Theme = "Nullx11",
			Intro = false,
			Watermark = false,
			MenuKey = Enum.KeyCode.LeftControl,
			ConfigFolder = "Nullx11 stealabrainrot",
		})
		window = { Native = native, _destroyed = false }
		function window:Open()
			native:SetVisible(true)
		end
		function window:GetDefaultTab()
			return self.DefaultTab
		end
		function window:CreateState(spec)
			local state = library.Ref(spec.Default)
			states[spec.Name] = state
			return state
		end
		function window:GetState(name)
			return states[name]
		end
		function window:CreateTab(spec)
			local title = type(spec) == "table" and spec.Name or spec
			local icons = {
				Stealer = "brain",
				Helper = "settings",
				Player = "user",
				ESP = "eye",
				Misc = "settings",
				Server = "server",
				["Source limitations"] = "info",
			}
			local tabNative =
				native:AddTab(title, icons[title], "stealabrainrot / Nullx11")
			local tab = { Native = tabNative }
			if not self.DefaultTab then
				self.DefaultTab = tab
			end
			function tab:CreateSection(spec)
				local group = tabNative:AddLeftGroupbox(spec.Name)
				local section = {}
				local function build(kind, info)
					sequence += 1
					local key = "Brainrot_" .. sequence
					local element = {
						Spec = info,
						Kind = kind,
						Value = kind == "Toggle" and false or info.Default,
					}
					if kind == "Toggle" then
						element.Value = false
					end
					local function callback(value)
						element.Value = value
						if info.Callback then
							runtime.Guard(info.Callback)(value)
						end
					end
					local spec = {
						Text = info.Name,
						Description = info.Note,
						Default = element.Value,
						Callback = callback,
					}
					local control
					if kind == "Toggle" then
						control = group:AddToggle(key, spec)
					elseif kind == "Slider" then
						spec.Min, spec.Max = info.Min, info.Max
						spec.Rounding = info.AllowDecimals
								and math.clamp(
									math.ceil(
										-math.log10(info.Increment or 0.1)
									),
									0,
									6
								)
							or 0
						control = group:AddSlider(key, spec)
					elseif kind == "Dropdown" or kind == "MultiDropdown" then
						spec.Values, spec.Multi =
							info.Options or {}, kind == "MultiDropdown"
						control = group:AddDropdown(key, spec)
					elseif kind == "Input" then
						spec.Placeholder, spec.Finished = info.Placeholder, true
						control = group:AddInput(key, spec)
					elseif kind == "Button" then
						spec.Func = runtime.Guard(info.Callback)
						-- Purchasing/unlocking and kicking/resetting are still explicit user actions.
						spec.DoubleClick = info.Name:find(
							"Unlock Floor",
							1,
							true
						) ~= nil or info.Name == "Kick" or info.Name == "Fast Reset"
						control = group:AddButton(spec)
					else
						control = group:AddParagraph({
							Title = info.Name,
							Content = info.Text or info.Note or "",
						})
					end
					element.Native = control
					function element:Get()
						return control.Value ~= nil and control.Value
							or self.Value
					end
					function element:Set(value, fire)
						local saved = control.Callback
						if fire == false then
							control.Callback = nil
						end
						if control.SetValue then
							control:SetValue(value)
						else
							control:SetContent(tostring(value))
						end
						control.Callback = saved
						self.Value = value
					end
					function element:SetRange(min, max, fire)
						local callback = control.Callback
						if fire == false then
							control.Callback = nil
						end
						control:SetRange(min, max)
						control.Callback = callback
					end
					function element:SetOptions(values, value, fire)
						control:SetValues(values)
						if value ~= nil then
							self:Set(value, fire)
						end
					end
					function element:GetUnit()
						return self.Unit
					end
					local unit = info.Unit
					if type(unit) == "table" then
						element.Unit = unit.Default
						element.UnitNative = group:AddDropdown(key .. "_Unit", {
							Text = info.Name .. " / unit",
							Values = unit.Options,
							Default = unit.Default,
							Callback = function(value)
								element.Unit = value
								if unit.Callback then
									runtime.Guard(unit.Callback)(value)
								end
							end,
						})
					end
					local parent = info.ShowWhen or info.SubOf
					if
						parent
						and parent.Native
						and parent.Native.Ref
						and control.SetVisible
					then
						library.Watch(parent.Native.Ref, function(value)
							control:SetVisible(value == true)
							if element.UnitNative then
								element.UnitNative:SetVisible(value == true)
							end
						end, { Immediate = true })
						control:SetVisible(parent:Get() == true)
					end
					table.insert(controls, element)
					return element
				end
				for _, kind in ipairs({
					"Toggle",
					"Slider",
					"Dropdown",
					"MultiDropdown",
					"Input",
					"Button",
					"Text",
				}) do
					section["Create" .. kind] = function(_, info)
						return build(kind, info)
					end
				end
				return section
			end
			return tab
		end
		library:OnUnload(function()
			window._destroyed = true
		end)
		return window
	end
	function adapter:Finalize(_spec)
		-- All source locals exist now. Synchronize OFF states before any worker runs.
		for _, element in ipairs(controls) do
			if element.Kind == "Toggle" and element.Spec.Callback then
				local ok, reason = pcall(element.Spec.Callback, false)
				if not ok then
					warn(
						"[Nullx11 init / "
							.. element.Spec.Name
							.. "] "
							.. tostring(reason)
					)
				end
			end
		end
		runtime.Ready = true
		runtime.AddCleanup(function()
			for i = #controls, 1, -1 do
				local element = controls[i]
				if element.Kind == "Toggle" and element.Spec.Callback then
					pcall(element.Spec.Callback, false)
				end
			end
		end)
		for _, element in ipairs(controls) do
			-- Do not set the device's FPS cap merely by opening a window.
			if
				element.Kind ~= "Toggle"
				and element.Kind ~= "Button"
				and element.Kind ~= "Text"
				and element.Spec.Name ~= "FPS Cap"
				and element.Spec.Callback
			then
				local ok, reason = pcall(element.Spec.Callback, element:Get())
				if not ok then
					warn(
						"[Nullx11 default / "
							.. element.Spec.Name
							.. "] "
							.. tostring(reason)
					)
				end
			end
		end
		local tab = window.Native:AddTab(
			"Nullx11",
			"settings",
			"Session / provenance / manual configuration"
		)
		local group = tab:AddLeftGroupbox("stealabrainrot / Gab")
		group:AddParagraph({
			Title = "Supplied recovered source",
			Content = "Adapted from the supplied Chilli controller. Live game compatibility is unverified. AP/TP/Priority were absent in the source; no working replacements are claimed. Automation and overlays start OFF.",
		})
		group:AddButton({
			Text = "Unload this game script",
			DoubleClick = true,
			Func = function()
				library:Unload()
			end,
		})
		window.Native:AddSettingsTab()
		window.Native:SelectTab(window.DefaultTab.Native)
		runtime.Start()
	end
	return adapter
end
