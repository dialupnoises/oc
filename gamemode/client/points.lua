function createPoints()
	local panel = vgui.Create("DPanel")
	panel:SetSize(50, 25)
	panel:SetPos(5, 5)
	panel:SetBackgroundColor(Color(0, 0, 0, 150))
	panel:Show()

	local labelLabel = vgui.Create("DLabel")
	labelLabel:SetParent(panel)
	labelLabel:SetText("POINTS")
	labelLabel:SetPos(5, 5)
	labelLabel:SetTextColor(OC.Color)
	labelLabel:SetFont("ObsidianSmall")

	local pointsLabel = vgui.Create("DLabel")
	pointsLabel:SetParent(panel)
	pointsLabel:SetText("000000")
	pointsLabel:SetPos(5, 25)
	pointsLabel:SetTextColor(OC.Color)
	pointsLabel:SetFont("ObsidianSmall")

	surface.SetFont("ObsidianSmall")
	local w, h = surface.GetTextSize("000000")
	panel:SetSize(5 + w + 5, 25 + h + 5)

	function lpad(str, len, char)
	    if char == nil then char = " " end
	    return string.rep(char, len - #str) .. str
	end

	hook.Add("Think", "PointsThink", function()
		local points = tostring(OC.Points.getPoints(LocalPlayer()))
		if #points > 6 then
			pointsLabel:SetText("999999")
		else
			pointsLabel:SetText(lpad(points, 6, "0"))
		end
	end)
end

hook.Add("InitPostEntity", "PointsInitialize", createPoints)