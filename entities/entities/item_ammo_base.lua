AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName = "Base Ammo Box"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.AmmoAmount = 45
ENT.AmmoType = "none"
ENT.BoxModel = "models/items/ammocrate_357.mdl"

function ENT:Initialize()
	self:SetModel(self.BoxModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	
	if SERVER then
		self:SetTrigger(true)
	end
end

function ENT:Touch(entity)
	if not entity:IsPlayer() then return end

	if SERVER then
		entity:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
	end

	self:Remove()
end