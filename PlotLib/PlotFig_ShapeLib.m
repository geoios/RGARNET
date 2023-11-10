function [MarkM] = PlotFig_ShapeLib(Type)

%          b     blue          .     point              -     solid
%          g     green         o     circle             :     dotted
%          r     red           x     x-mark             -.    dashdot
%          c     cyan          +     plus               --    dashed
%          m     magenta       *     star             (none)  no line
%          y     yellow        s     square
%          k     black         d     diamond
%          w     white         v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram
switch Type
    case 'line'
    MarkM = {'o ','+ ','* ','s ','d ','v ','^ ','< ','> ','p ','h ','x ','. ','- ',': ','-.','--'};
    case 'point'
    MarkM = {'-',': ','--','-.','-',': ','--','-.'};
    case 'line_point'
    MarkM = {'-o ','-+ ','-* ','-s ','-d ','-v ','-^ ','-< ','-> ','-p ','-h ','-x ','-. ','- ',': ','-.','--'};
end


end

