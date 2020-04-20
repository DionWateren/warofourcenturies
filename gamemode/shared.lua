GM.Name = "War of our Centuries"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

--include ("player_class/player_default.lua")
--include ("player_class/player_custom.lua")

team.SetUp( 0, "Red", Color(255, 0, 0))
team.SetUp( 1, "Blue", Color(0, 0, 255))
team.SetUp( 2, "Yellow", Color(255, 255, 0))

function GM:Initialize()
	-- do stuff
	print("Shared Initialize")
	--print(GM.FolderName)
end