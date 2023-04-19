OC = OC or {}

OC.Points = {}
-- for in-memory persistence
OC.Points.PlayerCache = OC.Points.PlayerCache or {}

if SERVER then
	util.AddNetworkString("alert_points_change")
end

local function ensureTableCreated()
	sql.Query("CREATE TABLE IF NOT EXISTS oc_pointcache (steamid TEXT, points INT);")
end

local function playerExistsInDatabase(ply)
	return sql.Query("SELECT 1 FROM oc_pointcache WHERE steamid = '" .. ply:SteamID() .. "'") ~= nil
end

local function loadPointsSql(ply)
	ensureTableCreated()

	local result = sql.Query("SELECT points FROM oc_pointcache WHERE steamid = '" .. ply:SteamID() .. "'")
	if result == nil then
		return 0
	else
		return result["points"]
	end
end

local function savePointsSql(ply, amount)
	ensureTableCreated()

	if playerExistsInDatabase(ply) then
		sql.Query("UPDATE oc_pointcache SET points = " .. amount .. " WHERE steamid = '" .. ply:SteamID() .. "'")
	else
		sql.Query("INSERT INTO oc_pointcache VALUES('" .. ply:SteamID() .. "', " .. amount .. ")")
	end
end

OC.Points.areFrags = function()
	return GetConVar("oc_fragsarepoints"):GetBool()
end

OC.Points.persistenceType = function()
	return GetConVar("oc_pointpersist"):GetInt()
end

-- Runs when the player connects
OC.Points.initPlayer = function(ply)
	local amount = 0

	if OC.Points.persistenceType() == 2 then
		amount = loadPointsSql(ply)
	elseif OC.Points.persistenceType() == 1 then
		amount = OC.Points.PlayerCache[ply:SteamID()] or 0
	end

	if OC.Points.areFrags() then
		ply:SetFrags(amount)
	else
		ply:SetNWInt("oc_points", amount)
	end
end

-- returns the number of points the player has
OC.Points.getPoints = function(ply)
	if OC.Points.areFrags() then
		return ply:Frags()
	else
		return ply:GetNWInt("oc_points")
	end
end

-- sets the player's number of points
OC.Points.setPoints = function(ply, amount)
	local startPoints = OC.Points.getPoints(ply)
	if OC.Points.areFrags() then
		ply:SetFrags(amount)
	else
		ply:SetNWInt("oc_points", amount)
	end

	OC.Points.enforceNegative(ply)
	OC.Points.sendChange(ply, OC.Points.getPoints(ply) - startPoints)

	-- update point persistence
	if OC.Points.persistenceType() == 2 then
		savePointsSql(ply, amount)
	elseif OC.Points.persistenceType() == 1 then
		OC.Points.PlayerCache[ply:SteamID()] = amount
	end
end

-- Whether the player has this amount of points.
OC.Points.hasAmount = function(ply, amount)
	return OC.Points.getPoints(ply) >= amount
end

-- Adds the given amount of points
OC.Points.givePoints = function(ply, amount)
	if CLIENT then
		if LocalPlayer():UserID() ~= ply:UserID() then
			ply:PrintMessage(HUD_PRINTCONSOLE, "Can't set someone else's points.")
			return
		end

		net.Start("do_give_points")
			net.WriteInt(amount, 32)
		net.SendToServer()
	else
		OC.Points.setPoints(ply, OC.Points.getPoints(ply) + amount)
	end
end

-- Subtracts the given amount of points
OC.Points.removePoints = function(ply, amount)
	OC.Points.givePoints(ply, -amount)
end

OC.Points.enforceNegative = function(ply)
	if GetConVar("sv_allownegativescore"):GetBool() then return end
	if OC.Points.getPoints(ply) < 0 then
		OC.Points.setPoints(ply, 0)
	end
end

OC.Points.sendChange = function(ply, amt)
	net.Start("alert_points_change")
	net.WriteInt(amt, 32)
	net.Send(ply)
end

if SERVER then
	util.AddNetworkString("alert_points_change")
	util.AddNetworkString("do_give_points")
end

net.Receive("alert_points_change", function(len, ply)
	local amt = net.ReadInt(32)
	hook.Call("OCPointsChange", nil, amt)
end)

net.Receive("do_give_points", function(len, ply)
	local amt = net.ReadInt(32)
	
	local cheatsConvar = GetConVar("sv_cheats")
	if not cheatsConvar:GetBool() and not ply:IsAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "sv_cheats must be enabled, or you must be an admin.")
		return
	end

	OC.Points.givePoints(ply, amt)
end)