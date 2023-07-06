local _,Addon = ...;

Addon.GRID = CreateFrame( 'Frame' );
Addon.GRID.MaxColumns = 3;
Addon.GRID.ColInset = 10;

Addon.GRID.RegisterGrid = function( self,Parent,Data,Handler )
    self.ScrollFrame = CreateFrame( 'ScrollFrame',Parent.Name..'ScrollFrame',Parent,'UIPanelScrollFrameTemplate' );
    self.ScrollFrame:SetPoint( 'TOPLEFT',3,-4 );
    self.ScrollFrame:SetPoint( 'BOTTOMRIGHT',-27,4 );

    self.ScrollChild = CreateFrame( 'Frame',Parent.Name..'ScrollChild' );
    self.ScrollFrame:SetScrollChild( self.ScrollChild );
    if( Addon:IsClassic() ) then
        self.ScrollChild:SetWidth( InterfaceOptionsFramePanelContainer:GetWidth()-18 );
    else
        self.ScrollChild:SetWidth( SettingsPanel:GetWidth()-18 );
    end
    self.ScrollChild:SetHeight( 20 );

    self.Browser = CreateFrame( 'Frame',Parent.Name..'Browser',self.ScrollChild );
    self.Browser:SetSize( self.ScrollChild:GetWidth(),self.ScrollChild:GetHeight() );
    self.Browser:SetPoint( 'topleft',self.ScrollChild,'topleft',0,0 );

    for i = 1, self.MaxColumns do
        self.Browser[ i ] = CreateFrame( 'Frame',Parent.Name..'Browser'..i,self.Browser );
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
            Frame = self:AddToggle( VarName,VarData.Description,Parent,Handler );
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
            Frame = self:AddSelect( VarName,VarData.Description,VarData.KeyPairs,Parent,Handler );
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
            Frame = self:AddRange( VarName,VarData.Description,VarData.Step,VarData.KeyPairs,Parent,Handler );
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

Addon.GRID.AddRange = function( self,Name,Tip,Step,Range,Parent,Handler )
    Name = string.lower( Name );
    local Frame = LibStub( 'Sushi-3.1' ).Slider( Parent );
    Frame:SetTip( Name,Tip );
    Frame:SetValue( Handler:GetValue( Name ) );
    Frame.Edit:SetValue( Addon:SliderRound( Handler:GetValue( Name ),Step ) );
    Frame:SetRange( 
        Range.Option1.Value,
        Range.Option2.Value,
        Range.Option1.Description,
        Range.Option2.Description 
    );
    Frame:SetStep( Step );
    Frame:SetLabel( Name );
    Frame.keyValue = Name;
    Frame:SetSmall( true );
    Frame:SetCall( 'OnValue',function( self )
        Handler:SetValue( self.keyValue,self:GetValue() );
    end );
    return Frame;
end

Addon.GRID.AddToggle = function( self,Name,Tip,Parent,Handler )
    Name = string.lower( Name );
    local Frame = LibStub( 'Sushi-3.1' ).Check( Parent );
    Frame:SetChecked( Addon:Int2Bool( Handler:GetValue( Name ) ) );
    Frame:SetTip( Name,Tip );
    Frame:SetLabel( Name );
    Frame:SetSmall( true );
    Frame.keyValue = Name;
    Frame:SetCall( 'OnClick',function( self )
        Handler:SetValue( self.keyValue,Addon:BoolToInt( self:GetValue() ) );
    end );
    return Frame;
end

Addon.GRID.AddSelect = function( self,Name,Tip,Choices,Parent,Handler )
    Name = string.lower( Name );
    local Frame = LibStub( 'Sushi-3.1' ).DropChoice( Parent );
    Frame:SetValue( Handler:GetValue( Name ) );
    Frame:SetTip( Name,Tip );
    Frame:SetLabel( Name );
    Frame:SetSmall( true );
    Frame.keyValue = Name;
    if( tonumber( Handler:GetValue( Name ) ) ~= nil ) then
        Frame:SetValue( tonumber( Handler:GetValue( Name ) ) );
    else
        Frame:SetValue( Handler:GetValue( Name ) );
    end
    for i,v in pairs( Choices ) do
        Frame:Add( v.Value,v.Description );
    end
    Frame:SetCall( 'OnInput',function( self )
        Handler:SetValue( self.keyValue,self:GetValue() );
    end );
    return Frame;
end