AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/mechanics/wheels/tractor.mdl")
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    
    self:SetColor(Color(255, 255, 255))

end

function ENT:Think()

    local playersInRadiusTable = ents.FindInSphere(self:GetPos(), self:GetCaptureRadius())
    local playerCount = 0
    
    local teamsTable = {}

    for k, v in pairs(playersInRadiusTable) do
        -- check if players in radius are player entities
        if((v:EntIndex() > 0 && v:EntIndex() < game.MaxPlayers()) 
                && v:Alive()) then
            
            playerCount = playerCount + 1

            if(teamsTable[v:Team()] == nil) then
                teamsTable[v:Team()] = 0
            end
            
            teamsTable[v:Team()] = teamsTable[v:Team()] + 1
        end
    end

    local newProgression = self:GetCaptureProgress()
    
    if (playerCount > 0) then
        -- which team is dominant
        local dominantTeam = -1
        local plyNum = -1
        for k, v in pairs(teamsTable) do
            
            if (v > plyNum) then
                plyNum = v
                dominantTeam = k
            elseif (v == plyNum) then
                dominantTeam = -1
            end

        end

        -- set capture state
        self:SetTeamCapturing(dominantTeam)
        
        -- if new progression has been logged and no owner has been set yet
        if (newProgression >= 0 && self:GetTeamOwnership() == -1) then
            self:SetTeamOwnership(dominantTeam)
        elseif (newProgression <= 0) then
            self:SetTeamOwnership(-1)
        end
        -- check/set cp team capturing
        if (dominantTeam != -1) then
            if (self:GetTeamOwnership() == self:GetTeamCapturing()) then
                newProgression = newProgression + (FrameTime() + self:GetCaptureSpeed())
            else
                newProgression = newProgression - (FrameTime() + self:GetCaptureSpeed())
            end
        end
    else

        self:SetTeamCapturing(-1)
        
        if (newProgression < self:GetCaptureMax()) then
            newProgression = newProgression + ((self:GetIsCaptured() and 1 or -1) * (FrameTime() + self:GetCaptureDecay()))
            if (newProgression <= 0) then
                self:SetTeamOwnership(-1)
            end
        end
    end

    if (newProgression > self:GetCaptureMax()) then
        newProgression = self:GetCaptureMax()
        self:SetIsCaptured(true)
    elseif (newProgression <= 0) then
        newProgression = 0
        self:SetIsCaptured(false)
    end
    
    -- update cp progression
    self:SetCaptureProgress(newProgression)

    self:SetPlayersOnPoint(playerCount)

    -- check for correct teams
    if (self:GetTeamOwnership() > 0 && self:GetTeamOwnership() < 1000) then

        local newColor = team.GetColor(self:GetTeamOwnership()):ToVector()

        local frac = newProgression / self:GetCaptureMax()
        local lerpedColor = LerpVector(frac, Vector(1, 1, 1), newColor):ToColor()
        
        self:SetColor( lerpedColor )
    end
end