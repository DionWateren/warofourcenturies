local curRoundTime = 0.0
local curTicketCheckTime = 0.0
local ticketCheckMaxTime = 1.0

local cpEntTable = {}
local botEntTable = {}

function UpdateTimer(countUp)
    if(countUp) then
        curRoundTime = curRoundTime + FrameTime()
    else
        curRoundTime = curRoundTime - FrameTime()
    end

    net.Start( "round_timer" )
        net.WriteInt(math.floor(curRoundTime), 10)
    net.Broadcast()
end

function SendTargetTickets()
    curRoundTime = curRoundTime - FrameTime()

    net.Start( "target_tickets" )
        net.WriteUInt(conVarTargetTickets:GetInt(), 10)
    net.Broadcast()
end

function InitialiseRoundSystem()

    cpEntTable = ents.FindByClass("capture_point")
    botEntTable = player.GetBots()

end

hook.Add("PlayerSpawn", "SendTargetTickets", function()

    SendTargetTickets()

end)

local initialWarmupOver = false
function RoundUpdate()
    if(conVarInProgress:GetBool()) then

        RoundInProgress()

        RoundUpdateBots()

    else
        if (CanStartRound()) then
            -- check & set warmup
            if (!conVarWarmup:GetBool() && !conVarInProgress:GetBool() && !initialWarmupOver) then
                conVarWarmup:SetBool(true)
                curRoundTime = conVarWarmupTime:GetFloat()
                initialWarmupOver = true
            elseif (curRoundTime <= 0.0 || initialWarmupOver) then
                if(conVarWarmup:GetBool() || initialWarmupOver) then
                    RoundStart()
                end
            end

        end
    end

    if(conVarWarmup:GetBool()) then
        UpdateTimer(false)
    elseif(conVarInProgress:GetBool()) then
        UpdateTimer(true)
    end
end

function RoundMeetBotQuota()

    if (#botEntTable == conVarBotQuota:GetInt()) then
        return
    end

    local botBucketFlow = 0

    if(#botEntTable < conVarBotQuota:GetInt()) then
        local botsToAdd = conVarBotQuota:GetInt() - #botEntTable

        for i=1, botsToAdd do

	        player.CreateNextBot( table.Random(botNameTable) )
        end

    elseif(#botEntTable > conVarBotQuota:GetInt()) then
        local botsToRemove =  #botEntTable - conVarBotQuota:GetInt()

        for i=1, botsToRemove do

            botEntTable[i]:Kick("Bot quota")
        end
    end
end

function RoundUpdateBots()
    botEntTable = player.GetBots()

    for k, v in pairs(botEntTable) do
        
        if(!v:Alive()) then
            
            v:Spawn()

        end
    end

    RoundMeetBotQuota()
end

function CanStartRound()
    local teamsTable = team.GetAllTeams()
    for k, v in pairs(teamsTable) do
        if ((k > 0 && k < 6) && table.Count(team.GetPlayers(k)) < conVarStartQuota:GetInt()) then
            return false
        end
    end

    return true
end

function RoundStart()
    print( "Round started" )

    conVarWarmup:SetBool(false)
    conVarInProgress:SetBool(true)

    conVarRoundOver:SetBool(false)

    net.Start("round_start")
    net.Broadcast()

    curRoundTime = conVarInProgressTime:GetFloat()
end

function RoundInProgress()

    if (curTicketCheckTime > ticketCheckMaxTime) then
        curTicketCheckTime = 0.0

        if (table.IsEmpty(cpEntTable)) then
            cpEntTable = ents.FindByClass("capture_point")
        end

        for k, v in pairs(cpEntTable) do
            
            if(v:GetIsCaptured()) then
                AddTeamCurrentTickets(
                    v:GetTeamOwnership()
                    , v:GetCaptureWorth() * 1.0)

                if (GetTeamCurrentTickets(v:GetTeamOwnership()) > conVarTargetTickets:GetInt()) then
                    SetTeamCurrentTickets(v:GetTeamOwnership(), conVarTargetTickets:GetInt())
                end
                
                
            end
        end

        local tableToSend = {}
        for i=1, GetTeamCount() do
            tableToSend[i] = GetTeamCurrentTickets(i)
        end

        net.Start("team_ticket_scores")
            net.WriteTable(tableToSend)
        net.Broadcast()

        RoundEndCheck()

    end

    curTicketCheckTime = curTicketCheckTime + FrameTime()

end

function RoundEndCheck()
    local teamsTable = team.GetAllTeams()
    for k, v in pairs(teamsTable) do
        if ((k > 0 && k < 6) && GetTeamCurrentTickets(k) >= conVarTargetTickets:GetInt()) then
            
            EndRound( v )

            return
        end
    end
end

function EndRound( winnerTeam )
    
    print( winnerTeam.Name .. " won the round!" )

    conVarInProgress:SetBool(false)
    conVarRoundOver:SetBool(true)

    -- reward the players
    for k, v in pairs( player.GetAll() ) do
        --if( team.GetName( v:Team() ) == winnerTeam.Name ) then
            --v:StadsAddXp( 100 )
            PrintMessage(HUD_PRINTCENTER, winnerTeam.Name .. " has won the round!")
        --end
    end

    timer.Create( "cleanup", 3, 1, function()
        game.CleanUpMap( false, {} )

        local tableToSend = {}
        for i=1, GetTeamCount() do
            SetTeamCurrentTickets(i, 0)
            tableToSend[i] = GetTeamCurrentTickets(i)
        end

        net.Start("team_ticket_scores")
            net.WriteTable(tableToSend)
        net.Broadcast()

        table.Empty(cpEntTable)
        
        for k, v in pairs( player.GetAll() ) do

            if( v:Alive() ) then
                v:SetupHands()
                v:StripWeapons()
                v:KillSilent()
            end

            v:SetupTeam( v:Team() )
        end

    end)
end

function AutoBalance()
    local teamCount = GetTeamCount()
    for x=1, teamCount do
        for y=1, teamCount do
            if(x==y) then
                continue 
            end

            if(table.Count(team.GetPlayers(x)) > table.Count(team.GetPlayers(y))) then
                return y
            elseif(table.Count(team.GetPlayers(x)) < table.Count(team.GetPlayers(y))) then
                return x
            end
        end
    end

    return math.random( 1, GetTeamCount() )

    -- by KDR
    -- local redAvgKDR = 0
    -- local blueAvgKDR = 0
    -- for k, v in pairs( team.GetPlayers( 1 ) ) do
    --     redAvgKDR = redAvgKDR + v:Frags()/v:Deaths()
    -- end
    -- redAvgKDR = redAvgKDR/table.Count( team.GetPlayers( 1 ) )

    -- for k, v in pairs( team.GetPlayers( 2 ) ) do
    --     blueAvgKDR = blueAvgKDR + v:Frags()/v:Deaths()
    -- end
    -- blueAvgKDR = blueAvgKDR/table.Count( team.GetPlayers( 2 ) )

    -- print( "Auto Balance: Red KDR - " .. redAvgKDR .. " | Blue KDR - " .. blueAvgKDR )

    -- if ( redAvgKDR > blueAvgKDR ) then
    --     return 2
    -- elseif ( redAvgKDR < blueAvgKDR ) then
    --     return 1
    -- end
end