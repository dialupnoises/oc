AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Game Text Quick"
ENT.Spawnable = false

local entKvs = {}
local newEnt, name

function createEnt()
	newEnt:SetName(name)
	for k, v in pairs(entKvs) do
		newEnt:SetKeyValue(k, v)
	end
end

function ENT:InitPostEntity()
	if newEnt then return end
	newEnt = ents.Create("game_text")
	name = self:GetName()
	createEnt()
end

function ENT:AcceptInput(name, activator, caller, val)
	if newEnt == nil then
		newEnt = ents.Create("game_text")
		name = self:GetName()
		createEnt()
	end

	if inputName == "DisplayText" then
		newEnt:Remove()
		entKvs["message"] = val
		createEnt()
		newEnt:Input("Display", activator, caller)
		return false
	end

	newEnt:Input(name, activator, caller, val)
	return false
end

function ENT:KeyValue(key, value)
	entKvs[key] = value
end