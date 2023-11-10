function [FigSet] = PlotFig_ini(FigSet)

% line design
switch FigSet.PlotModel
    case 'line'
        if ~isfield(FigSet,'LineType')
            FigSet.LineType = PlotFig_ShapeLib('line');         
            FigSet.LineColor = PlotFig_ColorLib();
        end
        
        FigSet.lineWidth = 1;                                   
        if ~isfield(FigSet,'MarkerSize')
            FigSet.MarkerSize = 8;
        end
        if ~isfield(FigSet,'legendType')
            FigSet.legendType = 'Inside';
        end
    case 'point'
        if ~isfield(FigSet,'PointType')
            FigSet.PointType = PlotFig_ShapeLib('point');     
            FigSet.PoinColor = PlotFig_ColorLib();
        end
        FigSet.MarkerSize = 8;                                
    case 'pointcolorbar'
        if ~isfield(FigSet,'ScatterSize')
            FigSet.ScatterSize = 40;
        end
       
end

% legend
FigSet.Location = 'best';
% Coordinate Axis Settings
FigSet.linewidth = 0.75;                                
% overall design
if ~isfield(FigSet,'FontSize')
    FigSet.FontSize = 15;                                  
end
FigSet.Frame = 'grid';
end

