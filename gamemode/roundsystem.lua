roundActive = false

function RoundStart()
    local Alive = 0
    for k, v in pairs( player.GetAll() ) do
        if( v:Alive() ) then
            Alive = Alive + 1
        end
    end

    if( Alive >= table.Count( player.GetAll() ) && table.Count( player.GetAll() ) > 1 ) then
        roundActive = true
    end

    print( "Round started: " .. tostring( roundActive ) )

    RoundEndCheck()
end

function RoundEndCheck()

    print( "Round active: " .. tostring( roundActive ) )

    if( roundActive == false ) then return end

    timer.Create( "checkdelay", 1, 1, function()

        local RedAlive = 0  
        local BlueAlive = 0  

        for k, v in pairs( team.GetPlayers( 0 ) ) do
            if( v:Alive() ) then
                RedAlive = RedAlive + 1
            end
        end
        for k, v in pairs( team.GetPlayers( 1 ) ) do
            if( v:Alive() ) then
                BlueAlive = BlueAlive + 1
            end
        end

        print( "Red Alive: " .. tostring( RedAlive ) .. " | Blue Alive: " .. tostring( BlueAlive ) )

        if( RedAlive == 0 ) then
            EndRound( "Blue" )
        elseif( BlueAlive == 0 ) then
            EndRound( "Red" )
        end

    end)

end

function EndRound( winners )
    print( winners .. " won the round!" )

    ---- reward the players
    --for k, v in pairs( players.GetAll() ) do
    --    if( team.GetName( v:Team() ) == winners ) then
    --        v:StadsAddXp( 100 )
    --    end
    --end

    timer.Create( "cleanup", 3, 1, function()

        game.CleanUpMap( false, {} )

        for k, v in pairs( player.GetAll() ) do

            if( v:Alive() ) then
                v:SetupHands()
                v:StripWeapons()
                v:KillSilent()
            end

            v:SetupTeam( v:Team() )
        end

        roundActive = false

    end)
end