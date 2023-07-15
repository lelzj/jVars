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
                Modified = {
                    Total = 0,
                },
                Search = {
                    Query = nil,
                    Category = 'Game',
                    Direction = 'asc',
                },
                Reload = {
                    UI = false,
                    GX = true,
                },
                Vars = {},
            };
            for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do
                local Dict = Addon.DICT:GetDictionary()[ string.lower( VarName ) ] or {
                    CurrentValue = nil,
                    Flagged = true,
                };

                Defaults.Vars[ string.lower( VarName ) ] = {
                    Flagged = Dict.Flagged or false,
                    Value = Dict.CurrentValue,
                    Indexed = false,
                };
            end
            return Defaults;
        end

        --
        --  Get module persistence
        --
        --  @return table
        Addon.DB.GetPersistence = function( self )
            if( not self.persistence ) then
                return;
            end
            return self.persistence;
        end

        Addon.DB.GetFlagged = function( self,Index )
            if( self:GetPersistence().Vars[ string.lower( Index ) ] ) then
                return self:GetPersistence().Vars[ string.lower( Index ) ].Flagged;
            end
        end

        Addon.DB.GetModified = function( self,Index )
            if( self:GetPersistence().Vars[ string.lower( Index ) ] ) then
                return self:GetPersistence().Vars[ string.lower( Index ) ].Modified;
            end
        end

        --
        --  Set module setting
        --
        --  @param  string  Index
        --  @param  string  Value
        --  @return bool
        Addon.DB.SetValue = function( self,Index,Value )
            if( InCombatLockdown() ) then
                Addon.APP:Warn( 'Leave combat before updating' );
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
                    if( self:GetPersistence().Vars[ string.lower( Index ) ].Value ~= Addon.DICT:GetDictionary()[ string.lower( Index ) ].DefaultValue ) then
                        self:GetPersistence().Vars[ string.lower( Index ) ].Modified = true;
                        self:GetPersistence().Modified.Total = self:GetPersistence().Modified.Total + 1;
                    else
                        self:GetPersistence().Vars[ string.lower( Index ) ].Modified = false;
                        self:GetPersistence().Modified.Total = self:GetPersistence().Modified.Total - 1;
                    end
                end
            end
            Addon.APP:Notify( 'Updated',Addon.DICT:GetDictionary()[ string.lower( Index ) ].DisplayText,'to',self:GetPersistence().Vars[ string.lower( Index ) ].Value );
            return true;
        end

        --
        --  Get module setting
        --
        --  @param  string  Index
        --  @return mixed
        Addon.DB.GetValue = function( self,Index )
            if( self:GetPersistence().Vars[ string.lower( Index ) ].Value ~= nil ) then
                return self:GetPersistence().Vars[ string.lower( Index ) ].Value;
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
            self.db = LibStub( 'AceDB-3.0' ):New( AddonName,{ profile = self:GetDefaults() },true );
            if( not self.db ) then
                return;
            end
            self.persistence = self.db.profile;
            if( not self.persistence ) then
                return;
            end
            for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do
                if( self:GetPersistence().Vars[ string.lower( VarName ) ] and not self:GetPersistence().Vars[ string.lower( VarName ) ].Indexed ) then
                    if( Addon.DICT:GetDictionary()[ string.lower( VarName ) ] ) then
                        if( VarData.Type == 'Toggle' ) then
                            if( tonumber( self:GetPersistence().Vars[ string.lower( VarName ) ].Value ) ~= tonumber( Addon.DICT:GetDictionary()[ string.lower( VarName ) ].DefaultValue ) ) then
                                self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = true;
                            else
                                self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = false
                            end
                        else
                            if( self:GetPersistence().Vars[ string.lower( VarName ) ].Value ~= Addon.DICT:GetDictionary()[ string.lower( VarName ) ].DefaultValue ) then
                                self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = true;
                            else
                                self:GetPersistence().Vars[ string.lower( VarName ) ].Modified = false;
                            end
                        end
                    end
                    self:GetPersistence().Vars[ string.lower( VarName ) ].Indexed = true;
                end
            end
        end

        Addon.DB:Init();
        Addon.DB:UnregisterEvent( 'ADDON_LOADED' );
    end
end );