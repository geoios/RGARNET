function RobPar = RobustControlPar()
%%% 抗差方案
RobPar.Var         = 'Var';
RobPar.Var         = 'Med';
RobPar.Type2       = 'IGG3';
RobPar.RobustK1    = 25;      %% robust estimation parameter
RobPar.RobustK2    = 15;    %% robust estimation parameter
%RobPar.RobustK3    = 4;  
RobPar.q           = 1/2;
RobPar.UpperIter   = 20;
RobPar.Termination = 10^-4;