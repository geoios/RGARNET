function [Control,Par] = RayTracing_ControlSystem() 
%% Solve control
% Angle of incidence: Fitted ¡ª¡ª¡ª> estimated
Control.InDirect = '';
Control.InDirect.Interpolation = '';
% The secant method solves for the initial angle of incidence
Control.InDirect.Tangent = '';
Control.InDirect.HeightAngle = '';

%% Parameter control
% Calculate the angle of incidence method parameter configuration
Par.InAngle.WindowNum = 7;
Par.InAngle.Order     = 5;
Par.InAngle.TermIter  = 20;
Par.InAngle.delta     = 10^-4;


end