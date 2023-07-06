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
            local Defaults = {
                raidGraphicsEnvironmentDetail = GetCVar( 'raidGraphicsEnvironmentDetail' ),
                raidGraphicsGroundClutter = GetCVar( 'raidGraphicsGroundClutter' ),
                raidGraphicsLiquidDetail = GetCVar( 'raidGraphicsLiquidDetail' ),
                raidGraphicsParticleDensity = GetCVar( 'raidGraphicsParticleDensity' ),
                RAIDgraphicsQuality = GetCVar( 'RAIDgraphicsQuality' ),
                raidGraphicsShadowQuality = GetCVar( 'raidGraphicsShadowQuality' ),
                RAIDweatherDensity = GetCVar( 'RAIDweatherDensity' ),
                raidGraphicsSSAO = GetCVar( 'raidGraphicsSSAO' ),
                RAIDfarclip = GetCVar( 'RAIDfarclip' ),
                raidFramesWidth = GetCVar( 'raidFramesWidth' ),
                raidFramesHeight = GetCVar( 'raidFramesHeight' ),
                raidFramesHealthText = GetCVar( 'raidFramesHealthText' ),
                raidOptionKeepGroupsTogether = GetCVar( 'raidOptionKeepGroupsTogether' ),
                raidOptionDisplayPets = GetCVar( 'raidOptionDisplayPets' ),
                raidOptionShowBorders = GetCVar( 'raidOptionShowBorders' ),
                raidOptionSortMode = GetCVar( 'raidOptionSortMode' ),
                raidOptionIsShown = GetCVar( 'raidOptionIsShown' ),
                raidFramesDisplayClassColor = GetCVar( 'raidFramesDisplayClassColor' ),
                raidFramesDisplayOnlyDispellableDebuffs = GetCVar( 'raidFramesDisplayOnlyDispellableDebuffs' ),
                raidFramesPosition = GetCVar( 'raidFramesPosition' ),
                useCompactPartyFrames = GetCVar( 'useCompactPartyFrames' ),
            };
            for i,v in pairs( Defaults ) do
                Defaults[ string.lower( i ) ] = v;
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
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( 'jRaid' ),{
                type = 'group',
                name = 'jRaid',
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( 'jRaid' ),'jRaid','jVars' );
            self.Config.Name = 'jRaid';
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
            RestartGx();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.RAID.Init = function( self )
            local RegisteredVars = {
                RAIDfarclip = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1300,
                            Description = 'High',
                        },
                    },
                    Step = 100,
                },
                raidFramesDisplayClassColor = {
                    Type = 'Toggle',
                },
                raidFramesDisplayOnlyDispellableDebuffs = {
                    Type = 'Toggle',
                },
                raidFramesHealthText = {
                    Type = 'Select',
                    KeyPairs = {
                        Option1 = {
                            Value = 'none',
                            Description = 'None',
                        },
                        Option2 = {
                            Value = 'health',
                            Description = 'Health Remaining',
                        },
                        Option3 = {
                            Value = 'losthealth',
                            Description = 'Health Lost (ie Deficit)',
                        },
                        Option4 = {
                            Value = 'perc',
                            Description = 'Health Percentage',
                        },
                    },
                },
                raidFramesHeight = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 75,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 25,
                },
                raidFramesWidth = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 75,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 25,
                },
                raidGraphicsEnvironmentDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 1,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                raidGraphicsGroundClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 1,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                raidGraphicsLiquidDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 1,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                raidGraphicsParticleDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 10,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 100,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                },
                raidGraphicsShadowQuality = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 5,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                raidGraphicsSSAO = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 4,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                RAIDgraphicsQuality = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 1,
                            Description = 'Low',
                        },
                        Option2 = {
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
                        Option1 = {
                            Value = 'role',
                            Description = 'Role',
                        },
                        Option2 = {
                            Value = 'group',
                            Description = 'Group',
                        },
                    },
                },
                RAIDweatherDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                },
                useCompactPartyFrames = {
                    Type = 'Toggle',
                },
            };
            self.RegisteredVars = {};
            for VarName,VarData in pairs( RegisteredVars ) do
                if( Addon.VARS.Dictionary[ string.lower( VarName ) ] ) then
                    VarData.Description = Addon.VARS.Dictionary[ string.lower( VarName ) ].Description;
                end
                self.RegisteredVars[ string.lower( VarName ) ] = VarData;
            end
            self.db = LibStub( 'AceDB-3.0' ):New( 'jRaid',{ profile = self:GetDefaults() },true );
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
            self.ScrollChild = Addon.GRID:RegisterGrid( self.Config,self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox','jRaidFilter',self.ScrollChild,'SearchBoxTemplate' );
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