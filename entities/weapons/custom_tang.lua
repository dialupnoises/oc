AddCSLuaFile()

SWEP.PrintName = "TANG!"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.AnimPrefix = "smg2"
SWEP.Slot = 2
--SWEP.SlotPos = 9

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 3
SWEP.ViewModelFlip = false

local holdType = 6
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_SMG1.Single",
	Empty = "Weapon_SMG1.Empty",
	Reload = "Weapon_SMG1.Reload",
	ReloadNPC = "Weapon_SMG1.NPC_Reload",
	Special1 = "Weapon_SMG1.Special1",
	Special2 = "Weapon_SMG1.Special2",
	Burst = "Weapon_SMG1.Burst"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-8.00,
	-6.45,
	2.53
)
SWEP.IronSightsAng = Angle(
	0,
	0,
	0
)


SWEP.Primary.Round = "SMG1"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Delay = 0.18
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.5
SWEP.Primary.RPM = 333.33333333333337
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 30

