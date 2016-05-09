AddCSLuaFile()

SWEP.PrintName = "mp5k"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_mp5k.mdl"
SWEP.WorldModel = "models/weapons/w_mp5k.mdl"
SWEP.AnimPrefix = "smg2"
SWEP.Slot = 2
--SWEP.SlotPos = 6

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 3
SWEP.ViewModelFlip = true

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_mp5k.Single",
	Empty = "Weapon_SMG1.Empty",
	Reload = "Weapon_SMG1.Reload",
	ReloadNPC = "Weapon_SMG1.NPC_Reload",
	Special1 = "Weapon_SMG1.Special1",
	Special2 = "Weapon_SMG1.Special2",
	Burst = "Weapon_mp5k.Burst"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-14.00,
	-6.47,
	3.10
)


SWEP.Primary.Round = "SMG1"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.1
SWEP.Primary.RPM = 600
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

