SWEP.PrintName = "Healer"
SWEP.Spawnable = true
SWEP.Slot = 0
SWEP.SlotPos = 5

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = 100
SWEP.Secondary.DefaultClip = 100
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "MedkitHeal"

SWEP.DropHealAmount = 25
SWEP.HealInterval = 0.2
SWEP.LastHeal = 0
SWEP.FailSound = Sound("common/wpn_denyselect.wav")
SWEP.HealSound = Sound("items/medcharge4.wav")
SWEP.HealSoundPatch = nil
SWEP.DropSound = Sound("items/medshot4.wav")

function SWEP:Initialize()
	self:SetHoldType("slam")

	if SERVER then
		timer.Create("medkit_ammo_" .. self:EntIndex(), 5, 0, function()
			if CurTime() < self.LastHeal + self.HealInterval then
				return 
			end
			
			if self:Clip2() < 100 then
				self:SetClip2(math.min(self:Clip2() + 5, 100))
			end
		end)
	else
		timer.Create("medkit_sound_" .. self:EntIndex(), self.HealInterval + 0.1, 0, function()
			timer.Stop("medkit_sound_" .. self:EntIndex())
			if self.HealSoundPatch == nil then return end
			MsgN("stopping")
			if self.HealSoundPatch:IsPlaying() then
				self.HealSoundPatch:Stop()
			end
		end)
	end
end

function SWEP:Equip(owner)
	if owner:IsPlayer() then
		local ammoType = game.GetAmmoID("MedkitHeal")
		if owner:GetAmmoCount(ammoType) <= 0 then
			owner:SetAmmo(100, ammoType)
		elseif owner:GetAmmoCount(ammoType) > 100 then
			owner:SetAmmo(100, ammoType)
		end
	end
end

function SWEP:PrimaryAttack()
	if not self.Owner:IsPlayer() then return end
	if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end
	if self:Clip2() <= 0 then return end

	if CurTime() < self.LastHeal + self.HealInterval then
		return
	end

	local tr = util.TraceLine({
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 70,
		filter = function(ent)
			return ent:IsPlayer()
		end
	})

	if not tr.Hit then return end
	if tr.Entity:Health() >= tr.Entity:GetMaxHealth() then return end
	
	self.LastHeal = CurTime()
	if SERVER then
		tr.Entity:SetHealth(tr.Entity:Health() + 1)
		self:SetClip2(self:Clip2() - 1)
	end

	if self.HealSoundPatch == nil then
		self.HealSoundPatch = CreateSound(self.Weapon, self.HealSound)
	end

	self.HealSoundPatch:Play()
	timer.Start("medkit_sound_" .. self:EntIndex())
end

function SWEP:CanSecondaryAttack()
	if self:Clip2() < self.DropHealAmount then
		if CLIENT then
			self.Weapon:EmitSound(self.FailSound)
		end
		
		return false
	end
	
	return true
end

function SWEP:SecondaryAttack()
	if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end
	if not self:CanSecondaryAttack() then return end 

	if CLIENT then
		self.Weapon:EmitSound(self.DropSound)
		return
	end
	
	self:SetClip2(self:Clip2() - self.DropHealAmount)

	local healthEnt = ents.Create("item_healthkit_oc")
	healthEnt.amount = self.DropHealAmount
	healthEnt.spawner = self:GetOwner()
	healthEnt:SetOwner(self:GetOwner())
	healthEnt:SetPos(self:GetOwner():EyePos() + (self:GetOwner():GetForward() * 30))
	healthEnt:Spawn()
end

function SWEP:OnRemove()
	timer.Remove("medkit_ammo_" .. self:EntIndex())
end