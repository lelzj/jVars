local _, Addon = ...;

Addon.DB = CreateFrame( 'Frame' );
Addon.DB:RegisterEvent( 'ADDON_LOADED' );
Addon.DB:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module defaults
        --
        --  @return table
        Addon.DB.GetDefaults = function( self )
            local Defaults = {
                Debug = false,
                Modified = {
                    Total = 0,
                },
                ModifiedOnly = false,
                ReloadUI = false,
                ReloadGX = false,
                ReloadOnImport = true,
                Refresh = true,
                Vars = {},
                Theme = 'Sex',
            };
            -- Flag missing C_Console.GetAllCommands vars
            for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do
                local Dict = Addon.DICT:GetDictionary()[ string.lower( VarName ) ] or {
                    CurrentValue = nil,
                    Missing = true,
                };

                Defaults.Vars[ string.lower( VarName ) ] = {
                    Protected = VarData.Protected or nil,
                    Missing = Dict.Missing or false,
                    Cascade = VarData.Cascade or {},
                    Value = Dict.CurrentValue,
                };
            end
            return Defaults;
        end

        --
        --  Get module persistence
        --
        --  @return table
        Addon.DB.GetPersistence = function( self )
            if( not self.db ) then
                return;
            end

            self.persistence = self.db.global;
            if( not self.persistence ) then
                return;
            end
            return self.persistence;
        end

        Addon.DB.GetMissing = function( self,Index )
            if( self:GetPersistence().Vars[ string.lower( Index ) ] ) then
                return self:GetPersistence().Vars[ string.lower( Index ) ].Missing or false;
            end
        end

        Addon.DB.GetModified = function( self,Index )
            if( self:GetPersistence().Vars[ string.lower( Index ) ] ) then
                return self:GetPersistence().Vars[ string.lower( Index ) ].Modified;
            end
        end

        --
        --  Set cvar setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return bool
        Addon.DB.SetVarValue = function( self,Index,Value )
            if( InCombatLockdown() ) then
                return false;
            end
            if( Addon.REG:GetRegistry()[ string.lower( Index ) ] ) then
                if( Addon.REG:GetRegistry()[ string.lower( Index ) ].Type == 'Toggle' ) then
                    if( type( Value ) == 'boolean' ) then
                        self:GetPersistence().Vars[ string.lower( Index ) ].Value = Addon:BoolToInt( Value );
                    else
                        self:GetPersistence().Vars[ string.lower( Index ) ].Value = Value;
                    end
                else
                    self:GetPersistence().Vars[ string.lower( Index ) ].Value = Value;
                end
            end
            if( Addon.REG:GetRegistry()[ string.lower( Index ) ] ) then
                if( Addon.REG:GetRegistry()[ string.lower( Index ) ].Type == 'Toggle' ) then
                    if( tonumber( self:GetPersistence().Vars[ string.lower( Index ) ].Value ) ~= tonumber( Addon.DICT:GetDictionary()[ string.lower( Index ) ].DefaultValue ) ) then
                        self:GetPersistence().Vars[ string.lower( Index ) ].Modified = true;
                        self:GetPersistence().Modified.Total = self:GetPersistence().Modified.Total + 1;
                    else
                        self:GetPersistence().Vars[ string.lower( Index ) ].Modified = false;
                        self:GetPersistence().Modified.Total = self:GetPersistence().Modified.Total - 1;
                    end
                else

                    if( tostring( self:GetPersistence().Vars[ string.lower( Index ) ].Value ) ~= tostring( Addon.DICT:GetDictionary()[ string.lower( Index ) ].DefaultValue ) ) then
                        self:GetPersistence().Vars[ string.lower( Index ) ].Modified = true;
                        self:GetPersistence().Modified.Total = self:GetPersistence().Modified.Total + 1;
                    else
                        self:GetPersistence().Vars[ string.lower( Index ) ].Modified = false;
                        self:GetPersistence().Modified.Total = self:GetPersistence().Modified.Total - 1;
                    end
                end
            end
            return true;
        end

        --
        --  Get cvar setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.DB.GetVarValue = function( self,Index )
            if( self:GetPersistence().Vars[ string.lower( Index ) ].Value ~= nil ) then
                return self:GetPersistence().Vars[ string.lower( Index ) ].Value;
            end; return GetCVar( Index );
        end

        --
        --  Set module setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return bool
        Addon.DB.SetValue = function( self,Index,Value )
            if( self:GetPersistence()[Index] ~= nil ) then
                self:GetPersistence()[Index] = Value;
                return true;
            end; return false;
        end

        --
        --  Get module setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.DB.GetValue = function( self,Index )
            if( self:GetPersistence()[Index] ~= nil ) then
                return self:GetPersistence()[Index];
            end
        end

        Addon.DB.Reset = function( self )
            if( not self.db ) then
                return;
            end
            self.db:ResetDB();
        end

        --
        --  Module init
        --
        --  @return void
        Addon.DB.Init = function( self )
            self.db = LibStub( 'AceDB-3.0' ):New( AddonName,{ global = self:GetDefaults() },true );
            if( not self.db ) then
                return;
            end

            if( not self:GetPersistence() ) then
                return;
            end
            --[[
            for i,v in pairs( self:GetPersistence().Vars ) do
                if( i:find( 'nameplateotheratbase' ) ) then
                    Addon:Dump({
                        i = i,
                        v = v,
                    })
                end
                if( i:find( 'nameplatepersonalshowalways' ) ) then
                    Addon:Dump({
                        i = i,
                        v = v,
                    })
                end
            end
            ]]
            --self:GetPersistence().Vars = self:GetDefaults().Vars;
            --self:Reset();

            for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do
                if( Addon.DICT:GetDictionary()[ string.lower( VarName ) ] ) then
                    self:GetPersistence().Vars[ string.lower( VarName ) ].Dictionary = Addon.DICT:GetDictionary()[ string.lower( VarName ) ];

                    if( tostring( self:GetPersistence().Vars[ string.lower( VarName ) ].Value ) == tostring( Addon.DICT:GetDictionary()[ string.lower( VarName ) ].DefaultValue ) ) then
                         self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = false;
                    else
                        if( VarData.Type == 'Toggle' ) then
                            if( tonumber( self:GetPersistence().Vars[ string.lower( VarName ) ].Value ) ~= tonumber( Addon.DICT:GetDictionary()[ string.lower( VarName ) ].DefaultValue ) ) then
                                self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = true;
                            end
                        else
                            if( self:GetPersistence().Vars[ string.lower( VarName ) ].Value ~= Addon.DICT:GetDictionary()[ string.lower( VarName ) ].DefaultValue ) then
                                self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = true;
                            end
                        end
                    end
                end
            end
        end

        Addon.DB:UnregisterEvent( 'ADDON_LOADED' );
    end
end );