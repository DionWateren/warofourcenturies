function KillAllPlayers()
	for k, v in pairs( player.GetAll() ) do
        sound.Play( "ambient/explosions/exp1.wav", v:GetPos() )
		PrintMessage( HUD_PRINTTALK, k .. ", Killed: " .. v:Nick() )
        v:Kill()
	end
end

concommand.Add( "print_all_bots", 		function() PrintTable( player.GetBots() ) end , true )
concommand.Add( "print_all_humans", 	function() PrintTable( player.GetHumans() ) end , true )
concommand.Add( "print_all_players", 	function() PrintTable( player.GetAll() ) end , true )

concommand.Add( "kill_all_players", KillAllPlayers, true )
concommand.Add( "test_print", function() print("Printing test con message") end )