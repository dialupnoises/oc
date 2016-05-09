AddCSLuaFile()

SWEP.PrintName = "G36c"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_hex_g36c.mdl"
SWEP.WorldModel = "models/weapons/w_hex_g36c.mdl"
SWEP.AnimPrefix = "ar2"
SWEP.Slot = 2
--SWEP.SlotPos = 12

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = false
SWEP.Weight = 0
SWEP.ViewModelFlip = false

local holdType = 2
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_g36c.Single",
	Empty = "Weapon_Pistol.Empty",
	Reload = "undefined",
	ReloadNPC = "Weapon_Pistol.NPC_Reload",
	Special1 = "Weapon_g36c.Single",
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
	3.78,
	1.46
)


SWEP.Primary.Round = "ar2"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Delay = 0.09
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.05
SWEP.Primary.RPM = 666.6666666666667
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

