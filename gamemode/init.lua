AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ammo_types.lua")
AddCSLuaFile("teams.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("weapon_sounds.lua")
AddCSLuaFile("client/timer.lua")
AddCSLuaFile("client/npc_info.lua")
AddCSLuaFile("client/points.lua")
AddCSLuaFile("client/strings.lua")
AddCSLuaFile("client/merchant.lua")
AddCSLuaFile("custom_replacements.lua")
AddCSLuaFile("convars.lua")
AddCSLuaFile("points.lua")

include("shared.lua")
include("server/map_configs.lua")

-- ents to replace after InitPostEntity
local weaponEntsToReplace = {}
local postEntCalled = false

local numlives = 0
local teamplay = false

function GM:EntityKeyValue(ent, key, value)
	if ent:EntIndex() == 0 and key == "teamplay" then
		teamplay = (value == "1")
	elseif ent:EntIndex() == 0 and key == "numlives" then
		numlives = tonumber(value)
	end

	-- OH MY GOD THIS WORKS
	if ent:GetClass() == "trigger_multiple_oc" and key == "classname" then
		return "trigger_multiple"
	elseif ent:GetClass() == "trigger_once_oc" and key == "classname" then
		return "trigger_once"
	end

	if OC.CustomReplacements[ent:GetClass()] ~= nil and key == "classname" then
		return ResolveOCWeapon(ent:GetClass())
	end

	if ent:IsNPC() then
		if key == "npchealth" then
			if tonumber(value) == 0 then
				ent.invincible = true
			else
				ent:SetHealth(tonumber(value))
			end
		elseif key == "npcname" then
			ent:SetNWString("npcname", value)
		elseif key == "teamnumber" and teamplay then
			ent:SetNWInt("npcteam", tonumber(value))
		elseif key == "additionalequipment" and OC.CustomReplacements[value] ~= nil then
			return ResolveOCWeapon(value)
		end
	end

	if ent:GetClass() == "game_score" and key == "points" then
		ent.pointAmount = tonumber(value)
	end

	if ent:GetClass() == "info_player_deathmatch" and key == "StartDisabled" then
		ent.spawnEnabled = (value == "0")
	elseif ent:GetClass() == "info_player_deathmatch" and key == "OnPlayerSpawn" then
		ent:StoreOutput(key, value)
	end
end

function GM:InitPostEntity()
	postEntCalled = true

	for _, ent in pairs(weaponEntsToReplace) do
		if IsValid(ent) then
			ReplaceEnt(ent, ResolveOCWeapon(ent:GetClass()))
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

	if numlives ~= nil and numlives > 0 then
		ply:SetNWInt("lives", numlives)
	else
		ply:SetNWInt("lives", -1)
	end

	OC.Points.initPlayer(ply)

	ply:AllowFlashlight(true)
end

function GM:PlayerSpawn(ply)
	if MapConfigs[game.GetMap()] ~= nil then
		config = MapConfigs[game.GetMap()]
		for k, v in pairs(config["spawn_items"]) do
			amount = tonumber(v)

			for i = 1, amount do
				ply:Give(ResolveOCWeapon(k))
			end
		end
	else
		ply:Give("weapon_crowbar")
		ply:Give("weapon_healer")
		ply:Give("weapon_pistol")
		ply:Give("weapon_physcannon")
	end

	ply:SetModel("models/player/group01/male_01.mdl")
	ply:SetupHands(ply)
	player_manager.OnPlayerSpawn(ply)
	player_manager.RunClass(ply, "Spawn")
end

function GM:OnEntityCreated(ent)
	-- force the game not to have stalkers be neutral
	if ent:GetClass() == "npc_stalker" then
		ent:AddRelationship("player D_HT 99")
	end

	if OC.CustomReplacements[ent:GetClass()] ~= nil then
		if postEntCalled then
			ReplaceEnt(ent, ResolveOCWeapon(ent:GetClass()))
		else
			table.insert(weaponEntsToReplace, ent)
		end
	end

	if ent:GetClass() == "info_player_deathmatch" and ent.spawnEnabled == nil then
		ent.spawnEnabled = true
	end
end

function GM:AcceptInput(ent, input, activator, caller, value)
	if input == "Use" then
		ent.lastUseActivator = activator
	end

	-- patch game_score for points not being frags
	if input == "ApplyScore" and not OC.Points.areFrags() then
		local kvs = ent:GetKeyValues()
		local points = ent.pointAmount

		-- flag 2 = team points
		if ent:HasSpawnFlag(2) then
			for _, v in pairs(team.GetPlayers(activator:Team())) do
				OC.Points.givePoints(v, points)
			end
		else
			OC.Points.givePoints(activator, points)
		end

		return true
	end

	if ent:GetClass() == "info_player_deathmatch" and input == "Enable" then
		ent.spawnEnabled = true
	elseif ent:GetClass() == "info_player_deathmatch" and input == "Disable" then
		ent.spawnEnabled = false
	end

	return false
end

function GM:FindUseEntity(ply, defaultEnt)
	if defaultEnt.useRedirectEnt ~= nil then
		return defaultEnt.useRedirectEnt
	end

	return defaultEnt
end

function GM:PlayerUse(ply, ent)
	if ent:IsNPC() and ent.NPCUse ~= nil then
		ent.NPCUse(ent, ply, ply, USE_ON, nil)
	end

	net.Start("play_use_sound")
	net.Send(ply)
	return true
end

function GM:IsSpawnpointSuitable(ply, spawnpoint, makeSuitable)
	if spawnpoint.spawnEnabled ~= nil then
		if spawnpoint.spawnEnabled then 
			spawnpoint:TriggerOutput("OnPlayerSpawn", ply, nil)
		end
		return spawnpoint.spawnEnabled
	end

	MsgN(spawnpoint)
	spawnpoint:TriggerOutput("OnPlayerSpawn", ply, nil)
	return true
end

util.AddNetworkString("play_use_sound")
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

	if ply:GetNWInt("lives") > 0 then
		ply:SetNWInt("lives", ply:GetNWInt("lives") - 1)
	end

	if ply:GetNWInt("lives") <= 0 then
		ply:SetTeam(TEAM_SPECTATOR)
		ply:Spectate(OBS_MODE_ROAMING)
	end
end)

hook.Add("ScaleNPCDamage", "prevent_invincible_npc_damage", function(npc, hitgroup, dmginfo)
	if npc.invincible ~= nil and npc.invincible then
		dmginfo:ScaleDamage(0)
	else
		dmginfo:ScaleDamage(1)
	end
end)