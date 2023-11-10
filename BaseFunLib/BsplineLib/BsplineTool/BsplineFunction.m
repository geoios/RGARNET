function [Y1,Y2] = BsplineFunction(X,a,Scope,spdeg)
% 输入：X（自变量）；a（样条系数）；Scope（有效范围）；spdeg 样条次数

if length(a)<=spdeg
    disp("error:length(a) need > spdeg");
end

NUM=length(a);
XStart=Scope(1);XEnd=Scope(end);
knots0=linspace(XStart,XEnd,NUM-spdeg+1);
dknots=(XEnd-XStart)/(NUM-spdeg);
for i=1:1:spdeg
    knots_First(i)=XStart-(spdeg-i+1)*dknots;
    knots_End(i)=XEnd+i*dknots;
end
knots=[knots_First,knots0,knots_End];
%% de-Boor Cox 定义方法
Y1=0;
for i=1:length(a)
    Y1=Y1+a(i)*Bbase_DeBoor(i,spdeg,X,knots);
end

%% Clark定义法
% 判断X所在区间范围将其归一化

Array=X-knots;
Rnum=find(Array<=0,1);
Rscope=knots(Rnum);
Lnum=max(find(Array>0));
Lscope=knots(Lnum);
if Rscope==Scope(1)
    Rnum=Rnum+1;Lnum=Lnum+1;
    Rscope=knots(Rnum);Lscope=knots(Lnum);
end
t=(X-Lscope)/(Rscope-Lscope);
Y2=0;
for k=0:1:spdeg
    Y2=Y2+a(Lnum-spdeg+k)*Bbase_Clark(k,spdeg,t);
end


end

