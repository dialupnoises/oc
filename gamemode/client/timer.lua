OC.Timer.Time = 0
OC.Timer.Running = false
OC.Timer.Display = false
OC.Timer.Label = "Timer"

local panel = vgui.Create("DPanel")
panel:SetSize(500, 100)
panel:SetPos(ScrW() / 2 - 250, 0)
panel:SetBackgroundColor(Color(0, 0, 0, 0.5))
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

function setTimeText()
	timeLabel:SetText(os.date("!%X", OC.Timer.Time))
	surface.SetFont("ObsidianLarge")
	w, h = surface.GetTextSize(timeLabel:GetText())
	timeLabel:SetPos(250 - w / 2, 30)
end

function setLabel()
	labelLabel:SetText(OC.Timer.Label)
	surface.SetFont("ObsidianMedium")
	w, h = surface.GetTextSize(OC.Timer.Label)
	labelLabel:SetPos(250 - w / 2, 5)
end

OC.Timer.Start = function(time)
	OC.Timer.Display = true
	OC.Timer.Running = true
	OC.Timer.Time = time
	setTimeText()
	panel:Show()
end

OC.Timer.Tick = function()
	if not OC.Timer.Running then
		return
	end
	Msg(OC.Timer.Time)
	OC.Timer.Time = OC.Timer.Time - FrameTime()
	if OC.Timer.Time < 0 then
		OC.Timer.Running = false
		OC.Timer.Display = false
		panel:Hide()
	end
	setTimeText()
end

OC.Timer.Stop = function()
	OC.Timer.Running = false
	OC.Timer.Time = -1
	panel:Hide()
end

OC.Timer.Pause = function()
	OC.Timer.Running = false
end

OC.Timer.Resume = function()
	if OC.Timer.Time ~= -1 then
		OC.Timer.Running = true
	end
end

usermessage.Hook("game_countdown_timer_start", function(data) 
	OC.Timer.Start(data:ReadLong())
end)

usermessage.Hook("game_countdown_timer_label", function(data)
	OC.Timer.Label = data:ReadString()
	setLabel()
end)

usermessage.Hook("game_countdown_timer_pause", function(data)
	OC.Timer.Pause()
end)

usermessage.Hook("game_countdown_timer_resume", function(data)
	OC.Timer.Resume()
end)

usermessage.Hook("game_countdown_timer_stop", function(data)
	OC.Timer.Stop()
end)