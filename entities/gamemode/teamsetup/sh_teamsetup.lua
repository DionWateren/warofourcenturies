teamData = {}

teamData[1] = {
    name = "Penguin",
    color = Color( 255.0, 0.0, 0.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0", "weapon_potatogun_01"  },
    p_models = { [0] = "BFOL_Penguin_0" },
    spawnPoints = {},
    logoMat = Material( "hud/1_penguin_logo.png", 	"noclamp" ),
    curTickets = 0.0
}
teamData[2] = {
    name = "Potato",
    color = Color( 204, 149, 45),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0", "weapon_potatogun_01" },
    p_models = { [0] = "Parrotv3" },
    spawnPoints = {},
    logoMat = Material( "hud/0_potato_logo.png",	"noclamp" ),
    curTickets = 0.0
}
teamData[3] = {
    name = "Banana",
    color = Color( 238, 255, 0),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0", "weapon_potatogun_01"  },
    p_models = { [0] = "BFOL_Banana-Man_0" },
    spawnPoints = {},
    logoMat = Material( "hud/2_banana_logo.png",	"noclamp" ),
    curTickets = 0.0
}

function SetTeamSpawnPoints( teamId )
    local playerStartEntTable = ents.FindByClass("info_player_start")
    
    for k, v in pairs( playerStartEntTable ) do
        entKeyValueTable = v:GetKeyValues()

        if (entKeyValueTable.TeamNum == teamId) then

            teamData[teamId].spawnPoints[k] = v:EntIndex()
        end
    end

    -- if all fails add fall back spawn points
    if(table.IsEmpty(teamData[teamId].spawnPoints)) then
        for k, v in pairs( playerStartEntTable ) do
            teamData[teamId].spawnPoints[k] = v:EntIndex()
        end
    end
end

function InitialiseteamData()
    print("Initialising teamData")
    for k, v in ipairs( teamData ) do

        team.SetUp( k, v.name, v.color )
        
        if (SERVER) then
            SetTeamSpawnPoints( k )
        end
    end
end

hook.Add("Initialize", "InitialiseteamData", function()
    InitialiseteamData()
end)

function GetTeamCurrentTickets( teamId )
    if (teamId == nil) then return nil end
    return teamData[teamId].curTickets
end
function SetTeamCurrentTickets( teamId, newTickets )
    if (teamId == nil) then return nil end
    teamData[teamId].curTickets = newTickets
end
function AddTeamCurrentTickets( teamId, ticketsToAdd )
    if (teamId == nil) then return nil end
    teamData[teamId].curTickets = teamData[teamId].curTickets + ticketsToAdd
end

function GetTeamLogoMaterial( teamId )
    if (teamId == nil || teamData[teamId] == nil) then return nil end
    return teamData[teamId].logoMat
end

function GetTeamCount()
    return #teamData
end

function IsTeamDataInitialised()
    if (IsValid(teamData)) then
        return table.IsEmpty(teamData)
    end
    return false
end

if(CLIENT) then
    net.Receive("team_ticket_scores", function()
        local receivedTable = net.ReadTable()
        
        for k, v in pairs(receivedTable) do
            SetTeamCurrentTickets(k, v)
        end
    end)
end