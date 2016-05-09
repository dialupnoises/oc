AddCSLuaFile()

SWEP.PrintName = "Steyr Aug"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_rif_Aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_Aug.mdl"
SWEP.AnimPrefix = "ar2"
SWEP.Slot = 2
--SWEP.SlotPos = 19

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 0
SWEP.ViewModelFlip = false

local holdType = 6
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_AUG.Single",
	Empty = "Default.ClipEmpty_Rifle",
	Reload = "undefined",
	ReloadNPC = "Weapon_AR2.NPC_Reload",
	Special1 = "Default.Zoom",
	Special2 = "Default.Zoom",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end



SWEP.Primary.Round = "ar2"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.05
SWEP.Primary.RPM = 600
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

