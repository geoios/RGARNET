




# Positioning Model Description
Variable:
# DirOffset(Array offset model)
0.Single Epoch solution -> Fix Array -> Array offset solution;  1. Seabed baseline constraint solution(this paper)

# GradModel(Sound Speed Field model)
1.GARPOS Model; 2.NTD derive model(this paper)  

# AdjGuiModel(adjustment model)：
(DirOffset = 0)1.LS; 2.B-spline observation knots midpoint constraint; 3.B-spline roughness smoothing; 4.Indirect adjustment with restrictive conditions; 5. Baseline tightness constraint
(DirOffset = 1)1.Large Matrix Solution; 4.Simplified solution for large matrices;  5.Tight Baseline Model with Constraints

# ObsEqModel(Observation Equation)
0.NTD derive observation equation(this paper); 1.Logarithmic observation equation

# JcbMoodel(坐标设计矩阵构建方式)
1.numerical method 2.directional cosine


# TModel(SSF time variation); SurENModel(SSF ship measurement impact/ship & station impact); FloorENModel(SSF responder impact/ship & Center impact); RayObePro(mapping).
# GARPOS Logarithmic observation equation(GradModel = 1,ObsEqModel = 1)
[TModel,SurENModel,FloorENModel,RayObePro] = [1,1,1,0]
# This paper three parameter positioning model(GradModel = 2,ObsEqModel = 0)
[TModel,SurENModel,FloorENModel,RayObePro] = [2,0,2,1]
# This paper five parameter positioning model(GradModel = 2,ObsEqModel = 0)
[TModel,SurENModel,FloorENModel,RayObePro] = [6,7,7,1]


# Stochastic Model (Weight)
0.unit weight 1.Height angle^2; 2.(TT/T*)^2(Logarithmic observation model, covariance correlation) 3. (TT/T*)^2 4.Height angle^2 + covariance correlation

# Gradient Datum Position （Reference center）
1.Center position of sea surface antenna; 2.Center position of seabed initial value; 3.Center position of sea surface transducer; 4.Seasurface: center of sea surface antenna, Seafloor: initial center of Seafloor


