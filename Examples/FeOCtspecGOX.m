
%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%

% Octahedral

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
%Sys.g = 2.0043;
Sys.g= [2.004 2.002 2.007];
Sys.lwpp = 1.6;
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.nPoints = 1e4;
%================================%


%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0]*pi/180; % align vertical of sample with mw Field
rho = (90)*pi/180; % 90 deg is 0 deg in our expt ie B//b
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori; % this experimental paramenter must be defined after cori
%================================%


%%%%%%%%%% Simulate spectra %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
[B,spc] = pepper(Sys,Exp,Opt);
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
%plot(B1*0.1,spc1/400);
%hold on
%plot(B,spc);
stackplot(B,spc);
%================================%


%%%%%%%%%% Save data to .txt %%%%%%%%%%
data = [B(:)*10 spc(:)*8000];
save('GaOFespc_90D.txt','data','-ascii');
%================================%
