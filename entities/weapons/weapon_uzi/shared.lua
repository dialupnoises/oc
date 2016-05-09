AddCSLuaFile()

SWEP.PrintName = "Uzi"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "oc_gun_base"

SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/Weapons/v_imi_uzi01.mdl"
SWEP.WorldModel = "models/Weapons/w_uzi_imi.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.ClipSize = 30
SWEP.Primary.Damage = 5
SWEP.Primary.RPM = 720
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = Sound("weapons/uzi/uzi_fire1.wav")

if SERVER then
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
	resource.AddFile("sounds/weapons/uzi/uzi_fire1.wav")
end