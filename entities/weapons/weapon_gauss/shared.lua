AddCSLuaFile()

//General Variables\\
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV = 64
SWEP.ViewModel = "v_pist_finger1.mdl"
SWEP.WorldModel = "[Choose different Model]"
SWEP.AutoSwitchTo = false
SWEP.Slot = 5
SWEP.HoldType = "smg"
SWEP.PrintName = "gauss gun"
SWEP.Author = "Aeph"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = true
SWEP.Weight = 5
SWEP.DrawCrosshair = true
SWEP.Category = "rifle"
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.ReloadSound = "Weapon_Pistol.Reload"
SWEP.Instructions = "shoot"
SWEP.Contact = "x"
SWEP.Purpose = "x"
SWEP.base = "weapon_base"
//General Variables\\

//Primary Fire Variables\\
SWEP.Primary.Sound = "Weapon_IRifle.Single"
SWEP.Primary.Damage = 5000
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 200
SWEP.Primary.Ammo = "gauss"
SWEP.Primary.DefaultClip = 32
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1.0
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 5000
//Primary Fire Variables\\

//Secondary Fire Variables\\
SWEP.Secondary.NumberofShots = 1
SWEP.Secondary.Force = 1200
SWEP.Secondary.Spread = 0.1
SWEP.Secondary.Sound = "Weapon_357.Single"
SWEP.Secondary.DefaultClip = 32
SWEP.Secondary.Automatic = "false"
SWEP.Secondary.Ammo = "w_umd.mdl"
SWEP.Secondary.Recoil = 5.0
SWEP.Secondary.Delay = 1.0
SWEP.Secondary.TakeAmmo = 1
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Damage = 9999
//Secondary Fire Variables\\

//SWEP:Initialize()\\
function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound(self.Secondary.Sound)
	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
end
//SWEP:Initialize()\\

//SWEP:PrimaryFire()\\
function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 0
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo
	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	self:ShootEffects()
	self.Owner:FireBullets( bullet )
	self.Weapon:EmitSound(Sound(self.Primary.Sound))
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end
//SWEP:PrimaryFire()\\

//SWEP:SecondaryFire()\\
function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
	local bullet = {}
		bullet.Num = self.Secondary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.Secondary.Spread * 0.1 , self.Secondary.Spread * 0.1, 0)
		bullet.Tracer = 0
		bullet.Force = self.Secondary.Force
		bullet.Damage = self.Secondary.Damage
		bullet.AmmoType = self.Secondary.Ammo
	local rnda = self.Secondary.Recoil * -1
	local rndb = self.Secondary.Recoil * math.random(-1, 1)
	self:ShootEffects()
	self.Owner:FireBullets( bullet )
	self.Weapon:EmitSound(Sound(self.Secondary.Sound))
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	self:TakeSecondaryAmmo(self.Secondary.TakeAmmo)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end
//SWEP:SecondaryFire()\\

