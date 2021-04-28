include( "shared.lua" )
include( "cl_scoreboard.lua" )
include( "vgui/menu_main.lua" )
include( "cl_handle_capture_points.lua" )
include( "cl_draw_hud.lua" )
include( "cl_font_setup.lua" )
include( "teamsetup.lua" )

local alpha = 0

hook.Add("PostDrawTranslucentRenderables", "DebugDrawLines", function()
    alpha = 128 + math.sin(CurTime()) * 127;

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

function GM:Initialize()
	InitialiseTeams()
end

function GM:Think()


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