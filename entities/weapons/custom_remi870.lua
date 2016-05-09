AddCSLuaFile()

SWEP.PrintName = "Remington 870"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_shotty_base"

SWEP.ViewModel = "models/weapons/v_remi870.mdl"
SWEP.WorldModel = "models/weapons/w_remi870.mdl"
SWEP.AnimPrefix = "shotgun"
SWEP.Slot = 3
--SWEP.SlotPos = 11

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 5
SWEP.ViewModelFlip = true

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_remi870.Single",
	Empty = "Weapon_Shotgun.Empty",
	Reload = "Weapon_Shotgun.Reload",
	ReloadNPC = "Weapon_Shotgun.NPC_Reload",
	Special1 = "Weapon_remi870.Special1",
	Special2 = "undefined",
	Burst = "undefined"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end


SWEP.IronSightsPos = Vector(
	-6,
	-5.50,
	3.30
)


SWEP.Primary.Round = "Buckshot"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Delay = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.175
SWEP.Primary.RPM = 150
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

