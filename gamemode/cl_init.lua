include("shared.lua")

function GM:Initialize()
	resource.AddFile("resource/obsidian.ttf")

	surface.CreateFont("ObsidianLarge", {
		font = "Obsidian",
		size = 40
	})

	surface.CreateFont("ObsidianMedium", {
		font = "Obsidian",
		size = 22,
		weight = 700
	})

	surface.CreateFont("ObsidianSmall", {
		font = "Obsidian",
		size = 14,
		weight = 700
	})
end

include("client/timer.lua")
include("client/npc_info.lua")
include("client/points.lua")
include("client/strings.lua")
include("client/merchant.lua")

local lastUse = 0
net.Receive("play_use_sound", function(len, ply)
	if CurTime() - lastUse < 0.2 then return end
	lastUse = CurTime()
	surface.PlaySound("common/wpn_select.wav")
end)

function GM:Think()
	OC.Timer.Tick()
end