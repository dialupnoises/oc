local transferFrame

function ShowTransferGUI()
	if transferFrame ~= nil and transferFrame:IsVisible() then
		return
	end
	
	transferFrame = vgui.Create("DFrame")
	transferFrame:SetTitle("Transfer Points")
	transferFrame:SetSize(220, 165)
	transferFrame:Center()

	local inputLabel = vgui.Create("DLabel", transferFrame)
	inputLabel:SetPos(11, 30)
	inputLabel:SetText("Points:")

	local inputBox = vgui.Create("DTextEntry", transferFrame)
	inputBox:SetPos(10, 50)
	inputBox:SetSize(200, 20)
	inputBox:SetNumeric(true)
	inputBox:SetText("0")
	inputBox:SetUpdateOnType(true)
	function inputBox:OnValueChange(value)
		if tonumber(value) < 0 then
			inputBox:SetText("0")
		elseif tonumber(value) > OC.Points.getPoints(LocalPlayer()) then
			inputBox:SetText(OC.Points.getPoints(LocalPlayer()))
		end
	end

	local charLabel = vgui.Create("DLabel", transferFrame)
	charLabel:SetPos(11, 70)
	charLabel:SetText("Player:")

	local charSelect = vgui.Create("DComboBox", transferFrame)
	charSelect:SetPos(10, 90)
	charSelect:SetSize(200, 20)
	charSelect:SetValue(player.GetAll()[1]:Nick())
	for _, v in pairs(player.GetAll()) do
	    charSelect:AddChoice(v:Nick(), v:UserID())
	end

	local sendButton = vgui.Create("DButton", transferFrame)
	sendButton:SetPos(10, 125)
	sendButton:SetSize(200, 30)
	sendButton:SetText("Send Points")
	function sendButton:DoClick()
		local _, plyId = charSelect:GetSelected()
		if plyId == nil then
			plyId = player.GetAll()[1]:UserID()
		end

		local pointCount = tonumber(inputBox:GetText())
		net.Start("send_points")
		net.WriteInt(pointCount, 32)
		net.WriteInt(plyId, 32)
		net.SendToServer()
	end

	transferFrame:MakePopup()
end