local _,Addon = ...;

Addon.VIEW = CreateFrame( 'Frame' );

Addon.VIEW:RegisterEvent( 'ADDON_LOADED' );
Addon.VIEW:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        Addon.VIEW.GetModified = function( self,Data,Handler )
            return Handler:GetModified( Data,Handler );
        end
        Addon.VIEW.GetStats = function( self,Data,Handler )
            local Stats = {
                Locked = 0,
                Modified = 0,
                Total = 0,
            };
            for VarName,VarData in pairs( Data ) do
                if( VarData.Scope == 'Locked' ) then
                    Stats.Locked = Stats.Locked+1;
                end
                if( Addon.VIEW:GetModified( VarData,Handler ) ) then
                    Stats.Modified = Stats.Modified+1;
                end
                Stats.Total = Stats.Total+1;
            end

            self.AddRow = function( self,Data,Handler )

                local Row = CreateFrame( 'Frame',Handler.Stats:GetName()..'StatsRow',Handler.Stats );

                Row.LockedLabel = Addon.FRAMES:AddLocked( { DisplayText = 'Locked' },Row );
                Row.LockedValue = Addon.FRAMES:AddLabel( { DisplayText = Data.Locked },Row );

                Row.ModifiedLabel = Addon.FRAMES:AddModified( { DisplayText = 'Modified,' },Row );
                Row.ModifiedValue = Addon.FRAMES:AddLabel( { DisplayText = Data.Modified },Row );

                Row.TotalLabel = Addon.FRAMES:AddLabel( { DisplayText = 'Total,' },Row );
                Row.TotalValue = Addon.FRAMES:AddLabel( { DisplayText = Data.Total },Row );


                Row.LockedLabel:SetPoint( 'topright',Handler.Stats,'topright',-10,-7 );
                Row.LockedValue:SetPoint( 'topright',Row.LockedLabel,'topleft',0,0 );

                Row.ModifiedLabel:SetPoint( 'topright',Row.LockedValue,'topleft',0,0 );
                Row.ModifiedValue:SetPoint( 'topright',Row.ModifiedLabel,'topleft',0,0 );

                Row.TotalLabel:SetPoint( 'topright',Row.ModifiedValue,'topleft',0,0 );
                Row.TotalValue:SetPoint( 'topright',Row.TotalLabel,'topleft',0,0 );

                local FrameData = {
                    Name        = Row:GetName(),
                    Frame       = Row,
                    Description = '',
                };
                Handler:FrameRegister( FrameData );

                return Row;
            end

            return self:AddRow( {
                Locked = Stats.Locked,
                Modified = Stats.Modified,
                Total = Stats.Total
            },Handler );
        end

        Addon.VIEW.RegisterList = function( self,Data,Handler )

            Handler:HideAll();
            Handler.RegisteredFrames = {};

            self.AddRow = function( Data,Parent,Handler )

                local Row = CreateFrame( 'Frame',string.lower( Data.Name ),Parent );

                Row:SetSize( Parent:GetWidth(),30 );
                if( Addon.VIEW:GetModified( Data,Handler ) ) then
                    Row.Label = Addon.FRAMES:AddModifiedTip( Data,Row );

                    local ScopeData = Data;
                    ScopeData.DisplayText = Data.Scope;
                    Row.Scope = Addon.FRAMES:AddModified( ScopeData,Row );

                    local CategoryData = Data;
                    CategoryData.DisplayText = Data.Category;
                    Row.Category = Addon.FRAMES:AddModified( CategoryData,Row );

                    local DefaultData = Data;
                    DefaultData.DisplayText = Data.DefaultValue;
                    Row.Default = Addon.FRAMES:AddModified( DefaultData,Row );
                    Row.Adjust = Addon.FRAMES:AddModified( Data,Row );
                elseif( Data.Scope == 'Locked' ) then
                    Row.Label = Addon.FRAMES:AddModifiedTip( Data,Row );

                    local ScopeData = Data;
                    ScopeData.DisplayText = Data.Scope;
                    Row.Scope = Addon.FRAMES:AddLocked( ScopeData,Row );

                    local CategoryData = Data;
                    CategoryData.DisplayText = Data.Category;
                    Row.Category = Addon.FRAMES:AddLocked( CategoryData,Row );

                    local DefaultData = Data;
                    DefaultData.DisplayText = Data.DefaultValue;
                    Row.Default = Addon.FRAMES:AddLocked( DefaultData,Row );
                    Row.Adjust = Addon.FRAMES:AddLocked( Data,Row );
                else
                    Row.Label = Addon.FRAMES:AddTip( Data,Row );

                    local ScopeData = Data;
                    ScopeData.DisplayText = Data.Scope;
                    Row.Scope = Addon.FRAMES:AddLabel( ScopeData,Row );

                    local CategoryData = Data;
                    CategoryData.DisplayText = Data.Category;
                    Row.Category = Addon.FRAMES:AddLabel( CategoryData,Row );

                    local Default = Data;
                    Default.DisplayText = Data.DefaultValue;
                    Row.Default = Addon.FRAMES:AddLabel( Default,Row );
                    Row.Adjust = Addon.FRAMES:AddLabel( Data,Row );
                end

                -- CVar
                Row.Label:SetPoint( 'topleft',Row,'topleft',Addon.APP.Heading.ColInset,-8 );
                Row.Label:SetSize( 180,Addon.APP.Heading.FieldHeight );
                Row.Label:SetJustifyH( 'right' );

                -- Scope
                Row.Scope:SetPoint( 'topleft',Row.Label,'topright',Addon.APP.Heading.ColInset,0 );
                Row.Scope:SetSize( 50,Addon.APP.Heading.FieldHeight );
                Row.Scope:SetJustifyH( 'left' );

                -- Category
                Row.Category:SetPoint( 'topleft',Row.Scope,'topright',Addon.APP.Heading.ColInset,0 );
                Row.Category:SetSize( 50,Addon.APP.Heading.FieldHeight );
                Row.Category:SetJustifyH( 'left' );

                -- Default Value
                Row.Default:SetPoint( 'topleft',Row.Category,'topright',Addon.APP.Heading.ColInset,0 );
                Row.Default:SetSize( 50,Addon.APP.Heading.FieldHeight );
                Row.Default:SetJustifyH( 'left' );

                -- Adjust
                if( Data.Type == 'Toggle' ) then
                    Row.Value = Addon.FRAMES:AddVarToggle( Data,Row,Handler );
                elseif( Data.Type == 'Range' ) then
                    Row.Value = Addon.FRAMES:AddRange( Data,Row,Handler );
                elseif( Data.Type == 'Select' ) then
                    Row.Value = Addon.FRAMES:AddSelect( Data,Row,Handler );
                elseif( Data.Type == 'Edit' ) then
                    Row.Value = Addon.FRAMES:AddEdit( Data,Row,Handler );
                end

                if( Data.Type == 'Select' ) then
                    Row.Value:SetPoint( 'topleft',Row.Default,'topright',-19,7 );
                elseif( Data.Type == 'Toggle' ) then
                    Row.Value:SetPoint( 'topleft',Row.Default,'topright',-5,5 );
                elseif( Data.Type == 'Range' ) then
                    Row.Value:SetPoint( 'topleft',Row.Default,'topright',0,5 );
                else
                    Row.Value:SetPoint( 'topleft',Row.Default,'topright',0,0 );
                end
                if( Data.Type ~= 'Toggle' ) then
                    Row.Value:SetSize( 150,Addon.APP.Heading.FieldHeight );
                end

                Row.Sep = Addon.FRAMES:AddSeperator( Row );
                Row.Sep:SetPoint( 'topleft',Row,'bottomleft',10,0 );
                return Row;
            end

            local Iterator = 1;
            local X,Y = 0,( Addon.APP.Heading.FieldHeight )*-1;
            local RowElements = {};
            for VarName,VarData in Addon:Sort( Data ) do
                local Row = self.AddRow( VarData,Handler.ScrollChild,Handler );

                --Row.Art = Row:CreateTexture( nil, 'ARTWORK', nil, 0 )
                --Row.Art:SetTexture( 'Interface\\Addons\\'..Addon.AddonName..'\\Libs\\jUI\\Textures\\frame' )
                --Row.Art:SetAllPoints( Row )

                if( not( #RowElements > 0 ) ) then
                    Row:SetPoint( 'topleft',Handler.ScrollChild,'topleft',X,Y );

                    RowElements[ Iterator ] = Row:GetName();

                else
                    Row:SetPoint( 'topleft',Handler.ScrollChild,'topleft',X,Y );

                    RowElements[ Iterator ] = Row:GetName();

                end

                Iterator = Iterator + 1;

                local FrameData = {
                    Name        = VarName,
                    Frame       = Row,
                    Description = VarData.Description or '',
                };
                Handler:FrameRegister( FrameData );

                Row:Show();
                Y = Y-Handler.RowHeight;
            end
        end
        
        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );