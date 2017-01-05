GM.Name = "Obsidian Conflict"
GM.Author = "Anime Night"
GM.Email = "andrew@anime-night.com"
GM.Website = "https://www.anime-night.com/"

OC = {}
OC.Timer = {}

OC.Color = Color(0, 93, 190, 255)
OC.RedColor = Color(127, 0, 0, 255)
OC.YellowColor = Color(255, 175, 6, 255)

OC.WeaponRespawn = 30
OC.WeaponSpawnSound = Sound("garrysmod/ui_hover.wav")

include("custom_replacements.lua")
include("ammo_types.lua")
include("util.lua")
include("teams.lua")
include("weapon_sounds.lua")
include("convars.lua")
include("points.lua")

concommand.Add("givepoints", function(ply, cmd, args, argStr) 
	if not IsValid(ply) then return end

	local points = OC.Points.getPoints(ply)
	if tonumber(argStr) == nil then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Number of points required.")
		return
	end

	local cheatsConvar = GetConVar("sv_cheats")
	if not cheatsConvar:GetBool() and not ply:IsAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "sv_cheats must be enabled.")
		return
	end

	OC.Points.givePoints(ply, tonumber(argStr))
end)