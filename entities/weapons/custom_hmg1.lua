AddCSLuaFile()

SWEP.PrintName = "HMG 1"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_hmg1.mdl"
SWEP.WorldModel = "models/weapons/w_hmg1.mdl"
SWEP.AnimPrefix = "ar2"
SWEP.Slot = 3
--SWEP.SlotPos = 10

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 6
SWEP.ViewModelFlip = true

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "null",
	Empty = "Weapon_IRifle.Empty",
	Reload = "Weapon_AR2.Reload",
	ReloadNPC = "Weapon_AR2.NPC_Reload",
	Special1 = "Weapon_CombineGuard.Special1",
	Special2 = "undefined",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end



SWEP.Primary.Round = "AR2"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 120
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Delay = 0.05
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.1
SWEP.Primary.RPM = 1200
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

