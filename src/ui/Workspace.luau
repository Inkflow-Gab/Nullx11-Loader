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
					Title = "Nullx11 / Developed by NULL",
					Content = "One Nullx11 interface, native player tools and eight independent game workspaces. Nothing plays or farms until you enable it.",
				})
				local live = welcomeGroup:AddLabel("Reading current session...")
				library:Every(1, function()
					if not alive or not window.Visible then
						return
					end
					live:SetText(
						string.format(
							"%s / %d FPS / %d players / place %s",
							player.DisplayName,
							library:GetFPS(),
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
					"Find your game. Open your own workspace."
				)
				local catalog = playerToolsBridge.Catalog
				local browser = library:CreateScriptBrowser(scriptsTab, {
					Entries = function()
						return catalog.Entries
					end,
					Refresh = catalog.Refresh,
					Open = function(entry)
						secondary(function()
							catalog.OpenGame(entry)
						end)
					end,
				})
				catalog.WorkspaceBrowser = browser
				library:OnUnload(function()
					if catalog.WorkspaceBrowser == browser then
						catalog.WorkspaceBrowser = nil
					end
				end)

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
							"Stopped registered game sessions by your explicit request.",
							6,
							"Info"
						)
					end,
				})
				safety:AddParagraph({
					Title = "Cleanup and consent",
					Content = "Unload closes only this loader and its native tools. Executed game scripts keep their own windows and controls. Use their Unload action, or the separate confirmed stop button above, to stop them.",
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
			end
			library:CreateWindow({
				Title = "Nullx11",
				SubTitle = "Developed by NULL",
				Theme = "Nullx11",
				MenuKey = appearance.ToggleKey,
				ConfigFolder = "Nullx11 Workspace",
				Intro = false,
				Watermark = false,
				OnUnlocked = build,
			})
			playerToolsBridge.UnloadPrimary = function()
				library:Unload()
			end
			playerToolsBridge.StartupBegin = function()
				return library:SetOpening(true)
			end
			playerToolsBridge.StartupEnd = function()
				library:SetOpening(false)
			end
			playerToolsBridge.BeginExecution = function(title)
				return library:BeginExecution(title)
			end
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
				-- Games have independent ownership/lifetimes. Never stop them here.
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
