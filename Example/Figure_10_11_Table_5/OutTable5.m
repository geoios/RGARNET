function  OutTable5(V,Sig,TableName)

Stations = ["u_0^2 = 0.00005";"u_0^2 = 0.0001";"u_0^2 = 0.0005";"u_0^2 = 0.001";"u_0^2 = 0.005";"u_0^2 = 0.01";"u_0^2 = 0.05";"u_0^2 = 0.1";"u_0^2 = 0.5";"u_0^2 = 1";"u_0^2 = 100"];  % 
Station_velocity_E = V(:,1);Station_velocity_N = V(:,2);Station_velocity_U = V(:,3);
Residual_STD_E = Sig(:,1);Residual_STD_N = Sig(:,2);Residual_STD_U = Sig(:,3);

Root_Sum_Squares = [];
for i = 1:length(Sig(:,1))
    Root_Sum_Squares = [Root_Sum_Squares;sqrt(sum(Sig(i,:).^2))];
end

Table5 = table(Stations,Station_velocity_E,Station_velocity_N,Station_velocity_U,...
    Residual_STD_E,Residual_STD_N,Residual_STD_U,Root_Sum_Squares);
writetable(Table5,TableName);
end

