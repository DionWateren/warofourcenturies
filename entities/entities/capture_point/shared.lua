ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.ClassName = "capture_point"

ENT.PrintName = "Capture Point"

ENT.Spawnable = true 

function ENT:SetupDataTables()

    self:NetworkVar("String",   0, "CaptureName")
    self:NetworkVar("Int",      1, "PlayersOnPoint")

    self:NetworkVar("Float",    10, "CaptureRadius")
    self:NetworkVar("Float",    11, "CaptureProgress")
    self:NetworkVar("Float",    12, "CaptureSpeed")
    self:NetworkVar("Float",    13, "CaptureMax")

    if (SERVER) then
        
        self:SetCaptureName     ("Unnamed Capture Point")
        self:SetPlayersOnPoint  (0)

        self:SetCaptureRadius   (300.0)
        self:SetCaptureProgress (0.0)
        self:SetCaptureSpeed    (0.5)
        self:SetCaptureMax      (100.0)

    end
end