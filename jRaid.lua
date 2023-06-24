local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jRaid = jVars:NewModule( 'jRaid' );
jRaid.Explode = Addon.Explode;
jRaid.Implode = Addon.Implode;
jRaid.Dump = Addon.Dump;
jRaid.IsClassic = Addon.IsClassic;
jRaid.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jRaid:GetDefaults()
    return {
        CVars = {
            raidGraphicsEnvironmentDetail = GetCVar( 'raidGraphicsEnvironmentDetail' ),
            raidGraphicsGroundClutter = GetCVar( 'raidGraphicsGroundClutter' ),
            raidGraphicsLiquidDetail = GetCVar( 'raidGraphicsLiquidDetail' ),
            raidGraphicsParticleDensity = GetCVar( 'raidGraphicsParticleDensity' ),
            RAIDgraphicsQuality = GetCVar( 'RAIDgraphicsQuality' ),
            raidGraphicsShadowQuality = GetCVar( 'raidGraphicsShadowQuality' ),
            RAIDweatherDensity = GetCVar( 'RAIDweatherDensity' ),
            raidGraphicsSSAO = GetCVar( 'raidGraphicsSSAO' ),
            RAIDfarclip = GetCVar( 'RAIDfarclip' ),
            raidFramesWidth = GetCVar( 'raidFramesWidth' ),
            raidFramesHeight = GetCVar( 'raidFramesHeight' ),
            raidFramesHealthText = GetCVar( 'raidFramesHealthText' ),
            raidOptionKeepGroupsTogether = GetCVar( 'raidOptionKeepGroupsTogether' ),
            raidOptionDisplayPets = GetCVar( 'raidOptionDisplayPets' ),
            raidOptionShowBorders = GetCVar( 'raidOptionShowBorders' ),
            raidOptionSortMode = GetCVar( 'raidOptionSortMode' ),
            raidOptionIsShown = GetCVar( 'raidOptionIsShown' ),
            raidFramesDisplayClassColor = GetCVar( 'raidFramesDisplayClassColor' ),
            raidFramesDisplayOnlyDispellableDebuffs = GetCVar( 'raidFramesDisplayOnlyDispellableDebuffs' ),
            raidFramesPosition = GetCVar( 'raidFramesPosition' ),
            useCompactPartyFrames = GetCVar( 'useCompactPartyFrames' ),
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jRaid:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jRaid:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jRaid:GetSettings()
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
            RAIDfarclip = {
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
                name = 'RAIDfarclip',
                desc = 'This CVar controls the view distance of the raid environment',
                min = 0, max = 1300, step = 10,
                arg = 'RAIDfarclip',
            },
            raidFramesDisplayClassColor = {
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
                name = 'raidFramesDisplayClassColor',
                desc = 'Colors raid frames with the class color',
                arg = 'raidFramesDisplayClassColor',
            },
            raidFramesDisplayOnlyDispellableDebuffs = {
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
                name = 'raidFramesDisplayOnlyDispellableDebuffs',
                desc = 'Whether to display only dispellable debuffs on Raid Frames',
                arg = 'raidFramesDisplayOnlyDispellableDebuffs',
            },
            raidFramesHealthText = {
                type = 'select',
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
                style = 'dropdown',
                name = 'raidFramesHealthText',
                desc = 'How to display health text on the raid frames',
                values = {
                    none = 'none',
                    health = 'Health Remaining',
                    losthealth = 'Health Lost (ie Deficit)',
                    perc = 'Health Percentage',
                },
                arg = 'raidFramesHealthText',
            },
            raidFramesHeight = {
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
                name = 'raidFramesHeight',
                desc = 'The height of the individual raid frames',
                min = 75, max = 200, step = 25,
                arg = 'raidFramesHeight',
            },
            raidFramesPosition = {
                type = 'input',
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
                name = 'raidFramesPosition',
                desc = 'This CVar saves where the raid frames should be placed',
                arg = 'raidFramesPosition',
                disabled = true,
            },
            raidFramesWidth = {
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
                name = 'raidFramesWidth',
                desc = 'The width of the individual raid frames',
                min = 75, max = 200, step = 25,
                arg = 'raidFramesWidth',
            },
            raidGraphicsEnvironmentDetail = {
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
                name = 'raidGraphicsEnvironmentDetail',
                desc = 'UI value of the graphics setting',
                min = 1, max = 7, step = 1,
                arg = 'raidGraphicsEnvironmentDetail',
            },
            raidGraphicsGroundClutter = {
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
                name = 'raidGraphicsGroundClutter',
                desc = 'UI value of the graphics setting',
                min = 1, max = 7, step = 1,
                arg = 'raidGraphicsGroundClutter',
            },
            raidGraphicsLiquidDetail = {
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
                name = 'raidGraphicsLiquidDetail',
                desc = 'UI value of the graphics setting',
                min = 1, max = 7, step = 1,
                arg = 'raidGraphicsLiquidDetail',
            },
            raidGraphicsParticleDensity = {
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
                name = 'raidGraphicsParticleDensity',
                desc = 'UI value of the graphics setting',
                min = 10, max = 100, step = 10,
                arg = 'raidGraphicsParticleDensity',
            },
            raidGraphicsShadowQuality = {
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
                name = 'raidGraphicsShadowQuality',
                desc = 'Graphics quality of shadows',
                min = 0, max = 5, step = 1,
                arg = 'raidGraphicsShadowQuality',
            },
            raidGraphicsSSAO = {
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
                name = 'raidGraphicsSSAO',
                desc = 'Controls the rendering quality of the advanced lighting effects in raids. Decreasing this may greatly improve performance',
                min = 0, max = 4, step = 1,
                arg = 'raidGraphicsSSAO',
            },
            RAIDgraphicsQuality = {
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
                name = 'RAIDgraphicsQuality',
                desc = 'UI value of the graphics setting',
                min = 1, max = 10, step = 1,
                arg = 'RAIDgraphicsQuality',
            },
            raidOptionDisplayPets = {
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
                name = 'raidOptionDisplayPets',
                desc = 'Toggles the option for displaying hunter and warlock pets in raid frames',
                arg = 'raidOptionDisplayPets',
            },
            raidOptionIsShown = {
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
                name = 'raidOptionIsShown',
                desc = 'Whether the Raid Frames are shown while in a raid',
                arg = 'raidOptionIsShown',
            },
            raidOptionKeepGroupsTogether = {
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
                name = 'raidOptionKeepGroupsTogether',
                desc = 'The way to group raid frames',
                arg = 'raidOptionKeepGroupsTogether',
            },
            raidOptionShowBorders = {
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
                name = 'raidOptionShowBorders',
                desc = 'Displays borders around the raid frames',
                arg = 'raidOptionShowBorders',
            },
            raidOptionSortMode = {
                type = 'select',
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
                style = 'dropdown',
                name = 'raidOptionSortMode',
                desc = 'The way to sort raid frames',
                values = {
                    role = 'Role',
                    group = 'Group',
                },
                arg = 'raidOptionSortMode',
            },
            RAIDweatherDensity = {
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
                name = 'RAIDweatherDensity',
                desc = 'Intensity of raid weather',
                min = 0, max = 3, step = 1,
                arg = 'RAIDweatherDensity',
            },
            useCompactPartyFrames = {
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
                name = 'useCompactPartyFrames',
                desc = 'This CVar controls the type of party frames used in-game',
                arg = 'useCompactPartyFrames',
            },
        },
    };
end

--
--  Module initialize
--
--  @return void
function jRaid:OnInitialize()
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
function jRaid:OnEnable()
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
        jRaid.db:ResetDB();
    end
end