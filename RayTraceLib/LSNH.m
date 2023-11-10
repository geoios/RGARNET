function [P,S,xx,VV]=LSNH(X,Y,n)
L=length(X);
X0=zeros(n+1,L);
for L0=1:L           %�������X0
    for n0=1:n+1
        X0(n0,L0)=X(L0)^(n+1-n0);
    end
end
X1=X0';
ANSS=(X1'*X1)\X1'*Y';
for j=1:n+1          %answer����洢ÿ����õķ���ϵ�������д洢
    P(j,1)=ANSS(j);
end
S=[];
xx=[];
for i=1:L
    x=X(i);
    SS=ANSS(1)*x.^n    ;%������õ�ϵ����ʼ�����������ʽ����
    for num=2:1:n+1
        SS=SS+ANSS(num)*x.^(n+1-num);
    end
    xx=[xx;x];
    S=[S;SS];
end
VV=X1*ANSS-Y';
end