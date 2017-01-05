AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.weaponName = nil
ENT.postEntityReached = false
ENT.spawned = false
ENT.playerCondition = nil
ENT.inited = false

function ENT:doSpawn()
	if self.weaponName == nil or self.spawned then return end
	if self.playerCondition ~= nil and #player.GetAll() < self.playerCondition then return end
	local newEnt = ents.Create(ResolveOCWeapon(self.weaponName))
	newEnt:SetAngles(self:GetAngles())
	newEnt:SetPos(self:GetPos())
	newEnt:Spawn()
	self.inited = true
end

function ENT:Initialize()
	hook.Add("PlayerInitialSpawn", "weapon_scripted_playercondition_" .. self:EntIndex(), function() 
		if self.playerCondition ~= nil and #player.GetAll() >= self.playerCondition then
			self:doSpawn()
			hook.Remove("PlayerInitialSpawn", "weapon_scripted_playercondition_" .. self:EntIndex())
		end
	end)

	hook.Add("InitPostEntity", "weapon_scripted_dospawn", function() 
		self.postEntityReached = true
		if not self.inited then
			self:doSpawn()
		end
	end)

	if self.spawned or not self.postEntityReached then return end
	self:doSpawn()
end

function ENT:KeyValue(key, value)
	if key == "customweaponscript" then
		self.weaponName = value
	elseif key == "minplayerstospawn" then
		self.playerCondition = tonumber(value)
	end
end