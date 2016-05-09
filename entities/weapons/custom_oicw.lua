AddCSLuaFile()

SWEP.PrintName = "OICW"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_oicw.mdl"
SWEP.WorldModel = "models/weapons/w_oicw.mdl"
SWEP.AnimPrefix = "ar2"
SWEP.Slot = 2
--SWEP.SlotPos = 8

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 3
SWEP.ViewModelFlip = true

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_OICW.Single",
	Empty = "Weapon_OICW.Empty",
	Reload = "Weapon_OICW.Reload",
	ReloadNPC = "Weapon_OICW.NPC_Reload",
	Special1 = "Weapon_OICW.Special1",
	Special2 = "Weapon_OICW.Special2",
	Burst = "Weapon_OICW.ZoomedShot"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-8.00,
	-6.45,
	1.95
)


SWEP.Primary.Round = "SMG1"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Delay = 0.12
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.1
SWEP.Primary.RPM = 500
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

