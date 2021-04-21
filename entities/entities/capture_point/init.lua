AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/mechanics/wheels/tractor.mdl")
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    
    self:SetColor(Color(120, 255, 120))

end

function ENT:Think()

    local playersInRadiusTable = ents.FindInSphere(self:GetPos(), self:GetCaptureRadius())
    local playerCount = 0

    for k, v in pairs(playersInRadiusTable) do
        if(v:EntIndex() > 0 && v:EntIndex() < game.MaxPlayers()) then
            
            playerCount = playerCount + 1
            print(v)
        end
    end
    
    self:SetPlayersOnPoint(playerCount)
end