
clear Sys;
clear Exp;
clear Opt;
clear H;
clear B_0;
clear eigenvalsEasySpin;
clear eigenvecsEasySpin;


%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 1;
Sys.lwpp = 1.6;
Sys.D = [2213*3 2091]; % Buscher and Lehmann
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 300; 
Exp.Range = [0 1000]; % mT
Exp.nPoints = 1e5;
%================================%

FieldRange = [0 1000];
Freq = 9.4066;

% generate energy level plot
levelsplot(Sys,'z',FieldRange,Freq,Exp);
title('EasySpin EPR Energy vs. Magnetic Field Simulation');


% get eigenvalues and eigenvectors to compare with our own script
% "DiagonalizeSpinOneWithZFS.m"
for i = 1:1001
    
    B_0 = [0, 0, i-1]; % static magnetic field in mT
    
    H = zeeman(Sys, B_0) + zfield(Sys);
    
    [V,E] = eig(H,'vector'); % V is matrix of eigenvectors, E is column of eigenvalues
    
    eigenvalsEasySpin(:,i) = E; % each individual D is the ith column of eigenvalEasySpin
    eigenvecsEasySpin(:,:,i) = V; % each individual V is the ith item in eigenvecsEasySpin
    
end
