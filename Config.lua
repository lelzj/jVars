local _, Addon = ...;

Addon.CONFIG = CreateFrame( 'Frame' );
Addon.CONFIG:RegisterEvent( 'ADDON_LOADED' );
Addon.CONFIG:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module settings
        --
        --  @return table
        Addon.CONFIG.GetSettings = function( self )
            local function GetVars()

                local Order = 1;
                local Settings = {
                    Alerts = {
                        type = 'header',
                        order = Order,
                        name = 'Custom CVars',
                    },
                };

                local AllData = {};
                for VarName,VarData in pairs( Addon.REG:GetRegistry() ) do

                    local Key = string.lower( VarName );
                    local Value = Addon.APP:GetVarValue( Key );
                    local Flagged = Addon.DB:GetFlagged( Key );
                    local Dict = Addon.DICT:GetDictionary()[ Key ];

                    if( not Flagged ) then
                        AllData[ Key ] = {
                            DisplayText = Dict.DisplayText,
                            Description = Dict.Description,
                            DefaultValue = Dict.DefaultValue,
                            Type = VarData.Type,                -- Toggle, Range, Select, etc
                            Flagged = Flagged,                  -- Not appearing in list of client commands
                            Cascade = VarData.Cascade,          -- Dependencies that need to fire when value changes
                            Name = Key,
                            Value = Value,
                            Scope = Dict.Scope,                 -- Character, Account, Locked, Unknown
                            Step = VarData.Step,                -- How much to dec/increment
                            KeyPairs = VarData.KeyPairs,
                            Category = VarData.Category,
                            Dict = Dict,                        -- Dictionary entry
                        };
                    end
                    --[[
                    if( AllData[ Key ].Dict.Secure ) then
                        Addon:Dump( AllData[ Key ] );
                    end
                    ]]

                    for VarName,VarData in Addon:Sort( AllData ) do
                        Order = Order+1;
                        Settings[ VarName ] = {
                            order = Order,
                            name = VarData.DisplayText,
                            desc = VarData.Description,
                            arg = VarName,
                        };
                        if( VarData.Type == 'Range' ) then
                            Settings[ VarName ].max = VarData.KeyPairs.High.Value;
                            Settings[ VarName ].min = VarData.KeyPairs.Low.Value;
                            Settings[ VarName ].step = VarData.Step;
                        elseif( VarData.Type == 'Select' ) then
                            local KeyPairs = {};
                            for _,Key in pairs( VarData.KeyPairs ) do
                                KeyPairs[ Key.Value ] = Key.Description;
                            end
                            Settings[ VarName ].values = KeyPairs;
                        end
                        if( VarData.Type == 'Toggle' ) then
                            Settings[ VarName ].type = 'toggle';
                        elseif( VarData.Type == 'Range' ) then
                            Settings[ VarName ].type = 'range';
                        elseif( VarData.Type == 'Select' ) then
                            Settings[ VarName ].type = 'select';
                        elseif( VarData.Type == 'Edit' ) then
                            Settings[ VarName ].type = 'input';
                        end



                    if( VarName:find( 'findyourself' ) ) then
                                Addon:Dump( Settings[ VarName ] )
                    end
                    end
                end

                return Settings;
            end
            local function GetGeneral()
                local Order = 1;
                local Settings = {
                    General = {
                        type = 'header',
                        order = Order,
                        name = 'General',
                    },
                };
                Order = Order+1;
                Settings.Refresh = {
                    type = 'toggle',
                    order = Order,
                    name = 'Refresh',
                    desc = 'Apply settings on each reload',
                    arg = 'Refresh',
                    get = function( Info )
                        return Addon.APP:GetValue( Info.arg );
                    end,
                    set = function( Info,Value )
                        Addon.APP:SetValue( Info.arg,Value );
                    end,
                };
                Order = Order+1;
                Settings.ReloadUI = {
                    type = 'toggle',
                    order = Order,
                    name = 'ReloadUI',
                    desc = 'Reload UI for each update',
                    arg = 'ReloadUI',
                };
                Order = Order+1;
                Settings.ReloadGX = {
                    type = 'toggle',
                    order = Order,
                    name = 'ReloadGX',
                    desc = 'Reload GX for each update',
                    arg = 'ReloadGX',
                };
                Order = Order+1;
                Settings.Debug = {
                    type = 'toggle',
                    order = Order,
                    name = 'Debug',
                    desc = 'Output update information',
                    arg = 'Debug',
                };

                return Settings;
            end
            local Settings = {
                type = 'group',
                get = function( Info )
                    local Value = Addon.APP:GetVarValue( Info.arg );
                    if( tonumber( Value ) == 0 or tonumber( Value ) == 1 ) then
                        if( tonumber( Value ) > 0 ) then
                            Value = true;
                        else
                            Value = false;
                        end
                    else
                        Value = Value;
                    end
                    return Value;
                end,
                set = function( Info,Value )
                    Addon.APP:SetVarValue( Info.arg,Value );
                end,
                name = 'jVars Settings',
                desc = 'Simple cvar editor',
                childGroups = 'tab',
                args = {
                },
            };
            local Order = 1;
            Settings.args[ 'tab'..Order ] = {
                type = 'group',
                name = 'Custom CVars',
                width = 'full',
                order = Order,
                args = GetVars(),
            };

            Order = Order+1;
            Settings.args[ 'tab'..Order ] = {
                type = 'group',
                name = 'General',
                width = 'full',
                order = Order,
                args = GetGeneral(),
                get = function( Info )
                    return Addon.APP:GetValue( Info.arg );
                end,
                set = function( Info,Value )
                    Addon.APP:SetValue( Info.arg,Value );
                end,
            };

            return Settings;
        end

        --
        --  Create module config frames
        --
        --  @return void
        Addon.CONFIG.CreateFrames = function( self )

            -- Initialize window
            local AppName = string.upper( AddonName );
            local BlizOptions = LibStub( 'AceConfigDialog-3.0' ).BlizOptions;
            if( not BlizOptions[ AppName ] ) then
                BlizOptions[ AppName ] = {};
            end
            local Key = AppName;
            if( not BlizOptions[ AppName ][ Key ] ) then
                self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( AppName,AddonName );

                LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( AppName,self:GetSettings() );
            end

            hooksecurefunc( self.Config,'OnCommit',function()
                -- handle like window close...
            end );

            hooksecurefunc( self.Config,'OnRefresh',function()
                -- handle like window open...
            end );

            hooksecurefunc( self.Config,'OnDefault',function()
                --print( 'OnDefault',... )
                --Addon.CHAT.db:ResetDB();
            end );

        end

        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );