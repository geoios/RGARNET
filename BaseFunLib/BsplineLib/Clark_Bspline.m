close all;clear all;clc;
% ���ÿ��Ƶ�
Px=[0, 1, 2, 3, 4, 5];
Py=[1, 4, 2, 5, 1, 3];

% B������Clark���巨��������ͼ�εĻ滭
% 1-3��ϵ����
M1=[1,0;-1,1];
M2=[1,1,0;-2,2,0;1,-2,1]*(1/2);
M3=[1,4,1,0;-3,0,3,0;3,-6,3,0;-1,3,-3,1]*(1/6);
x=linspace(0,1,100);

% ��������ʽ
%% 1��
% figure(1)
% B1_1=1*M1(1,1)+x*M1(2,1);
% B1_2=1*M1(1,2)+x*M1(2,2);
% plot(x,B1_1,'-r');
% hold on
% plot(x,B1_2,'-b');
% title('�ֶ�ʽB����1�λ�����');
% xlabel('�ֲ�����t')
% ylabel('B����������ֵ')
% legend({'1�ε�1������������','1�ε�2������������'});
% axis([0 1 0 1]);
% hold off

%% 2��
figure(2)
B2_1=1*M2(1,1)+x*M2(2,1)+x.^2*M2(3,1);
B2_2=1*M2(1,2)+x*M2(2,2)+x.^2*M2(3,2);
B2_3=1*M2(1,3)+x*M2(2,3)+x.^2*M2(3,3);
plot(x,B2_1,'-m','LineWidth',2);
hold on
plot(x,B2_2,'-k','LineWidth',2);
hold on
plot(x,B2_3,'-b','LineWidth',2);

title('�ֶ�ʽB����2�λ�����');
xlabel('�ֲ�����u')
ylabel('B����������ֵ')
legend({'2�ε�1������������','2�ε�2������������','2�ε�3������������'});
axis([0 1 0 1]);
hold off

%% 3��
figure(3)
B3_1=1*M3(1,1)+x*M3(2,1)+x.^2*M3(3,1)+x.^3*M3(4,1);
B3_2=1*M3(1,2)+x*M3(2,2)+x.^2*M3(3,2)+x.^3*M3(4,2);
B3_3=1*M3(1,3)+x*M3(2,3)+x.^2*M3(3,3)+x.^3*M3(4,3);
B3_4=1*M3(1,4)+x*M3(2,4)+x.^2*M3(3,4)+x.^3*M3(4,4);
plot(x,B3_1,'-m','LineWidth',2);
hold on
plot(x,B3_2,'-k','LineWidth',2);
hold on
plot(x,B3_3,'-b','LineWidth',2);
hold on
plot(x,B3_4,'-y','LineWidth',2);

title('�ֶ�ʽB����3�λ�����');
xlabel('�ֲ�����u')
ylabel('B����������ֵ')
legend({'3�ε�1������������','3�ε�2������������','3�ε�3������������','3�ε�4������������'});
axis([0 1 0 1]);
hold off

% figure(4)
% for i=1:1:3
%     Sx=Px(i)*B2_1+Px(i+1)*B2_2+Px(i+2)*B2_3;
%     Sy=Py(i)*B2_1+Py(i+1)*B2_2+Py(i+2)*B2_3;
%     plot(Sx,Sy, 'MarkerSize',5);
%     hold on
% end
% plot(Px,Py,'.r', 'MarkerSize',5);
% hold off

% figure(5)
% for i=1:1:3
%     Sx=Px(i)*B3_1+Px(i+1)*B3_2+Px(i+2)*B3_3+Px(i+3)*B3_4;
%     Sy=Py(i)*B3_1+Py(i+1)*B3_2+Py(i+2)*B3_3+Py(i+3)*B3_4;
%     plot(Sx,Sy,'MarkerSize',5);
%     hold on
% end
% plot(Px,Py,'.r','MarkerSize',5);
% hold off