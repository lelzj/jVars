local _, Addon = ...;

Addon.SOCIAL = CreateFrame( 'Frame' );
Addon.SOCIAL:RegisterEvent( 'ADDON_LOADED' )
Addon.SOCIAL.FistColInset = 15;
Addon.SOCIAL.RegisteredFrames = {};
Addon.SOCIAL:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.SOCIAL.GetDefaults = function( self )
            local Defaults = {};
            for VarName,_ in pairs( self.RegisteredVars ) do
                Defaults[ string.lower( VarName ) ] = GetCVar( VarName );
                if( Defaults[ string.lower( VarName ) ] == nil ) then
                    self.RegisteredVars[ string.lower( VarName ) ].Flagged = true;
                    Defaults[ string.lower( VarName ) ] = 0;
                end
            end
            return Defaults;
        end

        --
        --  Set module setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return void
        Addon.SOCIAL.SetValue = function( self,Index,Value )
            if( self.RegisteredVars[ string.lower( Index ) ] ) then
                if( self.RegisteredVars[ string.lower( Index ) ].Type == 'Toggle' ) then
                    if( type( Value ) == 'boolean' ) then
                        self.persistence[ string.lower( Index ) ] = Addon:BoolToInt( Value );
                    else
                        self.persistence[ string.lower( Index ) ] = Value;
                    end
                else
                    self.persistence[ string.lower( Index ) ] = Value;
                end
                self:Refresh();
            end
        end

        --
        --  Get module setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.SOCIAL.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.SOCIAL.FrameRegister = function( self,FrameData )
            local Found = false;
            for i,MetaData in pairs( self.RegisteredFrames ) do
                if( MetaData.Name == FrameData.Name ) then
                    Found = true;
                end
            end
            if( not Found ) then
                table.insert( self.RegisteredFrames,{
                    Name        = FrameData.Name,
                    Frame       = FrameData.Frame,
                    Description = FrameData.Description,
                } );
            end
        end

        Addon.SOCIAL.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.SOCIAL.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.SOCIAL.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.SOCIAL.Filter = function( self,SearchQuery )
            if( not ( string.len( SearchQuery ) >= 3 ) ) then
                return;
            end
            local FoundFrames = {};
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( Addon:Minify( FrameData.Name ):find( Addon:Minify( SearchQuery ) ) ) then
                    if( not FoundFrames [ string.lower( FrameData.Name ) ] ) then
                        FoundFrames [ string.lower( FrameData.Name ) ] = FrameData.Frame;
                    end
                end
                if( Addon:Minify( FrameData.Description ):find( Addon:Minify( SearchQuery ) ) ) then
                    if( not FoundFrames [ string.lower( FrameData.Name ) ] ) then
                        FoundFrames [ string.lower( FrameData.Name ) ] = FrameData.Frame;
                    end
                end
            end
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( not FoundFrames[ string.lower( FrameData.Name ) ] ) then
                    FrameData.Frame:Hide();
                else
                    FrameData.Frame:Show();
                end
            end
        end

        --
        --  Create module config frames
        --
        --  @return void
        Addon.SOCIAL.CreateFrames = function( self )
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( self.Name ),{
                type = 'group',
                name = self.Name,
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( self.Name ),self.Name,'jVars' );
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.SOCIAL.Refresh = function( self )
            if( not Addon.SOCIAL.persistence ) then
                return;
            end

            -- Set environment CVars to DB values
            for VarName,VarData in pairs( self.RegisteredVars ) do
                if( self.persistence[ string.lower( VarName ) ] ~= nil ) then
                    SetCVar( string.lower( VarName ),self.persistence[ string.lower( VarName ) ] );
                end
            end

            -- Color chat names
            self:ColorNames();
        end

        --
        --  Module reset
        --
        --  @return void
        Addon.SOCIAL.ResetDb = function( self )
            self.db:ResetDB();
        end

        Addon.SOCIAL.ColorNames = function( self )
            if( self.persistence[ string.lower( 'colorChatNamesByClass' ) ] ~= nil ) then
                if( self.persistence[ string.lower( 'colorChatNamesByClass' ) ] ) then
                    SetCVar( 'chatClassColorOverride',0 );
                else
                    SetCVar( 'chatClassColorOverride',1 );
                end
            end
        end

        Addon.SOCIAL.FillSpeechOptions = function( self )
            local SelectedValue = tonumber( GetCVar( 'remoteTextToSpeechVoice' ) );
            for Index,Voice in ipairs( C_VoiceChat.GetRemoteTtsVoices() ) do
                local Row = {
                    Value=Voice.voiceID,
                    Description=VOICE_GENERIC_FORMAT:format( Voice.voiceID ),
                };
                table.insert( self.RegisteredVars[ string.lower( 'remoteTextToSpeechVoice' ) ].KeyPairs,Row );
            end
        end

        --
        --  Module init
        --
        --  @return void
        Addon.SOCIAL.Init = function( self )
            self.Name = 'jSocial';
            local RegisteredVars = {
                colorChatNamesByClass = {
                    Type = 'Toggle',
                },
                guildMemberNotify = {
                    Type = 'Toggle',
                },
                profanityfilter = {
                    Type = 'Toggle',
                },
                showToastBroadcast = {
                    Type = 'Toggle',
                },
                showToastFriendRequest = {
                    Type = 'Toggle',
                },
                showToastWindow = {
                    Type = 'Toggle',
                },
                showToastOffline = {
                    Type = 'Toggle',
                },
                showToastOnline = {
                    Type = 'Toggle',
                },
                spamFilter = {
                    Type = 'Toggle',
                },
                showLootSpam = {
                    Type = 'Toggle',
                },
                autoCompleteResortNamesOnRecency = {
                    Type = 'Toggle',
                },
                autoCompleteUseContext = {
                    Type = 'Toggle',
                },
                autoCompleteWhenEditingFromCenter = {
                    Type = 'Toggle',
                },
                blockChannelInvites = {
                    Type = 'Toggle',
                },
                chatBubbles = {
                    Type = 'Toggle',
                },
                chatBubblesParty = {
                    Type = 'Toggle',
                },
                chatMouseScroll = {
                    Type = 'Toggle',
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
                },
                friendsSmallView = {
                    Type = 'Toggle',
                },
                blockTrades = {
                    Type = 'Toggle',
                },
                autojoinBGVoice = {
                    Type = 'Toggle',
                },
                autojoinPartyVoice = {
                    Type = 'Toggle',
                },
                friendsViewButtons = {
                    Type = 'Toggle',
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
                },
                --[[
                lastTalkedToGM = {
                    Type = 'Edit',
                },
                ]]
                lfgAutoFill = {
                    Type = 'Toggle',
                },
                lfgAutoJoin = {
                    Type = 'Toggle',
                },
                --[[
                lfgSelectedRoles = {
                },
                ]]
                PushToTalkSound = {
                    Type = 'Toggle',
                },
                remoteTextToSpeech = {
                    Type = 'Toggle',
                },
                remoteTextToSpeechVoice = {
                    Type = 'Select',
                    KeyPairs = {},
                },
                removeChatDelay = {
                    Type = 'Toggle',
                },
                showToastClubInvitation = {
                    Type = 'Toggle',
                },
                showToastConversation = {
                    Type = 'Toggle',
                },
                textToSpeech = {
                    Type = 'Toggle',
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
                },
            };
            self.RegisteredVars = {};
            for VarName,VarData in pairs( RegisteredVars ) do
                if( Addon.VARS.Dictionary[ string.lower( VarName ) ] ) then
                    VarData.Description = Addon.VARS.Dictionary[ string.lower( VarName ) ].Description;
                    VarData.DisplayText = Addon.VARS.Dictionary[ string.lower( VarName ) ].DisplayText;
                else
                    VarData.Description = 'Info is currently unavailable';
                    VarData.DisplayText = VarName;
                end
                VarData.Name = string.lower( VarName );
                self.RegisteredVars[ string.lower( VarName ) ] = VarData;
            end
            self.db = LibStub( 'AceDB-3.0' ):New( self.Name,{ profile = self:GetDefaults() },true );
            if( not self.db ) then
                return;
            end
            --self.db:ResetDB();
            self.persistence = self.db.profile;
            if( not self.persistence ) then
                return;
            end

            -- Text to speech options
            self:FillSpeechOptions();
        end

        --
        --  Module run
        --
        --  @return void
        Addon.SOCIAL.Run = function( self )
            self.ScrollChild = Addon.GRID:RegisterGrid( self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox',self.Name..'ChatFilter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.SOCIAL:ShowAll();
                self:SetAutoFocus( false );
                if( self.Instructions ) then
                    self.Instructions:Show();
                end
                self:ClearFocus();
                self:SetText( '' );
            end );
            self.FilterBox:SetScript( 'OnEditFocusGained',function( self ) 
                self:SetAutoFocus( true );
                if( self.Instructions ) then
                    self.Instructions:Hide();
                end
                self:HighlightText();
            end );
            self.FilterBox:SetScript( 'OnTextChanged',function( self )
                Addon.SOCIAL:ShowAll();
                Addon.SOCIAL:Filter( self:GetText(),Addon.SOCIAL );
            end );
        end

        Addon.SOCIAL:Init();
        Addon.SOCIAL:CreateFrames();
        Addon.SOCIAL:Refresh();
        Addon.SOCIAL:Run();
        Addon.SOCIAL:UnregisterEvent( 'ADDON_LOADED' );
    end
end );