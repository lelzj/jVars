local _, Addon = ...;

Addon.SOUND = CreateFrame( 'Frame' );
Addon.SOUND:RegisterEvent( 'ADDON_LOADED' )
Addon.SOUND.FistColInset = 15;
Addon.SOUND.RegisteredFrames = {};
Addon.SOUND:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.SOUND.GetDefaults = function( self )
            local Defaults = {
                Sound_EnableErrorSpeech = GetCVar( 'Sound_EnableErrorSpeech' ),
                Sound_EnableMusic = GetCVar( 'Sound_EnableMusic' ),
                Sound_ZoneMusicNoDelay = GetCVar( 'Sound_ZoneMusicNoDelay' ),
                FootstepSounds = GetCVar( 'FootstepSounds' ),
                Sound_EnableReverb = GetCVar( 'Sound_EnableReverb' ),
                Sound_MasterVolume = GetCVar( 'Sound_MasterVolume' ),
                Sound_MusicVolume = GetCVar( 'Sound_MusicVolume' ),
                Sound_AmbienceVolume = GetCVar( 'Sound_AmbienceVolume' ),
                Sound_DialogVolume = GetCVar( 'Sound_DialogVolume' ),
                Sound_SFXVolume = GetCVar( 'Sound_SFXVolume' ),
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
        Addon.SOUND.SetValue = function( self,Index,Value )
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
        Addon.SOUND.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.SOUND.FrameRegister = function( self,FrameData )
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

        Addon.SOUND.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.SOUND.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.SOUND.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.SOUND.Filter = function( self,SearchQuery )
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
        Addon.SOUND.CreateFrames = function( self )
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( 'jSound' ),{
                type = 'group',
                name = 'jSound',
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( 'jSound' ),'jSound','jVars' );
            self.Config.Name = 'jSound';
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.SOUND.Refresh = function( self )
            if( not Addon.SOUND.persistence ) then
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
        Addon.SOUND.ResetDb = function( self )
            self.db:ResetDB();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.SOUND.Init = function( self )  
            local RegisteredVars = {
                FootstepSounds = {
                    Type = 'Toggle',
                },
                Sound_EnableErrorSpeech = {
                    Type = 'Toggle',
                },
                Sound_EnableMusic = {
                    Type = 'Toggle',
                },
                Sound_EnableReverb = {
                    Type = 'Toggle',
                },
                Sound_ZoneMusicNoDelay = {
                    Type = 'Toggle',
                },
                Sound_AmbienceVolume = {
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
                Sound_DialogVolume = {
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
                Sound_MasterVolume = {
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
                Sound_MusicVolume = {
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
                Sound_SFXVolume = {
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
            };
            self.RegisteredVars = {};
            for VarName,VarData in pairs( RegisteredVars ) do
                if( Addon.VARS.Dictionary[ string.lower( VarName ) ] ) then
                    VarData.Description = Addon.VARS.Dictionary[ string.lower( VarName ) ].Description;
                end
                self.RegisteredVars[ string.lower( VarName ) ] = VarData;
            end
            self.db = LibStub( 'AceDB-3.0' ):New( 'jSound',{ profile = self:GetDefaults() },true );
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
        Addon.SOUND.Run = function( self )
            self.ScrollChild = Addon.GRID:RegisterGrid( self.Config,self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox','jSoundFilter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.SOUND:ShowAll();
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
                Addon.SOUND:ShowAll();
                Addon.SOUND:Filter( self:GetText(),Addon.SOUND );
            end );
        end

        Addon.SOUND:Init();
        Addon.SOUND:CreateFrames();
        Addon.SOUND:Refresh();
        Addon.SOUND:Run();
        Addon.SOUND:UnregisterEvent( 'ADDON_LOADED' );
    end
end );