local pointsTimer = 0
local pointsTimerMax = 2
local pointChangeAmt = 0

function drawPoints()
	local points = OC.Points.getPoints(LocalPlayer())
	local str = "000000000" .. math.abs(points)
	local digits = 9
	if points ~= 0 then
		digits = math.max(math.ceil(math.log10(math.abs(points))), 9)
	end 

	local pointsStr = string.Right(str, digits)
	if points < 0 then 
		if points > 99999999 then 
			pointsStr = "-" .. pointsStr
		else
			pointsStr = "-" .. string.Right(pointsStr, 8)
		end
	end

	surface.SetFont("ChatFont")
	local w, h = surface.GetTextSize(pointsStr)
	draw.RoundedBox(5, 5, 5, w + 10, 40, Color(0, 0, 0, 200))

	draw.Text({
		text = "Score:",
		font = "ObsidianSmall",
		pos = {10, 10},
		color = OC.LightestBlue
	})

	local textObj = {
		text = pointsStr,
		font = "ChatFont",
		pos = {10, 25},
		color = OC.LightestBlue
	}

	draw.TextShadow(textObj, 0, 255)
	draw.Text(textObj)

	if pointsTimer > 0 then
		pointsTimer = math.max(0, pointsTimer - FrameTime())
		local alpha = (pointsTimer / pointsTimerMax) * 255
		local color = Color(37, 246, 101, alpha)
		local pointText = "+" .. pointChangeAmt
		if pointChangeAmt < 0 then
			color = Color(222, 107, 34, alpha)
			pointText = pointChangeAmt
		end

		if pointChangeAmt ~= 0 then
			draw.Text({
				text = pointText,
				font = "ChatFont",
				pos = {50, 10},
				color = color
			})
		end
	end
end

hook.Add("HUDPaint", "oc_points_paint", drawPoints)
hook.Add("OCPointsChange", "oc_points_paintchange", function(change)
	if pointsTimer > 0 then
		pointChangeAmt = pointChangeAmt + change
	else
		pointChangeAmt = change
	end
	pointsTimer = pointsTimerMax
end)