local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jChat = jVars:NewModule( 'jChat' );
jChat.Explode = Addon.Explode;
jChat.Implode = Addon.Implode;
jChat.Dump = Addon.Dump;
jChat.IsClassic = Addon.IsClassic;
jChat.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jChat:GetDefaults()
    return {
        CVars = {
            colorChatNamesByClass = GetCVar( 'colorChatNamesByClass' ),
            chatStyle = GetCVar( 'chatStyle' ),
            guildMemberNotify = GetCVar( 'guildMemberNotify' ),
            profanityfilter = GetCVar( 'profanityfilter' ),
            showToastBroadcast = GetCVar( 'showToastBroadcast' ),
            showToastFriendRequest = GetCVar( 'showToastFriendRequest' ),
            showToastWindow = GetCVar( 'showToastWindow' ),
            showToastOffline = GetCVar( 'showToastOffline' ),
            showToastOnline = GetCVar( 'showToastOnline' ),
            spamFilter = GetCVar( 'spamFilter' ),
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jChat:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jChat:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jChat:GetSettings()
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
            colorChatNamesByClass = {
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
                        if( Addon:Int2Bool( Value ) ) then
                            SetCVar( 'chatClassColorOverride',0 );
                            SetCVar( 'colorChatNamesByClass',1 );
                        else
                            SetCVar( 'chatClassColorOverride',1 );
                            SetCVar( 'colorChatNamesByClass',0 );
                        end
                    end
                end,
                name = 'colorChatNamesByClass',
                desc = 'Enable/disable class specific color coding names in chat',
                arg = 'colorChatNamesByClass',
            },
            guildMemberNotify = {
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
                name = 'guildMemberNotify',
                desc = 'Receive notification when guild members log on/off',
                arg = 'guildMemberNotify',
            },
            profanityfilter = {
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
                name = 'profanityfilter',
                desc = 'Enable/disable display of profanity while in joined channels',
                arg = 'profanityfilter',
            },
            showToastBroadcast = {
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
                name = 'showToastBroadcast',
                desc = 'Enable/disable display of Battle.net message for broadcasts',
                arg = 'showToastBroadcast',
            },
            showToastFriendRequest = {
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
                name = 'showToastFriendRequest',
                desc = 'Enable/disable display of Battle.net message for friend requests',
                arg = 'showToastFriendRequest',
            },
            showToastWindow = {
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
                name = 'showToastWindow',
                desc = 'Enable/disable display of Battle.net system messages in a toast window',
                arg = 'showToastWindow',
            },
            showToastOffline = {
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
                name = 'showToastOffline',
                desc = 'Enable/disable display of Battle.net message for friend going offline',
                arg = 'showToastOffline',
            },
            showToastOnline = {
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
                name = 'showToastOnline',
                desc = 'Enable/disable display of Battle.net message for friend coming online',
                arg = 'showToastOnline',
            },
            spamFilter = {
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
                name = 'spamFilter',
                desc = 'Whether to enable spam filtering',
                arg = 'spamFilter',
            },
        }
    };
end

--
--  Module initialize
--
--  @return void
function jChat:OnInitialize()
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
function jChat:OnEnable()
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
        jChat.db:ResetDB();
    end
end