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
AddCSLuaFile("client/hud.lua")
AddCSLuaFile("client/transfer.lua")
AddCSLuaFile("custom_replacements.lua")
AddCSLuaFile("convars.lua")
AddCSLuaFile("points.lua")
AddCSLuaFile("lives.lua")

include("shared.lua")

-- ents to replace after InitPostEntity
local weaponEntsToReplace = {}
local postEntCalled = false
local mapConfig = {}
-- OC func_precipitation allows enabling/disabling
-- we're just assuming you don't have multiple on a map that are independently enabled and disabled
local rainOn = true

local numlives = 0
local teamplay = false

function GM:EntityKeyValue(ent, key, value)
	if ent:EntIndex() == 0 and key == "teamplay" then
		teamplay = (value == "1")
	elseif ent:EntIndex() == 0 and key == "numlives" then
		numlives = tonumber(value)
		OC.Lives.setNumLives(numlives)
	end

	return ReplaceKeyValues(ent, key, value)
end

function ReplaceKeyValues(ent, key, value)
	if ent:GetClass() == "npc_maker" and string.equalsi(key, "npctype") and OC.NPCReplacements[value] ~= nil then
		return OC.NPCReplacements[value]
	end

	if ent:IsNPC() or ent:GetClass() == "npc_maker" then
		if key == "npchealth" then
			ent:SetHealth(tonumber(value))
		elseif key == "npcname" then
			ent:SetNWString("npcname", value)
		elseif key == "teamnumber" and teamplay then
			ent:SetNWInt("npcteam", tonumber(value))
		elseif key == "additionalequipment" and value == "Nothing" then
			return ""
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

	if ent:GetClass() == "func_precipitation" and key == "startoff" and value == "1" then
		rainOn = false
		SetRainEnabled(rainOn)
	end
end

function GM:InitPostEntity()
	postEntCalled = true

	for _, ent in pairs(weaponEntsToReplace) do
		if IsValid(ent) then
			ReplaceEnt(ent, ResolveOCWeapon(ent:GetClass()))
		end
	end

	local config = mapConfig[game.GetMap()]

	if config.convars ~= nil then
		for k, v in pairs(config.convars) do 
			RunConsoleCommand(k, v)
		end
	end

	if config.add ~= nil then
		for n, t in pairs(config.add) do
			if OC.CustomReplacements[n] ~= nil then
				n = ResolveOCWeapon(n)
			elseif OC.NPCReplacements[n] ~= nil then
				n = OC.NPCReplacements[n]
			end

			if n ~= "info_node" then
				local ent = ents.Create(n)
				if IsValid(ent) then
					for k, v in pairs(t) do
						local testV = ReplaceKeyValues(ent, k, v)
						if testV ~= nil then v = testV end
						MsgN(n .. ", " .. k .. " = " .. v)
						ent:SetKeyValue(k, v)
					end

					ent:Spawn()
				end
			end
		end
	end

	if config.remove ~= nil then
		ApplyToFoundScript(config.remove, function(e, t) e:Remove() end)
	end

	if config.modify ~= nil then
		ApplyToFoundScript(config.modify, function(e, t)
			for k, v in pairs(t) do
				e:SetKeyValue(k, v)
			end
		end)
	end
end

function GM:Initialize()
	resource.AddFile("resource/obsidian.ttf")

	if mapConfig[game.GetMap()] == nil then
		mapConfig[game.GetMap()] = LoadMapConfig(game.GetMap())
	end

	if numlives ~= nil and numlives > 0 then
		OC.Lives.setLivesEnabled(true)
	end
end

function GM:PlayerInitialSpawn(ply)
	if #team.GetPlayers(TEAM_RED) > #team.GetPlayers(TEAM_BLUE) then
		ply:SetTeam(TEAM_BLUE)
	else
		ply:SetTeam(TEAM_RED)
	end

	OC.Lives.initPlayer(ply)
	OC.Points.initPlayer(ply)

	ply:AllowFlashlight(true)

	SetRainEnabled(rainOn, ply)
end

function GM:PlayerSpawn(ply)
	if ply:Team() == TEAM_SPECTATOR then
		ply:StripWeapons()
		ply:Spectate(OBS_MODE_ROAMING)
		return
	end
	
	if mapConfig[game.GetMap()] ~= nil then
		config = mapConfig[game.GetMap()]
		for k, v in pairs(config.spawnItems) do
			amount = tonumber(v)

			for i = 1, amount do
				ply:Give(ResolveOCWeapon(k))
			end
		end
	end

	ply:Give("weapon_crowbar")
	ply:Give("weapon_healer")
	ply:Give("weapon_pistol")

	ply:SetModel("models/player/group01/male_01.mdl")
	ply:SetupHands(ply)
	player_manager.OnPlayerSpawn(ply)
	player_manager.RunClass(ply, "Spawn")
end

function GM:PlayerDeath(ply, attacker, damage)
	OC.Lives.playerDead(ply)

	if OC.Lives.allPlayersDead() then
		OC.Lives.handleAllDead()
	end
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

	if OC.NPCReplacements[ent:GetClass()] ~= nil then
		ReplaceEnt(ent, OC.NPCReplacements[ent:GetClass()])
	end

	if ent:GetClass() == "info_player_deathmatch" and ent.spawnEnabled == nil then
		ent.spawnEnabled = true
	end
end

function GM:AcceptInput(ent, input, activator, caller, value)
	if input == "Use" then
		ent.lastUseActivator = activator
	end

	if input == "ApplyScore" then
		local kvs = ent:GetKeyValues()
		local points = ent.pointAmount
		if points ~= nil then
			if ent:HasSpawnFlags(2) then
				for _, v in pairs(team.GetPlayers(activator:Team())) do
					OC.Points.sendChange(v, points)
				end
			else
				OC.Points.sendChange(activator, points)
			end
		end
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

	if ent:GetClass() == "func_precipitation" then
		if input == "Enable" then 
			rainOn = true
		elseif input == "Disable" then
			rainOn = false
		elseif input == "Toggle" then
			rainOn = not rainOn
		end
		SetRainEnabled(rainOn)
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

	if spawnpoint.TriggerOutput then
		spawnpoint:TriggerOutput("OnPlayerSpawn", ply, nil)
	end
	
	return true
end

function GM:EntityTakeDamage(target, dmginfo)
	if target:IsPlayer() then
		net.Start("player_damaged_ui")
		net.Send(target)
	elseif target:IsNPC() and dmginfo:GetAttacker():IsPlayer() then
		local prevHealth = target:Health() + dmginfo:GetDamage()
		local currentHealth = target:Health()

		if math.floor(prevHealth / 50) > math.floor(currentHealth / 50) then
			OC.Points.givePoints(dmginfo:GetAttacker(), 1)
		end
	end
end

function GM:OnNPCKilled(npc, attacker, inflictor)
	if attacker:IsPlayer() then
		OC.Points.givePoints(attacker, math.random(2, 3))
	end
end

util.AddNetworkString("player_damaged_ui")
util.AddNetworkString("play_use_sound")
util.AddNetworkString("send_points")
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

net.Receive("send_points", function(len, ply)
	local pointAmount = net.ReadInt(32)
	local toPlayer = Player(net.ReadInt(32))
	if OC.Points.getPoints(ply) < pointAmount then return end
	if not IsValid(toPlayer) then return end
	OC.Points.removePoints(ply, pointAmount)
	OC.Points.givePoints(toPlayer, pointAmount)
end)

local friendlyNPCs = {"npc_alyx","npc_barney","npc_citizen","npc_eli","npc_fisherman","npc_gman","npc_kleiner","npc_monk"}
hook.Add("ScaleNPCDamage", "prevent_invincible_npc_damage", function(npc, hitgroup, dmginfo)
	if npc:IsNPC() and table.HasValue(friendlyNPCs, npc:GetClass()) then
		dmginfo:ScaleDamage(0)
	else
		dmginfo:ScaleDamage(1)
	end
end)