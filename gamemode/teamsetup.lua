local ply = FindMetaTable( "Player" )

local teams = {}

teams[0] = {
    name = "Royal Potatos",
    color = Vector( 1.0, 0.0, 0.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0"  },
    p_models = { [0] = "Parrotv3" },
}
teams[1] = {
    name = "Curious Penguins",
    color = Vector( 0.0, 0.0, 1.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0"  },
    p_models = { [0] = "BFOL_Penguin_0" },
}
teams[2] = {
    name = "Crazy Bananas",
    color = Vector( 1.0, 1.0, 0.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun", "weapon_weirdsmg_0"},
    p_models = { [0] = "BFOL_Banana-Man_0" },
}

player_manager.AddValidModel( "BFOL_Banana-Man_0", "models/player/rebs/BFOL_Banana-Man_0/BFOL_Banana-Man.mdl" );
player_manager.AddValidModel( "BFOL_Penguin_0", "models/player/rebs/BFOL_Penguin-Man_0/BFOL_Penguin.mdl" );

player_manager.AddValidModel( "Parrotv3", "models/player/rebs/parrotv3_pm/parrotv3.mdl" );

function ply:SetupTeam( n )
    if ( not teams[n] ) then return end

    self:SetTeam( n )
    self:SetPlayerColor(teams[n].color)
    self:SetHealth( 150 )
    self:SetMaxHealth( 200 )
    self:SetWalkSpeed( 100 )
    self:SetRunSpeed( 1000 )

    --print( type( teams[n].p_models[0] ) )
    --print( teams[n].p_models[0] )

    local pm_models = player_manager.AllValidModels()
    self:SetModel( pm_models[teams[n].p_models[0]] )

    self:GiveWeapons( n )
    
end

function ply:GiveWeapons( n )
    for k, weapon in pairs( teams[n].weapons ) do
        self:Give( weapon )
    end
end