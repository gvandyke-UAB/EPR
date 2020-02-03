
clear, clf % clears all variables and figures

%%%%%%%%%%%%%%%%%%%% Cr lines %%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 3/2;
Sys.g = [1.968 0 -0.008; 0 1.964 0; 0 0 1.973];
%Sys.gFrame = [0 43 0] * pi/180;  
Sys.lwpp = 1.6;
%Sys.Nucs = 'Cr'
%Sys.AFrame = 3;
%Sys.A = [17 * 2/0.7]
%Sys.D = [13*2.9979 0 -1334*2.9979; 0 3083*2.9979 0; 0 0 -3096*2.2979];  
Sys.D = [3*5385 3*1288];
%================================%


%%%%%%%%%% Optional parameters %%%%%%%%%%
%Opt.Threshold = 0.5;
Opt.Output = 'separate'; % make sure spectra are not added up
%================================%


%%%%%%%%%% Experimental parameters %%%%%%%%%%
Exp.mwFreq = 9.4066;
Exp.Range = [50 1100];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.Temperature = 298; 
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


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresCr*10,rho * 180/pi - 90,'linewidth',3,'color','b'); % blue traces
xlabel('Magnetic Field (mT)');
ylabel('Angle (°)');
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


%%%%%%%%%% Import B field data %%%%%%%%%%
%BA = dlmread('FeGaOangBmT1.txt');
%x = BA(:,1);
%y = BA(:,2);
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
%scatter (x, y + 90);
%hold on
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
%Bres = resfields(Sys,Exp,Opt);
%gres = Bres / 9.4 / 715;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
%plot(rho * 180/pi,Bres,'linewidth',3,'color','red');
%ylabel('Magnetic Field (mT)');
%xlabel('Angle of rotation (°)');
%legend('Ga2O3:Cr, rotation about horiz. edge in a*b plane','location','south');
%================================%


%%%%%%%%%% Save data to a .txt %%%%%%%%%%
%data = [B(:)*10 spc(:)*8000];
%save('GaO_Cr_90D1.txt','data','-ascii');
%================================%



%================================================================%
            % spectra from single crystal rotation %
%================================================================%

%%%%%%%%%%%%%%%%%%%% Fe3+ %%%%%%%%%%%%%%%%%%%%

% Octahedral

%%%%%%%%%% Spin parameters %%%%%%%%%%
Sys.S = 5/2;
%Sys.g = 2.0043;
Sys.g= [2.004 2.002 2.007];
% Sys.gFrame = [0 24 0] * pi/180;  % 24o rotation about y to be consistent with Yamaga(Phs Rev 68)
Sys.lwpp = 1.6;
%Sys.D = [2210*3 2190]; % Fits 0 deg data better with these parameters
%Sys.D = [2210*3 2050]; % Buscher and Lehmann
%Sys.D = [6635 2015];
% reproduces RT angle dependence of Ga2O3:Mg doped sample well except for
% relative line intensities
%================================%


%%%%%%%%%% Optional Parameters %%%%%%%%%%
%Opt.Threshold = 0.95;
%Opt.Sites = [2 1];
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
%cori0 = [0 102 0];
cori0 = [0 102 0] * pi/180; % align vertical of sample with mw Field
rho = (90:3:270) * pi/180; % 90 deg is 0 deg in our expt ie B//b
%cori0 = [0 76.2 180] * pi/180; % B//a in ab plane ( rotation about c* axis)
%rho = (0:90:180) * pi/180; % B//a is 0 deg
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori; % this Exp paramenter must be defined after cori
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
%Bres = resfields(Sys,Exp,Opt);
%BA = dlmread('GaORTang.txt'); % data from .txt into a matrix
%x = BA(:,1);
%y = BA(:,2);
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
%scatter(x,y+90);
%hold on
%plot(Bres,rho*180/pi);
%xlabel('magnetic field (mT)');
%ylabel('theta (°)');
%hold off
%================================%


%%%%%%%%%% Simulate spectra %%%%%%%%%%
%[B,spc] = pepper(Sys,Exp,Opt);
%[B1,spc1] = eprload('TiO2s5d0.spc');
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
%plot(B1*0.1, spc1/400);
%hold on
%plot(B,spc);
%stackplot(B,spc);
%hold off
%================================%


%%%%%%%%%% Save data to .txt %%%%%%%%%%
%data = [B(:)*10 spc(:)*8000];
%save('GaOFespc_90D3.txt','data','-ascii');
%================================%


%%%%%%%%%% Generate B field roadmap data %%%%%%%%%%
BresFe = resfields(Sys,Exp,Opt);
%gres = Bres/9.4/715;
ang = rho * 180/pi - 90;
%================================%


%%%%%%%%%% Plotting %%%%%%%%%%
plot(BresFe*10,ang,'linewidth',3,'color','k'); % black traces
%plot((rho*180/pi-90),BresFe*10,'linewidth',3,'color','k');
%plot(BresFe,rho*180/pi,'linewidth',3,'color','k');
%ylabel('Magnetic Field (mT)');
%xlabel('Angle of rotation (°)');
%legend('Ga2O3:Mg, rotation about axis horiz. edge in a*b plane','location','south');
%}
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
save('CombinedRoadmap.txt','totalRoadMapData','-ascii');
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
points = [Bresdata(:,1)*10 ydata];

% this loop adds however other many traces there are
for i = 2:desiredBresRows
    points = [points Bresdata(:,i)*10 ydata];
end

resfieldsCSV = points;
save(strcat(filename, 'Roadmap.txt'),'points','-ascii');

end
%=====================================================================%

