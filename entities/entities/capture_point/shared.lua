ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.ClassName = "capture_point"

ENT.PrintName = "Capture Point"

ENT.Spawnable = true 

function ENT:SetupDataTables()

    self:NetworkVar("Int", 1, "TestInt")

end