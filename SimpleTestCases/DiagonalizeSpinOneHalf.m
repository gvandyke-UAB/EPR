
clear B_0;
clear g;
clear theta;
clear H;
clear eigenvals;
clear eigenvecs;

%%%%%%%%%%%% Diagonalization of Spin Hamiltonian %%%%%%%%%%%%

% Define spin operators

S_z = [1/2 0;...
       0 -1/2];
       
 
S_x = [0 1/2;...
       1/2 0];

     
S_y = [0 i/2;...
       -i/2 0];
 
% Spin operators squared
S_xx = S_x * S_x;
S_yy = S_y * S_y;
S_zz = S_z * S_z;
   
% Spin number
s = 1/2;

% Matrix of S^2 eigenvalue
S_sq = s*(s+1) * eye(2*s + 1);


B_0 = linspace(0,1000,1001); % static magnetic field in mT
u_0 = 13.996; % Bohr magneton-MHz/mT
g = 2.002319;

for i = 1:length(B_0)
   
    term1 = g*u_0*B_0(i)*S_z;
   
    H = term1;
    
    [V,E] = eig(H,'vector'); % V is matrix of eigenvectors, D is column of eigenvalues
    
    eigenvals(:,i) = E/1000; % each individual D is the ith column of eigenval
    eigenvecs(:,:,i) = V; % each individual V is the ith item in eigenvecs               
    % eigenvecs is not used, but nice to have for reference
    % basis is |s,m>
end

eigenvals_vs_BField_data = [transpose(B_0),transpose(eigenvals)];

plot(B_0,eigenvals_vs_BField_data(:,2),B_0,eigenvals_vs_BField_data(:,3))

title('UAB EPR Energy vs. Magnetic Field Simulation');
xlabel('Magnetic Field (mT)');
ylabel('Energy (GHz)');
    % plots each column of data separately
