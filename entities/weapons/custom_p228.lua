AddCSLuaFile()

SWEP.PrintName = "p228"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.AnimPrefix = "pistol"
SWEP.Slot = 1
--SWEP.SlotPos = 7

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = true
SWEP.Weight = 2
SWEP.ViewModelFlip = false

local holdType = 1
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_P228.Single",
	Empty = "Default.ClipEmpty_Pistol",
	Reload = "undefined",
	ReloadNPC = "Weapon_Pistol.NPC_Reload",
	Special1 = "undefined",
	Special2 = "undefined",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-5.00,
	4.75,
	2.90
)


SWEP.Primary.Round = "pistol"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 13
SWEP.Primary.Delay = 0.2
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.15
SWEP.Primary.RPM = 300
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

