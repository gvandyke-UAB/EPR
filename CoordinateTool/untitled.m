xL = [1 0 0];  % rotation axis
N = 31;
[phi,theta] = rotplane(xL,[0 pi],N);
chi = zeros(N,1);
[phi(:) theta(:) chi]