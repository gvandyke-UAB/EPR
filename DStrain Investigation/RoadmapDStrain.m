
% This script generates roadmap plots and outputs a CSV .txt file with the
% roadmap data

 % clears all variables and figures
clear Sys;
center1 = 'Fe3+';
center2 = 'Cr';
%%%%%%%%%%%%%%%%%%%% Title %%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; 
rho = (90:2:270) * pi/180;
cori = rotatecrystal(cori0,nL,rho);
%================================%


%%%%%%%%%% Spin system parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.962 1.964 1.979];
Sys.lwpp = 1.6;
%Sys.D = [1535*3 1548];
%Sys.DStrain = [100 20];
Sys.B2 = [-3*1535 -3*2668 -3*1548 0 0]; % Extended Stevens parameters
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.504;
Exp.Range = [50 1100];
Exp.Temperature = 298;
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.CrystalOrientation = cori; % this Exp paramenter must be defined after cori
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

