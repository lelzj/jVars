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

                Addon.ACTIONBAR:Init();
                Addon.ACTIONBAR:Refresh();

                Addon.CHAT:Init();
                Addon.CHAT:Refresh();

                Addon.MAP:Init();
                Addon.MAP:Refresh();

                Addon.NAME:Init();
                Addon.NAME:Refresh();

                Addon.RAID:Init();
                Addon.RAID:Refresh();

                Addon.SOUND:Init();
                Addon.SOUND:Refresh();

                Addon.SYSTEM:Init();
                Addon.SYSTEM:Refresh();

                Addon.DEBUG:Init();
                Addon.DEBUG:Refresh();
                RestartGx();
            end

            self.Config.default = function( self )

                Addon.ACTIONBAR:ResetDb();
                Addon.ACTIONBAR:Init();
                Addon.ACTIONBAR:Refresh();

                Addon.CHAT:ResetDb();
                Addon.CHAT:Init();
                Addon.CHAT:Refresh();

                Addon.MAP:ResetDb();
                Addon.MAP:Init();
                Addon.MAP:Refresh();

                Addon.NAME:ResetDb();
                Addon.NAME:Init();
                Addon.NAME:Refresh();

                Addon.RAID:ResetDb();
                Addon.RAID:Init();
                Addon.RAID:Refresh();

                Addon.SOUND:ResetDb();
                Addon.SOUND:Init();
                Addon.SOUND:Refresh();

                Addon.SYSTEM:ResetDb();
                Addon.SYSTEM:Init();
                Addon.SYSTEM:Refresh();

                Addon.DEBUG:ResetDb();
                Addon.DEBUG:Init();
                Addon.DEBUG:Refresh();
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
            self.Dictionary,self.Modules = {},{};
            for i,Row in pairs( C_Console.GetAllCommands() ) do
                Row.DisplayText = Row.command;
                Row.command = string.lower( Row.command );
                local CurrentValue,DefaultValue,AccountWide,PerCharacter,_,Secure,ReadOnly = GetCVarInfo( Row.command );
                self.Dictionary[ Row.command ] = {
                    CurrentValue    = CurrentValue,
                    DefaultValue    = DefaultValue,
                    DisplayText     = Row.DisplayText,
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