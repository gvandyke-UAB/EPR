
clear all;
clf % clears all variables and figures

%%%%%%%%%%%%%%%%%%%% Cr lines %%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.968 0 -0.008; 0 1.964 0; 0 0 1.973];
%Sys.lwpp = .3; 
Sys.D = [3*5385 3*1288];
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.Temperature = 4000; 
%================================%


%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; 
rho = (90:2:270) * pi/180;
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori; % this Exp paramenter must be defined after cori
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresCr, CrInt, CrWidth] = resfields(Sys,Exp,Opt);
angCr = rho * 180/pi - 90;
[normalizedIntCr, maxCr] = normInt(CrInt); % normalize intensities to itself
%================================%



%%%%%%%%%%%%%%%%%%%% Fe3+ lines %%%%%%%%%%%%%%%%%%%%

% Octahedral

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g= [2.004 2.002 2.007];
%Sys.lwpp = .3;
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
%================================%


%%%%%%%%%% Generate rotations about nL %%%%%%%%%%
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 102 0] * pi/180; % align vertical of sample with mw Field
rho = (90:3:270) * pi/180; % 90 deg is 0 deg in our expt ie B//b
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori; % this Exp paramenter must be defined after cori
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
[BresFe, FeInt] = resfields(Sys,Exp,Opt);
angFe = rho * 180/pi - 90;
[normalizedIntFe, maxFe] = normInt(FeInt); % normalize intensities to itself
%================================%


%%%%%%%%% Overall Normalization %%%%%%%%%
setToOne = max(maxFe, maxCr); % find which value to regard as our "1"
normalizedIntFe = normalizedIntFe * maxFe / setToOne; % "undoes" normalization then redoes it with global max val
normalizedIntCr = normalizedIntCr * maxCr / setToOne; % this technique is ridiculous but works


%%%%%%%%%% Plotting %%%%%%%%%%
plot3(BresFe*10, angFe, normalizedIntFe,'b','linewidth',2,'DisplayName','Fe'); % blue traces
hold on;
plot3(BresCr*10, angCr, normalizedIntCr,'k','linewidth',2,'DisplayName','Cr'); % black traces
legend
xlabel('Magnetic Field (mT)');
ylabel('Angle of rotation (°)');
zlabel('Relative Intensity (a.u.)');
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

% The following function takes in the intensities outputted by resfields
% and normalizes them all to 1
function [normalizedIntensities, maxVal] = normInt(intMatrix)

maxVal = intMatrix(1,1);

for i = 1:size(intMatrix,1)
    for j = 1:size(intMatrix,2)
        if maxVal <= intMatrix(i,j)
            maxVal = intMatrix(i,j);
        end
    end
end

normalizedIntensities = intMatrix/maxVal;

end
%=====================================================================%

