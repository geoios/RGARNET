# RGARNET
"RGARNET"


# 0. Related theories
The paper is under review.
# 1. Information about the author


# 2. Positioning Model Description
### Variable:
(1) DirOffset (Array offset model)
0.Single Epoch solution -> Fix Array -> Array offset solution;  1. Resilient array solution(this paper)

(2) GradModel (Sound Speed Field model)
2.ZAD derive model(this paper)  

(3) AdjGuiModel(adjustment model)：
(DirOffset = 0) 1. LS; 3.B-spline roughness smoothing; 4.Indirect adjustment with restrictive conditions; 5. Baseline tightness constraint.
(DirOffset = 1)1.Large Matrix Solution; 4.Simplified solution for large matrices;  5.Tight Baseline Model with Constraints.

(4) ObsEqModel (Observation Equation)
0.ZAD derive observation equation(this paper);

(5) JcbMoodel (Coordinate design matrix construction)
2.directional cosine


(6) TModel (SSF time variation); SurENModel (SSF ship measurement impact/ship & station impact); FloorENModel (SSF responder impact/ship & Center impact); RayObePro (mapping).
This paper five parameter positioning model(GradModel = 2,ObsEqModel = 0)
[TModel,SurENModel,FloorENModel,RayObePro] = [6,7,7,1]

(7) Stochastic Model (Weight)
1. Height angle^2^;

(8) Gradient Datum Position （Reference center）
1.Center position of sea surface antenna;


# others
In the paper, the setting of the   $\mu^2_0$ factor is shown in Mu3 in the "Settings-prep_*.ini" files

