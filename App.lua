local _, Addon = ...;

Addon.APP = CreateFrame( 'Frame' );
Addon.APP:RegisterEvent( 'ADDON_LOADED' );
Addon.APP:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        Addon.APP.RegisteredFrames = {};
        Addon.APP.Theme = {
            Text = {
                Hex = 'ffffff',
            },
            Notify = {
                Hex = '009bff',
            },
            Warn = {
                Hex = 'ffbf00',
            },
            Error = {
                Hex = 'ff2d00',
            },
            Disabled = {
                Hex = '999999',
            },
            Font = {
                Family = 'Fonts\\FRIZQT__.TTF',
                Flags = 'OUTLINE, MONOCHROME',
                Large = 14,
                Normal = 10,
                Small = 8,
            },
        };

        Addon.APP.Notify = function( self,... )
            local prefix = CreateColor(
                self.Theme.Notify.r,
                self.Theme.Notify.g,
                self.Theme.Notify.b
            ):WrapTextInColorCode( AddonName );

            _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', prefix, ... ) );
        end

        Addon.APP.Warn = function( self,... )
            local prefix = CreateColor(
                self.Theme.Warn.r,
                self.Theme.Warn.g,
                self.Theme.Warn.b
            ):WrapTextInColorCode( AddonName );

            _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', prefix, ... ) );
        end

        Addon.APP.Error = function( self,... )
            local prefix = CreateColor(
                self.Theme.Error.r,
                self.Theme.Error.g,
                self.Theme.Error.b
            ):WrapTextInColorCode( AddonName );

            _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', prefix, ... ) );
        end

        --
        --  Set cvar setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return bool
        Addon.APP.SetVarValue = function( self,Index,Value )
            local Result = Addon.DB:SetVarValue( Index,Value );
            if( Result ) then
                self:Query();
                SetCVar( Index,Value );
                if( Addon.DB:GetValue( 'ReloadGX' ) ) then
                    RestartGx();
                end
                if( Addon.DB:GetValue( 'ReloadUI' ) ) then
                    ReloadUI();
                end
                return true;
            end
            return false;
        end

        --
        --  Get cvar setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.APP.GetVarValue = function( self,Index )
            return Addon.DB:GetVarValue( Index,Value );
        end

        --
        --  Set module setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return bool
        Addon.APP.SetValue = function( self,Index,Value )
            return Addon.DB:SetValue( Index,Value );
        end

        --
        --  Get module setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.APP.GetValue = function( self,Index )
            return Addon.DB:GetValue( Index );
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.APP.Refresh = function( self )
            if( not Addon.DB:GetPersistence() ) then
                return;
            end
            self:Notify( 'Refreshing all settings...' );
            C_Timer.After( 2.5,function()
                for VarName,VarData in pairs( Addon.DB:GetPersistence().Vars ) do
                local Updated = SetCVar( string.lower( VarName ),VarData.Value );
                end; self:Notify( 'Done' );
            end );
        end

        Addon.APP.FrameRegister = function( self,FrameData )
            local Found = false;
            for i,MetaData in pairs( self.GetRegisteredFrames() ) do
                if( MetaData.Name == FrameData.Name ) then
                    Found = true;
                end
            end
            if( not Found ) then
                table.insert( self.GetRegisteredFrames(),{
                    Name        = FrameData.Name,
                    Frame       = FrameData.Frame,
                    Description = FrameData.Description,
                } );
            end
        end

        Addon.APP.ShowAll = function( self )
            for i,FrameData in pairs( self.GetRegisteredFrames() ) do
                FrameData.Frame:Show();
            end
        end

        Addon.APP.HideAll = function( self )
            for i,FrameData in pairs( self.GetRegisteredFrames() ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.APP.GetRegisteredFrame = function( self,Name )
            if( not self:GetRegisteredFrames() ) then
                return;
            end
            for i,FrameData in pairs( self:GetRegisteredFrames() ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.APP.GetRegisteredFrames = function()
            return self.RegisteredFrames or {};
        end

        Addon.APP.Filter = function( self,SearchQuery )

            local AllData = {};
            for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do

                local Key = string.lower( VarName );
                local Value = self:GetVarValue( Key );
                local Flagged = Addon.DB:GetFlagged( Key );
                local Dict = Addon.DICT:GetDictionary()[ Key ];

                if( Value and not Flagged ) then
                    AllData[ Key ] = {
                        DisplayText = Dict.DisplayText,
                        Description = Dict.Description,
                        DefaultValue = Dict.DefaultValue,
                        Type = VarData.Type,
                        Flagged = Flagged,
                        Name = Key,
                        Value = Value,
                        Scope = Dict.Scope,
                        Step = VarData.Step,
                        KeyPairs = VarData.KeyPairs,
                        Category = VarData.Category,
                        Dict = Dict,
                    };
                end
            end

            if( not SearchQuery or not ( string.len( SearchQuery ) >= 3 ) ) then
                return AllData;
            end

            local FilteredData = {};
            for VarName,VarData in pairs( AllData ) do
                if( Addon:Minify( VarName ):find( Addon:Minify( SearchQuery ) ) ) then
                    FilteredData[ string.lower( VarName ) ] = VarData;
                end
                if( VarData.Category ) then
                    if( Addon:Minify( VarData.Category ):find( Addon:Minify( SearchQuery ) ) ) then
                        FilteredData[ string.lower( VarName ) ] = VarData;
                    end
                end
                if( VarData.Scope ) then
                    if( Addon:Minify( VarData.Scope ):find( Addon:Minify( SearchQuery ) ) ) then
                        FilteredData[ string.lower( VarName ) ] = VarData;
                    end
                end
                if( VarData.Description ) then
                    if( Addon:Minify( VarData.Description ):find( Addon:Minify( SearchQuery ) ) ) then
                        FilteredData[ string.lower( VarName ) ] = VarData;
                    end
                end
            end
            return FilteredData;
        end

        Addon.APP.GetModified = function( self,Data,Handler )
            return Addon.DB:GetModified( Data.Name );
        end

        Addon.APP.Query = function( self )
            local SearchQuery = self.Heading.FilterBox:GetText();
            local FilteredList = Addon.APP:Filter( SearchQuery );
            Addon.GRID:RegisterList( FilteredList,Addon.APP );
            Addon.GRID:GetStats( FilteredList,Addon.APP );
        end

        --
        --  Module init
        --
        --  @return void
        Addon.APP.Init = function( self )

            self.Name = AddonName;

            for Key,Data in pairs( self.Theme ) do
                if( Key ~= 'Font' ) then
                    self.Theme[ Key ].r,self.Theme[ Key ].g,self.Theme[ Key ].b = Addon:Hex2RGB( Data.Hex );
                end
            end

            self.Config = CreateFrame( 'Frame',self.Name);
            self.Config.name = self.Name;

            self.Config.okay = function( self )
                RestartGx();
            end

            self.Config.default = function( self )
                Addon.DB:Reset();
                RestartGx();
            end

            InterfaceOptions_AddCategory( self.Config );

            self.RowHeight = 30;

            self.Heading = CreateFrame( 'Frame',self.Name..'Heading',self.Config );
            self.Heading:SetPoint( 'topleft',self.Config,'topleft',10,-10 );
            self.Heading:SetSize( 580,100 );
            self.Heading.FieldHeight = 10;
            self.Heading.ColInset = 15;

            self.Heading.FilterBox = CreateFrame( 'EditBox',self.Name..'Filter',self.Config,'SearchBoxTemplate' );
            self.Heading.FilterBox:SetPoint( 'topleft',self.Heading,'topleft',15,-35 );
            self.Heading.FilterBox:SetSize( 200,20 );
            self.Heading.FilterBox.clearButton:Hide();
            self.Heading.FilterBox:ClearFocus();
            self.Heading.FilterBox:SetAutoFocus( false );
            self.Heading.FilterBox:SetScript( 'OnEscapePressed',function( self )
                self:SetAutoFocus( false );
                if( self.Instructions ) then
                    self.Instructions:Show();
                end
                self:ClearFocus();
                self:SetText( '' );
                Addon.APP:ShowAll();
            end );
            self.Heading.FilterBox:SetScript( 'OnEditFocusGained',function( self ) 
                self:SetAutoFocus( true );
                if( self.Instructions ) then
                    self.Instructions:Hide();
                end
                self:HighlightText();
            end );
            self.Heading.FilterBox:SetScript( 'OnTextChanged',function( self )
                Addon.APP:Query();
            end );

            self.Heading.Name = Addon.GRID:AddLabel( { DisplayText = 'Name' },self.Heading );
            self.Heading.Name:SetPoint( 'topleft',self.Heading,'topleft',self.Heading.ColInset+3,( ( self.Heading:GetHeight() )*-1 )+20 );
            self.Heading.Name:SetSize( 180,self.Heading.FieldHeight );
            self.Heading.Name:SetJustifyH( 'right' );

            self.Heading.Scope = Addon.GRID:AddLabel( { DisplayText = 'Scope' },self.Heading );
            self.Heading.Scope:SetPoint( 'topleft',self.Heading.Name,'topright',self.Heading.ColInset,0 );
            self.Heading.Scope:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Scope:SetJustifyH( 'left' );

            self.Heading.Category = Addon.GRID:AddLabel( { DisplayText = 'Category' },self.Heading );
            self.Heading.Category:SetPoint( 'topleft',self.Heading.Scope,'topright',self.Heading.ColInset,0 );
            self.Heading.Category:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Category:SetJustifyH( 'left' );

            self.Heading.Default = Addon.GRID:AddLabel( { DisplayText = 'Default' },self.Heading );
            self.Heading.Default:SetPoint( 'topleft',self.Heading.Category,'topright',self.Heading.ColInset,0 );
            self.Heading.Default:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Default:SetJustifyH( 'left' );

            self.Heading.Adjustment = Addon.GRID:AddLabel( { DisplayText = 'Adjustment' },self.Heading );
            self.Heading.Adjustment:SetPoint( 'topleft',self.Heading.Default,'topright',0,0 );
            self.Heading.Adjustment:SetSize( 150,self.Heading.FieldHeight );
            self.Heading.Adjustment:SetJustifyH( 'left' );

            self.Heading.Art = self.Heading:CreateTexture( nil,'ARTWORK', nil,0 );
            self.Heading.Art:SetTexture( 'Interface\\Addons\\'..self.Name..'\\Textures\\frame' );
            self.Heading.Art:SetAllPoints( self.Heading );

            self.Browser = CreateFrame( 'Frame',self.Name..'Browser',self.Config );
            self.Browser:SetSize( self.Heading:GetWidth(),400 );
            self.Browser:SetPoint( 'topleft',self.Heading,'bottomleft',0,-10 );

            self.ScrollFrame = CreateFrame( 'ScrollFrame',self.Name..'ScrollFrame',self.Browser,'UIPanelScrollFrameTemplate' );
            self.ScrollFrame:SetAllPoints( self.Browser );

            self.ScrollChild = CreateFrame( 'Frame',self.Name..'ScrollChild' );
            self.ScrollFrame:SetScrollChild( self.ScrollChild );
            if( Addon:IsClassic() ) then
                self.ScrollChild:SetWidth( InterfaceOptionsFramePanelContainer:GetWidth()-18 );
            else
                self.ScrollChild:SetWidth( SettingsPanel:GetWidth()-18 );
            end
            self.ScrollChild:SetHeight( 20 );

            self.Footer = CreateFrame( 'Frame',self.Name..'Footer',self.Config );
            self.Footer:SetSize( self.Browser:GetWidth(),25 );
            self.Footer:SetPoint( 'topleft',self.Browser,'bottomleft',0,-10 );

            self.Footer.Art = self.Footer:CreateTexture( nil,'ARTWORK', nil,0 );
            self.Footer.Art:SetTexture( 'Interface\\Addons\\'..self.Name..'\\Textures\\frame' );
            self.Footer.Art:SetAllPoints( self.Footer );

            self.Stats = CreateFrame( 'Frame',self.Name..'FooterStats',self.Footer );
            self.Stats:SetSize( self.Footer:GetWidth()/2,self.Footer:GetHeight() );
            self.Stats:SetPoint( 'topright',self.Footer,'topright',0,0 );

            self.Controls = CreateFrame( 'Frame',self.Name..'FooterConfig',self.Footer );
            self.Controls:SetSize( self.Footer:GetWidth()/2,self.Footer:GetHeight() );
            self.Controls:SetPoint( 'topright',self.Stats,'topleft',0,0 );

            local RefreshData = {
                Name = 'Refresh',
                DisplayText = 'Re-Apply settings on reload',
            };
            self.Apply = Addon.GRID:AddToggle( RefreshData,self.Controls );
            self.Apply.keyValue = RefreshData.Name;
            self.Apply:SetChecked( self:GetValue( self.Apply.keyValue ) );
            self.Apply:SetPoint( 'topleft',self.Controls,'topleft',0,0 );
            self.Apply.Label = Addon.GRID:AddLabel( RefreshData,self.Apply );
            self.Apply.Label:SetPoint( 'topleft',self.Apply,'topright',0,-3 );
            self.Apply.Label:SetSize( self.Controls:GetWidth()/3,20 );
            self.Apply.Label:SetJustifyH( 'left' );
            self.Apply:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );
            if( self:GetValue( self.Apply.keyValue ) ) then
                self:Refresh();
            end

            local ReloadUIData = {
                Name = 'ReloadUI',
                DisplayText = 'Reload UI for each update',
            };
            self.ReloadUI = Addon.GRID:AddToggle( ReloadUIData,self.Controls );
            self.ReloadUI.keyValue = ReloadUIData.Name;
            self.ReloadUI:SetChecked( self:GetValue( self.ReloadUI.keyValue ) );
            self.ReloadUI:SetPoint( 'topleft',self.Apply.Label,'topright',0,3 );
            self.ReloadUI.Label = Addon.GRID:AddLabel( ReloadUIData,self.ReloadUI );
            self.ReloadUI.Label:SetPoint( 'topleft',self.ReloadUI,'topright',0,-3 );
            self.ReloadUI.Label:SetSize( self.Controls:GetWidth()/3,20 );
            self.ReloadUI.Label:SetJustifyH( 'left' );
            self.ReloadUI:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            local ReloadGXData = {
                Name = 'ReloadGX',
                DisplayText = 'Reload GX for each update',
            };
            self.ReloadGX = Addon.GRID:AddToggle( ReloadGXData,self.Controls );
            self.ReloadGX.keyValue = ReloadGXData.Name;
            self.ReloadGX:SetChecked( self:GetValue( self.ReloadGX.keyValue ) );
            self.ReloadGX:SetPoint( 'topleft',self.ReloadUI.Label,'topright',0,3 );
            self.ReloadGX.Label = Addon.GRID:AddLabel( ReloadGXData,self.ReloadGX );
            self.ReloadGX.Label:SetPoint( 'topleft',self.ReloadGX,'topright',0,-3 );
            self.ReloadGX.Label:SetSize( self.Controls:GetWidth()/3,20 );
            self.ReloadGX.Label:SetJustifyH( 'left' );
            self.ReloadGX:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            --self.Controls.Import = Addon.GRID:AddEdit( { Name=self.Name..'Import' },self.Controls,self );
            --self.Controls.Import:SetPoint( 'topleft',self.Controls,'topleft',0,0 );
        end

        Addon.APP:Init();
        Addon.APP:Refresh();
        Addon.APP:UnregisterEvent( 'ADDON_LOADED' );
    end
end );