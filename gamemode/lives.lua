OC = OC or {}
OC.Lives = OC.Lives or {}
OC.Lives.PlayerCache = OC.Lives.PlayerCache or {}

local livesIsEnabled = nil
local numlives = nil
OC.Lives.isEnabled = function()
	-- priority: mp_livesmode, livesIsEnabled, mp_livesoverride
	if GetConVar("mp_livesoverride"):GetInt() ~= -1 then
		return GetConVar("mp_livesoverride") == 1
	elseif livesIsEnabled ~= nil then
		return livesIsEnabled
	end

	return OC.Lives.livesMode() > 0
end

OC.Lives.livesMode = function()
	local result = GetConVar("mp_livesmode"):GetInt()
	if GetConVar("mp_livesoverride"):GetInt() == 1 and result == 0 then return 1 end
	if livesIsEnabled and result == 0 then return 1 end
	return result
end

OC.Lives.numLives = function()
	if GetConVar("mp_numlives"):GetInt() > 0 then
		return GetConVar("mp_numlives"):GetInt()
	elseif numlives ~= nil then
		return numlives
	else
		return 3
	end
end

OC.Lives.setNumLives = function(n)
	numlives = n
end

OC.Lives.setLivesEnabled = function(enabled)
	livesIsEnabled = enabled
end

OC.Lives.getLives = function(ply)
	return ply:GetNWInt("lives")
end

OC.Lives.setLives = function(ply, lives)
	ply:SetNWInt("lives", lives)
end

OC.Lives.addLives = function(ply, lives)
	local prevLives = OC.Lives.getLives(ply)
	OC.Lives.setLives(ply, prevLives + lives)

	if prevLives < 0 and (prevLives + lives) >= 0 then
		local newTeam = team.BestAutoJoinTeam()
		if newTeam == TEAM_UNASSIGNED then
			newTeam = TEAM_RED
		end
		ply:SetTeam(newTeam)
		ply:UnSpectate()
		ply:KillSilent()
	end
end

OC.Lives.removeLives = function(ply, lives)
	OC.Lives.addLives(ply, -lives)
end

OC.Lives.initPlayer = function(ply)
	if OC.Lives.PlayerCache[ply:SteamID()] then
		OC.Lives.setLives(ply, OC.Lives.PlayerCache[ply:SteamID()])
		if OC.Lives.getLives(ply) < 0 then
			OC.Lives.playerNoLives(ply)
		end
	else
		OC.Lives.setLives(ply, OC.Lives.numLives())
	end
end

OC.Lives.playerDead = function(ply)
	if not OC.Lives.isEnabled() then return end

	OC.Lives.removeLives(ply, 1)

	if OC.Lives.getLives(ply) < 0 then 
		OC.Lives.playerNoLives(ply)
	end
end

OC.Lives.playerNoLives = function(ply)
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	ply:StripWeapons()
	ply:ChatPrint("You have lost all your lives. You have become spectator until the game ends or you receive an additional life.")
end

OC.Lives.allPlayersDead = function()
	if not OC.Lives.isEnabled() then return false end

	for k, v in pairs(player.GetAll()) do
		if OC.Lives.getLives(v) >= 0 then
			return false
		end
	end
	
	return true
end

OC.Lives.handleAllDead = function()
	if OC.Lives.livesMode() == 0 then return end

	if OC.Lives.livesMode() == 2 then
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("All players dead. Reloading current map in ten seconds.")
		end

		timer.Simple(10, function() RunConsoleCommand("reload") end)
	elseif OC.Lives.livesMode() == 1 then
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("All players dead. Changing to next map.")
		end

		timer.Simple(10, function() game.LoadNextMap() end)
	end
end