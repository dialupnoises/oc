--Variables that are used on both client and server
SWEP.Category               = ""
SWEP.Gun                    = ""
SWEP.Author                 = "Generic Default, Worshipper, Clavus, and Bob"
SWEP.Contact                = ""
SWEP.Purpose                = ""
SWEP.Instructions           = ""
SWEP.MuzzleAttachment       = "1"          -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.DrawCrosshair          = true         -- Hell no, crosshairs r 4 nubz
SWEP.ViewModelFOV           = 65           -- How big the gun will look
SWEP.ViewModelFlip          = true         -- True for CSS models, False for HL2 models
 
SWEP.Spawnable              = false
SWEP.AdminSpawnable         = false
 
SWEP.Primary.Sound          = Sound("")    -- Sound of the gun
SWEP.Primary.Round          = ("")         -- What kind of bullet?
SWEP.Primary.Cone           = 0.2          -- Accuracy of NPCs
SWEP.Primary.Recoil         = 10
SWEP.Primary.Damage         = 10
SWEP.Primary.Spread         = .01          --define from-the-hip accuracy (1 is terrible, .0001 is exact)
SWEP.Primary.NumShots       = 1
SWEP.Primary.RPM            = 0            -- This is in Rounds Per Minute
SWEP.Primary.ClipSize       = 0            -- Size of a clip
SWEP.Primary.DefaultClip    = 0            -- Default number of bullets in a clip
SWEP.Primary.KickUp         = 0            -- Maximum up recoil (rise)
SWEP.Primary.KickDown       = 0            -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal = 0            -- Maximum side recoil (koolaid)
SWEP.Primary.Automatic      = true         -- Automatic/Semi Auto
SWEP.Primary.Ammo           = "none"       -- What kind of ammo

SWEP.Secondary.Ammo         = ""
SWEP.Secondary.IronFOV = 65

SWEP.BoltAction     = false
SWEP.Scoped         = false
SWEP.ShellTime      = .35
SWEP.Tracer         = 0
SWEP.CanBeSilenced  = false
SWEP.Silenced       = false
SWEP.NextSilence    = 0
SWEP.SelectiveFire  = false
SWEP.NextFireSelect = 0
SWEP.OrigCrossHair  = true

SWEP.NPCMinBurst = 3
SWEP.NPCMaxBurst = 10
SWEP.NPCFireRate = 1 / ((SWEP.Primary.RPM or 1)/ 60)
 
local PainMulti = 1

SWEP.IronSightsPos = Vector(2.4537, 1.0923, 0.2696)
SWEP.IronSightsAng = Vector(0.0186, -0.0547, 0)
 
SWEP.VElements = {}
SWEP.WElements = {}
 
function SWEP:Initialize()
	self.Reloadaftershoot = 0          -- Can't reload when firing
	self:SetHoldType(self.HoldType)
	self.OrigCrossHair = self.DrawCrosshair
	if SERVER and self.Owner:IsNPC() then
		MsgN(self.PrintName)
		self:SetNPCMinBurst(SWEP.NPCMinBurst)
		self:SetNPCMaxBurst(SWEP.NPCMaxBurst)
		self:SetNPCFireRate(SWEP.NPCFireRate)
	end

	if CLIENT then
		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels

		-- init view model bone build function
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
			if self.Owner:Alive() then
				local vm = self.Owner:GetViewModel()
				if IsValid(vm) then
					self:ResetBonePositions(vm)
					-- Init viewmodel visibility
					if (self.ShowViewModel == nil or self.ShowViewModel) then
						vm:SetColor(Color(255,255,255,255))
					else
						-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
						vm:SetMaterial("Debug/hsv")                    
					end
				end
			end
		end

		local oldpath = "vgui/hud/name" -- the path goes here
		local newpath = string.gsub(oldpath, "name", self.Gun)
		self.WepSelectIcon = surface.GetTextureID(newpath)
	end
end
 
function SWEP:Equip()
	self:SetHoldType(self.HoldType)
end
 
function SWEP:Deploy()
	self:SetIronsights(false, self.Owner)          -- Set the ironsight false
	self:SetHoldType(self.HoldType)
   
	if self.Silenced then
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
	else
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	end

	self.Weapon:SetNWBool("Reloading", false)
   
	if not self.Owner:IsNPC() and self.Owner ~= nil then
		if self.ResetSights and self.Owner:GetViewModel() ~= nil then
			self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
	end
	return true
end
 
function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) and not self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	return true
end
 
function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and not self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end
 
function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1
end
 
function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)
end
 
function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
		if not self.Owner:KeyDown(IN_SPEED) and not self.Owner:KeyDown(IN_RELOAD) then
			self:ShootBulletInformation()
			self.Weapon:TakePrimaryAmmo(1)
			   
			if self.Silenced then
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED )
				self.Weapon:EmitSound(self.Primary.SilencedSound)
			else
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Weapon:EmitSound(self.Primary.Sound)
			end    
		   
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetOrigin(self.Owner:GetShootPos())
			fx:SetNormal(self.Owner:GetAimVector())
			fx:SetAttachment(self.MuzzleAttachment)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Owner:MuzzleFlash()
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
			self:CheckWeaponsAndAmmo()
			if self.BoltAction then self:BoltBack() end
		end
	elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
	end
end
 
function SWEP:CheckWeaponsAndAmmo()
	if SERVER and self.Weapon ~= nil and (GetConVar("M9KWeaponStrip"):GetBool()) then
		if self.Weapon:Clip1() == 0 and self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
			timer.Simple(.1, function() 
				if SERVER then 
					if not IsValid(self) then return end
					if self.Owner == nil then return end
					self.Owner:StripWeapon(self.Gun)
				end 
			end)
		end
	end
end
 
 
--[[
   Name: SWEP:ShootBulletInformation()
   Desc: This func add the damage, the recoil, the number of shots and the cone on the bullet.
]]--
function SWEP:ShootBulletInformation()
 
	local CurrentDamage
	local CurrentRecoil
	local CurrentCone
	local basedamage
	   
	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
		CurrentCone = self.Primary.IronAccuracy
	else
		CurrentCone = self.Primary.Spread
	end
	
	local damagedice = math.Rand(.85,1.3)
	   
	basedamage = PainMulti * self.Primary.Damage
	CurrentDamage = basedamage * damagedice
	CurrentRecoil = self.Primary.Recoil
	   
	--Player is aiming
	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
		self:ShootBullet(CurrentDamage, CurrentRecoil / 6, self.Primary.NumShots, CurrentCone)
	--Player is not aiming
	else
		self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, CurrentCone)
	end
	   
end
 
--[[
   Name: SWEP:ShootBullet()
   Desc: A convenience func to shoot bullets.
]]--
local TracerName = "Tracer"
 
function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)
	num_bullets = num_bullets or 1
	aimcone     = aimcone or 0
 
	self:ShootEffects()
 
	if self.Tracer == 1 then
		TracerName = "Ar2Tracer"
	elseif self.Tracer == 2 then
		TracerName = "AirboatGunHeavyTracer"
	else
		TracerName = "Tracer"
	end
	   
	local bullet = {}
	bullet.Num        = num_bullets
	bullet.Src        = self.Owner:GetShootPos()          -- Source
	bullet.Dir        = self.Owner:GetAimVector()          -- Dir of bullet
	bullet.Spread     = Vector(aimcone, aimcone, 0)          -- Aim Cone
	bullet.Tracer     = 3          -- Show a tracer on every x bullets
	bullet.TracerName = TracerName
	bullet.Force      = damage * 0.25          -- Amount of force to give to phys objects
	bullet.Damage     = damage

	self.Owner:FireBullets(bullet)
 
	local anglo1 = Angle(math.Rand(-self.Primary.KickDown,-self.Primary.KickUp), math.Rand(-self.Primary.KickHorizontal,self.Primary.KickHorizontal), 0)
	self.Owner:ViewPunch(anglo1)
	   
	if SERVER and game.SinglePlayer() and not self.Owner:IsNPC()  then
		local offlineeyes = self.Owner:EyeAngles()
		offlineeyes.pitch = offlineeyes.pitch + anglo1.pitch
		offlineeyes.yaw = offlineeyes.yaw + anglo1.yaw
	end
	   
	if CLIENT and not game.SinglePlayer() and not self.Owner:IsNPC() then
		local anglo = Angle(math.Rand(-self.Primary.KickDown,-self.Primary.KickUp), math.Rand(-self.Primary.KickHorizontal,self.Primary.KickHorizontal), 0)
 
		local eyes = self.Owner:EyeAngles()
		eyes.pitch = eyes.pitch + (anglo.pitch/3)
		eyes.yaw = eyes.yaw + (anglo.yaw/3)
	end
 
end
 
function SWEP:SecondaryAttack()
	return false
end
 
function SWEP:Reload()
	if not IsValid(self) then return end 
	if not IsValid(self.Owner) then return end
	   
	if self.Owner:IsNPC() then
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		return 
	end
	   
	if self.Owner:KeyDown(IN_USE) then return end
	   
	if self.Silenced then
		self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
	else
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	end
	   
	if not self.Owner:IsNPC() then
		if self.Owner:GetViewModel() == nil then 
			self.ResetSights = CurTime() + 3 
		else
			self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
	end
	   
	if SERVER and self.Weapon ~= nil then
		if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and not self.Owner:IsNPC() then
			--When the current clip < full clip and the rest of your ammo > 0, then
			self.Owner:SetFOV( 0, 0.3 )
			--Zoom = 0
			self:SetIronsights(false)
			--Set the ironsight to false
			self.Weapon:SetNWBool("Reloading", true)
		end

		local waitdammit = (self.Owner:GetViewModel():SequenceDuration())
		timer.Simple(
			waitdammit + .1,
			function()
				if self.Weapon == nil then return end
				self.Weapon:SetNWBool("Reloading", false)
				if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then
					if CLIENT then return end
					if self.Scoped == false then
						self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
						self.IronSightsPos = self.SightsPos          -- Bring it up
						self.IronSightsAng = self.SightsAng          -- Bring it up
						self:SetIronsights(true, self.Owner)
						self.DrawCrosshair = false
					else 
						return 
					end
				elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then
					if self.Weapon:GetNextPrimaryFire() <= (CurTime() + .03) then
						self.Weapon:SetNextPrimaryFire(CurTime()+0.3)          -- Make it so you can't shoot for another quarter second
					end
					self.IronSightsPos = self.RunSightsPos          -- Hold it down
					self.IronSightsAng = self.RunSightsAng          -- Hold it down
					self:SetIronsights(true, self.Owner)          -- Set the ironsight true
					self.Owner:SetFOV( 0, 0.3 )
				else 
					return 
				end
			end)
	end
end
 
function SWEP:PostReloadScopeCheck()
	if self.Weapon == nil then return end
	self.Weapon:SetNWBool("Reloading", false)
	if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then
		if CLIENT then return end
		if self.Scoped == false then
			self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
			self.IronSightsPos = self.SightsPos          -- Bring it up
			self.IronSightsAng = self.SightsAng          -- Bring it up
			self:SetIronsights(true, self.Owner)
			self.DrawCrosshair = false
		else 
			return 
		end
	elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then
		if self.Weapon:GetNextPrimaryFire() <= (CurTime() + .03) then
			self.Weapon:SetNextPrimaryFire(CurTime()+0.3)          -- Make it so you can't shoot for another quarter second
		end
		self.IronSightsPos = self.RunSightsPos          -- Hold it down
		self.IronSightsAng = self.RunSightsAng          -- Hold it down
		self:SetIronsights(true, self.Owner)          -- Set the ironsight true
		self.Owner:SetFOV( 0, 0.3 )
	else 
		return
	end
end
 
function SWEP:Silencer()
	if self.NextSilence > CurTime() then return end
	   
	if self.Weapon ~= nil then
		self.Owner:SetFOV( 0, 0.3 )
		self:SetIronsights(false)
		self.Weapon:SetNWBool("Reloading", true) -- i know we're not reloading but it works
	end
	   
	if self.Silenced then
		self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
		self.Silenced = false
	elseif not self.Silenced then
		self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
		self.Silenced = true
	end
	   
	siltimer = CurTime() + (self.Owner:GetViewModel():SequenceDuration()) + 0.1
	if self.Weapon:GetNextPrimaryFire() <= siltimer then
		self.Weapon:SetNextPrimaryFire(siltimer)
	end
	self.NextSilence = siltimer
	   
	timer.Simple( 
		self.Owner:GetViewModel():SequenceDuration() + 0.1,
		function()
			if self.Weapon ~= nil then
				self.Weapon:SetNWBool("Reloading", false)
				if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then
					if CLIENT then return end
					if self.Scoped == false then
						self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
						self.IronSightsPos = self.SightsPos          -- Bring it up
						self.IronSightsAng = self.SightsAng          -- Bring it up
						self:SetIronsights(true, self.Owner)
						self.DrawCrosshair = false
					else 
						return 
					end
				elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then
					if self.Weapon:GetNextPrimaryFire() <= (CurTime()+0.3) then
						self.Weapon:SetNextPrimaryFire(CurTime()+0.3)          -- Make it so you can't shoot for another quarter second
					end
					self.IronSightsPos = self.RunSightsPos          -- Hold it down
					self.IronSightsAng = self.RunSightsAng          -- Hold it down
					self:SetIronsights(true, self.Owner)          -- Set the ironsight true
					self.Owner:SetFOV( 0, 0.3 )
				else 
					return 
				end
			end
		end)
 
end
 
function SWEP:SelectFireMode()
	if self.Primary.Automatic then
		self.Primary.Automatic = false
		self.NextFireSelect = CurTime() + .5
		if CLIENT then
			self.Owner:PrintMessage(HUD_PRINTTALK, "Semi-automatic selected.")
		end
		self.Weapon:EmitSound("Weapon_AR2.Empty")
	else
		self.Primary.Automatic = true
		self.NextFireSelect = CurTime() + .5
		if CLIENT then
			self.Owner:PrintMessage(HUD_PRINTTALK, "Automatic selected.")
		end
		self.Weapon:EmitSound("Weapon_AR2.Empty")
	end
end
 
 
--[[
IronSight
]]--
function SWEP:IronSight()
	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
 
	if not self.Owner:IsNPC() then
		if self.ResetSights and CurTime() >= self.ResetSights then
			self.ResetSights = nil
			   
			if self.Silenced then
				self:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
			else
				self:SendWeaponAnim(ACT_VM_IDLE)
			end
		end 
	end
	   
	if self.CanBeSilenced and self.NextSilence < CurTime() then
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_ATTACK2) then
			self:Silencer()
		end
	end
	   
	if self.SelectiveFire and self.NextFireSelect < CurTime() and not (self.Weapon:GetNWBool("Reloading")) then
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_RELOAD) then
			self:SelectFireMode()
		end
	end    
	   
	if self.Owner:KeyPressed(IN_SPEED) and not (self.Weapon:GetNWBool("Reloading")) then          -- If you are running
		if self.Weapon:GetNextPrimaryFire() <= (CurTime()+0.3) then
			self.Weapon:SetNextPrimaryFire(CurTime()+0.3)          -- Make it so you can't shoot for another quarter second
		end
		self.IronSightsPos = self.RunSightsPos          -- Hold it down
		self.IronSightsAng = self.RunSightsAng          -- Hold it down
		self:SetIronsights(true, self.Owner)          -- Set the ironsight true
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = false
	end                                                            
 
	if self.Owner:KeyReleased (IN_SPEED) then          -- If you release run then
		self:SetIronsights(false, self.Owner)          -- Set the ironsight true
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = self.OrigCrossHair
	end          -- Shoulder the gun
 

	if not self.Owner:KeyDown(IN_USE) and not self.Owner:KeyDown(IN_SPEED) then
	--If the key E (Use Key) is not pressed, then
 
		if self.Owner:KeyPressed(IN_ATTACK2) and not (self.Weapon:GetNWBool("Reloading")) then
			self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
			self.IronSightsPos = self.SightsPos          -- Bring it up
			self.IronSightsAng = self.SightsAng          -- Bring it up
			self:SetIronsights(true, self.Owner)
			self.DrawCrosshair = false
			--Set the ironsight true
 
			if CLIENT then return end
		end
	end
 
	if self.Owner:KeyReleased(IN_ATTACK2) and not self.Owner:KeyDown(IN_USE) and not self.Owner:KeyDown(IN_SPEED) then
	--If the right click is released, then
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = self.OrigCrossHair
		self:SetIronsights(false, self.Owner)
		--Set the ironsight false
 
		if CLIENT then return end
	end

	if self.Owner:KeyDown(IN_ATTACK2) and not self.Owner:KeyDown(IN_USE) and not self.Owner:KeyDown(IN_SPEED) then
	self.SwayScale  = 0.05
	self.BobScale   = 0.05
	else
	self.SwayScale  = 1.0
	self.BobScale   = 1.0
	end
end
 
--[[
Think
]]--
function SWEP:Think()
	self:IronSight()
end
 
--[[
GetViewModelPosition
]]--
local IRONSIGHT_TIME = 0.3
--Time to enter in the ironsight mod
 
function SWEP:GetViewModelPosition(pos, ang)
	if (not self.IronSightsPos) then return pos, ang end
 
	local bIron = self.Weapon:GetNWBool("M9K_Ironsights")
 
	if (bIron ~= self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()
	end
 
	local fIronTime = self.fIronTime or 0
 
	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end
 
	local Mul = 1.0
 
	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
 
		if not bIron then 
			Mul = 1 - Mul 
		end
	end
 
	local Offset = self.IronSightsPos
 
	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(),   self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(),      self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
	end
 
	local Right     = ang:Right()
	local Up        = ang:Up()
	local Forward   = ang:Forward()
 
	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
 
	return pos, ang
end
 
--[[
SetIronsights
]]--
function SWEP:SetIronsights(b)
	self.Weapon:SetNWBool("M9K_Ironsights", b)
end
 
function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("M9K_Ironsights")
end
 
 
if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then return end
		if (not self.VElements) then return end
		   
		self:UpdateBonePositions(vm)
 
		if (not self.vRenderOrder) then
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}
			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
		end
 
		for k, name in ipairs( self.vRenderOrder ) do
		   
			local v = self.VElements[name]
			if (not v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			   
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			   
			if (not v.bone) then continue end
			   
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			   
			if (not pos) then continue end
			   
			if (v.type == "Model" and IsValid(model)) then
 
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
 
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				   
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				   
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				   
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				   
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				   
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				   
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				   
			elseif (v.type == "Sprite" and sprite) then
				   
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				   
			elseif (v.type == "Quad" and v.draw_func) then
				   
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				   
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
 
			end
			   
		end
		   
	end
 
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		   
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		   
		if (not self.WElements) then return end
		   
		if (not self.wRenderOrder) then
 
			self.wRenderOrder = {}
 
			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
 
		end
		   
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end
		   
		for k, name in pairs( self.wRenderOrder ) do
		   
			local v = self.WElements[name]
			if (not v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			   
			local pos, ang
			   
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			   
			if (not pos) then continue end
			   
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			   
			if (v.type == "Model" and IsValid(model)) then
 
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
 
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				   
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				   
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				   
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				   
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				   
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				   
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				   
			elseif (v.type == "Sprite" and sprite) then
				   
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				   
			elseif (v.type == "Quad" and v.draw_func) then
				   
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				   
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
 
			end
			   
		end
		   
	end
 
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		   
		local bone, pos, ang
		if (tab.rel and tab.rel ~= "") then
			   
			local v = basetab[tab.rel]
			   
			if (not v) then return end
			   
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			   
			if (not pos) then return end
			   
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				   
		else
		   
			bone = ent:LookupBone(bone_override or tab.bone)
 
			if (not bone) then return end
			   
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			   
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r --// Fixes mirrored models
			end
		   
		end
		   
		return pos, ang
	end
 
	function SWEP:CreateModels( tab )
 
		if (not tab) then return end
 
		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				   
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				   
			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite)
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				   
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				-- make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end
 
				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				   
			end
		end
		   
	end
	   
	local allbones
	local hasGarryFixedBoneScalingYet = false
 
	function SWEP:UpdateBonePositions(vm)
		   
		if self.ViewModelBoneMods then
			   
			if (not vm:GetBoneCount()) then return end
			   
			local loopthrough = self.ViewModelBoneMods
			if (not hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				   
				loopthrough = allbones
			end
			   
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (not bone) then continue end
				   
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (not hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				   
				s = s * ms
				   
				if vm:GetManipulateBoneScale(bone) ~= s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) ~= v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) ~= p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		   
		if (not vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		   
	end
 
	--[[
		Global utility code
	]]--
 
	-- Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	-- Does not copy entities of course, only copies their reference.
	-- WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )
 
		if (not tab) then return nil end
		   
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) --// recursion ho
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		   
		return res
		   
	end
	   
end