local alpha = 150

local customMaterial = Material( "color" )

hook.Add("PostDrawTranslucentRenderables", "DrawCapturePointRadius", function()

	local capturePointTable = ents.FindByClass("capture_point")

	render.SetMaterial( customMaterial )

	for k, v in pairs(capturePointTable) do
		
		local pos = v:GetPos()


		local radius = v:GetCaptureRadius()
		local wideSteps = 10
		local tallSteps = 10

		-- Draw the sphere!
		render.DrawSphere( pos, radius, wideSteps, tallSteps, Color( 0, 175, 175, 50 ) )

	end
end)