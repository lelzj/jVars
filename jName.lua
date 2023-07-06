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
            local Defaults = {
                findYourselfMode = GetCVar( 'findYourselfMode' ),
                findyourselfanywhere = GetCVar( 'findyourselfanywhere' ),
                NameplatePersonalShowAlways = GetCVar( 'NameplatePersonalShowAlways' ),
                nameplateShowEnemyPets = GetCVar( 'nameplateShowEnemyPets' ),
                nameplateShowFriends = GetCVar( 'nameplateShowFriends' ),
                nameplateShowFriendlyGuardians = GetCVar( 'nameplateShowFriendlyGuardians' ),
                nameplateTargetRadialPosition = GetCVar( 'nameplateTargetRadialPosition' ),
                countdownForCooldowns = GetCVar( 'countdownForCooldowns' ),
                NameplatePersonalShowInCombat = GetCVar( 'NameplatePersonalShowInCombat' ),
                NameplatePersonalShowWithTarget = GetCVar( 'NameplatePersonalShowWithTarget' ),
                nameplateShowEnemies = GetCVar( 'nameplateShowEnemies' ),
                nameplateShowEnemyGuardians = GetCVar( 'nameplateShowEnemyGuardians' ),
                nameplateShowEnemyTotems = GetCVar( 'nameplateShowEnemyTotems' ),
                nameplateShowFriendlyNPCs = GetCVar( 'nameplateShowFriendlyNPCs' ),
                nameplateShowFriendlyTotems = GetCVar( 'nameplateShowFriendlyTotems' ),
                nameplateShowEnemyMinions = GetCVar( 'nameplateShowEnemyMinions' ),
                nameplateShowFriendlyPets = GetCVar( 'nameplateShowFriendlyPets' ),
                nameplateShowFriendlyMinions = GetCVar( 'nameplateShowFriendlyMinions' ),
                nameplateShowAll = GetCVar( 'nameplateShowAll' ),
                NameplatePersonalHideDelaySeconds = GetCVar( 'NameplatePersonalHideDelaySeconds' ),
                NameplatePersonalHideDelayAlpha = GetCVar( 'NameplatePersonalHideDelayAlpha' ),
                NamePlateVerticalScale = GetCVar( 'NamePlateVerticalScale' ),
                NamePlateHorizontalScale = GetCVar( 'NamePlateHorizontalScale' ),
                nameplateLargerScale = GetCVar( 'nameplateLargerScale' ),
                nameplateMaxAlpha = GetCVar( 'nameplateMaxAlpha' ),
                nameplateMaxDistance = GetCVar( 'nameplateMaxDistance' ),
                nameplateSelectedScale = GetCVar( 'nameplateSelectedScale' ),
                nameplateSelfScale = GetCVar( 'nameplateSelfScale' ),
                nameplateMinScaleDistance = GetCVar( 'nameplateMinScaleDistance' ),
                nameplateSelectedAlpha = GetCVar( 'nameplateSelectedAlpha' ),
                nameplateSelfAlpha = GetCVar( 'nameplateSelfAlpha' ),
                nameplateMaxScaleDistance = GetCVar( 'nameplateMaxScaleDistance' ),
                statusText = GetCVar( 'statusText' ),
                statusTextDisplay = GetCVar( 'statusTextDisplay' ),
                predictedHealth = GetCVar( 'predictedHealth' ),
                UnitNameGuildTitle = GetCVar( 'UnitNameGuildTitle' ),
                ShowClassColorInNameplate = GetCVar( 'ShowClassColorInNameplate' ),
                nameplateNotSelectedAlpha = GetCVar( 'nameplateNotSelectedAlpha' ) or 0,
                nameplateRemovalAnimation = GetCVar( 'nameplateRemovalAnimation' ),
                showtargetoftarget = GetCVar( 'showtargetoftarget' ),
                nameplateMinAlphaDistance = GetCVar( 'nameplateMinAlphaDistance' ),
                nameplateClassResourceTopInset = GetCVar( 'nameplateClassResourceTopInset' ),
                nameplateOtherBottomInset = GetCVar( 'nameplateOtherBottomInset' ),
                ShowClassColorInFriendlyNameplate = GetCVar( 'ShowClassColorInFriendlyNameplate' ),
                nameplateMotionSpeed = GetCVar( 'nameplateMotionSpeed' ),
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
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( 'jName' ),{
                type = 'group',
                name = 'jName',
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( 'jName' ),'jName','jVars' );
            self.Config.Name = 'jName';
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
                        Option1 = {
                            Value = 0,
                            Description = 'Circle',
                        },
                        Option2 = {
                            Value = 1,
                            Description = 'Circle & Outline',
                        },
                        Option3 = {
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
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                NamePlateHorizontalScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateLargerScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateMaxScaleDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 20,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },

                nameplateMotionSpeed = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },


                NamePlateVerticalScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                NameplatePersonalHideDelaySeconds = {
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
                nameplateSelectedScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateNotSelectedAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateMaxDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 20,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },
                nameplateSelfScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
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
                        Option1 = {
                            Value = 0,
                            Description = 'None',
                        },
                        Option2 = {
                            Value = 1,
                            Description = 'Target Only',
                        },
                        Option3 = {
                            Value = 3,
                            Description = 'All In Combat',
                        },
                    },
                },
                NameplatePersonalShowWithTarget = {
                    Type = 'Select',
                    KeyPairs = {
                        Option1 = {
                            Value = 0,
                            Description = 'None',
                        },
                        Option2 = {
                            Value = 1,
                            Description = 'Hostile Target',
                        },
                        Option3 = {
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
                        Option1 = {
                            Value = 'NONE',
                            Description = 'None',
                        },
                        Option2 = {
                            Value = 'NUMERIC',
                            Description = 'Numeric',
                        },
                        Option3 = {
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
                --[[
                nameplateSelfAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateOtherBottomInset = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateMinAlphaDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 20,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                },
                nameplateMinScaleDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 20,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                }
                nameplateSelfAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                nameplateMaxAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                NameplatePersonalHideDelayAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Option1 = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        Option2 = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                },
                ]]
            };
            self.RegisteredVars = {};
            for VarName,VarData in pairs( RegisteredVars ) do
                if( Addon.VARS.Dictionary[ string.lower( VarName ) ] ) then
                    VarData.Description = Addon.VARS.Dictionary[ string.lower( VarName ) ].Description;
                end
                self.RegisteredVars[ string.lower( VarName ) ] = VarData;
            end
            self.db = LibStub( 'AceDB-3.0' ):New( 'jName',{ profile = self:GetDefaults() },true );
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
            self.ScrollChild = Addon.GRID:RegisterGrid( self.Config,self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox','jNameChatFilter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
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