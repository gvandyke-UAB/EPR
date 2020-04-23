          % spectra from single crystal rotation
%================================================================

clear, clf

%Sys.Nucs = 'Cr'

% Spin parameters
Sys.S = 3/2;
Sys.g = 1.968;
Sys.lwpp = 3;
Exp.Temperature = 298; 

Sys.B2 = [-1535*3 -2668*3 -1548*3 0 0]; %Yeom's values gives correct roadmap

% Experimental parameters 
Exp.mwFreq = 9.504;
Exp.Range = [0 1600];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC

%Generate rotations about xL
xL = [1;0;0]; % rotating about mW magnetic field
%cori0 = [0 85 0]*pi/180; %Yeom's a*b it's like a* was on the 'wrong' side of a
%cori0 = [0 0 0]*pi/180; %Yeom's c*b plane 
cori0 = [-90 0 0]*pi/180; %Yeom's c*a plane c,c* matches RM ifenter -1 steps (c c* mislabled in fig) 

rho = (0:-1:-180)*pi/180; %needs to be changed for different cori0s to match fig
cori = rotatecrystal(cori0,xL,rho);
Exp.CrystalOrientation = cori;

%generate roadmap
Opt.Output = 'separate';  % make sure spectra are not added up
Bres = resfields(Sys,Exp,Opt);

% plotting
plot(Bres,rho*180/pi);
xlabel('magnetic field (mT)');
ylabel('theta (°)');
