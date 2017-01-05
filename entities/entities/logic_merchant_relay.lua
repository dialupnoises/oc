AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"
ENT.purchaseSound = nil

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Cost")
	self:NetworkVar("Float", 1, "MaxPointsToTake")
	self:NetworkVar("Bool", 0, "Enabled")
	self:NetworkVar("Bool", 1, "Shared")
	self:NetworkVar("Bool", 2, "Announce")
	self:NetworkVar("String", 0, "PurchaseSound")
	self:NetworkVar("String", 1, "PurchaseName")

	self:SetEnabled(true)
end

function ENT:AcceptInput(input, activator, caller, data)
	-- For whatever reason, the "Use" output sets the activator and caller to the same thing,
	-- so we use this dirty hack.
	if caller.lastUseActivator ~= nil then
		activator = caller.lastUseActivator
	end

	if input == "Enable" then
		self:SetEnabled(true)
		return true
	end

	if input == "Purchase" and not self:GetEnabled() then
		self:TriggerOutput("OnDisabled", activator)
	end

	if not self:GetEnabled() then return true end
	if input == "Disable" then
		self:SetEnabled(false)
		return true
	elseif input == "Purchase" then
		local points = OC.Points.getPoints(activator)

		if self:GetShared() and points > 0 then
			if self:GetMaxPointsToTake() > 0 then
				local spent = math.min(self:GetCost(), math.min(points, self:GetMaxPointsToTake()))
				if spent > 0 then
					OC.Points.removePoints(activator, spent)
					self:SetCost(points - spent)
				end
			else 
				local spent = math.min(self:GetCost(), points)
				OC.Points.removePoints(activator, spent)
				self:SetCost(points - spent)
			end

			self:TriggerOutput("OnCashReduced", activator)
			if self:GetCost() <= 0 then
				self:TriggerOutput("OnPurchased", activator)
				playPurchaseSound(self)
			end
		elseif self:GetCost() <= points then
			OC.Points.removePoints(activator, self:GetCost())
			self:TriggerOutput("OnPurchased", activator)
			playPurchaseSound(self)
		elseif self:GetCost() > points then
			self:TriggerOutput("OnNotEnoughCash", activator)
			sendNotEnoughMessage(self, activator)
		end
	elseif input == "SetPurchaseCost" then
		self:SetCost(tonumber(data))
	elseif input == "SetPurchaseName" then
		self:SetPurchaseName(data)
	end
	return false
end

function ENT:KeyValue(key, value)
	if key == "CostOf" then
		self:SetCost(tonumber(value))
	elseif key == "StartDisabled" then
		self:SetEnabled(value ~= "1")
	elseif key == "IsShared" then
		self:SetShared(value == "1")
	elseif key == "AnnounceCashNeeded" then
		self:SetAnnounce(value == "1")
	elseif key == "purchasesound" then
		self:SetPurchaseSound(value)
	elseif key == "MaxPointsTake" then
		self:SetMaxPointsToTake(tonumber(value))
	elseif key == "PurchaseName" then
		self:SetPurchaseName(value)
	end

	if string.Left(key, 2) == "On" then
		self:StoreOutput(key, value)
	end

	return false
end

function playPurchaseSound(self)
	self.purchaseSound = Sound(self:GetPurchaseSound())
	sound.Play(self.purchaseSound, self:GetPos(), 75, 100, 1)
end

function sendNotEnoughMessage(self, ply)
	net.Start("OCLogicMerchantRelay_NotEnoughCash")
	net.WriteFloat(self:GetCost())
	net.WriteString(self:GetPurchaseName())
	net.Send(ply)
end

if SERVER then
	util.AddNetworkString("OCLogicMerchantRelay_NotEnoughCash")
end

net.Receive("OCLogicMerchantRelay_NotEnoughCash", function(len, ply)
	local cost = net.ReadFloat()
	local name = net.ReadString()

	chat.AddText(Color(200, 0, 0), "You need " .. cost .. " points to buy a "  .. name .. "!")
end)