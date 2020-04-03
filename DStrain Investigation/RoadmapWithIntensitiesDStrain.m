% This file generates a roadmap with a third axis representing relative
% intensity. General structure is: define Sys, Exp, and Opt, generate data,
% normalize, plot


clear all;
clf % clears all variables and figures

% Name your EPR centers here, used for plot formatting later
center1 = 'Fe(1)';
center2 = 'Fe(2)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fe(1) lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; % align vertical of sample with mw Field
rho = (90:3:270) * pi/180; % 90 deg is 0 deg in our experiment i.e. B_0//b
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g = [2.004 2.002 2.007];
%Sys.D = [3*5385 3*1288];
Sys.D = [2213*3 2091];
Sys.DStrain = [10 12]; % values are for experimenting and do not reflect sample at this time
%================================%


%%%%%%%%%% Optional Parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  % assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = cori;
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresFe1, IntFe1, WidFe1] = resfields(Sys,Exp,Opt);
angFe1 = rho * 180/pi - 90;
%================================%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fe(2) lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Octahedral

%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; % align vertical of sample with mw Field
rho = (90:3:270) * pi/180; % 90 deg is 0 deg in our expt ie B//b
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g = [2.004 2.002 2.007];
%Sys.D = [3*5385 3*1288];
Sys.D = [2213*3 2091];
Sys.DStrain = [100 20]; % values are for experimenting and do not reflect sample at this time
%================================%


%%%%%%%%%% Optional Parameters %%%%%%%%%%
Opt.Output = 'separate';  % make sure spectra are not added up
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.Temperature = 298; 
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  % assumes 'b' is yC
Exp.nPoints = 1e4;
Exp.CrystalOrientation = cori;
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresFe2, IntFe2, WidFe2] = resfields(Sys,Exp,Opt);
angFe2 = rho * 180/pi - 90;
%================================%


%%%%%%%%%% Overall Normalization %%%%%%%%%%
setToOne = max(max(IntFe1,[],'all'), max(IntFe2,[],'all')); % find which value to regard as our "1"
normalizedIntFe1 = IntFe1 / setToOne;
normalizedIntFe2 = IntFe2 / setToOne;
%================================%



%%%%%%%%%% Plotting %%%%%%%%%%
set(gcf, 'Name','Roadmap + Intensities EasySpin Simulation','numbertitle','off');
plot3(BresFe1*10, angFe1, normalizedIntFe1,'k','linewidth',2,'DisplayName',center1); % black traces
hold on;
plot3(BresFe2*10, angFe2, normalizedIntFe2,'b','linewidth',2,'DisplayName',center2); % blue traces
legend
title(strcat('Roadmap + Intensities for',{' '},center1,{' '},'and',{' '},center2));
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
%================================%
