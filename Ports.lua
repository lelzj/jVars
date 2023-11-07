local _, Addon = ...;

Addon.PORTS = CreateFrame( 'Frame' );
Addon.PORTS:RegisterEvent( 'ADDON_LOADED' );
Addon.PORTS:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Module export
        --
        --  @return string
        Addon.PORTS.Export = function( self )
            local Data = '';
            for VarName,VarData in pairs( Addon.DB:GetPersistence().Vars ) do
                if( VarName and VarData.Value ) then
                    Data = Data..string.lower( VarName )..'::'..VarData.Value..';;';
                end
            end; 
            return Data;
        end

        --
        --  Module implode
        --
        --  @return table
        Addon.PORTS.Explode = function( self,Input )
            local VarData = {};
            
            local Vars = Addon:Explode( Input,';' );

            for _,Var in pairs( Vars ) do
                local Data = Addon:Explode( Var,':' );
                VarData[ string.lower( Data[1] ) ] = Data[2];
            end
            return VarData;
        end

        --
        --  Module validate
        --
        --  @return bool
        Addon.PORTS.Validate = function( self,Input )

            local Valid = true;
            local Lines = Addon:Explode( Input,';;' );
            for _,Line in pairs( Lines ) do
                local Data = Addon:Explode( Line,'::' );
                Addon:Dump( Data )
                for _,Index in pairs( Data ) do
                    if( Index and Index ~= '' ) then
                        if( Addon.REG:GetRegistry()[ string.lower( Index ) ] == nil ) then
                            Valid = false;
                        end
                    end
                end
            end
            return Valid;
        end

        --
        --  Module import
        --
        --  @return void
        Addon.PORTS.Import = function( self,Input )
            Addon.FRAMES:Notify( 'Importing...' );
            --Addon:Dump( self:Explode( Input ) );
            --Addon.DB:GetPersistence().Vars = self:Implode( Input );
            --Addon.DB:Init();
            --Addon.APP:Refresh();
            --Addon:Dump( Addon.DB:GetPersistence().Vars )
            Addon.FRAMES:Notify( 'Done' );
        end

        --
        --  Module init
        --
        --  @return void
        Addon.PORTS.Init = function( self )

            self.Name = AddonName;

            self.Config = CreateFrame( 'Frame','Ports' );
            self.Config.parent = self.Name;
            self.Config.name = 'Ports';

            self.Config.okay = function( self )
                RestartGx();
            end

            self.Config.default = function( self )
                Addon.DB:Reset();
                RestartGx();
            end

            InterfaceOptions_AddCategory( self.Config,self.Name );
            --https://wowpedia.fandom.com/wiki/Using_the_Interface_Options_Addons_panel
            --[[SettingsPanel
            SettingsPanel.Container
            SettingsPanel.Container.SettingsList
            SettingsPanel.Container.SettingsList.ScrollBox]]

            if( Addon:IsClassic() ) then
                self.Height = InterfaceOptionsFramePanelContainer:GetHeight();
            else
                self.Height = SettingsPanel.Container.SettingsList.ScrollBox:GetHeight();
            end

            self.Browser = CreateFrame( 'Frame',self.Name..'Browser'..'Ports',self.Config );
            self.Browser:SetSize( 610,self.Height );
            self.Browser:SetPoint( 'topleft',self.Config,'topleft',10,-10 );

            self.ScrollFrame = CreateFrame( 'ScrollFrame',self.Name..'ScrollFrame',self.Browser,'UIPanelScrollFrameTemplate' );
            self.ScrollFrame:SetPoint( 'topleft',self.Browser,'topleft',0,0 );
            self.ScrollFrame:SetSize( 610,self.Height );

            self.ScrollChild = CreateFrame( 'Frame',self.Name..'ScrollChild' );
            self.ScrollFrame:SetScrollChild( self.ScrollChild );
            self.ScrollChild:SetWidth( 610 );
            self.ScrollChild:SetHeight( 20 );

            local Desc = 'Export current CVar setttings';
            self.ExportLabel = Addon.FRAMES:AddTip( {DisplayText='Export Settings',Description=Desc},self.ScrollChild );
            self.ExportLabel:SetPoint( 'topleft',self.ScrollChild,'topleft',0,0 );

            local Value = 'Exported CVar Settings will appear here';
            self.ExportText = Addon.FRAMES:AddMultiEdit( {Name='ExportText',Value=Value,Flagged=false},self.ScrollChild,self );
            self.ExportText:GetParent():ClearAllPoints();
            self.ExportText:GetParent():SetPoint( 'topleft',self.ExportLabel,'bottomleft',0,-10 );
            self.ExportText:GetParent():SetSize( 610,100 );
            self.ExportText:SetSize( 610,100 );
            local Export = Addon.PORTS:Export();
            if( Export ) then
                Addon.PORTS.ExportText:SetText( Export );
            end

            local Desc = 'Import CVar setttings';
            self.ImportLabel = Addon.FRAMES:AddTip( {DisplayText='Import Settings',Description=Desc},self.ScrollChild );
            self.ImportLabel:SetPoint( 'topleft',self.ExportText:GetParent(),'bottomleft',0,-10 );

            local Value = 'Paste Import string here';
            self.ImportText = Addon.FRAMES:AddMultiEdit( {Name='ImportText',Value=Value,Flagged=false},self.ScrollChild,self );
            self.ImportText:GetParent():ClearAllPoints();
            self.ImportText:GetParent():SetPoint( 'topleft',self.ImportLabel,'bottomleft',0,-10 );
            self.ImportText:GetParent():SetSize( 610,100 );
            self.ImportText:SetSize( 610,100 );

            self.ImportButton = Addon.FRAMES:AddButton( {Name='Import',DisplayText='Import'},self.ScrollChild );
            self.ImportButton:SetPoint( 'topleft',self.ImportText:GetParent(),'bottomleft',0,-10 );
            self.ImportButton:SetSize( 100,20 );
            self.ImportButton:SetScript( 'OnClick',function( self )
                local Valid = Addon.PORTS:Validate( Addon.PORTS.ImportText:GetText() );
                if( not Valid ) then
                    Addon.FRAMES:Error( 'Invalid! Must be format: Var:Val;' );
                    return;
                end
                Addon.PORTS:Import( Addon.PORTS.ImportText:GetText() );
            end );
        end
        self:Init();
    end
end );