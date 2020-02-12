
%%%%%%Fe3+%%%%%%%%%%%%%%%%%%%%%%%%%%
%Octahedral
%
clear all;

% Spin parameters
Sys.S = 5/2;
%Sys.g = 2.0043;
Sys.g = [2.004 2.002 2.007];
Sys.lwpp = 1.6;

Exp.Temperature = 300; 

%Opt.Threshold = 0.95;

%Sys.D = [2210*3 2190];% Fits 0 deg data better with these parameters
%Sys.D = [2213*3 2091];% Buscher and Lehmann
Sys.B2 = [2091 0 2213 0 0];%
%Sys.B2 = [-2060 0 -2100 0 0];%

 
% Experimental parameters
Exp.mwFreq = 9.4066; % 1.4 mT (14 G) modulation amplitude, peak-to-peak
Exp.Range = [0 1400];%mT
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.nPoints = 1e4;

%Generate rotations about nL
nL = [1;0;0]; % rotating about mW magnetic field

cori0 = [0 102 0];
%cori0 = [0 -13 0]*pi/180; %align vertical of sample with mw Field
rho = (0)*pi/180;% 90 deg is 0 deg in our expt ie B//b
%cori0 = [0 76.2 180]*pi/180; % B//a in ab plane ( rotation about c* axis)

%rho = (0:90:180)*pi/180;% B//a is 0 deg
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori;
%Opt.Sites = [2 1];

Ori = cori;
FieldRange = [0 1000]; Freq = 9.4066;
figure
levelsplot(Sys,Ori,FieldRange,Freq,Exp);
%{

B = [0 0 14000];
H = sham(Sys,B);
[V,E] = eig(H); E = diag(E).'/1e3, V
%}
% A S=5/2 spin system
