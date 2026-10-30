-- Compatibility notice only. Never teleports, queues code or starts a controller.
return function(library, entry, _url)
	library:CreateWindow({
		Title = "Nullx11",
		SubTitle = entry.Name .. " / Gab",
		Theme = "Nullx11",
		Intro = false,
		Watermark = false,
		ConfigFolder = "Nullx11 Launch " .. entry.Id,
		OnUnlocked = function()
			local tab = library.Window:AddTab(
				"Compatibility",
				"info",
				"Join the game manually"
			)
			local group = tab:AddLeftGroupbox("Unsupported game")
			group:AddParagraph({
				Title = "Cannot start here",
				Content = "Required game/place compatibility was not detected. Join the intended game manually and execute again. No teleport or automatic execution was requested.",
			})
			group:AddParagraph({
				Title = "Credits",
				Content = entry.Author or "Developed by Gab",
			})
			group:AddButton({
				Text = "Close",
				Func = function()
					library:Unload()
				end,
			})
		end,
	})
end
