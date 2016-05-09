AddCSLuaFile()

SWEP.PrintName = "FIVE SEVEN"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.AnimPrefix = "pistol"
SWEP.Slot = 1
--SWEP.SlotPos = 11

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.FiresUnderwater = true
SWEP.Weight = 0
SWEP.ViewModelFlip = false

local holdType = 1
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "Weapon_FiveSeven.Single",
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
	-3.50,
	4.53,
	3.30
)


SWEP.Primary.Round = "pistol"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Delay = 0.2
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = 0.05
SWEP.Primary.RPM = 300
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 20

