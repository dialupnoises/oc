AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

function ENT:AcceptInput(name, activator, called, data)
	local numLives = tonumber(data) or 1
	if name == "GiveLivesToActivator" then
			OC.Lives.addLives(v, numLives)
	elseif name == "GiveLivesToActivatorTeam" then
		for _, v in pairs(team.GetPlayers(activator:Team())) do
			OC.Lives.addLives(v, numLives)
		end
	elseif name == "GiveLivesToAllPlayers" then
		for _, v in pairs(player.GetAll()) do
			OC.Lives.addLives(v, numLives)
		end
	elseif name == "GiveLivesToBlueTeam" then
		for _, v in pairs(team.GetPlayers(2)) do
			OC.Lives.addLives(v, numLives)
		end
	elseif name == "GiveLivesToRedTeam" then
		for _, v in pairs(team.GetPlayers(1)) do
			OC.Lives.addLives(v, numLives)
		end
	elseif name == "GiveLivesToEnemyTeam" then
		local enemyTeam = 1
		if activator:Team() == enemyTeam then
			enemyTeam = 2
		end
		for _, v in pairs(team.GetPlayers(enemyTeam)) do
			OC.Lives.addLives(v, numLives)
		end
	end
end