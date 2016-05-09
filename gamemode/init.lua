AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ammo_types.lua")
AddCSLuaFile("teams.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("weapon_sounds.lua")
AddCSLuaFile("client/timer.lua")
AddCSLuaFile("client/npc_info.lua")

include("shared.lua")
include("server/map_configs.lua")

-- Stores player points in-memory
OC.PlayerCache = {}

function GM:EntityKeyValue(ent, key, value)
	if ent:IsNPC() then
		if key == "npchealth" then
			ent:SetHealth(value)
		elseif key == "npcname" then
			ent:SetNWString("npcname", value)
		elseif key == "teamnumber" and (MapConfigs[game.GetMap()] or {})["teamplay"] then
			ent:SetNWInt("npcteam", value)
		end
	end
end

function GM:Initialize()
	resource.AddFile("resource/obsidian.ttf")
end

function GM:PlayerInitialSpawn(ply)
	if #team.GetPlayers(TEAM_RED) > #team.GetPlayers(TEAM_BLUE) then
		ply:SetTeam(TEAM_BLUE)
	else
		ply:SetTeam(TEAM_RED)
	end

	local config = MapConfigs[game.GetMap()]
	local lives = 0
	if config ~= nil then 
		lives = config["numlives"]
	end

	if lives > 0 then
		ply:SetNWInt("lives", lives)
	else
		ply:SetNWInt("lives", -1)
	end

	if OC.PlayerCache[ply:SteamID()] ~= nil then
		ply:SetNWInt("points", OC.PlayerCache[ply:SteamID()])
	else
		ply:SetNWInt("points", 0)
		OC.PlayerCache[ply:SteamID()] = 0
	end
	ply:AllowFlashlight(true)
end

function GM:PlayerSpawn(ply)
	if MapConfigs[game.GetMap()] ~= nil then
		config = MapConfigs[game.GetMap()]
		for k, v in pairs(config["spawn_items"]) do
			amount = tonumber(v)

			for i = 1, amount do
				ply:Give(k)
			end
		end
	end
end

util.AddNetworkString("npc_disposition_request")
util.AddNetworkString("npc_disposition_response")
net.Receive("npc_disposition_request", function(len, ply)
	local entIndex = net.ReadInt(16)
	local ent = ents.GetByIndex(entIndex)
	if not ent:IsNPC() then return end

	net.Start("npc_disposition_response")
	net.WriteInt(entIndex, 16)
	net.WriteInt(ent:Disposition(ply), 4)
	net.Send(ply)
end)

hook.Add("PlayerDeath", "lives_manager_player_death", function(ply, inflictor, attacker)
	if #ents.FindByClass("game_lives_manager") == 0 then return end

	if ply:GetNWInt("lives" > 0) then
		ply:SetNWInt("lives", ply:GetNWInt("lives") - 1)
	end

	if ply:GetNWInt("lives") <= 0 then
		ply:SetTeam(TEAM_SPECTATOR)
		ply:Spectate(OBS_MODE_ROAMING)
	end
end)