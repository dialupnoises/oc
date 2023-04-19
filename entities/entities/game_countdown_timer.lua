AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

ENT.PrintName = "Countdown timer"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.LastTimerUpdateSent = 0

local timerId = "game_countdown_timerer"

local function timerOver()
	OC.Timer.Stop()
end

function ENT:AcceptInput(inputName, activator, called, data)
	local inputLower = string.lower(inputName)

	if inputLower == "settimerlabel" then
		OC.Timer.SetLabel(data)
	elseif inputLower == "starttimer" then
		duration = tonumber(data)

		if timer.Exists(timerId) then
			timer.Remove(timerId)
		end

		timer.Create(timerId, duration, 1, timerOver)

		self.LastTimerUpdateSent = RealTime()
		OC.Timer.Start(duration)
	elseif inputLower == "pausetimer" then
		if timer.Exists(timerId) then
			timer.Pause(timerId)
		end

		OC.Timer.Pause()
	elseif inputLower == "resumetimer" then
		if timer.Exists(timerId) then
			timer.Resume(timerId)
		end

		OC.Timer.Resume()
	elseif inputLower == "stoptimer" then
		if timer.Exists(timerId) then
			timer.Remove(timerId)
		end

		OC.Timer.Stop()
	end
end

function ENT:Think()
	if SERVER then
		if (RealTime() - self.LastTimerUpdateSent) > 5 then
			self.LastTimerUpdateSent = RealTime()
			OC.Timer.UpdateClientTime()
		end
	end

	return true
end

if CLIENT then
	hook.Add("InitPostEntity", "countdown_timer_update_post_ent", function()
		OC.Timer.UpdateNewPlayer()
	end)
end