AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "teamsetup.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "vgui/menu_main.lua" )

-- sounds
resource.AddFile( "sound/temp_song0.mp3" )
-- models
resource.AddFile( "models/player/rebs/parrotv3_pm/parrotv3.mdl" )
resource.AddFile( "materials/models/parrot_rc/parrot/parrot_texture.vmt" )

include ( "shared.lua" )
include ( "teamsetup.lua" )
include ( "concommands.lua" )

util.AddNetworkString( "f4menu" )

hook.Add( "PlayerSay", "CommandIdent", function( ply, text, bteam ) 

	text = string.lower( text )

	if( text == "!buddy" ) then

		local spawns = ents.FindByClass( "info_player_start" )
		local random_entry = math.random( #spawns )
		local Ent = ents.Create( "npc_zombie" )

		if( !IsValid( Ent ) ) then return end

		local tr = ply:GetEyeTrace()

		--Ent:SetPos( spawns[random_entry]:GetPos() + Vector(0, 0, 5) )
		Ent:SetPos( tr.HitPos + Vector(0, 0, 5) )
		Ent:Spawn()

	end

end)

function GM:PlayerSpawn( ply )
	ply:ChatPrint("You have spawned!")

	ply:SetupHands()
	ply:SetupTeam( math.random( 0, 1 ) )

	timer.Create( "HPregen" .. ply:UserID(), 1, 0, function()
		ply:SetHealth( math.Clamp( ply:Health() + 1, 0, ply:GetMaxHealth() ) )

		--PrintMessage( HUD_PRINTTALK, "Reps Left: " .. timer.RepsLeft( "HPregen" .. ply:UserID() ) )
		--PrintMessage( HUD_PRINTTALK, "Time Left Next Rep: " .. timer.TimeLeft( "HPregen" .. ply:UserID() ) )

	end)

	test_trail = util.SpriteTrail( ply, 0, Color(math.Rand(0, 255), math.Rand(0, 255), math.Rand(0, 255)), false, 100, 0, 3, 1/(100) * 0.5, "trails/plasma.vmt")
end

function GM:PlayerDeath( ply )
	SafeRemoveEntity( test_trail )
end

function GM:PlayerDisconnected( ply )

	if ( timer.Exists( "HPregen" .. ply:UserID() ) ) then
		timer.Remove( "HPregen" .. ply:UserID() )
	end

end

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:PlayerShouldTakeDamage(ply, attacker)

	local att
	if( attacker:IsPlayer() ) then
		att = attacker
	elseif( attacker:IsNPC() ) then
		return true
	elseif( attacker:IsWorld() ) then
		return true
	elseif( false ) then -- check if physics prop!!!!!
		return false
	else
		att = attacker:GetOwner()
	end

	--if (ply:Team() == att:Team()) then
	--	return true
	--end

	return true
end

function GM:ShowSpare1( ply )
	local botamount = 10
	PrintMessage( HUD_PRINTTALK, "Spawning " .. botamount .. " bots" )
	for i=0, botamount do
		RunConsoleCommand( "bot", "" )
	end
end

function GM:ShowSpare2( ply )
	net.Start( "f4menu" )
	net.Send( ply )
end

function GM:PlayerDisconnected( ply )

	if (motionsensor.Active()) then
		motionsensor.Stop()
	end

end