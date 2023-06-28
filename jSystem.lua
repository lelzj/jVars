local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jSystem = jVars:NewModule( 'jSystem' );
jSystem.Explode = Addon.Explode;
jSystem.Implode = Addon.Implode;
jSystem.Dump = Addon.Dump;
jSystem.IsClassic = Addon.IsClassic;
jSystem.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jSystem:GetDefaults()
    return {
        CVars = {
            violencelevel = GetCVar( 'violencelevel' ),
            autoSelfCast = GetCVar( 'autoSelfCast' ),
            autoClearAFK = GetCVar( 'autoClearAFK' ),
            projectedtextures = GetCVar( 'projectedtextures' ),
            emphasizeMySpellEffects = GetCVar( 'emphasizeMySpellEffects' ),
            ffxDeath = GetCVar( 'ffxDeath' ),
            groundEffectDensity = GetCVar( 'groundEffectDensity' ),
            graphicsEnvironmentDetail = GetCVar( 'graphicsEnvironmentDetail' ),
            graphicsGroundClutter = GetCVar( 'graphicsGroundClutter' ),
            graphicsLiquidDetail = GetCVar( 'graphicsLiquidDetail' ),
            particleDensity = GetCVar( 'particleDensity' ),
            graphicsQuality = GetCVar( 'graphicsQuality' ),
            cameraDistanceMaxZoomFactor = GetCVar( 'cameraDistanceMaxZoomFactor' ),
            farclip = GetCVar( 'farclip' ),
            SpellQueueWindow = GetCVar( 'SpellQueueWindow' ),
            cameraSmoothStyle = GetCVar( 'cameraSmoothStyle' ),
            deselectOnClick = GetCVar( 'deselectOnClick' ),
            ffxGlow = GetCVar( 'ffxGlow' ),
            graphicsShadowQuality = GetCVar( 'graphicsShadowQuality' ),
            weatherDensity = GetCVar( 'weatherDensity' ),
            SkyCloudLOD = GetCVar( 'SkyCloudLOD' ),
            graphicsSSAO = GetCVar( 'graphicsSSAO' ),
            doNotFlashLowHealthWarning = GetCVar( 'doNotFlashLowHealthWarning' ),
            showTutorials = GetCVar( 'showTutorials' ),
            autoLootDefault = GetCVar( 'autoLootDefault' ),
            screenEdgeFlash = GetCVar( 'screenEdgeFlash' ),
            RenderScale = GetCVar( 'RenderScale' ),
            uiScale = GetCVar( 'uiScale' ),
            useUiScale = GetCVar( 'useUiScale' ),
            interactOnLeftClick = GetCVar( 'interactOnLeftClick' ),
            lootUnderMouse = GetCVar( 'raidFramesDisplayOnlyDispellableDebuffs' ),
            instantQuestText = GetCVar( 'instantQuestText' ),
            timeMgrUseLocalTime = GetCVar( 'timeMgrUseLocalTime' ),
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jSystem:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jSystem:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jSystem:GetSettings()
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
            autoClearAFK = {
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
                name = 'autoClearAFK',
                desc = 'Automatically clear AFK when moving or chatting',
                arg = 'autoClearAFK',
            },
            autoLootDefault = {
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
                name = 'autoLootDefault',
                desc = 'Automatically loot items when the loot window opens',
                arg = 'autoLootDefault',
            },
            autoSelfCast = {
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
                name = 'autoSelfCast',
                desc = 'Whether spells should automatically be cast on you if you don\'t have a valid target',
                arg = 'autoSelfCast',
            },
            cameraDistanceMaxZoomFactor = {
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
                name = 'cameraDistanceMaxZoomFactor',
                desc = 'The maximum zoom setting',
                min = 1.0, max = 3.4, step = 0.1,
                arg = 'cameraDistanceMaxZoomFactor',
            },
            cameraSmoothStyle = {
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
                name = 'cameraSmoothStyle',
                desc = 'Controls the automatic camera adjustment (following) style',
                values = {
                    [0] = 'Never adjust camera',
                    [1] = 'Adjust camera only horizontal when moving',
                    [2] = 'Always adjust camera',
                    [4] = 'Adjust camera only when moving',
                },
                arg = 'cameraSmoothStyle',
            },
            deselectOnClick = {
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
                name = 'deselectOnClick',
                desc = 'Clear the target when clicking on terrain',
                arg = 'deselectOnClick',
            },
            doNotFlashLowHealthWarning = {
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
                name = 'doNotFlashLowHealthWarning',
                desc = 'Do not flash your screen red when you are low on health',
                arg = 'doNotFlashLowHealthWarning',
            },
            emphasizeMySpellEffects = {
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
                name = 'emphasizeMySpellEffects',
                desc = 'Whether other player\'s spell impacts are toned down or not',
                arg = 'emphasizeMySpellEffects',
            },
            farclip = {
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
                name = 'farclip',
                desc = 'This CVar controls the view distance of the environment',
                min = 0, max = 1300, step = 10,
                arg = 'farclip',
            },
            ffxDeath = {
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
                name = 'ffxDeath',
                desc = 'Toggles Fullscreen Glow. The checkbox to toggle this was removed in 4.0.1. Disabling can improve fps',
                arg = 'ffxDeath',
            },
            ffxGlow = {
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
                name = 'ffxGlow',
                desc = 'Full screen death desat effect',
                arg = 'ffxGlow',
            },
            graphicsEnvironmentDetail = {
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
                name = 'graphicsEnvironmentDetail',
                desc = 'UI value of the graphics setting',
                min = 1, max = 7, step = 1,
                arg = 'graphicsEnvironmentDetail',
            },
            graphicsGroundClutter = {
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
                name = 'graphicsGroundClutter',
                desc = 'UI value of the graphics setting',
                min = 1, max = 7, step = 1,
                arg = 'graphicsGroundClutter',
            },
            graphicsLiquidDetail = {
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
                name = 'graphicsLiquidDetail',
                desc = 'UI value of the graphics setting',
                min = 1, max = 7, step = 1,
                arg = 'graphicsLiquidDetail',
            },
            graphicsShadowQuality = {
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
                name = 'graphicsShadowQuality',
                desc = 'Graphics quality of shadows',
                min = 0, max = 5, step = 1,
                arg = 'graphicsShadowQuality',
            },
            graphicsSSAO = {
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
                name = 'graphicsSSAO',
                desc = 'Controls the rendering quality of the advanced lighting effects in the world. Decreasing this may greatly improve performance',
                min = 0, max = 4, step = 1,
                arg = 'graphicsSSAO',
            },
            graphicsQuality = {
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
                name = 'graphicsQuality',
                desc = 'UI value of the graphics setting',
                min = 1, max = 10, step = 1,
                arg = 'graphicsQuality',
            },
            groundEffectDensity = {
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
                name = 'groundEffectDensity',
                desc = 'Ground effect density, Set the density of ground effects such as ferns, flowers, grass, and rocks',
                min = 16, max = 256, step = 16,
                arg = 'groundEffectDensity',
            },
            interactOnLeftClick = {
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
                name = 'interactOnLeftClick',
                desc = 'Test CVar for interacting with NPC\'s on left click',
                arg = 'interactOnLeftClick',
            },
            lootUnderMouse = {
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
                name = 'lootUnderMouse',
                desc = 'Whether the loot window should open under the mouse',
                arg = 'lootUnderMouse',
            },
            instantQuestText = {
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
                name = 'instantQuestText',
                desc = 'Whether to instantly show quest text instead of fading it in',
                arg = 'instantQuestText',
            },
            particleDensity = {
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
                name = 'particleDensity',
                desc = 'UI value of the graphics setting',
                min = 10, max = 100, step = 10,
                arg = 'particleDensity',
            },
            projectedtextures = {
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
                name = 'projectedtextures',
                desc = 'Projected Textures',
                arg = 'projectedtextures',
            },
            RenderScale = {
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
                name = 'RenderScale',
                desc = 'Render scale (for supersampling or undersampling)',
                min = 0, max = 3, step = 1,
                arg = 'RenderScale',
            },
            screenEdgeFlash = {
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
                name = 'screenEdgeFlash',
                desc = 'Whether to show a red flash while you are in combat with the world map up',
                arg = 'screenEdgeFlash',
            },
            showTutorials = {
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
                name = 'showTutorials',
                desc = 'Whether to show tutorials',
                arg = 'showTutorials',
            },
            SkyCloudLOD = {
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
                name = 'SkyCloudLOD',
                desc = 'Texture resolution for clouds',
                min = 0, max = 3, step = 1,
                arg = 'SkyCloudLOD',
            },
            SpellQueueWindow = {
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
                name = 'SpellQueueWindow',
                desc = 'Sets how early you can pre-activate/queue a spell/ability. (In Milliseconds)',
                min = 0, max = 400, step = 1,
                arg = 'SpellQueueWindow',
            },
            timeMgrUseLocalTime = {
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
                name = 'timeMgrUseLocalTime',
                desc = 'Toggles the use of either the realm time or your system time',
                arg = 'timeMgrUseLocalTime',
            },
            uiScale = {
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
                        if( Value > 0.0 ) then
                            self.persistence.CVars.useUiScale = 1;
                            SetCVar( 'useUiScale',1 );
                        else
                            SetCVar( 'useUiScale',0 );
                            self.persistence.CVars.useUiScale = 0;
                        end
                    end
                end,
                name = 'uiScale',
                desc = 'This variable is used to scale the User Interface',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'uiScale',
            },
            violencelevel = {
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
                name = 'violencelevel',
                desc = 'Sets the violence level of the game',
                min = 0, max = 5, step = 1,
                arg = 'violencelevel',
            },
            weatherDensity = {
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
                name = 'weatherDensity',
                desc = 'Intensity of world weather',
                min = 0, max = 3, step = 1,
                arg = 'weatherDensity',
            },
        },
    };
end

--
--  Module initialize
--
--  @return void
function jSystem:OnInitialize()
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
function jSystem:OnEnable()
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
        jSystem.db:ResetDB();
    end
end