clear all;
%����С���˼���һ��
L1=load('C:\Users\asus\Desktop\lhs\data.txt');%�۲�����
t=load('C:\Users\asus\Desktop\lhs\time.txt');%��T
x00=[-34.6463;751.2269;11.5154;-765.6406;76.5983;855.9027;118.2692;-664.5866];%��ʼ������
p=length(t);
r=p-9;
P=eye(p);%Ȩ��
k1=[1;1;1;1;0;0;0;0];%ǰ4�۲��ʼ
k2=[1;1;1;1;1;1;1;1];%ȫ8�۲��ʼ
k3=[0;0;0;0;1;1;1;1];%��8�۲��ʼ
    a=eye(8);%8�ĵ�λ����ȫ8�۲�
    b=zeros(4);%4*4ȫΪ0 
    c=eye(4);%4�ĵ�λ����
    E=[c b];%ǰ4��۲�ʱ
    C=[b c];%��4��۲�ʱ;
 
    for i=1:28
    x=L1(i,:);
    if x(:,5)==0
        x000=x00.*k1;       
    elseif x(:,1)==0
        x000=x00.*k3;
    else
        x000=x00.*k2;      
    end
    ch(:,i)=x000;
    X0=ch(:);
    da(:,i)=x';
     end
    L=da(:);
    L(find(L==0))=[];
    X0(find(X0==0))=[];
    l=L-X0;
    B1=[E;E;E;E;a;a;a;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C];
    B=[B1,t];    
    dx=pinv(B'*P*B)*B'*P*l;
    vv=B*dx-l;
sid0_2=vv'*vv/r;
sig=sqrt(sid0_2);


delt=0.01;
k=0;
while(1)
%  m=length();
%     
%  sid0_2=vv'*vv/r;
% sig=sqrt(sid0_2);   
m=length(vv);
for j=1:m

v(j)=vv(j,:);
    if v(j)<1.5*sig
        p1(j)=1;
    elseif v(j)>1.5*sig && v(j)<2.5*sig
        p1(j)=1/(abs(v(j))+0.001*abs(v(j)));
    else
        p1(j)=0;
        B(j,:)=[];
        l(j,:)=0;
    end
    P(j,j)=p1(j)/v(j);%������Ȩ����
%     P(j,:)=[];
end
  P(all(P==0,2),:)=[];
   P(:,all(P==0,1))=[];
%   B(find(B==0))=[];
  l(find(l==0))=[];
%     l=L-X0;
%     B1=[E;E;E;E;a;a;a;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C;C];
%     B=[B1,t];    
    dx=pinv(B'*P*B)*B'*P*l;
    vv=B*dx-l;
%     dxx=dx(1:8,:);
%     x00 = x00+ dxx;
    k = k + 1;
    aa=norm(dx);
    %%ֹͣѭ��
    if aa<delt
      break
    end
    if k > 100
      break
    end

end
