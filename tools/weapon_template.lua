AddCSLuaFile()

SWEP.PrintName = "{{=WeaponData.printname}}"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = {{? WeaponData.Advanced.FireType1 == "3"}}"oc_shotty_base"{{??}}"oc_gun_base"{{?}}

SWEP.ViewModel = "{{=WeaponData.viewmodel}}"
SWEP.WorldModel = "{{=WeaponData.playermodel}}"
SWEP.AnimPrefix = "{{=WeaponData.anim_prefix}}"
SWEP.Slot = {{=WeaponData.bucket}}
--SWEP.SlotPos = {{=WeaponData.bucket_position}}

SWEP.AutoSwitchTo = {{=WeaponData.autoswitchto == "1"}}
SWEP.AutoSwitchFrom = {{=WeaponData.autoswitchfrom == "1"}}
SWEP.FiresUnderwater = {{=WeaponData.Advanced.FireUnderWater1 == "1"}}
SWEP.Weight = {{=WeaponData.weight}}
SWEP.ViewModelFlip = {{=WeaponData.csviewmodel == 0}}

local holdType = {{=WeaponData.Advanced.PlayerAnimationSet || "1"}}
local holdTypes = {"pistol", "ar2", "crossbow", "physgun", "shotgun", "smg"}
SWEP.HoldType = holdTypes[holdType] or "pistol"

Sounds = {
	Primary = "{{=convertSound(WeaponData.SoundData.single_shot)}}",
	Empty = "{{=convertSound(WeaponData.SoundData.empty)}}",
	Reload = "{{=convertSound(WeaponData.SoundData.reload)}}",
	ReloadNPC = "{{=convertSound(WeaponData.SoundData.reload_npc)}}",
	Special1 = "{{=convertSound(WeaponData.SoundData.special1)}}",
	Special2 = "{{=convertSound(WeaponData.SoundData.special2)}}",
	Burst = "{{=convertSound(WeaponData.SoundData.burst)}}"
}

if SERVER then
	resource.AddFile("sounds/" .. Sounds.Primary)
	resource.AddFile(SWEP.ViewModel)
	resource.AddFile(SWEP.WorldModel)
end

{{? WeaponData.ironsightoffset}}
SWEP.IronSightsPos = Vector(
	{{=WeaponData.ironsightoffset.x}},
	{{=WeaponData.ironsightoffset.y}},
	{{=WeaponData.ironsightoffset.z}}
)
SWEP.IronSightsAng = Angle(
	{{=WeaponData.ironsightoffset.xori||0}},
	{{=WeaponData.ironsightoffset.yori||0}},
	{{=WeaponData.ironsightoffset.zori||0}}
)
{{?}}

SWEP.Primary.Round = "{{=WeaponData.primary_ammo}}"
SWEP.Primary.Ammo = SWEP.Primary.Round
SWEP.Primary.ClipSize = {{=WeaponData.clip_size}}
SWEP.Primary.DefaultClip = {{=WeaponData.default_clip || 0}}
SWEP.Primary.Delay = {{=WeaponData.Advanced.FireRate1}}
SWEP.Primary.Automatic = true
SWEP.Primary.Cone = {{=WeaponData.Advanced.FireCone1 / 20}}
SWEP.Primary.RPM = {{=60/WeaponData.Advanced.FireRate1}}
SWEP.Primary.Sound = Sound(Sounds.Primary)
SWEP.Primary.Damage = 30

{{? WeaponData.Advanced.FireType2 != "0" && WeaponData.secondary_ammo != "None" }}
SWEP.Secondary.Round = "{{=WeaponData.secondary_ammo}}"
SWEP.Secondary.Ammo = SWEP.Secondary.Round
SWEP.Secondary.ClipSize = "{{=WeaponData.clip2_size}}"
SWEP.Secondary.DefaultClip = "{{=WeaponData.default_clip2}}"
SWEP.Secondary.Delay = {{=WeaponData.Advanced.FireRate2}}
SWEP.Secondary.Automatic = true
SWEP.Secondary.Cone = {{=WeaponData.Advanced.FireCone2 / 20}}
SWEP.Secondary.RPM = {{=60/WeaponData.Advanced.FireRate2}}
{{?}}