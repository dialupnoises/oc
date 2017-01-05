function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
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