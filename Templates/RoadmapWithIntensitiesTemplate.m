% This file generates a roadmap with a third axis representing relative
% intensity. General structure is: define Sys, Exp, and Opt, generate data,
% normalize, plot


clear all;
clf % clears all variables and figures

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
[BresCr, IntCr] = resfields(Sys,Exp,Opt);
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
Sys.g= [2.004 2.002 2.007];
Sys.D = [3*5385 3*1288];
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
[BresFe, IntFe] = resfields(Sys,Exp,Opt);
angFe = rho * 180/pi - 90;
%================================%


%%%%%%%%%% Overall Normalization %%%%%%%%%%
setToOne = max(max(IntFe,[],'all'), max(IntCr,[],'all')); % find which value to regard as our "1"
normalizedIntFe = IntFe / setToOne;
normalizedIntCr = IntCr / setToOne;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot3(BresFe*10, angFe, normalizedIntFe,'b','linewidth',2,'DisplayName','Fe'); % blue traces
hold on;
plot3(BresCr*10, angCr, normalizedIntCr,'k','linewidth',2,'DisplayName','Cr'); % black traces
legend
title('Roadmap + Intensities for Fe3+ and Cr');
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
%================================%
