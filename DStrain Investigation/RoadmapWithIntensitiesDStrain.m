
% This file generates a roadmap with a third axis representing relative
% intensity.

clear Sys;
clear Exp;
clear Opt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cr3+ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


center1 = 'Cr3+'; % name your EPR center for plotting
startAng = 0; % for a*b plane [0 103 0], 0 makes -a*//B_0, 90 makes b//B_0
              % for bc* plane [0 0 0], 0 makes c*//B_0, 90 makes b//B_0
              % for ac*/ac plane [0 0 -90], 0 makes c*//B_0, -90 makes a//B_0
stopAng = startAng + 180;


%%%%%%%%%% Generate rotations about xL %%%%%%%%%%
% define axis of rotation as xL
xL = [1 0 0];

% Euler angles for crystal starting orientation
    % a*b plane [0 103 0] or [0 -77 0] geometrically, but fits Yeom with [0 84 0]
    % bc* plane [0 0 0]
    % ac*/ac plane [0 0 -90], cannot be [0 0 90] bc (+)b//B_1
crystalOriStart = [0 0 -90] * pi/180;

% angle of rotation: number (for spectra) or row of numbers (for stackplot)
rho = (startAng:2:stopAng) * pi/180; % startang to stopang in steps of 2 degrees

% generate Euler angles for each rotation of 2 degrees
crystalOri = rotatecrystal(crystalOriStart,xL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.962 1.964 1.979];   
Sys.B2 = [-3*1535 -3*2668 -3*1548 0 0];
%================================%


%%%%%%%%%% Optional Parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.504;
Exp.Range = [0 1500];
Exp.CrystalSymmetry = 'C2/m';  % assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresCr, IntCr] = resfields(Sys,Exp,Opt);
angCr = rho * 180/pi - 90;
%================================%


%%%%%%%%%% Overall Normalization %%%%%%%%%%
setToOne = max(IntCr,[],'all'); % find which value to regard as our "1"
normalizedIntFe1 = IntCr / setToOne;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
set(gcf, 'Name','EasySpin Roadmap + Intensities Simulation','numbertitle','off');
plot3(BresCr, angCr, normalizedIntFe1,'k','linewidth',2,'DisplayName',center1); % black traces
hold on;
legend
title(strcat('Roadmap + Intensities for',{' '},center1));
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
%================================%
