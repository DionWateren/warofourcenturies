

surface.CreateFont( "ScoreboardTitle", {
    font = "Helvetica",
    size = 32,
    weight = 800
})


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