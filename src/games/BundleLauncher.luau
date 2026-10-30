-- Wrong-place UI for directly opened standalone bundles. No controller is
-- initialized until its exact target place matches. Execution after arrival is
-- an explicit, non-persisted opt-in and references only this bundle.
return function(library, entry, url)
	local Players = game:GetService("Players")
	local TeleportService = game:GetService("TeleportService")
	local selectedAfterJoin = false
	local teleporting = false
	local status
	local failureConnection
	local env = type(getgenv) == "function" and getgenv() or _G
	env.Nullx11SelectedGameQueues = env.Nullx11SelectedGameQueues or {}
	local queued = env.Nullx11SelectedGameQueues
	local function queueAPI()
		if type(queue_on_teleport) == "function" then
			return queue_on_teleport
		end
		if type(queueonteleport) == "function" then
			return queueonteleport
		end
		if
			type(syn) == "table"
			and type(syn.queue_on_teleport) == "function"
		then
			return syn.queue_on_teleport
		end
	end
	local function message(text)
		if not library.Unloaded and status then
			status:SetText(text)
		end
	end
	library:OnUnload(function()
		if failureConnection then
			failureConnection:Disconnect()
		end
	end)
	library:CreateWindow({
		Title = "Nullx11",
		SubTitle = entry.Name,
		Theme = "Nullx11",
		Intro = false,
		Watermark = false,
		ConfigFolder = "Nullx11 Launch " .. entry.Id,
		OnUnlocked = function()
			local tab = library.Window:AddTab(
				"Game launch",
				"teleport",
				"Wrong game / explicit teleport consent"
			)
			local group = tab:AddLeftGroupbox(entry.Name, "play")
			group:AddParagraph({
				Title = "This script belongs to another game",
				Content = "Current place: "
					.. tostring(game.PlaceId)
					.. "\nTarget place: "
					.. tostring(entry.GamePlaceId)
					.. "\nThe game controller has not started.",
			})
			group:AddToggle("SelectedAfterJoin", {
				Text = "Execute this selected script after joining",
				Default = false,
				NoSave = true,
				Callback = function(value)
					selectedAfterJoin = value == true
					message(
						selectedAfterJoin
								and "Opted in: selected game bundle only."
							or "Teleport only. No new code will be queued."
					)
				end,
			})
			status = group:AddLabel(
				"Teleport only is the default. Nothing has been queued."
			)
			group:AddButton({
				Text = "Teleport to selected game",
				Func = function()
					if teleporting or library.Unloaded then
						return
					end
					if queued[entry.Id] and not selectedAfterJoin then
						message(
							"Earlier code may remain queued. Clear the executor queue before requesting teleport-only."
						)
						return
					end
					if selectedAfterJoin and not queued[entry.Id] then
						local queue = queueAPI()
						if not queue or type(loadstring) ~= "function" then
							message(
								"Queue/loadstring unavailable. Turn off execute-after-joining to teleport only."
							)
							return
						end
						local payload = string.format(
							[[local ok,reason=pcall(function()
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId~=%d then return end
local source=game:HttpGet(%q,true)
assert(type(source)=="string" and #source<=2097152,"Invalid selected game bundle")
local run,err=loadstring(source,"Nullx11SelectedGame")
assert(run,err)
run()
end)
if not ok then warn("[Nullx11 game] "..tostring(reason)) end]],
							entry.GamePlaceId,
							url
						)
						local ok, reason = pcall(queue, payload)
						if not ok then
							message(
								"Queue failed; no teleport requested: "
									.. tostring(reason)
							)
							return
						end
						queued[entry.Id] = true
					end
					teleporting = true
					message(
						selectedAfterJoin
								and "Teleport requested; this game bundle is queued."
							or "Teleport requested without queued code."
					)
					local ok, reason = pcall(
						TeleportService.Teleport,
						TeleportService,
						entry.GamePlaceId,
						Players.LocalPlayer
					)
					if not ok then
						teleporting = false
						message(
							"Teleport failed: "
								.. tostring(reason)
								.. (
									queued[entry.Id]
										and " / Code may remain queued."
									or ""
								)
						)
					end
				end,
			})
			group:AddButton({
				Text = "Close game launch window",
				Func = function()
					library:Unload()
				end,
			})
			group:AddLabel(entry.Author)
		end,
	})
	failureConnection = TeleportService.TeleportInitFailed:Connect(
		function(who, result, reason, placeId)
			if
				who ~= Players.LocalPlayer
				or placeId ~= entry.GamePlaceId
				or not teleporting
			then
				return
			end
			teleporting = false
			message(
				"Teleport rejected: "
					.. tostring(reason or result)
					.. (queued[entry.Id] and " / Code may remain queued." or "")
			)
		end
	)
end
