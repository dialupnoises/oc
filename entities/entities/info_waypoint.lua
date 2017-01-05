AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

if SERVER then
	util.AddNetworkString("EnableWaypointOC")
	util.AddNetworkString("DisableWaypointOC")
end

local ICON_WIDTH = 32
local ICON_HEIGHT = 32

ENT.imageSprite = nil
ENT.waypointEnabled = nil

function ENT:Initialize()
	if CLIENT then
		hook.Add("PostDrawHUD", "PostDrawHUD_waypoint_" .. self:EntIndex(), function()
			if not self.waypointEnabled then return end

			local pos = self:GetPos():ToScreen()
			local scrX = math.max(pos.x, 0)
			local scrY = math.max(pos.y, 0)

			-- draw icon
			local iconX = math.min(ScrW() - ICON_WIDTH, scrX)
			local iconY = math.min(ScrH() - ICON_HEIGHT, scrY) 
			render.SetMaterial(self.imageSprite)
			render.DrawScreenQuadEx(iconX, iconY, ICON_WIDTH, ICON_HEIGHT)
			
			-- draw text
			-- distance is in meters - 1 ft in source engine is 16 units, and 1 meter is ~3.28 feet,
			-- so 1 meter is 3.28 * 16 = ~52.5
			local distance = math.ceil(self:GetPos():Distance(LocalPlayer():GetPos()) / 52.5)
			local text = self:GetText() .. "\n" .. distance .. " m"

			surface.SetFont("ChatFont")
			local w, h = surface.GetTextSize(text)

			local alignment = TEXT_ALIGN_LEFT
			local textX = iconX + ICON_WIDTH + 5
			if textX + w > ScrW() then
				textX = iconX - 5
				alignment = TEXT_ALIGN_RIGHT
			end

			draw.DrawText(text, "ChatFont", textX, iconY, Color(255, 255, 255), alignment)
		end)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Image", { KeyName = "image" })
	self:NetworkVar("String", 1, "Text", { KeyName = "text" })
end

function ENT:AcceptInput(name, activator, caller, val)
	if name == "Enable" or name == "EnableForActivator" then
		local duration = tonumber(val)
		net.Start("EnableWaypointOC")
		net.WriteEntity(self)
		net.WriteFloat(duration)

		if name == "EnableForActivator" then
			net.Send(activator)
		else
			net.Broadcast()
		end

		self.waypointEnabled = true
		if duration > 0 then
			timer.Create("OCWaypoint" .. self:EntIndex(), duration, 0, function()
				self.waypointEnabled = false
			end)
		end

		return true
	elseif name == "Disable" or name == "DisableForActivator" then
		net.Start("DisableWaypointOC")
		net.WriteEntity(self)

		if name == "DisableForActivator" then
			net.Send(activator)
		else
			net.Broadcast()
		end

		self.waypointEnabled = false
		if timer.Exists("OCWaypoint" .. self:EntIndex()) then
			timer.Remove("OCWaypoint" .. self:EntIndex())
		end

		return true
	end

	return false
end

function ENT:KeyValue(key, value)
	if key == "image" then
		self:SetImage(value)
	elseif key == "text" then
		self:SetText(value)
	end
end

-- CLIENT
net.Receive("EnableWaypointOC", function(len, ply)
	local waypoint = net.ReadEntity()
	local duration = net.ReadFloat()

	if waypoint.imageSprite == nil then
		waypoint.imageSprite = Material(waypoint:GetImage())
	end

	waypoint.waypointEnabled = true
	if duration > 0 then
		timer.Create("OCWaypoint" .. waypoint:EntIndex(), duration, 0, function()
			waypoint.waypointEnabled = false
		end)
	end
end)

net.Receive("DisableWaypointOC", function(len, ply)
	local waypoint = net.ReadEntity()

	waypoint.waypointEnabled = false
	if timer.Exists("OCWaypoint" .. waypoint:EntIndex()) then
		timer.Remove("OCWaypoint" .. waypoint:EntIndex())
	end
end)