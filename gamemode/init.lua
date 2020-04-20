AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("teamsetup.lua")

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
function GM:ShowHelp(ply)
	ply:SetHealth(math.Clamp(ply:Health() + 25, 0, ply:GetMaxHealth()))
end

function GM:ShowTeam(ply)
	ply:SetHealth(ply:Health() - 50)
	if (ply:Health() <= 0) then
		ply:Kill()
	end
end

function GM:ShowSpare1(ply)
	print("Ouch! Stop pressing me, " .. ply:Nick() .. "!")
end

function GM:ShowSpare2(ply)
	ply:Say("I'M COOL!", false)
end

function GM:KeyPress(ply, key)

	if (key == IN_JUMP) then
			ply:SetVelocity(ply:GetVelocity() + Vector(0,0,1000))
	elseif (key == IN_DUCK) then
			ply:EmitSound("vo/Citadel/br_laugh01.wav")
	end

end

function GM:PlayerDisconnected( ply )

	if (motionsensor.Active()) then
		motionsensor.Stop()
	end

end