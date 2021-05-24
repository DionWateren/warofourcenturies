local ply = FindMetaTable( "Player" )

function ply:SetupTeam( n )
    if ( IsValid( teamData[n] ) ) then 
        print("Data not valid" .. n)
        PrintTable(teamData[n])
        return 
    end

    local curTeam = teamData[n]

    self:SetTeam( n )
    self:SetPlayerColor( team.GetColor( n ):ToVector() )
    self:SetHealth( 150 )
    self:SetMaxHealth( 200 )
    self:SetWalkSpeed( 200 )
    self:SetRunSpeed( 800 )
    --print( type( curTeam.p_models[0] ) )
    --print( curTeam.p_models[0] )

    local pm_models = player_manager.AllValidModels()
    self:SetModel( pm_models[curTeam.p_models[0]] )

    self:GiveWeapons( n )
    
end

function ply:GiveWeapons()
    local teamTable = teamData[self:Team()]
    if (not IsValid(teamTable)) then 
        return 0 
    end
    for k, weapon in pairs( teamTable.weapons ) do
        self:Give( weapon )
    end
end

function ply:GetTeamSpawnPointEnt(  )
    if (IsTeamDataInitialised()) then 
        print("[ERROR] No team data set")
        return 0 
    end
    
    local teamTable = teamData[self:Team()]
    if (teamTable == nil) then 
        return 0 
    end

    // if no spawn data is set, recreate it
    if (table.IsEmpty(teamTable.spawnPoints)) then
        SetTeamSpawnPoints(self:Team())
    end

    local pointIndex = table.Random( teamData[self:Team()].spawnPoints)
    return ents.GetByIndex(pointIndex)
end

player_manager.AddValidModel( "BFOL_Banana-Man_0", "models/player/rebs/BFOL_Banana-Man_0/BFOL_Banana-Man.mdl" );
player_manager.AddValidModel( "BFOL_Penguin_0", "models/player/rebs/BFOL_Penguin-Man_0/BFOL_Penguin.mdl" );
player_manager.AddValidModel( "Parrotv3", "models/player/rebs/parrotv3_pm/parrotv3.mdl" );