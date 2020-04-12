% spectra from single crystal rotation
%================================================================

clear, clf

% Spin parameters
Sys.S = 3/2;
Sys.g = [1.962 1.964 1.979];
Sys.lwpp = 1.6;
%Sys.D = [1535*3 1548];
Sys.B2 = [1535 2668 1548 0 0];

% Experimental parameters
Exp.mwFreq = 9.504;
Exp.Range = [0 1500];
Exp.CrystalSymmetry = 'C2/m';

% Generate orientations in a single rotation plane
xL = [1;0;0]; % rotating about mw magnetic field (axis of rotation is vertical)
N = 31;
[phi,theta] = rotplane(xL,[0 pi],N);
chi = zeros(N,1);
Exp.CrystalOrientation = [phi(:) theta(:) chi];

% Simulate spectra
Opt.Output = 'separate';  % make sure spectra are not added up
[B,spc] = pepper(Sys,Exp,Opt);

% plotting
stackplot(B,spc);