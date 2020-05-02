
% This script generates roadmap plots and outputs a CSV .txt file with the
% roadmap data

clear, clf % clears all variables and figures

%%%%%%%%%%%%%%%%%%%% Title %%%%%%%%%%%%%%%%%%%%

center1 = 'Fe3+';
center2 = 'Cr3+';
startAng = 90; % for a*b plane [0 103 0], 0 makes -a*//B_0, 90 makes b//B_0
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


%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.968 0 -0.008; 0 1.964 0; 0 0 1.973];
Sys.D = [3*5385 3*1288];
Sys.lwpp = 1.6;
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.Temperature = 298;
Exp.CrystalSymmetry = 'C2/m'; % Assumes 'b' is yC
Exp.CrystalOrientation = crystalOri;
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresCr = resfields(Sys,Exp,Opt);
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresCr*10,rho * 180/pi - 90,'linewidth',3,'color','b'); % blue traces
xlabel('Magnetic Field (mT)');
ylabel('Angle (°)');
hold on % keeps previous plots displayed
%================================%


%%%%%%%%%% Save data to a .txt %%%%%%%%%%
pointsCr = makeResfieldsCSVtxt(BresCr, rho, 'BresCr');
%================================%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% At this point, define new Sys, Exp, and Opt parameters %%%%%%%
%%%%%%% for the roadmap you'd like to overlay %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g= [2.004 2.002 2.007];
Sys.D = [3*5385 3*1288];
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresFe = resfields(Sys,Exp,Opt);
ang = rho * 180/pi - 90;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresFe*10,ang,'linewidth',3,'color','k'); % black traces

set(gcf, 'Name','Roadmap EasySpin Simulation','numbertitle','off');
title(strcat('Roadmap + Intensities for',{' '}, center1,{' '}, 'and',{' '}, center2));
%================================%


%%%%%%%%%% Save data to .txt %%%%%%%%%%
pointsFe = makeResfieldsCSVtxt(BresFe, rho, 'BresFe');
%================================%


%%%%%%%%%% Combine .txt files %%%%%%%%%%
totalRoadMapData = combinetxt(pointsFe,pointsCr);
writecell(totalRoadMapData, 'CombinedRoadmap.txt');
%================================%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% UAB-written functions %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following function takes two CSV-style .txt files and horizontally
% concatenates them. It also adds units to the top of the CSV, change as
% necessary.

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

% The .txt file now follows the formatting:

%Trace 1 X |Trace 1 Y |Trace 2 X |Trace 2 Y |.....
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |
%          |          |          |          |


%=====================================================================%

