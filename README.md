# RGARNET
"RGARNET"(Resilient GNSS-A Ranging NETwork solver) is a so-called rigid-array solution was developed to extract the seafloor motion from long-term GNSS-A observations.

### Version
Latest version is RGARNET v 0.1.0 
### Major change(s)
* v 0.1.0 : under review


## Citation
#### for methodology
The paper is under review.
#### for code
The paper is under review.
#### for dataset 
 Shun-ichi Watanabe, Tadashi Ishikawa, Yuto Nakamura, & Yusuke Yokota. (2021). GNSS-A data obtained at the sites along the Japan Trench from March 2011 to June 2020 (1.0.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.4529008


### Corresponding author
* Shuqiang Xue 
* Chinese Academy of Surveying and Mapping
* Website: https://www.casm.ac.cn/ (in Chinese)

## License
"RGARNET" is distributed under the [GPL 3.0] (https://www.gnu.org/licenses/gpl-3.0.html) license.

### Algorithm and documentation
The paper is under review.

## Requirements
* Mathlab 2021a
Running RGARNET requires add selected folders and subfolders to path.

## Usage 
When using RGARNET, you should prepare the following files.
* Initial site-parameter file (eg., *initcfg.ini)
* Acoustic observation data csv file
* Reference sound speed data csv file
* Settings file (e.g., Settings.ini)

"Main.m" is a driver code. 
The acoustic obervation  and reference sound speed dataset  are stored in "obsdata". The  Initial site-parameter file is stored in "initcfg".  These datasets can be obtained on the website (https://doi.org/10.5281/zenodo.4529008) .


##### The Settings file Introduction 
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

###### others
In the paper, the setting of the   $\mu^2_0$ factor is shown in Mu3 in the "Settings-prep_*.ini" files

