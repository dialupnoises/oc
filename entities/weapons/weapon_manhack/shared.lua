SWEP.PrintName = "Manhack"
SWEP.Author = "Obsidian Conflict"
SWEP.Category = "Obsidian Conflict Weapons"
SWEP.Base = "weapon_base"

SWEP.ViewModel = "models/weapons/v_manhack.mdl"
SWEP.WorldModel = "models/weapons/w_manhack.mdl"
SWEP.Slot = 2

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()

	if not SERVER then return end

	local manhack = ents.Create("npc_manhack")
	manhack:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
	manhack:SetAngles(self.Owner:EyeAngles())
	manhack:AddRelationship("player D_LI 99")
	manhack:Spawn()

	local phys = manhack:GetPhysicsObject()
	local shotLength = tr.HitPos:Length()
	phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() * math.pow(shotLength, 3))
end