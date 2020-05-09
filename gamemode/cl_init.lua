include( "shared.lua" )
include( "cl_scoreboard.lua" )
include( "vgui/menu_main.lua" )

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

RoundActive = false

net.Receive( "round_active", function( len )
	RoundActive = net.ReadBool()
end)

local place_holder_0 = Material( "hud/0_potato_logo.png",	"noclamp" )
local place_holder_1 = Material( "hud/1_penguin_logo.png", 	"noclamp" )
local place_holder_2 = Material( "hud/2_banana_logo.png", 	"noclamp" )

hook.Add("HUDPaint", "HUDIdent", function()

	if( !IsValid( TimerPanel ) ) then
		TimerPanel = vgui.CreateFromTable( TIMER_PANEL )
	end

	if( !IsValid( TimerPanel ) ) then
		TimerPanel:Show()
	end

	local ply = LocalPlayer()

	if ( ply:Team() == 0 ) then
		surface.SetMaterial( place_holder_0 )
	elseif ( ply:Team() == 1 ) then
		surface.SetMaterial( place_holder_1 )
	elseif ( ply:Team() == 2 ) then
		surface.SetMaterial( place_holder_2 )
	end
	--surface.DrawTexturedRect( 30 - 2, ScrH() - 148 - 2, 128 + 4, 128 + 4)

	--surface.SetTexture( 10 )
	surface.SetDrawColor( 255, 200, 200, 255)
	surface.DrawTexturedRect( 30, ScrH() - 148, 128*( ply:Health() / ply:GetMaxHealth() ), 128 )

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

	-- surface.PlaySound( "temp_song0.mp3" )

	print("Trying to start motionsensor" )

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

local temp_death_sound = Sound( "effects/death_0.mp3" )

net.Receive( "playdeathsound", function()

	--if ( IsValid( temp_death_sound ) ) then
	sound.Play( temp_death_sound, LocalPlayer():GetPos() )
	--surface.PlaySound( temp_death_sound )

	--end

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