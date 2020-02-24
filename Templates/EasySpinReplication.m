clear variables;

%%%%%%%%%%%% Diagonalization of Spin Hamiltonian %%%%%%%%%%%%


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
S_sq = s*(s+1) * eye(6);


%%%%%%%%%%%%%%%%%%%%%%%%%% Hamiltonian Info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spin Hamiltonian from R. Büscher and G. Lehmann, Z. Naturforsch. 42a, 67-71 (1987);
 
% H = u*B_0*g*S + b20[S_zz - 1/3*s*(s+1)] + 1/3*b22*[S_xx - S_yy]
 
% The first term in H, 'term1' below is calculated using direction cosines in R. Büscher and G. Lehmann
% and the first term of equation [13] in Dieter Slebert and Juergen Dahlem, Anal. Chem. 1994, 66, 2640-2646

% u = Bohr magneton
% g = isotropic g-value
% S = spin operator matrix
% b20 = ZFS (D)
% b22 = E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 

% Sixfold
term2 = (3*2213)*(S_zz - (1/3)*S_sq); % b20/cm^-1 = 0.2213 (cm^-1*3*10^4 in MHz) 
term3 = (1/3)*(3*2091)*(S_xx - S_yy); % b22/cm^-1 = 0.2091 Bushcher and Lehmann
 
% Fourfold
%term2 = (3*1570)*(S_zz - (1/3)*S_sq); % b20/cm^-1 = 0.1336 (cm^-1*3 in MHz) D = 3b20 and E = b22
%term3 = (1/3)*(3*1336)*(S_xx - S_yy); % b22/cm^-1 = 0.1576 Bushcher and Lehmann

B_0 = linspace(0,1000,10001); % static magnetic field
g = 2.0043;
theta = 0 * pi/180; % theta = pi/2 is B_0 perp. to b, theta = 0 is B_0 parallel to b
u_0 = 13.996; % Bohr magneton-MHz/mT
 
for i = 1:length(B_0)
   
    term1 = u_0*g*B_0(i)*(cos(theta)*S_z + 0.4115*sin(theta)*S_x - 0.9112*sin(theta)*S_y); % sixfold
    
    %term1 = u_0*g*B_0(i)*(cos(theta)*S_z + 0.213*sin(theta)*S_x - 0.9770*sin(theta)*S_y); % sixfold
   
    %term1 = u_0*g*B_0(i)*((0.0443*sin(theta) + 0.978*cos(theta))*S_z+(0.2083*sin(theta)-0.208*cos(theta))*S_x...
      % -0.977*sin(theta)*S_y); % Sixfold w/ m=0 in ab plane
     
    %term1 = u_0*g*B_0(i)*(cos(theta)*S_z - 0.9921*sin(theta)*S_x + 0.1237*sin(theta)*S_y); % fourfold
    
    H = -(term1 + term2 + term3); % still unclear why "-" sign is necessary
    
    [V,D] = eig(H,'vector'); % V is matrix of eigenvectors, D is column of eigenvalues
    
    eigenvals(:,i) = D; % each individual D is the ith column of eigenval
    eigenvecs(:,:,i) = V; % each individual V is the ith item in eigenvecs               
    % eigenvecs is not used, but nice to have for reference
    % basis is |s,m>
end

eigenvals_vs_BField_data = [transpose(B_0),transpose(eigenvals)];

plot(B_0,eigenvals_vs_BField_data(:,2),B_0,eigenvals_vs_BField_data(:,3),B_0,eigenvals_vs_BField_data(:,4),B_0,eigenvals_vs_BField_data(:,5)...
    ,B_0,eigenvals_vs_BField_data(:,6),B_0,eigenvals_vs_BField_data(:,7));
    % plots each column of data separately


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Fourfold--at 90 deg in diagonalization and 0 deg in EasySpin, the 
% energy level diagram looks similar!!!

% with "-" sign in Hamiltonian, 0 deg in diag. is similar to 90 deg in 
% EasySpin for both sixfold and fourfld.