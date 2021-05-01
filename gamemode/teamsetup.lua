local ply = FindMetaTable( "Player" )

--include ("player_class/player_default.lua")
--include ("player_class/player_custom.lua")
local teams = {}

teams[1] = {
    name = "Penguin",
    color = Color( 255.0, 0.0, 0.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0"  },
    p_models = { [0] = "BFOL_Penguin_0" },
    spawnPoints = {},
    logoMat = Material( "hud/1_penguin_logo.png", 	"noclamp" ),
    curTickets = 0.0
}
teams[2] = {
    name = "Potato",
    color = Color( 204, 149, 45),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0"},
    p_models = { [0] = "Parrotv3" },
    spawnPoints = {},
    logoMat = Material( "hud/0_potato_logo.png",	"noclamp" ),
    curTickets = 0.0
}
teams[3] = {
    name = "Banana",
    color = Color( 238, 255, 0),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0"  },
    p_models = { [0] = "BFOL_Banana-Man_0" },
    spawnPoints = {},
    logoMat = Material( "hud/2_banana_logo.png",	"noclamp" ),
    curTickets = 0.0
}

function GetTeamCurrentTickets( teamId )
    if (teamId == nil) then return nil end
    return teams[teamId].curTickets
end
function SetTeamCurrentTickets( teamId, newTickets )
    if (teamId == nil) then return nil end
    teams[teamId].curTickets = newTickets
end
function AddTeamCurrentTickets( teamId, ticketsToAdd )
    if (teamId == nil) then return nil end
    teams[teamId].curTickets = teams[teamId].curTickets + ticketsToAdd
end

function GetTeamLogoMaterial( teamId )
    if (teamId == nil || teams[teamId] == nil) then return nil end
    return teams[teamId].logoMat
end

function GetTeamCount()
    return #teams
end

function SetTeamSpawnPoints( teamId )
    local playerStartEntTable = ents.FindByClass("info_player_start")
    for k, v in pairs( playerStartEntTable ) do
        entKeyValueTable = v:GetKeyValues()

        if (entKeyValueTable.TeamNum == teamId) then

            teams[teamId].spawnPoints[k] = v:EntIndex()
        
        end
    end

    -- if all fails add fall back spawn points
    if(table.IsEmpty(teams[teamId].spawnPoints)) then
        for k, v in pairs( playerStartEntTable ) do
            teams[teamId].spawnPoints[k] = v:EntIndex()
        end
    end
end

function InitialiseTeams()
    for k, v in ipairs( teams ) do

        team.SetUp( k, v.name, v.color )
        
        SetTeamSpawnPoints( k )

    end
end

function ply:SetupTeam( n )
    if ( not teams[n] ) then return end

    self:SetTeam( n )
    self:SetPlayerColor( team.GetColor( n ):ToVector() )
    self:SetHealth( 150 )
    self:SetMaxHealth( 200 )
    self:SetWalkSpeed( 200 )
    self:SetRunSpeed( 800 )
    --print( type( teams[n].p_models[0] ) )
    --print( teams[n].p_models[0] )

    local pm_models = player_manager.AllValidModels()
    self:SetModel( pm_models[teams[n].p_models[0]] )

    self:GiveWeapons( n )
    
end

function ply:GiveWeapons()
    for k, weapon in pairs( teams[self:Team()].weapons ) do
        self:Give( weapon )
    end
end

function ply:GetTeamSpawnPointEnt(  )
    if (table.IsEmpty(teams)) then 
        print("[ERROR] No team data set")
        return 0 
    end
    
    local teamTable = teams[self:Team()]
    if (teamTable == nill) then 
        print("[ERROR] Team Table is empty")
        PrintTable(teamTable)
        return 0 
    end
    // if not spawn data is set, recreate it
    if (table.IsEmpty(teamTable.spawnPoints)) then
        SetTeamSpawnPoints(self:Team())
    end

    local pointIndex = table.Random( teamTable.spawnPoints )
    return ents.GetByIndex(pointIndex)
end

player_manager.AddValidModel( "BFOL_Banana-Man_0", "models/player/rebs/BFOL_Banana-Man_0/BFOL_Banana-Man.mdl" );
player_manager.AddValidModel( "BFOL_Penguin_0", "models/player/rebs/BFOL_Penguin-Man_0/BFOL_Penguin.mdl" );
player_manager.AddValidModel( "Parrotv3", "models/player/rebs/parrotv3_pm/parrotv3.mdl" );