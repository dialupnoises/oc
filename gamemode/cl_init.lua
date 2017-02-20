include("shared.lua")

function GM:Initialize()
	resource.AddFile("resource/fonts/zrnic.ttf")

	surface.CreateFont("ObsidianXL", {
		font = "Zrnic Rg",
		size = 72
	})

	surface.CreateFont("ObsidianLarge", {
		font = "Zrnic Rg",
		size = 40
	})

	surface.CreateFont("ObsidianMedium", {
		font = "Zrnic Rg",
		size = 22,
		weight = 700
	})

	surface.CreateFont("ObsidianSmall", {
		font = "Zrnic Rg",
		size = 14,
		weight = 700
	})

	surface.CreateFont("OCRobotoBlack", {
		font = "Roboto",
		weight = 800,
		size = 22
	})

	surface.CreateFont("OCRobotoBoldSmall", {
		font = "Roboto",
		weight = 700,
		size = 16
	})
end

include("client/timer.lua")
include("client/npc_info.lua")
include("client/points.lua")
include("client/strings.lua")
include("client/merchant.lua")
include("client/hud.lua")
include("client/transfer.lua")

local lastUse = 0
net.Receive("play_use_sound", function(len, ply)
	if CurTime() - lastUse < 0.2 then return end
	lastUse = CurTime()
	surface.PlaySound(OC.UseSound)
end)

function GM:Think()
	OC.Timer.Tick()
end

hook.Add("PlayerBindPress", "oc_player_bind", function(ply, bind, pressed)
	if bind == "gm_showhelp" then
		return true
	elseif bind == "gm_showteam" then 
		ShowTransferGUI()
		return true
	end
end)