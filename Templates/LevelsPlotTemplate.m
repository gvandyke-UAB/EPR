
%%%%%%%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%%%%%%%
% Octahedral

clear Sys;
clear Exp;
clear Opt;
clear eigenvalsEasySpin;
clear eigenvecsEasySpin;


%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.lwpp = 1.6;
Sys.D = [2213*3 2091]; % Buscher and Lehmann
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 300; 
Exp.mwFreq = 9.4066; % 1.4 mT (14 G) modulation amplitude, peak-to-peak
Exp.Range = [0 1000]; % mT
Exp.CrystalSymmetry = 'C2/m'; % assumes 'b' is yC
Exp.nPoints = 1e5;
%================================%

FieldRange = [0 1000];
Freq = 9.4066;

% generate energy level plot
levelsplot(Sys,'z',FieldRange,Freq,Exp);


% get eigenvalues and eigenvectors to compare with our own script
% "Diagonalize.m"
for i = 1:1001
    
    B_0 = [0, 0, i-1]; % static magnetic field in mT
    
    H1 = zeeman(Sys, B_0);
    H2 = zfield(Sys);
    
    H = H1 + H2; % matches our hamiltonian perfectly
   
    [V,E] = eig(H,'vector'); % V is matrix of eigenvectors, E is column of eigenvalues
    
    eigenvalsEasySpin(:,i) = E; % each individual D is the ith column of eigenvalEasySpin
    eigenvecsEasySpin(:,:,i) = V; % each individual V is the ith item in eigenvecsEasySpin
    
end

