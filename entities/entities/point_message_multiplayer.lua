AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"
ENT.colorObj = Color(255, 255, 255)
ENT.colorText = "255 255 255"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Message")
	self:NetworkVar("String", 1, "TextColor")
	self:NetworkVar("Int", 0, "Radius")
	self:NetworkVar("Bool", 0, "Enabled")
end

function ENT:KeyValue(key, value)
	if key == "message" then
		self:SetMessage(value)
	elseif key == "radius" then
		self:SetRadius(tonumber(value))
	elseif key == "textcolor" then
		self:SetTextColor(value)
	end

	return false
end

function ENT:Initialize()
	self:SetEnabled(not self:HasSpawnFlags(1))
	hook.Add("HUDPaintBackground", "HUDBG_pmm_" .. self:EntIndex(), function()
		if not IsValid(self) then
			hook.Remove("HUDPaintBackground", "HUDBG_pmm_" .. self:EntIndex())
		else
			drawText(self)
		end
	end)
end

function drawText(self)
	if not self:GetEnabled() then return end
	if self:GetPos():Distance(LocalPlayer():GetPos()) > self:GetRadius() then return end
	if self:GetTextColor() ~= self.colorText then
		self.colorText = self:GetTextColor()
		local parts = string.Split(self.colorText, " ")
		self.colorObj = Color(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
	end

	local pos = self:GetPos():ToScreen()

	if not pos.visible then return end
	local messageTextData = {
		text = self:GetMessage(),
		font = "DebugFixed",
		pos = { pos.x, pos.y },
		xalign = TEXT_ALIGN_CENTER,
		color = self.colorObj
	}
	draw.TextShadow(messageTextData, 1, 255)
	draw.TextShadow(messageTextData, -1, 255)
	draw.Text(messageTextData)
end

function ENT:AcceptInput(name, activator, caller, val)
	if name == "ChangeMessage" then
		self:SetMessage("message", val)
	elseif name == "Enable" then
		self:SetEnabled(true)
	elseif name == "Disable" then
		self:SetEnabled(false)
	end

	return false
end