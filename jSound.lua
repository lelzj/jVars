local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jSound = jVars:NewModule( 'jSound' );
jSound.Explode = Addon.Explode;
jSound.Implode = Addon.Implode;
jSound.Dump = Addon.Dump;
jSound.IsClassic = Addon.IsClassic;
jSound.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jSound:GetDefaults()
    return {
        CVars = {
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
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jSound:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jSound:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jSound:GetSettings()
    if( not self.persistence ) then
        return;
    end
    return {
        type = 'group',
        get = function( Info )
            if( self.persistence[ Info.arg ] ~= nil ) then
                return self.persistence[ Info.arg ];
            end
        end,
        set = function( Info,Value )
            if( self.persistence[ Info.arg ] ~= nil ) then
                self.persistence[ Info.arg ] = Value;
            end
        end,
        name = self:GetName()..' Settings',
        args = {
            FootstepSounds = {
                type = 'toggle',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return Addon:Int2Bool( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Addon:BoolToInt( Value );
                        SetCVar( Info.arg,Addon:BoolToInt( Value ) );
                    end
                end,
                name = 'FootstepSounds',
                desc = 'Play footstep sounds',
                arg = 'FootstepSounds',
            },
            Sound_EnableErrorSpeech = {
                type = 'toggle',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return self.persistence.CVars[ Info.arg ];
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
                    end
                end,
                name = 'Sound_EnableErrorSpeech',
                desc = 'Error speech',
                arg = 'Sound_EnableErrorSpeech',
            },
            Sound_EnableMusic = {
                type = 'toggle',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return Addon:Int2Bool( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Addon:BoolToInt( Value );
                        SetCVar( Info.arg,Addon:BoolToInt( Value ) );
                    end
                end,
                name = 'Sound_EnableMusic',
                desc = 'Enables music',
                arg = 'Sound_EnableMusic',
            },
            Sound_EnableReverb = {
                type = 'toggle',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return Addon:Int2Bool( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Addon:BoolToInt( Value );
                        SetCVar( Info.arg,Addon:BoolToInt( Value ) );
                    end
                end,
                name = 'Sound_EnableReverb',
                desc = 'Enables sound reverb',
                arg = 'Sound_EnableReverb',
            },
            Sound_AmbienceVolume = {
                type = 'range',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return tonumber( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
                    end
                end,
                name = 'Sound_AmbienceVolume',
                desc = 'Ambience volume',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'Sound_AmbienceVolume',
            },
            Sound_DialogVolume = {
                type = 'range',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return tonumber( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
                    end
                end,
                name = 'Sound_DialogVolume',
                desc = 'Dialog volume',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'Sound_DialogVolume',
            },
            Sound_MasterVolume = {
                type = 'range',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return tonumber( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
                    end
                end,
                name = 'Sound_MasterVolume',
                desc = 'Master volume',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'Sound_MasterVolume',
            },
            Sound_MusicVolume = {
                type = 'range',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return tonumber( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
                    end
                end,
                name = 'Sound_MusicVolume',
                desc = 'Music volume',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'Sound_MusicVolume',
            },
            Sound_SFXVolume = {
                type = 'range',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return tonumber( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
                    end
                end,
                name = 'Sound_SFXVolume',
                desc = 'Effects volume',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'Sound_SFXVolume',
            },
            Sound_ZoneMusicNoDelay = {
                type = 'toggle',
                get = function( Info )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        return Addon:Int2Bool( self.persistence.CVars[ Info.arg ] );
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Addon:BoolToInt( Value );
                        SetCVar( Info.arg,Addon:BoolToInt( Value ) );
                    end
                end,
                name = 'Sound_ZoneMusicNoDelay',
                desc = 'If enabled, music starts immediately upon entering a zone and continuously plays with no breaks',
                arg = 'Sound_ZoneMusicNoDelay',
            },
        },
    };
end

--
--  Module initialize
--
--  @return void
function jSound:OnInitialize()
    -- Database
    self.db = LibStub( 'AceDB-3.0' ):New( self:GetName(),{ profile = self:GetDefaults() },true );
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
--  Module enable
--
--  @return void
function jSound:OnEnable()
    if( not self.persistence ) then
        return;
    end
    -- Check external updates
    -- Bug found in wow-classic-era-source/Interface/FrameXML/OptionsPanelTemplates.lua
    -- ^ BlizzardOptionsPanel_SetCVarSafe() being called by blizz on login, forcing values to be incorrectly updated
    -- ^^ As such, we will have to forcefully override those dumb updates they are making
    for CVar,Value in pairs( self.persistence.CVars ) do
        SetCVar( CVar,Value );
    end
    -- Config
    LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( self:GetName() ),self:GetSettings() );
    self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( self:GetName() ),self:GetName(),'jVars' );
    -- ok handler
    self.Config.okay = function( self )
        for CVar,Value in pairs( self.persistence.CVars ) do
            SetCVar( CVar,Value );
        end 
        RestartGx();
    end
    -- default handler
    self.Config.default = function( self )
        jSound.db:ResetDB();
    end
end