AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

ENT.PrintName = "Game Text Quick"
ENT.Spawnable = false

ENT.Kvs = {}
ENT.NewEnt = nil
ENT.Name = nil

function ENT:createEnt()
	if not IsValid(self.NewEnt) then self.NewEnt = ents.Create("game_text") end
	self.NewEnt:SetName(self.Name)
	for k, v in pairs(self.Kvs) do
		self.NewEnt:SetKeyValue(k, v)
	end
end

function ENT:InitPostEntity()
	if self.NewEnt then return end
	self.Name = self:GetName()
	self:createEnt()
end

function ENT:AcceptInput(name, activator, caller, val)
	if self.NewEnt == nil then
		self.NewEnt = ents.Create("game_text")
		self.Name = self:GetName()
		self:createEnt()
	end

	if name == "DisplayText" then
		if IsValid(self.NewEnt) then
			self.NewEnt:Remove()
		end
		self.Kvs["message"] = val
		self:createEnt()
		self.NewEnt:Input("Display", activator, caller)
		MsgN(val)
		return false
	end

	self.NewEnt:Input(self.Name, activator, caller, val)
	return false
end

function ENT:KeyValue(key, value)
	self.Kvs[key] = value
end