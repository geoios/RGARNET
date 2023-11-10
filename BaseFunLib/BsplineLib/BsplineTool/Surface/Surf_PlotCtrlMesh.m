function Surf_PlotCtrlMesh(M, N, X, Y, Z)
% 绘制由控制顶点所组成的M*N网格，X Y Z是M*N形式的矩阵

for i = 1 : M
    for j = 1 : N-1
        hold on
        plot3([X(i, j) X(i, j+1)], [Y(i, j) Y(i, j+1)], [Z(i, j) Z(i, j+1)], 'o-k');
    end
end
for j = 1 : N
    for i = 1 : M-1
        plot3([X(i, j) X(i+1, j)], [Y(i, j) Y(i+1, j)], [Z(i, j) Z(i+1, j)], 'o-k');
    end
end
xlabel('X');
ylabel('Y');
zlabel('Z');
view(45, -45);