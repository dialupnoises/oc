AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

function ENT:AcceptInput(name, activator, called, data)
	local nameLower = string.lower(name)
	
	local numLives = tonumber(data) or 1
	if nameLower == "givelivestoactivator" then
			OC.Lives.addLives(v, numLives)
	elseif nameLower == "givelivestoactivatorteam" then
		for _, v in pairs(team.GetPlayers(activator:Team())) do
			OC.Lives.addLives(v, numLives)
		end
	elseif nameLower == "givelivestoallplayers" then
		for _, v in pairs(player.GetAll()) do
			OC.Lives.addLives(v, numLives)
		end
	elseif nameLower == "givelivestoblueteam" then
		for _, v in pairs(team.GetPlayers(2)) do
			OC.Lives.addLives(v, numLives)
		end
	elseif nameLower == "givelivestoredteam" then
		for _, v in pairs(team.GetPlayers(1)) do
			OC.Lives.addLives(v, numLives)
		end
	elseif nameLower == "givelivestoenemyteam" then
		local enemyTeam = 1
		if activator:Team() == enemyTeam then
			enemyTeam = 2
		end
		for _, v in pairs(team.GetPlayers(enemyTeam)) do
			OC.Lives.addLives(v, numLives)
		end
	end
end