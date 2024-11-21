local _, Addon = ...;

Addon.REG = CreateFrame( 'Frame' );
Addon.REG:RegisterEvent( 'ADDON_LOADED' );
Addon.REG:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        Addon.AddonName = AddonName;
        Addon.REG.Registry = {};

        --
        --  Get module registry
        --
        --  @return table
        Addon.REG.GetRegistry = function( self )
            local Registry = {
                disableSuggestedLevelActivityFilter = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                useClassicGuildUI = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                RAIDsettingsEnabled = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                UnitNameNPC = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                UnitNameOwn = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                UnitNameFriendlyPlayerName = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                spellEffectLevel = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1000,
                            Description = 'High',
                        },
                    },
                    Step = 100,
                    Category = 'Hud',
                },
                RAIDVolumeFogLevel = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidVolumeFog = {
                        },
                        RefreshEnableRaidSettings = {
                        },
                    },
                    Description = 'Volumetric fog is representative of … fog that fills a volume. Lighting then gives this fog depth for 3D visualisation',
                },
                volumeFogLevel = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableVolumeFog = {
                        },
                    },
                    Description = 'Volumetric fog is representative of … fog that fills a volume. Lighting then gives this fog depth for 3D visualisation',
                },
                GraphicsTextureResolution = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                },
                raidGraphicsTextureResolution = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                entityLodDist = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                RAIDentityLodDist = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                ShowNamePlateLoseAggroFlash = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateMotion = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Overlapping',
                        },
                        {
                            Value = 1,
                            Description = 'Stacking',
                        },
                        {
                            Value = 2,
                            Description = 'Spreading',
                        },
                    },
                    Category = 'Hud',
                },
                nameplateOverlapH = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.1,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateOverlapV = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.1,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateGlobalScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateShowOnlyNames = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateHideHealthAndPower = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Description = 'Resource indicator powerbar for player character visibility toggle',
                },
                NameplatePersonalClickThrough = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateResourceOnTarget = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowDebuffsOnFriendly = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowSelf = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoRangedCombat = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                chatClassColorOverride = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Always',
                        },
                        {
                            Value = 1,
                            Description = 'Never',
                        },
                        {
                            Value = 2,
                            Description = 'Legacy',
                        },
                    },
                    Category = 'Social',
                },
                digSites = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                useUiScale = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                countdownForCooldowns = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                graphicsOutlineMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 1,
                            Description = 'Good',
                        },
                        {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                },
                raidGraphicsOutlineMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 1,
                            Description = 'Good',
                        },
                        {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                findyourselfanywhere = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                findYourselfMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Circle',
                        },
                        {
                            Value = 1,
                            Description = 'Circle & Outline',
                        },
                        {
                            Value = 2,
                            Description = 'Outline',
                        },
                    },
                    Category = 'Character',
                    Cascade = {
                        RefreshFindYourself = {
                        },
                    },
                },
                nameplateOtherAtBase = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Hud',
                },
                nameplateRemovalAnimation = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateClassResourceTopInset = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                NamePlateHorizontalScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateLargerScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateMaxScaleDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 20,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                    Category = 'Hud',
                },
                nameplateMotionSpeed = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                NamePlateVerticalScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                NameplatePersonalHideDelaySeconds = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Character',
                },
                nameplateSelectedScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateNotSelectedAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateMaxDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 20,
                            Description = 'Low',
                        },
                        High = {
                            Value = 41,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Hud',
                },
                nameplateSelfScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Character',
                },
                NameplatePersonalShowAlways = {
                    Type = 'Toggle',
                    Category = 'Character',
                    Cascade = {
                        RefreshShowPersonalNamePlate = {

                        },
                    },
                },
                NameplatePersonalShowInCombat = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                nameplateShowAll = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshShowAllNamePlates = {

                        },
                    },
                },
                nameplateShowEnemies = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowEnemyGuardians = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowEnemyMinions = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowEnemyPets = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowEnemyTotems = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowFriends = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                UnitNamePlayerPVPTitle = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                UnitNamePlayerGuild = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                UnitNameGuildTitle = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowFriendlyGuardians = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateTargetRadialPosition = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'None',
                        },
                        {
                            Value = 1,
                            Description = 'Target Only',
                        },
                        {
                            Value = 3,
                            Description = 'All In Combat',
                        },
                    },
                    Category = 'Hud',
                },
                NameplatePersonalShowWithTarget = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'None',
                        },
                        {
                            Value = 1,
                            Description = 'Hostile Target',
                        },
                        {
                            Value = 2,
                            Description = 'Any Target',
                        },
                    },
                    Category = 'Character',
                },
                nameplateShowFriendlyNPCs = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshShowFriendlyNPCNamePlates = {

                        },
                    },
                },
                nameplateShowFriendlyTotems = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowFriendlyPets = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateShowFriendlyMinions = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                statusText = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                statusTextDisplay = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'NONE',
                            Description = 'None',
                        },
                        {
                            Value = 'NUMERIC',
                            Description = 'Numeric',
                        },
                        {
                            Value = 'PERCENT',
                            Description = 'Percent',
                        },
                    },
                    Category = 'Hud',
                },
                predictedHealth = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ShowClassColorInNameplate = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                showtargetoftarget = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ShowClassColorInFriendlyNameplate = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                clampTargetNameplateToScreen = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                --[[
                floatingCombatTextAuraFade = {
                },
                ]]
                GamePadEmulateEsc = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'NONE',
                            Description = 'None',
                        },
                        {
                            Value = 'PADBACK',
                            Description = 'PADBACK',
                        },
                    },
                    Category = 'Hud',
                },
                ColorNameplateNameBySelection = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                fullSizeFocusFrame = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                nameplateSelfAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Character',
                },
                nameplateOtherBottomInset = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateMinAlphaDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 10,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Hud',
                },
                nameplateMinScaleDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 10,
                            Description = 'Low',
                        },
                        High = {
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Hud',
                },
                nameplateSelfAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Character',
                },
                nameplateMaxAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                NameplatePersonalHideDelayAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Character',
                },
                Contrast = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 100,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Hud',
                },
                showArenaEnemyCastbar = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                alwaysShowActionBars = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                LockActionBars = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                multiBarRightVerticalLayout = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshActionBars = {
                        },
                    },
                },
                ConsoleKey = {
                    Type = 'Edit',
                    Category = 'System',
                    Cascade = {
                        RefreshConsole = {
                        },
                    },
                },
                checkAddonVersion = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                enableSourceLocationLookup = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                fstack_showhighlight = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                fstack_showanchors = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                fstack_showhidden = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                fstack_showregions = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                fullDump = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                scriptErrors = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                scriptProfile = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                scriptWarnings = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                showErrors = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                taintLog = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 1,
                            Description = 'Blocked Actions Logged',
                        },
                        {
                            Value = 2,
                            Description = 'Blocked and Globals',
                        },
                    },
                    Category = 'Debug',
                },
                mapFade = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                showMinimapClock = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                secondaryProfessionsFilter = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                rotateMinimap = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                mapAnimDuration = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1,
                            Description = 'High',
                        },
                    },
                    Step = .2,
                    Category = 'Hud',
                },
                --[[
                useCompactPartyFrames = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidFramesDisplayIncomingHeals = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                raidFramesHealthText = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'none',
                            Description = 'None',
                        },
                        {
                            Value = 'health',
                            Description = 'Health Remaining',
                        },
                        {
                            Value = 'losthealth',
                            Description = 'Health Lost (ie Deficit)',
                        },
                        {
                            Value = 'perc',
                            Description = 'Health Percentage',
                        },
                    },
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidOptionShowBorders = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidOptionSortMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'role',
                            Description = 'Role',
                        },
                        {
                            Value = 'group',
                            Description = 'Group',
                        },
                    },
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidFramesDisplayClassColor = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidFramesDisplayOnlyDispellableDebuffs = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidFramesDisplayPowerBars = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidOptionDisplayPets = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidOptionKeepGroupsTogether = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidOptionDisplayMainTankAndAssist = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Cascade = {
                        RefreshCompactPartyFrame = {
                        },
                    },
                },
                raidOptionLocked = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'lock',
                            Description = 'Locked',
                        },
                        {
                            Value = 'unlock',
                            Description = 'Unlocked',
                        },
                    },
                    Category = 'Hud',
                    Cascade = {
                        RefreshRaid = {
                        },
                    },
                },
                ]]
                RAIDfarclip = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 185,
                            Description = 'Low',
                        },
                        High = {
                            Value = 4000,
                            Description = 'High',
                        },
                    },
                    Step = 5,
                    Category = 'Hud',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                    Description = 'This CVar controls the view distance of the environment. Manually increasing this CVar beyond the maximum value may cause the client to crash (Error 132).',
                },
                waterDetail  = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                RAIDWaterDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                RAIDgroundEffectAnimation = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                raidGraphicsEnvironmentDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                raidGraphicsGroundClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                raidGraphicsLiquidDetail = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                raidGraphicsSSAO = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 4,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                RAIDweatherDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                raidGraphicsSunshafts = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                lfgNewPlayerFriendly = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                alwaysShowBlizzardGroupsTab = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                bspcache = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                calendarShowResets = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                calendarShowWeeklyHolidays = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                enablePVPNotifyAFK = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                showCastableBuffs = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                hwDetect = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                showDispelDebuffs = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                colorChatNamesByClass = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                guildMemberNotify = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                guildShowOffline = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                profanityfilter = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastBroadcast = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastFriendRequest = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastWindow = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastOffline = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastOnline = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                spamFilter = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showLootSpam = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                autoCompleteResortNamesOnRecency = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                autoCompleteUseContext = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                autoCompleteWhenEditingFromCenter = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                blockChannelInvites = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                chatBubbles = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                chatBubblesParty = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                chatMouseScroll = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                chatStyle = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'classic',
                            Description = 'Classic',
                        },
                        {
                            Value = 'im',
                            Description = 'IM',
                        },
                    },
                    Category = 'Social',
                },
                friendsSmallView = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                blockTrades = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                autojoinBGVoice = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                autojoinPartyVoice = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                friendsViewButtons = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                guildRosterView = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'playerStatus',
                            Description = 'View Player Status',
                        },
                        {
                            Value = 'guildStatus',
                            Description = 'View Guild Status',
                        },
                        {
                            Value = 'weeklyxp',
                            Description = 'View Guild Status (weekly)',
                        },
                        {
                            Value = 'totalxp',
                            Description = 'View Guild Status',
                        },
                        {
                            Value = 'guildStatus',
                            Description = 'View Guild Status (total)',
                        },
                        {
                            Value = 'achievement',
                            Description = 'View Achievement Points',
                        },
                        {
                            Value = 'tradeskill',
                            Description = 'View Professions',
                        },
                    },
                    Category = 'Social',
                },
                lfgAutoFill = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                lfgAutoJoin = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                --[[
                lfgSelectedRoles = {
                },
                ]]
                PushToTalkSound = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                remoteTextToSpeech = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                remoteTextToSpeechVoice = {
                    Type = 'Select',
                    KeyPairs = {},
                    Category = 'Social',
                },
                removeChatDelay = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastClubInvitation = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                showToastConversation = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                textToSpeech = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                whisperMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'popout',
                            Description = 'Pop Out',
                        },
                        {
                            Value = 'inline',
                            Description = 'Inline',
                        },
                        {
                            Value = 'popout_and_inline',
                            Description = 'Pop Out & Inline',
                        },
                    },
                    Category = 'Social',
                    Description = 'The action new whispers take by default: "popout", "inline", "popout_and_inline"',
                },
                Sound_EnableSoundWhenGameIsInBG = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_EnableEmoteSounds = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_EnablePetSounds = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                FootstepSounds = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                ChatMusicVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                ChatSoundVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                Sound_EnableErrorSpeech = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_EnableMusic = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_EnableReverb = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_ZoneMusicNoDelay = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_EnableAllSound = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                Sound_AmbienceVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                Sound_DialogVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                Sound_MasterVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                Sound_MusicVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                Sound_SFXVolume = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Sound',
                },
                equipmentManager = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                consolidateBuffs = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoClearAFK = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoLootDefault = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoSelfCast = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                cameraDistanceMaxZoomFactor = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3.9,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                cameraSmoothStyle = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Never adjust camera',
                        },
                        {
                            Value = 1,
                            Description = 'Adjust camera only horizontal when moving',
                        },
                        {
                            Value = 2,
                            Description = 'Always adjust camera',
                        },
                        {
                            Value = 4,
                            Description = 'Adjust camera only when moving',
                        },
                    },
                    Category = 'Hud',
                },
                deselectOnClick = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                doNotFlashLowHealthWarning = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                emphasizeMySpellEffects = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                farclip = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 185,
                            Description = 'Low',
                        },
                        High = {
                            Value = 4000,
                            Description = 'High',
                        },
                    },
                    Step = 5,
                    Category = 'Hud',
                    Description = 'This CVar controls the view distance of the environment. Manually increasing this CVar beyond the maximum value may cause the client to crash (Error 132).',
                },
                ffxDeath = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ffxGlow = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                RAIDrippleDetail = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'No reflection',
                        },
                        {
                            Value = 1,
                            Description = 'Sky reflection',
                        },
                        {
                            Value = 2,
                            Description = 'More reflection',
                        },
                        {
                            Value = 3,
                            Description = 'High reflection',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                rippleDetail = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'No reflection',
                        },
                        {
                            Value = 1,
                            Description = 'Sky reflection',
                        },
                        {
                            Value = 2,
                            Description = 'More reflection',
                        },
                        {
                            Value = 3,
                            Description = 'High reflection',
                        },
                    },
                    Category = 'Graphics',
                },
                graphicsEnvironmentDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                graphicsGroundClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                graphicsLiquidDetail = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                },
                graphicsSSAO = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 4,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                groundEffectDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 16,
                            Description = 'Low',
                        },
                        High = {
                            Value = 256,
                            Description = 'High',
                        },
                    },
                    Step = 16,
                    Category = 'Graphics',
                },
                RAIDgroundEffectDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 16,
                            Description = 'Low',
                        },
                        High = {
                            Value = 256,
                            Description = 'High',
                        },
                    },
                    Step = 16,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                EffectDist = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 32,
                            Description = 'Low',
                        },
                        High = {
                            Value = 600,
                            Description = 'High',
                        },
                    },
                    Step = 16,
                    Category = 'Graphics',
                },
                RAIDgroundEffectDist = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 32,
                            Description = 'Low',
                        },
                        High = {
                            Value = 600,
                            Description = 'High',
                        },
                    },
                    Step = 16,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                interactOnLeftClick = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                lootUnderMouse = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                instantQuestText = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoAcceptQuickJoinRequests = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoQuestProgress = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoQuestWatch = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoQuestPopUps = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                minimapShowQuestBlobs = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                showQuestObjectivesOnMap = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ShowQuestUnitCircles = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                questLogOpen = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                minimapTrackingShowAll = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                secondaryProfessionsFilter = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                RAIDparticleDensity = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 10,
                            Description = 'Low',
                        },
                        {
                            Value = 25,
                            Description = 'Fair',
                        },
                        {
                            Value = 50,
                            Description = 'Good',
                        },
                        {
                            Value = 80,
                            Description = 'High',
                        },
                        {
                            Value = 100,
                            Description = 'Ultra',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                        RefreshRaidParticleDensity = {
                        },
                    },
                },
                particleDensity = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 10,
                            Description = 'Low',
                        },
                        {
                            Value = 25,
                            Description = 'Fair',
                        },
                        {
                            Value = 50,
                            Description = 'Good',
                        },
                        {
                            Value = 80,
                            Description = 'High',
                        },
                        {
                            Value = 100,
                            Description = 'Ultra',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshParticleDensity = {
                        },
                    },
                },
                projectedtextures = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                RAIDreflectionMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Screen Space',
                        },
                        {
                            Value = 1,
                            Description = 'Sky',
                        },
                        {
                            Value = 2,
                            Description = 'Sky/Terrain',
                        },
                        {
                            Value = 3,
                            Description = 'Sky/Terrain/Building',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                reflectionMode = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Screen Space',
                        },
                        {
                            Value = 1,
                            Description = 'Sky',
                        },
                        {
                            Value = 2,
                            Description = 'Sky/Terrain',
                        },
                        {
                            Value = 3,
                            Description = 'Sky/Terrain/Building',
                        },
                    },
                    Category = 'Graphics',
                },
                RenderScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Hud',
                },
                screenEdgeFlash = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                showTutorials = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                SkyCloudLOD = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                SpellQueueWindow = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 400,
                            Description = 'High',
                        },
                    },
                    Step = 20,
                    Category = 'System',
                },
                timeMgrUseLocalTime = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                uiScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.6,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                violencelevel = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 5,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                weatherDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                xpBarText = {
                    Type = 'Toggle',
                    Category = 'Hud',
                    Description = 'Whether the XP bar shows the numeric experience value',
                },
                synchronizeMacros = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                synchronizeSettings = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                showfootprintparticles = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                speechToText = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                synchronizeConfig = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                pathSmoothing = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                secureAbilityToggle = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                useMaxFPS = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                maxFPSLoading = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Graphics',
                },
                maxFPSBk = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Graphics',
                },
                displayFreeBagSlots = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                maxFPS = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Graphics',
                },
                displayWorldPVPObjectives = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                dontShowEquipmentSetsOnItems = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                enableWowMouse = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                floatingCombatTextAuras = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextCombatDamage = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextCombatDamageAllAutos = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextCombatHealing = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextComboPoints = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextEnergyGains = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextHonorGains = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                floatingCombatTextLowManaHealth = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                forceEnglishNames = {
                    Type = 'Toggle',
                    Category = 'Social',
                },
                cursorSizePreferred = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = -1,
                            Description = 'Determine based on system/monitor dpi',
                        },
                        {
                            Value = 0,
                            Description = '32x32',
                        },
                        {
                            Value = 1,
                            Description = '48x48',
                        },
                        {
                            Value = 2,
                            Description = '64x64',
                        },
                        {
                            Value = 3,
                            Description = '96x96',
                        },
                        {
                            Value = 4,
                            Description = '128x128',
                        },
                    },
                    Category = 'Hud',
                },
                cameraCustomViewSmoothing = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                CameraKeepCharacterCentered = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                cameraYawSmoothSpeed = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 90,
                            Description = 'Low',
                        },
                        High = {
                            Value = 270,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Hud',
                },
                cameraPivot = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                cameraTerrainTilt = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ClipCursor = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                colorblindMode = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                cameraBobbingSmoothSpeed = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                buffDurations = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                calendarShowBattlegrounds = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                calendarShowDarkmoon = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                calendarShowHolidays = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                cameraBobbing = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                Brightness = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 100,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Graphics',
                },
                autoLootRate = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 50,
                            Description = 'Low',
                        },
                        High = {
                            Value = 300,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Character',
                },
                autoOpenLootHistory = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                breakUpLargeNumbers = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ActionButtonUseKeyDown = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                advancedCombatLogging = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                advancedWatchFrame = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoDismount = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoDismountFlying = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoInteract = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                ShowAllSpellRanks = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                cameraFov = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 50,
                            Description = 'Low',
                        },
                        High = {
                            Value = 90,
                            Description = 'High',
                        },
                    },
                    Step = 10,
                    Category = 'Hud',
                    Description = 'Default camera field of view',
                },
                previewTalents = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                graphicsSunshafts = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                groundEffectAnimation = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                showKeyring = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                showNewbieTips = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ShowClassColorInFriendlyNameplate = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ShowClassColorInNameplate = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ShowAllSpellRanks = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                --[[trackerFilter = {
                },]]
                --[[trackerSorting = {
                },]]
                --[[watchFrameWidth = {
                },]]
                heardChoiceSFX = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                hideOutdoorWorldState = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                minimumAutomaticUiScale = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.64,
                            Description = 'Low',
                        },
                        High = {
                            Value = 0.9,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Hud',
                },
                nameplateCommentatorMaxDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 200,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1000,
                            Description = 'High',
                        },
                    },
                    Step = 200,
                    Category = 'Hud',
                },
                showUnactivatedCharacters = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                RAIDspellClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = -1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 100,
                            Description = '100',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                    Description = 'Cull unimportant spell effects. -1 means auto based on targetFPS otherwise [0-100], 0 means cull nothing for perf reasons, 100 means cull as much as you can',
                },
                graphicsSpellDensity = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Essential',
                        },
                        {
                            Value = 1,
                            Description = 'Some',
                        },
                        {
                            Value = 2,
                            Description = 'Half',
                        },
                        {
                            Value = 3,
                            Description = 'Most',
                        },
                        {
                            Value = 4,
                            Description = 'Dynamic',
                        },
                        {
                            Value = 5,
                            Description = 'Everything',
                        },
                    },
                    Category = 'Graphics',
                },
                raidGraphicsSpellDensity = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Essential',
                        },
                        {
                            Value = 1,
                            Description = 'Some',
                        },
                        {
                            Value = 2,
                            Description = 'Half',
                        },
                        {
                            Value = 3,
                            Description = 'Most',
                        },
                        {
                            Value = 4,
                            Description = 'Dynamic',
                        },
                        {
                            Value = 5,
                            Description = 'Everything',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                spellClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = -1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 100,
                            Description = '100',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Description = 'Cull unimportant spell effects. -1 means auto based on targetFPS otherwise [0-100], 0 means cull nothing for perf reasons, 100 means cull as much as you can',
                },
                spellClutterDefaultTargetScalar = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3.000000,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'System',
                },
                spellClutterHostileScalar = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.001,
                            Description = 'Low',
                        },
                        High = {
                            Value = 0.500000,
                            Description = 'High',
                        },
                    },
                    Step = 0.001,
                    Category = 'System',
                },
                spellClutterMinSpellCount = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'System',
                },
                spellClutterMinWeaponTrailCount = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'System',
                },
                spellClutterPartySizeScalar = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 20.000000,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'System',
                },
                spellClutterPlayerScalarMultiplier = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.666667,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'System',
                },
                spellClutterRangeConstant = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 30.000000,
                            Description = 'High',
                        },
                    },
                    Step = 1.0,
                    Category = 'System',
                },
                spellClutterRangeConstantRaid = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 30.000000,
                            Description = 'High',
                        },
                    },
                    Step = 1.0,
                    Category = 'System',
                },
                twitterCharactersPerMedia = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 23,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'System',
                },
                worldEntityLinkMode = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                Sound_EnableDSPEffects = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                textureErrorColors = {
                    Type = 'Toggle',
                    Category = 'Debug',
                },
                threatPlaySounds = {
                    Type = 'Toggle',
                    Category = 'Sound',
                },
                threatShowNumeric = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                threatWarning = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Hud',
                },
                threatWorldText = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                allowCompareWithToggle = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                alwaysCompareItems = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                animFrameSkipLOD = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                    Description = 'Skip loading animation frames in distance',
                },
                assaoAdaptiveQualityLimit = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoBlurPassCount = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 6,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                assaoFadeOutFrom = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 50.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoFadeOutTo = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 300.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoHorizonAngleThresh = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 0.4,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoNormals = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                assaoRadius = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.85,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                raidGraphicsShadowQuality = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                        {
                            Value = 4,
                            Description = 'Ultra',
                        },
                        {
                            Value = 5,
                            Description = 'Ultra High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                        RefreshRaidShadowQuality = {

                        },
                    },
                },
                graphicsShadowQuality = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Low',
                        },
                        {
                            Value = 1,
                            Description = 'Fair',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                        {
                            Value = 4,
                            Description = 'Ultra',
                        },
                        {
                            Value = 5,
                            Description = 'Ultra High',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshShadowQuality = {

                        },
                    },
                },
                assaoDetailShadowStrength = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 5.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoShadowClamp = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = .10,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoShadowMult = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 5.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoShadowPower = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.5,
                            Description = 'Low',
                        },
                        High = {
                            Value = 5.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoSharpness = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoTemporalSSAngleOffset = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 3.14,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assaoTemporalSSRadiusOffset = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0.0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                },
                assistAttack = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                asyncThreadSleep = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                auctionDisplayOnCharacter = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoFilledMultiCastSlots = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                autoStand = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoUnshift = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                worldPreloadHighResTextures = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                worldPreloadNonCritical = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 2,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Description = 'Require objects to be loaded in streaming non critical radius when preloading',
                },
                worldPreloadNonCriticalTimeout = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 45,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Description = 'World preload time (in seconds) when non-critical items are automatically ignored',
                },
                showTimestamps = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 'none',
                            Description = 'None',
                        },
                        {
                            Value = '%I:%M ',
                            Description = '03:27',
                        },
                        {
                            Value = '%I:%M %p ',
                            Description = '03:27 PM',
                        },
                        {
                            Value = '%I:%M:%S %p ',
                            Description = '03:27:32 PM',
                        },
                        {
                            Value = '%H:%M ',
                            Description = '15:27',
                        },
                        {
                            Value = '%H:%M:%S ',
                            Description = '15:27:32',
                        },
                    },
                    Category = 'Social',
                },
                DisableAdvancedFlyingVelocityVFX = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                DisableAdvancedFlyingFullScreenEffects = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                horizonStart = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 800,
                            Description = 'Default',
                        },
                        {
                            Value = 400,
                            Description = 'Low',
                        },
                        {
                            Value = 1400,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                },
                RAIDhorizonStart = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 800,
                            Description = 'Default',
                        },
                        {
                            Value = 400,
                            Description = 'Low',
                        },
                        {
                            Value = 1400,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                },
                WorldTextScale = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 1.0,
                            Description = 'Default',
                        },
                        {
                            Value = 0.5,
                            Description = 'Low',
                        },
                        {
                            Value = 2.0,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                    Description = 'The scale of fonts in the world',
                },
                WorldTextMinSize = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 64,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Description = 'The minimum size of fonts in the world',
                },
                WorldTextMinAlpha = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1,
                            Description = 'High',
                        },
                    },
                    Step = 0.1,
                    Category = 'Graphics',
                    Description = 'The minimum transparancy of fonts in the world',
                },
                raidGraphicsComputeEffects = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 1,
                            Description = 'Low',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                        {
                            Value = 4,
                            Description = 'Ultra',
                        },
                    },
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                graphicsComputeEffects = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 1,
                            Description = 'Low',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                        {
                            Value = 4,
                            Description = 'Ultra',
                        },
                    },
                    Category = 'Graphics',
                },
                graphicsDepthEffects = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Disabled',
                        },
                        {
                            Value = 1,
                            Description = 'Low',
                        },
                        {
                            Value = 2,
                            Description = 'Good',
                        },
                        {
                            Value = 3,
                            Description = 'High',
                        },
                    },
                    Category = 'Graphics',
                },
                maxLightDist = {
                    Type = 'Select',
                    KeyPairs = {
                        {
                            Value = 0,
                            Description = 'Off',
                        },
                        {
                            Value = 35,
                            Description = 'Close-Range',
                        },
                        {
                            Value = 2048,
                            Description = 'Default',
                        },
                    },
                    Category = 'Graphics',
                },
                graphicsViewDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                raidGraphicsViewDistance = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 10,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                terrainLodDist = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 400,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },                },
                RAIDterrainLodDist = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 400,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                    Cascade = {
                        RefreshEnableRaidSettings = {
                        },
                    },
                },
                synchronizeConfig = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                synchronizeMacros = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                synchronizeSettings = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                synchronizeBindings = {
                    Type = 'Toggle',
                    Category = 'System',
                },
            };
            for VarName,VarData in pairs( Registry ) do
                self.Registry[ string.lower( VarName ) ] = VarData;
            end

            return self.Registry;
        end

        Addon.REG:UnregisterEvent( 'ADDON_LOADED' );
    end
end );