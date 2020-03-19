
clear, clf % clears all variables and figures

%================================================================%
            % spectra from single crystal rotation %
%================================================================%

%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%

% Octahedral

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
Sys.g= [2.004 2.002 2.007];
Sys.lwpp = 1.6;
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
[BresFe, Int] = resfields(Sys,Exp,Opt);
ang = rho * 180/pi - 90;
%================================%

normalizedInt = normInt(Int);

%%%%%%%%%% Plotting %%%%%%%%%%
plot3(BresFe*10, ang, normalizedInt);
ylabel('Magnetic Field (mT)');
xlabel('Angle of rotation (°)');
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
function normalizedIntensities = normInt(intMatrix)

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

