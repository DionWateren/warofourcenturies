local ply = FindMetaTable("Player")

local teams = {}

teams[0] = {
    name = "Red",
    color = Vector( 1.0, 0.0, 0.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun"}
}
teams[1] = {
    name = "Blue",
    color = Vector( 0.0, 0.0, 1.0 ),
    weapons = { "weapon_vampcrowbar", "weapon_revolver", "weapon_bigrevolver", "weapon_chairgun"}
}

function ply:SetupTeam( n )
    if ( not teams[n] ) then return end

    self:SetTeam( n )
    self:SetPlayerColor(teams[n].color)
    self:SetHealth( 150 )
    self:SetMaxHealth( 200 )
    self:SetWalkSpeed( 100 )
    self:SetRunSpeed( 1000 )
    self:SetModel( "models/player/Group03m/Male_0" .. math.random(1,9) .. ".mdl")

    self:GiveWeapons( n )
    
end

function ply:GiveWeapons( n )
    for k, weapon in pairs(teams[n].weapons) do
        self:Give(weapon)
    end
end