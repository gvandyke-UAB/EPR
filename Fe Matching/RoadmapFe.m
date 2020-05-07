
% This script generates roadmap plots and outputs a CSV .txt file with the
% roadmap data. Rotation comments are for gallium oxide crystal structure.

clear Sys;
clear Exp;
clear Opt;
clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fe3+ Octahedral %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

center1 = 'Fe3+';
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
Sys.S = 5/2;
Sys.g = 2.0043;
Sys.lwpp = 1.6;
Sys.B2 = [-3*2091 0 2213 0 0];
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


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresFe = resfields(Sys,Exp,Opt);
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresFe*10,rho * 180/pi,'linewidth',3,'color','b','DisplayName',center1); % blue traces
xlabel('Magnetic Field (mT)');
ylabel('Angle (°)');
hold on % keeps previous plots displayed
%================================%

