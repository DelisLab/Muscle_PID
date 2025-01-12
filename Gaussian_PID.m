function [R,S,UY,UZ] =Gaussian_PID(Y,Z,X)

%Y and Z are potentially multidimensional source variables
%X is a univariate target variable

%Copula-normalise XYZ variables
x=copnorm(X);
y=copnorm(Y);
z=copnorm(Z);


Ntrl = size(x,1);
vs=[size(y,2),size(z,2),size(x,2)];
xyz = [y z x];
Cxyz = (xyz'*xyz) / (Ntrl - 1);




lat = lattice2d();
lat = calc_pi_mvn(lat, Cxyz, vs, @Iccs_mvn_P2);

R = lat.PI(1);
UY = lat.PI(2);
UZ = lat.PI(3);
S = lat.PI(4);


end
