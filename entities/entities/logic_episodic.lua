AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Enabled")
	self:SetEnabled(true)
end

function ENT:AcceptInput(input, activator, caller, data)
	local inputLower = string.lower(input)

	if inputLower == "enable" then
		self:SetEnabled(true)
	elseif inputLower == "disable" then
		self:SetEnabled(false)
	end 

	if not self:GetEnabled() then return end
	
	if inputLower == "test" then
		if IsMounted("episodic") then
			self:TriggerOutput("OnEpisode1", activator, "1")
		end

		if IsMounted("ep2") then
			self:TriggerOutput("OnEpisode2", activator, "1")
		end
	end

	return false
end

function ENT:KeyValue(key, value)
	local keyLower = string.lower(key)

	if keyLower == "startenabled" then
		self:SetEnabled(data == "1")
	end

	if string.Left(keyLower, 2) == "on" then
		self:StoreOutput(key, value)
	end

	return false
end