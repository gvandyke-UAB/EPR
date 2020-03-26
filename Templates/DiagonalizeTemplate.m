
% This script plots energy eigenvalues as a function of magnetic field
% without using any EasySpin functions

clear variables;

%%%%%%%%%%%% Diagonalization of Spin Hamiltonian %%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Hamiltonian Info %%%%%%%%%%%%%%%%%%%%%%%
% Spin Hamiltonian from R. Büscher and G. Lehmann, Z. Naturforsch. 42a, 67-71 (1987);
 
% H = u_B*B_0*g*S + b20[S_zz - 1/3*s*(s+1)] + 1/3*b22*[S_xx - S_yy]
 
% The first term in H, 'term1' below is calculated using direction cosines in R. Büscher and G. Lehmann
% and the first term of equation [13] in Dieter Slebert and Juergen Dahlem, Anal. Chem. 1994, 66, 2640-2646

% u_B = Bohr magneton
% g = isotropic g-value
% S = spin operator matrix
% b20 = ZFS (D)
% b22 = E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Define spin operators

S_z = [5/2 0 0 0 0 0;...
       0 3/2 0 0 0 0;...
       0 0 1/2 0 0 0;...
       0 0 0 -1/2 0 0;...
       0 0 0 0 -3/2 0;...
       0 0 0 0 0 -5/2];
   
 
S_x = [0 sqrt(5)/2 0 0 0 0;...
       sqrt(5)/2 0 sqrt(8)/2 0 0 0;...
       0 sqrt(8)/2 0 sqrt(9)/2 0 0;...
       0 0 sqrt(9)/2 0 sqrt(8)/2 0;...
       0 0 0 sqrt(8)/2 0 sqrt(5)/2;...
       0 0 0 0 sqrt(5)/2 0];

     
S_y = (1/2)*[0 -i*sqrt(5) 0 0 0 0;...
       i*sqrt(5) 0 -2*i*sqrt(2) 0 0 0;...
       0 2*i*sqrt(2) 0 -3*i 0 0;...
       0 0 3*i 0 -2*i*sqrt(2) 0;...
       0 0 0 2*i*sqrt(2) 0 -i*sqrt(5);...
       0 0 0 0 i*sqrt(5) 0];
 
% Spin operators squared
S_xx = S_x * S_x;
S_yy = S_y * S_y;
S_zz = S_z * S_z;
   
% Spin number
s = 5/2;

% Matrix of S^2 eigenvalue
S_sq = s*(s+1) * eye(2*s + 1);

% Sixfold
term2 = (3*2213)*(S_zz - (1/3)*S_sq); % b20/cm^-1 = 0.2213 (cm^-1*3*10^4 in MHz) 
term3 = (1/3)*(3*2091)*(S_xx - S_yy); % b22/cm^-1 = 0.2091 Bushcher and Lehmann
 
% Fourfold
%term2 = (3*1570)*(S_zz - (1/3)*S_sq); % b20/cm^-1 = 0.1336 (cm^-1*3 in MHz) D = 3b20 and E = b22
%term3 = (1/3)*(3*1336)*(S_xx - S_yy); % b22/cm^-1 = 0.1576 Bushcher and Lehmann

% Assign static magnetic field and constants
B_0 = linspace(0,1000,1001); % static magnetic field in mT
g = 2.0043;
u_0 = 13.996; % Bohr magneton-MHz/mT

for i = 1:length(B_0)
   
    term1 = u_0*g*B_0(i)*S_z; % sixfold
   
    H = term1 + term2 + term3;
    
    [V,D] = eig(H,'vector'); % V is matrix of eigenvectors, D is column of eigenvalues
    
    eigenvals(:,i) = D/1000; % each individual D is the ith column of eigenval
    eigenvecs(:,:,i) = V; % each individual V is the ith item in eigenvecs               
    % eigenvecs is only calculated for reference
    % basis is |s,m>
end

% assemble data
eigenvals_vs_BField_data = [transpose(B_0),transpose(eigenvals)];

% plot
for i = 2:size(eigenvals_vs_BField_data,2)
    plot(B_0,eigenvals_vs_BField_data(:,i))
    hold on
end

set(gcf,'name','Energy Eigenvalues UAB Simulation','numbertitle','off');
title('UAB EPR Energy vs. Magnetic Field Simulation');
xlabel('Magnetic Field (mT)');
ylabel('Energy (GHz)');
