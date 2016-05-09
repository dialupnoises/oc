AddCSLuaFile()

SWEP.PrintName = "Bofors AK5"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_borak5.mdl"
SWEP.WorldModel = "models/weapons/w_borak5.mdl"
SWEP.AnimPrefix = "smg2"
SWEP.Slot = 2
--SWEP.SlotPos = 7

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 3
SWEP.ViewModelFlip = true

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_ak5.Single",
	Empty = "Weapon_SMG1.Empty",
	Reload = "Weapon_SMG1.Reload",
	ReloadNPC = "Weapon_SMG1.Reload",
	Special1 = "Weapon_SMG1.Special1",
	Special2 = "Weapon_SMG1.Special2",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-5.80,
	-3.80,
	1.40
)


SWEP.Primary.Round = "SMG1"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Delay = 0.12
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.0875
SWEP.Primary.RPM = 500
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20


SWEP.Secondary.Round = "SMG1_Grenade"
SWEP.Secondary.Ammo = SWEP.Secondary.Round
SWEP.Secondary.ClipSize = "-1"
SWEP.Secondary.DefaultClip = "-1"
SWEP.Secondary.Delay = 1.0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Cone = NaN
SWEP.Secondary.RPM = 60
