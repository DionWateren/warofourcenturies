botNameTable = {
    "Herman",
    "Yoeri",
    "Indy",
    "Thijs",
    "Dion",
    "Piet"
}

hook.Add( "StartCommand", "StartCommandExample", function( ply, cmd )

	-- If the player is not a bot or the bot is dead, do not do anything
	-- TODO: Maybe spawn the bot manually here if the bot is dead
	if ( !ply:IsBot() or !ply:Alive() ) then return end

	-- Clear any default movement or actions
	cmd:ClearMovement() 
	cmd:ClearButtons()

	-- Bot has no enemy, try to find one
	if ( !IsValid( ply.CustomEnemy ) ) then
		-- Scan through all players and select one not dead
		for id, pl in ipairs( player.GetAll() ) do
			if ( !pl:Alive() or pl == ply ) then continue end -- Don't select dead players or self as enemies 
			ply.CustomEnemy = pl
		end
		-- TODO: Maybe add a Line Of Sight check so bots won't walk into walls to try to get to their target
		-- Or add path finding so bots can find their way to enemies
	end

	-- We failed to find an enemy, don't do anything
	if ( !IsValid( ply.CustomEnemy ) ) then return end

	-- Move forwards at the bots normal walking speed
	cmd:SetForwardMove( ply:GetWalkSpeed() )

	-- Aim at our enemy
	if ( ply.CustomEnemy:IsPlayer() ) then
		cmd:SetViewAngles( ( ply.CustomEnemy:GetShootPos() - ply:GetShootPos() ):GetNormalized():Angle() )
	else
		cmd:SetViewAngles( ( ply.CustomEnemy:GetPos() - ply:GetShootPos() ):GetNormalized():Angle() )
	end

	-- Give the bot a crowbar if the bot doesn't have one yet
	if ( SERVER and !ply:HasWeapon( "weapon_crowbar" ) ) then ply:Give( "weapon_crowbar" ) end

	-- Select the crowbar
	cmd:SelectWeapon( ply:GetWeapon( "weapon_crowbar" ) )

	-- Hold Mouse 1 to cause the bot to attack
	cmd:SetButtons( IN_ATTACK )

	-- Enemy is dead, clear our enemy so that we may acquire a new one
	if ( !ply.CustomEnemy:Alive() ) then
		ply.CustomEnemy = nil
	end

end )
    