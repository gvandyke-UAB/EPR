% This file generates a roadmap with a third axis representing relative
% intensity. General structure is: define Sys, Exp, and Opt, generate data,
% normalize, plot


clear all;
clf % clears all variables and figures

% Name your EPR centers here, used for plot formatting later
center1 = 'Cr';
center2 = 'Fe3+';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cr lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; 
rho = (90:2:270) * pi/180;
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.968 0 -0.008; 0 1.964 0; 0 0 1.973];
Sys.D = [3*5385 3*1288];
Sys.DStrain = [10 12]; % values are for experimenting and do not reflect sample at this time
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.Temperature = 298;
Exp.CrystalOrientation = cori;
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresCr, IntCr, WidCr] = resfields(Sys,Exp,Opt);
angCr = rho * 180/pi - 90;
%================================%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fe3+ lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
Sys.D = [3*5385 3*1288];
Sys.DStrain = [10 12]; % values are for experimenting and do not reflect sample at this time
% reproduces RT angle dependence of Ga2O3:Mg doped sample well except for
% relative line intensities
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
[BresFe, IntFe, WidFe] = resfields(Sys,Exp,Opt);
angFe = rho * 180/pi - 90;
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
