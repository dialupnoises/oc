function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.equalsi(a, b)
	return string.lower(a) == string.lower(b)
end

function player.FindInPVS(viewpoint)
	local viewableEnts = ents.FindInPVS(viewpoint)
	local players = {}
	for k, v in pairs(viewableEnts) do
		if v:IsPlayer() then
			table.insert(players, v)
		end
	end
	return players
end

function DoesWeaponExist(name)
	return weapons.Get(name) ~= nil
end

function ResolveOCWeapon(name)
	if OC.CustomReplacements[name] ~= nil then
		replacement = OC.CustomReplacements[name]
		if istable(replacement) then
			for _, v in pairs(replacement) do
				if DoesWeaponExist(v) then
					return v
				end
			end
		elseif DoesWeaponExist(replacement) then
			return replacement
		end
	end

	return name
end

function ReplaceEnt(a, bname)
	if a:GetClass() == bname then return end
	local newEnt = ents.Create(bname)
	newEnt:SetPos(a:GetPos())
	newEnt:SetAngles(a:GetAngles())
	newEnt:SetName(a:GetName())
	newEnt:Spawn()
	a:Remove()
end

function LoadMapConfig(map)
	local convars = {}
	local add = {}
	local remove = {}
	local spawnItems = {}
	local modify = {}
	local mounts = {}

	if file.Exists("maps/cfg/" .. map .. "_cfg.txt", "GAME") then
		local data = file.Read("maps/cfg/" .. map .. "_cfg.txt", "GAME")
		convars = util.KeyValuesToTable(data)
	end

	if file.Exists("maps/cfg/" .. map .. "_modify.txt", "GAME") then
		local data = file.Read("maps/cfg/" .. map .. "_modify.txt", "GAME")
		local modifyFile = util.KeyValuesToTable(data)

		add = modifyFile["add"] or {}
		remove = modifyFile["remove"] or {}
		spawnItems = modifyFile["spawnitems"] or {}
		modify = modifyFile["modify"] or {}
	end

	return {
		convars = convars,
		add = add,
		remove = remove,
		modify = modify,
		spawnItems = spawnItems
	}
end

function FindTableKey(t, k)
	for _, v in pairs(table.GetKeys(t)) do
		if string.equalsi(v, k) then
			return v
		end
	end

	return k
end

function StringToVector(s)
	local parts = string.Split(s, " ")
	return Vector(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
end

function StringToColor(s)
	local parts = string.Split(s, " ")
	if #parts == 4 then
		return Color(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]), tonumber(parts[4]))
	else
		return Color(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
	end
end

function ApplyToFoundScript(t, f)
	if t["classname"] ~= nil then
		for k, v in pairs(t["classname"]) do
			local entsByClass = ents.FindByClass(k)
			for _, e in pairs(entsByClass) do f(e, v) end
		end
	end

	if t["targetname"] ~= nil then
		for k, v in pairs(t["targetname"]) do
			local entsByName = ents.FindByName(k)
			for _, e in pairs(entsByName) do f(e, v) end
		end
	end

	if t["origin"] ~= nil then
		for k, v in pairs(t["origin"]) do
			local originVector = StringToVector(k)
			for _, e in pairs(ents.FindInSphere(originVector, 1)) do
				if e:GetPos() == originVector then
					f(e, v)
				end
			end
		end
	end
end

function SetRainEnabled(rainOn,ply)
	if ply ~= nil then
		if rainOn then 
			ply:ConCommand("r_rainalpha 0.4")
		else
			ply:ConCommand("r_rainalpha 0")
		end
	end

	if rainOn then
		for k, v in pairs(player.GetAll()) do
			v:ConCommand("r_rainalpha 0.4")
		end
	else
		for k, v in pairs(player.GetAll()) do
			v:ConCommand("r_rainalpha 0")
		end
	end
end

function SmoothLerp(t, from, to)
	t = math.Clamp(t, 0, 1)
	return from + (to - from) * (t * t * t * (t * (t * 6 - 15) + 10))
end

local lerpVars = {}
function LerpText(name, currentVal)
	if lerpVars[name] == nil then
		lerpVars[name] = { last = currentVal, lerping = false }
		return currentVal
	end

	PrintTable(lerpVars[name])

	if lerpVars[name].current == currentVal then
		lerpVars[name] = { last = currentVal, current = currentVal, lerping = false }
		return currentVal
	elseif lerpVars[name].lerping and lerpVars[name].last ~= currentVal then
		lerpVars[name].last = currentVal
		lerpVars[name].current = lerpVars[name].lastLerp
		--lerpVars[name].t = 0
	elseif not lerpVars[name].lerping then
		lerpVars[name].current = lerpVars[name].last
		lerpVars[name].last = currentVal
		lerpVars[name].lastLerp = lerpVars[name].last
		lerpVars[name].lerping = true
		lerpVars[name].t = 0
	end

	lerpVars[name].t = lerpVars[name].t + FrameTime() / 2
	if lerpVars[name].t >= 0.99 then
		lerpVars[name].lerping = false
		return lerpVars[name].last
	end

	lerpVars[name].lastLerp = SmoothLerp(lerpVars[name].t, lerpVars[name].current, lerpVars[name].last)
	return math.floor(lerpVars[name].lastLerp)
end

if CLIENT then
	-- Draws an arc on your screen.
	-- startang and endang are in degrees, 
	-- radius is the total radius of the outside edge to the center.
	-- cx, cy are the x,y coordinates of the center of the arc.
	-- roughness determines how many triangles are drawn. Number between 1-360; 2 or 3 is a good number.
	-- https://facepunch.com/showthread.php?t=1438016&p=46533574&viewfull=1#post46533574
	function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
		surface.SetDrawColor(color)
		surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness))
	end

	function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
		local triarc = {}
		-- local deg2rad = math.pi / 180
		
		-- Define step
		local roughness = math.max(roughness or 1, 1)
		local step = roughness
		
		-- Correct start/end ang
		local startang,endang = startang or 0, endang or 0
		
		if startang > endang then
			step = math.abs(step) * -1
		end
		
		-- Create the inner circle's points.
		local inner = {}
		local r = radius - thickness
		for deg=startang, endang, step do
			local rad = math.rad(deg)
			-- local rad = deg2rad * deg
			local ox, oy = cx+(math.cos(rad)*r), cy+(-math.sin(rad)*r)
			table.insert(inner, {
				x=ox,
				y=oy,
				u=(ox-cx)/radius + .5,
				v=(oy-cy)/radius + .5,
			})
		end
		
		
		-- Create the outer circle's points.
		local outer = {}
		for deg=startang, endang, step do
			local rad = math.rad(deg)
			-- local rad = deg2rad * deg
			local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
			table.insert(outer, {
				x=ox,
				y=oy,
				u=(ox-cx)/radius + .5,
				v=(oy-cy)/radius + .5,
			})
		end
		
		
		-- Triangulize the points.
		for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
			local p1,p2,p3
			p1 = outer[math.floor(tri/2)+1]
			p3 = inner[math.floor((tri+1)/2)+1]
			if tri%2 == 0 then --if the number is even use outer.
				p2 = outer[math.floor((tri+1)/2)]
			else
				p2 = inner[math.floor((tri+1)/2)]
			end
		
			table.insert(triarc, {p1,p2,p3})
		end
		
		-- Return a table of triangles to draw.
		return triarc
		
	end

	function surface.CreateHUDClippingPoly(cx, cy, radius, dr, roughness)
		local outer = {}

		local roughness = math.max(roughness or 1, 1)
		local step = roughness

		for deg=-90, 90, step do
			local rad = math.rad(deg)

			local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
			table.insert(outer, {
				x=ox,
				y=oy,
				u=(ox-cx)/radius + .5,
				v=(oy-cy)/radius + .5,
			})
		end

		local trx = cx + dr
		local try = cy - radius

		local brx = cx + dr
		local bry = cy + radius

		local topVert = {x = trx, y = try, u = 1, v = 0}
		local bottomVert = {x = brx, y = bry, u = 1, v = 1}

		local tris = {}
		for tri=1,math.floor(#outer/2)-1 do
			table.insert(tris, {outer[tri], bottomVert, outer[tri + 1]})
		end

		for tri=math.floor(#outer/2),#outer-1 do
			table.insert(tris, {outer[tri], topVert, outer[tri + 1]})
		end

		return tris
	end

	function surface.DrawArc(arc) //Draw a premade arc.
		for k,v in ipairs(arc) do
			surface.DrawPoly(v)
		end
	end
end

colorLib = colorLib or {}
function colorLib.mult(color, a)
	return Color(color.r * a, color.g * a, color.b * a, color.a * a)
end

function colorLib.lighten(color, percent)
	local a = percent * 255
	return Color(math.min(255, color.r + a), math.min(255, color.g + a), math.min(255, color.b + a), color.a)
end