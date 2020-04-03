% This file generates a roadmap with a third axis representing relative
% intensity. General structure is: define Sys, Exp, and Opt, generate data,
% normalize, plot


clear all;
clf % clears all variables and figures

% Name your EPR centers here, used for plot formatting later
center1 = 'Cr1';
center2 = 'Cr2';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cr1 lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
Sys.DStrain = [1000 1200]; % values are for experimenting and do not reflect a sample at this time
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
[BresCr1, IntCr1, WidCr1] = resfields(Sys,Exp,Opt);
angCr1 = rho * 180/pi - 90;
%================================%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cr2 lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Octahedral

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
Sys.DStrain = [10 12]; % values are for experimenting and do not reflect a sample at this time
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
[BresCr2, IntCr2, WidCr2] = resfields(Sys,Exp,Opt);
angCr2 = rho * 180/pi - 90;
%================================%

%{
%%%%%%%%%% Overall Normalization %%%%%%%%%%
setToOne = max(max(IntCr1,[],'all'), max(IntCr2,[],'all')); % find which value to regard as our "1"
normalizedIntCr1 = IntCr1 / setToOne;
normalizedIntCr2 = IntCr2 / setToOne;
%================================%
%}

%{
%%%%%%%%%% Plotting %%%%%%%%%%
set(gcf, 'Name','Roadmap + Intensities EasySpin Simulation','numbertitle','off');
plot3(BresCr1*10, angCr1, normalizedIntCr1,'k','linewidth',2,'DisplayName',center1); % black traces
hold on;
plot3(BresCr2*10, angCr2, normalizedIntCr2,'b','linewidth',2,'DisplayName',center2); % blue traces
legend
title(strcat('Roadmap + Intensities for',{' '},center1,{' '},'and',{' '},center2));
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
%================================%
%}