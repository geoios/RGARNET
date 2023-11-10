function NodeVector = U_piecewise_Bezier(n, k)
% �ֶ�Bezier���ߵĽڵ��������㣬��n+1�����ƶ��㣬k��B����
% �ֶ�Bezier�˽ڵ��ظ���Ϊk+1���ڼ�ڵ��ظ���Ϊk,������n/kΪ������

if ~mod(n, k) && (~mod(k, 1) && k>=1)   % ����n��k����������kΪ������
    NodeVector = zeros(1, n+k+2);   % �ڵ�ʸ������Ϊn+k+2
    NodeVector(1, n+2 : n+k+2) = ones(1, k+1);  % �Ҷ˽ڵ���1
    
    piecewise = n / k;      % �趨�ڽڵ��ֵ
    Flg = 0;
    if piecewise > 1
        for i = 2 : piecewise
            for j = 1 : k
                NodeVector(1, k+1 + Flg*k+j) = (i-1)/piecewise;
            end
            Flg = Flg + 1;
        end
    end
    
else
    fprintf('error!\n');
end