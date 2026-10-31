-- Nullx11 / Gab adaptation of the supplied TTK source. See source review.
local patches = context.Patches
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local cfg = {
	esp = false,
	box = true,
	names = true,
	dist = true,
	head = true,
	chams = true,
	enemyOnly = true,
	aim = false,
	aimHead = true,
	aimFov = 130,
	aimSmooth = 0,
	showFov = true,
	noSpread = false,
	noRecoil = false,
	noShake = false,
	noSway = false,
	infAmmo = false,
	infReserve = false,
	noReload = false,
	rapid = false,
	rapidRate = 0.05,
	fullAuto = false,
	instantADS = false,
	infThrow = false,
}
local COL_ENEMY = Color3.fromRGB(255, 70, 70)
local COL_ALLY = Color3.fromRGB(90, 200, 120)
local aimActive = false
local SWAY_SPRINGS = {
	"MoveLagSpring",
	"MovementLowerSpring",
	"GunStrafeRollSpring",
	"LookFlickSpring",
	"LookPitchTiltSpring",
	"LandingSpring",
	"CrouchJerkPosSpring",
	"CrouchJerkRotSpring",
	"BarrelSnapSpring",
	"AdsLookaroundSpring",
	"AimParallaxSpring",
}

local function cam()
	return Workspace.CurrentCamera
end
local function w2s(p)
	local c = cam()
	if not c then
		return nil
	end
	local v, on = c:WorldToViewportPoint(p)
	return Vector2.new(v.X, v.Y), (on and v.Z > 0), v.Z
end
local function myTeam()
	return LP.Character and LP.Character:GetAttribute("Team")
end
local function scanTargets(enemyOnly)
	local mt, out, best = myTeam(), {}, {}
	local mp = Workspace:FindFirstChild("MercPlayers")
	if not mp then
		return out
	end
	for _, rig in ipairs(mp:GetChildren()) do
		if
			rig.Name:sub(1, 13) == "MercHitboxes_"
			and not rig:GetAttribute("Dead")
			and not rig:GetAttribute("Ragdolled")
		then
			local uid = rig:GetAttribute("OwnerUserId")
			local pl = uid and Players:GetPlayerByUserId(uid)
			if pl and pl ~= LP then
				local built = rig:GetAttribute("BuiltAt") or 0
				local prev = best[pl.Name]
				if not prev or built >= prev.built then
					best[pl.Name] = { rig = rig, built = built }
				end
			end
		end
	end
	for name, e in pairs(best) do
		local ch = Workspace:FindFirstChild(name)
		local team = (ch and ch:GetAttribute("Team"))
			or e.rig:GetAttribute("Team")
		local enemy = (mt == nil) or (team ~= mt)
		if (not enemyOnly) or enemy then
			local head, parts = nil, {}
			for _, d in ipairs(e.rig:GetDescendants()) do
				if #parts >= 24 then
					break
				end
				if d:IsA("BasePart") then
					if d.Name:find("HitZone", 1, true) then
						parts[#parts + 1] = d
					end
					if d.Name == "Head" then
						head = d
					end
				end
			end
			if #parts == 0 then
				for _, d in ipairs(e.rig:GetDescendants()) do
					if #parts >= 24 then
						break
					end
					if d:IsA("BasePart") then
						parts[#parts + 1] = d
					end
				end
			end
			if #parts > 0 then
				out[#out + 1] = {
					name = name,
					hb = e.rig,
					visual = e.rig,
					head = head,
					parts = parts,
					enemy = enemy,
				}
			end
		end
	end
	while #out > 24 do
		table.remove(out)
	end
	return out
end
local cachedTargets, nextTargets = {}, 0
local function targets(enemyOnly)
	if os.clock() >= nextTargets then
		cachedTargets = scanTargets(false)
		nextTargets = os.clock() + 0.25
	end
	if not enemyOnly then
		return cachedTargets
	end
	local filtered = {}
	for _, target in ipairs(cachedTargets) do
		if target.enemy then
			table.insert(filtered, target)
		end
	end
	return filtered
end

local pool = {}
local function slot(i)
	if pool[i] then
		return pool[i]
	end
	local created = {}
	local function allocate(kind)
		local object = Drawing.new(kind)
		table.insert(created, object)
		return object
	end
	local ok, s = pcall(function()
		return {
			box = allocate("Square"),
			name = allocate("Text"),
			dist = allocate("Text"),
			head = allocate("Circle"),
		}
	end)
	if not ok then
		for _, object in ipairs(created) do
			pcall(function()
				object:Remove()
			end)
		end
		return nil
	end
	pool[i] = s
	s.box.Thickness = 1
	s.box.Filled = false
	s.box.Transparency = 1
	s.name.Size = 14
	s.name.Center = true
	s.name.Outline = true
	s.dist.Size = 14
	s.dist.Center = true
	s.dist.Outline = true
	s.head.Thickness = 1
	s.head.Filled = false
	s.head.NumSides = 14
	for _, o in pairs(s) do
		o.Visible = false
	end
	pool[i] = s
	return s
end
local function hideFrom(n)
	for i = n, #pool do
		for _, o in pairs(pool[i]) do
			o.Visible = false
		end
	end
end
local function hideAll()
	hideFrom(1)
end

local chamsHolder
pcall(function()
	chamsHolder = Instance.new("Folder")
	chamsHolder.Name = "Nullx11_TTK_Chams"
	chamsHolder.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end)
local chamsPool = {}
local function chamSlot(i)
	if chamsPool[i] then
		return chamsPool[i]
	end
	local ok, h = pcall(function()
		local x = Instance.new("Highlight")
		x.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		x.FillTransparency = 0.55
		x.OutlineTransparency = 0
		x.Enabled = false
		x.Parent = chamsHolder
		return x
	end)
	if not ok then
		return nil
	end
	chamsPool[i] = h
	return h
end
local function hideChams(from)
	for i = from, #chamsPool do
		chamsPool[i].Enabled = false
		chamsPool[i].Adornee = nil
	end
end

local nextVisual = 0
context.Connect(RunService.RenderStepped, function()
	if os.clock() < nextVisual then
		return
	end
	nextVisual = os.clock() + 1 / 30
	if not cfg.esp then
		hideAll()
		hideChams(1)
		return
	end
	local list = targets(cfg.enemyOnly)
	if cfg.chams then
		local c = 0
		for _, t in ipairs(list) do
			if t.visual then
				c = c + 1
				local h = chamSlot(c)
				if h then
					local col = t.enemy and COL_ENEMY or COL_ALLY
					h.Adornee = t.visual
					h.FillColor = col
					h.OutlineColor = col
					h.Enabled = true
				end
			end
		end
		hideChams(c + 1)
	else
		hideChams(1)
	end
	if not Drawing then
		hideAll()
		return
	end
	local eye = cam() and cam().CFrame.Position
	local n = 0
	for _, t in ipairs(list) do
		local minX, minY, maxX, maxY, any = 1e9, 1e9, -1e9, -1e9, false
		local bounds = {}
		if t.hb:IsA("Model") then
			local ok, frame, size = pcall(t.hb.GetBoundingBox, t.hb)
			if ok then
				bounds[1] = { CFrame = frame, Size = size }
			end
		end
		if #bounds == 0 then
			for index = 1, math.min(#t.parts, 8) do
				bounds[index] = t.parts[index]
			end
		end
		for _, p in ipairs(bounds) do
			local sz = p.Size * 0.5
			for sx = -1, 1, 2 do
				for sy = -1, 1, 2 do
					for sz2 = -1, 1, 2 do
						local s, on = w2s(
							(p.CFrame * CFrame.new(
								sz.X * sx,
								sz.Y * sy,
								sz.Z * sz2
							)).Position
						)
						if on then
							any = true
							if s.X < minX then
								minX = s.X
							end
							if s.Y < minY then
								minY = s.Y
							end
							if s.X > maxX then
								maxX = s.X
							end
							if s.Y > maxY then
								maxY = s.Y
							end
						end
					end
				end
			end
		end
		if any then
			n = n + 1
			local s = slot(n)
			if s then
				local col = t.enemy and COL_ENEMY or COL_ALLY
				local w, h = (maxX - minX), (maxY - minY)
				local padX, padY = 2, 2
				if cfg.box then
					s.box.Position = Vector2.new(minX - padX, minY - padY)
					s.box.Size = Vector2.new(w + padX * 2, h + padY * 2)
					s.box.Color = col
					s.box.Visible = true
				else
					s.box.Visible = false
				end
				if cfg.names then
					s.name.Text = t.name
					s.name.Color = col
					s.name.Position =
						Vector2.new((minX + maxX) / 2, minY - padY - 15)
					s.name.Visible = true
				else
					s.name.Visible = false
				end
				if cfg.dist and eye then
					local ref = (t.head or t.parts[1]).Position
					s.dist.Text = ("%d studs"):format((ref - eye).Magnitude)
					s.dist.Color = col
					s.dist.Position =
						Vector2.new((minX + maxX) / 2, maxY + padY + 1)
					s.dist.Visible = true
				else
					s.dist.Visible = false
				end
				if cfg.head and t.head then
					local hs, on = w2s(t.head.Position)
					if on then
						s.head.Position = hs
						s.head.Radius = math.max(h * 0.06, 2)
						s.head.Color = col
						s.head.Visible = true
					else
						s.head.Visible = false
					end
				else
					s.head.Visible = false
				end
			end
		end
	end
	hideFrom(n + 1)
end)

local aiming = false
local touchAim = false
context.Connect(UIS.InputBegan, function(i, gpe)
	if not gpe and i.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = true
	end
end)
context.Connect(UIS.InputEnded, function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = false
	end
end)
local fovCircle
context.Connect(RunService.RenderStepped, function()
	local c = cam()
	if not c then
		return
	end
	if Drawing and cfg.aim and cfg.showFov then
		if not fovCircle then
			local ok, x = pcall(function()
				local o = Drawing.new("Circle")
				o.Thickness = 1
				o.Filled = false
				o.NumSides = 48
				o.Color = Color3.fromRGB(255, 255, 255)
				o.Transparency = 0.5
				return o
			end)
			fovCircle = ok and x or nil
		end
		if fovCircle then
			fovCircle.Position = c.ViewportSize / 2
			fovCircle.Radius = cfg.aimFov
			fovCircle.Visible = true
		end
	elseif fovCircle then
		fovCircle.Visible = false
	end
	if not cfg.aim or not (aiming or touchAim) then
		aimActive = false
		return
	end
	local center = c.ViewportSize / 2
	local best, bestD
	for _, t in ipairs(targets(true)) do
		local part = (cfg.aimHead and t.head) or t.parts[1]
		if part then
			local sp, on = w2s(part.Position)
			if on then
				local d = (sp - center).Magnitude
				if d < cfg.aimFov and (not bestD or d < bestD) then
					bestD, best = d, part.Position
				end
			end
		end
	end
	aimActive = best ~= nil
	if best then
		local pos = c.CFrame.Position
		local alpha = math.clamp(1 - cfg.aimSmooth, 0.06, 1)
		c.CFrame = c.CFrame:Lerp(CFrame.lookAt(pos, best), alpha)
	end
end)

local localGun, gunObj, camCtrl, firearmClass

local hooksInstalled = false
local function patchMethod(object, key, callback)
	patches.Write("hooks", object, key, callback)
end
local function discover()
	if type(getgc) ~= "function" then
		return "getgc is unavailable; module hooks remain usable."
	end
	local snapshot = getgc(true)
	local limit = math.min(#snapshot, 50000)
	for index = 1, limit do
		local object = snapshot[index]
		if type(object) == "table" then
			if
				not firearmClass
				and type(rawget(object, "Fire")) == "function"
				and type(rawget(object, "InitFromDef")) == "function"
			then
				firearmClass = object
				local original = object.Fire
				patchMethod(object, "Fire", function(self, ...)
					localGun = self
					if cfg.infAmmo and type(self.MaxMagSize) == "number" then
						patches.Write(
							"infAmmo",
							self,
							"MagAmmo",
							self.MaxMagSize + 1
						)
					end
					if cfg.rapid then
						patches.Write("rapid", self, "CanFire", true)
						patches.Write(
							"rapid",
							self,
							"FireRate",
							math.min(self.FireRate or 0.1, cfg.rapidRate)
						)
					end
					return original(self, ...)
				end)
				local reserve = object.GetReserve
				if type(reserve) == "function" then
					patchMethod(object, "GetReserve", function(self, ...)
						if cfg.infReserve then
							return 999
						end
						return reserve(self, ...)
					end)
				end
			end
			if
				not camCtrl
				and rawget(object, "_recoilShakeSpring") ~= nil
				and rawget(object, "_recoilSpring") ~= nil
			then
				camCtrl = object
			end
		end
		if firearmClass and camCtrl then
			break
		end
	end
	return string.format(
		"Firearm: %s / camera: %s. Explicit scan, at most 50,000 tables; no background GC polling.",
		firearmClass and "found" or "not found",
		camCtrl and "found" or "not found"
	)
end
local function installHooks()
	if hooksInstalled then
		return
	end
	hooksInstalled = true

	pcall(function()
		local GC = require(RS.Modules.Client.Controllers.GunController)
		if type(GC) ~= "table" then
			return
		end
		for _, fn in ipairs({ "ApplyRecoil", "_FireScriptedRecoil" }) do
			local orig = GC[fn]
			if type(orig) == "function" then
				patchMethod(GC, fn, function(self, ...)
					gunObj = self
					if cfg.noRecoil then
						return
					end
					return orig(self, ...)
				end)
			end
		end
		for _, fn in ipairs({ "GetBloomFraction", "GetEffectiveBloomFraction" }) do
			local orig = GC[fn]
			if type(orig) == "function" then
				patchMethod(GC, fn, function(self, ...)
					if cfg.noSpread then
						return 0
					end
					return orig(self, ...)
				end)
			end
		end
		for _, fn in ipairs({ "GetIdleSwayOffset", "GetMovementSwayOffset" }) do
			local orig = GC[fn]
			if type(orig) == "function" then
				patchMethod(GC, fn, function(self, ...)
					if cfg.noSway then
						return CFrame.new()
					end
					return orig(self, ...)
				end)
			end
		end
	end)

	pcall(function()
		local CC = require(RS.Modules.Client.Controllers.CameraController)
		if type(CC) == "table" then
			for _, fn in ipairs({ "Recoil", "BoomKick" }) do
				local orig = CC[fn]
				if type(orig) == "function" then
					patchMethod(CC, fn, function(...)
						if cfg.noRecoil then
							return
						end
						return orig(...)
					end)
				end
			end
		end
	end)

	pcall(function()
		local TC = require(RS.Modules.Client.Controllers.ThrowableController)
		if type(TC) == "table" and type(TC.GetAmmo) == "function" then
			local orig = TC.GetAmmo
			patchMethod(TC, "GetAmmo", function(...)
				if cfg.infThrow then
					return 99
				end
				return orig(...)
			end)
		end
	end)
end
local ZERO = Vector3.new(0, 0, 0)
local function rest(category, spring)
	if type(spring) ~= "table" then
		return
	end
	for _, key in ipairs({ "t", "p" }) do
		local value = spring[key]
		if typeof(value) == "Vector3" then
			patches.Write(category, spring, key, ZERO)
		elseif type(value) == "number" then
			patches.Write(category, spring, key, 0)
		end
	end
end

context.Connect(RunService.RenderStepped, function()
	if gunObj then
		if cfg.noRecoil then
			for k, v in pairs(gunObj) do
				if
					type(k) == "string"
					and type(v) == "table"
					and (
						k:find("Recoil")
						or k:find("Kick")
						or k:find("FireDrift")
					)
				then
					rest("noRecoil", v)
				end
			end
		end
		if cfg.noSway then
			for _, nm in ipairs(SWAY_SPRINGS) do
				rest("noSway", gunObj[nm])
			end
			patches.Write("noSway", gunObj, "WalkSwayX", 0)
			patches.Write("noSway", gunObj, "WalkSwayY", 0)
		end
	end
	if camCtrl then
		if cfg.noShake then
			for k, v in pairs(camCtrl) do
				local lk = type(k) == "string" and k:lower() or ""
				if
					type(v) == "table"
					and (
						lk:find("shake")
						or lk:find("sway")
						or lk:find("bob")
						or lk:find("breath")
					)
				then
					rest("noShake", v)
				end
			end
		end
		if cfg.noRecoil then
			for k, v in pairs(camCtrl) do
				if
					type(k) == "string"
					and type(v) == "table"
					and (k:lower():find("recoil"))
				then
					rest("noRecoil", v)
				end
			end
		end
	end
end)

context.Connect(RunService.Heartbeat, function()
	if not localGun then
		return
	end
	if cfg.infAmmo and type(localGun.MaxMagSize) == "number" then
		patches.Write("infAmmo", localGun, "MagAmmo", localGun.MaxMagSize + 1)
	end
	if cfg.noReload then
		patches.Write("noReload", localGun, "IsReloading", false)
	end
	if cfg.fullAuto or cfg.rapid then
		patches.Write("fireMode", localGun, "FireMode", "auto")
	end
	if cfg.rapid then
		patches.Write("rapid", localGun, "CanFire", true)
	end
	if cfg.infReserve and localGun._magazines then
		for i = 1, #localGun._magazines do
			patches.Write(
				"infReserve",
				localGun._magazines,
				i,
				localGun.MaxMagSize
			)
		end
	end
end)

context.RegisterCleanup(function()
	for key, value in pairs(cfg) do
		if type(value) == "boolean" then
			cfg[key] = false
		end
	end
	patches.Clear()
	hideAll()
	hideChams(1)
	for _, objects in ipairs(pool) do
		for _, object in pairs(objects) do
			pcall(function()
				object:Remove()
			end)
		end
	end
	if fovCircle then
		pcall(function()
			fovCircle:Remove()
		end)
	end
	if chamsHolder then
		chamsHolder:Destroy()
	end
	table.clear(cachedTargets)
end)
local window = context.Adapter:CreateWindow({})
local visuals = window:CreateTab({ name = "Visuals & aim", icon = "target" })
visuals:CreateText({
	name = "TTK Testing / Gab",
	text = "All master switches start off. Hold RMB to aim; touch users can explicitly enable Touch aim. Drawing overlays require executor Drawing; native Highlights do not.",
})
local function toggle(tab, key, name, weapon)
	tab:CreateToggle({
		name = name,
		flag = key,
		value = cfg[key],
		callback = function(value)
			cfg[key] = value
			if not value then
				patches.Restore(key)
			end
			if key == "rapid" or key == "fullAuto" then
				if not cfg.rapid and not cfg.fullAuto then
					patches.Restore("fireMode")
				end
			end
			if key == "esp" and not value then
				hideAll()
				hideChams(1)
			end
			if weapon and value then
				installHooks()
			end
		end,
	})
end
visuals:CreateSection({ name = "Visual overlays" })
toggle(visuals, "esp", "Enable ESP")
toggle(visuals, "box", "Boxes")
toggle(visuals, "names", "Player names")
toggle(visuals, "dist", "Distance")
toggle(visuals, "head", "Head markers")
toggle(visuals, "chams", "Through-wall Highlights")
toggle(visuals, "enemyOnly", "Enemies only")
visuals:CreateSection({ name = "Centered aim" })
toggle(visuals, "aim", "Enable aim / hold RMB")
toggle(visuals, "aimHead", "Target head")
toggle(visuals, "showFov", "Show centered FOV")
visuals:CreateToggle({
	name = "Touch aim / continuous while enabled",
	value = false,
	callback = function(value)
		touchAim = value
	end,
})
visuals:CreateSlider({
	name = "FOV radius / pixels",
	range = { 20, 600 },
	value = 130,
	increment = 1,
	callback = function(value)
		cfg.aimFov = value
	end,
})
visuals:CreateSlider({
	name = "Aim strength",
	range = { 6, 100 },
	value = 100,
	increment = 1,
	callback = function(value)
		cfg.aimSmooth = 1 - value / 100
	end,
})
local weapons = window:CreateTab({ name = "Weapons", icon = "target" })
local discovery = weapons:CreateText({
	name = "Explicit discovery",
	text = "Enable a weapon option to install guarded module wrappers. Equip a weapon, then scan for firearm/camera tables. No automatic GC scan or endless discovery worker.",
})
local nextScan = 0
weapons:CreateButton({
	name = "Scan equipped weapon / camera",
	callback = function()
		if os.clock() < nextScan then
			return
		end
		nextScan = os.clock() + 5
		installHooks()
		local ok, result = pcall(discover)
		discovery:Set({
			Title = "Discovery",
			Desc = ok and result or tostring(result),
		})
	end,
})
toggle(weapons, "noSpread", "No spread", true)
toggle(weapons, "noRecoil", "No recoil / kick", true)
toggle(weapons, "noShake", "No camera shake", true)
toggle(weapons, "noSway", "No sway", true)
toggle(weapons, "infAmmo", "Infinite magazine", true)
toggle(weapons, "infReserve", "Infinite reserve", true)
toggle(weapons, "noReload", "No reload", true)
toggle(weapons, "rapid", "Rapid fire", true)
toggle(weapons, "fullAuto", "Force full auto", true)
toggle(weapons, "infThrow", "Infinite throwables", true)
weapons:CreateSlider({
	name = "Fire delay / seconds",
	range = { 0.01, 0.2 },
	value = 0.05,
	increment = 0.01,
	callback = function(value)
		cfg.rapidRate = value
	end,
})
weapons:CreateText({
	name = "Instant ADS intentionally unavailable",
	text = "The supplied spring setter has no known reversible getter. Nullx11 leaves it unchanged instead of permanently modifying an unknown spring. Client edits do not guarantee server acceptance.",
})
weapons:CreateButton({
	name = "Unload this game workspace",
	callback = function()
		context.Library:Unload()
	end,
})
return window
