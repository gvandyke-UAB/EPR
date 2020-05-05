
% This script generates a roadmap plot.

clf;
clear Sys;
clear Exp;
clear Opt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cr3+ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


center1 = 'Cr3+'; % name your EPR center for plotting
startAng = 0; % for a*b plane [90 90 13], 0 makes b//B_0
              % for bc* plane [90 90 -90], 0 makes b//B_0
              % for ac*/ac plane [0 0 -90], 0 makes c*//B_0
stopAng = startAng + 180;


%%%%%%%%%% Generate rotations about xL %%%%%%%%%%
% define axis of rotation as xL
xL = [1 0 0];

% Euler angles for crystal starting orientation
    % a*b plane [90 90 13] geometrically, but fits Yeom with [0 -77 0]
    % bc* plane [90 90 -90]
    % ac*/ac plane [0 0 -90]
crystalOriStart = [-3.1416   -1.7977   -3.1416];

% angle of rotation: number (for spectra) or row of numbers (for stackplot)
rho = (startAng:2:stopAng) * pi/180; % startang to stopang in steps of 2 degrees

% generate Euler angles for each rotation of 2 degrees
crystalOri = rotatecrystal(crystalOriStart,xL,rho);
%================================%


%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.962 1.964 1.979];
Sys.lwpp = 1.6;
Sys.B2 = [-3*1535 -3*2668 -3*1548 0 0]; % Extended Stevens parameters
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.504;
Exp.Range = [0 1500];
Exp.CrystalSymmetry = 'C2/m';  % assumes 'b' is yC
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresCr = resfields(Sys,Exp,Opt);
angCr = rho * 180/pi;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
set(gcf, 'Name','EasySpin Roadmap Simulation','numbertitle','off');
plot(BresCr,angCr,'linewidth',3,'color','b','DisplayName',center1); % blue traces
xlabel('Magnetic Field (mT)');
ylabel('Angle (°)');
hold on;
legend
title(strcat('Roadmap for',{' '},center1));
%================================%

