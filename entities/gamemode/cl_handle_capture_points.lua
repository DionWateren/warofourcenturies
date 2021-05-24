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

		local newCol = v:GetColor()
		newCol.a = 50

		-- Draw the sphere!
		render.DrawSphere( pos, radius, wideSteps, tallSteps, newCol )

	end
end)