
%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%
% The MatLab eig() function returns eigenvalues in ascending order,
% therefore it looks like traces never cross if you zoom in enough. They do
% in fact cross, it just looks like the traces bounce off each other.

clear B_0;
clear g;
clear theta;
clear H;
clear eigenvals;
clear eigenvecs;
clear i;

%%%%%%%%%%%% Diagonalization of Spin Hamiltonian %%%%%%%%%%%%

% Define spin operators

S_z = [2 0 0 0 0;...
       0 1 0 0 0;...
       0 0 0 0 0;...
       0 0 0 -1 0;...
       0 0 0 0 -2];
       
 
S_x = [0 1 0 0 0;...
       1 0 sqrt(6)/2 0 0;...
       0 sqrt(6)/2 0 sqrt(6)/2 0;...
       0 0 sqrt(6)/2 0 1;...
       0 0 0 1 0];


S_y = [0 1/i 0 0 0;...
       -1/i 0 sqrt(6)/2i 0 0;...
       0 -sqrt(6)/2i 0 sqrt(6)/2i 0;...
       0 0 -sqrt(6)/2i 0 1/i;...
       0 0 0 -1/i 0];
 
% Spin operators squared
S_xx = S_x * S_x;
S_yy = S_y * S_y;
S_zz = S_z * S_z;
   
% Spin number
s = 2;

% Matrix of S^2 eigenvalue
S_sq = s*(s+1) * eye(2*s + 1);

% Assign static magnetic field and constants
B_0 = linspace(0,1000,1001); % static magnetic field in mT
u_0 = 13.996; % Bohr magneton-MHz/mT
g = 2.002319;

for i = 1:length(B_0)
    
    term1 = g*u_0*B_0(i)*S_z;
    term2 = (3*2213)*(S_zz - (1/3)*S_sq); % b20/cm^-1 = 0.2213 (cm^-1*3*10^4 in MHz) 
    term3 = (1/3)*(3*2091)*(S_xx - S_yy); % b22/cm^-1 = 0.2091 Bushcher and Lehmann
    
    H = term1 + term2 + term3;
    
    [V,E] = eig(H,'vector'); % V is matrix of eigenvectors, D is column of eigenvalues
    
    eigenvals(:,i) = E/1000; % each individual E is the ith column in eigenval
    eigenvecs(:,:,i) = V; % each individual V is the ith item in eigenvecs               
    % eigenvecs is not used, but nice to have for reference
    % basis is |s,m>
    
end

% Assemble data
eigenvals_vs_BField_data = [transpose(B_0),transpose(eigenvals)];

% Plot each column of data separately
plot(B_0,eigenvals_vs_BField_data(:,2),B_0,eigenvals_vs_BField_data(:,3),B_0,eigenvals_vs_BField_data(:,4),B_0,eigenvals_vs_BField_data(:,5),B_0,eigenvals_vs_BField_data(:,6));

title('UAB EPR Energy vs. Magnetic Field Simulation');
xlabel('Magnetic Field (mT)');
ylabel('Energy (GHz)');