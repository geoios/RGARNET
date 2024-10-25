function  OutTable3(V,Sig,TableName)

Stations = ["Free-array";"Two-step array-rigid";"Strict rigid-array"];
Station_velocity_E = V(:,1);Station_velocity_N = V(:,2);Station_velocity_U = V(:,3);
Residual_STDs_E = Sig(:,1);Residual_STDs_N = Sig(:,2);Residual_STDs_U = Sig(:,3);

Table3 = table(Stations,Station_velocity_E,Station_velocity_N,Station_velocity_U,...
    Residual_STDs_E,Residual_STDs_N,Residual_STDs_U);
writetable(Table3,TableName);
end

