include("shared.lua")

surface.CreateFont("ObsidianLarge", {
	font = "Obsidian",
	size = 40
})

surface.CreateFont("ObsidianMedium", {
	font = "Obsidian",
	size = 22,
	bold = true
})

include("client/timer.lua")
include("client/npc_info.lua")

function GM:Think()
	OC.Timer.Tick()
end