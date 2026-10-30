-- Compatibility bridge for the two supplied Gen2 controllers.
-- Every control is a real shared-UI control; no Sirius download or placeholder UI.
return function(library, title, folder)
	local adapter = {}
	local sequence = 0
	local function id(spec)
		sequence += 1
		return tostring(spec.flag or ("Control_" .. sequence))
	end
	local function handle(native, spec)
		local element = { Native = native, value = spec.value }
		function element:Set(value)
			if
				type(value) == "table"
				and (value.Title or value.Desc or value.Text)
			then
				if value.Title and native.SetTitle then
					native:SetTitle(value.Title)
				end
				if native.SetContent then
					native:SetContent(value.Desc or value.Text or "")
				end
				return
			end
			self.value = value
			if native.SetValue then
				native:SetValue(value)
			elseif native.SetText then
				native:SetText(tostring(value))
			end
		end
		function element:SetTitle(value)
			if native.SetTitle then
				native:SetTitle(value)
			elseif native.Row then
				native.Row:SetTitle(value)
			elseif native.SetText then
				native:SetText(value)
			end
		end
		function element:SetDesc(value)
			if native.SetContent then
				native:SetContent(value)
			elseif native.Row and native.Row.Desc then
				native.Row.Desc.Text = tostring(value)
				native.Container:MarkDirty()
			end
		end
		function element:Refresh(values)
			assert(native.SetValues, "This control is not a dropdown")
			native:SetValues(values)
		end
		element.Select = element.Set
		return element
	end
	function adapter:CreateWindow(_spec)
		local window = {}
		local native = library:CreateWindow({
			Title = "Nullx11",
			SubTitle = title .. " / Gab",
			ConfigFolder = folder,
			Theme = "Nullx11",
			MenuKey = Enum.KeyCode.LeftControl,
			Intro = false,
			Watermark = false,
		})
		window.Native = native
		window.settings = {}
		function window:CreateTab(spec)
			local tab = {
				Native = native:AddTab(
					spec.name or "Tab",
					spec.icon,
					spec.description or ""
				),
			}
			function tab:CreateSection(info)
				self.Group =
					self.Native:AddLeftGroupbox(info.name or "Controls")
				return self.Group
			end
			function tab:Container()
				if not self.Group then
					self.Group =
						self.Native:AddLeftGroupbox(spec.name or "Controls")
				end
				return self.Group
			end
			function tab:CreateToggle(info)
				return handle(
					self:Container():AddToggle(id(info), {
						Text = info.name,
						Description = info.description,
						Icon = info.icon,
						Default = info.value == true,
						Callback = info.callback,
					}),
					info
				)
			end
			function tab:CreateSlider(info)
				local step = tonumber(info.increment) or 1
				local decimals = math.clamp(math.ceil(-math.log10(step)), 0, 6)
				return handle(
					self:Container():AddSlider(id(info), {
						Text = info.name,
						Description = info.description,
						Icon = info.icon,
						Min = info.range[1],
						Max = info.range[2],
						Default = info.value,
						Rounding = decimals,
						Callback = info.callback,
					}),
					info
				)
			end
			function tab:CreateDropdown(info)
				return handle(
					self:Container():AddDropdown(id(info), {
						Text = info.name,
						Description = info.description,
						Icon = info.icon,
						Values = info.options or {},
						Multi = info.multi == true,
						Default = info.value,
						Callback = info.callback,
					}),
					info
				)
			end
			function tab:CreateInput(info)
				return handle(
					self:Container():AddInput(id(info), {
						Text = info.name,
						Description = info.description,
						Icon = info.icon,
						Default = info.value or "",
						Placeholder = info.placeholder,
						Finished = true,
						Callback = info.callback,
					}),
					info
				)
			end
			function tab:CreateButton(info)
				return handle(
					self:Container()
						:AddButton({ Text = info.name, Func = info.callback }),
					info
				)
			end
			function tab:CreateText(info)
				return handle(
					self:Container():AddParagraph({
						Title = info.name or "Status",
						Content = info.text or info.description or "",
					}),
					info
				)
			end
			function tab:CreateDivider()
				return self:Container():AddDivider()
			end
			function tab:Select()
				native:SelectTab(self.Native)
			end
			return tab
		end
		function window:SelectTab(index)
			local tab = native.Tabs[index]
			if tab then
				native:SelectTab(tab)
			end
		end
		function window:Notify(info)
			library:Notify(
				info.Title or info.title or title,
				info.content or info.Content or "",
				info.duration or info.Duration or 4
			)
		end
		function window:ChangeTheme(theme)
			library:SetTheme(type(theme) == "string" and theme or "Nullx11")
		end
		function window:SetTransparency(value)
			local number = type(value) == "boolean" and (value and 0.2 or 0)
				or tonumber(value)
			if number then
				native.Body.BackgroundTransparency = math.clamp(number, 0, 0.8)
			end
		end
		function window:SetToggleKey(key)
			library:SetMenuKey(key)
		end
		function window:Unload()
			library:Unload()
		end
		function window:OnDestroy(callback)
			library:OnUnload(callback)
		end
		local manager = {}
		function manager:DeleteConfig(name)
			return library.Configs.Delete(name)
		end
		function manager:AllConfigs()
			return library.Configs.List()
		end
		function manager:CreateConfig(name)
			local config = { Controls = {} }
			function config:Register(key, element)
				assert(
					type(key) == "string" and element.Native,
					"Invalid configuration control"
				)
				self.Controls[key] = element.Native
			end
			function config:Save()
				local ok, reason = library:SaveConfig(name)
				assert(ok, reason or "Configuration save failed")
			end
			function config:Load()
				local ok, reason = library:LoadConfig(name)
				assert(ok, reason or "Configuration load failed")
			end
			function config:Delete()
				local ok, reason = library.Configs.Delete(name)
				assert(ok, reason or "Configuration delete failed")
			end
			return config
		end
		window.ConfigManager = manager
		return window
	end
	return adapter
end
