clear variables;

% diagonalization of spin Hamiltonian
 sz = [5/2 0 0 0 0 0;...
       0 3/2 0 0 0 0;...
       0 0 1/2 0 0 0;...
       0 0 0 -1/2 0 0;...
       0 0 0 0 -3/2 0;...
       0 0 0 0 0 -5/2];
 sz1 = sz*sz;
 sx = [0 sqrt(5)/2 0 0 0 0;...
       sqrt(5)/2 0 sqrt(8)/2 0 0 0;...
       0 sqrt(8)/2 0 sqrt(9)/2 0 0;...
       0 0 sqrt(9)/2 0 sqrt(8)/2 0;...
       0 0 0 sqrt(8)/2 0 sqrt(5)/2;...
       0 0 0 0 sqrt(5)/2 0];

     
 sy = [1/2]*[0 -i*sqrt(5) 0 0 0 0;...
       i*sqrt(5) 0 -2*i*sqrt(2) 0 0 0;...
       0 2*i*sqrt(2) 0 -3*i 0 0;...
       0 0 3*i 0 -2*i*sqrt(2) 0;...
       0 0 0 2*i*sqrt(2) 0 -i*sqrt(5);...
       0 0 0 0 i*sqrt(5) 0];
 
 %spin Hamiltonian % R. Büscher and G. Lehmann, Z. Naturforsch. 42a, 67-71 (1987);
 
 % H = u*B0*g*S+b20[sz*sz-1/3*s*(s+1)]+1/3*b22*[sx*sx-sy*sy];
 
 % the first term in H, 'T1' below is calculated using direction cosines in R. Büscher and G. Lehmann
 % and first term of equation [13] in Dieter Slebert and Juergen Dahlem, Anal. Chem. 1994, 66, 2640-2646
 
 %g isotropic g-value, u>> bohr magneton, S>> spin operator matrix, 
 %b20>>ZFS (D); b22>> E
 sx1 = sx*sx;
 sy1 = sy*sy;
 s = 5/2;
 s1 = s*(s+1)*eye(2*s + 1);
 %T2 = b20[sz*sz-1/3*s*(s+1)];
 %T3 = 1/3*b22*[sx*sx-sy*sy];
 %Sixfold
 T2 = (3*2213)*(sz1-(1/3)*s1);%b20/cm-1 = 0.2213 (cm-1*3 *10^4 in MHz) 
 T3 = (1/3)*(3*2091)*(sx1-sy1);% b22/cm-1 = 0.2091 Bushcher and lehmann
 
%fourfold
 %T2 = (3*1570)*(sz1-(1/3)*s1);%b20/cm-1 = 0.1336 (cm-1*3 in MHz) D = 3b20 and E =b22
 %T3 = (1/3)*(3*1336)*(sx1-sy1);% b22/cm-1 = 0.1576 Bushcher and lehmann
 
 %C = u*B*g*sz;% g =2.0023; free electron value
 %A0 = sz;% Sm =Sz for n=1, l=m=0 eqn(13) Analytic chem 1994, 66, 2640-2646;
 
 
 %D = eig(H,'matrix');
 B0 = linspace(0,1000,10001);
 g = 2.0043;
 theta = 0*pi/180; %90 is Bperp.b,theta= 0 is B //b
 u0 = 13.996;% bohr magneton-MHz/mT
 
 for i = 1:length(B0)
    
     T1 = u0*g*B0(i)*(cos(theta)*sz+0.4115*sin(theta)*sx-0.9112*sin(theta)*sy);% sixfold
    
    %T1 = u0*g*B0(i)*(cos(theta)*sz+0.213*sin(theta)*sx-0.9770*sin(theta)*sy);% sixfold
    
    %T1 = u0*g*B0(i)*((0.0443*sin(theta)+0.978*cos(theta))*sz+(0.2083*sin(theta)-0.208*cos(theta))*sx...
       % -0.977*sin(theta)*sy);% sixfold w/ m=0 in ab plane
        
    %T1 = u0*g*B0(i)*(cos(theta)*sz-0.9921*sin(theta)*sx+0.1237*sin(theta)*sy);%fourfold
    
     H = -(T1 + T2 + T3);
     [V,D]= eig(H,'vector');
     eigenval(:,i) = D;% ith column of eigenval
     eigenvecs(:,:,i) = V;%ith page of three dimensional array
 end
 eigenvals = [transpose(B0),transpose(eigenval)];

 figure
 plot(B0,eigenvals(:,2),B0,eigenvals(:,3),B0,eigenvals(:,4),B0,eigenvals(:,5)...
     ,B0,eigenvals(:,6),B0,eigenvals(:,7));
 
  
 %%%%%
 %m1 = [-0.9963 0 -0.0854; -0.0854 0 0.9963; 0 1 0];%fourfold
 %m2 = [0.978 0 -0.208; 0 1 0; 0.208 0 0.978];%  a b c* to a* b c
 %m = m1*m2;
 
 %%%%%sixfold 
 %n1 = [0.213 0 0.977; -0.977 0 0.213; 0 1 0];
 %n1*transpose(m2)
 %%%%%
% Note: Fourfold--at 90 deg in diagonalization and 0 deg in easyspin, the energy
% level diagram look similar!!!


% with -sign in Hamiltonian, 0 deg in diag. is similar to 90 deg in easyspin for both sixfold and fourfld.