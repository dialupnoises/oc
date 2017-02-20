local frame = vgui.Create("DFrame")
frame:SetTitle("Player Settings")
frame:SetSize(400, 400)
frame:SetPos(100, 100)

local modelTable = player_manager.AllValidModels()
local modelKeys = table.GetKeys(modelTable)
table.sort(modelKeys, function(a,b) return a < b end)

local modelPanelContainer = vgui.Create("DPanel", frame)
modelPanelContainer:SetPos(10, 30)
modelPanelContainer:SetSize(190, 360)

local modelPanel = vgui.Create("DModelPanel", modelPanelContainer)
modelPanel:SetSize(180, 360)
modelPanel:SetModel(modelTable[modelKeys[1]])

local modelComboPanel = vgui.Create("DComboBox", frame)
modelComboPanel:SetSize(180, 20)
modelComboPanel:SetPos(210, 30)
