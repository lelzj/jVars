local _, Addon = ...;

local jVars = LibStub( 'AceAddon-3.0' ):NewAddon( 'jVars' );
jVars.Explode = Addon.Explode;
jVars.Implode = Addon.Implode;
jVars.Dump = Addon.Dump;
jVars.IsClassic = Addon.IsClassic;
jVars.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jVars:GetDefaults()
    return {
        Verbose = true,
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jVars:SetValue( Index,Value )
    if( self.persistence[ Index ] ~= nil ) then
        self.persistence[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jVars:GetValue( Index )
    if( self.persistence[ Index ] ~= nil ) then
        return self.persistence[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jVars:GetSettings()
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
            intro = {
                order = 1,
                type = 'description',
                name = "CVars, otherwise known as Console Variables, control many aspects of the game. Although documentation exists for them, there has never been an editor that attempts to cut out the guess work for their appropriate setting values",
            },
            Verbose = {
                type = 'toggle',
                name = 'Verbose',
                desc = 'Enable/Disable verbosity',
                arg = 'Verbose',
            },
        },
    };
end

--
--  Module initialize
--
--  @return void
function jVars:OnInitialize()
    -- Database
    self.db = LibStub( 'AceDB-3.0' ):New( self:GetName(),{ profile = self:GetDefaults() },true );
    if( not self.db ) then
        return;
    end
    --Addon.db:ResetDB();
    self.persistence = self.db.profile;
    if( not self.persistence ) then
        return;
    end
end

--
--  Module enable
--
--  @return void
function jVars:OnEnable()
    if( not self.persistence ) then
        return;
    end
    -- Config
    LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( self:GetName() ),self:GetSettings() );
    self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( self:GetName() ),self:GetName() );
    -- ok handler
    self.Config.okay = function( self )
        RestartGx();
    end
    -- default handler
    self.Config.default = function( self )
        self.db:ResetDB();
    end
end