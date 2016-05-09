AddCSLuaFile("shared.lua")

include("shared.lua")

local weaponName = nil
local postEntityReached = false
local spawned = false
local playerCondition = nil
local inited = false

local angles, pos
function doSpawn()
	if weaponName == nil or spawned then return end
	if playerCondition ~= nil and #player.GetAll() < playerCondition then return end
	newEnt = ents.Create(weaponName)
	--newEnt:SetAngles(angles)
	--newEnt:SetPos(pos)
	newEnt:Spawn()
	inited = true
end

function ENT:Initialize()
	angles = self:GetAngles()
	pos = self:GetPos()
	if spawned or not postEntityReached then return end
	doSpawn()
end

function ENT:KeyValue(key, value)
	if key == "customweaponscript" then
		weaponName = value
	elseif key == "minplayerstospawn" then
		playerCondition = tonumber(value)
	end
end

hook.Add("PlayerInitialSpawn", "weapon_scripted_playercondition", function() 
	if playerCondition ~= nil and #player.GetAll() >= playerCondition then
		doSpawn()
		hook.Remove("PlayerInitialSpawn", "weapon_scripted_playercondition")
	end
end)

hook.Add("InitPostEntity", "weapon_scripted_dospawn", function() 
	postEntityReached = true
	if not inited then
		doSpawn()
	end
end)