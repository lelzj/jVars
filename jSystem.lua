local _, Addon = ...;

Addon.SYSTEM = CreateFrame( 'Frame' );
Addon.SYSTEM:RegisterEvent( 'ADDON_LOADED' )
Addon.SYSTEM.FistColInset = 15;
Addon.SYSTEM.RegisteredFrames = {};
Addon.SYSTEM:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.SYSTEM.GetDefaults = function( self )
            local Defaults = {};
            for VarName,_ in pairs( self.RegisteredVars ) do
                Defaults[ string.lower( VarName ) ] = GetCVar( VarName );
                if( Defaults[ string.lower( VarName ) ] == nil ) then
                    Defaults[ string.lower( VarName ) ] = 0;
                    self.RegisteredVars[ string.lower( VarName ) ].Flagged = true;
                    print( AddonName..' Flagging '..VarName );
                end
            end
            return Defaults;
        end

        --
        --  Set module setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return void
        Addon.SYSTEM.SetValue = function( self,Index,Value )
            if( self.RegisteredVars[ string.lower( Index ) ] ) then
                if( self.RegisteredVars[ string.lower( Index ) ].Type == 'Toggle' ) then
                    if( type( Value ) == 'boolean' ) then
                        self.persistence[ string.lower( Index ) ] = Addon:BoolToInt( Value );
                    else
                        self.persistence[ string.lower( Index ) ] = Value;
                    end
                else
                    self.persistence[ string.lower( Index ) ] = Value;
                end
            end
        end

        --
        --  Get module setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.SYSTEM.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.SYSTEM.FrameRegister = function( self,FrameData )
            local Found = false;
            for i,MetaData in pairs( self.RegisteredFrames ) do
                if( MetaData.Name == FrameData.Name ) then
                    Found = true;
                end
            end
            if( not Found ) then
                table.insert( self.RegisteredFrames,{
                    Name        = FrameData.Name,
                    Frame       = FrameData.Frame,
                    Description = FrameData.Description,
                } );
            end
        end

        Addon.SYSTEM.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.SYSTEM.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.SYSTEM.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.SYSTEM.Filter = function( self,SearchQuery )
            if( not ( string.len( SearchQuery ) >= 3 ) ) then
                return;
            end
            local FoundFrames = {};
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( Addon:Minify( FrameData.Name ):find( Addon:Minify( SearchQuery ) ) ) then
                    if( not FoundFrames [ string.lower( FrameData.Name ) ] ) then
                        FoundFrames [ string.lower( FrameData.Name ) ] = FrameData.Frame;
                    end
                end
                if( Addon:Minify( FrameData.Description ):find( Addon:Minify( SearchQuery ) ) ) then
                    if( not FoundFrames [ string.lower( FrameData.Name ) ] ) then
                        FoundFrames [ string.lower( FrameData.Name ) ] = FrameData.Frame;
                    end
                end
            end
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( not FoundFrames[ string.lower( FrameData.Name ) ] ) then
                    FrameData.Frame:Hide();
                else
                    FrameData.Frame:Show();
                end
            end
        end

        --
        --  Create module config frames
        --
        --  @return void
        Addon.SYSTEM.CreateFrames = function( self )
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( self.Name ),{
                type = 'group',
                name = self.Name,
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( self.Name ),self.Name,'jVars' );
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.SYSTEM.Refresh = function( self )
            if( not Addon.SYSTEM.persistence ) then
                return;
            end
            for VarName,VarData in pairs( self.RegisteredVars ) do
                if( self.persistence[ string.lower( VarName ) ] ~= nil ) then
                    SetCVar( string.lower( VarName ),self.persistence[ string.lower( VarName ) ] );
                end
            end
        end

        --
        --  Module reset
        --
        --  @return void
        Addon.SYSTEM.ResetDb = function( self )
            self.db:ResetDB();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.SYSTEM.Init = function( self )
            self.Name = 'jSystem';
            local RegisteredVars = {
                equipmentManager = {
                    Type = 'Toggle',
                },
                consolidateBuffs = {
                    Type = 'Toggle',
                },
                autoClearAFK = {
                    Type = 'Toggle',
                },
                autoLootDefault = {
                    Type = 'Toggle',
                },
                autoSelfCast = {
                    Type = 'Toggle',
                },
                cameraDistanceMaxZoomFactor = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3.4,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                cameraSmoothStyle = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Never adjust camera',
                        },
                        {
                            Value = 1,
                            Description = 'Adjust camera only horizontal when moving',
                        },
                        {
                            Value = 2,
                            Description = 'Always adjust camera',
                        },
                        {
                            Value = 4,
                            Description = 'Adjust camera only when moving',
                        },
                    },
                },
                deselectOnClick = {
                    Type = 'Toggle',
                },
                doNotFlashLowHealthWarning = {
                    Type = 'Toggle',
                },
                emphasizeMySpellEffects = {
                    Type = 'Toggle',
                },
                farclip = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1300,
                            Description = 'High',
                        },
                    },
                    Step = 100,
                },
                ffxDeath = {
                    Type = 'Toggle',
                },
                ffxGlow = {
                    Type = 'Toggle',
                },
                graphicsEnvironmentDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                graphicsGroundClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                graphicsLiquidDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                graphicsShadowQuality = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 5,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                graphicsSSAO = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 4,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                graphicsQuality = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                groundEffectDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 16,
                            Description = 'Low',
                        },
                        High = {
                            Value = 256,
                            Description = 'High',
                        },
                    },
                    Step = 16,
                },
                interactOnLeftClick = {
                    Type = 'Toggle',
                },
                lootUnderMouse = {
                    Type = 'Toggle',
                },
                instantQuestText = {
                    Type = 'Toggle',
                },
                particleDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 10,
                            Description = 'Low',
                        },
                        High = {
                            Value = 100,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                projectedtextures = {
                    Type = 'Toggle',
                },
                RenderScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                screenEdgeFlash = {
                    Type = 'Toggle',
                },
                showTutorials = {
                    Type = 'Toggle',
                },
                SkyCloudLOD = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                SpellQueueWindow = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 400,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },
                timeMgrUseLocalTime = {
                    Type = 'Toggle',
                },
                uiScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                violencelevel = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 5,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                weatherDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                useIPv6 = {
                    Type = 'Toggle',
                },
                xpBarText = {
                    Type = 'Toggle',
                },
                synchronizeMacros = {
                    Type = 'Toggle',
                },
                synchronizeSettings = {
                    Type = 'Toggle',
                },
                showfootprintparticles = {
                    Type = 'Toggle',
                },
                speechToText = {
                    Type = 'Toggle',
                },
                synchronizeConfig = {
                    Type = 'Toggle',
                },
                pathSmoothing = {
                    Type = 'Toggle',
                },
                secureAbilityToggle = {
                    Type = 'Toggle',
                },
                maxFPSLoading = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                maxFPSBk = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                displayFreeBagSlots = {
                    Type = 'Toggle',
                },
                maxFPS = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                cursorSizePreferred = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = -1,
                            Description = 'Determine based on system/monitor dpi',
                        },
                        {
                            Value = 0,
                            Description = '32x32',
                        },
                        {
                            Value = 1,
                            Description = '48x48',
                        },
                        {
                            Value = 2,
                            Description = '64x64',
                        },
                        {
                            Value = 3,
                            Description = '96x96',
                        },
                        {
                            Value = 4,
                            Description = '128x128',
                        },
                    },
                },
                cameraCustomViewSmoothing = {
                    Type = 'Toggle',
                },
                CameraKeepCharacterCentered = {
                    Type = 'Toggle',
                },
                cameraPivot = {
                    Type = 'Toggle',
                },
                cameraTerrainTilt = {
                    Type = 'Toggle',
                },
                ClipCursor = {
                    Type = 'Toggle',
                },
                colorblindMode = {
                    Type = 'Toggle',
                },
                cameraBobbingSmoothSpeed = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                buffDurations = {
                    Type = 'Toggle',
                },
                calendarShowBattlegrounds = {
                    Type = 'Toggle',
                },
                calendarShowDarkmoon = {
                    Type = 'Toggle',
                },
                calendarShowHolidays = {
                    Type = 'Toggle',
                },
                cameraBobbing = {
                    Type = 'Toggle',
                },
                Brightness = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 100,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                autoLootRate = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 50,
                            Description = 'Low',
                        },
                        High = {
                            Value = 300,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                autoOpenLootHistory = {
                    Type = 'Toggle',
                },
                breakUpLargeNumbers = {
                    Type = 'Toggle',
                },
                ActionButtonUseKeyDown = {
                    Type = 'Toggle',
                },
                advancedCombatLogging = {
                    Type = 'Toggle',
                },
                advancedWatchFrame = {
                    Type = 'Toggle',
                },
                autoDismount = {
                    Type = 'Toggle',
                },
                autoDismountFlying = {
                    Type = 'Toggle',
                },
                autoInteract = {
                    Type = 'Toggle',
                },
                cameraFov = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 50,
                            Description = 'Low',
                        },
                        High = {
                            Value = 90,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                previewTalents = {
                    Type = 'Toggle',
                },
                graphicsSunshafts = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                groundEffectAnimation = {
                    Type = 'Toggle',
                },
                showKeyring = {
                    Type = 'Toggle',
                },
                showNewbieTips = {
                    Type = 'Toggle',
                },
            };
            self.RegisteredVars = {};
            for VarName,VarData in pairs( RegisteredVars ) do
                if( Addon.VARS.Dictionary[ string.lower( VarName ) ] ) then
                    VarData.Description = Addon.VARS.Dictionary[ string.lower( VarName ) ].Description;
                    VarData.DisplayText = Addon.VARS.Dictionary[ string.lower( VarName ) ].DisplayText;
                else
                    VarData.Description = 'Info is currently unavailable';
                    VarData.DisplayText = VarName;
                end
                VarData.Name = string.lower( VarName );
                self.RegisteredVars[ string.lower( VarName ) ] = VarData;
            end
            self.db = LibStub( 'AceDB-3.0' ):New( self.Name,{ profile = self:GetDefaults() },true );
            if( not self.db ) then
                return;
            end
            --self.db:ResetDB();
            self.persistence = self.db.profile;
            if( not self.persistence ) then
                return;
            end
        end

        --
        --  Module run
        --
        --  @return void
        Addon.SYSTEM.Run = function( self )
            self.ScrollChild = Addon.GRID:RegisterGrid( self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox',self.Name..'Filter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.SYSTEM:ShowAll();
                self:SetAutoFocus( false );
                if( self.Instructions ) then
                    self.Instructions:Show();
                end
                self:ClearFocus();
                self:SetText( '' );
            end );
            self.FilterBox:SetScript( 'OnEditFocusGained',function( self ) 
                self:SetAutoFocus( true );
                if( self.Instructions ) then
                    self.Instructions:Hide();
                end
                self:HighlightText();
            end );
            self.FilterBox:SetScript( 'OnTextChanged',function( self )
                Addon.SYSTEM:ShowAll();
                Addon.SYSTEM:Filter( self:GetText(),Addon.SYSTEM );
            end );
        end

        Addon.SYSTEM:Init();
        Addon.SYSTEM:CreateFrames();
        Addon.SYSTEM:Refresh();
        Addon.SYSTEM:Run();
        Addon.SYSTEM:UnregisterEvent( 'ADDON_LOADED' );
    end
end );