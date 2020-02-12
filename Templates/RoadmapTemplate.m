
clear, clf % clears all variables and figures

%%%%%%%%%%%%%%%%%%%% Title %%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 3/2;
%Sys.Nucs = 'Cr'
%Sys.Abund
Sys.g = [1.968 0 -0.008; 0 1.964 0; 0 0 1.973];
%Sys.gFrame = [0 43 0] * pi/180;
%Sys.A
%Sys.A_
%Sys.AFrame = 3;
%Sys.Q
%Sys.QFrame
Sys.D = [3*5385 3*1288];
%Sys.DFrame
%Sys.af
%Sys.B0, B2, B4, B6, B8, B10, B12
%Sys.J
%Sys.dvec
%Sys.eeD
%Sys.ee
%Sys.eeFrame
%Sys.ee2
%Sys.nn
%Sys.nnFrame
%Sys.L
%Sys.CF0, CF2, CF4, CF6, CF8, CF10, CF12
%Sys.orf
%Sys.soc
%Sys.Ham
Sys.lwpp = 1.6;
%Sys.lw
%Sys.lwEndor
%Sys.HStrain
%Sys.gStrain, AStrain, gAStrainCorr, DStrain, DStrainCorr
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.4066;
%Exp.mwPhase
%Exp.CenterSweep
Exp.Range = [50 1100];
%Exp.nPoints
%Exp.Harmonic
%Exp.ModAmp
%Exp.Mode
Exp.Temperature = 298;
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
% See pepper documentation for other options
%Opt.Threshold = 0.5;
%Opt.Verbosity
%Opt.Sites
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; 
rho = (90:2:270) * pi/180;
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori; % this Exp paramenter must be defined after cori
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresCr = resfields(Sys,Exp,Opt);
%================================%


%%%%%%%%%% Import .txt data %%%%%%%%%%
%BA = dlmread('FeGaOangBmT1.txt');
%x = BA(:,1);
%y = BA(:,2);
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresCr*10,rho * 180/pi - 90,'linewidth',3,'color','b'); % blue traces
xlabel('Magnetic Field (mT)');
ylabel('Angle (�)');
hold on % keeps previous plots displayed
%================================%


%%%%%%%%%% Save data to a .txt %%%%%%%%%%
pointsCr = makeResfieldsCSVtxt(BresCr, rho, 'BresCr');

% The .txt file now follows the formatting:

%Trace 1 X |Trace 1 Y |Trace 2 X |Trace 2 Y |.....
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%=================================================%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% At this point, define new Sys, Exp, and Opt parameters %%%%%%%
%%%%%%% for the following roadmap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresFe = resfields(Sys,Exp,Opt);
%gres = Bres/9.4/715;
ang = rho * 180/pi - 90;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresFe*10,ang,'linewidth',3,'color','k'); % black traces
%================================%


%%%%%%%%%% Save data to .txt %%%%%%%%%%
pointsFe = makeResfieldsCSVtxt(BresFe, rho, 'BresFe');

%The .txt file now follows the formatting:

%Trace 1 X |Trace 1 Y |Trace 2 X |Trace 2 Y |.....
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%=================================================%


%%%%%%%%%% Combine .txt files %%%%%%%%%%
totalRoadMapData = combinetxt(pointsFe,pointsCr);
writecell(totalRoadMapData, 'CombinedRoadmap.txt');
%================================%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% UAB-written functions %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following function takes two CSV-style .txt files and horizontally
% concatenates them.

function finaltxt = combinetxt(x,y)
% if the matrices we want to combine into one .txt file are of different
% size, insert NaN at the bottom of the shorter one until they match length
if size(x,1) == size(y,1)
    finaltxt = [x,y]; % if they're compatible sizes, great
elseif size(x,1) > size(y,1) % if the first one is bigger, pad the second one with NaNs
    numNans = size(x,1) - size(y,1);
    rowofnans = nan(size(y,2));
    for i = 1:numNans
        y = [y;rowofnans];
    end
    finaltxt = [x,y];
elseif size(x,1) < size(y,1)
    numNans = size(y,1) - size(x,1);
    rowofnans = nan(1,size(x,2));
    for i = 1:numNans
        x = [x;rowofnans];
    end
    finaltxt = [x,y];
end

% first two rows are name and units
names = {};
units = {};
for i = 1:size(finaltxt,2)/2
    names = horzcat(names, {'Magnetic Field', 'Angle'});
    units = horzcat(units, {'Gauss', 'Degrees'});   
end

finaltxt = [names; units; num2cell(finaltxt)];

end

% The following function takes resfield and rho data and turns it into a
% CSV-style .txt file

function resfieldsCSV = makeResfieldsCSVtxt(xdata, rho, filename)
% For some reason, the resfields function returns duplicated data, so first
% we cut our matrix in half
desiredBresRows = size(xdata,1)/2;
Bresdata = xdata(1:desiredBresRows, 1:size(xdata,2))';

% Crete angle matrix
ydata = rho * 180/pi -90;
ydata = ydata'; % Transpose it

% initialize data as the x & y coordinates from the first trace
resfieldsCSV = [Bresdata(:,1)*10 ydata];

% this loop adds however other many traces there are
for i = 2:desiredBresRows
    resfieldsCSV = [resfieldsCSV Bresdata(:,i)*10 ydata];
end

save(strcat(filename, 'Roadmap.txt'),'resfieldsCSV','-ascii');

end
%=====================================================================%
