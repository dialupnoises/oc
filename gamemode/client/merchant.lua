local panel, nameLabel
local weaponPriceBox, weaponComboBox, weaponDescText
local itemPriceBox, itemComboBox, itemDescText, itemAmountBox, itemAmountSlider
local merchantEnt

local function displayMerchantWindow(ent, name, weapons, items)
	if panel == nil then
		createMerchantWindow()
	end

	weaponComboBox:Clear()
	weaponComboBox:SetValue("Weapons")
	for k, v in pairs(weapons) do
		weaponComboBox:AddChoice(k, v)
	end

	itemComboBox:Clear()
	itemComboBox:SetValue("Items")
	for k, v in pairs(items) do
		itemComboBox:AddChoice(k, v)
	end

	nameLabel:SetText(name)
	merchantEnt = ent

	gui.EnableScreenClicker(true)
	panel:Show()
end

function createMerchantWindow()
	panel = vgui.Create("DPanel")
	panel:SetSize(450, 450)
	panel:SetPos(100, 120)
	function panel:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, ColorAlpha(OC.Color, 200))
	end

	nameLabel = vgui.Create("DLabel", panel)
	nameLabel:SetPos(0, 0)
	nameLabel:SetSize(450, 90)
	nameLabel:SetFont("ObsidianLarge")
	nameLabel:SetTextColor(OC.YellowColor)
	nameLabel:SetContentAlignment(5)

	-- weapon elements

	local weaponPriceLabel = vgui.Create("DLabel", panel)
	weaponPriceLabel:SetPos(230, 90)
	weaponPriceLabel:SetSize(50, 20)
	weaponPriceLabel:SetFont("ObsidianSmall")
	weaponPriceLabel:SetContentAlignment(4)
	weaponPriceLabel:SetTextColor(OC.YellowColor)
	weaponPriceLabel:SetText("Price:")

	weaponPriceBox = vgui.Create("DTextEntry", panel)
	weaponPriceBox:SetPos(270, 90)
	weaponPriceBox:SetSize(80, 20)
	weaponPriceBox:SetFont("ObsidianSmall")
	weaponPriceBox.AllowInput = function(self, char)
		return true
	end
	function weaponPriceBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		surface.SetTextColor(OC.YellowColor)
		surface.SetFont(self:GetFont())
		self:DrawOutlinedRect()
		surface.SetTextPos(3, 2)
		surface.DrawText(self:GetText())
	end

	weaponComboBox = vgui.Create("DComboBox", panel)
	weaponComboBox:SetPos(45, 115)
	weaponComboBox:SetSize(90, 20)
	weaponComboBox:SetValue("Weapons")
	weaponComboBox:SetFont("ObsidianSmall")
	weaponComboBox:SetTextColor(OC.YellowColor)
	weaponComboBox.selectedWeapon = nil
	function weaponComboBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		self:DrawOutlinedRect()
	end
	function weaponComboBox:OnSelect(index, value, data)
		weaponPriceBox:SetText(data)
		weaponDescText:SetText(OC.Strings["info_" .. value])
		self.selectedWeapon = value
	end

	local buyWeaponButton = vgui.Create("DButton", panel)
	buyWeaponButton:SetPos(45, 140)
	buyWeaponButton:SetSize(90, 20)
	buyWeaponButton:SetText("Buy Weapon")
	buyWeaponButton:SetFont("ObsidianSmall")
	buyWeaponButton:SetTextColor(OC.YellowColor)
	buyWeaponButton.DoClick = function()
		local price = tonumber(weaponPriceBox:GetText())
		if price == nil or weaponComboBox.selectedWeapon == nil then return end
		if not OC.Points.hasAmount(LocalPlayer(), price) then return end
		net.Start("OCNPCMerchant_BuyWeapon")
		net.WriteEntity(merchantEnt)
		net.WriteString(weaponComboBox.selectedWeapon)
		net.SendToServer()
	end
	function buyWeaponButton:Paint(w, h)
		local color = Color(62, 119, 233)
		if buyWeaponButton:IsHovered() then
			color = ColorAlpha(color, 200)
		end
		draw.RoundedBox(5, 0, 0, w, h, color)
	end

	local weaponDescBox = vgui.Create("DScrollPanel", panel)
	weaponDescBox:SetPos(140, 115)
	weaponDescBox:SetSize(210, 110)
	weaponDescBox:GetCanvas():DockPadding(5, 5, 5, 5)
	function weaponDescBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		weaponDescBox:DrawOutlinedRect()
	end

	weaponDescText = vgui.Create("DLabel", weaponDescBox)
	weaponDescText:SetSize(200, 110)
	weaponDescText:SetPos(5, 5)
	weaponDescText:SetWrap(true)
	weaponDescText:SetAutoStretchVertical(true)
	weaponDescText:SetText("Select weapon.")
	weaponDescText:SetFont("ObsidianSmall")
	weaponDescText:SetTextColor(OC.YellowColor)

	-- item elements
	local itemPriceLabel = vgui.Create("DLabel", panel)
	itemPriceLabel:SetPos(230, 230)
	itemPriceLabel:SetSize(50, 20)
	itemPriceLabel:SetFont("ObsidianSmall")
	itemPriceLabel:SetContentAlignment(4)
	itemPriceLabel:SetTextColor(OC.YellowColor)
	itemPriceLabel:SetText("Price:")

	itemPriceBox = vgui.Create("DTextEntry", panel)
	itemPriceBox:SetPos(270, 230)
	itemPriceBox:SetSize(80, 20)
	itemPriceBox:SetFont("ObsidianSmall")
	itemPriceBox:SetFGColor(OC.YellowColor)
	itemPriceBox.AllowInput = function(self, char)
		return true
	end
	function itemPriceBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		surface.SetTextColor(OC.YellowColor)
		surface.SetFont(self:GetFont())
		self:DrawOutlinedRect()
		surface.SetTextPos(3, 2)
		surface.DrawText(self:GetText())
	end

	itemComboBox = vgui.Create("DComboBox", panel)
	itemComboBox:SetPos(45, 255)
	itemComboBox:SetSize(90, 20)
	itemComboBox:SetValue("Items")
	itemComboBox:SetFont("ObsidianSmall")
	itemComboBox:SetTextColor(OC.YellowColor)
	itemComboBox.selectedItem = nil
	function itemComboBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		self:DrawOutlinedRect()
	end
	function itemComboBox:OnSelect(index, value, data)
		itemPriceBox:SetText(data)
		itemDescText:SetText(OC.Strings["info_" .. value])
		self.selectedItem = value
	end

	local buyItemButton = vgui.Create("DButton", panel)
	buyItemButton:SetPos(45, 280)
	buyItemButton:SetSize(90, 20)
	buyItemButton:SetText("Buy Item")
	buyItemButton:SetFont("ObsidianSmall")
	buyItemButton:SetTextColor(OC.YellowColor)
	buyItemButton.DoClick = function()
		local price = tonumber(itemPriceBox:GetText())
		local amount = tonumber(itemAmountBox:GetText())
		if price == nil or amount == nil or itemComboBox.selectedItem == nil then return end
		if not OC.Points.hasAmount(LocalPlayer(), amount * price) then return end
		net.Start("OCNPCMerchant_BuyItem")
		net.WriteEntity(merchantEnt)
		net.WriteString(itemComboBox.selectedItem)
		net.WriteInt(amount, 8)
		net.SendToServer()
	end
	function buyItemButton:Paint(w, h)
		local color = Color(62, 119, 233)
		if buyItemButton:IsHovered() then
			color = ColorAlpha(color, 200)
		end
		draw.RoundedBox(5, 0, 0, w, h, color)
	end

	local itemAmountLabel = vgui.Create("DLabel", panel)
	itemAmountLabel:SetPos(45, 305)
	itemAmountLabel:SetSize(70, 20)
	itemAmountLabel:SetContentAlignment(4)
	itemAmountLabel:SetFont("ObsidianSmall")
	itemAmountLabel:SetTextColor(OC.YellowColor)
	itemAmountLabel:SetText("Amount:")

	itemAmountBox = vgui.Create("DTextEntry", panel)
	itemAmountBox:SetPos(95, 305)
	itemAmountBox:SetSize(40, 20)
	itemAmountBox:SetFont("ObsidianSmall")
	itemAmountBox:SetNumeric(true)
	itemAmountBox:SetText("1")
	itemAmountBox:SetFGColor(OC.YellowColor)
	function itemAmountBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		surface.SetTextColor(OC.YellowColor)
		surface.SetFont(self:GetFont())
		self:DrawOutlinedRect()
		surface.SetTextPos(3, 2)
		surface.DrawText(self:GetText())
	end

	itemAmountSlider = vgui.Create("DSlider", panel)
	itemAmountSlider:SetPos(45, 330)
	itemAmountSlider:SetSize(90, 20)
	itemAmountSlider:SetTrapInside(true)
	itemAmountSlider:SetLockY(0.5)
	itemAmountSlider:SetNotches(20)
	itemAmountSlider:SetSlideX(0.00)
	function itemAmountSlider:TranslateValues(x, y)
		if tonumber(itemPriceBox:GetText()) ~= nil then
			local price = tonumber(itemPriceBox:GetText())
			local maxAffordableAmount = math.floor(OC.Points.getPoints(LocalPlayer()) / price)
			if math.floor(x * 19) + 1 > maxAffordableAmount then
				itemAmountSlider:SetSlideX(maxAffordableAmount / 20)
				x = maxAffordableAmount / 20
			end
		end
		itemAmountBox:SetText(math.floor(x * 19) + 1)
		return x, y
	end
	function itemAmountSlider:Paint(w, h)
		local notchInterval = w / self:GetNotches()
		for i=2,self:GetNotches()-2 do
			surface.SetDrawColor(OC.YellowColor)
			local x = i * notchInterval
			surface.DrawLine(x, h - 4, x, h)
		end
	end

	local itemDescBox = vgui.Create("DScrollPanel", panel)
	itemDescBox:SetPos(140, 255)
	itemDescBox:SetSize(210, 110)
	itemDescBox:GetCanvas():DockPadding(5, 5, 5, 5)
	function itemDescBox:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 90))
		surface.SetDrawColor(OC.YellowColor)
		itemDescBox:DrawOutlinedRect()
	end

	itemDescText = vgui.Create("DLabel", itemDescBox)
	itemDescText:SetSize(200, 100)
	itemDescText:SetPos(5, 5)
	itemDescText:SetWrap(true)
	itemDescText:SetAutoStretchVertical(true)
	itemDescText:SetText("Select item.")
	itemDescText:SetFont("ObsidianSmall")
	itemDescText:SetTextColor(OC.YellowColor)
	itemDescText:Dock(FILL)

	local closeButton = vgui.Create("DButton", panel)
	closeButton:SetPos(350, 410)
	closeButton:SetSize(80, 20)
	closeButton:SetText("Close")
	closeButton:SetFont("ObsidianSmall")
	closeButton:SetTextColor(OC.YellowColor)
	closeButton.DoClick = function()
		panel:Hide()
		gui.EnableScreenClicker(false)
	end
	function closeButton:Paint(w, h)
		local color = Color(62, 119, 233)
		if closeButton:IsHovered() then
			color = ColorAlpha(color, 200)
		end
		draw.RoundedBox(5, 0, 0, w, h, color)
	end
end

net.Receive("OCNPCMerchant_Use", function(len, ply)
	local ent = net.ReadEntity()
	local name = net.ReadString()
	local weapons = net.ReadTable()
	local items = net.ReadTable()

	displayMerchantWindow(ent, name, weapons, items)
end)