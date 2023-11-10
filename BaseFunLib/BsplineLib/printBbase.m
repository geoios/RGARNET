clear all;close all; clc
result0=0;
k=3;

NodeVector=[0,1,2,3,4,5,6,7,8,9,10];
figure
i=6;
for u=0:0.01:10
    result = Bbase(i,k,u,NodeVector);
    %         if (u==3.5)
    %             result0=result0+result
    %         end
    plot(u,result,'r.');
    hold on
end

i=5;
for u=0:0.01:10
    result = Bbase(i,k,u,NodeVector);
    plot(u,result,'g.');
    hold on
end

i=4;
for u=0:0.01:10
    result = Bbase(i,k,u,NodeVector);
    plot(u,result,'y.');
    hold on
end

i=3;
for u=0:0.01:10
    result = Bbase(i,k,u,NodeVector);
    plot(u,result,'b.');
    hold on
end

i=2;
for u=0:0.01:10
    result = Bbase(i,k,u,NodeVector);
    plot(u,result,'k.');
    hold on
end

i=1;
for u=0:0.01:10
    result = Bbase(i,k,u,NodeVector);
    plot(u,result,'m.');
    hold on
end

% plot([0.6 0.6],[0 0.85],'--c','Linewidth',2);

title('0次B样条基函数')
% axis([0 0.6 0 1.1])
xlabel('整体参数t')
ylabel('基函数')