function flag = GaussNewtonStp(x)
%% stop the loop with special conditions, e.g., for x>0, if x<0,then it should be stopped
if x(end)<10^-1 || x(end) > 2
    flag = 1
else
    flag = 0;
end