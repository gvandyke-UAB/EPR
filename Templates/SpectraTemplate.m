
%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%

% Octahedral

%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0]*pi/180; % align vertical of sample with mw Field
rho = (90)*pi/180; % 90 deg is 0 deg in our expt ie B//b
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g= [2.004 2.002 2.007];
Sys.lwpp = 1.6;
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = cori;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Simulate spectra %%%%%%%%%%
pepper(Sys,Exp,Opt); % this pepper call plots
[B,spec] = pepper(Sys,Exp,Opt); % this pepper call stores values so we can write them to a .txt file
%================================%


%%%%%%%%%% Save data to .txt %%%%%%%%%%
data = [B(:)*10 spec(:)*8000]; % B(:)*10 converts from mT to G
save('GaOFespc_90D.txt','data','-ascii');
%================================%
