function [Control,Par] = RayTracing_ControlSystem() 
%% �������
% ����ǣ���� ������> �ƹ�
Control.InDirect = '';
Control.InDirect.Interpolation = '';
% ���߷�����ʼ�����
Control.InDirect.Tangent = '';
Control.InDirect.HeightAngle = '';

%% ��������
% ��������Ƿ�����������
Par.InAngle.WindowNum = 7;
Par.InAngle.Order     = 5;
Par.InAngle.TermIter  = 20;
Par.InAngle.delta     = 10^-4;


end