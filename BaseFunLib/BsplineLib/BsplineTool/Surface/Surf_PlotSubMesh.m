function Surf_PlotSubMesh(M, N, k, l, X, Y, Z)
% 绘制网格曲面，X Y Z是所绘制的M*N网格的坐标，k, l是网格的u向和v向的次数

global FLAG_U FLAG_V;

% ------------------------------------------------------------------
% 根据所选择的类型绘图
n = N - 1;
m = M - 1;
piece_u = 20;   % u向的节点矢量细分
piece_v = 20;
Nik_u = zeros(n+1, 1);  % 基函数初始化
Nik_v = zeros(m+1, 1);
% u方向的细分
switch FLAG_U
    case 1
        NodeVector_u = linspace(0, 1, n+k+2);     % 均匀B样条的u向节点矢量
        u = linspace(k/(n+k+1), (n+1)/(n+k+1), piece_u);    % u向节点分成若干份
        
        X_M_piece = zeros(M, piece_u);    % 沿着u方向的网格，M * piece
        Y_M_piece = zeros(M, piece_u);
        Z_M_piece = zeros(M, piece_u);
        for i = 1 : M
            for j = 1 : piece_u
                for ii = 0 : 1: n
                    Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
                end
                X_M_piece(i, j) = X(i, :) * Nik_u;
                Y_M_piece(i, j) = Y(i, :) * Nik_u;
                Z_M_piece(i, j) = Z(i, :) * Nik_u;
            end
        end
    case 2
        NodeVector_u = U_quasi_uniform(n, k); % 准均匀B样条的u向节点矢量
        u = linspace(0, 1-0.0001, piece_u);    %% u向节点分成若干份
        
        X_M_piece = zeros(M, piece_u);    % 沿着u方向的网格，M * piece
        Y_M_piece = zeros(M, piece_u);
        Z_M_piece = zeros(M, piece_u);
        for i = 1 : M
            for j = 1 : piece_u
                for ii = 0 : 1: n
                    Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
                end
                X_M_piece(i, j) = X(i, :) * Nik_u;
                Y_M_piece(i, j) = Y(i, :) * Nik_u;
                Z_M_piece(i, j) = Z(i, :) * Nik_u;
            end
        end
    case 3
        if ~mod(n, k)
            NodeVector_u = U_piecewise_Bezier(n, k);  % 分段Bezier曲线的节点矢量
            u = linspace(0, 1-0.0001, piece_u);    %% u向节点分成若干份
            
            X_M_piece = zeros(M, piece_u);    % 沿着u方向的网格，M * piece_u
            Y_M_piece = zeros(M, piece_u);
            Z_M_piece = zeros(M, piece_u);
            for i = 1 : M
                for j = 1 : piece_u
                    for ii = 0 : 1: n
                        Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
                    end
                    X_M_piece(i, j) = X(i, :) * Nik_u;
                    Y_M_piece(i, j) = Y(i, :) * Nik_u;
                    Z_M_piece(i, j) = Z(i, :) * Nik_u;
                end
            end
        else
            errordlg('Error: n/k is not an integer!', 'Piecewise Bezier');
        end
    otherwise
        % NodeVector_u = U_Hartley_Judd(n, k, P);  % Hartley-Judd方法
        u = linspace(0, 1-0.0001, piece_u);    %% u向节点分成若干份
        
        X_M_piece = zeros(M, piece_u);    % 沿着u方向的网格，M * piece
        Y_M_piece = zeros(M, piece_u);
        Z_M_piece = zeros(M, piece_u);
        for i = 1 : M
            % -------------------------------------------------------------
            % 计算第i行控制顶点的节点矢量
            Points = zeros(3, n+1);
            Points(1, :) = X(i, :);
            Points(2, :) = Y(i, :);
            Points(3, :) = Z(i, :);
            
            NodeVector_u = zeros(1, n+k+2);       % 节点矢量长度为n+k+2
            NodeVector_u(1, n+2 : n+k+2) = ones(1, k+1);  % 右端节点置1
            Len = zeros(1, n);    % 控制多边形共n条边
            for iP = 2 : n+1
                Len(iP-1) = sqrt((Points(1,iP) - Points(1,iP-1))^2 ...
                            + (Points(2,iP) - Points(2,iP-1))^2 ...
                            + (Points(3,iP) - Points(3,iP-1))^2);
            end
            Lsum = 2*sum(Len) - Len(1) - Len(n);
            for iP = k+2 : n+1
                NodeVector_u(1, iP) = (2*sum( Len(1 : iP-2) ) - Len(1) - Len(iP-2)) / Lsum;
            end
            % -------------------------------------------------------------
            for j = 1 : piece_u
                for ii = 0 : 1: n
                    Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
                end
                X_M_piece(i, j) = X(i, :) * Nik_u;
                Y_M_piece(i, j) = Y(i, :) * Nik_u;
                Z_M_piece(i, j) = Z(i, :) * Nik_u;
            end
        end
end

% v方向的细分
switch FLAG_V
    case 1
        NodeVector_v = linspace(0, 1, m+l+2);     % 均匀B样条的u向节点矢量
        v = linspace(l/(m+l+1), (m+1)/(m+l+1), piece_v);    % v向节点分成若干份
        X_MN_piece = zeros(piece_v, piece_u);
        Y_MN_piece = zeros(piece_v, piece_u);
        Z_MN_piece = zeros(piece_v, piece_u);
        for i = 1 : piece_u
            for j = 1 : piece_v
                for ii = 0 : 1 : m
                    Nik_v(ii+1, 1) = BaseFunction(ii, l, v(j), NodeVector_v);
                end
            X_MN_piece(j, i) = Nik_v' * X_M_piece(:, i);
            Y_MN_piece(j, i) = Nik_v' * Y_M_piece(:, i);
            Z_MN_piece(j, i) = Nik_v' * Z_M_piece(:, i);
            end
        end
    case 2
        NodeVector_v = U_quasi_uniform(m, l);   % 准均匀B样条的v向节点矢量
        v = linspace(0, 1-0.0001, piece_v);    % v向节点分成若干份
        
        X_MN_piece = zeros(piece_v, piece_u);
        Y_MN_piece = zeros(piece_v, piece_u);
        Z_MN_piece = zeros(piece_v, piece_u);
        for i = 1 : piece_u
            for j = 1 : piece_v
                for ii = 0 : 1 : m
                    Nik_v(ii+1, 1) = BaseFunction(ii, l, v(j), NodeVector_v);
                end
            X_MN_piece(j, i) = Nik_v' * X_M_piece(:, i);
            Y_MN_piece(j, i) = Nik_v' * Y_M_piece(:, i);
            Z_MN_piece(j, i) = Nik_v' * Z_M_piece(:, i);
            end
        end
    case 3
        if ~mod(m, l)
            NodeVector_v = U_piecewise_Bezier(m, l);   % 分段Bezier的v向节点矢量
            v = linspace(0, 1-0.0001, piece_v);    % v向节点分成若干份
        
            X_MN_piece = zeros(piece_v, piece_u);
            Y_MN_piece = zeros(piece_v, piece_u);
            Z_MN_piece = zeros(piece_v, piece_u);
            for i = 1 : piece_u
                for j = 1 : piece_v
                    for ii = 0 : 1 : m
                        Nik_v(ii+1, 1) = BaseFunction(ii, l, v(j), NodeVector_v);
                    end
                X_MN_piece(j, i) = Nik_v' * X_M_piece(:, i);
                Y_MN_piece(j, i) = Nik_v' * Y_M_piece(:, i);
                Z_MN_piece(j, i) = Nik_v' * Z_M_piece(:, i);
                end
            end
        else
            errordlg('Error: n/k is not an integer!', 'Piecewise Bezier');
        end
    otherwise
        % NodeVector_u = U_Hartley_Judd(n, k, P);  % Hartley-Judd方法
        v = linspace(0, 1-0.0001, piece_v);    % v向节点分成若干份
        
        X_MN_piece = zeros(piece_v, piece_u);   % 沿v向的网格piece_v * piece_u
        Y_MN_piece = zeros(piece_v, piece_u);
        Z_MN_piece = zeros(piece_v, piece_u);
        for i = 1 : piece_u
            % -------------------------------------------------------------
            % 计算第i行控制顶点的节点矢量
            Points = zeros(3, m+1);
            Points(1, :) = X_M_piece(:, i)';
            Points(2, :) = Y_M_piece(:, i)';
            Points(3, :) = Z_M_piece(:, i)';
            
            NodeVector_v = zeros(1, m+l+2);       % 节点矢量长度为n+k+2
            NodeVector_v(1, m+2 : m+l+2) = ones(1, l+1);  % 右端节点置1
            Len = zeros(1, m);    % 控制多边形共n条边
            for iP = 2 : m+1
                Len(iP-1) = sqrt((Points(1,iP) - Points(1,iP-1))^2 ...
                            + (Points(2,iP) - Points(2,iP-1))^2 ...
                            + (Points(3,iP) - Points(3,iP-1))^2);
            end
            Lsum = 2*sum(Len) - Len(1) - Len(m);
            for iP = l+2 : m+1
                NodeVector_v(1, iP) = (2*sum( Len(1 : iP-2) ) - Len(1) - Len(iP-2)) / Lsum;
            end
            % -------------------------------------------------------------
            for j = 1 : piece_v
                for ii = 0 : 1: m
                    Nik_v(ii+1, 1) = BaseFunction(ii, l, v(j), NodeVector_v);
                end
                X_MN_piece(j, i) = Nik_v' * X_M_piece(:, i);
                Y_MN_piece(j, i) = Nik_v' * Y_M_piece(:, i);
                Z_MN_piece(j, i) = Nik_v' * Z_M_piece(:, i);
            end
        end
end

% --------------------------------------------------------
% for i = 1 : 4
%     for j = 1 : piece_u -1
%         %hold on
%         plot3([X_M_piece(i, j) X_M_piece(i, j+1)],...
%             [Y_M_piece(i, j) Y_M_piece(i, j+1)],...
%             [Z_M_piece(i, j) Z_M_piece(i, j+1)], '.r-');
%     end
% end
% for j = 1 : piece_u
%     for i = 1 : 4 -1
%         plot3([X_M_piece(i, j) X_M_piece(i+1, j)],...
%             [Y_M_piece(i, j) Y_M_piece(i+1, j)],...
%             [Z_M_piece(i, j) Z_M_piece(i+1, j)], 'g-');
%     end
% end
% 根据得到的曲面数据点X_MN_piece... 绘制网格曲面
for j = 1 : piece_u
    for i = 1 : piece_v -1
        plot3([X_MN_piece(i, j) X_MN_piece(i+1, j)],...
            [Y_MN_piece(i, j) Y_MN_piece(i+1, j)],...
            [Z_MN_piece(i, j) Z_MN_piece(i+1, j)], 'b-');
    end
end
for i = 1 : piece_v
    for j = 1 : piece_u -1
        %hold on
        plot3([X_MN_piece(i, j) X_MN_piece(i, j+1)],...
            [Y_MN_piece(i, j) Y_MN_piece(i, j+1)],...
            [Z_MN_piece(i, j) Z_MN_piece(i, j+1)], 'b-');
    end
end