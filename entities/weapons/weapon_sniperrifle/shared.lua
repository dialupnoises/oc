AddCSLuaFile()

SWEP.PrintName             = "Sniper Rifle"
SWEP.Author                = "Obsidian Conflict"
SWEP.Base                  = "oc_scoped_base"
SWEP.HoldType = "ar2"

SWEP.Spawnable             = false
SWEP.AdminOnly             = false

SWEP.Weight                = 5
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false

SWEP.Slot                  = 3
SWEP.DrawCrosshair         = true

SWEP.ViewModel             = "models/weapons/v_sniper.mdl"
SWEP.WorldModel            = "models/weapons/w_sniper.mdl"

SWEP.Primary.Sound          = Sound("weapons/sniper/sniper_fire.wav") 
SWEP.Primary.Round          = "SniperRound"
SWEP.Primary.RPM            = 0
SWEP.Primary.Cone           = 0.05
SWEP.Primary.Recoil         = 10
SWEP.Primary.Damage         = 80
SWEP.Primary.Spread         = .001
SWEP.Primary.NumShots       = 1
SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 10
SWEP.Primary.KickUp         = 0.5
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "SniperRound"

SWEP.Secondary.ScopeZoom      = 0
SWEP.Secondary.UseACOG        = false
SWEP.Secondary.UseMilDot      = false
SWEP.Secondary.UseSVD         = false
SWEP.Secondary.UseParabolic   = false
SWEP.Secondary.UseElcan       = false
SWEP.Secondary.UseGreenDuplex = false