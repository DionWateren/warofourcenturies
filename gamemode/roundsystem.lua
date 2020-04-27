roundActive = false

function UpdateTimer( time )
    net.Start( "round_timer" )
        net.WriteInt( time, 10 )
    net.Broadcast()
end

function RoundStart()

    local time = 5
    UpdateTimer( time )
    timer.Create( "round", 1, time, function()
        time = time - 1

        local Alive = 0
        for k, v in pairs( player.GetAll() ) do
            if( v:Alive() ) then
                Alive = Alive + 1
            end
        end

        if( Alive >= table.Count( player.GetAll() ) && table.Count( player.GetAll() ) > 1 && time <= 0 ) then
            roundActive = true
            net.Start( "round_active" )
                net.WriteBool( true )
            net.Broadcast()

        elseif ( table.Count( player.GetAll() ) < 2 ) then
            UpdateTimer( 5 )
            return
        end
        if( time <= 0 ) then
            print( "Round started: " .. tostring( roundActive ) )
            RoundEndCheck()
        end

        UpdateTimer( time )

    end)
end

function RoundEndCheck()

    print( "Round active: " .. tostring( roundActive ) )
    time = 31
    if( roundActive == false ) then return end

    timer.Create( "checkdelay", 1, time, function()
        time = time - 1
        UpdateTimer( time )
        if ( time <= 0 ) then
            EndRound( "No one" )
        end
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
    timer.Remove( "checkdelay" )
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

        net.Start( "round_active" )
            net.WriteBool( false )
        net.Broadcast()

        roundActive = false

    end)
end

function AutoBalance()

    if ( table.Count( team.GetPlayers( 0 ) ) > table.Count( team.GetPlayers( 1 ) ) ) then
        return 1
    elseif ( table.Count( team.GetPlayers( 0 ) ) < table.Count( team.GetPlayers( 1 ) ) ) then
        return 0
    else
        local redAvgKDR = 0
        local blueAvgKDR = 0
        for k, v in pairs( team.GetPlayers( 0 ) ) do
            redAvgKDR = redAvgKDR + v:Frags()/v:Deaths()
        end
        redAvgKDR = redAvgKDR/table.Count( team.GetPlayers( 0 ) )

        for k, v in pairs( team.GetPlayers( 1 ) ) do
            blueAvgKDR = blueAvgKDR + v:Frags()/v:Deaths()
        end
        blueAvgKDR = blueAvgKDR/table.Count( team.GetPlayers( 1 ) )

        print( "Auto Balance: Red KDR - " .. redAvgKDR .. " | Blue KDR - " .. blueAvgKDR )

        if ( redAvgKDR > blueAvgKDR ) then
            return 1
        elseif ( redAvgKDR < blueAvgKDR ) then
            return 0
        else
            return math.random( 0, 1 )
        end
    end
end