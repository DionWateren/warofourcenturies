surface.CreateFont( "ScoreboardPlayer", {
    font = "Helvetica",
    size = 22,
    weight = 800
})

surface.CreateFont( "ScoreboardTitle", {
    font = "Helvetica",
    size = 32,
    weight = 800
})

local PLAYER_LINE_TITLE = {
    Init = function( self )

        self.Players = self:Add( "DLabel" )
        self.Players:Dock( FILL )
        self.Players:SetFont( "ScoreboardPlayer" )
        self.Players:SetTextColor( Color( 255, 255, 255 ) )
        self.Players:DockMargin( 0, 0, 0, 0 )

        self.Ping = self:Add( "DLabel" )
        self.Ping:Dock( RIGHT )
        self.Ping:SetFont( "ScoreboardPlayer" )
        self.Ping:SetTextColor( Color( 255, 255, 255 ) )
        self.Ping:DockMargin( 0, 0, 20, 0 )

        self.Score = self:Add( "DLabel" )
        self.Score:Dock( RIGHT )
        self.Score:SetFont( "ScoreboardPlayer" )
        self.Score:SetTextColor( Color( 255, 255, 255 ) )
        self.Score:DockMargin( 0, 0, 0, 0 )

        self:Dock( TOP )
        self:DockPadding( 3, 3, 3, 3 )
        self:SetHeight( 38 )
        self:DockMargin( 10, 0, 10, 2 )
        
        self:SetZPos( -8000 )

    end,

    Think = function( self )

        playerCount = 0

        for k, v in pairs( player.GetAll() ) do

            if( v:Team() == self.TeamNum ) then
                playerCount = playerCount + 1
            end

        end

        self.Players:SetText( "Players (" .. playerCount .. ")" )
        self.Score:SetText( "Score" )
        self.Ping:SetText( "Ping" )

    end,

    Paint = function( self, w, h )

        draw.RoundedBox( 4, 0, 0, w, h, Color( 50, 50, 50, 175 ) )

    end
}

PLAYER_LINE_TITLE = vgui.RegisterTable( PLAYER_LINE_TITLE, "DPanel" )

local PLAYER_LINE = {
    Init = function( self )
        
        self.AvatarButton = self:Add( "DButton" )
        self.AvatarButton:Dock( LEFT )
        self.AvatarButton:DockMargin( 3, 3, 0, 3 )
        self.AvatarButton:SetSize( 32, 32 )
        self.AvatarButton:SetContentAlignment( 5 )
        self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

        self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton )
        self.Avatar:SetSize( 32, 32 )
        self.Avatar:SetMouseInputEnabled( false )

        self.Name = self:Add( "DLabel" )
        self.Name:Dock( FILL )
        self.Name:SetFont( "ScoreboardPlayer" )
        self.Name:SetTextColor( Color( 100, 100, 100 ) )
        self.Name:DockMargin( 0, 0, 0, 0 )
        
        self.MutePanel = self:Add( "DPanel" )
        self.MutePanel:SetSize( 36, self:GetTall() )
        self.MutePanel:Dock( RIGHT )
        function self.MutePanel:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 150 ) )
        end

        self.Mute = self.MutePanel:Add( "DImageButton" )
        self.Mute:SetSize( 32, 32 )
        self.Mute:Dock( FILL )
        self.Mute:SetContentAlignment( 5 ) -- 8 4 2 6 

        self.Ping = self:Add( "DLabel" )
        self.Ping:Dock( RIGHT )
        self.Ping:DockMargin( 0, 0, 2, 0 )
        self.Ping:SetWidth( 50 )
        self.Ping:SetFont( "ScoreboardPlayer" )
        self.Ping:SetTextColor( Color( 100, 100, 100 ) )
        self.Ping:SetContentAlignment( 5 )

        self.ScorePanel = self:Add( "DPanel" )
        self.ScorePanel:SetSize( 60, self:GetTall() )
        self.ScorePanel:Dock( RIGHT )
        self.ScorePanel:DockMargin( 0, 0, 4, 0 )
        function self.ScorePanel:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 150 ) )
        end

        self.Score = self.ScorePanel:Add( "DLabel" )
        self.Score:Dock( FILL )
        self.Score:SetFont( "ScoreboardDefault" )
        self.Score:SetTextColor( Color( 100, 100, 100 ) )
        self.Score:SetContentAlignment( 5 )

        self:Dock( TOP )
        self:SetHeight( 38 )
        self:DockMargin( 10, 0, 10, 2 )

    end,

    Setup = function( self, pl )
        self.Player = pl
        self.Avatar:SetPlayer( pl )
        self:Think( self )
    end,

    Think = function( self )
        
        if( !IsValid( self.Player ) ) then
            self:SetZPos( 9999 )
            self:Remove()
            return
        end

        self.Name:SetTextColor( Color( 255, 255, 255 ) )
        self.Score:SetTextColor( Color( 255, 255, 255 ) )
        self.Ping:SetTextColor( Color( 255, 255, 255 ) )

        if( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
            self.NumKills = self.Player:Frags()
            self.Score:SetText( self.NumKills )
        end

        if( self.PName == nil || self.NumKills != self.Player:Nick() ) then
            self.PName = self.Player:Nick()
            self.Name:SetText( self.PName )
        end

        if( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
            self.NumPing = self.Player:Ping()
            self.Ping:SetText( self.NumPing )
        end

        if( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

            self.Muted = self.Player:IsMuted()
            if( self.Muted ) then
                self.Mute:SetImage( "icon32/muted.png" )
            else
                self.Mute:SetImage( "icon32/unmuted.png" )
            end

            self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

        end

        -- if( self.Player:Team() == 0 ) then
        --     self:SetZPos( 2000 + self.Player:EntIndex() + ( self.NumKills*-50 ) )
        --     return
        -- end

        self:SetZPos( self.Player:EntIndex() + ( self.NumKills*-50 ) )

    end,

    Paint = function( self, w, h )

        if ( !IsValid( self.Player ) ) then
            return
        end

        if( !self.Player:Alive() ) then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 10, 10, 10, 175) )
            return
        end
        
        if( self.Player:Team() == 0 ) then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 100, 100, 175) )
            return
        end

        if( self.Player:Team() == 1 ) then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 100, 100, 255, 175) )
            return
        end

        if( self.Player:Team() == 2 ) then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 100, 175) )
            return
        end

        if( self.Player:Team() == TEAM_CONNECTING ) then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 100, 100, 100, 175) )
            return
        end

        draw.RoundedBox( 4, 0, 0, w, h, Color( 10, 10, 10, 175) )

    end
}

PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" )

local SCORE_BOARD = {
    Init = function( self )

        self.Header = self:Add( "Panel" )
        self.Header:Dock( TOP )
        self.Header:SetHeight( 50 )

        self.Name = self.Header:Add( "DLabel" )
        self.Name:SetFont( "ScoreboardTitle" )
        self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
        self.Name:Dock( TOP )
        self.Name:SetHeight( 50 )
        self.Name:SetContentAlignment( 5 ) 
        self.Name:SetExpensiveShadow( 3, Color( 0 ,0 , 0, 200 ) )
        self.Name:DockMargin( 0, 0, 0, 0 )

        self.Teams = self:Add( "DScrollPanel" )
        self.Teams:Dock( FILL )
        self.Teams:DockMargin( 0, 0, 0, 10 )
        local scrollBar = self.Teams:GetVBar()
        scrollBar:DockMargin( -5, 0, 0, 0 )
        function scrollBar:Paint( w, h )
            surface.SetDrawColor( 10, 10, 10, 100 )
            surface.DrawOutlinedRect( 0, 0, w-1, h-1 )
        end
        function scrollBar.btnGrip:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 200, 150, 150 ) )
        end

        local TeamsWidth = 1200 / 3

        self.TeamList0 = self.Teams:Add( "DListLayout" )
        self.TeamList0:Dock( LEFT )
        --self.TeamList0:SetContentAlignment( 4 )
        self.TeamList0:SetWidth( TeamsWidth )

        self.TeamList1 = self.Teams:Add( "DListLayout" )
        self.TeamList1:Dock( LEFT )
        self.TeamList1:SetPaintBackground( true )
        self.TeamList1:SetSize( 100, 400 )
        --for i=1, 50 do
        --    self.TeamList1:Add( Label( "Test " .. i ) )
        --end
        --self.TeamList1:SizeToContents()
        --self.TeamList1:SizeToChildren( true )
        self.TeamList1:SetWidth( TeamsWidth )
        
        --self.TeamList1:SetContentAlignment( 5 )

        self.TeamList2 = self.Teams:Add( "DListLayout" )
        self.TeamList2:Dock( LEFT )
        self.TeamList2:SetWidth( TeamsWidth )
        --self.TeamList2:SetContentAlignment( 6 )

        self.Title0 = self.TeamList0:Add( PLAYER_LINE_TITLE )
        self.Title0.TeamNum = 0
        self.Title1 = self.TeamList1:Add( PLAYER_LINE_TITLE )
        self.Title1.TeamNum = 1
        self.Title2 = self.TeamList2:Add( PLAYER_LINE_TITLE )
        self.Title2.TeamNum = 2

        -- self.Title = self.Teams:Add( PLAYER_LINE_TITLE )
    end,

    PerformLayout = function( self )
        
        local panelwidth = 1200
        self:SetSize( panelwidth, ScrH() - 100 )
        self:SetPos( ScrW()/2 - panelwidth / 2, 100 / 2 )

    end,

    Paint = function( self, w, h )

        draw.RoundedBox( 8, 0, 0, w, h, Color( 10, 10, 10, 150 ) )

    end,

    Think = function( self, w, h )

        self.Name:SetText( GetHostName() )
            
        print( #self.TeamList0:GetChildren() )
        print( #self.TeamList1:GetChildren() )
        print( #self.TeamList2:GetChildren() )

        for id, pl in pairs( player.GetAll() ) do

            if( IsValid( pl.ScoreEntry ) ) then 

                if( pl:Team() == 0 ) then

                    self.TeamList0:Add( pl.ScoreEntry )
                    self.TeamList0:SetHeight( table.Count( self.TeamList0:GetChildren() ) * 38 )

                elseif( pl:Team() == 1 ) then

                    self.TeamList1:Add( pl.ScoreEntry )
                    self.TeamList1:SetHeight( table.Count( self.TeamList1:GetChildren() ) * 38 )

                elseif( pl:Team() == 2 ) then

                    self.TeamList2:Add( pl.ScoreEntry )
                    self.TeamList2:SetHeight( table.Count( self.TeamList2:GetChildren() ) * 38 )

                end

                continue 
            
            end -- && pl.ScoreEntry.Player:Team() ==

            pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
            pl.ScoreEntry:Setup( pl )
            
        end
    end
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" )

function GM:ScoreboardShow()

    if ( !IsValid( Scoreboard ) ) then
        Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
    end

    if ( IsValid( Scoreboard ) ) then
        Scoreboard:Show()
        Scoreboard:MakePopup()
        Scoreboard:SetKeyboardInputEnabled( false )
    end

end

function GM:ScoreboardHide()

    if ( IsValid( Scoreboard ) ) then
        Scoreboard:Hide()
    end

end