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
        Addon.APP.SetVarValue = function( self,Index,Value )
            if( InCombatLockdown() ) then
                return;
            end
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
                local VarData = Addon.REG:GetRegistry()[ Addon:Minify( Index ) ];
                if( VarData and VarData.Protected ) then
                    for Handling,_ in pairs( VarData.Protected ) do
                        if( Addon.APP[Handling] ) then
                            Addon.APP[Handling]( Index,VarData,true );
                        end
                    end
                end
                Addon.FRAMES:Notify( 'Updated',Addon.DICT:GetDictionary()[ Addon:Minify( Index ) ].DisplayText,'to',Addon.APP:GetVarValue( Index ) );
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

        --
        --  Setup raid frames
        --
        --  @param  string  VarName
        --  @param  table   VarData
        --  @param  bool    Manual
        --  @return void
        Addon.APP.RefreshCompactPartyFrame = function( VarName,VarData,Manual )

            local category,layout = Settings.RegisterVerticalLayoutCategory( INTERFACE_LABEL );

            -- Party frame
            if( Addon:Minify( VarName ):find( Addon:Minify( 'useCompactPartyFrames' ) ) ) then
                local function CVarChangedCB()
                    local compactFrames = C_CVar.GetCVarBool( 'useCompactPartyFrames' );
                    RaidOptionsFrame_UpdatePartyFrames()
                    CompactRaidFrameManager_UpdateShown( CompactRaidFrameManager );
                    InterfaceOverrides.RefreshRaidOptions();
                end

                CVarChangedCB();
                Settings.SetupCVarCheckBox( category,'useCompactPartyFrames',USE_RAID_STYLE_PARTY_FRAMES,OPTION_TOOLTIP_USE_RAID_STYLE_PARTY_FRAMES);
                CVarCallbackRegistry:RegisterCVarChangedCallback( CVarChangedCB,nil );
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesDisplayClassColor' ) ) ) then
                do
                    -- Use Class Colors
                    local defaultValue = false;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("useClassColors", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("useClassColors", value);
                    end

                    local setting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_CLASS_COLORS", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_USECLASSCOLORS, defaultValue, GetValue, SetValue);
                    Settings.CreateCheckBox(category, setting, OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_USECLASSCOLORS);
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesHealthText' ) ) ) then
                 do
                    -- Display Health Text
                    local defaultValue = "none";
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("healthText", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("healthText", value);
                    end

                    local function GetOptions()
                        local container = Settings.CreateControlTextContainer();
                        container:Add("none", COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_NONE, nil);
                        container:Add("health", COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_HEALTH, nil);
                        container:Add("losthealth", COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_LOSTHEALTH, nil);
                        container:Add("perc", COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_PERC, nil);
                        return container:GetData();
                    end

                    local healthTextSetting = Settings.RegisterProxySetting(category, "PROXY_RAID_HEALTH_TEXT", Settings.DefaultVarLocation,
                        Settings.VarType.String, COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT, defaultValue, GetValue, SetValue);
                    Settings.CreateDropDown(category, healthTextSetting, GetOptions, OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT);
                end
            end

            -- Show debuffs
            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesDisplayOnlyDispellableDebuffs' ) ) ) then
                local debuffsSetting;
                local debuffsInitializer;

                do
                    local defaultValue = true;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("displayNonBossDebuffs", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("displayNonBossDebuffs", value);
                    end

                    debuffsSetting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_SHOW_DEBUFFS", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_DISPLAYNONBOSSDEBUFFS, defaultValue, GetValue, SetValue);
                    debuffsInitializer = Settings.CreateCheckBox(category, debuffsSetting, OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYNONBOSSDEBUFFS);
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesDisplayPowerBars' ) ) ) then
                do
                    -- Display Power Bars
                    local defaultValue = false;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("displayPowerBar", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("displayPowerBar", value);
                    end

                    local setting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_POWER_BAR", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_DISPLAYPOWERBAR, defaultValue, GetValue, SetValue);
                    Settings.CreateCheckBox(category, setting, OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYPOWERBAR);
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionDisplayPets' ) ) ) then
                do
                    -- Display Pets
                    local defaultValue = false;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("displayPets", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("displayPets", value);
                    end

                    local setting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_PETS", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_DISPLAYPETS, defaultValue, GetValue, SetValue);
                    Settings.CreateCheckBox(category, setting, OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYPETS);
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionKeepGroupsTogether' ) ) ) then
                -- Keep Groups Together
                local keepGroupsTogetherSetting;
                local keepGroupsInitializer;

                do
                    local defaultValue = false;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("keepGroupsTogether", defaultValue);
                    end
                    
                    local function SetValue(value)
                        local test = InterfaceOverrides.GetRaidProfileOption("keepGroupsTogether", defaultValue);
                        InterfaceOverrides.SetRaidProfileOption("keepGroupsTogether", value);
                    end

                    SetValue( self:GetVarValue( VarName ) );

                    keepGroupsTogetherSetting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_KEEP_GROUPS_TOGETHER", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_KEEPGROUPSTOGETHER, defaultValue, GetValue, SetValue);
                    keepGroupsInitializer = Settings.CreateCheckBox(category, keepGroupsTogetherSetting, OPTION_TOOLTIP_KEEP_GROUPS_TOGETHER);
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionShowBorders' ) ) ) then
                do
                    -- Display Border
                    local defaultValue = true;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("displayBorder", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("displayBorder", value);
                    end

                    local setting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_BORDER", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_DISPLAYBORDER, defaultValue, GetValue, SetValue);
                    Settings.CreateCheckBox(category, setting, nil);
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionSortMode' ) ) ) then
                local keepGroupsTogetherSetting;
                local keepGroupsInitializer;

                do
                    local defaultValue = false;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("keepGroupsTogether", defaultValue);
                    end
                    
                    local function SetValue(value)
                        local test = InterfaceOverrides.GetRaidProfileOption("keepGroupsTogether", defaultValue);
                        InterfaceOverrides.SetRaidProfileOption("keepGroupsTogether", value);
                    end

                    SetValue( self:GetVarValue( VarName ) );
                    
                    keepGroupsTogetherSetting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_KEEP_GROUPS_TOGETHER", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_KEEPGROUPSTOGETHER, defaultValue, GetValue, SetValue);
                    keepGroupsInitializer = Settings.CreateCheckBox(category, keepGroupsTogetherSetting, OPTION_TOOLTIP_KEEP_GROUPS_TOGETHER);
                end

                -- Sort By
                local defaultValue = "role";
                local function GetValue()
                    return InterfaceOverrides.GetRaidProfileOption("sortBy", defaultValue);
                end
                
                local function SetValue(value)
                    InterfaceOverrides.SetRaidProfileOption("sortBy", value);
                end

                local function GetOptions()
                    local container = Settings.CreateControlTextContainer();
                    container:Add("role", RAID_SORT_ROLE, OPTION_RAID_SORT_BY_ROLE);
                    container:Add("group", RAID_SORT_GROUP, OPTION_RAID_SORT_BY_GROUP);
                    container:Add("alphabetical", RAID_SORT_ALPHABETICAL, OPTION_RAID_SORT_BY_ALPHABETICAL);
                    return container:GetData();
                end

                if( tonumber( self:GetVarValue( VarName ) ) == 0 ) then
                    SetCVar( VarName,defaultValue );
                end

                SetValue( self:GetVarValue( VarName ) );

                local sortBySetting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_SORT_BY", Settings.DefaultVarLocation,
                    Settings.VarType.String, COMPACT_UNIT_FRAME_PROFILE_SORTBY, defaultValue, GetValue, SetValue);

                local sortByInitializer = Settings.CreateDropDown(category, sortBySetting, GetOptions, TOOLTIP_TEXT);

                local function SortShouldShow()
                    return not keepGroupsTogetherSetting:GetValue();
                end

                sortByInitializer:SetParentInitializer(keepGroupsInitializer);
                sortByInitializer:AddShownPredicate(SortShouldShow);
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionDisplayMainTankAndAssist' ) ) ) then
                do
                    -- Display Main Tank and Assist
                    local defaultValue = true;
                    local function GetValue()
                        return InterfaceOverrides.GetRaidProfileOption("displayMainTankAndAssist", defaultValue);
                    end
                    
                    local function SetValue(value)
                        InterfaceOverrides.SetRaidProfileOption("displayMainTankAndAssist", value);
                    end

                    local setting = Settings.RegisterProxySetting(category, "PROXY_RAID_FRAME_TANK_ASSIST", Settings.DefaultVarLocation, 
                        Settings.VarType.Boolean, COMPACT_UNIT_FRAME_PROFILE_DISPLAYMAINTANKANDASSIST, defaultValue, GetValue, SetValue);
                    Settings.CreateCheckBox(category, setting, OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYMAINTANKANDASSIST);
                end
            end

            --local Settings = GetRaidProfileFlattenedOptions( CompactUnitFrameProfiles.selectedProfile );
            --Addon:Dump( Settings );
            CompactUnitFrameProfiles_ApplyCurrentSettings();
            
            if( Manual ) then
                Addon.FRAMES:Warn( 'Changing this setting may require a reload' );
            end
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
            local ShouldRefreshRaid = false;
            C_Timer.After( 5,function()
                Addon.FRAMES:Notify( 'Refreshing all settings...' );
                for VarName,VarData in pairs( Addon.DB:GetPersistence().Vars ) do

                    if( not VarData.Flagged and not VarData.Protected ) then
                        local Updated = SetCVar( Addon:Minify( VarName ),VarData.Value );
                        if( Updated and VarData.Cascade ) then
                            for Name,Data in pairs( VarData.Cascade ) do
                                SetCVar( Addon:Minify( Name ),VarData.Value );
                            end
                        end
                    elseif( not VarData.Flagged and VarData.Protected ) then
                        for Handling,_ in pairs( VarData.Protected ) do
                            if( Addon.APP[Handling] ) then
                                Addon.APP[Handling]( VarName,VarData );
                                ShouldRefreshRaid = true;
                            end
                        end
                        if( ShouldRefreshRaid ) then
                            CompactUnitFrameProfiles_ApplyCurrentSettings();
                        end
                    end
                end;
                Addon.FRAMES:Notify( 'Done' );
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
            if( InCombatLockdown() ) then
                return;
            end
            local AllData = {};
            for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do

                local Key = string.lower( VarName );
                local Value = self:GetVarValue( Key );
                local Flagged = Addon.DB:GetFlagged( Key );
                local Dict = Addon.DICT:GetDictionary()[ Key ];

                if( not Flagged ) then
                    AllData[ Key ] = {
                        DisplayText = Dict.DisplayText,
                        Description = Dict.Description,
                        DefaultValue = Dict.DefaultValue,
                        Type = VarData.Type,                -- Toggle, Range, Select, etc
                        Flagged = Flagged,                  -- Not appearing in list of client commands
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
                --[[
                if( AllData[ Key ].Dict.Secure ) then
                    Addon:Dump( AllData[ Key ] );
                end
                ]]
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

            self.Name = AddonName;

            self.Config = CreateFrame( 'Frame',self.Name);
            self.Config.name = self.Name;

            self.RowHeight = 30;

            self.Heading = CreateFrame( 'Frame',self.Name..'Heading',self.Config );
            self.Heading:SetPoint( 'topleft',self.Config,'topleft',10,-10 );
            self.Heading:SetSize( 610,100 );
            self.Heading.FieldHeight = 10;
            self.Heading.ColInset = 15;

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
                Addon.APP:Query();
            end );
    
            self.Heading.Name = Addon.FRAMES:AddLabel( { DisplayText = 'Name' },self.Heading );
            self.Heading.Name:SetPoint( 'topleft',self.Heading,'topleft',self.Heading.ColInset+3,( ( self.Heading:GetHeight() )*-1 )+20 );
            self.Heading.Name:SetSize( 180,self.Heading.FieldHeight );
            self.Heading.Name:SetJustifyH( 'right' );

            self.Heading.Scope = Addon.FRAMES:AddLabel( { DisplayText = 'Scope' },self.Heading );
            self.Heading.Scope:SetPoint( 'topleft',self.Heading.Name,'topright',self.Heading.ColInset,0 );
            self.Heading.Scope:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Scope:SetJustifyH( 'left' );

            self.Heading.Category = Addon.FRAMES:AddLabel( { DisplayText = 'Category' },self.Heading );
            self.Heading.Category:SetPoint( 'topleft',self.Heading.Scope,'topright',self.Heading.ColInset,0 );
            self.Heading.Category:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Category:SetJustifyH( 'left' );

            self.Heading.Default = Addon.FRAMES:AddLabel( { DisplayText = 'Default' },self.Heading );
            self.Heading.Default:SetPoint( 'topleft',self.Heading.Category,'topright',self.Heading.ColInset,0 );
            self.Heading.Default:SetSize( 50,self.Heading.FieldHeight );
            self.Heading.Default:SetJustifyH( 'left' );

            self.Heading.Adjustment = Addon.FRAMES:AddLabel( { DisplayText = 'Adjustment' },self.Heading );
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
            if( Addon:IsClassic() ) then
                self.ScrollChild:SetWidth( InterfaceOptionsFramePanelContainer:GetWidth() );
            else
                self.ScrollChild:SetWidth( SettingsPanel:GetWidth() );
            end
            self.ScrollChild:SetHeight( 20 );

            self.Footer = CreateFrame( 'Frame',self.Name..'Footer',self.Config );
            self.Footer:SetSize( self.Browser:GetWidth(),25 );
            self.Footer:SetPoint( 'topleft',self.Browser,'bottomleft',0,-10 );

            self.Footer.Art = Addon.FRAMES:AddBackGround( self.Footer );
            self.Footer.Art:SetAllPoints( self.Footer );

            self.Stats = CreateFrame( 'Frame',self.Name..'FooterStats',self.Footer );
            self.Stats:SetSize( self.Footer:GetWidth()/2,self.Footer:GetHeight() );
            self.Stats:SetPoint( 'topright',self.Footer,'topright',0,0 );

            self.Controls = CreateFrame( 'Frame',self.Name..'FooterConfig',self.Footer );
            self.Controls:SetSize( self.Footer:GetWidth()/2,self.Footer:GetHeight() );
            self.Controls:SetPoint( 'topright',self.Stats,'topleft',0,0 );

            local RefreshData = {
                Name = 'Refresh',
                DisplayText = 'Apply settings on each reload',
            };
            self.Apply = Addon.FRAMES:AddToggle( RefreshData,self.Controls );
            self.Apply.keyValue = RefreshData.Name;
            self.Apply:SetChecked( self:GetValue( self.Apply.keyValue ) );
            self.Apply:SetPoint( 'topleft',self.Controls,'topleft',0,0 );
            self.Apply.Label = Addon.FRAMES:AddLabel( RefreshData,self.Apply );
            self.Apply.Label:SetPoint( 'topleft',self.Apply,'topright',0,-3 );
            self.Apply.Label:SetSize( self.Controls:GetWidth()/3,20 );
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
            self.ReloadUI.Label = Addon.FRAMES:AddLabel( ReloadUIData,self.ReloadUI );
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
            self.ReloadGX = Addon.FRAMES:AddToggle( ReloadGXData,self.Controls );
            self.ReloadGX.keyValue = ReloadGXData.Name;
            self.ReloadGX:SetChecked( self:GetValue( self.ReloadGX.keyValue ) );
            self.ReloadGX:SetPoint( 'topleft',self.ReloadUI.Label,'topright',0,3 );
            self.ReloadGX.Label = Addon.FRAMES:AddLabel( ReloadGXData,self.ReloadGX );
            self.ReloadGX.Label:SetPoint( 'topleft',self.ReloadGX,'topright',0,-3 );
            self.ReloadGX.Label:SetSize( self.Controls:GetWidth()/3,20 );
            self.ReloadGX.Label:SetJustifyH( 'left' );
            self.ReloadGX:HookScript( 'OnClick',function( self )
                Addon.APP:SetValue( self.keyValue,self:GetChecked() );
            end );

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
        end

        local EventFrame = CreateFrame( 'Frame' );
        EventFrame:RegisterEvent( 'COMPACT_UNIT_FRAME_PROFILES_LOADED' );
        EventFrame:SetScript( 'OnEvent',function( self,Event)
            Addon.APP:Init();
            if( Addon.APP:GetValue( 'Refresh' ) ) then
                Addon.APP:Refresh();
            end
            EventFrame:UnregisterEvent( 'COMPACT_UNIT_FRAME_PROFILES_LOADED' );
        end );
        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );