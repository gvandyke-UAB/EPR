
% This script generates a roadmap with a third axis representing relative
% intensity. Rotation comments are for gallium oxide crystal structure.


clear Sys;
clear Exp;
clear Opt;
clf % clears all variables and figures


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Title %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


center1 = 'Fe3+'; % Name your EPR centers here, used for plot formatting later
center2 = 'Cr3+';
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
crystalOriStart = [90 90 -13] * pi/180;

% angle of rotation: number (for spectra) or row of numbers (for stackplot)
rho = (startAng:2:stopAng) * pi/180; % startAng to stopAng in steps of 2 degrees

% generate Euler angles for each rotation of 2 degrees
crystalOri = rotatecrystal(crystalOriStart,xL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.968 0 -0.008; 0 1.964 0; 0 0 1.973];
Sys.D = [3*5385 3*1288];
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m'; % assumes 'b' is yC
Exp.Temperature = 298;
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresCr, IntCr, WidCr] = resfields(Sys,Exp,Opt);
angCr = rho * 180/pi;
%================================%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fe3+ lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% Generate rotations about xL %%%%%%%%%%
% Euler angles are already calculated up top
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g = [2.004 2.002 2.007];
Sys.D = [3*5385 3*1288];
Sys.DStrain = [10 12];
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  % assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Optional Parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresFe, IntFe, WidFe] = resfields(Sys,Exp,Opt);
angFe = rho * 180/pi;
%================================%


%%%%%%%%%% Overall Normalization %%%%%%%%%%
setToOne = max(max(IntFe,[],'all'), max(IntCr,[],'all')); % find which value to regard as our "1"
normalizedIntCr = IntCr / setToOne;
normalizedIntFe = IntFe / setToOne;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
set(gcf, 'Name','Roadmap + Intensities EasySpin Simulation','numbertitle','off');
plot3(BresCr*10, angCr, normalizedIntCr,'k','linewidth',2,'DisplayName',center1); % black traces
hold on;
plot3(BresFe*10, angFe, normalizedIntFe,'b','linewidth',2,'DisplayName',center2); % blue traces
legend
title(strcat('Roadmap + Intensities for',{' '}, center1,{' '}, 'and',{' '}, center2));
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
%================================%
