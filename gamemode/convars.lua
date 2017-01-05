-- When 1, the player's points are equivalent to their frags (this is the same behavior as Obsidian Conflict)
-- When 0, they are seperate numbers.
CreateConVar("oc_fragsarepoints", "1", FCVAR_REPLICATED, "Whether frags and points are the same.")

-- When 2, the player's points are persisted across map changes, server restarts, etc
-- When 1, the player's points are persisted until a map change or a server shutdown (i.e. leaving and rejoining right away won't clear them)
-- When 0, the player's points are not persisted at all
CreateConVar("oc_pointpersist", "1", FCVAR_NONE, "0 = no persistence, 1 = persistence until level reload, 2 = full persistence")