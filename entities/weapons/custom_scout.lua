AddCSLuaFile()

SWEP.PrintName = "Scout"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.AnimPrefix = "ar2"
SWEP.Slot = 3
--SWEP.SlotPos = 5

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 2
SWEP.ViewModelFlip = false

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_Scout.Single",
	Empty = "Default.ClipEmpty_Rifle",
	Reload = "undefined",
	ReloadNPC = "Weapon_SniperRifle.NPC_Reload",
	Special1 = "Default.Zoom",
	Special2 = "Default.Zoom",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end



SWEP.Primary.Round = "357"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Delay = 1.0
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.15
SWEP.Primary.RPM = 60
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 30

