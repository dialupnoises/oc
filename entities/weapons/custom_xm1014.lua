AddCSLuaFile()

SWEP.PrintName = "SPAS12"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_shotty_base"

SWEP.ViewModel = "models/weapons/v_spas12.mdl"
SWEP.WorldModel = "models/weapons/w_spas12.mdl"
SWEP.AnimPrefix = "shotgun"
SWEP.Slot = 3
--SWEP.SlotPos = 4

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 4
SWEP.ViewModelFlip = true

local holdType = 5
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_spas12.Single",
	Empty = "Weapon_Shotgun.Empty",
	Reload = "Weapon_Shotgun.Reload",
	ReloadNPC = "Weapon_Shotgun.NPC_Reload",
	Special1 = "Weapon_Shotgun.Special1",
	Special2 = "undefined",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-4.00,
	-6.70,
	4.80
)


SWEP.Primary.Round = "Buckshot"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Delay = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.45
SWEP.Primary.RPM = 200
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

