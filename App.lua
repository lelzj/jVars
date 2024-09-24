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
                SetCVar( Index,Value );
                local VarData = Addon.REG:GetRegistry()[ Addon:Minify( Index ) ];
                if( VarData and VarData.Protected ) then
                    for Handling,_ in pairs( VarData.Protected ) do
                        if( Addon.APP[Handling] ) then
                            Addon.APP[Handling]( Index,VarData,true );
                        end
                    end
                end

                if( VarData and VarData.Cascade ) then
                    for Name,Data in pairs( VarData.Cascade ) do
                        SetCVar( Addon:Minify( Name ),Value );
                        --print( 'Cascade',Addon:Minify( Name ),Value )
                    end
                end

                if( Addon.DB:GetValue( 'Debug' ) ) then
                    Addon.FRAMES:Notify( 'Updated',Addon.DICT:GetDictionary()[ string.lower( Index ) ].DisplayText,'to',Addon.APP:GetVarValue( Index ) );
                end
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
        --  @param  string  IndexInterfaceOverrides.SetRaidProfileOption
        --  @return mixed
        Addon.APP.GetValue = function( self,Index )
            return Addon.DB:GetValue( Index );
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

        --
        --  Setup raid frames
        --
        --  @param  string  VarName
        --  @param  table   VarData
        --  @param  bool    Manual
        --  @return void
        Addon.APP.RefreshCompactPartyFrame = function( VarName,VarData,Manual )

            -- /Blizzard_CUFProfiles/Blizzard_CompactUnitFrameProfiles.xml
            -- $parentKey:
            -- 
            -- where $parent is CompactUnitFrameProfiles
            -- and Key is referred to such as $parentRaidStylePartyFrames
            --
            -- More keys:
            --             $parentHeightSlider
            --             $parentWidthSlider

            if( Addon:Minify( VarName ):find( Addon:Minify( 'useCompactPartyFrames' ) ) ) then
                if( CompactUnitFrameProfilesRaidStylePartyFrames ) then
                    local CurrentValue = CompactUnitFrameProfilesRaidStylePartyFrames:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesRaidStylePartyFrames:Click();
                    end
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionKeepGroupsTogether' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether:Click();
                    end
                end
                if( CompactRaidFrameManager_SetKeepGroupsTogether ) then
                    CompactRaidFrameManager_SetKeepGroupsTogether( Addon:Int2Bool( self:GetVarValue( VarName ) ) );
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionSortMode' ) ) ) then
                if( CompactRaidFrameManager_SetSortMode ) then
                    CompactRaidFrameManager_SetSortMode( self:GetVarValue( VarName ) );
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesDisplayPowerBars' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar:Click();
                    end
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesDisplayClassColor' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors:Click();
                    end
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionDisplayPets' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets:Click();
                    end
                end
                if( CompactRaidFrameManager_SetDisplayPets ) then
                    CompactRaidFrameManager_SetDisplayPets( Addon:Int2Bool( self:GetVarValue( VarName ) ) );
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionDisplayMainTankAndAssist' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameMainTankAndAssist ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameMainTankAndAssist:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameMainTankAndAssist:Click();
                    end
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidOptionShowBorders' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder:Click();
                    end
                end
                if( CompactRaidFrameManager_SetBorderShown ) then
                    CompactRaidFrameManager_SetBorderShown( Addon:Int2Bool( self:GetVarValue( VarName ) ) );
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesDisplayOnlyDispellableDebuffs' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs:GetChecked();
                    if( CurrentValue ~= Addon:Int2Bool( self:GetVarValue( VarName ) ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs:Click();
                    end
                end
            end

            if( Addon:Minify( VarName ):find( Addon:Minify( 'raidFramesHealthText' ) ) ) then
                if( CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown ) then
                    local CurrentValue = CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown.selectedValue;
                    if( CurrentValue ~= self:GetVarValue( VarName ) ) then
                        CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown.selectedValue = self:GetVarValue( VarName );
                    end
                end
            end

            CompactUnitFrameProfiles_UpdateCurrentPanel();
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
                            end
                        end
                    end
                end;
                Addon.FRAMES:Notify( 'Done' );
            end );
        end

        SLASH_JVARS1,SLASH_JVARS2,SLASH_JVARS3 = '/jv','/vars','/jvars';
        SlashCmdList['JVARS'] = function( Msg,EditBox )
            Settings.OpenToCategory( AddonName );
        end

        local EventFrame = CreateFrame( 'Frame' );
        EventFrame:RegisterEvent( 'COMPACT_UNIT_FRAME_PROFILES_LOADED' );
        EventFrame:SetScript( 'OnEvent',function( self,Event)
            Addon.CONFIG:CreateFrames();
            if( Addon.APP:GetValue( 'Refresh' ) ) then
                Addon.APP:Refresh();
            end
            EventFrame:UnregisterEvent( 'COMPACT_UNIT_FRAME_PROFILES_LOADED' );
        end );
        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );