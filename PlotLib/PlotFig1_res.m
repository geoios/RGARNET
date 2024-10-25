function PlotFig1_res(FigSet)
[DataLine,DataRow]= size(FigSet.Data);
%% draw
figure(1) % 'visible','off'
switch FigSet.SubplotModel   
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
                        t = FigSet.t;
                        LineType = FigSet.LineType{DataNum};
                        Line1Type = FigSet.Line1Type{DataNum};
                        if isfield(FigSet,'PointSize')
                            PMarkerSize = FigSet.PointSize(DataNum);
                        else
                            PMarkerSize = FigSet.MarkerSize;
                        end
                        h = plot(t,Y,LineType,'lineWidth',FigSet.lineWidth,'MarkerSize',PMarkerSize);
                        if isfield(FigSet,'PointFull')
                            if FigSet.PointFull(DataNum)
                                set(h,'MarkerFaceColor',get(h,'color'));
                            end
                        end
                        hold on
                        
                        MidDay = mean(t);
                        delt   = (t - MidDay)/365;
                        P      = ones(length(delt),1);
                        A      = [P delt];
                        RobPar = RobustControlPar();
                        
                        [x,Sigma,L_est,v,P,Qx] = RobLS(A,Y,P,RobPar);
                        y  = x(1) + x(2)*delt;

                        plot(t,y,Line1Type,'lineWidth',FigSet.lineWidth)
                        dateaxis('x',17);

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
            
%             FigSet.Xticks.LableNum1{1} = t;FigSet.Xticks.LableNum1{2} = t;FigSet.Xticks.LableNum1{3} = t;
%             if isfield(FigSet,'Xticks')
%                 if isempty(FigSet.Xticks.LableNum1{DataLineNum})
%                     set(gca,'xticklabel',[]);
%                 else
%                     xticks(FigSet.Xticks.LableNum1{DataLineNum});xticklabels(FigSet.Xticks.LableStr{DataLineNum})
%                 end
%             end
            
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
        lgd = legend(FigSet.legendName,'Location','NorthOutside','FontSize',FigSet.FontSize,...   % FigSet.FontSize
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

