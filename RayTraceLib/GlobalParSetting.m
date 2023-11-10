function [GlobalRefT, GlobalRefP,GlobalArmLength,GlobalRefH,GlobalRefc,GlobalDepthH,Globalc1,Interval, HardDelay] = GlobalParSetting()


GlobalRefT = [07 13 00 00 00];  % 参考转换时刻
%% 固体潮为零; 
GlobalRefP = [-2686643.38952782,5410552.69054612,2039760.98252097]; % 参考转换点                        
GlobalRefH = - 5;           % 参考转换高程      
GlobalDepthH  = 3070;
%GlobalArmLength     = [7.892;1.498;-29.04]; 
%GlobalArmLength     = [7.892-0.23+0.0158-0.0661558918383737+0.009+0.02849+0.235926885397477-0.227367255596279+0.0429307104718356;1.498-0.6+0.064+0.185561839794772+0.3786-0.04386-0.329-1.05442016702118+0.875282394293079+0.577779038756051;-29.04]; % 臂长参数
GlobalArmLength  = [7.892-0.0375-0.1913;1.498+0.1427+0.054;-29.04];
GlobalArmLength  = [7.892-0.0575-0.1913;1.498+0.1427+0.054-0.169919659584227;-29.04];

%GlobalArmLength  = [7.892;1.498;-29.04];

%GlobalRefc = 1495;          % 参考声速
%[0.0325061162887292;-0.329524716729198]
Globalc1   = 1494.99840403718; %% 天顶方向有效声速
GlobalRefc = 1494.99840403718; % 参考声速  + 1米
%[1494.99840403718]
Interval = 8;
HardDelay = 0;
end







