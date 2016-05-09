AddCSLuaFile()

ENT.Type = "brush"
ENT.Base = "base_gmodentity"
ENT.IsMultiple = false
ENT.touchAmount = 0

function checkFilter(self, ent)
	if self:HasSpawnFlags(4096) and ent:IsPlayer() and ent:IsBot() then
		return false
	end
	
	if IsValid(self:GetNWEntity("filterEnt")) then
		local result = ent:PassesFilter(self, self:GetNWEntity("filterEnt"))
		if not result then 
			return false 
		end
	end

	if self:HasSpawnFlags(64) then
		return true
	end

	if ent:GetClass() == "func_pushable" and not self:HasSpawnFlags(4) then
		return false
	end

	if self:HasSpawnFlags(16) then
		if not ent:IsNPC() then
			return false
		end
		
		if ent:Disposition(player.GetHumans[1]) == D_HT then
			return false
		end

		return true
	end

	if self:HasSpawnFlags(32) then
		if ent:IsPlayer() and ent:InVehicle() then
			return true
		end

		if not ent:IsVehicle() then
			return false
		end

		if IsValid(ent:GetDriver()) and not ent:GetDriver():IsNPC() then
			return true
		end

		return false
	end

	if self:HasSpawnFlags(512) then
		if not ent:IsPlayer() then
			return false
		end

		if ent:InVehicle() then
			return false
		end

		return true
	end
	
	if self:HasSpawnFlags(2048) then
		if not ent:IsVehicle() then
			return false
		end

		if IsValid(ent:GetDriver()) and ent:GetDriver():IsNPC() then
			return true
		end

		return false
	end
	
	if ent:IsPlayer() and not self:HasSpawnFlags(1) then
		return false
	end
	
	if ent:IsNPC() and not self:HasSpawnFlags(2) then
		return false
	end
	
	return true
end

function ENT:Initialize()
	if SERVER then
		self:SetTrigger(true)
	end
end

function ENT:Touch(ent)
	if self:GetNWBool("disabled") then return end
	if not checkFilter(self, ent) then return end

	self:TriggerOutput("OnTrigger", ent)
	if (not self.IsMultiple) or self:GetNWInt("resetDelay") == -1 then
		self:Remove()
	end

	if self:GetNWInt("resetDelay") > 0 then
		self:SetNWBool("disabled", true)
		timer.Simple(self:GetNWInt("resetDelay"), function()
			self:SetNWBool("disabled", false)
		end)
	end
end

function ENT:StartTouch(ent)
	if self:GetNWBool("disabled") then return end
	if not checkFilter(self, ent) then return end
	self.touchAmount = self.touchAmount + 1

	self:TriggerOutput("OnStartTouch", ent)
	if self.touchAmount == 1 then
		self:TriggerOutput("OnStartTouchAll", ent)
	end
end

function ENT:EndTouch(ent)
	if self:GetNWBool("disabled") then return end
	if not checkFilter(self, ent) then return end
	self.touchAmount = self.touchAmount - 1
	self:TriggerOutput("OnEndTouch", ent)
	if self.touchAmount == 0 then
		self:TriggerOutput("OnEndTouchAll", ent)
	end
end

function ENT:AcceptInput(name, activator, called, data)
	if name == "Toggle" then
		self:SetNWBool("disabled", not self:GetNWBool("disabled"))
	elseif name == "Enable" then
		self:SetNWBool("disabled", false)
	elseif name == "Disable" then
		self:SetNWBool("disabled", true)
	elseif name == "TouchTest" then
		if self.triggerAmount == 0 then
			self:TriggerOutput("OnTouching", nil)
		else
			self:TriggerOutput("OnNotTouching", nil)
		end
	end
end

function ENT:KeyValue(key, value)
	if key == "filtername" then
		local results = ents.FindByName(value)
		if #results == 0 then return end
		self:SetNWEntity("filterEnt", results[1])
	elseif key == "StartDisabled" then
		if self:GetName() == "Final_Trigger" then
			self:SetNWBool("disabled", true)
		else
			self:SetNWBool("disabled", value == "1")
		end
	elseif key == "wait" then
		self:SetNWInt("resetDelay", tonumber(value))
	elseif key ~= nil and string.Left(key, 2) == "On" then
		self:StoreOutput(key, value)
	end
end