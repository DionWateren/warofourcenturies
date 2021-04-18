AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "teamsetup.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "roundsystem.lua" )
AddCSLuaFile( "vgui/menu_main.lua" )
AddCSLuaFile( "resources.lua" )


include ( "resources.lua" )

include ( "shared.lua" )
include ( "teamsetup.lua" )
include ( "roundsystem.lua" )
include ( "concommands.lua" )

util.AddNetworkString( "f4menu" )
util.AddNetworkString( "playdeathsound" )

util.AddNetworkString( "round_timer" )
util.AddNetworkString( "round_active" )

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

function GM:Initialize()

	file.Write("soundscripts.txt",table.concat(sound.GetTable(),"\n"))

end

function GM:PlayerSpawn( ply )
	ply:ChatPrint("You have spawned!")

	ply:SetupHands()
	ply:SetupTeam( math.random( 0, 2 ) )
	--ply:SetupTeam( AutoBalance() )

	timer.Create( "HPregen" .. ply:UserID(), 1, 0, function()
		if( !IsValid( ply ) ) then return end
		ply:SetHealth( math.Clamp( ply:Health() + 1, 0, ply:GetMaxHealth() ) )

		--PrintMessage( HUD_PRINTTALK, "Reps Left: " .. timer.RepsLeft( "HPregen" .. ply:UserID() ) )
		--PrintMessage( HUD_PRINTTALK, "Time Left Next Rep: " .. timer.TimeLeft( "HPregen" .. ply:UserID() ) )

	end)

	test_trail = util.SpriteTrail( ply, 0, Color(math.Rand(0, 255), math.Rand(0, 255), math.Rand(0, 255)), false, 100, 0, 3, 1/(100) * 0.5, "trails/plasma.vmt")

	ply:GiveAmmo( 100, "SMG1", false )

	if ( roundActive == true ) then
		ply:KillSilent()
		return
	else
		RoundStart()
	end

end


function GM:PlayerDeathSound()
	return false
end

local temp_death_sound = Sound( "effects/death_0.mp3" )

function GM:PlayerDeath( ply )

	sound.Play( temp_death_sound, ply:GetPos(), 100, math.random( 25, 175 ), 1 )
	--net.Start( "playdeathsound" )
	--net.Send( ply )

	SafeRemoveEntity( test_trail )

	-- RoundEndCheck()
end

function GM:PlayerDeathThink( ply )

	if ( roundActive == false ) then
		ply:Spawn()
		return true
	else
		return false
	end

end

-- function GM:PlayerSelectSpawn( ply, transition )
-- 	print('player is selecting spawn')
-- 	local v = Vector{ 0, 0, 0 }
-- 	return v
-- end

function GM:PlayerDisconnected( ply )

	if ( timer.Exists( "HPregen" .. ply:UserID() ) ) then
		timer.Remove( "HPregen" .. ply:UserID() )
	end

	RoundEndCheck()
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

	--if (motionsensor.Active()) then
	--	motionsensor.Stop()
	--end

end