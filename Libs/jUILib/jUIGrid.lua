local _,Addon = ...;

Addon.GRID = CreateFrame( 'Frame' );
Addon.GRID.MaxColumns = 3;
Addon.GRID.ColInset = 10;

Addon.GRID.RegisterGrid = function( self,Data,Handler )
    self.ScrollFrame = CreateFrame( 'ScrollFrame',Handler.Name..'ScrollFrame',Handler.Config,'UIPanelScrollFrameTemplate' );
    self.ScrollFrame:SetPoint( 'TOPLEFT',3,-4 );
    self.ScrollFrame:SetPoint( 'BOTTOMRIGHT',-27,4 );

    self.ScrollChild = CreateFrame( 'Frame',Handler.Name..'ScrollChild' );
    self.ScrollFrame:SetScrollChild( self.ScrollChild );
    if( Addon:IsClassic() ) then
        self.ScrollChild:SetWidth( InterfaceOptionsFramePanelContainer:GetWidth()-18 );
    else
        self.ScrollChild:SetWidth( SettingsPanel:GetWidth()-18 );
    end
    self.ScrollChild:SetHeight( 20 );

    self.Browser = CreateFrame( 'Frame',Handler.Name..'Browser',self.ScrollChild );
    self.Browser:SetSize( self.ScrollChild:GetWidth(),self.ScrollChild:GetHeight() );
    self.Browser:SetPoint( 'topleft',self.ScrollChild,'topleft',0,0 );

    for i = 1, self.MaxColumns do
        self.Browser[ i ] = CreateFrame( 'Frame',Handler.Name..'Browser'..i,self.Browser );
        self.Browser[ i ]:SetSize( self.Browser:GetWidth()/self.MaxColumns-25,self.Browser:GetHeight() );
        if( i == 1 ) then
            self.Browser[ i ]:SetPoint( 'topleft',self.Browser,'topleft',self.ColInset,0 );
        else
            self.Browser[ i ]:SetPoint( 'topleft',self.Browser[ i-1 ],'topright',self.ColInset,0 );
        end
    end

    local Iterator = 1;
    local X,Y = 0,0;
    local ColumnElements = {};
    for VarName,VarData in Addon:Sort( Data ) do
        local Frame;
        if( VarData.Type == 'Toggle' ) then
            Frame = self:AddToggle( VarData,self.Browser[ Iterator ],Handler );
            if( not ColumnElements[ self.Browser[ Iterator ]:GetName() ] ) then
                ColumnElements[ self.Browser[ Iterator ]:GetName() ] = {};
            end
            local LastElementInCol = ColumnElements[ self.Browser[ Iterator ]:GetName() ][ #ColumnElements[ self.Browser[ Iterator ]:GetName() ] ];
            if( not LastElementInCol ) then 
                Y = - 75;
            else
                local _,_,_,_,LastY = LastElementInCol:GetPoint();
                Y = LastY - 25;
            end
            Frame:GetFontString():SetJustifyH( 'left' );
            Frame:GetFontString():SetWidth( self.Browser[ Iterator ]:GetWidth()-20 );
            Frame:SetWidth( self.Browser[ Iterator ]:GetWidth() );
            table.insert( ColumnElements[ self.Browser[ Iterator ]:GetName() ], Frame );
            Frame:SetPoint( 'topleft',self.Browser[ Iterator ],'topleft',X,Y );
            Iterator = Iterator+1;
            if( Iterator == self.MaxColumns+1 ) then
                Iterator = 1;
            end
        elseif( VarData.Type == 'Select' ) then
            Frame = self:AddSelect( VarData,self.Browser[ Iterator ],Handler );
            if( not ColumnElements[ self.Browser[ Iterator ]:GetName() ] ) then
                ColumnElements[ self.Browser[ Iterator ]:GetName() ] = {};
            end
            local LastElementInCol = ColumnElements[ self.Browser[ Iterator ]:GetName() ][ #ColumnElements[ self.Browser[ Iterator ]:GetName() ] ];
            if( not LastElementInCol ) then 
                Y = - 75;
            else
                local _,_,_,_,LastY = LastElementInCol:GetPoint();
                Y = LastY - 50;
            end
            Frame:SetWidth( self.Browser[ Iterator ]:GetWidth() );
            table.insert( ColumnElements[ self.Browser[ Iterator ]:GetName() ], Frame );
            Frame:SetPoint( 'topleft',self.Browser[ Iterator ],'topleft',X-20,Y );
            Iterator = Iterator+1;
            if( Iterator == self.MaxColumns+1 ) then
                Iterator = 1;
            end
        elseif( VarData.Type == 'Range' ) then
            Frame = self:AddRange( VarData,self.Browser[ Iterator ],Handler );
            if( not ColumnElements[ self.Browser[ Iterator ]:GetName() ] ) then
                ColumnElements[ self.Browser[ Iterator ]:GetName() ] = {};
            end
            local LastElementInCol = ColumnElements[ self.Browser[ Iterator ]:GetName() ][ #ColumnElements[ self.Browser[ Iterator ]:GetName() ] ];
            if( not LastElementInCol ) then 
                Y = - 75;
            else
                local _,_,_,_,LastY = LastElementInCol:GetPoint();
                Y = LastY - 50;
            end
            Frame.Label:SetJustifyH( 'left' );
            Frame.Label:SetWidth( self.Browser[ Iterator ]:GetWidth()-20 );
            Frame:SetWidth( self.Browser[ Iterator ]:GetWidth() );
            table.insert( ColumnElements[ self.Browser[ Iterator ]:GetName() ], Frame );
            Frame:SetPoint( 'topleft',self.Browser[ Iterator ],'topleft',X,Y );
            Iterator = Iterator+1;
            if( Iterator == self.MaxColumns+1 ) then
                Iterator = 1;
            end
        end
        if( Frame ) then
            local FrameData = {
                Name        = VarName,
                Frame       = Frame,
                Description = VarData.Description or '',
            };
            Handler:FrameRegister( FrameData );
        end
    end
    return self.ScrollChild;
end

Addon.GRID.AddRange = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = LibStub( 'Sushi-3.1' ).Slider( Parent );
    Frame:SetTip( VarData.DisplayText,VarData.Description );
    Frame:SetValue( Handler:GetValue( Key ) );
    Frame.Edit:SetValue( Addon:SliderRound( Handler:GetValue( Key ),VarData.Step ) );
    Frame:SetRange( 
        VarData.KeyPairs.Low.Value,
        VarData.KeyPairs.High.Value,
        VarData.KeyPairs.Low.Description,
        VarData.KeyPairs.High.Description 
    );
    Frame:SetStep( VarData.Step );
    Frame:SetLabel( VarData.DisplayText );
    Frame.keyValue = Key;
    Frame:SetSmall( true );
    Frame:SetCall( 'OnValue',function( self )
        Handler:SetValue( self.keyValue,self:GetValue() );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    return Frame;
end

Addon.GRID.AddToggle = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = LibStub( 'Sushi-3.1' ).Check( Parent );
    Frame:SetChecked( Addon:Int2Bool( Handler:GetValue( Key ) ) );
    Frame:SetTip( VarData.DisplayText,VarData.Description );
    Frame:SetLabel( VarData.DisplayText );
    Frame:SetSmall( true );
    Frame.keyValue = Key;
    Frame:SetCall( 'OnClick',function( self )
        Handler:SetValue( self.keyValue,Addon:BoolToInt( self:GetValue() ) );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    return Frame;
end

Addon.GRID.AddSelect = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = LibStub( 'Sushi-3.1' ).DropChoice( Parent );
    Frame:SetValue( Handler:GetValue( Key ) );
    Frame:SetTip( VarData.DisplayText,VarData.Description );
    Frame:SetLabel( VarData.DisplayText );
    Frame:SetSmall( true );
    Frame.keyValue = Key;
    if( tonumber( Handler:GetValue( Key ) ) ~= nil ) then
        Frame:SetValue( tonumber( Handler:GetValue( Key ) ) );
    else
        Frame:SetValue( Handler:GetValue( Key ) );
    end
    for i,v in pairs( VarData.KeyPairs ) do
        Frame:Add( v.Value,v.Description );
    end
    Frame:SetCall( 'OnInput',function( self )
        Handler:SetValue( self.keyValue,self:GetValue() );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    return Frame;
end