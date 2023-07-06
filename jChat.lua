local _, Addon = ...;

Addon.CHAT = CreateFrame( 'Frame' );
Addon.CHAT:RegisterEvent( 'ADDON_LOADED' )
Addon.CHAT.FistColInset = 15;
Addon.CHAT.RegisteredFrames = {};
Addon.CHAT:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.CHAT.GetDefaults = function( self )
            local Defaults = {
                colorChatNamesByClass = GetCVar( 'colorChatNamesByClass' ),
                guildMemberNotify = GetCVar( 'guildMemberNotify' ),
                profanityfilter = GetCVar( 'profanityfilter' ),
                showToastBroadcast = GetCVar( 'showToastBroadcast' ),
                showToastWindow = GetCVar( 'showToastWindow' ),
                showToastOffline = GetCVar( 'showToastOffline' ),
                showToastOnline = GetCVar( 'showToastOnline' ),
                spamFilter = GetCVar( 'spamFilter' ),
            };
            for i,v in pairs( Defaults ) do
                Defaults[ string.lower( i ) ] = v;
            end
            return Defaults;
        end

        --
        --  Set module setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return void
        Addon.CHAT.SetValue = function( self,Index,Value )
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
        Addon.CHAT.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.CHAT.FrameRegister = function( self,FrameData )
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

        Addon.CHAT.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.CHAT.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.CHAT.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.CHAT.Filter = function( self,SearchQuery )
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
        Addon.CHAT.CreateFrames = function( self )
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( 'jChat' ),{
                type = 'group',
                name = 'jChat',
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( 'jChat' ),'jChat','jVars' );
            self.Config.Name = 'jChat';
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.CHAT.Refresh = function( self )
            if( not Addon.CHAT.persistence ) then
                return;
            end
            for VarName,VarData in pairs( self.RegisteredVars ) do
                if( self.persistence[ string.lower( VarName ) ] ~= nil ) then
                    SetCVar( string.lower( VarName ),self.persistence[ string.lower( VarName ) ] );
                end
            end
            self:ColorNames();
        end

        --
        --  Module reset
        --
        --  @return void
        Addon.CHAT.ResetDb = function( self )
            self.db:ResetDB();
        end

        Addon.CHAT.ColorNames = function( self )
            if( self.persistence[ string.lower( 'colorChatNamesByClass' ) ] ~= nil ) then
                if( self.persistence[ string.lower( 'colorChatNamesByClass' ) ] ) then
                    SetCVar( 'chatClassColorOverride',0 );
                else
                    SetCVar( 'chatClassColorOverride',1 );
                end
            end
        end

        --
        --  Module init
        --
        --  @return void
        Addon.CHAT.Init = function( self )
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
            };
            self.RegisteredVars = {};
            for VarName,VarData in pairs( RegisteredVars ) do
                if( Addon.VARS.Dictionary[ string.lower( VarName ) ] ) then
                    VarData.Description = Addon.VARS.Dictionary[ string.lower( VarName ) ].Description;
                    VarData.DisplayText = Addon.VARS.Dictionary[ string.lower( VarName ) ].DisplayText;
                end
                VarData.Name = string.lower( VarName );
                self.RegisteredVars[ string.lower( VarName ) ] = VarData;
            end
            self.db = LibStub( 'AceDB-3.0' ):New( 'jChat',{ profile = self:GetDefaults() },true );
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
        --  Module run
        --
        --  @return void
        Addon.CHAT.Run = function( self )
            self.ScrollChild = Addon.GRID:RegisterGrid( self.Config,self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox','jChatChatFilter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.CHAT:ShowAll();
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
                Addon.CHAT:ShowAll();
                Addon.CHAT:Filter( self:GetText(),Addon.CHAT );
            end );
        end

        Addon.CHAT:Init();
        Addon.CHAT:CreateFrames();
        Addon.CHAT:Refresh();
        Addon.CHAT:Run();
        Addon.CHAT:UnregisterEvent( 'ADDON_LOADED' );
    end
end );