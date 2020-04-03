
clear all;

%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%

center1 = 'Fe3+'; % name your EPR center for plotting

% Octahedral

%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0]*pi/180; % align vertical of sample with mw Field
rho = (90)*pi/180; % 90 deg is 0 deg in our experiment i.e. B_0//b
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g = [2.004 2.002 2.007];
Sys.lwpp = 1.6;
Sys.D = [2213*3 2091];
Sys.DStrain = [100 20];
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
figure;
set(gcf, 'Name','Spectrum EasySpin Simulation','numbertitle','off');

[B,spec1] = pepper(Sys,Exp,Opt); % this pepper call stores values so we can write them to a .txt file
plot(B, spec1);
hold on;
title(strcat(center1,{' '},'Spectrum'));
%================================%

%{
Sys.DStrain = [500 200];
[B,spec2] = pepper(Sys,Exp,Opt); % this pepper call stores values so we can write them to a .txt file
plot(B, spec2);
legend('Low DStrain','High DStrain');
%}

