local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jFrame = jVars:NewModule( 'jFrame' );
jFrame.Explode = Addon.Explode;
jFrame.Implode = Addon.Implode;
jFrame.Dump = Addon.Dump;
jFrame.IsClassic = Addon.IsClassic;
jFrame.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jFrame:GetDefaults()
    return {
        CVars = {
            alwaysShowActionBars = GetCVar( 'alwaysShowActionBars' ),
            LockActionBars = GetCVar( 'LockActionBars' ),
            multiBarRightVerticalLayout = GetCVar( 'multiBarRightVerticalLayout' ),
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jFrame:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jFrame:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jFrame:GetSettings()
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
            alwaysShowActionBars = {
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
                name = 'alwaysShowActionBars',
                desc = 'Whether to always show the action bar grid',
                arg = 'alwaysShowActionBars',
            },
            LockActionBars = {
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
                name = 'LockActionBars',
                desc = 'Whether the action bars should be locked, preventing changes',
                arg = 'LockActionBars',
            },
            multiBarRightVerticalLayout = {
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
                name = 'multiBarRightVerticalLayout',
                desc = 'Whether the action bars should show vertically instead of side by side',
                arg = 'multiBarRightVerticalLayout',
            },
        },
    };
end

--
--  Module refresh
--
--  @return void
function jFrame:Refresh()
    if( not self.persistence ) then
        return;
    end
end

--
--  Module initialize
--
--  @return void
function jFrame:OnInitialize()
    -- Database
    self.db = LibStub( 'AceDB-3.0' ):New( self:GetName(),{ profile = self:GetDefaults() },true );
    if( not self.db ) then
        return;
    end
    self.persistence = self.db.profile;
    if( not self.persistence ) then
        return;
    end
end

--
--  Module enable
--
--  @return void
function jFrame:OnEnable()
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
        jFrame.db:ResetDB();
    end
    -- Check external updates
    for CVar,Value in pairs( self.persistence.CVars ) do
        if( Value ~= GetCVar( CVar ) ) then
            self.persistence.CVars[ CVar ] = GetCVar( CVar );
        end
    end
    --[[
    local CheckData = {};
    for CVar,Value in pairs( self.persistence.CVars ) do
        CheckData[ CVar ] = {
            cvar_value = GetCVar( CVar ),
            db_value = Value,
        };
    end
    self:Dump( CheckData );
    ]]
end