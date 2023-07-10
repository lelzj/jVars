local _,Addon = ...;
local _G = _G;

Addon.GRID = CreateFrame( 'Frame' );

Addon.GRID.GetModified = function( self,Data,Handler )
    return Handler:GetModified( Data,Handler );
end

Addon.GRID.GetStats = function( self,Data,Handler )
    local Stats = {
        Locked = 0,
        Modified = 0,
        Total = 0,
    };
    for VarName,VarData in pairs( Data ) do
        if( VarData.Scope == 'Locked' ) then
            Stats.Locked = Stats.Locked+1;
        end
        if( Addon.GRID:GetModified( VarData,Handler ) ) then
            Stats.Modified = Stats.Modified+1;
        end
        Stats.Total = Stats.Total+1;
    end

    self.AddRow = function( self,Data,Handler )

        local Row = CreateFrame( 'Frame',Handler.Footer:GetName()..'StatsRow',Handler.Footer );

        Row.LockedLabel = self:AddLocked( { DisplayText = 'Locked' },Row );
        Row.LockedValue = self:AddLabel( { DisplayText = Data.Locked },Row );

        Row.ModifiedLabel = self:AddModified( { DisplayText = 'Modified,' },Row );
        Row.ModifiedValue = Addon.GRID:AddLabel( { DisplayText = Data.Modified },Row );

        Row.TotalLabel = self:AddLabel( { DisplayText = 'Total,' },Row );
        Row.TotalValue = self:AddLabel( { DisplayText = Data.Total },Row );


        Row.LockedLabel:SetPoint( 'topright',Handler.Footer,'topright',-10,-7 );
        Row.LockedValue:SetPoint( 'topright',Row.LockedLabel,'topleft',0,0 );

        Row.ModifiedLabel:SetPoint( 'topright',Row.LockedValue,'topleft',0,0 );
        Row.ModifiedValue:SetPoint( 'topright',Row.ModifiedLabel,'topleft',0,0 );

        Row.TotalLabel:SetPoint( 'topright',Row.ModifiedValue,'topleft',0,0 );
        Row.TotalValue:SetPoint( 'topright',Row.TotalLabel,'topleft',0,0 );

        local FrameData = {
            Name        = Row:GetName(),
            Frame       = Row,
            Description = '',
        };
        Handler:FrameRegister( FrameData );

        return Row;
    end

    return self:AddRow( {
        Locked = Stats.Locked,
        Modified = Stats.Modified,
        Total = Stats.Total
    },Handler );
end

Addon.GRID.RegisterList = function( self,Data,Handler )

    Handler:HideAll();
    Handler.RegisteredFrames = {};

    self.AddRow = function( Data,Parent,Handler )

        local Row = CreateFrame( 'Frame',string.lower( Data.Name ),Parent );

        Row:SetSize( Parent:GetWidth(),30 );
        if( Addon.GRID:GetModified( Data,Handler ) ) then
            Row.Label = Addon.GRID:AddModifiedTip( Data,Row );

            local ScopeData = Data;
            ScopeData.DisplayText = Data.Scope;
            Row.Scope = Addon.GRID:AddModified( ScopeData,Row );

            local CategoryData = Data;
            CategoryData.DisplayText = Data.Category;
            Row.Category = Addon.GRID:AddModified( CategoryData,Row );

            local DefaultData = Data;
            DefaultData.DisplayText = Data.DefaultValue;
            Row.Default = Addon.GRID:AddModified( DefaultData,Row );
            Row.Adjust = Addon.GRID:AddModified( Data,Row );
        elseif( Data.Scope == 'Locked' ) then
            Row.Label = Addon.GRID:AddModifiedTip( Data,Row );

            local ScopeData = Data;
            ScopeData.DisplayText = Data.Scope;
            Row.Scope = Addon.GRID:AddLocked( ScopeData,Row );

            local CategoryData = Data;
            CategoryData.DisplayText = Data.Category;
            Row.Category = Addon.GRID:AddLocked( CategoryData,Row );

            local DefaultData = Data;
            DefaultData.DisplayText = Data.DefaultValue;
            Row.Default = Addon.GRID:AddLocked( DefaultData,Row );
            Row.Adjust = Addon.GRID:AddLocked( Data,Row );
        else
            Row.Label = Addon.GRID:AddTip( Data,Row );

            local ScopeData = Data;
            ScopeData.DisplayText = Data.Scope;
            Row.Scope = Addon.GRID:AddLabel( ScopeData,Row );

            local CategoryData = Data;
            CategoryData.DisplayText = Data.Category;
            Row.Category = Addon.GRID:AddLabel( CategoryData,Row );

            local Default = Data;
            Default.DisplayText = Data.DefaultValue;
            Row.Default = Addon.GRID:AddLabel( Default,Row );
            Row.Adjust = Addon.GRID:AddLabel( Data,Row );
        end

        -- CVar
        Row.Label:SetPoint( 'topleft',Row,'topleft',Addon.APP.Heading.ColInset,-8 );
        Row.Label:SetSize( 180,Addon.APP.Heading.FieldHeight );
        Row.Label:SetJustifyH( 'right' );

        -- Scope
        Row.Scope:SetPoint( 'topleft',Row.Label,'topright',Addon.APP.Heading.ColInset,0 );
        Row.Scope:SetSize( 50,Addon.APP.Heading.FieldHeight );
        Row.Scope:SetJustifyH( 'left' );

        -- Category
        Row.Category:SetPoint( 'topleft',Row.Scope,'topright',Addon.APP.Heading.ColInset,0 );
        Row.Category:SetSize( 50,Addon.APP.Heading.FieldHeight );
        Row.Category:SetJustifyH( 'left' );

        -- Default Value
        Row.Default:SetPoint( 'topleft',Row.Category,'topright',Addon.APP.Heading.ColInset,0 );
        Row.Default:SetSize( 50,Addon.APP.Heading.FieldHeight );
        Row.Default:SetJustifyH( 'left' );

        -- Adjust
        if( Data.Scope == 'Locked' ) then
            if( Data.Type == 'Toggle' ) then
                Row.Value = Addon.GRID:AddToggle( Data,Row,Handler );
            elseif( Data.Type == 'Range' ) then
                Row.Value = Addon.GRID:AddRange( Data,Row,Handler );
            elseif( Data.Type == 'Select' ) then
                Row.Value = Addon.GRID:AddSelect( Data,Row,Handler );
            end
        else
            if( Data.Type == 'Toggle' ) then
                Row.Value = Addon.GRID:AddToggle( Data,Row,Handler );
            elseif( Data.Type == 'Range' ) then
                Row.Value = Addon.GRID:AddRange( Data,Row,Handler );
            elseif( Data.Type == 'Select' ) then
                Row.Value = Addon.GRID:AddSelect( Data,Row,Handler );
            end
        end
        if( Data.Type == 'Select' ) then
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',-19,7 );
        elseif( Data.Type == 'Toggle' ) then
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',-5,0 );
        else
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',0,0 );
        end
        Row.Value:SetSize( 150,Addon.APP.Heading.FieldHeight );

        Row.Sep = self:AddSeperator( Row );
        Row.Sep:SetPoint( 'topleft',Row,'bottomleft',10,0 );
        return Row;
    end

    local Iterator = 1;
    local X,Y = 0,( Addon.APP.Heading.FieldHeight )*-1;
    local RowElements = {};
    for VarName,VarData in Addon:Sort( Data ) do
        local Row = self.AddRow( VarData,Handler.ScrollChild,Handler );

        Row.Art = Row:CreateTexture( nil, 'ARTWORK', nil, 0 )
        Row.Art:SetTexture( 'Interface\\Addons\\'..Addon.AddonName..'\\Textures\\frame' )
        Row.Art:SetAllPoints( Row )

        if( not( #RowElements > 0 ) ) then
            Row:SetPoint( 'topleft',Handler.ScrollChild,'topleft',X,Y );

            RowElements[ Iterator ] = Row:GetName();

        else
            Row:SetPoint( 'topleft',Handler.ScrollChild,'topleft',X,Y );

            RowElements[ Iterator ] = Row:GetName();

        end

        Iterator = Iterator + 1;

        local FrameData = {
            Name        = VarName,
            Frame       = Row,
            Description = VarData.Description or '',
        };
        Handler:FrameRegister( FrameData );

        Row:Show();
        Y = Y-Handler.RowHeight;
    end
end

Addon.GRID.AddLocked = function( self,VarData,Parent )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.APP.Theme.Font.Family, Addon.APP.Theme.Font.Normal, Addon.APP.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    FontString:SetTextColor( 
        Addon.APP.Theme.Error.r,
        Addon.APP.Theme.Error.g,
        Addon.APP.Theme.Error.b
    );
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    return FontString;
end

Addon.GRID.AddModified = function( self,VarData,Parent )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.APP.Theme.Font.Family, Addon.APP.Theme.Font.Normal, Addon.APP.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    FontString:SetTextColor( 
        Addon.APP.Theme.Notify.r,
        Addon.APP.Theme.Notify.g,
        Addon.APP.Theme.Notify.b
    );
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    return FontString;
end

Addon.GRID.AddLabel = function( self,VarData,Parent )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.APP.Theme.Font.Family, Addon.APP.Theme.Font.Normal, Addon.APP.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    if( VarData.Flagged ) then
        FontString:SetTextColor( 
            Addon.APP.Theme.Disabled.r,
            Addon.APP.Theme.Disabled.g,
            Addon.APP.Theme.Disabled.b
        );
    else
        FontString:SetTextColor( 
            Addon.APP.Theme.Text.r,
            Addon.APP.Theme.Text.g,
            Addon.APP.Theme.Text.b
        );
    end
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    return FontString;
end

Addon.GRID.AddModifiedTip = function( self,VarData,Parent )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.APP.Theme.Font.Family, Addon.APP.Theme.Font.Normal, Addon.APP.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    if( VarData.Flagged ) then
        FontString:SetTextColor( 
            Addon.APP.Theme.Disabled.r,
            Addon.APP.Theme.Disabled.g,
            Addon.APP.Theme.Disabled.b
        );
    else
        FontString:SetTextColor( 
            Addon.APP.Theme.Notify.r,
            Addon.APP.Theme.Notify.g,
            Addon.APP.Theme.Notify.b
        );
    end
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    Parent.DataKeys = {
        Name = VarData.Name,
        DisplayText = VarData.DisplayText,
        Description = VarData.Description,
        Parent = FontString
    };
    Parent:SetScript( 'OnEnter',function( self )
        self.Label.Tip = CreateFrame( 'GameTooltip',self.DataKeys.Name..'ToolTip',UIParent,'GameTooltipTemplate' );
        GameTooltip:SetOwner( self.DataKeys.Parent,'ANCHOR_NONE',0,0 );
        GameTooltip:AddLine( self.DataKeys.DisplayText,nil,nil,nil,false );
        GameTooltip:AddLine( self.DataKeys.Description,1,1,1,false );
        GameTooltip:SetPoint( 'topright',self.DataKeys.Parent,'bottomright',0,0 );
        GameTooltip:Show();
    end );
    Parent:SetScript( 'OnLeave',function( self )
        GameTooltip:Hide();
    end );
    return FontString;
end

Addon.GRID.AddTip = function( self,VarData,Parent )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.APP.Theme.Font.Family, Addon.APP.Theme.Font.Normal, Addon.APP.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    if( VarData.Flagged ) then
        FontString:SetTextColor( 
            Addon.APP.Theme.Disabled.r,
            Addon.APP.Theme.Disabled.g,
            Addon.APP.Theme.Disabled.b
        );
    else
        FontString:SetTextColor( 
            Addon.APP.Theme.Text.r,
            Addon.APP.Theme.Text.g,
            Addon.APP.Theme.Text.b
        );
    end
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    Parent.DataKeys = {
        Name = VarData.Name,
        DisplayText = VarData.DisplayText,
        Description = VarData.Description,
        Parent = FontString
    };
    Parent:SetScript( 'OnEnter',function( self )
        self.Label.Tip = CreateFrame( 'GameTooltip',self.DataKeys.Name..'ToolTip',UIParent,'GameTooltipTemplate' );
        GameTooltip:SetOwner( self.DataKeys.Parent,'ANCHOR_NONE',0,0 );
        GameTooltip:AddLine( self.DataKeys.DisplayText,nil,nil,nil,false );
        GameTooltip:AddLine( self.DataKeys.Description,1,1,1,false );
        GameTooltip:SetPoint( 'topright',self.DataKeys.Parent,'bottomright',0,0 );
        GameTooltip:Show();
    end );
    Parent:SetScript( 'OnLeave',function( self )
        GameTooltip:Hide();
    end );
    return FontString;
end

Addon.GRID.AddSeperator = function( self,Parent )
  local Texture = Parent:CreateTexture( nil, 'ARTWORK', nil, 2 );
  Texture:SetTexture( 'Interface\\Addons\\'..Addon.AddonName..'\\Textures\\seperator' );
  Texture:SetSize( Parent:GetWidth( ), 2 );
  Texture:SetAlpha( 0.1 );
  return Texture;
end

Addon.GRID.AddRange = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = LibStub( 'Sushi-3.1' ).Slider( Parent );
    Frame:SetValue( Handler:GetValue( Key ) or 0 );
    Frame.Edit:SetValue( Addon:SliderRound( Handler:GetValue( Key ) or 0,VarData.Step ) );
    if( VarData.Flagged ) then
        Frame.Edit:Disable();
    end
    Frame:SetRange( 
        VarData.KeyPairs.Low.Value,
        VarData.KeyPairs.High.Value,
        VarData.KeyPairs.Low.Description,
        VarData.KeyPairs.High.Description 
    );
    Frame:SetStep( VarData.Step );
    Frame.keyValue = Key;
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