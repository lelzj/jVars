local _, Addon = ...;

Addon.VARS = CreateFrame( 'Frame' );
Addon.VARS:RegisterEvent( 'ADDON_LOADED' );
Addon.VARS:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Create module config frames
        --
        --  @return void
        Addon.VARS.CreateFrames = function( self )

            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( string.upper( AddonName ),{
                type = 'group',
                name = AddonName,
                args = {},
            } );
            self.Config = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( string.upper( AddonName ),AddonName );

            self.Config.okay = function( self )
                Addon.System:Refresh();
                RestartGx();
            end

            self.Config.default = function( self )
                Addon.System.db:ResetDB();
                Addon.System:Refresh();
                RestartGx();
            end
        end

        --
        --  Module refresh
        --
        --  @return void
        Addon.VARS.Refresh = function( self )
        end

        --
        --  Module init
        --
        --  @return void
        Addon.VARS.Init = function( self )
            self.Dictionary = {};
            for i,Row in pairs( C_Console.GetAllCommands() ) do
                Row.command = string.lower( Row.command );
                local CurrentValue,DefaultValue,AccountWide,PerCharacter,_,Secure,ReadOnly = GetCVarInfo( Row.command );
                self.Dictionary[ Row.command ] = {
                    CurrentValue    = CurrentValue,
                    DefaultValue    = DefaultValue,
                    ReadOnly        = ReadOnly,
                    Secure          = Secure,
                    Name            = Row.command,
                    Category        = Row.category,
                    Description     = Row.help,
                    AccountWide     = AccountWide,
                    PerCharacter    = PerCharacter,
                    scriptContents  = Row.scriptContents,
                };
            end
        end

        --
        --  Module run
        --
        --  @return void
        Addon.VARS.Run = function( self )
        end

        Addon.VARS:Init();
        Addon.VARS:CreateFrames();
        Addon.VARS:Refresh();
        Addon.VARS:Run();
        Addon.VARS:UnregisterEvent( 'ADDON_LOADED' );
    end
end );