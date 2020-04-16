
clear all;

%%%%%%%%%%%%%%%%%%%% Cr %%%%%%%%%%%%%%%%%%%%

center1 = 'Cr'; % name your EPR center for plotting
theta = 90; % rotation angle, also used for plot labels

%%%%%%%%%% Generate rotations about xL %%%%%%%%%%
xL = [1;0;0]; % rotating about mw magnetic field (xL)
CrystalOriStart = [0 13 0]*pi/180; % align a* axis of sample with mw field
rho = (theta) * pi/180; % 90 deg is 0 deg in our experiment i.e. B_0//b, aligns b axis with zL
CrystalOri = rotatecrystal(CrystalOriStart,xL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.962 1.964 1.979];
Sys.lwpp = 1.6;
%Sys.D = [1535*3 1548];
%Sys.DStrain = [100 20];
Sys.B2 = [1535 2668 1548 0 0]; % Extended Stevens parameters
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.4066;
Exp.Range = [0 1000];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = CrystalOri;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Simulate spectra %%%%%%%%%%
figure;
set(gcf, 'Name','Spectrum EasySpin Simulation','numbertitle','off');
[B, spec1] = pepper(Sys,Exp,Opt); % this pepper call stores values so we can write them to a .txt file
plot(B, spec1);
hold on;
title(strcat(center1,{' '},'Spectrum',{' '}, 'at',{' '},int2str(theta-90),{' '},'degrees'));
xlabel('Magnetic Field (mT)');
ylabel('Intensity');
%================================%




