AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    self:SetColor(Color(120, 120, 120))

    local phys = self:GetPhysicsObject()

    if(phys:IsValid()) then
        phys:Wake()
    end

end

function ENT:Use(a, c)

    self:SetTestInt(self:GetTestInt() + 1)

end