AddCSLuaFile()

SWEP.PrintName = "SG550"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.AnimPrefix = "ar2"
SWEP.Slot = 3
--SWEP.SlotPos = 6

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 5
SWEP.ViewModelFlip = false

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_SG550.Single",
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
SWEP.Primary.Delay = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.15
SWEP.Primary.RPM = 200
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

