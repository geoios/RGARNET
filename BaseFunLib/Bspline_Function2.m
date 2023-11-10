function [Y] = Bspline_Function2(u,Mp,knots,spdeg)
du = u-knots;
Rnum = find(du <= 0,1,'first');
Lnum = find(du > 0,1,'last');
Rscope = knots(Rnum);
Lscope = knots(Lnum);
if Rscope == knots(spdeg+1)
    Rnum=Rnum+1;Lnum=Lnum+1;
    Rscope=knots(Rnum);Lscope=knots(Lnum);
end
r=(u-Lscope)/(Rscope-Lscope);
MP = Mp(Lnum-spdeg:Lnum)';
Y = [r^3,r^2,r,1]*1/6*[-1,3,-3,1;3,-6,3,0;-3,0,3,0;1,4,1,0] * MP;
end