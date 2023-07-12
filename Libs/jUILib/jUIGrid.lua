local _,Addon = ...;

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
                Row.Value:SetValue( Handler:GetValue( Data.Name ) );
            end
        else
            if( Data.Type == 'Toggle' ) then
                Row.Value = Addon.GRID:AddToggle( Data,Row,Handler );
            elseif( Data.Type == 'Range' ) then
                Row.Value = Addon.GRID:AddRange( Data,Row,Handler );
            elseif( Data.Type == 'Select' ) then
                Row.Value = Addon.GRID:AddSelect( Data,Row,Handler );
                Row.Value:SetValue( Handler:GetValue( Data.Name ) );
            end
        end
        if( Data.Type == 'Select' ) then
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',-19,7 );
        elseif( Data.Type == 'Toggle' ) then
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',-5,5 );
        elseif( Data.Type == 'Range' ) then
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',0,5 );
        else
            Row.Value:SetPoint( 'topleft',Row.Default,'topright',0,0 );
        end
        if( Data.Type ~= 'Toggle' ) then
            Row.Value:SetSize( 150,Addon.APP.Heading.FieldHeight );
        end

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
    local Frame = CreateFrame( 'Slider',Key..'Range',Parent,'OptionsSliderTemplate' );
    --[[
    local SliderBackdrop  = {
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true, tileSize = 8, edgeSize = 8,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    };
    ]]
    Frame:SetMinMaxValues( VarData.KeyPairs.Low.Value,VarData.KeyPairs.High.Value );
    Frame:SetValueStep( VarData.Step );
    Frame:SetHeight( 15 );
    Frame:SetHitRectInsets( 0,0,-10,0 );
    --Frame:SetBackdrop( SliderBackdrop );
    Frame:SetThumbTexture( "Interface\\Buttons\\UI-SliderBar-Button-Horizontal" );
    Frame:SetOrientation( 'HORIZONTAL' );
    Frame.minValue, Frame.maxValue = Frame:GetMinMaxValues();
    Frame.textLow = _G[ Key..'Range'..'Low' ];
    Frame.textHigh = _G[ Key..'Range'..'High' ];
    Frame.textLow:SetText( floor( VarData.KeyPairs.Low.Value ) );
    Frame.textHigh:SetText( floor( VarData.KeyPairs.High.Value ) );
    Frame:SetValue( Handler:GetValue( Key ) );
    Frame.keyValue = Key;
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    --[[
    local ManualBackdrop = {
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, edgeSize = 1, tileSize = 5,
    };
    ]]
    Frame.EditBox = CreateFrame( 'EditBox',Key..'SliderEditBox',Frame,'InputBoxTemplate' --[[and BackdropTemplate]] );
    Frame.EditBox:SetSize( 40,15 );
    --Frame.EditBox:GetFontString():SetJustifyH( 'center' );
    Frame.EditBox:ClearAllPoints();
    Frame.EditBox:SetPoint( 'top',Frame,'bottom',0,2 );
    Frame.EditBox:SetText( Handler:GetValue( Key ) );
    --Frame.EditBox:SetBackdrop( ManualBackdrop );
    --[[
    Frame.EditBox:HookScript( 'OnTextChanged',function( self )
        local Value = self:GetText();
        if( tonumber( Value ) ) then
            self:GetParent():SetValue( Value );
        end
    end );
    ]]
    Frame:HookScript( 'OnValueChanged',function( self,Value )
        self.EditBox:SetText( Addon:SliderRound( self:GetValue(),VarData.Step ) );
        Handler:SetValue( self.keyValue,Addon:SliderRound( self:GetValue(),VarData.Step ) );
    end );
    Frame.EditBox:Disable();
    return Frame;
end

Addon.GRID.AddToggle = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'CheckButton',Key..'Toggle',Parent,'UICheckButtonTemplate' );
    Frame:SetChecked( Addon:Int2Bool( Handler:GetValue( Key ) ) );
    Frame:SetSize( 25,25 );
    Frame.keyValue = Key;
    Frame:HookScript( 'OnClick',function( self )
        Handler:SetValue( self.keyValue,Addon:BoolToInt( self:GetChecked() ) );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    return Frame;
end

Addon.GRID.AddEdit = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Frame',Key..'Edit',Parent,'InputBoxTemplate' );
    Frame:SetMultiLine( true );
    Frame:SetTextInsets( 0,0,3,3);
    Frame:SetHeight( 20 );
    return Frame;
end

Addon.GRID.AddSelect = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Frame',Key..'Select',Parent,'UIDropDownMenuTemplate' );
    UIDropDownMenu_Initialize( Frame,function( Frame,Level,MenuList )
        local Info = UIDropDownMenu_CreateInfo();
        Info.func = function( self )
            UIDropDownMenu_SetSelectedValue( Frame,self.value );
            Handler:SetValue( Key,self.value );
        end
        for i,v in pairs( VarData.KeyPairs ) do
            Info.text = v.Description;
            Info.value = v.Value;
            Info.checked = false;
            Info.isNotRadio = true;
            Info.justifyH = 'right';
            UIDropDownMenu_AddButton( Info );
        end
    end );
    Frame.SetValue = function( self,value )
        local SelectedText;
        self.selectedValue = value;
        for i,v in pairs( VarData.KeyPairs ) do
            if( tonumber( value ) == tonumber( Handler:GetValue( Key ) ) and tonumber( value ) == tonumber( v.Value ) ) then
                SelectedText = v.Description;
            elseif( value == Handler:GetValue( Key ) and value == v.Value ) then
                SelectedText = v.Description;
            end
        end
        if( SelectedText ) then
            UIDropDownMenu_SetText( self,SelectedText );
        end
    end
    _G[Frame:GetName()..'Text']:SetWordWrap( true )
    return Frame;
end