AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

local blacklist = {
	"origin",
	"targetname",
	"spawnflags",
	"classname",
	"hammerid"
}

ENT.weapons = {}

function ENT:Initialize()
	if CLIENT then return end

	hook.Add("PlayerSpawn", "GamePlayerEquip", function(ply)
		for _, v in pairs(self.weapons) do
			ply:Give(v)
			local wpn = ents.Create(v)
			wpn:SetPos(self:GetPos())
			wpn:Spawn()
		end
	end)
end

function ENT:KeyValue(key, value)
	if table.HasValue(blacklist, key) then
		return false
	end

	if self.weapons == nil then
		self.weapons = { key }
	else
		table.insert(self.weapons, key)
	end
	return true
end