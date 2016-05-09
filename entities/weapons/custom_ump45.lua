AddCSLuaFile()

SWEP.PrintName = "UMP45"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.AnimPrefix = "smg2"
SWEP.Slot = 2
--SWEP.SlotPos = 11

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 3
SWEP.ViewModelFlip = false

local holdType = 6
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_UMP45.Single",
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
	-5.00,
	7.3,
	3.22
)


SWEP.Primary.Round = "SMG1"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Delay = 0.11
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.1
SWEP.Primary.RPM = 545.4545454545455
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

