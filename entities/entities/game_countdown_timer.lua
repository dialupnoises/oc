AddCSLuaFile()

ENT.Type = "point"
ENT.Base = "base_anim"

ENT.PrintName = "Countdown Timer"
ENT.Spawnable = false
ENT.AdminSpawnable = false

local timerId = "game_countdown_timerer"

local function timerOver()
	umsg.Start("game_countdown_timer_stop")
	umsg.End()
end

function ENT:AcceptInput(inputName, activator, called, data)
	if inputName == "SetTimerLabel" then
		umsg.Start("game_countdown_timer_label")
		umsg.String(data)
		umsg.End()
	elseif inputName == "StartTimer" then
		duration = tonumber(data)

		if timer.Exists(timerId) then
			timer.Remove(timerId)
		end

		timer.Create(timerId, duration, 1, timerOver)

		umsg.Start("game_countdown_timer_start")
		umsg.Long(duration)
		umsg.End()
	elseif inputName == "PauseTimer" then
		if timer.Exists(timerId) then
			timer.Pause(timerId)
		end

		umsg.Start("game_countdown_timer_pause")
		umsg.End()
	elseif inputName == "ResumeTimer" then
		if timer.Exists(timerId) then
			timer.Resume(timerId)
		end

		umsg.Start("game_countdown_timer_resume")
		umsg.End()
	elseif inputName == "StopTimer" then
		if timer.Exists(timerId) then
			timer.Remove(timerId)
		end

		umsg.Start("game_countdown_timer_stop")
		umsg.End()
	end
end