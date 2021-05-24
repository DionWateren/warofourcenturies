function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local HEADER_PANEL = {
	Init = function( self )
		
		self.Body = self:Add( "DPanel" )
		self.Body:SetSize(400, 400)
		self.Body:Dock(FILL)
		function self.Body:Paint( w, h )
			--draw.RoundedBox( 6, 0, 0, w, h, Color( 75, 75, 75, 150 ) ) 
		end

		self.Timer = self.Body:Add( "DLabel" )
		self.Timer:SetFont( "MyFont" )
		self.Timer:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Timer:SetSize(ScrW(), 50)
		self.Timer:Dock(TOP)
		self.Timer:SetContentAlignment(5)
		function self.Timer:Paint(w, h)
			--draw.RoundedBox( 6, 0, 0, w, h, Color( 63, 26, 226, 150) ) 
		end

		self.CapturePoints = self.Body:Add("DPanel")
		self.CapturePoints:SetSize(ScrW(), 100)
		self.CapturePoints:Dock(TOP)
		self.CapturePoints:SetContentAlignment(5)
		function self.CapturePoints:Paint(w, h)
			--draw.RoundedBox( 6, 0, 0, w, h, Color( 218, 0, 0, 150) ) 
			
			local cpEntsTable = ents.FindByClass("capture_point")
			local cpHorOffset = 30
			local cpCircleRadius = 10

			for k, v in pairs(cpEntsTable) do
				
				local newCol = v:GetColor()
				local newPos = Vector()
				newPos.x = (w * 0.5 - ((#cpEntsTable-1) * (cpHorOffset)) * 0.5) + ((k-1) * cpHorOffset)
				newPos.y = h * 0.5
				surface.DrawCircle( newPos.x, newPos.y, cpCircleRadius, newCol.r, newCol.g, newCol.b )
				
				-- if (v:GetTeamOwnership() > 0) then
				-- 	surface.SetMaterial( GetTeamLogoMaterial(v:GetTeamOwnership()))
				-- 	surface.DrawCircle( 500, 500, 100 + math.sin( CurTime() ) * 50, Color( 255, 255, 255, newCol.r ) )
				-- end
				
			end
		end
	end,

	PerformLayout = function( self )
		self:SetSize( ScrW(), 200 )
		-- self:SetPos( ScrW() * 0.5, 0 )

	end,

	Think = function( self, w, h )

		net.Receive( "round_timer", function( len, ply )
			time = net.ReadInt( 10 )
		end)

		if ( time == nil ) then
			self.Timer:SetText( "Waiting for players..." )
		else
			self.Timer:SetText( string.FormattedTime(time, "%02i:%02i") ) 
		end
	end
}

local RIGHT_PANEL = {
	Init = function( self )
		
		self.Body = self:Add( "DPanel" )
		self.Body:Dock(FILL)
		function self.Body:Paint( w, h )
			--draw.RoundedBox( 6, 0, 0, w, h, Color( 243, 64, 64, 150) ) 
		end

		self.TicketPanel = self.Body:Add("DPanel")
		self.TicketPanel:SetSize(200, 0)
		self.TicketPanel:Dock(RIGHT)
		function self.TicketPanel:Paint( w, h )
			-- draw.RoundedBox( 6, 0, 0, w, h, Color( 115, 238, 146, 100) ) 

			local textHorOffset = 50
			local circleRadius = 40

			surface.SetFont( "MyFont" )
			surface.SetTextColor( 79, 205, 255)
			surface.SetTextPos( w*0.5-textHorOffset, h*0.5- 210 ) 
			surface.DrawText( targetTickets )

			surface.SetFont( "MyFont" )
			surface.SetTextColor( 53, 53, 53)
			surface.SetTextPos( w*0.5-textHorOffset, h*0.5- 205 ) 
			surface.DrawText( "____" )

			for i=1, GetTeamCount() do

				local logoMat = GetTeamLogoMaterial(i)
				if(logoMat != nil) then
					surface.SetMaterial( GetTeamLogoMaterial(i) )
				end

				local heightOffset = 100 
				local newHeight = (h * 0.5 + ((i-1) * heightOffset)) - (heightOffset * GetTeamCount() * 0.5)
				
				surface.SetDrawColor( 255, 255, 255)
				draw.Circle(w*0.75, newHeight, circleRadius, 40)

				surface.SetFont( "MyFont" )
				surface.SetTextColor( 255, 255, 255 )
				surface.SetTextPos( w*0.5-textHorOffset, newHeight - (circleRadius * 0.4)) 
				surface.DrawText( GetTeamCurrentTickets(i) )
				
			end
		end

	end,

	PerformLayout = function( self )
		self:SetSize( ScrW(), ScrH() )
		-- self:SetPos( ScrW() * 0.5, 0 )

	end,

	Think = function( self, w, h )

	end
}

HEADER_PANEL 			= vgui.RegisterTable( HEADER_PANEL, "EditablePanel" )
RIGHT_PANEL 			= vgui.RegisterTable( RIGHT_PANEL, "EditablePanel" )

function DrawDebugLines()

	surface.DrawRect( ScrW() * 0.5 - 1, 0, 
	2, ScrH(), Color( 53, 53, 53, 180) ) 

	surface.DrawRect( 0, ScrH() * 0.5 - 1, 
	ScrW(), 2, Color( 53, 53, 53, 180) ) 
	
	hook.Add("PostDrawTranslucentRenderables", "DebugDrawLines", function()

		render.SetColorMaterial()

		-- The position to render the sphere at, in this case, the looking position of the local player
		local pos = LocalPlayer():GetEyeTrace().HitPos

		local trace = LocalPlayer():GetEyeTrace()
		local angle = trace.HitNormal:Angle()
			
		render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Forward(), Color( 255, 0, 0 ), true )
		render.DrawLine( trace.HitPos, trace.HitPos + 8 * -angle:Right(), Color( 0, 255, 0 ), true )
		render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Up(), Color( 0, 0, 255 ), true )
			
		cam.Start3D2D( trace.HitPos, angle, 1 )
			surface.SetDrawColor( 255, 165, 0, 255 )
			surface.DrawRect( 0, 0, 8, 8 )
			render.DrawLine( Vector( 0, 0, 0 ), Vector( 8, 8, 8 ), Color( 100, 149, 237, 255 ), true )
		cam.End3D2D()
	end)
end

hook.Add("HUDPaint", "HUDIdent", function()

	--DrawDebugLines()

	if( !IsValid( HeaderPanel ) ) then
		HeaderPanel = vgui.CreateFromTable( HEADER_PANEL )
		HeaderPanel:Show()
	end

	if( !IsValid( RightPanel ) ) then
		RightPanel = vgui.CreateFromTable( RIGHT_PANEL )
		RightPanel:Show()
	end

	local ply = LocalPlayer()

	local logoMat = GetTeamLogoMaterial(ply:Team())
	if(logoMat != nil) then
		surface.SetMaterial( GetTeamLogoMaterial(ply:Team()) )
		
	end

	surface.SetDrawColor( 255, 200, 200, 255)
	surface.DrawTexturedRect( 30, ScrH() - 148, 128*( ply:Health() / ply:GetMaxHealth() ), 128 )

	draw.SimpleText( ply:Health(), "MyFont", 30 + 150, ScrH() - 70 + 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if ( !IsValid( ply ) ) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( !IsValid(wep) ) then return -1 end

	local clip1 = GetActiveWeapon( ply ):Clip1()
	local maxclip1 = GetActiveWeapon( ply ):GetMaxClip1()

	surface.SetDrawColor( 150, 150, 25, 255)
	surface.DrawRect( ScrW() - 100, ScrH() - 200, 30, 150)

	surface.SetDrawColor( 250, 250, 50, 255)
	surface.SetTexture( 10 )
	surface.DrawTexturedRect( ScrW() - 100, ScrH() - 200, 30, 150*(clip1 / maxclip1) )

end)