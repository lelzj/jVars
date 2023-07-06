local _, Addon = ...;

Addon.RAID = CreateFrame( 'Frame' );
Addon.RAID:RegisterEvent( 'ADDON_LOADED' )
Addon.RAID.FistColInset = 15;
Addon.RAID.RegisteredFrames = {};
Addon.RAID:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.RAID.GetDefaults = function( self )
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
        Addon.RAID.SetValue = function( self,Index,Value )
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
                self:Refresh();
            end
        end

        --
        --  Get module setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.RAID.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.RAID.FrameRegister = function( self,FrameData )
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

        Addon.RAID.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.RAID.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.RAID.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.RAID.Filter = function( self,SearchQuery )
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
        Addon.RAID.CreateFrames = function( self )
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
        Addon.RAID.Refresh = function( self )
            if( not Addon.RAID.persistence ) then
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
        Addon.RAID.ResetDb = function( self )
            self.db:ResetDB();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.RAID.Init = function( self )
        self.Name = 'jRaid';
            local RegisteredVars = {
                RAIDfarclip = {
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
                raidFramesDisplayClassColor = {
                    Type = 'Toggle',
                },
                raidFramesHealthText = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'none',
                            Description = 'None',
                        },
                        {
                            Value = 'health',
                            Description = 'Health Remaining',
                        },
                        {
                            Value = 'losthealth',
                            Description = 'Health Lost (ie Deficit)',
                        },
                        {
                            Value = 'perc',
                            Description = 'Health Percentage',
                        },
                    },
                },
                raidFramesHeight = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 75,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 25,
                },
                raidFramesWidth = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 75,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 25,
                },
                raidGraphicsEnvironmentDetail = {
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
                raidGraphicsGroundClutter = {
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
                raidGraphicsLiquidDetail = {
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
                raidGraphicsParticleDensity = {
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
                raidGraphicsShadowQuality = {
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
                raidGraphicsSSAO = {
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
                RAIDgraphicsQuality = {
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
                raidOptionDisplayPets = {
                    Type = 'Toggle',
                },
                raidOptionIsShown = {
                    Type = 'Toggle',
                },
                raidOptionKeepGroupsTogether = {
                    Type = 'Toggle',
                },
                raidOptionShowBorders = {
                    Type = 'Toggle',
                },
                raidOptionSortMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'role',
                            Description = 'Role',
                        },
                        {
                            Value = 'group',
                            Description = 'Group',
                        },
                    },
                },
                RAIDweatherDensity = {
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
                useCompactPartyFrames = {
                    Type = 'Toggle',
                },
                lfgNewPlayerFriendly = {
                    Type = 'Toggle',
                },
                alwaysShowBlizzardGroupsTab = {
                    Type = 'Toggle',
                },
                raidGraphicsSunshafts = {
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
                showPartyBackground = {
                    Type = 'Toggle',
                },
                calendarShowResets = {
                    Type = 'Toggle',
                },
                enablePVPNotifyAFK = {
                    Type = 'Toggle',
                },
                raidFramesDisplayPowerBars = {
                    Type = 'Toggle',
                },
                raidOptionDisplayMainTankAndAssist = {
                    Type = 'Toggle',
                },
                raidOptionLocked = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'lock',
                            Description = 'Locked',
                        },
                        {
                            Value = 'unlock',
                            Description = 'Unlocked',
                        },
                    },
                },
                showCastableBuffs = {
                    Type = 'Toggle',
                },
                raidFramesDisplayOnlyDispellableDebuffs = {
                    Type = 'Toggle',
                },
                showDispelDebuffs = {
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
        Addon.RAID.Run = function( self )
            self.ScrollChild = Addon.GRID:RegisterGrid( self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox',self.Name..'Filter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.RAID:ShowAll();
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
                Addon.RAID:ShowAll();
                Addon.RAID:Filter( self:GetText(),Addon.RAID );
            end );
        end

        Addon.RAID:Init();
        Addon.RAID:CreateFrames();
        Addon.RAID:Refresh();
        Addon.RAID:Run();
        Addon.RAID:UnregisterEvent( 'ADDON_LOADED' );
    end
end );