function  OutTable4(V,Sig,TableName)

Stations = ["Strict_rigid_array";"Earth_adhered_rigid_array"];  % 
Station_velocity_E = V(:,1);Station_velocity_N = V(:,2);Station_velocity_U = V(:,3);
Residual_STD_E = Sig(:,1);Residual_STD_N = Sig(:,2);Residual_STD_U = Sig(:,3);

Table4 = table(Stations,Station_velocity_E,Station_velocity_N,Station_velocity_U,...
    Residual_STD_E,Residual_STD_N,Residual_STD_U);
writetable(Table4,TableName);
end

