AddCSLuaFile()

SWEP.PrintName = "DESERT EAGLE"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.AnimPrefix = "pistol"
SWEP.Slot = 1
--SWEP.SlotPos = 9

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = true
SWEP.Weight = 2
SWEP.ViewModelFlip = false

local holdType = 1
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_DEagle.Single",
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
	-6.00,
	5.15,
	2.7
)


SWEP.Primary.Round = "357"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Delay = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.05
SWEP.Primary.RPM = 100
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

