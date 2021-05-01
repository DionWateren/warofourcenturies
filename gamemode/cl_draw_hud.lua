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
		--self.Body:Center()
		function self.Body:Paint( w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color( 75, 75, 75, 150 ) ) 
		end

		self.Timer = self.Body:Add( "DLabel" )
		self.Timer:SetFont( "MyFont" )
		self.Timer:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Timer:Dock( TOP )
		self.Timer:Center()

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
			self.Timer:SetText( "--" )
		else
			self.Timer:SetText( time ) 
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

function DrawCapturePoints()

	local cpEntsTable = ents.FindByClass("capture_point")

	for k, v in pairs(cpEntsTable) do
		
		local newCol = v:GetColor()
		surface.DrawCircle( (ScrW() * 0.5) + (40 * (k - (#cpEntsTable * 0.5))) - (40 * #cpEntsTable), 50, 10, newCol.r, newCol.g, newCol.b )
		
		-- if (v:GetTeamOwnership() > 0) then
		-- 	surface.SetMaterial( GetTeamLogoMaterial(v:GetTeamOwnership()))
		-- 	surface.DrawCircle( 500, 500, 100 + math.sin( CurTime() ) * 50, Color( 255, 255, 255, newCol.r ) )
		-- end
		
	end
	
end

hook.Add("HUDPaint", "HUDIdent", function()

	if( !IsValid( HeaderPanel ) ) then
		HeaderPanel = vgui.CreateFromTable( HEADER_PANEL )
		HeaderPanel:Show()
	end

	if( !IsValid( RightPanel ) ) then
		RightPanel = vgui.CreateFromTable( RIGHT_PANEL )
		RightPanel:Show()
	end

	local ply = LocalPlayer()

	DrawCapturePoints()

	local logoMat = GetTeamLogoMaterial(ply:Team())
	if(logoMat != nil) then
		surface.SetMaterial( GetTeamLogoMaterial(ply:Team()) )
		
	end

	surface.SetDrawColor( 255, 200, 200, 255)
	surface.DrawTexturedRect( 30, ScrH() - 148, 128*( ply:Health() / ply:GetMaxHealth() ), 128 )

	draw.SimpleText( ply:Health(), "MyFont", 30 + 150, ScrH() - 70 + 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.DrawCircle( 50, 50, 100 + math.sin( CurTime() ) * 50, 255, 0, 0 )
	
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