include("shared.lua")

function ENT:Draw()

    self:DrawModel()

    print(self:GetTestInt())

end