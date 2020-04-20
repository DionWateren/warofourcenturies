AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("vgui/menu_main.lua")

include ("shared.lua")
include ("teamsetup.lua")

function GM:PlayerSpawn( ply )
	ply:ChatPrint("You have spawned!")

	ply:SetupHands()
	ply:SetupTeam( math.random( 0, 1 ) )

	timer.Create("HPregen" .. ply:UserID(), 1, 0, function()
		ply:SetHealth( math.Clamp( ply:Health() + 1, 0, ply:GetMaxHealth() ) )

		--PrintMessage( HUD_PRINTTALK, "Reps Left: " .. timer.RepsLeft( "HPregen" .. ply:UserID() ) )
		--PrintMessage( HUD_PRINTTALK, "Time Left Next Rep: " .. timer.TimeLeft( "HPregen" .. ply:UserID() ) )

	end)

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
		return false
	elseif( attacker:IsWorld() ) then
		return true
	elseif( false ) then -- check if prop!!!!!
		return false
	else
		att = attacker:GetOwner()
	end

	--if (ply:Team() == att:Team()) then
	--	return true
	--end

	return true
end

-- input
util.AddNetworkString( "f4menu" )

function GM:ShowSpare2( ply )
	net.Start( "f4menu" )
	net.Send( ply )
end

function GM:PlayerDisconnected( ply )

	if (motionsensor.Active()) then
		motionsensor.Stop()
	end

end