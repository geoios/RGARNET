clc
clear 
close all
E=0.000001;
maxnum=800;%最大迭代次数
narvs=1;%目标函数的自变量个数
particlesize=50;%粒子群规模
c1=2;%每个粒子的个体学习因子，加速度常数
c2=2;%每个粒子的社会学习因子，加速度常数
w=0.6;%惯性因子
vmax=5;%粒子的最大飞翔速度
v=2*rand(particlesize,narvs);%粒子飞翔速度
x=-300+600*rand(particlesize,narvs);%粒子所在位置
%定义适应度函数
fitness=inline('(x(1)^2+x(2)^2)/10000','x');
for i=1:particlesize
	f(i)=fitness(x(i,:));	
end
personalbest_x=x;
personalbest_faval=f;
[globalbest_faval,i]=min(personalbest_faval);
globalbest_x=personalbest_x(i,:); 
k=1;
while (k<=maxnum)
	for i=1:particlesize
			f(i)=fitness(x(i,:));
		if f(i)<personalbest_faval(i)
			personalbest_faval(i)=f(i);
			personalbest_x(i,:)=x(i,:);
		end
	end
	[globalbest_faval,i]=min(personalbest_faval);
	globalbest_x=personalbest_x(i,:);
	for i=1:particlesize
		v(i,:)=w*v(i,:)+c1*rand*(personalbest_x(i,:)-x(i,:))...
			+c2*rand*(globalbest_x-x(i,:));
		for j=1:narvs
			if v(i,j)>vmax
				v(i,j)=vmax;
			elseif v(i,j)<-vmax
				v(i,j)=-vmax;
            end
		end
		x(i,:)=x(i,:)+v(i,:);
    end
    ff(k)=globalbest_faval;
    if globalbest_faval<E
        break
    end
%       figure(1)
%       for i= 1:particlesize
%       plot(x(i,1),x(i,2),'*')
%       end
	k=k+1;
end
xbest=globalbest_x;
figure(2)
set(gcf,'color','white');
plot(1:length(ff),ff)