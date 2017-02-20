GM.Name = "Obsidian Conflict"
GM.Author = "Anime Night"
GM.Email = "andrew@anime-night.com"
GM.Website = "https://www.anime-night.com/"

OC = {}
OC.Timer = {}

OC.Color = Color(9, 125, 238, 255)
OC.RedColor = Color(250, 60, 60, 255)
OC.YellowColor = Color(255, 175, 6, 255)
OC.GreenColor = Color(144, 238, 144, 255)
OC.LightBlueColor = Color(33, 135, 255)
OC.LightestBlue = Color(13, 126, 244, 255)

OC.WeaponRespawn = 30
OC.WeaponSpawnSound = Sound("garrysmod/ui_hover.wav")
OC.UseSound = Sound("common/wpn_select.wav")

game.AddAmmoType({
	name = "MedkitHeal"
})

include("custom_replacements.lua")
include("ammo_types.lua")
include("util.lua")
include("teams.lua")
include("weapon_sounds.lua")
include("convars.lua")
include("points.lua")
include("lives.lua")

concommand.Add("givepoints", function(ply, cmd, args, argStr) 
	if not IsValid(ply) then return end

	if tonumber(argStr) == nil then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Number of points required.")
		return
	end

	local cheatsConvar = GetConVar("sv_cheats")
	if not cheatsConvar:GetBool() and not ply:IsAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "sv_cheats must be enabled, or you must be an admin.")
		return
	end

	OC.Points.givePoints(ply, tonumber(argStr))
end)

concommand.Add("givelives", function(ply, cmd, args, argStr)
	if not IsValid(ply) then return end

	if tonumber(argStr) == nil then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Number of lives required.")
		return
	end

	local cheatsConvar = GetConVar("sv_cheats")
	if not cheatsConvar:GetBool() and not ply:IsAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "sv_cheats must be enabled, or you must be an admin.")
		return
	end

	OC.Lives.addLives(ply, tonumber(argStr))
end)