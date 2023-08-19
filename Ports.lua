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
                    Data = Data..string.lower( VarName )..':'..VarData.Value..';';
                end
            end; 
            return Data;
        end

        

        --
        --  Module implode
        --
        --  @return table
        Addon.PORTS.Implode = function( self,Input )
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
            local Data = self:Implode( Input );

            for I,V in pairs( Data ) do
                if( Addon.DB:GetDefaults().Vars[ string.lower( I ) ] == nil ) then
                    Valid = false;
                end
            end
            --[[
            for I,V in pairs( Addon.DB:GetDefaults().Vars ) do
                if( Data[ string.lower( I ) ] == nil ) then
                    Valid = false;
                end
            end
            ]]
            return Valid;
        end

        Addon.PORTS.Import = function( self,Input )
            Addon.VIEW:Notify( 'Importing...' );
            Addon.DB:GetPersistence().Vars = self:Implode( Input );
            Addon.DB:Init();
            --Addon.APP:Refresh();
            Addon:Dump( Addon.DB:GetPersistence().Vars )
            Addon.View:Notify( 'Done' );
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

            if( Addon:IsClassic() ) then
                self.Width = InterfaceOptionsFramePanelContainer:GetWidth()-35;
                self.Height = InterfaceOptionsFramePanelContainer:GetHeight()-25;
            else
                self.Width = SettingsPanel:GetWidth()-35;
                self.Height = SettingsPanel:GetHeight()-25;
            end

            self.Browser = CreateFrame( 'Frame',self.Name..'Browser'..'Ports',self.Config );
            self.Browser:SetSize( self.Width,self.Height );
            self.Browser:SetPoint( 'topleft',self.Config,'topleft',10,-10 );

            self.ScrollFrame = CreateFrame( 'ScrollFrame',self.Name..'ScrollFrame',self.Browser,'UIPanelScrollFrameTemplate' );
            self.ScrollFrame:SetPoint( 'topleft',self.Browser,'topleft',0,0 );
            self.ScrollFrame:SetSize( self.Width,self.Height );

            self.ScrollChild = CreateFrame( 'Frame',self.Name..'ScrollChild' );
            self.ScrollFrame:SetScrollChild( self.ScrollChild );
            self.ScrollChild:SetWidth( self.Width );
            self.ScrollChild:SetHeight( 20 );

            local Desc = 'Export current CVar setttings';
            self.ExportLabel = Addon.GRID:AddTip( {DisplayText='Export Settings',Description=Desc},self.ScrollChild );
            self.ExportLabel:SetPoint( 'topleft',self.ScrollChild,'topleft',0,0 );

            local Value = 'Exported CVar Settings will appear here';
            self.ExportText = Addon.GRID:AddMultiEdit( {Name='ExportText',Value=Value,Flagged=false},self.ScrollChild,self );
            self.ExportText:GetParent():ClearAllPoints();
            self.ExportText:GetParent():SetPoint( 'topleft',self.ExportLabel,'bottomleft',0,-10 );
            self.ExportText:GetParent():SetSize( self.Width,100 );
            self.ExportText:SetSize( self.Width,100 );

            self.ExportButton = Addon.GRID:AddButton( {Name='Export',DisplayText='Export'},self.ScrollChild );
            self.ExportButton:SetPoint( 'topleft',self.ExportText:GetParent(),'bottomleft',0,-10 );
            self.ExportButton:SetSize( 100,20 );
            self.ExportButton:SetScript( 'OnClick',function( self )
                local Export = Addon.PORTS:Export();
                if( Export ) then
                    Addon.PORTS.ExportText:SetText( Export );
                end

                Addon.PORTS.ExportText:SetFocus( true );
                Addon.PORTS.ExportText:HighlightText();
            end );

            local Desc = 'Import CVar setttings';
            self.ImportLabel = Addon.GRID:AddTip( {DisplayText='Import Settings',Description=Desc},self.ScrollChild );
            self.ImportLabel:SetPoint( 'topleft',self.ExportButton,'bottomleft',0,-10 );

            local Value = 'Paste Import string here';
            self.ImportText = Addon.GRID:AddMultiEdit( {Name='ImportText',Value=Value,Flagged=false},self.ScrollChild,self );
            self.ImportText:GetParent():ClearAllPoints();
            self.ImportText:GetParent():SetPoint( 'topleft',self.ImportLabel,'bottomleft',0,-10 );
            self.ImportText:GetParent():SetSize( self.Width,100 );
            self.ImportText:SetSize( self.Width,100 );

            self.ImportButton = Addon.GRID:AddButton( {Name='Import',DisplayText='Import'},self.ScrollChild );
            self.ImportButton:SetPoint( 'topleft',self.ImportText:GetParent(),'bottomleft',0,-10 );
            self.ImportButton:SetSize( 100,20 );
            self.ImportButton:SetScript( 'OnClick',function( self )
                local Valid = Addon.PORTS:Validate( Addon.PORTS.ImportText:GetText() );
                if( Valid ) then
                    Addon.VIEW:Notify( 'Valid' );
                else
                    Addon.VIEW:Error( 'Invalid' );
                end

                if( Valid ) then
                    Addon.PORTS:Import( Addon.PORTS.ImportText:GetText() );
                end
            end );
        end
        self:Init();
    end
end );