AddCSLuaFile()

SWEP.PrintName = "M3"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_shotty_base"

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.AnimPrefix = "shotgun"
SWEP.Slot = 3
--SWEP.SlotPos = 10

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 4
SWEP.ViewModelFlip = false

local holdType = 5
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_M3.Single",
	Empty = "Weapon_Shotgun.Empty",
	Reload = "undefined",
	ReloadNPC = "Weapon_Shotgun.NPC_Reload",
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
	-2.00,
	5.75,
	3.40
)


SWEP.Primary.Round = "Buckshot"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Delay = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.5
SWEP.Primary.RPM = 200
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

