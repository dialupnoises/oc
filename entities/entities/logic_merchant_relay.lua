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

	local inputLower = string.lower(input)

	if inputLower == "enable" then
		self:SetEnabled(true)
		return true
	end

	if inputLower == "purchase" and not self:GetEnabled() then
		self:TriggerOutput("OnDisabled", activator)
	end

	if not self:GetEnabled() then return true end
	if inputLower == "disable" then
		self:SetEnabled(false)
		return true
	elseif inputLower == "purchase" then
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
			MsgN("purchased, removing ", self:GetCost(), " points from ", activator)
			OC.Points.removePoints(activator, self:GetCost())
			self:TriggerOutput("OnPurchased", activator)
			playPurchaseSound(self)
		elseif self:GetCost() > points then
			self:TriggerOutput("OnNotEnoughCash", activator)
			sendNotEnoughMessage(self, activator)
		end
	elseif inputLower == "setpurchasecost" then
		self:SetCost(tonumber(data))
	elseif inputLower == "setpurchasename" then
		self:SetPurchaseName(data)
	end
	return false
end

function ENT:KeyValue(key, value)
	local keyLower = string.lower(key)

	if keyLower == "costof" then
		self:SetCost(tonumber(value))
	elseif keyLower == "startdisabled" then
		self:SetEnabled(value ~= "1")
	elseif keyLower == "isshared" then
		self:SetShared(value == "1")
	elseif keyLower == "announcecashneeded" then
		self:SetAnnounce(value == "1")
	elseif keyLower == "purchasesound" then
		self:SetPurchaseSound(value)
	elseif keyLower == "maxpointstake" then
		self:SetMaxPointsToTake(tonumber(value))
	elseif keyLower == "purchasename" then
		self:SetPurchaseName(value)
	end

	if string.Left(keyLower, 2) == "on" then
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