local _,Addon = ...;

Addon.GRID = CreateFrame( 'Frame' );

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
    Frame:SetHitRectInsets( 0,0,-10,0 );
    --Frame:SetBackdrop( SliderBackdrop );
    Frame:SetThumbTexture( "Interface\\Buttons\\UI-SliderBar-Button-Horizontal" );
    Frame:SetOrientation( 'HORIZONTAL' );
    Frame.minValue,Frame.maxValue = Frame:GetMinMaxValues();

    Frame.Low:SetText( VarData.KeyPairs.Low.Value );
    Frame.High:SetText( VarData.KeyPairs.High.Value );

    local Point,RelativeFrame,RelativePoint,X,Y = Frame.Low:GetPoint();
    Frame.Low:SetPoint( Point,RelativeFrame,RelativePoint,X+5,Y-5 );

    local Point,RelativeFrame,RelativePoint,X,Y = Frame.High:GetPoint();
    Frame.High:SetPoint( Point,RelativeFrame,RelativePoint,X-5,Y-5 );

    Frame:SetValue( Handler:GetVarValue( Key ) );
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
    Frame.EditBox:SetText( Handler:GetVarValue( Key ) );
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
        Handler:SetVarValue( self.keyValue,Addon:SliderRound( self:GetValue(),VarData.Step ) );
    end );
    Frame.EditBox:Disable();
    Frame:SetHeight( 15 );
    return Frame;
end

Addon.GRID.AddToggle = function( self,VarData,Parent )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'CheckButton',Key..'Toggle',Parent,'UICheckButtonTemplate' );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    Frame:SetSize( 25,25 );
    return Frame;
end

Addon.GRID.AddVarToggle = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'CheckButton',Key..'Toggle',Parent,'UICheckButtonTemplate' );
    Frame:SetChecked( Addon:Int2Bool( Handler:GetVarValue( Key ) ) );
    Frame.keyValue = Key;
    Frame:HookScript( 'OnClick',function( self )
         Handler:SetVarValue( self.keyValue,Addon:BoolToInt( self:GetChecked() ) );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    Frame:SetSize( 25,25 );
    return Frame;
end

Addon.GRID.AddEdit = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'EditBox',Key..'Edit',Parent,'InputBoxTemplate' );
    Frame:SetAutoFocus( false );
    Frame:ClearFocus();
    Frame:SetText( VarData.Value );
    Frame.keyValue = Key;
    Frame:HookScript( 'OnEnterPressed',function( self )
        local Value = self:GetText();
        if( Value ) then
            Handler:SetVarValue( self.keyValue,Value );
        end
    end );
    return Frame;
    --[[
    local Frame = CreateFrame( 'ScrollFrame',Key..'ScrollFrame',Parent,'UIPanelScrollFrameTemplate' );
    Frame:SetPoint( 'topleft',Parent,'topleft',0,0 );

    Frame.Input = CreateFrame( 'EditBox',Key..'Edit',Parent,'InputBoxTemplate' );
    Frame.Input:DisableDrawLayer( 'BACKGROUND' );
    Frame.Input:SetAllPoints( Frame );
    Frame.Input:SetAutoFocus( false );
    Frame.Input:SetMultiLine( true );
    Frame.Input:SetTextInsets( 0,0,3,3);
    Frame.Input:SetSize( 20,20 );
    Frame.Input:ClearFocus();
    Frame.Input:HookScript( 'OnTextChanged',function( self )
        local Value = self:GetText();
        if( Value ) then

        end
    end );
    Frame:SetScrollChild( Frame.Input );
    return Frame.Input;
    ]]
end

Addon.GRID.AddSelect = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Frame',Key..'Select',Parent,'UIDropDownMenuTemplate' );
    Frame.initialize = function()
        local Info = {};
        for i,Data in pairs( VarData.KeyPairs ) do
            Info.isNotRadio = true;
            Info.text = Data.Description;
            Info.value = Data.Value;
            Info.func = function( self )
                Handler:SetVarValue( Key,self.value );
                Frame:initialize();
            end
            if ( tostring( Addon.APP:GetVarValue( Key ) ) == tostring( Data.Value ) ) then
                Info.checked = true;
                Frame.Text:SetText( Info.text );
            else
                Info.checked = false;
            end
            UIDropDownMenu_AddButton( Info );
        end
    end
    Frame:initialize();
    Frame:SetHeight( 20 );
    return Frame;
end