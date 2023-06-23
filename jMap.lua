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
    if( self.persistence[ Index ] ~= nil ) then
        self.persistence[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jMap:GetValue( Index )
    if( self.persistence[ Index ] ~= nil ) then
        return self.persistence[ Index ];
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
                        return self.persistence.CVars[ Info.arg ];
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
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
    -- Config
    LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( self:GetName() ),self:GetSettings() );
    self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( self:GetName() ),self:GetName(),'jVars' );
    -- ok handler
    self.Config.okay = function( self )
        RestartGx();
    end
    -- default handler
    self.Config.default = function( self )
        self.db:ResetDB();
    end
end