ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.ClassName = "capture_point"

ENT.PrintName = "Capture Point"

ENT.Spawnable = true 

function ENT:SetupDataTables()
    
    self:NetworkVar("String",   0, "CaptureName")
    self:NetworkVar("Int",      1, "PlayersOnPoint")
    self:NetworkVar("Int",      2, "TeamCapturing")
    self:NetworkVar("Int",      3, "TeamOwnership")

    self:NetworkVar("Bool",     9, "IsCaptured")
    self:NetworkVar("Float",    10, "CaptureRadius")
    self:NetworkVar("Float",    11, "CaptureProgress")
    self:NetworkVar("Float",    12, "CaptureSpeed")
    self:NetworkVar("Float",    13, "CaptureMax")
    self:NetworkVar("Float",    14, "CaptureDecay")

    if (SERVER) then
        
        self:SetCaptureName     ("Unnamed Capture Point")
        self:SetPlayersOnPoint  (0)
        self:SetTeamCapturing   (-1)
        self:SetTeamOwnership   (-1)

        self:SetIsCaptured      (false)

        self:SetCaptureRadius   (300.0)
        self:SetCaptureProgress (0.0)
        self:SetCaptureSpeed    (5.0)
        self:SetCaptureMax      (100.0)
        self:SetCaptureDecay    (2.5)

    end
end