-- When 1, the player's points are equivalent to their frags (this is the same behavior as Obsidian Conflict)
-- When 0, they are seperate numbers.
CreateConVar("oc_fragsarepoints", "1", FCVAR_REPLICATED, "Whether frags and points are the same.")

-- When 2, the player's points are persisted across map changes, server restarts, etc
-- When 1, the player's points are persisted until a map change or a server shutdown (i.e. leaving and rejoining right away won't clear them)
-- When 0, the player's points are not persisted at all
CreateConVar("oc_pointpersist", "1", FCVAR_NONE, "0 = no persistence, 1 = persistence until level load, 2 = full persistence")

-- When 1, the player's lives are persisted until map change or server shutdown. This prevents them from disconnecting and reconnecting to reset lives.
-- When 0, the player's lives reset when they leave the server.
CreateConVar("oc_livespersist", "0", FCVAR_NONE, "0 = no persistence, 1 = persistence until level load")

-- When 2, the map is restarted when all players are out of lives and dead.
-- When 1, the map is changed to the next map when all players are out of lives and dead.
-- When 0, there are no lives.
CreateConVar("mp_livesmode", "0", FCVAR_REPLICATED, "0 = disabled, 1 = change to next map on all players dead, 2 = restart map on all players dead")

-- When 1, this overrides the map's setting to add lives. This can add lives to a map where there are none.
-- When 0, this overrides the map's setting to remove lives. This can disable lives on a map where they are enabled.
CreateConVar("mp_livesoverride", "-1", FCVAR_REPLICATED, "0 = no lives, 1 = yes lives. overrides map setting.")

CreateConVar("mp_numlives", "-1", FCVAR_REPLICATED, "If > 0, this is the number of lives a player starts with.")

-- When 1, players are allowed to have a negative score. This is default behavior.
-- When 0, a player's score can't go lower than 0. This is the best behavior for maps like oc_harvest.
CreateConVar("sv_allownegativescore", "1", FCVAR_NONE, "Whether negative score should be allowed.")