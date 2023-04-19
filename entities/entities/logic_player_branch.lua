AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

ENT.LivePlayersOnly = false
ENT.InitialValue = 0
ENT.StrictEqualTo = false

function ENT:AcceptInput(input, activator, caller, data)
	local inputLower = string.lower(input)

	if inputLower == "setvalue" then
		self.InitialValue = tonumber(data) or 0
	elseif inputLower == "setvaluetest" then
		self.InitialValue = tonumber(data) or 0
		self:DoTest(activator)
	elseif inputLower == "test" then
		self:DoTest(activator)
	end 

	return false
end

function ENT:KeyValue(key, value)
	local keyLower = string.lower(key)

	if keyLower == "initialvalue" then
		self.InitialValue = tonumber(value)
	elseif keyLower == "spawnflags" then
		self.LivePlayersOnly = value == "1"
	elseif keyLower == "strictequalto" then
		self.StrictEqualTo = value == "1"
	end

	if string.Left(keyLower, 2) == "on" then
		self:StoreOutput(key, value)
	end

	return false
end

function ENT:DoTest(activator)
	local numPlayers = 0
	if self.LivePlayersOnly then
		for k, v in ipairs(player.GetAll()) do
			if v:Alive() then
				numPlayers = numPlayers + 1
			end
		end
	else 
		numPlayers = player.GetCount()
	end

	local result = false 
	if self.StrictEqualTo then 
		result = self.InitialValue == numPlayers 
	else
		result = numPlayers >= self.InitialValue
	end

	if result then
		self:TriggerOutput("OnTrue", activator, "1")
	else
		self:TriggerOutput("OnFalse", activator, "0")
	end
end