include( "shared.lua" )
include( "cl_scoreboard.lua" )
include( "vgui/menu_main.lua" )
include( "cl_handle_capture_points.lua" )
include( "cl_draw_hud.lua" )
include( "cl_font_setup.lua" )
include( "teamsetup/teamsetup.lua" )

targetTickets = -1

function GM:Initialize()

	InitialiseTeams()

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

net.Receive( "target_tickets", function()

	targetTickets = net.ReadUInt( 10 )

end)

local hideHud = {
	["CHudHealth"] 	= true,
	["CHudBattery"] = true,
	["CHudAmmo"] 	= true
}

function GM:HUDShouldDraw( name )
	if ( hideHud[name] ) then
		return false
	end
	return true
end

function GetActiveWeapon( ply )
	if ( !IsValid( ply ) ) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return -1 end

	return wep
end