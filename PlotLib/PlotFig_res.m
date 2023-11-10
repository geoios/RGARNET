function PlotFig_res(FigSet)
[DataLine,DataRow]= size(FigSet.Data);
%% draw
figure('visible','off')
switch FigSet.SubplotModel
    case 'solo'
        for DataNum = 1:DataRow
            X = FigSet.Data{DataNum}(:,1);
            Y = FigSet.Data{DataNum}(:,2);
            
            switch FigSet.PlotModel
                case 'line'
                    LineType = FigSet.LineType{DataNum};
                    plot(X,Y,LineType,'lineWidth',FigSet.lineWidth);
                case 'point'
                    PointType = FigSet.PointType{DataNum};
                    plot(X,Y,PointType,'MarkerSize',FigSet.MarkerSize,'MarkerFaceColor',PointType(2));
                case 'pointcolorbar'
                    Z = FigSet.Data{DataNum}(:,3);
                    scatter(X,Y,FigSet.ScatterSize,Z,'filled');
            end
            hold on
        end
        % Set Title
        if isfield(FigSet,'title')
            hTitle = title(FigSet.title,'FontSize',FigSet.FontSize);
        end
        if isfield(FigSet,'global')
            set(gca,'FontSize',FigSet.global.FontSize,'Fontname', FigSet.global.Fontname,...
                'linewidth',FigSet.global.linewidth,'FontWeight','bold','tickdir','in');
        end
        % Set coordinate axis
        hXLabel = xlabel(FigSet.xlabelName,'FontSize',FigSet.Label.FontSize);
        hYLabel = ylabel(FigSet.ylabelName,'FontSize',FigSet.Label.FontSize);
        
        if isfield(FigSet,'LabelLimit')
            [XLimitMin,XLimitMax] = deal(FigSet.LabelLimit.XLimit(1),FigSet.LabelLimit.XLimit(2));
            [YLimitMin,YLimitMax] = deal(FigSet.LabelLimit.YLimit(1),FigSet.LabelLimit.YLimit(2));
            axis([XLimitMin XLimitMax YLimitMin YLimitMax])
        end
        
        if isfield(FigSet,'Colorbar')
            c = colorbar();      % Gradient Color Bar
            colormap(FigSet.Colorbar.Colormap);
            c.Label.String = FigSet.Colorbar.Lable.String;
            c.Label.FontSize = FigSet.Label.FontSize;
            c.Label.FontName = FigSet.Label.FontName;
        end
        if isfield(FigSet,'Xticks')
            xticks(FigSet.Xticks.LableNum{1});xticklabels(FigSet.Xticks.LableStr{1})
        end
        
        % Is the coordinate axis reversed
        if isfield(FigSet,'LabelDir')
            set(gca,FigSet.LabelDir,'reverse');
        end
        
        % Legend Settings
        if isfield(FigSet,'legendName')
            legend(FigSet.legendName,'FontSize',FigSet.FontSize,...
                'Location',FigSet.Location,'Box','off');
        end
        
        if isfield(FigSet,'Frame')
            switch FigSet.Frame
                case 'grid'
                    grid on
                case 'axis'
                    axis square
            end
        end
        
        
    case 'biax'
        X1 = FigSet.Data{1}(:,1);Y1 = FigSet.Data{1}(:,2);
        X2 = FigSet.Data{2}(:,1);Y2 = FigSet.Data{2}(:,2);
        a = plotyy(X1,Y1,X2,Y2,'plot');
        xlabel(FigSet.xlabelName,'FontSize',FigSet.Label.FontSize);
        set(a,'FontSize',FigSet.Label.FontSize)
        set(get(a(1),'Ylabel'),'String',FigSet.ylabelName{1},'FontSize',FigSet.Label.FontSize)
        set(get(a(2),'Ylabel'),'String',FigSet.ylabelName{2},'FontSize',FigSet.Label.FontSize)
        set(a(2),'ycolor','r')
        
    case 'subplot'
        [SubLine,SubRow] = deal(FigSet.SubComb(1),FigSet.SubComb(2));DataNum = 1;
        for DataLineNum = 1:DataLine
            
            for DataRowNum = 1:DataRow
                subplot(SubLine,SubRow,DataLineNum)
                if isempty(FigSet.Data{DataLineNum,DataRowNum})
                    continue;
                end
                X = FigSet.Data{DataLineNum,DataRowNum}(:,1);
                Y = FigSet.Data{DataLineNum,DataRowNum}(:,2);
                switch FigSet.PlotModel
                    case 'line'
                        LineType = FigSet.LineType{DataNum};
                        if isfield(FigSet,'PointSize')
                            PMarkerSize = FigSet.PointSize(DataNum);
                        else
                            PMarkerSize = FigSet.MarkerSize;
                        end
                        h = plot(X,Y,LineType,'lineWidth',FigSet.lineWidth,'MarkerSize',PMarkerSize);
                        if isfield(FigSet,'PointFull')
                            if FigSet.PointFull(DataNum)
                                set(h,'MarkerFaceColor',get(h,'color'));
                            end
                        end
                    case 'point'
                        PointType = FigSet.PointType{DataNum};
                        plot(X,Y,PointType,'MarkerSize',FigSet.MarkerSize);
                end
                hold on
                DataNum = DataNum + 1;
            end
            % Set Title
            if isfield(FigSet,'title')
                hTitle = title(FigSet.title{DataLineNum},'FontSize',FigSet.FontSize);
            end
            % Set global font format
            if isfield(FigSet,'global')
                set(gca,'FontSize',FigSet.global.FontSize,'Fontname', FigSet.global.Fontname,...
                    'linewidth',FigSet.global.linewidth,'FontWeight','bold','tickdir','in');
            end
            
            % Set coordinate axis
            hXLabel = xlabel(FigSet.xlabelName{DataLineNum},'FontSize',FigSet.Label.FontSize);
            hYLabel = ylabel(FigSet.ylabelName{DataLineNum},'FontSize',FigSet.Label.FontSize);
            
            if isfield(FigSet,'Xticks')
                if isempty(FigSet.Xticks.LableNum{DataLineNum})
                    set(gca,'xticklabel',[]);
                else
                    xticks(FigSet.Xticks.LableNum{DataLineNum});xticklabels(FigSet.Xticks.LableStr{DataLineNum})
                end
            end
            
            if isfield(FigSet,'LabelLimit')
            [XLimitMin,XLimitMax] = deal(FigSet.LabelLimit.XLimit(1),FigSet.LabelLimit.XLimit(2));
            [YLimitMin,YLimitMax] = deal(FigSet.LabelLimit.YLimit(1),FigSet.LabelLimit.YLimit(2));
                axis([XLimitMin XLimitMax YLimitMin YLimitMax])
            end
            % Legend Settings
            if isfield(FigSet,'legendName')
                if strcmpi(FigSet.legendType,'Inside')
                    legend(FigSet.legendName{DataLineNum,:},'FontSize',FigSet.FontSize,...
                        'Location',FigSet.Location,'Box','off');
                end
            end
            
            if isfield(FigSet,'Frame')
                switch FigSet.Frame
                    case 'grid'
                        grid on
                    case 'axis'
                        axis square
                end
            end
        end
    case 'tiledlayout'
        [SubLine,SubRow] = deal(FigSet.SubComb(1),FigSet.SubComb(2));
        tiledlayout(SubLine,SubRow)
        for DataLineNum = 1:DataLine
            for DataRowNum = 1:DataRow
                nexttile
                if isempty(FigSet.Data{DataLineNum,DataRowNum})
                    continue;
                end
                X = FigSet.Data{DataLineNum,DataRowNum}(:,1);
                Y = FigSet.Data{DataLineNum,DataRowNum}(:,2);
                switch FigSet.PlotModel
                    case 'pointcolorbar'
                        Z = FigSet.Data{DataLineNum,DataRowNum}(:,3);
                        scatter(X,Y,FigSet.ScatterSize,Z,'filled');
                end
                hold on
                
                % Set Title
                if isfield(FigSet,'title')
                    hTitle = title(FigSet.title{DataLineNum,DataRowNum},'FontSize',FigSet.FontSize);
                end
                % Set global font format
                if isfield(FigSet,'global')
                    set(gca,'FontSize',FigSet.global.FontSize,'Fontname', FigSet.global.Fontname,...
                        'linewidth',FigSet.global.linewidth,'FontWeight','bold','tickdir','in');
                end
                
                % Set coordinate axis
                if ~isempty(FigSet.xlabelName{DataLineNum,DataRowNum})
                    hXLabel = xlabel(FigSet.xlabelName{DataLineNum,DataRowNum},'FontSize',FigSet.Label.FontSize);
                end
                if ~isempty(FigSet.ylabelName{DataLineNum,DataRowNum})
                    hYLabel = ylabel(FigSet.ylabelName{DataLineNum,DataRowNum},'FontSize',FigSet.Label.FontSize);
                end
                if isfield(FigSet,'LabelLimit')
                    [XLimitMin,XLimitMax] = deal(FigSet.LabelLimit.XLimit(1),FigSet.LabelLimit.XLimit(2));
                    [YLimitMin,YLimitMax] = deal(FigSet.LabelLimit.YLimit(1),FigSet.LabelLimit.YLimit(2));
                    %   axis([XLimitMin XLimitMax YLimitMin YLimitMax])
                    xlim([XLimitMin,XLimitMax]);ylim([YLimitMin,YLimitMax]);
                end
                % Legend Settings
                if isfield(FigSet,'legendName')
                    legend(FigSet.legendName{DataLineNum,:},'FontSize',FigSet.FontSize,...
                        'Location',FigSet.Location,'Box','off');
                end
                
                if isfield(FigSet,'Frame')
                    switch FigSet.Frame
                        case 'grid'
                            grid on
                        case 'axis'
                            axis square
                    end
                end
            end
        end
        
        % Set Color Bar
        if isfield(FigSet,'Colorbar')
            c = colorbar();      % Gradient Color Bar
            colormap(FigSet.Colorbar.Colormap);
            c.Label.String = FigSet.Colorbar.Lable.String;
            % set(get(c,'label'),'string',FigSet.Colorbar.Lable.String);% Name the color bar
            c.Label.FontSize = FigSet.Label.FontSize;
            c.Label.FontName = FigSet.Label.FontName;
            c.Layout.Tile = FigSet.Layout.Tile;
        end
end



% Specify window position and size
if isfield(FigSet,'PaperPosition')
    set(gcf, 'PaperPosition', FigSet.PaperPosition);
end
% Specify the size of the figure
if isfield(FigSet,'Size')
    set(gcf,'unit','centimeters','position',FigSet.Size);
end


% Legend Settings
if isfield(FigSet,'legendName') && isfield(FigSet,'legendType')
    if strcmpi(FigSet.legendType,'Outside_Top')
        lgd = legend(FigSet.legendName,'Location','NorthOutside','FontSize',FigSet.FontSize,...
            'Box','off','orientation','horizontal','NumColumns',FigSet.legendCol);
        lgd.Position = FigSet.legendPos;
    end
end


% save
if isfield(FigSet,'StorgePath')
    set(gcf,'PaperPositionMode','auto')
    print(gcf,FigSet.StorgePath,'-r600','-dpng');
end

end

