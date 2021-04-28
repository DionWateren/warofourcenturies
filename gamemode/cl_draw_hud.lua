local TIMER_PANEL = {
	Init = function( self )

		self.Body = self:Add( "Panel" )
		self.Body:Dock( TOP )
		self.Body:SetHeight( 40 )
		function self.Body:Paint( w, h )
			surface.SetDrawColor( 150, 255, 150 )
			draw.RoundedBox( 16, -20, 0, w/2, h, Color( 75, 75, 75, 150 ) ) 
		end

		self.Timer = self.Body:Add( "DLabel" )
		self.Timer:SetFont( "MyFont" )
		self.Timer:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Timer:Dock( LEFT )
		self.Timer:SetContentAlignment( 5 )

	end,

	PerformLayout = function( self )

		self:SetSize( 200, 100 )
		self:SetPos( 0, 0 )

	end,

	Think = function( self, w, h )

		net.Receive( "round_timer", function( len, ply )
			time = net.ReadInt( 10 )
		end)

		if ( time == nil ) then
			self.Timer:SetText( 5 )
		else
			self.Timer:SetText( time ) 
		end

	end
}

TIMER_PANEL = vgui.RegisterTable( TIMER_PANEL, "EditablePanel" )

function DrawCapturePoints()

	local cpEntsTable = ents.FindByClass("capture_point")

	for k, v in pairs(cpEntsTable) do
		
		--surface.SetDrawColor( v:GetColor():Unpack() )
		local newCol = v:GetColor()
		surface.DrawCircle( (ScrW() * 0.5) + (40 * k) - (40 * #cpEntsTable), 50, 10, newCol.r, newCol.g, newCol.b )

	end

	surface.SetDrawColor( 255, 255, 255, 128 )
	surface.DrawOutlinedRect( 25, 25, 100, 100, math.floor( math.sin( CurTime() * 5 ) * 5 ) + 10 )
	
end

hook.Add("HUDPaint", "HUDIdent", function()

	if( !IsValid( TimerPanel ) ) then
		TimerPanel = vgui.CreateFromTable( TIMER_PANEL )
	end

	if( !IsValid( TimerPanel ) ) then
		TimerPanel:Show()
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