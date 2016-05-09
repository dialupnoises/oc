AddCSLuaFile()

SWEP.PrintName = "MAC"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"
SWEP.AnimPrefix = "smg2"
SWEP.Slot = 1
--SWEP.SlotPos = 12

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 3
SWEP.ViewModelFlip = false

local holdType = 6
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_MAC10.Single",
	Empty = "Default.ClipEmpty_Rifle",
	Reload = "undefined",
	ReloadNPC = "Weapon_SMG1.NPC_Reload",
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
	-3.00,
	6.25,
	2.95
)


SWEP.Primary.Round = "SMG1"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Delay = 0.07
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.2
SWEP.Primary.RPM = 857.1428571428571
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

