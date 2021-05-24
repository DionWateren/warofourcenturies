DEFINE_BASECLASS( "player_default" )
 
 local PLAYER = {} 
 
 --
 -- See gamemodes/base/player_class/player_default.lua for all overridable variables
 --
 PLAYER.WalkSpeed = 200
 PLAYER.RunSpeed  = 2000
 
 
 function PLAYER:Loadout()
 
 	self.Player:RemoveAllAmmo()
 	
 	self.Player:GiveAmmo( 256,	"Pistol", 		true )
 	self.Player:Give( "weapon_pistol" )
 
 end
 
 player_manager.RegisterClass( "player_custom", PLAYER, "player_default" )