local preTag = "wooc_"

-- bot related
CreateConVar(preTag .. "bot_quota"
    , 6
    , FCVAR_NONE
    , "Amount of bots joining the server")

CreateConVar(preTag .. "bot_melee_only"
    , 0
    , FCVAR_NONE
    , "Will bots only use melee?")

-- round related
CreateConVar(preTag .. "round_target_tickets"
    , 100
    , FCVAR_NONE
    , "Determines the amount of tickets a team needs to win the round")

CreateConVar(preTag .. "round_warmup"
    , 0
    , FCVAR_NONE
    , "Are we currently warming up?")

CreateConVar(preTag .. "round_in_progress"
    , 0
    , FCVAR_NONE
    , "Are we currently playing?")

CreateConVar(preTag .. "round_warmup_time"
    , 30.0
    , FCVAR_NONE
    , "The amount of time in seconds a warmup will take?")

CreateConVar(preTag .. "round_in_progress_time"
    , 360.0
    , FCVAR_NONE
    , "The amount of time in seconds a round will take?")

CreateConVar(preTag .. "round_start_team_quota"
    , 1
    , FCVAR_NONE
    , "Amount of players per team before starting game")

CreateConVar(preTag .. "round_over"
    , 0
    , FCVAR_NONE
    , "Is the round over?")

conVarWarmupTime      = GetConVar("wooc_round_warmup_time")
conVarInProgressTime  = GetConVar("wooc_round_in_progress_time")
conVarWarmup          = GetConVar("wooc_round_warmup")
conVarInProgress      = GetConVar("wooc_round_in_progress")
conVarStartQuota      = GetConVar("wooc_round_start_team_quota")
conVarTargetTickets   = GetConVar("wooc_round_target_tickets")
conVarRoundOver       = GetConVar("wooc_round_over")
conVarBotQuota       = GetConVar("wooc_bot_quota")