local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jMap = jVars:NewModule( 'jMap' );
jMap.Explode = Addon.Explode;
jMap.Implode = Addon.Implode;
jMap.Dump = Addon.Dump;
jMap.IsClassic = Addon.IsClassic;

--
--  Get module defaults
--
--  @return table
function jMap:GetDefaults()
    return {
        CVars = {
            MapFade = GetCVar( 'MapFade' ),
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jMap:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jMap:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jMap:GetSettings( )
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
            MapFade = {
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
                name = 'MapFade',
                desc = 'Disabling this causes the map to stay faded until it is focused',
                arg = 'MapFade',
            },
        }
    };
end

--
--  Module initialize
--
--  @return void
function jMap:OnInitialize()
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
function jMap:OnEnable()
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
        jMap.db:ResetDB();
    end
end