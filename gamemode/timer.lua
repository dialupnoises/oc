OC.Timer.Time = 0
OC.Timer.Running = false
OC.Timer.Display = false
OC.Timer.Label = "Timer"

local panelWidth = 250

OC.Timer.guiItems = nil 
OC.Timer.ServerStartTime = 0
OC.Timer.ClientLastUpdateTime = 0

function initTimerPanel()
	local panel = vgui.Create("DPanel")
	panel:SetSize(panelWidth, 100)
	panel:SetPos(ScrW() / 2 - (panelWidth / 2), 0)
	panel:SetBackgroundColor(Color(0, 0, 0, 150))
	panel:Hide()

	local labelLabel = vgui.Create("DLabel")
	labelLabel:SetParent(panel)
	labelLabel:SetText("Timer")
	labelLabel:SetPos(250, 5)
	labelLabel:SetTextColor(OC.Color)
	labelLabel:SetFont("ObsidianMedium")
	
	local timeLabel = vgui.Create("DLabel")
	timeLabel:SetParent(panel)
	timeLabel:SetText("00:00:00")
	timeLabel:SetPos(250, 30)
	timeLabel:SetTextColor(OC.Color)
	timeLabel:SetFont("ObsidianLarge")

	OC.Timer.guiItems = {
		panel = panel,
		label = labelLabel,
		time = timeLabel
	}
end

function setTimeText()
	if OC.Timer.guiItems == nil then
		initTimerPanel()
	end

	OC.Timer.guiItems.time:SetText(os.date("!%X", OC.Timer.Time))
	surface.SetFont("ObsidianLarge")
	w, h = surface.GetTextSize(OC.Timer.guiItems.time:GetText())
	OC.Timer.guiItems.time:SetPos((panelWidth / 2) - w / 2, 30)
	OC.Timer.guiItems.time:SetSize(w, h)

	OC.Timer.guiItems.panel:SetPos(ScrW() / 2 - (panelWidth / 2), 10)
	OC.Timer.guiItems.panel:SetSize(panelWidth, 30 + h + 20)
end

function setLabel()
	if OC.Timer.guiItems == nil then
		initTimerPanel()
	end

	OC.Timer.guiItems.label:SetText(OC.Timer.Label)
	surface.SetFont("ObsidianMedium")
	w, h = surface.GetTextSize(OC.Timer.Label)
	OC.Timer.guiItems.label:SetPos((panelWidth / 2) - w / 2, 10)
	OC.Timer.guiItems.label:SetSize(w, h)
end

OC.Timer.Start = function(time)
	OC.Timer.Running = true
	OC.Timer.Time = time

	if SERVER then
		OC.Timer.ServerStartTime = RealTime()

		net.Start("game_countdown_timer_start")
			net.WriteInt(time, 32)
		net.Broadcast()
	else
		if OC.Timer.guiItems == nil then
			initTimerPanel()
		end
		
		OC.Timer.Display = true
		OC.Timer.ClientLastUpdateTime = RealTime()
		setTimeText()
		setLabel()
		OC.Timer.guiItems.panel:Show()
	end
end

OC.Timer.Tick = function()
	if not OC.Timer.Running then
		return
	end

	local timeChange = RealTime() - OC.Timer.ClientLastUpdateTime
	OC.Timer.Time = OC.Timer.Time - timeChange
	if OC.Timer.Time < 0 then
		OC.Timer.Running = false
		OC.Timer.Display = false
		if OC.Timer.guiItems == nil then
			initTimerPanel()
		end

		OC.Timer.guiItems.panel:Hide()
	end
	setTimeText()
end

OC.Timer.Stop = function()
	OC.Timer.Running = false
	OC.Timer.Time = -1

	if SERVER then
		net.Start("game_countdown_timer_stop")
		net.Broadcast()
	else
		if OC.Timer.guiItems == nil then
			initTimerPanel()
		end

		OC.Timer.guiItems.panel:Hide()
	end
end

OC.Timer.Pause = function()
	OC.Timer.Running = false

	if SERVER then
		-- save time so far
		OC.Timer.Time = OC.Timer.Time - (RealTime() - OC.Timer.ServerStartTime)
		net.Start("game_countdown_timer_pause")
		net.Broadcast()
	end
end

OC.Timer.Resume = function()
	if OC.Timer.Time ~= -1 then
		OC.Timer.Running = true

		if SERVER then
			OC.Timer.ServerStartTime = RealTime()
		else
			OC.Timer.ClientLastUpdateTime = RealTime()
		end
	end

	if SERVER then
		net.Start("game_countdown_timer_resume")
		net.Broadcast()
	end
end

OC.Timer.SetLabel = function(str)
	OC.Timer.Label = str

	if SERVER then
		net.Start("game_countdown_timer_label")
			net.WriteString(str)
		net.Broadcast()
	else
		setLabel()
	end
end

OC.Timer.UpdateClientTime = function()
	if SERVER then
		-- keep all clients in sync with what the server knows the timer is
		net.Start("game_countdown_timer_update")
			local time = OC.Timer.Time
			if OC.Timer.Running then
				time = time - (RealTime() - OC.Timer.ServerStartTime)
			end

			net.WriteFloat(time)
		net.Broadcast()
	end
end

-- called when a local player needs an updated time (like a player just joined)
OC.Timer.UpdateNewPlayer = function()
	net.Start("game_countdown_timer_ply_needs_update")
	net.SendToServer()
end

if SERVER then
	util.AddNetworkString("game_countdown_timer_start")
	util.AddNetworkString("game_countdown_timer_label")
	util.AddNetworkString("game_countdown_timer_pause")
	util.AddNetworkString("game_countdown_timer_resume")
	util.AddNetworkString("game_countdown_timer_stop")
	util.AddNetworkString("game_countdown_timer_update")
	util.AddNetworkString("game_countdown_timer_ply_needs_update")
	util.AddNetworkString("game_countdown_timer_ply_update")
end

net.Receive("game_countdown_timer_start", function(len, ply)
	OC.Timer.Start(net.ReadInt(32))
end)

net.Receive("game_countdown_timer_label", function(len, ply)
	OC.Timer.SetLabel(net.ReadString())
end)

net.Receive("game_countdown_timer_pause", function(len, ply)
	OC.Timer.Pause()
end)

net.Receive("game_countdown_timer_resume", function(len, ply)
	OC.Timer.Resume()
end)

net.Receive("game_countdown_timer_stop", function(len, ply)
	OC.Timer.Stop()
end)

net.Receive("game_countdown_timer_update", function(len, ply)
	OC.Timer.Time = net.ReadFloat()
	OC.Timer.ClientLastUpdateTime = RealTime()
	setTimeText()
end)

net.Receive("game_countdown_timer_ply_needs_update", function(len, ply)
	net.Start("game_countdown_timer_ply_update")
		net.WriteBool(OC.Timer.Running)
		net.WriteFloat(OC.Timer.Time - (RealTime() - OC.Timer.ServerStartTime))
		net.WriteString(OC.Timer.Label)
	net.Send(ply)
end)

net.Receive("game_countdown_timer_ply_update", function(len, ply)
	OC.Timer.Running = net.ReadBool()
	OC.Timer.Time = net.ReadFloat()
	OC.Timer.Label = net.ReadString()
	OC.Timer.Display = OC.Timer.Running and OC.Timer.Time > 0

	setLabel()
	setTimeText()
end)