local _, Addon = ...;

Addon.APP = CreateFrame( 'Frame' );
Addon.APP:RegisterEvent( 'ADDON_LOADED' );
Addon.APP:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then
        if( InCombatLockdown() ) then
            return;
        end

        --
        --  Set cvar setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return bool
        Addon.APP.SetVarValue = function( self,Index,Value,Importing )
            if( InCombatLockdown() ) then
                return;
            end
            local Result = Addon.DB:SetVarValue( Index,Value );
            if( Result ) then
                self:Query();
                local Updated = SetCVar( Index,Value,nil,true );
                if( Updated ) then

                    local VarData = self.Registry[ Addon:Minify( Index ) ];
                    if( VarData and VarData.Cascade ) then
                        for Handling,_ in pairs( VarData.Cascade ) do
                            if( Addon.APP[Handling] ) then
                                Addon.APP[Handling]( Index,VarData,true );
                            end
                        end
                    end
                end

                if( not Importing ) then
                    if( Addon.DB:GetValue( 'ReloadGX' ) ) then
                        RestartGx();
                    end
                    if( Addon.DB:GetValue( 'ReloadUI' ) ) then
                        ReloadUI();
                    end
                end

                if( Addon.DB:GetPersistence().Vars[ string.lower( Index ) ].Dictionary ) then
                    Addon.DB:GetPersistence().Vars[ string.lower( Index ) ].Dictionary.CurrentValue = GetCVar( Index );
                end
                if( Addon.DB:GetValue( 'Debug' ) ) then
                    Addon:Dump( Addon.DB:GetPersistence().Vars[ string.lower( Index ) ] );
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
        --  @param  string  IndexInterfaceOverrides.SetRaidProfileOption
        --  @return mixed
        Addon.APP.GetValue = function( self,Index )
            return Addon.DB:GetValue( Index );
        end

        Addon.APP.RefreshConsole = function( self )
            local Value = Addon.APP:GetVarValue( 'ConsoleKey' );
            if( Value ) then
                if( Addon.DB:GetValue( 'Debug' ) ) then
                    local Index = 'ConsoleKey';
                    Addon.FRAMES:Warn( 'The console is only accessible when WoW is started with the "-console" parameter. This function does nothing if the parameter wasn\'t used.' );
                end
                SetConsoleKey( Value );
            end
        end

        Addon.APP.RefreshFindYourself = function( self )
            local Value = Addon.APP:GetVarValue( 'findYourselfMode' );

            if( Value ) then
                if( GetCVar( 'findyourselfanywhere' ) ~= 1 ) then
                    SetCVar( 'findyourselfanywhere',1,nil,true );
                end
                if( GetCVar( 'findYourselfModeOutline' ) ~= 1 ) then -- https://warcraft.wiki.gg/wiki/Patch_11.0.0/API_changes
                    SetCVar( 'findYourselfModeOutline',1,nil,true );
                end
            else
                if( GetCVar( 'findyourselfanywhere' ) ~= 0 ) then
                    SetCVar( 'findyourselfanywhere',0,nil,true );
                end
                if( GetCVar( 'findYourselfModeOutline' ) ~= 0 ) then -- https://warcraft.wiki.gg/wiki/Patch_11.0.0/API_changes
                    SetCVar( 'findYourselfModeOutline',0,nil,true );
                end
            end
        end

        Addon.APP.RefreshActionBars = function( self )
            local Value = Addon.APP:GetVarValue( 'multiBarRightVerticalLayout' );

            if( Value and tonumber( Value ) > 0 ) then
                if( Addon:IsRetail() and MultiBarLeft and MultiBarRight ) then
                    -- Refer to 
                    -- /Interface/AddOns/Blizzard_ActionBar/Classic/MultiActionBars.lua
                    -- MultiActionBar_Update()

                    --MultiBarRight:SetSize( MultiBarRight:GetWidth() / 2,MultiBarRight:GetHeight() / 2 );
                    --MultiBarLeft:SetSize( MultiBarLeft:GetWidth() / 3,MultiBarLeft:GetHeight() / 3 );

                    --MultiBarLeft:ClearAllPoints();

                    --MultiBarLeft:SetPoint( 'topleft',MultiBarRight,'bottomleft',0,0 );

                end
            end
        end

        Addon.APP.RefreshShowFriendlyNPCNamePlates = function( self )
            local Value = Addon.APP:GetVarValue( 'nameplateShowFriendlyNPCs' );

            if( Value ) then
                if( GetCVar( 'UnitNameNPC' ) ~= 1 ) then
                    SetCVar( 'UnitNameNPC',1,nil,true );
                end
            else
                if( GetCVar( 'UnitNameNPC' ) ~= 0 ) then
                    SetCVar( 'UnitNameNPC',0,nil,true );
                end
            end
        end

        Addon.APP.RefreshShowPersonalNamePlate = function( self )
            local Value = Addon.APP:GetVarValue( 'NameplatePersonalShowAlways' );

            if( Value ) then
                if( GetCVar( 'UnitNameOwn' ) ~= 1 ) then
                    SetCVar( 'UnitNameOwn',1,nil,true );
                end
            else
                if( GetCVar( 'UnitNameOwn' ) ~= 0 ) then
                    SetCVar( 'UnitNameOwn',0,nil,true );
                end
            end
        end

        Addon.APP.RefreshShowAllNamePlates = function( self )
            local Value = Addon.APP:GetVarValue( 'nameplateShowAll' );

            if( Value ) then
                if( GetCVar( 'UnitNameOwn' ) ~= 1 ) then
                    SetCVar( 'UnitNameOwn',1,nil,true );
                end
                if( GetCVar( 'UnitNameFriendlyPlayerName' ) ~= 1 ) then
                    SetCVar( 'UnitNameFriendlyPlayerName',1,nil,true );
                end
                if( GetCVar( 'nameplateShowFriendlyNPCs' ) ~= 1 ) then
                    SetCVar( 'nameplateShowFriendlyNPCs',1,nil,true );
                end
            end
        end

        Addon.APP.RefreshEnableRaidSettings = function( self )
            if( GetCVar( 'RAIDsettingsEnabled' ) ~= 1 ) then
                SetCVar( 'RAIDsettingsEnabled',1,nil,true );
            end
        end

        Addon.APP.RefreshEnableVolumeFog = function( self )
            if( GetCVar( 'volumeFog' ) ~= 1 ) then
                SetCVar( 'volumeFog',1,nil,true );
            end
        end

        Addon.APP.RefreshEnableRaidVolumeFog = function( self )
            if( GetCVar( 'RAIDVolumeFog' ) ~= 1 ) then
                SetCVar( 'RAIDVolumeFog',1,nil,true );
            end
        end

        Addon.APP.RefreshShadowQuality = function( self )
            --[[
            shadowMode

            0
            Off. This leaves the 'blob' type shadow only. Blob shadow cannot be removed as CVar_shadowLOD is no longer available.
            1
            Precomputed terrain shadows, dynamic shadows near player.
            2
            Static environment shadows, dynamic shadows near player.
            3
            Full dynamic shadows.
            ]]
            local Value = tonumber( Addon.APP:GetVarValue( 'graphicsShadowQuality' ) );
            if( Value == 0 ) then
                if( GetCVar( 'shadowMode' ) ~= 0 ) then
                    SetCVar( 'shadowMode',0,nil,true );
                end
            elseif( Value > 0 and Value <= 3 ) then
                if( GetCVar( 'shadowMode' ) ~= 1 ) then
                    SetCVar( 'shadowMode',1,nil,true );
                end
            else -- Value > 3
                if( GetCVar( 'shadowMode' ) ~= 3 ) then
                    SetCVar( 'shadowMode',3,nil,true );
                end
            end
        end

        Addon.APP.RefreshRaidShadowQuality = function( self )
            --[[
            shadowMode

            0
            Off. This leaves the 'blob' type shadow only. Blob shadow cannot be removed as CVar_shadowLOD is no longer available.
            1
            Precomputed terrain shadows, dynamic shadows near player.
            2
            Static environment shadows, dynamic shadows near player.
            3
            Full dynamic shadows.
            ]]
            local Value = tonumber( Addon.APP:GetVarValue( 'raidGraphicsShadowQuality' ) );
            if( Value == 0 ) then
                if( GetCVar( 'RAIDshadowMode' ) ~= 0 ) then
                    SetCVar( 'RAIDshadowMode',0,nil,true );
                end
            elseif( Value > 0 and Value <= 3 ) then
                if( GetCVar( 'RAIDshadowMode' ) ~= 1 ) then
                    SetCVar( 'RAIDshadowMode',1,nil,true );
                end
            else -- Value > 3
                if( GetCVar( 'RAIDshadowMode' ) ~= 3 ) then
                    SetCVar( 'RAIDshadowMode',3,nil,true );
                end
            end
        end

        Addon.APP.RefreshParticleDensity = function( self )
            local Value = tonumber( Addon.APP:GetVarValue( 'particleDensity' ) );
            if( Value == 0 ) then
                -- disabled
                SetCVar( 'graphicsParticleDensity',0,nil,true );
            elseif( Value == 10 ) then
                -- low
                SetCVar( 'graphicsParticleDensity',1,nil,true );
            elseif( Value == 25 ) then
                -- fair
                SetCVar( 'graphicsParticleDensity',2,nil,true );
            elseif( Value == 50 ) then
                -- good
                SetCVar( 'graphicsParticleDensity',3,nil,true );
            elseif( Value == 80 ) then
                -- high
                SetCVar( 'graphicsParticleDensity',4,nil,true );
            elseif( Value == 100 ) then
                -- ultra
                SetCVar( 'graphicsParticleDensity',5,nil,true );
            end
        end

        Addon.APP.RefreshRaidParticleDensity = function( self )
            local Value = tonumber( Addon.APP:GetVarValue( 'RAIDparticleDensity' ) );
            if( Value == 0 ) then
                -- disabled
                SetCVar( 'raidGraphicsParticleDensity',0,nil,true );
            elseif( Value == 10 ) then
                -- low
                SetCVar( 'raidGraphicsParticleDensity',1,nil,true );
            elseif( Value == 25 ) then
                -- fair
                SetCVar( 'raidGraphicsParticleDensity',2,nil,true );
            elseif( Value == 50 ) then
                -- good
                SetCVar( 'raidGraphicsParticleDensity',3,nil,true );
            elseif( Value == 80 ) then
                -- high
                SetCVar( 'raidGraphicsParticleDensity',4,nil,true );
            elseif( Value == 100 ) then
                -- ultra
                SetCVar( 'raidGraphicsParticleDensity',5,nil,true );
            end
        end

        --
        --  Setup raid frames
        --
        --  @param  string  VarName
        --  @param  table   VarData
        --  @param  bool    Manual
        --  @return void
        Addon.APP.RefreshCompactPartyFrame = function( VarName,VarData,Manual )
        end

        Addon.APP.AddMovablePort = function( self,Parent )

            local Frame = Addon.FRAMES:AddMovable( {
                Name = 'ExportWindow',
                Value = '',
            },Parent );
            Frame:SetSize( SettingsPanel:GetWidth()-100,350 );
            Frame:SetPoint( 'center',SettingsPanel,'center' );
            SettingsPanel:HookScript( 'OnHide',function()
                Frame:Hide();
            end );

            Frame.Edit = Addon.FRAMES:AddMultiEdit( {
                Name = 'ExportImportEdit',
                Value = '',
            },Frame );
            Frame.Edit.Input:SetCursorPosition( 0 );
            Frame.Edit:SetPoint( 'center',Frame,'center' );
            Frame.Edit:SetSize( Frame:GetWidth()-25,Frame:GetHeight()-25 );
            Frame.Edit.Input:SetSize( Frame:GetWidth()-25,Frame:GetHeight()-25 );
            --Frame.Edit.Input:SetFocus();
            --Frame.Edit.Input:Click();
            Frame.Edit.Input:SetScript( 'OnKeyDown',function( self,Key )
                if( Addon:Minify( Key ):find( 'escape' ) ) then
                    Frame:Hide();
                end
            end );

            Frame.Clear = Addon.FRAMES:AddButton( {
                Name = 'Clear',
                DisplayText = 'Clear',
            },Frame,self.Theme.HighLight )
            Frame.Clear:SetPoint( 'bottomleft',10,5 );
            Frame.Clear:SetWidth( 50 );
            Frame.Clear:SetScript( 'OnClick',function( self )
                local Input = self:GetParent().Edit.Input;
                local Value = Input:GetText();
                if( Value ) then
                    Input:SetText( '' );
                end
            end );

            Frame.Ok = Addon.FRAMES:AddButton( {
                Name = 'Ok',
                DisplayText = 'Ok',
            },Frame,self.Theme.HighLight )
            Frame.Ok:SetPoint( 'topleft',Frame.Clear,'topright',10,0 );
            Frame.Ok:SetWidth( 50 );
            Frame.Ok:SetScript( 'OnClick',function( self )
                local Value = self:GetParent().Edit.Input:GetText();
                if( Value ) then
                    local Data = {};
                    local Tmp = Addon:Explode( Value,',' )
                    for _,SetString in pairs( Tmp ) do
                        local Pieces = Addon:Explode( SetString,':::' );
                        if( Pieces[1] and Pieces[1] ~= '' ) then
                            Data[ Pieces[1] ] = {
                                VarName = Pieces[1],
                                Value = Pieces[2],
                            };
                        end
                    end

                    local IsValid = function( VarName )
                        return Addon.DB:GetPersistence().Vars[ string.lower( VarName ) ] ~= nil and Addon.DICT:GetDictionary()[ string.lower( VarName ) ] ~= nil;
                    end
                    for VarName,VarData in pairs( Data ) do
                        if( IsValid( VarName ) ) then
                            Addon.APP:SetVarValue( VarName,VarData.Value,true );
                        end
                    end

                    if( Addon.APP:GetValue( 'ReloadOnImport' ) ) then
                        ReloadUI();
                        return;
                    end
                    local Input = self:GetParent().Edit.Input
                    Input:HighlightText( 0 );
                    Input:SetFocus();
                end
            end );

            Frame.Close = Addon.FRAMES:AddButton( {
                Name = 'Close',
                DisplayText = 'Close',
            },Frame,self.Theme.HighLight )
            Frame.Close:SetPoint( 'topleft',Frame.Ok,'topright',10,0 );
            Frame.Close:SetWidth( 50 );
            Frame.Close:SetScript( 'OnClick',function( self )
                self:GetParent():Hide();
            end );
            Frame:Hide();
            
            return Frame;
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.APP.Refresh = function( self )
            if( not Addon.DB:GetPersistence() ) then
                return;
            end
            if( InCombatLockdown() ) then
                return;
            end
            
            Addon.FRAMES:Notify( 'Refreshing all settings...' );

            for VarName,VarData in pairs( Addon.DB:GetPersistence().Vars ) do
                if( not VarData.Missing ) then

                    local Updated = SetCVar( Addon:Minify( VarName ),VarData.Value,nil,true );

                    if( Updated and self.Registry[ Addon:Minify( VarName ) ] and self.Registry[ Addon:Minify( VarName ) ].Cascade ) then
                        for Handling,_ in pairs( self.Registry[ Addon:Minify( VarName ) ].Cascade ) do
                            if( Addon.APP[Handling] ) then
                                Addon.APP[Handling]( VarName,VarData );
                            end
                        end
                    end
                end
            end;

            Addon.FRAMES:Notify( 'Done' );
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
            if( InCombatLockdown() ) then
                return;
            end

            local AllData = {};
            for VarName,VarData in pairs( self.Registry ) do

                local Key = string.lower( VarName );
                local Value = self:GetVarValue( Key );
                local Missing = Addon.DB:GetMissing( Key );
                local Dict = Addon.DICT:GetDictionary()[ Key ];

                if( not Missing ) then
                    AllData[ Key ] = {
                        DisplayText = Dict.DisplayText,
                        Description = VarData.Description or Dict.Description,
                        DefaultValue = Dict.DefaultValue,
                        Type = VarData.Type,                -- Toggle, Range, Select, etc
                        Missing = Missing,                  -- Not appearing in list of client commands
                        Cascade = VarData.Cascade,          -- Dependencies that need to fire when value changes
                        Name = Key,
                        Value = Value,
                        Scope = Dict.Scope,                 -- Character, Account, Locked, Unknown
                        Step = VarData.Step,                -- How much to dec/increment
                        KeyPairs = VarData.KeyPairs,
                        Category = VarData.Category,
                        Dict = Dict,                        -- Dictionary entry
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
            if( InCombatLockdown() ) then
                return;
            end
            local SearchQuery = self.FilterBox:GetText();
            local FilteredList = Addon.APP:Filter( SearchQuery );
            Addon.VIEW:RegisterList( FilteredList,Addon.APP );
            Addon.VIEW:GetStats( FilteredList,Addon.APP );
        end

        --
        --  Module init
        --
        --  @return void
        Addon.APP.Init = function( self )
            if( InCombatLockdown() ) then
                return;
            end

            -- Options
            self.Theme = {
                HighLight = Addon.Theme[ self:GetValue( 'Theme' ) ],
                Normal = Addon.Theme.Text,
            };
            self.Name = AddonName;
            self.RowHeight = 35;    -- Each entire row
            self.ColInset = 17;     -- All column data, including heaings
            self.FieldHeight = 20;  -- Height of each element in rows

            -- Registry
            self.Registry = Addon.REG:GetRegistry();

            local SelectedRemoteTextToSpeechVoice = tonumber( GetCVar( 'remoteTextToSpeechVoice' ) );
            for Index,Voice in ipairs( C_VoiceChat.GetRemoteTtsVoices() ) do
                local Row = {
                    Value=Voice.voiceID,
                    Description=VOICE_GENERIC_FORMAT:format( Voice.voiceID ),
                };
                table.insert( self.Registry[ string.lower( 'remoteTextToSpeechVoice' ) ].KeyPairs,Row );
            end

            -- Framing
            self.Config = CreateFrame( 'Frame',self.Name);
            self.Config.name = self.Name;
            self.Heading = CreateFrame( 'Frame',self.Name..'Heading',self.Config );
            self.Heading:SetPoint( 'topleft',self.Config,'topleft',10,-10 );
            self.Heading:SetSize( 610,100 );
            self.Heading.FieldHeight = self.FieldHeight;
            self.Heading.ColInset = self.ColInset;

            self.Heading.BookEnd = self.Heading:CreateTexture( nil,'ARTWORK',nil,3 );
            self.Heading.BookEnd:SetTexture( 'Interface\\azerite\\azeritecenterbggold' );
            self.Heading.BookEnd:SetSize( 65,self.Heading:GetHeight() );
            self.Heading.BookEnd:SetVertTile( true );
            self.Heading.BookEnd:SetPoint( 'topright',self.Heading,'topright',0,5 );

            self.FilterBox = CreateFrame( 'EditBox',self.Name..'Filter',self.Config,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.Heading,'topleft',15,( ( self.Heading:GetHeight() )*-1 )+25 );
            self.FilterBox:SetSize( 145,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                if( InCombatLockdown() ) then
                    return;
                end
                self:SetAutoFocus( false );
                if( self.Instructions ) then
                    self.Instructions:Show();
                end
                self:ClearFocus();
                self:SetText( '' );
                Addon.APP:ShowAll();
            end );
            self.FilterBox:SetScript( 'OnEditFocusGained',function( self ) 
                if( InCombatLockdown() ) then
                    return;
                end
                self:SetAutoFocus( true );
                if( self.Instructions ) then
                    self.Instructions:Hide();
                end
                self:HighlightText();
            end );
            self.FilterBox:SetScript( 'OnTextChanged',function( self )
                if( InCombatLockdown() ) then
                    return;
                end
                if( not Addon.APP.Config:IsVisible() ) then
                    return;
                end
                --if( string.len( self:GetText() ) > 3 ) then
                    Addon.APP:Query();
                --end
            end );
    
            self.Heading.Name = Addon.FRAMES:AddLabel( { DisplayText = 'Name' },self.Heading,self.Theme.Normal );
            self.Heading.Name:SetPoint( 'topleft',self.Heading,'topleft',self.Heading.ColInset,( ( self.Heading:GetHeight() )*-1 )+20 );
            self.Heading.Name:SetSize( 180,self.Heading.FieldHeight );
            self.Heading.Name:SetJustifyH( 'right' );

            self.Heading.Scope = Addon.FRAMES:AddLabel( { DisplayText = 'Scope' },self.Heading,self.Theme.Normal );
            self.Heading.Scope:SetPoint( 'topleft',self.Heading.Name,'topright',self.Heading.ColInset,0 );
            self.Heading.Scope:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Scope:SetJustifyH( 'left' );

            self.Heading.Category = Addon.FRAMES:AddLabel( { DisplayText = 'Category' },self.Heading,self.Theme.Normal );
            self.Heading.Category:SetPoint( 'topleft',self.Heading.Scope,'topright',self.Heading.ColInset,0 );
            self.Heading.Category:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Category:SetJustifyH( 'left' );

            self.Heading.Default = Addon.FRAMES:AddLabel( { DisplayText = 'Default' },self.Heading,self.Theme.Normal );
            self.Heading.Default:SetPoint( 'topleft',self.Heading.Category,'topright',self.Heading.ColInset,0 );
            self.Heading.Default:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Default:SetJustifyH( 'left' );

            self.Heading.Adjustment = Addon.FRAMES:AddLabel( { DisplayText = 'Adjustment' },self.Heading,self.Theme.Normal );
            self.Heading.Adjustment:SetPoint( 'topleft',self.Heading.Default,'topright',0,0 );
            self.Heading.Adjustment:SetSize( 150,self.Heading.FieldHeight );
            self.Heading.Adjustment:SetJustifyH( 'left' );

            self.Heading.Art = Addon.FRAMES:AddBackGround( self.Heading );
            self.Heading.Art:SetAllPoints( self.Heading );

            self.Browser = CreateFrame( 'Frame',self.Name..'Browser',self.Config );
            self.Browser:SetSize( self.Heading:GetWidth(),400 );
            self.Browser:SetPoint( 'topleft',self.Heading,'bottomleft',0,-10 );

            self.Browser.Art = Addon.FRAMES:AddBackGround( self.Browser );
            self.Browser.Art:SetAllPoints( self.Browser );
  
            self.Browser.BookEnd = self.Browser:CreateTexture( nil,'ARTWORK',nil,3 );
            self.Browser.BookEnd:SetTexture( 'Interface\\azerite\\azeritecenterbggold' );
            self.Browser.BookEnd:SetSize( 65,self.Browser:GetHeight() );
            self.Browser.BookEnd:SetPoint( 'topright',self.Browser,'topright',0,0 );

            self.ScrollFrame = CreateFrame( 'ScrollFrame',self.Name..'ScrollFrame',self.Browser,'UIPanelScrollFrameTemplate' );
            self.ScrollFrame:SetAllPoints( self.Browser );

            self.ScrollChild = CreateFrame( 'Frame',self.Name..'ScrollChild' );
            self.ScrollFrame:SetScrollChild( self.ScrollChild );
            if( SettingsPanel ) then
                self.ScrollChild:SetWidth( SettingsPanel:GetWidth() );
            elseif( InterfaceOptionsFramePanelContainer ) then
                self.ScrollChild:SetWidth( InterfaceOptionsFramePanelContainer:GetWidth() );
            end
            self.ScrollChild:SetHeight( 20 );

            self.Footer = CreateFrame( 'Frame',self.Name..'Footer',self.Config );
            self.Footer:SetSize( self.Browser:GetWidth(),50 );
            self.Footer:SetPoint( 'topleft',self.Browser,'bottomleft',0,-10 );

            self.Footer.Art = Addon.FRAMES:AddBackGround( self.Footer );
            self.Footer.Art:SetAllPoints( self.Footer );

            self.Stats = CreateFrame( 'Frame',self.Name..'FooterStats',self.Footer );
            self.Stats:SetSize( self.Footer:GetWidth()/2,self.Footer:GetHeight() );
            self.Stats:SetPoint( 'topright',self.Footer,'topright',0,0 );

            self.Controls = CreateFrame( 'Frame',self.Name..'FooterConfig',self.Footer );
            self.Controls:SetSize( self.Footer:GetWidth()/2,self.Footer:GetHeight() );
            self.Controls:SetPoint( 'topright',self.Stats,'topleft',0,0 );

            local MovingPort = Addon.APP:AddMovablePort( self.Browser );
            MovingPort.Edit.Input:SetScript( 'OnEditFocusLost',function( self )
                if( Addon.DB:GetValue( 'Debug' ) ) then
                    Addon.FRAMES:Debug( 'MovingPort.Edit.Input','OnEditFocusLost','setting focus....' )
                end
                self:SetFocus();
            end );

            local RefreshData = {
                Name = 'Refresh',
                DisplayText = 'Apply settings on each reload',
            };
            self.Apply = Addon.FRAMES:AddToggle( RefreshData,self.Controls );
            self.Apply.keyValue = RefreshData.Name;
            self.Apply:SetChecked( self:GetValue( self.Apply.keyValue ) );
            self.Apply:SetPoint( 'topleft',self.Controls,'topleft',0,0 );
            self.Apply.Label = Addon.FRAMES:AddLabel( RefreshData,self.Apply,self.Theme.Normal );
            self.Apply.Label:SetPoint( 'topleft',self.Apply,'topright',0,-3 );
            self.Apply.Label:SetSize( ( self.Controls:GetWidth()/3 )-5,20 );
            self.Apply.Label:SetJustifyH( 'left' );
            self.Apply:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            local ReloadUIData = {
                Name = 'ReloadUI',
                DisplayText = 'Reload UI for each update',
            };
            self.ReloadUI = Addon.FRAMES:AddToggle( ReloadUIData,self.Controls );
            self.ReloadUI.keyValue = ReloadUIData.Name;
            self.ReloadUI:SetChecked( self:GetValue( self.ReloadUI.keyValue ) );
            self.ReloadUI:SetPoint( 'topleft',self.Apply.Label,'topright',0,3 );
            self.ReloadUI.Label = Addon.FRAMES:AddLabel( ReloadUIData,self.ReloadUI,self.Theme.Normal );
            self.ReloadUI.Label:SetPoint( 'topleft',self.ReloadUI,'topright',0,-3 );
            self.ReloadUI.Label:SetSize( ( self.Controls:GetWidth()/3 )-5,20 );
            self.ReloadUI.Label:SetJustifyH( 'left' );
            self.ReloadUI:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            local ReloadGXData = {
                Name = 'ReloadGX',
                DisplayText = 'Reload GX for each update',
            };
            self.ReloadGX = Addon.FRAMES:AddToggle( ReloadGXData,self.Controls );
            self.ReloadGX.keyValue = ReloadGXData.Name;
            self.ReloadGX:SetChecked( self:GetValue( self.ReloadGX.keyValue ) );
            self.ReloadGX:SetPoint( 'topleft',self.ReloadUI.Label,'topright',0,3 );
            self.ReloadGX.Label = Addon.FRAMES:AddLabel( ReloadGXData,self.ReloadGX,self.Theme.Normal );
            self.ReloadGX.Label:SetPoint( 'topleft',self.ReloadGX,'topright',0,-3 );
            self.ReloadGX.Label:SetSize( ( self.Controls:GetWidth()/3 )-5,20 );
            self.ReloadGX.Label:SetJustifyH( 'left' );
            self.ReloadGX:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            local ImportCVs = {
                Name = 'Import',
                DisplayText = 'Import',
            };
            self.ImportCVs = Addon.FRAMES:AddButton( ImportCVs,self.Controls,self.Theme.HighLight );
            self.ImportCVs.keyValue = ImportCVs.Name;
            self.ImportCVs:SetPoint( 'topleft',self.ReloadGX.Label,'topright',10,3 );
            self.ImportCVs:SetSize( 50,25 );
            self.ImportCVs:HookScript( 'OnClick',function( self )

                local Input = MovingPort.Edit.Input;
                local Value = Input:GetText();
                if( Value ) then
                    Input:SetText( 'Paste your import string' );
                end

                MovingPort:Show();

                Input:HighlightText( 0 );
                Input:SetFocus();

                Addon.FRAMES:Warn( 'This will cause your game to temporarily freeze' );
            end );

            local ExportCVs = {
                Name = 'Export',
                DisplayText = 'Export',
            };
            self.ExportCVs = Addon.FRAMES:AddButton( ExportCVs,self.Controls,self.Theme.HighLight );
            self.ExportCVs.keyValue = ExportCVs.Name;
            self.ExportCVs:SetPoint( 'topleft',self.ImportCVs,'topright',10,0 );
            self.ExportCVs:SetSize( 50,25 );
            self.ExportCVs:HookScript( 'OnClick',function( self )

                local Input = MovingPort.Edit.Input;
                local Value = Input:GetText();
                if( Value ) then
                    Input:SetText( '' );
                end

                MovingPort:Show();

                local Export = '';
                for VarName,VarData in pairs( Addon.APP.Registry ) do
                    local Key = string.lower( VarName );
                    local Value = Addon.APP:GetVarValue( Key );
                    local Dict = Addon.DICT:GetDictionary()[ Key ];

                    if( Value ~= nil ) then
                        if( Dict and Dict.DefaultValue ~= Value ) then
                            Export = Export..Dict.Key..':::'..Value..',';
                        end
                    end
                end
                Input:SetText( Export );
                Input:HighlightText( 0 );
                Input:SetFocus();
            end );

            local DefaultUI = {
                Name = 'DefaultUI',
                DisplayText = 'Defaults',
            };
            self.DefaultUI = Addon.FRAMES:AddButton( DefaultUI,self.Controls,self.Theme.HighLight );
            self.DefaultUI.keyValue = DefaultUI.Name;
            self.DefaultUI:SetPoint( 'topleft',self.ExportCVs,'topright',10,0 );
            self.DefaultUI:SetSize( 50,25 );
            self.DefaultUI:HookScript( 'OnClick',function( self )
                Addon.DB:Reset();
                DEFAULT_CHAT_FRAME.editBox:SetText( '/console cvar_default' );
                ChatEdit_SendText( DEFAULT_CHAT_FRAME.editBox,0 );
            end );

            local DebugData = {
                Name = 'Debug',
                DisplayText = 'Debug',
            };
            self.Debug = Addon.FRAMES:AddToggle( DebugData,self.Controls );
            self.Debug.keyValue = DebugData.Name;
            self.Debug:SetChecked( self:GetValue( self.Debug.keyValue ) );
            self.Debug:SetPoint( 'topleft',self.Apply,'bottomleft',0,0 );
            self.Debug.Label = Addon.FRAMES:AddLabel( DebugData,self.Debug,self.Theme.Normal );
            self.Debug.Label:SetPoint( 'topleft',self.Debug,'topright',0,-3 );
            self.Debug.Label:SetSize( ( self.Controls:GetWidth()/3 )-5,20 );
            self.Debug.Label:SetJustifyH( 'left' );
            self.Debug:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            local ReloadImportData = {
                Name = 'ReloadOnImport',
                DisplayText = 'Reload UI for import',
            };
            self.ReloadOnImport = Addon.FRAMES:AddToggle( ReloadImportData,self.Controls );
            self.ReloadOnImport.keyValue = ReloadImportData.Name;
            self.ReloadOnImport:SetChecked( self:GetValue( self.ReloadOnImport.keyValue ) );
            self.ReloadOnImport:SetPoint( 'topleft',self.ReloadUI,'bottomleft',0,0  );
            self.ReloadOnImport.Label = Addon.FRAMES:AddLabel( ReloadImportData,self.ReloadOnImport,self.Theme.Normal );
            self.ReloadOnImport.Label:SetPoint( 'topleft',self.ReloadOnImport,'topright',0,-3 );
            self.ReloadOnImport.Label:SetSize( ( self.Controls:GetWidth()/3 )-5,20 );
            self.ReloadOnImport.Label:SetJustifyH( 'left' );
            self.ReloadOnImport:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

            local Info = {
                Name = 'Theme',
                KeyPairs = {
                    {
                        Description = 'Sex',
                        Value = 'Sex',
                    },
                    {
                        Description = 'Gold',
                        Value = 'Gold',
                    },
                    {
                        Description = 'Blue',
                        Value = 'Blue',
                    },
                },
            };

            self.ThemeSwap = CreateFrame( 'DropdownButton',nil,self.Controls,'WowStyle1DropdownTemplate' );
            self.ThemeSwap:SetDefaultText( self:GetValue( 'Theme' ) );
            self.ThemeSwap:SetPoint( 'topleft',self.ReloadGX,'bottomleft',10 );
            self.ThemeSwap:SetDefaultText( Info.Name );

            self.ThemeSwap:SetupMenu(function( DropDown,Interface )
                --Interface:CreateTitle( Info.Name );
                for i,v in pairs( Info.KeyPairs ) do
                    Interface:CreateButton( v.Description,function()
                        --DropDown:SetDefaultText( v.Value );

                        self:SetValue( 'Theme',v.Value );
                        self.Theme.HighLight = Addon.Theme[ v.Value ];

                        self:Query();
                    end)
                end
            end );
            if( Addon:IsClassic() and self.ThemeSwap:GetWidth() <= 60 ) then
                self.ThemeSwap:SetWidth( 120 );
            end

            local Category,Layout;
            if( InterfaceOptions_AddCategory ) then
                InterfaceOptions_AddCategory( self.Config,self.Name );
            elseif( Settings and Settings.RegisterCanvasLayoutCategory ) then
                Category,Layout = Settings.RegisterCanvasLayoutCategory( self.Config,self.Name );
                Settings.RegisterAddOnCategory( Category );
            end

            SLASH_JVARS1,SLASH_JVARS2,SLASH_JVARS3 = '/jv','/vars','/jvars';
            SlashCmdList['JVARS'] = function( Msg,EditBox )
                if( InterfaceOptionsFrame_OpenToCategory ) then
                    InterfaceOptionsFrame_OpenToCategory( self.Name );
                    InterfaceOptionsFrame_OpenToCategory( self.Name );
                else
                    Settings.OpenToCategory( Category.ID );
                end
            end

            hooksecurefunc( 'SetCVar',function( ... )
                local Index,Value,Ignored,Internal = ...;
                if( not Internal ) then
                    if( Index ~= nil and Value ~= nil ) then
                        local Result = Addon.DB:SetVarValue( Index,Value );
                        if( Result ) then
                            if( Addon.DB:GetPersistence().Vars[ string.lower( Index ) ] ) then
                                if( Addon.DB:GetPersistence().Vars[ string.lower( Index ) ].Dictionary ) then
                                    Addon.DB:GetPersistence().Vars[ string.lower( Index ) ].Dictionary.CurrentValue = GetCVar( Index );
                                end
                            end
                            if( Addon.DB:GetValue( 'Debug' ) ) then
                                Addon.FRAMES:Debug( 'Non-Internal SetCVar call...','Index:',tostring( Index ),'Value:',tostring( Value ) );
                            end
                            Addon.APP:Query();
                        end
                    end
                end
            end );
        end
        
        C_Timer.After( 15,function()
            Addon.DB:Init();
            Addon.APP:Init();
            if( Addon.APP:GetValue( 'Refresh' ) ) then
                Addon.APP:Refresh();
            end
        end );

        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );