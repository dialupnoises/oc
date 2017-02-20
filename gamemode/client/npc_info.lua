OC.DispositionCache = {}
local requestPending = false
D_HT = 1
D_FR = 2
D_LI = 3
D_NU = 4

function paintInfo()
	if requestPending then return end
	if not IsValid(LocalPlayer()) then return end
	local ang = LocalPlayer():GetAimVector()
	local trace = util.TraceLine({
		start = EyePos(),
		endpos = EyePos() + (ang * 500),
		filter = LocalPlayer()
	})
	if not trace.Hit or not trace.HitNonWorld or not trace.Entity:IsNPC() then return end
	surface.SetTextColor(OC.RedColor)

	local npc = trace.Entity
	local relationship = "Enemy"
	if OC.DispositionCache[npc:EntIndex()] == nil then
		net.Start("npc_disposition_request")
		net.WriteInt(npc:EntIndex(), 16)
		net.SendToServer()
		requestPending = true
		return
	elseif OC.DispositionCache[npc:EntIndex()] == D_LI || OC.DispositionCache[npc:EntIndex()] == D_NU then
		relationship = "Friend"
		surface.SetTextColor(OC.GreenColor)
	end 

	local label = 
		"Name: " .. npc:GetNWString("npcname", npc:GetClass())
	local label2 = 
		"Health: " .. math.floor((npc:Health() / npc:GetMaxHealth()) * 100) .. "%"
	local label3 = relationship

	surface.SetFont("OCRobotoBlack")
	_, y = surface.GetTextSize(label)
	_, y2 = surface.GetTextSize(label2)
	_, y3 = surface.GetTextSize(label3)
	local start = ScrH() / 2 - (y + y2 + y3 + 15) / 2
	surface.SetTextPos(10, start)
	surface.DrawText(label)
	surface.SetTextPos(10, start + y + 5)
	surface.DrawText(label2)
	surface.SetTextPos(10, start + y + y2 + 10)
	surface.DrawText(label3)
end

hook.Add("HUDPaint", "npc_info_paint", paintInfo)

net.Receive("npc_disposition_response", function(len, ply)
	local index = net.ReadInt(16)
	OC.DispositionCache[index] = net.ReadInt(4)
	requestPending = false
end)