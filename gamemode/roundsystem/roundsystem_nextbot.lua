botNameTable = {
    "Herman",
    "Yoeri",
    "Indy",
    "Thijs",
    "Dion",
    "Piet"
}

local cpTable = {}

hook.Add( "StartCommand", "astar_example", function( ply, cmd )

	// Only run this code on bots, and only if bot_mimic is set to 0
	if ( !ply:IsBot() ) then return end
	
	cmd:ClearButtons()
	cmd:ClearMovement()

	if (table.IsEmpty(cpTable)) then
		
		cpTable = ents.FindByClass("capture_point")

	else
		if(!ply.targetCP || ply.targetCP == nil || !ply.targetCP:IsValid()) then

			ply.targetCP = cpTable[math.random(#cpTable)]

		else
			if(ply.targetCP:GetTeamOwnership() == ply:Team() && ply.targetCP:GetIsCaptured()) then
				ply.targetCP = nil 
			else
				if( MoveToTargetEnt(ply, ply.targetCP) ) then
	
					// We got the target to go to, aim there and MOVE
					local targetang = ( ply.targetArea:GetCenter() - ply:GetPos() ):GetNormalized():Angle()
					cmd:SetViewAngles( targetang )
					cmd:SetForwardMove( 1000 )
				
				end
			end
		end
	end

	if ( !IsValid( ply.CustomEnemy ) ) then
		-- Scan through all players and select one not dead
		for id, pl in ipairs( player.GetAll() ) do
			if ( !pl:Alive() or pl == ply or pl:Team() == ply:Team() ) then continue end -- Don't select dead players
			ply.CustomEnemy = pl
		end
		-- TODO: Maybe add a Line Of Sight check so bots won't walk into walls to try to get to their target
		-- Or add path finding so bots can find their way to enemies
	end
	-- We failed to find an enemy, don't do anything
	if ( !IsValid( ply.CustomEnemy ) ) then return end
	
	-- Aim at our enemy
	-- if ( ply.CustomEnemy:IsPlayer() ) then
	-- 	cmd:SetViewAngles( ( ply.CustomEnemy:GetPos() - ply:GetShootPos() ):GetNormalized():Angle() )
	-- else
	-- 	cmd:SetViewAngles( ( ply.CustomEnemy:GetPos() - ply:GetShootPos() ):GetNormalized():Angle() )
	-- end
	-- Give the bot a crowbar if the bot doesn't have one yet
	if ( SERVER and !ply:HasWeapon( "weapon_pistol" ) ) then ply:Give( "weapon_pistol" ) ply:GiveAmmo( 400, "pistol", true ) end
	-- Select the crowbar
	cmd:SelectWeapon( ply:GetWeapon( "weapon_pistol" ) )
	-- Hold Mouse 1 to cause the bot to attack
	cmd:SetButtons( IN_ATTACK )
	-- Enemy is dead, clear our enemy so that we may acquire a new one
	if ( !ply.CustomEnemy:Alive() ) then
		ply.CustomEnemy = nil
	end

end)