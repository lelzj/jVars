local _, Addon = ...;
local _G = _G;

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
            return Addon.DB:GetValue( Index,Value );
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.APP.Refresh = function( self )
            if( not Addon.DB:GetPersistence() ) then
                return;
            end
            for VarName,VarData in pairs( Addon.DB:GetPersistence().Vars ) do
                SetCVar( string.lower( VarName ),VarData.Value );
            end
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
                local Value = Addon.DB:GetValue( Key );
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

            Addon.REG:FillSpeechOptions();

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

            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( self.Name ),{
                type = 'group',
                name = self.Name,
                args = {},
            } );

            --self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( self.Name ),self.Name );
            -- Commented, as breaks scrolling
            self.Config = CreateFrame( 'Frame' );
            self.Config.name = AddonName;
            InterfaceOptions_AddCategory( self.Config,self.Name );

            self.Config.okay = function( self )
                Addon.APP:Refresh();
                RestartGx();
            end

            self.Config.default = function( self )
                Addon.DB:Reset();
                RestartGx();
            end

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
                local FilteredList = Addon.APP:Filter( self:GetText() );
                Addon.GRID:RegisterList( FilteredList,Addon.APP );
                Addon.GRID:GetStats( FilteredList,Addon.APP );
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
            self.Heading.Art:SetTexture( 'Interface\\Addons\\'..Addon.AddonName..'\\Textures\\frame' );
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
            self.Footer.Art:SetTexture( 'Interface\\Addons\\'..AddonName..'\\Textures\\frame' );
            self.Footer.Art:SetAllPoints( self.Footer );
        end

        Addon.APP:Init();
        Addon.APP:UnregisterEvent( 'ADDON_LOADED' );
    end
end );