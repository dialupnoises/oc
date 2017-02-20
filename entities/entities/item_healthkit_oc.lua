AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.spawner = nil
ENT.pickupSound = Sound("items/medshot4.wav")

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	if SERVER then
		self:SetModel("models/items/healthkit.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	
		self:SetTrigger(true)
	end
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:StartTouch(ent)
	local healAmount = self.amount or 25
	if ent:IsPlayer() and ent:EntIndex() ~= self:GetOwner():EntIndex() and ent:Health() < ent:GetMaxHealth() then
		sound.Play(self.pickupSound, self:GetPos(), 75, 100, 1)
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + healAmount))
		self:Remove()
	end
end