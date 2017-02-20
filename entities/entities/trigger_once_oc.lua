AddCSLuaFile()

ENT.Type = "brush"
ENT.Base = "base_brush"
ENT.IsMultiple = false
ENT.touchAmount = 0

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "FilterEnt")
	self:NetworkVar("Bool", 0, "Disabled")
	self:NetworkVar("Int", 0, "ResetDelay")
end

local function checkFilter(self, ent)
	if self:HasSpawnFlags(4096) and ent:IsPlayer() and ent:IsBot() then
		return false
	end
	
	if self:GetFilterEnt() ~= nil then
		local filterEnts = ents.FindByName(self:GetFilterEnt())
		if #filterEnts > 0 and IsValid(filterEnts[1]) then
			local result = filterEnts[1]:PassesFilter(self, ent)
			if not result then 
				return false 
			end
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

	if self.queuedQutputs ~= nil then
		for k, v in pairs(self.queuedQutputs) do
			self:CallAllOutputs(v[1], v[2])
		end
	end
end

function ENT:Touch(ent)
	if self:GetDisabled() then return end
	if not checkFilter(self, ent) then return end

	self:CallAllOutputs("OnTrigger", ent)
	if (not self.IsMultiple) or self:GetResetDelay() == -1 then
		self:Remove()
	end

	if self:GetResetDelay() > 0 then
		self:SetDisabled(true)
		timer.Simple(self:GetResetDelay(), function()
			self:SetDisabled(false)
		end)
	end
end

function ENT:StartTouch(ent)
	if self:GetDisabled() then return end
	if not checkFilter(self, ent) then return end
	self.touchAmount = self.touchAmount + 1

	self:CallAllOutputs("OnStartTouch", ent)
	if self.touchAmount == 1 then
		self:CallAllOutputs("OnStartTouchAll", ent)
	end
end

function ENT:EndTouch(ent)
	if self:GetDisabled() then return end
	if not checkFilter(self, ent) then return end
	self.touchAmount = self.touchAmount - 1

	self:CallAllOutputs("OnEndTouch", ent)
	if self.touchAmount == 0 then
		self:CallAllOutputs("OnEndTouchAll", ent)
	end
end

function ENT:AcceptInput(name, activator, called, data)
	if name == "Toggle" then
		self:SetDisabled(not self:GetDisabled())
	elseif name == "Enable" then
		self:SetDisabled(false)
	elseif name == "Disable" then
		self:SetDisabled(true)
	elseif name == "TouchTest" then
		if self.triggerAmount == 0 then
			self:CallAllOutputs("OnTouching", nil)
		else
			self:CallAllOutputs("OnNotTouching", nil)
		end
	end
end

function ENT:KeyValue(key, value)
	if key == "filtername" then
		self:SetFilterEnt(value)
	elseif key == "StartDisabled" then
		if self:GetName() == "Final_Trigger" then
			self:SetDisabled(true)
		else
			self:SetDisabled(value == "1")
		end
	elseif key == "wait" then
		self:SetResetDelay(tonumber(value))
	elseif key ~= nil and string.Left(key, 2) == "On" then
		self:StoreOutput(key, value)
		self.triggerOutputs = self.triggerOutputs or {}
		self.outputsUsedCount = self.outputsUsedCount or {}
		self.outputsUsedCount[key .. value] = 0
		if self.triggerOutputs[key] == nil then
			self.triggerOutputs[key] = { value }
		else
			table.insert(self.triggerOutputs[key], value)
		end
	end
end

function ENT:CallAllOutputs(name, activator)
	if not self.triggerOutputs then 
		self.queuedOutputs = self.queuedOutputs or {}
		table.insert(self.queuedOutputs, {name, activator})
		return
	end
	if not self.triggerOutputs[name] then return end

	for k, v in pairs(self.triggerOutputs[name]) do
		self:SendOutput(name, v, activator)
	end
end

function ENT:SendOutput(name, output, activator)
	local outputParts = string.Split(output, ",")
	local targetName = outputParts[1]
	local targetEnt = nil
	if string.equalsi(targetName, "!activator") or string.equalsi(targetName, "!caller") then
		targetEnt = activator
	elseif string.equalsi(targetName, "!self") then
		targetEnt = self
	elseif string.equalsi(targetName, "!player") then
		targetEnt = player.GetAll()[1]
	elseif string.equalsi(targetName, "!pvsplayer") then
		targetEnt = player.FindInPVS(self)[1]
	else
		local foundEnts = ents.FindByName(targetName)
		if #foundEnts == 0 then return end
		targetEnt = foundEnts[1]
	end

	local inputName = outputParts[2]
	local param = outputParts[3]
	local delay = tonumber(outputParts[4])
	local timesUsed = tonumber(outputParts[5])

	function sendOutput()
		if not IsValid(targetEnt) then return end
		targetEnt:Input(inputName, activator, activator, param)
	end

	if timesUsed ~= nil and timesUsed ~= -1 and self.outputsUsedCount[name .. output] >= timesUsed then
		return
	end

	if delay ~= 0 then
		timer.Simple(delay, sendOutput)
	else
		sendOutput()
	end
end