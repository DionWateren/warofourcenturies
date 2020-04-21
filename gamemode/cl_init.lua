include("shared.lua")
include("vgui/menu_main.lua")

surface.CreateFont( "MyFont", {
	font = "Arial",
	size = 30,
	weight = 500,
	blursize = 0,
	scanline = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

hook.Add("HUDPaint", "HUDIdent", function()

	local ply = LocalPlayer()

	surface.SetDrawColor( 50, 50, 50, 255)
	surface.DrawRect( 30 - 2, ScrH() - 70 - 2, 300 + 4, 30 + 4)

	surface.SetDrawColor( 255, 100, 100, 255)
	surface.SetTexture( 10 )
	surface.DrawTexturedRect( 30, ScrH() - 70, 300*( ply:Health() / ply:GetMaxHealth() ), 30 )

	draw.SimpleText( ply:Health(), "MyFont", 30 + 150, ScrH() - 70 + 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.DrawCircle( 50, 50, 25, 255, 0, 0 )
	
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

	--for i=1, 11 do
	--	surface.SetTexture( i )
	--	surface.DrawTexturedRect( 10 + 100*i, 10, 100, 100)
	--end
--
	--for i=1, 11 do
	--	surface.SetTexture( 11 + i )
	--	surface.DrawTexturedRect( 10 + 100*i, 110, 100, 100)
	--end

end)

function GM:Initialize()
	surface.PlaySound( "temp_song0.mp3" )

	print("Starting motionsensor" )

	if ( !motionsensor.IsAvailable() ) then 
		print("Motionsensor not available!" )
		return 
	end

	--if ( !motionsensor.IsActive() ) then 
	--	print("Motionsensor not active!" )
	--	return 
	--end

	motionsensor.Start()
end

function GM:Think()

	if ( !motionsensor.IsAvailable() ) then return end
	
	if ( !motionsensor.IsActive() ) then return end

	local ply = LocalPlayer()

	for k, v in pairs( motionsensor.DebugBones ) do
 
		debugoverlay.Line( ply:MotionSensorPos( v[1] ), ply:MotionSensorPos( v[2] ), 0.5, Color(0, 255, 0), true )
	
	end

end

net.Receive( "f4menu", function() 
	if( !MainMenu ) then
		MainMenu = vgui.Create( "menu_main" )
		MainMenu:SetVisible( false )
	end

	if ( MainMenu:IsVisible() ) then
		MainMenu:SetVisible( false )
		gui.EnableScreenClicker( false )
	else
		MainMenu:SetVisible( true )
		gui.EnableScreenClicker( true )
	end
end)

function GM:HUDShouldDraw( name )
	local hud = {"CHudHealth", "CHudBattery", "CHudAmmo"}
	for k, element in pairs( hud ) do
		if name == element then return false end
	end
	return true
end

function GetActiveWeapon( ply )
	if ( !IsValid( ply ) ) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( !IsValid(wep) ) then return -1 end

	return wep
end

--local message = "My Text"
--
--hook.Add("HUDPaint", "HUDIdent", function()
--
--	surface.SetAlphaMultiplier( 1 )
--
--	surface.SetDrawColor( 200, 200, 100, 125 )
--
--	surface.DrawOutlinedRect( 10, 10, 100, 100 )
--	surface.DrawCircle( 120, 60, 50, 100, 200, 200, 125)
--	surface.DrawLine( 230, 10, 330, 110)
--	surface.DrawRect( 110, 10, 100, 100)
--
--	surface.SetTexture( 23 )
--	surface.DrawTexturedRect( 10, 120, 100, 100 )
--
--	local width, height = surface.GetTextSize( message )
--
--	surface.SetFont( "MyFont" )
--	surface.SetTextPos( ScrW()/2 - width/2, ScrH()/2 - height/2 )
--	surface.SetTextColor( 100, 100, 200, 125 )
--	surface.DrawText( message )
--
--	
--end)

--hook.Add("HUDPaint", "HUDIdent", function()
--
--	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 120, 120, 120, 120 ) )
--	draw.RoundedBox( 0, 0, 0, 100, 100, Color( 0, 0, 0, 255 ) )
--
--	draw.SimpleText("Whatever", "DermaDefault", ScrW()/2, ScrH()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
--
--end)