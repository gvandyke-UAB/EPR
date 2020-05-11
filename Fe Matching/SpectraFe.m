
% This script generates a spectrum at a single angle.
% Rotation comments are for gallium oxide crystal structure.

clear Sys;
clear Exp;
clear Opt;
clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fe3+ Octahedral %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

center1 = 'Fe3+'; % name your EPR center for plotting
ang = 90; % for a*b plane [90 90 13], 0 makes b//B_0
          % for bc* plane [90 90 -90], 0 makes b//B_0
          % for ac*/ac plane [0 0 -90], 0 makes c*//B_0


%%%%%%%%%% Generate rotations about xL %%%%%%%%%%
% define axis of rotation as xL
xL = [1 0 0];

% Euler angles for crystal starting orientation
    % a*b plane [90 90 13]
    % bc* plane [90 90 -90]
    % ac*/ac plane [0 0 -90]
crystalOriStart = [90 90 13] * pi/180; % [zL yL zL] not [zC y'C z''C]

% angle of rotation
rho = ang * pi/180;

% generate Euler angles for each rotation of 2 degrees
crystalOri = rotatecrystal(crystalOriStart,xL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g = 2.0043;
Sys.lwpp = 1.6;
Sys.B2 = [2091 0 2213 0 0];
Sys.DStrain = [20 70];
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 300; 
Exp.mwFreq = 9.4066;
Exp.Range = [0 840];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.nPoints = 1e5;
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Simulate spectra %%%%%%%%%%
pepper(Sys,Exp,Opt); % this pepper call plots

set(gcf, 'Name','Spectrum EasySpin Simulation','numbertitle','off');
title(strcat(center1,{' '},'Spectrum',{' '},'at',{' '},int2str(ang),{' '},'degrees'));

[B,spec] = pepper(Sys,Exp,Opt); % this pepper call stores values so we can write them to a .txt file
%================================%
