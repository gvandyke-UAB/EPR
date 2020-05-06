%Octahedral
%
% Spin parameters
Sys.S = 5/2;
Sys.g = 2.0043;
Sys.lwpp = 1.6;
Exp.Temperature = 300; 

%Sys.D = [2213*3 2091];% Buscher and Lehmann
Sys.B2 = [2091 0 2213 0 0];%

%tetrahedral
%Sys.D = [1576*3 1336];% Buscher and Lehmann 
%Sys.B2 = [1336 0 1576 0 0];%Buscher and Lehmann

% Experimental parameters
Exp.mwFreq = 9.4066;
Exp.Range = [40 1000];%mT
Exp.CrystalSymmetry = 'C2/m';  %assumes 'b' is yC
Exp.nPoints = 1e5;

%Generate rotations about nL
nL = [1;0;0]; % rotating about mW magnetic field
cori0 = [0 0 0]*pi/180;
rho = (0)*pi/180;% 90 deg is 0 deg in our expt ie B//b
%rho = (0:90:180)*pi/180;% B//a is 0 deg
cori = rotatecrystal(cori0,nL,rho);
Exp.CrystalOrientation = cori;
%Opt.Sites = [2 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulate SPECTRA
Opt.Output = 'separate';  % make sure spectra are not added up
[B,spc] = pepper(Sys,Exp,Opt);
% plotting
h2=stackplot(B,spc);
set(h2,'color','k','linewidth',2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%generate ROADMAP
Opt.Output = 'separate';  % make sure spectra are not added up
BresFeOCT = resfields(Sys,Exp,Opt);
%gres=Bres/9.4/715;
ang=rho*180/pi;
plot(BresFeOCT*10,ang,'linewidth',3,'color','k');
%plot((rho*180/pi-90),BresFe*10,'linewidth',3,'color','k');
%plot(BresFe,rho*180/pi,'linewidth',3,'color','k');
%ylabel('Magnetic Field (mT)');
%xlabel('Angle of rotation (°)');
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on