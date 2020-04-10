% This file generates a roadmap with a third axis representing relative
% intensity. General structure is: define Sys, Exp, and Opt, generate data,
% normalize, plot


clear all;
clf % clears all variables and figures

% Name your EPR centers here, used for plot formatting later
center1 = 'Cr';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cr lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; % align vertical of sample with mw Field
rho = (90:3:270) * pi/180; % 90 deg is 0 deg in our experiment i.e. B_0//b
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.968 0 -.008;...
         0 1.964 0;...
         -.008 0 1.973];
     
%Sys.D = [3*1548 1288];

Sys.B2 = [1535 2668 1548 0 0];
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
Exp.CrystalOrientation = cori;
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
set(gcf, 'Name','Roadmap + Intensities EasySpin Simulation','numbertitle','off');
plot3(BresCr, angCr, normalizedIntFe1,'k','linewidth',2,'DisplayName',center1); % black traces
hold on;
legend
title(strcat('Roadmap + Intensities for',{' '},center1,{' '}));
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
%================================%
