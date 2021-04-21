include("shared.lua")

-- Draw some 3D text
local function Draw3DCapturePoint( e, pos, scale, text, flipView )
    
	local ang = Angle( 0, LocalPlayer():GetAngles().y - 90, 90 )

	if ( flipView ) then
		-- Flip the angle 180 degrees around the UP axis
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )
	end

	cam.Start3D2D( pos, ang, scale )
		-- Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "DermaLarge", 0, 0, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
    cam.End3D2D()

end

function ENT:Draw()

	-- Draw the model
	self:DrawModel()

	-- The text to display
	local text = tostring(self:GetPlayersOnPoint())

	-- The position. We use model bounds to make the text appear just above the model. Customize this to your liking.
	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 60 )

	-- Draw front
	Draw3DCapturePoint( self, pos, 2.0, text, false )
	-- DrawDraw3DTextback
	Draw3DCapturePoint( self, pos, 2.0, text, true )

end

function ENT:Think()
    
end
