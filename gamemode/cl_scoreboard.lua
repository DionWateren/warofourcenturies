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

        if( self.Player:Team() == 0 ) then
            self:SetZPos( 2000 + self.Player:EntIndex() + ( self.NumKills*-50 ) )
            return
        end

        self:SetZPos( ( self.NumKills*-50 ) + self.Player:EntIndex() )

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

        self.Scores = self:Add( "DScrollPanel" )
        self.Scores:Dock( FILL )
        self.Scores:DockMargin( 0, 0, 0, 10 )
        local scrollBar = self.Scores:GetVBar()
        scrollBar:DockMargin( -5, 0, 0, 0 )
        function scrollBar:Paint( w, h )
            surface.SetDrawColor( 10, 10, 10, 100 )
            surface.DrawOutlinedRect( 0, 0, w-1, h-1 )
        end
        function scrollBar.btnGrip:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 200, 150, 150 ) )
        end

    end,

    PerformLayout = function( self )

        self:SetSize( 700, ScrH() - 100 )
        self:SetPos( ScrW()/2 - 700 / 2, 100 / 2 )

    end,

    Paint = function( self, w, h )

        draw.RoundedBox( 8, 0, 0, w, h, Color( 10, 10, 10, 150 ) )

    end,

    Think = function( self, w, h )

        self.Name:SetText( GetHostName() )

        for id, pl in pairs( player.GetAll() ) do

            if( IsValid( pl.ScoreEntry ) ) then continue end

            pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
            pl.ScoreEntry:Setup( pl )

            self.Scores:AddItem( pl.ScoreEntry )

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