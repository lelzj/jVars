local _, Addon = ...;

Addon.ACTIONBAR = CreateFrame( 'Frame' );
Addon.ACTIONBAR:RegisterEvent( 'ADDON_LOADED' )
Addon.ACTIONBAR.FistColInset = 15;
Addon.ACTIONBAR.RegisteredFrames = {};
Addon.ACTIONBAR:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.ACTIONBAR.GetDefaults = function( self )
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
        Addon.ACTIONBAR.SetValue = function( self,Index,Value )
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
        Addon.ACTIONBAR.GetValue = function( self,Index )
            if( self.persistence[ string.lower( Index ) ] ~= nil ) then
                return self.persistence[ string.lower( Index ) ];
            end
        end

        Addon.ACTIONBAR.FrameRegister = function( self,FrameData )
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

        Addon.ACTIONBAR.ShowAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Show();
            end
        end

        Addon.ACTIONBAR.HideAll = function( self )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                FrameData.Frame:Hide();
            end
        end

        Addon.ACTIONBAR.GetRegisteredFrame = function( self,Name )
            for i,FrameData in pairs( self.RegisteredFrames ) do
                if( FrameData.Name == Name ) then
                    return FrameData.Frame;
                end
            end
        end

        Addon.ACTIONBAR.Filter = function( self,SearchQuery )
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
        Addon.ACTIONBAR.CreateFrames = function( self )
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
        Addon.ACTIONBAR.Refresh = function( self )
            if( not Addon.ACTIONBAR.persistence ) then
                return;
            end
            for VarName,VarData in pairs( self.RegisteredVars ) do
                if( self.persistence[ string.lower( VarName ) ] ~= nil ) then
                    SetCVar( string.lower( VarName ),self.persistence[ string.lower( VarName ) ] );
                end
            end
        end

        --
        --  Module reset
        --
        --  @return void
        Addon.ACTIONBAR.ResetDb = function( self )
            self.db:ResetDB();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.ACTIONBAR.Init = function( self )
            self.Name = 'jActionBar';
            local RegisteredVars = {
                alwaysShowActionBars = {
                    Type = 'Toggle',
                },
                LockActionBars = {
                    Type = 'Toggle',
                },
                multiBarRightVerticalLayout = {
                    Type = 'Toggle',
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
        end

        --
        --  Module run
        --
        --  @return void
        Addon.ACTIONBAR.Run = function( self )
            self.ScrollChild = Addon.GRID:RegisterGrid( self.RegisteredVars,self );

            self.FilterBox = CreateFrame( 'EditBox',self.Name..'ChatFilter',self.ScrollChild,'SearchBoxTemplate' );
            self.FilterBox:SetPoint( 'topleft',self.ScrollChild,'topleft',self.FistColInset,-35 );
            self.FilterBox:SetSize( 200,20 );
            self.FilterBox.clearButton:Hide();
            self.FilterBox:ClearFocus();
            self.FilterBox:SetAutoFocus( false );
            self.FilterBox:SetScript( 'OnEscapePressed',function( self )
                Addon.ACTIONBAR:ShowAll();
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
                Addon.ACTIONBAR:ShowAll();
                Addon.ACTIONBAR:Filter( self:GetText(),Addon.ACTIONBAR );
            end );
        end

        Addon.ACTIONBAR:Init();
        Addon.ACTIONBAR:CreateFrames();
        Addon.ACTIONBAR:Refresh();
        Addon.ACTIONBAR:Run();
        Addon.ACTIONBAR:UnregisterEvent( 'ADDON_LOADED' );
    end
end );