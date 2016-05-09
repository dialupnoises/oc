AddCSLuaFile()

SWEP.PrintName = "CZ52"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_w_cz52.mdl"
SWEP.WorldModel = "models/weapons/w_w_cz52.mdl"
SWEP.AnimPrefix = "pistol"
SWEP.Slot = 1
--SWEP.SlotPos = 3

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 1
SWEP.ViewModelFlip = false

local holdType = 1
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_cz52.Single",
	Empty = "Weapon_Pistol.Empty",
	Reload = "Weapon_cz52.Reload",
	ReloadNPC = "Weapon_cz52.Reload",
	Special1 = "Weapon_Pistol.Special1",
	Special2 = "Weapon_Pistol.Special2",
	Burst = "Weapon_Pistol.Burst"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-19.00,
	-6.77,
	4.50
)


SWEP.Primary.Round = "Pistol"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Delay = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.1
SWEP.Primary.RPM = 200
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

