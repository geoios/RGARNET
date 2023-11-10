 function [T,Y,Z,L,theta,Iteration,RayInf] = InvRayTrace(PF,TT,YY,HH,PriTheta)
 %% InvRayTracing(PF,TT,YY,HH,tag)->inversion problem
%[theta] = IncidentAngle(PF, TT,YY,HH,'Tangent'); 
[T,Y,Z,L,theta,Iteration,RayInf] = InAngle(PF,TT,YY,HH,PriTheta); 
 end



