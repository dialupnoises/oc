AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.weapons = {}
ENT.items = {}
ENT.merchantLastUsed = 0
ENT.iconMaterial = nil
ENT.AutomaticFrameAdvance = true

if SERVER then
	util.AddNetworkString("OCNPCMerchant_Use")
	util.AddNetworkString("OCNPCMerchant_BuyWeapon")
	util.AddNetworkString("OCNPCMerchant_BuyItem")
end

function ENT:Initialize()
	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetSolid(SOLID_BBOX)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetHealth(100)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "IconHeight")
	self:NetworkVar("String", 0, "IconMaterial")
	self:NetworkVar("String", 1, "ExpressionOverride")
	self:NetworkVar("String", 2, "MerchantName")
	self:NetworkVar("Bool", 0, "ShowIcon")
	self:SetShowIcon(true)
	self:SetIconHeight(80)
end

function ENT:KeyValue(key, value)
	if key == "model" then
		self:SetModel(value)
		self:SetSequence(self:LookupSequence("LineIdle03"))
	elseif key == "npcname" then
		self:SetNWString("npcname", value)
	elseif key == "IconHeight" then
		self:SetIconHeight(tonumber(value))
	elseif key == "MerchantIconMaterial" then
		self:SetIconMaterial(value)
	elseif key == "ExpressionOverride" then
		self:SetExpression(value)
	elseif key == "ShowIcon" then
		self:SetShowIcon(value == "1")
	elseif key == "MerchantScript" then
		local result = file.Read("scripts/merchants/" .. value .. ".txt", "GAME")
		if result == nil then
			error("Can't find merchant script " .. value)
		end

		local kv = util.KeyValuesToTable(result)
		self:SetMerchantName(kv["name"])

		self.weapons = kv["weapons"]
		self.items = kv["items"]
	end
end

function ENT:NPCUse(activator, caller, type, value)
	if CurTime() - self.merchantLastUsed < 1 then return end
	self.merchantLastUsed = CurTime()
	net.Start("OCNPCMerchant_Use")
	net.WriteEntity(self)
	net.WriteString(self:GetMerchantName())
	net.WriteTable(self.weapons)
	net.WriteTable(self.items)
	net.Send(activator)
end

function ENT:OnTakeDamage(dmg)

end

function ENT:Draw()
	self:DrawModel()

	if self:GetIconMaterial() == nil then return end
	if self.iconMaterial == nil then
		local mat = self:GetIconMaterial()
		self.iconMaterial = Material(self:GetIconMaterial())
	end

	local pos = self:GetPos() + Vector(0, 0, self:GetIconHeight())
	local eyeAng = self:EyeAngles().y - 90
	local ang = Angle(0, eyeAng, -90)

	cam.Start3D2D(pos, ang, 0.2)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(self.iconMaterial)
		surface.DrawTexturedRect(-(self.iconMaterial:Width() / 2), 0, self.iconMaterial:Width(), self.iconMaterial:Height())
	cam.End3D2D()
end

net.Receive("OCNPCMerchant_BuyWeapon", function(len, ply)
	local merchant = net.ReadEntity()
	if not merchant.weapons then return end
	local weapon = net.ReadString()
	if not merchant.weapons[weapon] then return end
	local price = merchant.weapons[weapon]
	if not OC.Points.hasAmount(ply, price) then return end
	OC.Points.removePoints(ply, price)
	ply:Give(weapon)
end)

net.Receive("OCNPCMerchant_BuyItem", function(len, ply)
	local merchant = net.ReadEntity()
	if not merchant.items then return end
	local item = net.ReadString()
	if not merchant.items[item] then return end
	local price = merchant.items[item]
	local amount = net.ReadInt(8)
	if not OC.Points.hasAmount(ply, price * amount) then return end
	OC.Points.removePoints(ply, price * amount)
	for i=1,amount do
		ply:Give(item)
	end
end)