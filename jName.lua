local _, Addon = ...;
local jVars = LibStub( 'AceAddon-3.0' ):GetAddon( 'jVars' );
local jName = jVars:NewModule( 'jName' );
jName.Explode = Addon.Explode;
jName.Implode = Addon.Implode;
jName.Dump = Addon.Dump;
jName.IsClassic = Addon.IsClassic;
jName.Minify = Addon.Minify;

--
--  Get module defaults
--
--  @return table
function jName:GetDefaults()
    return {
        CVars = {
            findYourselfMode = GetCVar( 'findYourselfMode' ),
            findyourselfanywhere = GetCVar( 'findyourselfanywhere' ),
            NameplatePersonalShowAlways = GetCVar( 'NameplatePersonalShowAlways' ),
            nameplateShowEnemyPets = GetCVar( 'nameplateShowEnemyPets' ),
            nameplateShowFriends = GetCVar( 'nameplateShowFriends' ),
            nameplateShowFriendlyGuardians = GetCVar( 'nameplateShowFriendlyGuardians' ),
            nameplateTargetRadialPosition = GetCVar( 'nameplateTargetRadialPosition' ),
            countdownForCooldowns = GetCVar( 'countdownForCooldowns' ),
            NameplatePersonalShowInCombat = GetCVar( 'NameplatePersonalShowInCombat' ),
            NameplatePersonalShowWithTarget = GetCVar( 'NameplatePersonalShowWithTarget' ),
            nameplateShowEnemies = GetCVar( 'nameplateShowEnemies' ),
            nameplateShowEnemyGuardians = GetCVar( 'nameplateShowEnemyGuardians' ),
            nameplateShowEnemyTotems = GetCVar( 'nameplateShowEnemyTotems' ),
            nameplateShowFriendlyNPCs = GetCVar( 'nameplateShowFriendlyNPCs' ),
            nameplateShowFriendlyTotems = GetCVar( 'nameplateShowFriendlyTotems' ),
            nameplateShowEnemyMinions = GetCVar( 'nameplateShowEnemyMinions' ),
            nameplateShowFriendlyPets = GetCVar( 'nameplateShowFriendlyPets' ),
            nameplateShowFriendlyMinions = GetCVar( 'nameplateShowFriendlyMinions' ),
            nameplateShowAll = GetCVar( 'nameplateShowAll' ),
            NameplatePersonalHideDelaySeconds = GetCVar( 'NameplatePersonalHideDelaySeconds' ),
            NameplatePersonalHideDelayAlpha = GetCVar( 'NameplatePersonalHideDelayAlpha' ),
            NamePlateVerticalScale = GetCVar( 'NamePlateVerticalScale' ),
            NamePlateHorizontalScale = GetCVar( 'NamePlateHorizontalScale' ),
            nameplateLargerScale = GetCVar( 'nameplateLargerScale' ),
            nameplateMaxAlpha = GetCVar( 'nameplateMaxAlpha' ),
            nameplateMaxDistance = GetCVar( 'nameplateMaxDistance' ),
            nameplateSelectedScale = GetCVar( 'nameplateSelectedScale' ),
            nameplateSelfScale = GetCVar( 'nameplateSelfScale' ),
            nameplateMinScaleDistance = GetCVar( 'nameplateMinScaleDistance' ),
            nameplateSelectedAlpha = GetCVar( 'nameplateSelectedAlpha' ),
            nameplateSelfAlpha = GetCVar( 'nameplateSelfAlpha' ),
            nameplateMotionSpeed = GetCVar( 'nameplateMotionSpeed' ),
            nameplateMaxScaleDistance = GetCVar( 'nameplateMaxScaleDistance' ),
            statusText = GetCVar( 'statusText' ),
            statusTextDisplay = GetCVar( 'statusTextDisplay' ),
            predictedHealth = GetCVar( 'predictedHealth' ),
            UnitNameGuildTitle = GetCVar( 'UnitNameGuildTitle' ),
            ShowClassColorInNameplate = GetCVar( 'ShowClassColorInNameplate' ),
            nameplateNotSelectedAlpha = GetCVar( 'nameplateNotSelectedAlpha' ) or 0,
            nameplateRemovalAnimation = GetCVar( 'nameplateRemovalAnimation' ),
            showtargetoftarget = GetCVar( 'showtargetoftarget' ),
            nameplateMinAlphaDistance = GetCVar( 'nameplateMinAlphaDistance' ),
            nameplateClassResourceTopInset = GetCVar( 'nameplateClassResourceTopInset' ),
            nameplateOtherBottomInset = GetCVar( 'nameplateOtherBottomInset' ),
            ShowClassColorInFriendlyNameplate = GetCVar( 'ShowClassColorInFriendlyNameplate' ),
        },
    };
end

--
--  Set module setting
--
--  @param  string  Index
--  @param  string  Value
--  @return void
function jName:SetValue( Index,Value )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        self.persistence.CVars[ Index ] = Value;
    end
end

--
--  Get module setting
--
--  @param  string  Index
--  @return mixed
function jName:GetValue( Index )
    if( self.persistence.CVars[ Index ] ~= nil ) then
        return self.persistence.CVars[ Index ];
    end
end

--
--  Get module settings
--
--  @return table
function jName:GetSettings()
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
            countdownForCooldowns = {
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
                name = 'countdownForCooldowns',
                desc = 'Whether to use number countdown instead of radial swipe for action button cooldowns or not',
                arg = 'countdownForCooldowns',
            },
            findyourselfanywhere = {
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
                name = 'findyourselfanywhere',
                desc = 'Always Highlight your character',
                arg = 'findyourselfanywhere',
            },
            --[[
            findYourselfMode = {
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
                name = 'findYourselfMode',
                desc = 'Graphics quality of shadows',
                values = {
                    0 = 'Circle',
                    1 = 'Circle & Outline',
                    2 = 'Outline',
                },
                arg = 'findYourselfMode',
            },
            ]]
            nameplateClassResourceTopInset = {
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
                name = 'nameplateClassResourceTopInset',
                desc = 'The inset from the top (in screen percent) that nameplates are clamped to when class resources are being displayed on them',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateClassResourceTopInset',
            },
            NamePlateHorizontalScale = {
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
                name = 'NamePlateHorizontalScale',
                desc = 'Applied to horizontal size of all nameplates',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'NamePlateHorizontalScale',
            },
            nameplateLargerScale = {
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
                name = 'nameplateLargerScale',
                desc = 'An additional scale modifier for important monsters',
                min = 0.0, max = 2.0, step = 0.1,
                arg = 'nameplateLargerScale',
            },
            nameplateOtherBottomInset = {
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
                name = 'nameplateOtherBottomInset',
                desc = 'The inset from the bottom (in screen percent) that the non-self nameplates are clamped to',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateOtherBottomInset',
            },
            nameplateMaxScaleDistance = {
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
                name = 'nameplateMaxScaleDistance',
                desc = 'The distance from the camera that nameplates will reach their maximum scale',
                min = 20, max = 60, step = 20,
                arg = 'nameplateMaxScaleDistance',
            },
            nameplateMinAlphaDistance = {
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
                name = 'nameplateMinAlphaDistance',
                desc = 'The distance from the max distance that nameplates will reach their minimum alpha',
                min = 20, max = 60, step = 20,
                arg = 'nameplateMinAlphaDistance',
            },
            nameplateMinScaleDistance = {
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
                name = 'nameplateMinScaleDistance',
                desc = 'The distance from the max distance that nameplates will reach their minimum scale',
                min = 20, max = 60, step = 20,
                arg = 'nameplateMinScaleDistance',
            },
            nameplateMotionSpeed = {
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
                name = 'nameplateMotionSpeed',
                desc = 'Controls the rate at which nameplate animates into their target locations',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateMotionSpeed',
            },
            nameplateRemovalAnimation = {
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
                name = 'nameplateRemovalAnimation',
                desc = 'When enabled, nameplates will play a brief shrinking animation when disappearing',
                arg = 'nameplateRemovalAnimation',
            },
            nameplateNotSelectedAlpha = {
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
                name = 'nameplateNotSelectedAlpha',
                desc = 'When you have a target, the alpha of other units\' nameplates',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateNotSelectedAlpha',
            },
            nameplateSelectedAlpha = {
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
                name = 'nameplateSelectedAlpha',
                desc = 'The alpha of the selected nameplate',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateSelectedAlpha',
            },
            nameplateSelfAlpha = {
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
                name = 'nameplateSelfAlpha',
                desc = 'The alpha of the self nameplate',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateSelfAlpha',
            },
            nameplateSelectedScale = {
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
                name = 'nameplateSelectedScale',
                desc = 'The scale of the selected nameplate',
                min = 0.0, max = 2.0, step = 0.1,
                arg = 'nameplateSelectedScale',
            },
            nameplateSelfScale = {
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
                name = 'nameplateSelfScale',
                desc = 'The scale of the selected nameplate',
                min = 0.0, max = 2.0, step = 0.1,
                arg = 'nameplateSelfScale',
            },
            nameplateMaxAlpha = {
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
                name = 'nameplateMaxAlpha',
                desc = 'The max alpha of nameplates',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'nameplateMaxAlpha',
            },
            nameplateMaxDistance = {
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
                name = 'nameplateMaxDistance',
                desc = 'The max distance to show nameplates',
                min = 20, max = 60, step = 20,
                arg = 'nameplateMaxDistance',
            },
            NameplatePersonalHideDelayAlpha = {
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
                name = 'NameplatePersonalHideDelayAlpha',
                desc = 'Determines the alpha of the personal nameplate after no visibility conditions are met (during the period of time specified by NameplatePersonalHideDelaySeconds)',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'NameplatePersonalHideDelayAlpha',
            },
            NameplatePersonalHideDelaySeconds = {
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
                name = 'NameplatePersonalHideDelaySeconds',
                desc = 'Determines the length of time in seconds that the personal nameplate will be visible after no visibility conditions are met',
                min = 0, max = 3, step = 1,
                arg = 'NameplatePersonalHideDelaySeconds',
            },
            NameplatePersonalShowAlways = {
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
                name = 'NameplatePersonalShowAlways',
                desc = 'Determines if the the personal nameplate is shown',
                arg = 'NameplatePersonalShowAlways',
            },
            NameplatePersonalShowInCombat = {
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
                name = 'NameplatePersonalShowInCombat',
                desc = 'Determines if the the personal nameplate is shown when you enter combat. NameplatePersonalShowAlways likely overrides this but that remains to be tested',
                arg = 'NameplatePersonalShowInCombat',
            },
            nameplateShowAll = {
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
                name = 'nameplateShowAll',
                desc = 'Determines if nameplates are shown',
                arg = 'nameplateShowAll',
            },
            nameplateShowEnemies = {
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
                name = 'nameplateShowEnemies',
                desc = 'Determines if enemy nameplates are shown',
                arg = 'nameplateShowEnemies',
            },
            nameplateShowEnemyGuardians = {
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
                name = 'nameplateShowEnemyGuardians',
                desc = 'Determines if the the enemy guardian nameplate is shown',
                arg = 'nameplateShowEnemyGuardians',
            },
            nameplateShowEnemyMinions = {
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
                name = 'nameplateShowEnemyMinions',
                desc = 'Determines if the enemy minion nameplate is shown',
                arg = 'nameplateShowEnemyMinions',
            },
            nameplateShowEnemyPets = {
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
                name = 'nameplateShowEnemyPets',
                desc = 'Determines if the the enemy pet nameplate is shown',
                arg = 'nameplateShowEnemyPets',
            },
            nameplateShowEnemyTotems = {
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
                name = 'nameplateShowEnemyTotems',
                desc = 'Determines if the enemy totem nameplate is shown',
                arg = 'nameplateShowEnemyTotems',
            },
            nameplateShowFriendlyMinions = {
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
                name = 'nameplateShowFriendlyMinions',
                desc = 'Determines if the friendly minion nameplate is shown',
                arg = 'nameplateShowFriendlyMinions',
            },
            nameplateShowFriendlyNPCs = {
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
                name = 'nameplateShowFriendlyNPCs',
                desc = 'Determines if the the friendly NPC nameplate is shown',
                arg = 'nameplateShowFriendlyNPCs',
            },
            nameplateShowFriends = {
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
                name = 'nameplateShowFriends',
                desc = 'Determines if the the friendly nameplate is shown',
                arg = 'nameplateShowFriends',
            },
            nameplateShowFriendlyGuardians = {
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
                name = 'nameplateShowFriendlyGuardians',
                desc = 'Determines if the the friendly guardian nameplate is shown',
                arg = 'nameplateShowFriendlyGuardians',
            },
            nameplateShowFriendlyPets = {
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
                name = 'nameplateShowFriendlyPets',
                desc = 'Determines if the friendly pet nameplate is shown',
                arg = 'nameplateShowFriendlyPets',
            },
            nameplateShowFriendlyTotems = {
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
                name = 'nameplateShowFriendlyTotems',
                desc = 'Determines if the the friendly totem nameplate is shown',
                arg = 'nameplateShowFriendlyTotems',
            },
            --[[
            NameplatePersonalShowWithTarget = {
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
                name = 'NameplatePersonalShowWithTarget',
                desc = 'Determines if the personal nameplate is shown when selecting a target. NameplatePersonalShowAlways likely overrides this but that remains to be tested',
                values = {
                    0 = 'None',
                    1 = 'Hostile Target',
                    2 = 'Any Target',
                },
                arg = 'NameplatePersonalShowWithTarget',
            },
            ]]
            --[[
            nameplateTargetRadialPosition = {
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
                name = 'nameplateTargetRadialPosition',
                desc = 'When target is off screen, position its nameplate radially around sides and bottom',
                values = {
                    0 = 'None',
                    1 = 'Target Only',
                    3 = 'All In Combat',
                },
                arg = 'nameplateTargetRadialPosition',
            },
            ]]
            NamePlateVerticalScale = {
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
                name = 'NamePlateVerticalScale',
                desc = 'Applied to vertical size of all nameplates',
                min = 0.0, max = 1.0, step = 0.1,
                arg = 'NamePlateVerticalScale',
            },
            predictedHealth = {
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
                name = 'predictedHealth',
                desc = 'Whether or not to use predicted health values in the UI',
                arg = 'predictedHealth',
            },
            ShowClassColorInFriendlyNameplate = {
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
                name = 'ShowClassColorInFriendlyNameplate',
                desc = 'Use this to display the class color in friendly nameplate health bars',
                arg = 'ShowClassColorInFriendlyNameplate',
            },
            ShowClassColorInNameplate = {
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
                name = 'ShowClassColorInNameplate',
                desc = 'Use this to display the class color in nameplate health bars',
                arg = 'ShowClassColorInNameplate',
            },
            showtargetoftarget = {
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
                name = 'showtargetoftarget',
                desc = 'Whether the target of target frame should be shown',
                arg = 'showtargetoftarget',
            },
            statusText = {
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
                name = 'statusText',
                desc = 'Whether the status bars show numeric health/mana values',
                arg = 'statusText',
            },
            statusTextDisplay = {
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
                name = 'statusTextDisplay',
                desc = 'When target is off screen, position its nameplate radially around sides and bottom',
                values = {
                    NONE = 'None',
                    NUMERIC = 'Numeric',
                    PERCENT = 'Percent',
                },
                arg = 'statusTextDisplay',
            },
            UnitNameGuildTitle = {
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
                name = 'UnitNameGuildTitle',
                desc = 'Whether or not to display guild for playable characters',
                arg = 'UnitNameGuildTitle',
            },
        },
    };
end

--
--  Module initialize
--
--  @return void
function jName:OnInitialize()
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
function jName:OnEnable()
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
        jName.db:ResetDB();
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