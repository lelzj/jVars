local _, Addon = ...;

Addon.NAME = CreateFrame( 'Frame' );
Addon.NAME:RegisterEvent( 'ADDON_LOADED' )
Addon.NAME.FistColInset = 15;
Addon.NAME.RegisteredFrames = {};
Addon.NAME:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.NAME.GetDefaults = function( self )
            local Defaults = {};
            for VarName,_ in pairs( self.RegisteredVars ) do
                Defaults[ string.lower( VarName ) ] = GetCVar( VarName );
                if( Defaults[ string.lower( VarName ) ] == nil ) then
                    self.RegisteredVars[ string.lower( VarName ) ].Flagged = true;
                    Defaults[ string.lower( VarName ) ] = 0;
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
        Addon.NAME.SetValue = function( self,Index,Value )
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
        Addon.NAME.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.NAME.FrameRegister = function( self,FrameData )
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

        Addon.NAME.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.NAME.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.NAME.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.NAME.Filter = function( self,SearchQuery )
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
        Addon.NAME.CreateFrames = function( self )
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
        Addon.NAME.Refresh = function( self )
            if( not Addon.NAME.persistence ) then
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
        Addon.NAME.ResetDb = function( self )
            self.db:ResetDB();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.NAME.Init = function( self )
            self.Name = 'jName';
            local RegisteredVars = {
                countdownForCooldowns = {
                    Type = 'Toggle',
                },
                findyourselfanywhere = {
                    Type = 'Toggle',
                },
                findYourselfMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Circle',
                        },
                        {
                            Value = 1,
                            Description = 'Circle & Outline',
                        },
                        {
                            Value = 2,
                            Description = 'Outline',
                        },
                    },
                },
                nameplateRemovalAnimation = {
                    Type = 'Toggle',
                },
                nameplateClassResourceTopInset = {
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
                NamePlateHorizontalScale = {
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
                nameplateLargerScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateMaxScaleDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 20,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },

                nameplateMotionSpeed = {
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


                NamePlateVerticalScale = {
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
                NameplatePersonalHideDelaySeconds = {
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
                nameplateSelectedScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateNotSelectedAlpha = {
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
                nameplateMaxDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 20,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },
                nameplateSelfScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                NameplatePersonalShowAlways = {
                    Type = 'Toggle',
                },
                NameplatePersonalShowInCombat = {
                    Type = 'Toggle',
                },
                nameplateShowAll = {
                    Type = 'Toggle',
                },
                nameplateShowEnemies = {
                    Type = 'Toggle',
                },
                nameplateShowEnemyGuardians = {
                    Type = 'Toggle',
                },
                nameplateShowEnemyMinions = {
                    Type = 'Toggle',
                },
                nameplateShowEnemyPets = {
                    Type = 'Toggle',
                },
                nameplateShowEnemyTotems = {
                    Type = 'Toggle',
                },
                nameplateShowFriends ={
                    Type = 'Toggle',
                },
                nameplateShowFriendlyGuardians = {
                    Type = 'Toggle',
                },
                nameplateTargetRadialPosition = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'None',
                        },
                        {
                            Value = 1,
                            Description = 'Target Only',
                        },
                        {
                            Value = 3,
                            Description = 'All In Combat',
                        },
                    },
                },
                NameplatePersonalShowWithTarget = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'None',
                        },
                        {
                            Value = 1,
                            Description = 'Hostile Target',
                        },
                        {
                            Value = 2,
                            Description = 'Any Target',
                        },
                    },
                },
                nameplateShowFriendlyNPCs = {
                    Type = 'Toggle',
                },
                nameplateShowFriendlyTotems = {
                    Type = 'Toggle',
                },
                nameplateShowFriendlyPets = {
                    Type = 'Toggle',
                },
                nameplateShowFriendlyMinions = {
                    Type = 'Toggle',
                },
                statusText = {
                    Type = 'Toggle',
                },
                statusTextDisplay = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'NONE',
                            Description = 'None',
                        },
                        {
                            Value = 'NUMERIC',
                            Description = 'Numeric',
                        },
                        {
                            Value = 'PERCENT',
                            Description = 'Percent',
                        },
                    },
                },
                predictedHealth = {
                    Type = 'Toggle',
                },
                UnitNameGuildTitle = {
                    Type = 'Toggle',
                },
                ShowClassColorInNameplate = {
                    Type = 'Toggle',
                },
                showtargetoftarget = {
                    Type = 'Toggle',
                },
                ShowClassColorInFriendlyNameplate = {
                    Type = 'Toggle',
                },
                clampTargetNameplateToScreen = {
                    Type = 'Toggle',
                },
                ColorNameplateNameBySelection = {
                    Type = 'Toggle',
                },
                fullSizeFocusFrame = {
                    Type = 'Toggle',
                },
                nameplateSelfAlpha = {
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
                nameplateOtherBottomInset = {
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
                nameplateMinAlphaDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 20,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },
                nameplateMinScaleDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 20,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },
                nameplateSelfAlpha = {
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
                nameplateMaxAlpha = {
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
                NameplatePersonalHideDelayAlpha = {
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
                showArenaEnemyCastbar = {
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
        Addon.NAME.Run = function( self )
            Addon.GRID:RegisterGrid( self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox',self.Name..'ChatFilter',self.Config,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.Config,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.NAME:ShowAll();
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
                Addon.NAME:ShowAll();
                Addon.NAME:Filter( self:GetText(),Addon.NAME );
            end );
        end

        Addon.NAME:Init();
        Addon.NAME:CreateFrames();
        Addon.NAME:Refresh();
        Addon.NAME:Run();
        Addon.NAME:UnregisterEvent( 'ADDON_LOADED' );
    end
end );