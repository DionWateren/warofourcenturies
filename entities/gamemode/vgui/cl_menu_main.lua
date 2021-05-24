local PANEL = {
    Init = function( self )

        self:SetSize( 1000, 720)
        self:Center ()
        self:SetVisible( true )
        --self:MakePopup()

        local x, y = self:GetSize()
        
        local button = vgui.Create( "DButton", self)
        button:SetText( "Close" )
        button:SetSize( 50, 30 )
        button:SetPos( x-50, 0 )
        function button:Paint( w, h )
            if( button:IsDown() ) then
                button:SetColor( Color(150, 255, 150 ) )
            elseif( button:IsHovered() ) then
                button:SetColor( Color( 200, 255, 200 ) )
            else
                button:SetColor( Color( 255, 255, 255 ))
            end
        end
        button.DoClick = function()
            self:SetVisible( false )
		    gui.EnableScreenClicker( false )
        end

        local label = vgui.Create( "DLabel", self)
        label:SetFont( "MyFont" )
        label:SetText( "Derma and Panel Test Menu" )
        label:SetPos( 4, 4 )
        label:SizeToContents()
        --label:SetBright( true )
        --label:SetDark( true )

        local mainpanel = vgui.Create( "DPanel", self )
        mainpanel:SetPos( 3, 35 )
        mainpanel:SetSize( x - 6, y - 35 - 3 )
        mainpanel.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 100 ) )
        end

        local colsheet = vgui.Create( "DColumnSheet", mainpanel )
        colsheet:Dock( FILL )
        
        local sheet1 = vgui.Create( "DPanel", colsheet )
        sheet1:Dock( FILL )
        sheet1.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 100 ) )
        end
        colsheet:AddSheet( "Color Mixer", sheet1, "icon16/accept.png" )

        local colormixer = vgui.Create( "DColorMixer", sheet1 )
        --colormixer:Center()
        colormixer:Dock( TOP )
        colormixer:DockMargin( 15, 10, 15, 10 )
        colormixer:DockPadding( 290, 10, 290, 10 )
        colormixer:SetPalette( true )
        colormixer:SetAlphaBar( true )
        colormixer:SetWangs( true )
        colormixer:SetColor( Color( 10, 90, 180 ) )

        local mixbutton = vgui.Create( "DButton", sheet1 )
        mixbutton:SetText( "Enable" )
        mixbutton:Dock( TOP )
        mixbutton:DockMargin( 385, 10, 385, 10 )
        --mixbutton:SetSize( 50, 30 )
        --mixbutton:SetPos( x/2 - 25, y/2 - 15 + 140 )
        mixbutton.DoClick = function()
            function self:Paint( w, h )
                draw.RoundedBox( 0, 0, 0, w, h, colormixer:GetColor() )
                surface.SetDrawColor( 255, 255, 255)
                surface.DrawOutlinedRect( 2, 2, w-4, h-4 )
            end
        end

        local sheet2 = vgui.Create( "DPanel", colsheet )
        sheet2:Dock( FILL )
        sheet2.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 100 ) )
        end
        colsheet:AddSheet( "HTML", sheet2, "icon16/anchor.png" )

        local htmlbutton = vgui.Create( "DButton", sheet2 )
        htmlbutton:Dock( TOP )
        htmlbutton:DockMargin( 385, 10, 385, 10 )
        htmlbutton:SetText( "Website" )
        htmlbutton.DoClick = function()

            local htmlframe = vgui.Create( "DFrame" )
            htmlframe:Center()
            htmlframe:SetSize( 800, 600 )
            htmlframe:ShowCloseButton( true )
            htmlframe:MakePopup()

            local html = vgui.Create( "HTML", htmlframe )
            html:Dock( FILL )
            html:OpenURL( "https://www.youtube.com/watch?v=7E1ZhuFNbUY&list=PLLAN7OC4G99Sx65F38iYoqv2J1OoaiJse&index=25" )
    
            local htmlcontrols = vgui.Create( "DHTMLControls", htmlframe )
            htmlcontrols:Dock( TOP )
            htmlcontrols:SetHTML( html )
            htmlcontrols.AddressBar:SetText( "https://www.youtube.com/watch?v=7E1ZhuFNbUY&list=PLLAN7OC4G99Sx65F38iYoqv2J1OoaiJse&index=25" )
            
        end

       
    end,

    Paint = function( self, w, h )

        draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 150 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 2, 2, w-4, h-4 )

    end
}
vgui.Register( "menu_main", PANEL)