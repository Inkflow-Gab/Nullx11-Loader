-- Primary Nullx11 workspace. Uses the supplied +1 UI as its actual renderer.
-- Existing player tools and Design Studio remain live, not recreated as demos.
do
	if CONFIG.EnhancedWorkspace then
		local library
		local ok, reason = pcall(function()
			library = createNullx11UI({
				Id = "Workspace",
				ReducedMotion = CONFIG.ReducedMotion,
			})
			local window
			local function secondary(action)
				if window then
					window:SetVisible(false)
				end
				action()
			end
			local function build()
				window = library.Window
				window.OnShow = function()
					expanded = false
					card.Visible = false
					mini.Visible = false
					if playerToolsBridge.FoldWindows then
						playerToolsBridge.FoldWindows()
					end
				end
				local home = window:AddTab(
					"Workspace",
					"home",
					"Your session, without the clutter"
				)
				local welcomeGroup =
					home:AddLeftGroupbox("Nullx11 / session", "star")
				welcomeGroup:AddParagraph({
					Title = "A quieter way to get started.",
					Content = "Shared +1 interface, native player tools and three separate game workspaces. Nothing plays or farms until you enable it.",
				})
				local live = welcomeGroup:AddLabel("Reading current session...")
				local frames, elapsed, fps = 0, 0, 0
				connect(RunService.RenderStepped, function(dt)
					frames += 1
					elapsed += dt
					if elapsed >= 0.5 then
						fps = math.floor(frames / elapsed + 0.5)
						frames, elapsed = 0, 0
					end
				end)
				library:Every(1, function()
					if not alive then
						return
					end
					live:SetText(
						string.format(
							"%s / %d FPS / %d players / place %s",
							player.DisplayName,
							fps,
							#Players:GetPlayers(),
							tostring(game.PlaceId)
						)
					)
				end)
				local actions =
					home:AddRightGroupbox("Open a window", "settings")
				actions:AddButton({
					Text = "Open Scripts library",
					Func = function()
						secondary(playerToolsBridge.OpenScripts)
					end,
				})
				actions:AddButton({
					Text = "Open Visuals / ESP",
					Func = function()
						secondary(playerToolsBridge.OpenVisuals)
					end,
				})
				actions:AddButton({
					Text = "Open Aim / FOV",
					Func = function()
						secondary(playerToolsBridge.OpenAim)
					end,
				})
				actions:AddButton({
					Text = "Open Design Studio",
					Func = function()
						secondary(studioBridge.Open)
					end,
				})
				actions:AddButton({
					Text = "Open classic launcher / App hook",
					Func = function()
						secondary(function()
							setExpanded(true)
							mini.Visible = true
						end)
					end,
				})
				actions:AddButton({
					Text = "Stop aim and visuals",
					Style = "Danger",
					Func = playerToolsBridge.Stop,
				})

				local scriptsTab = window:AddTab(
					"Scripts",
					"code",
					"Open a game workspace; no ON/OFF navigation"
				)
				local catalog = playerToolsBridge.Catalog
				for _, entry in ipairs(catalog.Entries) do
					local group = scriptsTab:AddLeftGroupbox(entry.Name, "play")
					group:AddParagraph({
						Title = "Place " .. tostring(entry.GamePlaceId),
						Content = entry.Description,
					})
					group:AddLabel(entry.Author)
					group:AddButton({
						Text = "Open game launch window",
						Func = function()
							-- Resolve again: a refreshed manifest can remove or replace an entry.
							local selected
							for _, current in ipairs(catalog.Entries) do
								if current.Id == entry.Id then
									selected = current
									break
								end
							end
							if not selected then
								library:Notify(
									"Scripts",
									"This entry changed. Open the refreshed Scripts library.",
									5,
									"Warning"
								)
								return
							end
							secondary(function()
								catalog.OpenGame(selected)
							end)
						end,
					})
				end
				local more = scriptsTab:AddRightGroupbox(
					"Repository library",
					"settings"
				)
				more:AddParagraph({
					Title = "Separate game windows",
					Content = "Wrong game? The launch window offers teleport. Execute after joining is optional and queues only the selected game bundle, never this loader. Teleports are Roblox operations, not guaranteed successes.",
				})
				more:AddButton({
					Text = "Browse / refresh GitHub library",
					Func = function()
						secondary(playerToolsBridge.OpenScripts)
					end,
				})
				more:AddParagraph({
					Title = "Runtime requirements",
					Content = "Game execution needs client loadstring and HTTP. Delta capabilities vary by build. If unavailable, a visible error replaces execution; no simulated gameplay is substituted.",
				})

				local toolsTab = window:AddTab(
					"Session tools",
					"teleport",
					"Bookmarks, coordinates and performance"
				)
				local toolsGroup =
					toolsTab:AddLeftGroupbox("Floating tools", "settings")
				toolsGroup:AddButton({
					Text = "Open teleport / save-return",
					Func = function()
						secondary(function()
							setTeleportEnabled(true)
						end)
					end,
				})
				toolsGroup:AddToggle("WorkspaceReducedMotion", {
					Text = "Reduced motion",
					Default = CONFIG.ReducedMotion,
					NoSave = true,
					Callback = function(value)
						studioBridge.Motion(value)
					end,
				})
				toolsGroup:AddToggle("WorkspaceFPS", {
					Text = "Floating FPS meter",
					Default = false,
					NoSave = true,
					Callback = setFPSEnabled,
				})
				toolsGroup:AddToggle("WorkspaceCoordinates", {
					Text = "Floating position HUD",
					Default = false,
					NoSave = true,
					Callback = setHUDEnabled,
				})
				toolsGroup:AddToggle("WorkspaceGlitch", {
					Text = "Animated glitch title",
					Default = glitchEnabled,
					NoSave = true,
					Callback = function(value)
						setGlitchEnabled(value)
						library:SetTitleGlitch(value)
					end,
				})
				local safety =
					toolsTab:AddRightGroupbox("Session control", "shield")
				safety:AddButton({
					Text = "Unload launched game scripts",
					Style = "Danger",
					DoubleClick = true,
					Func = function()
						local env = type(getgenv) == "function" and getgenv()
							or _G
						local sessions = env.Nullx11GameSessions
						if type(sessions) == "table" then
							local snapshot = table.clone(sessions)
							for _, session in pairs(snapshot) do
								pcall(session.Unload)
							end
						end
						library:Notify(
							"Session",
							"Stopped registered game sessions. Executor teleport queues cannot be universally cleared.",
							6,
							"Info"
						)
					end,
				})
				safety:AddParagraph({
					Title = "Cleanup and consent",
					Content = "Closing the workspace with Unload stops its registered game sessions and native tools. Hiding a window does not stop a feature. Previously queued teleport code can survive a failed teleport; check your executor before retrying.",
				})
				window:AddSettingsTab()
				library:SetTitleGlitch(glitchEnabled)
			end
			playerToolsBridge.ReducedMotion = function(value)
				library:SetReducedMotion(value)
				library:SetTitleGlitch(not value and glitchEnabled)
				if value and library.Options.WorkspaceGlitch then
					library.Options.WorkspaceGlitch:SetValue(false)
				end
				local env = type(getgenv) == "function" and getgenv() or _G
				env.Nullx11ReducedMotion = value == true
				for _, session in pairs(env.Nullx11GameSessions or {}) do
					if session.Library then
						session.Library:SetReducedMotion(value)
					end
				end
			end
			library:CreateWindow({
				Title = "Nullx11",
				SubTitle = "personal workspace",
				Theme = "Nullx11",
				MenuKey = appearance.ToggleKey,
				ConfigFolder = "Nullx11 Workspace",
				Intro = CONFIG.StartupAnimation and not CONFIG.ReducedMotion,
				Watermark = false,
				OnUnlocked = build,
			})
			-- The shared interface is the entry point; the older UI is an advanced
			-- compatibility surface, available deliberately through Workspace.
			playerToolsBridge.PrimaryActive = true
			expanded = false
			card.Visible = false
			mini.Visible = false
			library:OnUnload(function()
				if alive then
					gui:Destroy()
				end
			end)
			connect(gui.Destroying, function()
				local env = type(getgenv) == "function" and getgenv() or _G
				if type(env.Nullx11GameSessions) == "table" then
					for _, session in
						pairs(table.clone(env.Nullx11GameSessions))
					do
						pcall(session.Unload)
					end
				end
				library:Unload()
			end)
		end)
		if not ok then
			playerToolsBridge.PrimaryActive = false
			if library then
				pcall(library.Unload, library)
			end
			expanded = true
			card.Visible = true
			mini.Visible = true
			status.Text =
				"Shared UI could not start; classic controls remain available."
			warn("[Nullx11 workspace] " .. tostring(reason))
		end
	end
end
