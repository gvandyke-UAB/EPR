
%%%%%%%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%%%%%%%
% Octahedral

% clear variables;

% Generate rotations about nL
nL = [1;0;0]; % rotating about mW magnetic field

cori0 = [0 102 0]; % crystal orientation

rho = (0)*pi/180; % 90 deg is 0 deg in our expt ie B//b

%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g = 2.0043;
Sys.lwpp = 1.6;
%Sys.D = [2210*3 2190];% Fits 0 deg data better with these parameters
%Sys.D = [2213*3 2091];% Buscher and Lehmann
Sys.B2 = [2091 0 2213 0 0];%
%Sys.B2 = [-2060 0 -2100 0 0];%
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 300; 
Exp.mwFreq = 9.4066; % 1.4 mT (14 G) modulation amplitude, peak-to-peak
Exp.Range = [0 1400]; % mT
Exp.CrystalSymmetry = 'C2/m'; % assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
%Opt.Sites = [2 1];
%Opt.Threshold = 0.95;
%================================%


Ori = rotatecrystal(cori0,nL,rho);
FieldRange = [0 1000];
Freq = 9.4066;

levelsplot(Sys,Ori,FieldRange,Freq,Exp);

% get eigenvalues and eigenvectors to compare with our own script
% "EasySpinReplication.m"

%{
for i = 1:10000
    B_0 = [i-1 ,0 ,0]; % static magnetic field
    
    H = sham(Sys,B_0);
    
    [V,D] = eig(H,'vector'); % V is matrix of eigenvectors, D is column of eigenvalues
    
    eigenvals(:,i) = D; % each individual D is the ith column of eigenval
    eigenvecsEasySpin(:,:,i) = V; % each individual V is the ith item in eigenvecs 
    
end

%}