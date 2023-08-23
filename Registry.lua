local _, Addon = ...;

Addon.REG = CreateFrame( 'Frame' );
Addon.REG:RegisterEvent( 'ADDON_LOADED' );
Addon.REG:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        Addon.AddonName = AddonName;
        Addon.REG.Registry = {};

        Addon.REG.FillSpeechOptions = function( self )
            local SelectedValue = tonumber( GetCVar( 'remoteTextToSpeechVoice' ) );
            for Index,Voice in ipairs( C_VoiceChat.GetRemoteTtsVoices() ) do
                local Row = {
                    Value=Voice.voiceID,
                    Description=VOICE_GENERIC_FORMAT:format( Voice.voiceID ),
                };
                table.insert( self.Registry[ string.lower( 'remoteTextToSpeechVoice' ) ].KeyPairs,Row );
            end
        end

        --
        --  Get module registry
        --
        --  @return table
        Addon.REG.GetRegistry = function( self )
            local Registry = {
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
                            Value = 60,
                            Description = 'High',
                        },
                    },
                    Step = 20,
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
                },
                NameplatePersonalShowInCombat = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                nameplateShowAll = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                nameplateShowFriends ={
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
                UnitNameGuildTitle = {
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
                },
                ConsoleKey = {
                    Type = 'Edit',
                    Category = 'System',
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
                RAIDfarclip = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1300,
                            Description = 'High',
                        },
                    },
                    Step = 100,
                    Category = 'Hud',
                },
                raidFramesDisplayClassColor = {
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
                },
                raidFramesHeight = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 75,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 25,
                    Category = 'Hud',
                },
                raidFramesWidth = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 75,
                            Description = 'Low',
                        },
                        High = {
                            Value = 200,
                            Description = 'High',
                        },
                    },
                    Step = 25,
                    Category = 'Hud',
                },
                raidGraphicsEnvironmentDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                raidGraphicsGroundClutter = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                raidGraphicsLiquidDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                raidGraphicsParticleDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 10,
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
                raidGraphicsShadowQuality = {
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
                RAIDgraphicsQuality = {
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
                raidOptionDisplayPets = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                raidOptionIsShown = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                raidOptionKeepGroupsTogether = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                raidOptionShowBorders = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                useCompactPartyFrames = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                lfgNewPlayerFriendly = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                alwaysShowBlizzardGroupsTab = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                bspcache = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                showPartyBackground = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                raidFramesDisplayPowerBars = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                raidOptionDisplayMainTankAndAssist = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                },
                showCastableBuffs = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                hwDetect = {
                    Type = 'Toggle',
                    Category = 'System',
                },
                raidFramesDisplayOnlyDispellableDebuffs = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                            Value = 3.4,
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
                            Value = 0,
                            Description = 'Low',
                        },
                        High = {
                            Value = 1300,
                            Description = 'High',
                        },
                    },
                    Step = 100,
                    Category = 'Hud',
                },
                ffxDeath = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                ffxGlow = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                graphicsEnvironmentDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
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
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                graphicsLiquidDetail = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 1,
                            Description = 'Low',
                        },
                        High = {
                            Value = 7,
                            Description = 'High',
                        },
                    },
                    Step = 1,
                    Category = 'Graphics',
                },
                graphicsShadowQuality = {
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
                graphicsQuality = {
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
                particleDensity = {
                    Type = 'Range',
                    KeyPairs = {
                        Low = {
                            Value = 10,
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
                projectedtextures = {
                    Type = 'Toggle',
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
                            Value = 0.5,
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
                    Category = 'Grapics',
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
                    Category = 'Grapics',
                },
                xpBarText = {
                    Type = 'Toggle',
                    Category = 'Hud',
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
                RAIDgroundEffectAnimation = {
                    Type = 'Toggle',
                    Category = 'Graphics',
                },
                showUnactivatedCharacters = {
                    Type = 'Toggle',
                    Category = 'System',
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
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                threatWorldText = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                addFriendInfoShown = {
                    Type = 'Toggle',
                    Category = 'Social',
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
                autoQuestProgress = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoQuestWatch = {
                    Type = 'Toggle',
                    Category = 'Hud',
                },
                autoStand = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
                autoUnshift = {
                    Type = 'Toggle',
                    Category = 'Character',
                },
            };
            for VarName,VarData in pairs( Registry ) do
                self.Registry[ string.lower( VarName ) ] = VarData;
            end
            self:FillSpeechOptions();
            return self.Registry;
        end

        Addon.REG:UnregisterEvent( 'ADDON_LOADED' );
    end
end );