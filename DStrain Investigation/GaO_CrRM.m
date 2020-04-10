          % spectra from single crystal rotation
%================================================================

clear, clf

%Sys.Nucs = 'Cr'

% Spin parameters
Sys.S = 3/2;
Sys.g = 1.968;
%Sys.gFrame = [0 43 0]*pi/180;  
Sys.lwpp = 3;
%Sys.AFrame = 3;
Exp.Temperature = 298; 

%Opt.Threshold = 0.5;

%Sys.A = [17*2/0.7]


%Sys.D = [13*2.9979 0 -1334*2.9979; 0 3083*2.9979 0; 0 0 -3096*2.9979];
%Sys.D = [13*2.9979  0           -1334*2.9979;...
%       0          3083*2.9979  0;...
%       0          0           -3096*2.9979];
%Dvals = [508*3 3083*3  -3590*3];        % principal values
%DFrame = [10 20 0]*pi/180;   % tilt angles
%A = Sys.D/2.997; 
%e=eig(A);         % full D tensor in its eigenframe
%matric in Yeom - perhaps an error?  Does not give same roadmap as Fig. 3
Sys.B2 = [-1535*3 -2668*3 -1548*3 0 0]; %Yeom's values gives correct roadmap

% Experimental parameters 
Exp.mwFreq = 9.504;
Exp.Range = [0 1600];
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC

%Generate rotations about nL
nL = [1;0;0]; % rotating about mW magnetic field
%cori0 = [0 85 0]*pi/180; %Yeom's a*b it's like a* was on the 'wrong' side of a
%cori0 = [0 0 0]*pi/180; %Yeom's c*b plane 
cori0 = [-90 0 0]*pi/180; %Yeom's c*a plane c,c* matches RM ifenter -1 steps (c c* mislabled in fig) 

rho = (0:-1:-180)*pi/180; %needs to be changed for different cori0s to match fig
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori;

%generate roadmap
Opt.Output = 'separate';  % make sure spectra are not added up
Bres = resfields(Sys,Exp,Opt);

% plotting
plot(Bres,rho*180/pi);
xlabel('magnetic field (mT)');
ylabel('theta (°)');

%Simulate spectra
%Opt.Output = 'separate';  % make sure spectra are not added up
%[B,spc] = pepper(Sys,Exp,Opt);
%[B1,spc1] = eprload('TiO2s5d0.spc');
% plotting

% plot(B1*0.1,spc1/400);
%hold on
%plot(B,spc);
%hold off

% data = [B1(:) spc1(:)];
% save('stoCrsim.txt','data','-ascii');
