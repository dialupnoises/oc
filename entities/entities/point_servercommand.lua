-- Garry's Mod removed point_servercommand, which the lobby's map doors and many
-- campaign maps use to run "changelevel <map>", set skill convars and so on.
-- Maps are untrusted content, so this only runs what the shipped maps need,
-- never an arbitrary string. Every handler takes (name, args), where args is
-- the command split on whitespace.
ENT.Type = "point"
ENT.Base = "base_point"

local MAP_NAME = "^[%w_%-]+$"
local SKILL_CONVAR = "^sk_[%w_]+$"

local function refuse(name, why)
    MsgN("[OC] point_servercommand: refusing '" .. name .. "': " .. why)
end

local function changeLevel(name, args)
    local map = args[1]

    if not map or not string.match(map, MAP_NAME) or not file.Exists("maps/" .. map .. ".bsp", "GAME") then
        return refuse(name, "unknown map '" .. tostring(map) .. "'")
    end

    RunConsoleCommand("changelevel", map)
end

-- a convar set to one number
local function numericConVar(name, args)
    local value = tonumber(args[1])

    if value == nil then
        return refuse(name, "needs a number, got '" .. tostring(args[1]) .. "'")
    end

    RunConsoleCommand(name, tostring(value))
end

local function echo(_, args)
    MsgN(table.concat(args, " "))
end

local function say(_, args)
    PrintMessage(HUD_PRINTTALK, table.concat(args, " "))
end

-- the one ent_fire the maps use; not a general ent_fire
local function entFire(name, args)
    if args[1] ~= "prop_ragdoll" or string.lower(args[2] or "") ~= "kill" then
        return refuse(name, "only 'ent_fire prop_ragdoll kill' is supported")
    end

    for _, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
        ragdoll:Remove()
    end
end

local ALLOWED_COMMANDS = {
    changelevel            = changeLevel,
    echo                   = echo,
    say                    = say,
    ent_fire               = entFire,
    mp_falldamage          = numericConVar,
    mp_flashlight          = numericConVar,
    mp_playercollide       = numericConVar,
    physcannon_mega_enable = numericConVar,
}

-- Episode searchpaths belong to the Source mods these maps came from
local IGNORED_COMMANDS = {
    sv_ep1searchpath = true,
    sv_ep2searchpath = true,
}

function ENT:AcceptInput(input, activator, caller, data)
    if string.lower(input) ~= "command" then return false end

    local args = string.Explode("%s+", string.Trim(data), true)
    local name = string.lower(table.remove(args, 1) or "")

    if IGNORED_COMMANDS[name] then return true end

    local run = ALLOWED_COMMANDS[name]

    if not run and string.match(name, SKILL_CONVAR) then
        run = numericConVar
    end

    if run then
        run(name, args)
    else
        refuse(name, "unsupported command")
    end

    return true
end
