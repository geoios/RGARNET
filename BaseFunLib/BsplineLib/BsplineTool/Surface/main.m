%%
clear;
% ����4*5�������
X = [0 0 0 3 6;
    20 20 20 23 26;
    40 40 40 43 46;
    60 60 60 63 66];
Y = [0 0 0 20 40;
    0 7 7 20 43;
    0 7 7 20 43;
    0 0 0 20 40];
Z = [60 30 0 0 -5;
    60 30 0 0 -5;
    60 30 0 0 -5;
    60 30 0 0 -5];
[M, N] = size(X);

% ���ƿ��ƶ�����ɵ�����
Surf_PlotCtrlMesh(M, N, X, Y, Z);
global FLAG_U FLAG_V;
FLAG_U = 1;
FLAG_V = 1;
k = 2; l = 2;
Surf_PlotSubMesh(M, N, k, l, X, Y, Z);