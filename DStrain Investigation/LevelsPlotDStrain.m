
% This script plots energy eigenvalues for a spin system as a function of magnetic field

%%%%%%%%%%%%%%%%%%%%%%%%%% Cr %%%%%%%%%%%%%%%%%%%%%%%%%%

clear Sys;
clear Exp;
clear Opt;
clear eigenvalsEasySpin;
clear eigenvecsEasySpin;


%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 3/2;

%Sys.g = [1.968 0 -.008;...
%         0 1.964 0;...
%         -.008 0 1.973]; % Full g-tensor

Sys.g = [1.962 1.964 1.979]; % g principal values

%Sys.D = [3*1548 1288];

Sys.B2 = [1535 2668 1548 0 0]; % Extended Stevens parameters
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 300; 
Exp.mwFreq = 9.504;
Exp.Range = [0 1000]; % mT
Exp.CrystalSymmetry = 'C2/m'; % assumes 'b' is yC
Exp.nPoints = 1e5;
%================================%


%%%%%%%%%% Generate energy level plot %%%%%%%%%%
FieldRange = [0 1000];
Freq = 9.504;

levelsplot(Sys,'z',FieldRange,Freq,Exp);

set(gcf, 'Name','Energy Eigenvalues EasySpin Simulation','numbertitle','off');
title('EasySpin EPR Energy vs. Magnetic Field Simulation');
%================================%


% get eigenvalues and eigenvectors to compare with our own script
% "DiagonalizeTemplate.m"
%{
for i = 1:1001
    
    B_0 = [0, 0, i-1]; % static magnetic field in mT
    
    H1 = zeeman(Sys, B_0);
    H2 = zfield(Sys);
    
    H = H1 + H2; % matches our hamiltonian perfectly
   
    [V,E] = eig(H,'vector'); % V is matrix of eigenvectors, E is column of eigenvalues
    
    eigenvalsEasySpin(:,i) = E; % each individual D is the ith column of eigenvalEasySpin
    eigenvecsEasySpin(:,:,i) = V; % each individual V is the ith item in eigenvecsEasySpin
    
end
%}
