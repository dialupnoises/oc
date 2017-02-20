AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

ENT.PrintName = "Game Text Quick"
ENT.Spawnable = false

local channels = {}

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Message")
	self:NetworkVar("String", 1, "TextColor")
	self:NetworkVar("Float", 0, "X")
	self:NetworkVar("Float", 1, "Y")
	self:NetworkVar("Float", 2, "FadeInTime")
	self:NetworkVar("Float", 3, "FadeOutTime")
	self:NetworkVar("Float", 4, "HoldTime")
	self:NetworkVar("Int", 0, "Channel")

	self:SetX(-1)
	self:SetY(-1)
	self:SetFadeInTime(1.5)
	self:SetFadeOutTime(0.5)
	self:SetHoldTime(1.2)
	self:SetTextColor("100 100 100")
	self:SetChannel(1)
end

function ENT:AcceptInput(name, activator, caller, val)
	if name == "Display" then
		net.Start("oc_game_text_quick_display")
		net.WriteEntity(self)
		if self:HasSpawnFlags(1) then
			net.Send(activator)
		else
			net.Broadcast()
		end
	elseif name == "DisplayText" then
		if val == nil then return end
		self:SetMessage(val)
		net.Start("oc_game_text_quick_display")
		net.WriteEntity(self)
		if self:HasSpawnFlags(1) then
			net.Send(activator)
		else
			net.Broadcast()
		end
	end

	return false
end

function ENT:KeyValue(key, value)
	if key == "message" then
		self:SetMessage(value)
	elseif key == "x" then
		self:SetX(tonumber(value))
	elseif key == "y" then
		self:SetY(tonumber(value))
	elseif key == "fadein" then
		self:SetFadeInTime(tonumber(value))
	elseif key == "fadeout" then
		self:SetFadeOutTime(tonumber(value))
	elseif key == "holdtime" then
		self:SetHoldTime(tonumber(value))
	elseif key == "color1" then
		self:SetTextColor(value)
	elseif key == "channel" then
		self:SetChannel(tonumber(value))
	end
end

if SERVER then
	util.AddNetworkString("oc_game_text_quick_display")
end

net.Receive("oc_game_text_quick_display", function(len, ply)
	local ent = net.ReadEntity()
	channels[ent:GetChannel()] = {
		message = ent:GetMessage(),
		x = ent:GetX(),
		y = ent:GetY(),
		fadein = ent:GetFadeInTime(),
		fadeout = ent:GetFadeOutTime(),
		holdtime = ent:GetHoldTime(),
		color = StringToColor(ent:GetTextColor()),
		state = "fadein",
		timer = ent:GetFadeInTime()
	}
	MsgN(channels[ent:GetChannel()])
end)

function DrawChannel(c)
	local a = 0
	c.timer = c.timer - FrameTime()
	if c.state == "fadein" then
		a = 255 * (1 - c.timer / c.fadein)
		if c.timer < 0 then 
			c.state = "hold"
			c.timer = c.holdtime
		end
	elseif c.state == "hold" then
		a = 255
		if c.timer < 0 then
			c.state = "fadeout"
			c.timer = c.fadeout
		end
	elseif c.state == "fadeout" then
		a = 255 * (c.timer / c.fadeout)
		if c.timer < 0 then
			return nil
		end
	end

	surface.SetFont("CloseCaption_Bold")
	local w, h = surface.GetTextSize(c.message)

	local x = 0
	local y = 0
	if c.x == -1 then
		x = ScrW() / 2 - w / 2
	else
		x = ScrW() * c.x - w * c.x
	end

	if c.y == -1 then
		y = ScrH() / 2 - h / 2
	else
		y = ScrH() * c.y - h * c.y
	end

	surface.SetTextColor(ColorAlpha(c.color, a))
	surface.SetTextPos(x, y)
	surface.DrawText(c.message)
	
	return c
end

hook.Add("HUDPaint", "oc_game_text_quick_paint", function()
	for k, v in pairs(channels) do
		if v ~= nil then
			channels[k] = DrawChannel(v)
		end
	end
end)