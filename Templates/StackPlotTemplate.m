
% This script generates a stackplot in a specified angle range. 
% Rotation comments are for gallium oxide crystal structure.


clear Sys;
clear Exp;
clear Opt;
clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Title %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


center1 = 'Cr3+'; % name your EPR center for plotting
startAng = 0; % for a*b plane [90 90 13], 0 makes b//B_0
               % for bc* plane [90 90 -90], 0 makes b//B_0
               % for ac*/ac plane [0 0 -90], 0 makes c*//B_0
stopAng = startAng + 180;


%%%%%%%%%% Generate rotations about xL %%%%%%%%%%
% define axis of rotation as xL
xL = [1 0 0];

% Euler angles for crystal starting orientation
    % a*b plane [90 90 13]
    % bc* plane [90 90 -90]
    % ac*/ac plane [0 0 -90]
crystalOriStart = [90 90 13] * pi/180; % [zL yL zL] not [zC y'C z''C]

% angle of rotation: number (for spectra) or row of numbers (for stackplot)
rho = (startAng:2:stopAng) * pi/180; % startAng to stopAng in steps of 2 degrees

% generate Euler angles for each rotation of 2 degrees
crystalOri = rotatecrystal(crystalOriStart,xL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.962 1.964 1.979];
Sys.lwpp = 1.6; % EasySpin uses this in stackplots/spectra
Sys.DStrain = [100 200]; % sample dependent
Sys.B2 = [-3*1535 -3*2668 -3*1548 0 0]; % Extended Stevens parameters
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298;
Exp.mwFreq = 9.504;
Exp.Range = [0 1500];
Exp.CrystalSymmetry = 'C2/m';  % assumes b-axis is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Simulate and plot spectra %%%%%%%%%%
set(gcf, 'Name','EasySpin Stackplot Simulation','numbertitle','off');
[B, spec1] = pepper(Sys,Exp,Opt);
stackplot(B, spec1);
hold on;
title(strcat(center1,{' '},'StackPlot',{' '}, 'from',{' '},int2str(startAng),{' '},'to',{' '},int2str(stopAng),{' '},'degrees'));
xlabel('Magnetic Field (mT)');
ylabel('Intensity');
yticks([1 round(size(spec1,1)/2) size(spec1,1)]);
yticklabels({int2str(startAng),int2str(stopAng/2),int2str(stopAng)})
%================================%

