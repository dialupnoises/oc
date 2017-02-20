local healthArc, batteryArc, healthClipPoly, batteryClipPoly
local ammoClipPolySecondary, ammoClipPolyPrimary
local ammoArcPrimary, ammoArcSecondary, ammoArcBoth
local lastUpdatedScreenH
local healthGlowTimer = 0
local healthGlowMax = 0.3

local ammoTypeModels = {
	ar2 = "models/items/combine_rifle_cartridge01.mdl",
	[1] = "models/items/combine_rifle_cartridge01.mdl",
	pistol = "models/items/boxsrounds.mdl",
	[3] = "models/items/boxsrounds.mdl",
	smg1 = "models/items/boxmrounds.mdl",
	[4] = "models/items/boxmrounds.mdl",
	revolver = "models/items/357ammo.mdl",
	[5] = "models/items/357ammo.mdl",
	crossbow = "models/items/crossbowrounds.mdl",
	[6] = "models/items/crossbowrounds.mdl",
	shotgun = "models/items/boxbuckshot.mdl",
	[7] = "models/items/boxbuckshot.mdl",
	-- 8 = rpg
	[8] = "models/weapons/w_missile_launch.mdl",
	grenade = "models/items/grenadeammo.mdl",
	[10] = "models/items/grenadeammo.mdl",
	-- 11 = slam
	[11] = "models/weapons/c_slam.mdl",
	MedkitHeal = "models/weapons/w_medkit.mdl"
}

local modelPositions = {
	["models/items/boxsrounds.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-40, 0, 45), fov = 30 },
	["models/items/boxmrounds.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-39, 0, 45), fov = 35 },
	["models/items/combine_rifle_cartridge01.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-41, 0, 40), fov = 15 },
	["models/items/357ammo.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-37, 0, 40), fov = 20 },
	["models/items/crossbowrounds.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-40, -1, 40), fov = 25 },
	["models/weapons/w_missile_launch.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-40, 0, 40), fov = 20 },
	["models/items/grenadeammo.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-40, 0, 40), fov = 15 },
	["models/items/boxbuckshot.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-35, 0, 40), fov = 25 },
	["models/weapons/c_slam.mdl"] = { angle = Angle(50, -145, 0), pos = Vector(38, 25, 76), fov = 7 },
	["models/weapons/w_medkit.mdl"] = { angle = Angle(45, 0, 0), pos = Vector(-45, 0, 45), fov = 15 }
}

-- if none found, use smg box
local defaultAmmoType = 3 
local defaultPosition = "models/items/boxmrounds.mdl"

function findAmmoTypeModel(swep)
	if ammoTypeModels[swep:GetPrimaryAmmoType()] ~= nil then
		return ammoTypeModels[swep:GetPrimaryAmmoType()]
	elseif ammoTypeModels[swep:GetSecondaryAmmoType()] ~= nil then
		return ammoTypeModels[swep:GetSecondaryAmmoType()]
	elseif ammoTypeModels[game.GetAmmoName(swep:GetSecondaryAmmoType())] then
		return ammoTypeModels[game.GetAmmoName(swep:GetSecondaryAmmoType())]
	elseif ammoTypeModels[swep:GetHoldType()] ~= nil then
		return ammoTypeModels[swep:GetHoldType()]
	else
		return ammoTypeModels[defaultAmmoType]
	end
end

function applyPositionSettings(model, panel)
	local settings = modelPositions[model]
	if not settings then settings = modelPositions[defaultPosition] end
	panel:SetFOV(settings.fov)
	panel:SetCamPos(settings.pos)
	panel:SetLookAng(settings.angle)
end

function drawHud()
	if healthGlowTimer > 0 then
		healthGlowTimer = math.max(0, healthGlowTimer - FrameTime())
	end
	
	if healthArc == nil or ScrH() ~= lastUpdatedScreenH then 
		healthArc = surface.PrecacheArc(80, ScrH() - 80, 40, 5, 0, 360, 1)
		batteryArc = surface.PrecacheArc(380, ScrH() - 80, 40, 5, 0, 360, 1)
		ammoArcPrimary = surface.PrecacheArc(ScrW() - 260, ScrH() - 80, 40, 5, 0, 360, 1)
		ammoArcSecondary = surface.PrecacheArc(ScrW() - 180, ScrH() - 80, 40, 5, 0, 360, 1)
		ammoArcBoth = surface.PrecacheArc(ScrW() - 380, ScrH() - 80, 40, 5, 0, 360, 1)
		healthClipPoly = surface.CreateHUDClippingPoly(80, ScrH() - 80, 40, 40, 1)
		batteryClipPoly = surface.CreateHUDClippingPoly(380, ScrH() - 80, 40, 40, 1)
		ammoClipPolyPrimary = surface.CreateHUDClippingPoly(ScrW() - 260, ScrH() - 80, 40, 40, 1)
		ammoClipPolySecondary = surface.CreateHUDClippingPoly(ScrW() - 380, ScrH() - 80, 40, 40, 1)
		healthModelPanel:SetPos(40, ScrH() - 120)
		batteryModelPanel:SetPos(340, ScrH() - 120)
		lastUpdatedScreenH = ScrH()
	end

	local activeWeapon = LocalPlayer():GetActiveWeapon()
	local drawAmmo = false
	local drawPrimary = false
	local drawSecondary = false
	local ammoX = ScrW() - 420
	if IsValid(activeWeapon) and (activeWeapon:GetPrimaryAmmoType() ~= -1 or activeWeapon:GetSecondaryAmmoType() ~= -1) then
		local model = findAmmoTypeModel(activeWeapon)
		if ammoModelPanel:GetModel() ~= model then
			ammoModelPanel:SetModel(model)
			applyPositionSettings(model, ammoModelPanel)
		end

		if not ammoModelPanel:IsVisible() then
			ammoModelPanel:Show()
		end

		drawAmmo = true
		drawPrimary = activeWeapon:GetPrimaryAmmoType() ~= -1
		drawSecondary = activeWeapon:GetSecondaryAmmoType() ~= -1

		if not drawPrimary then
			ammoX = ScrW() - 220
		elseif not drawSecondary then
			ammoX = ScrW() - 300
		end

		ammoModelPanel:SetPos(ammoX, ScrH() - 120)
	else
		ammoModelPanel:Hide()
	end

	-- reset surface texture
	surface.SetTexture(-1)

	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawArc(healthClipPoly)
	surface.DrawArc(batteryClipPoly)
	if drawPrimary and not drawSecondary then 
		surface.DrawArc(ammoClipPolyPrimary)
	elseif drawPrimary and drawSecondary then
		surface.DrawArc(ammoClipPolySecondary)
	end

	surface.SetDrawColor(Color(0, 0, 0))
	surface.DrawArc(healthArc)
	surface.DrawArc(batteryArc)
	if drawPrimary and drawSecondary then
		surface.DrawArc(ammoArcBoth)
	elseif drawSecondary then
		surface.DrawArc(ammoArcSecondary)
	elseif drawPrimary then
		surface.DrawArc(ammoArcPrimary)
	end

	draw.RoundedBoxEx(10, 120, ScrH() - 120, 120, 80, Color(0, 0, 0, 200), false, true, false, true)
	draw.RoundedBoxEx(10, 420, ScrH() - 120, 120, 80, Color(0, 0, 0, 200), false, true, false, true)

	if drawAmmo then
		if drawPrimary then
			draw.RoundedBoxEx(10, ammoX + 80, ScrH() - 120, 200, 80, Color(0, 0, 0, 200), false, true, false, true)
		end
		
		if drawSecondary then
			draw.RoundedBox(10, ScrW() - 120, ScrH() - 120, 100, 80, Color(0, 0, 0, 200))
		end
	end

	local function drawStringCentered(x, y, height, text, color, centerX, width)
		local w, h = surface.GetTextSize(text)
		if centerX then
			x = x + (width / 2) - (w / 2)
		end
		surface.SetTextColor(color)
		surface.SetTextPos(x, y + (height / 2) - (h / 2))
		surface.DrawText(text)
	end

	if OC.Lives.isEnabled() then
		surface.SetFont("ObsidianSmall")
		surface.SetTextColor(colorLib.lighten(OC.Color, 0.1))
		local w, h = surface.GetTextSize("LIVES")
		surface.SetTextPos(245 + (90 / 2) - (w / 2), ScrH() - 115)
		surface.DrawText("LIVES")

		draw.RoundedBox(10, 245, ScrH() - 120, 90, 80, Color(0, 0, 0, 200))

		surface.SetFont("ObsidianXL")
		local lives = OC.Lives.getLives(LocalPlayer())
		local livesText = tostring(lives)
		if lives < 0 then
			livesText = "-"
		end
		drawStringCentered(245, ScrH() - 115 + h, 80 - 5 - h, livesText, OC.LightBlueColor, true, 90)
	end

	surface.SetFont("ObsidianXL")
	local healthColor = colorLib.mult(OC.LightBlueColor, 0.5 + 0.5 * (1 - healthGlowTimer / healthGlowMax))
	drawStringCentered(130, ScrH() - 120, 80, math.max(0, LocalPlayer():Health()), healthColor)
	drawStringCentered(430, ScrH() - 120, 80, LocalPlayer():Armor(), OC.LightBlueColor)

	if drawAmmo then
		local primaryAmmoCount = "-"
		local primaryAmmoClip = "-"
		local secondaryAmmoCount = "-"
		if activeWeapon:GetPrimaryAmmoType() ~= -1 then
			primaryAmmoCount = tostring(activeWeapon:Clip1())
			primaryAmmoClip = tostring(math.min(9999, LocalPlayer():GetAmmoCount(activeWeapon:GetPrimaryAmmoType())))
			if activeWeapon:Clip1() == -1 then
				primaryAmmoCount = primaryAmmoClip
				primaryAmmoClip = "-"
			end
		end

		if activeWeapon:GetSecondaryAmmoType() ~= -1 then
			secondaryAmmoCount = tostring(activeWeapon:Clip2())
		end

		if drawSecondary then
			drawStringCentered(ScrW() - 120, ScrH() - 120, 80, secondaryAmmoCount, OC.LightBlueColor, true, 100)
		end
		
		if drawPrimary then
			drawStringCentered(ammoX + 110, ScrH() - 120, 80, primaryAmmoCount, OC.LightBlueColor)
			surface.SetFont("ObsidianLarge")
			drawStringCentered(ammoX + 200, ScrH() - 120, 80, primaryAmmoClip, OC.LightBlueColor)
		end
	end
end

local camPos = Vector(-5, 0, 70)
local camAng = Angle(80, 0, 0)
function createHudDerma()
	healthModelPanel = vgui.Create("DModelPanel")
	healthModelPanel:SetPos(40, ScrH() - 120)
	healthModelPanel:SetSize(80, 80)
	healthModelPanel:SetModel("models/items/healthkit.mdl")
	healthModelPanel:SetCamPos(Vector(5, 0, 80))
	healthModelPanel:SetLookAng(Angle(90, 0, 0))
	healthModelPanel:SetFOV(20)
	function healthModelPanel:LayoutEntity(ent) end

	batteryModelPanel = vgui.Create("DModelPanel")
	batteryModelPanel:SetPos(340, ScrH() - 120)
	batteryModelPanel:SetSize(80, 80)
	batteryModelPanel:SetModel("models/items/battery.mdl")
	batteryModelPanel:SetLookAng(Angle(0, 180, 0))
	batteryModelPanel:SetCamPos(Vector(80, 0, 5))
	batteryModelPanel:SetFOV(12)
	function batteryModelPanel:LayoutEntity(ent) end

	ammoModelPanel = vgui.Create("DModelPanel")
	ammoModelPanel:SetPos(ScrW() - 420, ScrH() - 120)
	ammoModelPanel:SetSize(80, 80)
	ammoModelPanel:SetModel("models/items/boxmrounds.mdl")
	ammoModelPanel:SetLookAng(Angle(45, 0, 0))
	ammoModelPanel:SetCamPos(Vector(-39, 0, 45))
	ammoModelPanel:SetFOV(30)
	function ammoModelPanel:LayoutEntity(ent)
		ent:SetAngles(Angle(0, 225, 0))
	end
end

hook.Add("InitPostEntity", "oc_hud_init", createHudDerma)
hook.Add("HUDPaint", "oc_hud_draw", drawHud)

local hudShouldNotDraw = {"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}
hook.Add("HUDShouldDraw", "oc_hud_hide", function(name)
	if table.HasValue(hudShouldNotDraw, name) then return false end
end)

net.Receive("player_damaged_ui", function(len, ply)
	healthGlowTimer = healthGlowMax
end)