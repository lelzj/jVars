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
    if( self.persistence[ Index ] ~= nil ) then
        self.persistence[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jFrame:GetValue( Index )
    if( self.persistence[ Index ] ~= nil ) then
        return self.persistence[ Index ];
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
                        return self.persistence.CVars[ Info.arg ];
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
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
                        return self.persistence.CVars[ Info.arg ];
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
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
                        return self.persistence.CVars[ Info.arg ];
                    end
                end,
                set = function( Info,Value )
                    if( self.persistence.CVars[ Info.arg ] ~= nil ) then
                        self.persistence.CVars[ Info.arg ] = Value;
                        SetCVar( Info.arg,Value );
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
        self.db:ResetDB();
    end
end