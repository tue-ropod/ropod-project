syms m  d R I Iw  L theta dtheta ddtheta phir dphir ddphir phil dphil ddphil 


dxq = R/2*(dphir+dphil)*cos(theta);
dyq = R/2*(dphir+dphil)*sin(theta);
% dtheta = R/(2*L)*(dphir-dphil);

dxg = dxq + d* dtheta * sin(theta);
dyg = dyq - d* dtheta * cos(theta);

E= 1/2*m*(dxg^2+dyg^2)  +  1/2*I*dtheta^2  + 1/2*Iw*dphir^2 + 1/2*Iw*dphil^2; 
E=simplify(E)
%%
% E = (m*R^2/8 +I/(8*L^2)*R^2 + Iw/2)*dphir^2 + ...
%     (m*R^2/8 +I/(8*L^2)*R^2 + Iw/2)*dphil^2 + ...
%     (m*R^2/4 -I/(4*L^2)*R^2 )*dphir*dphil;

% Mlag=Lagrange(E,[phir dphir ddphir phil dphil ddphil ])
Mlag=Lagrange(E,[theta dtheta ddtheta phir dphir ddphir phil dphil ddphil ])
% Mlag=Lagrange_nonhol(E,[phir dphir ddphir phil dphil ddphil ],[theta dtheta ddtheta phir dphir ddphir phil dphil ddphil])

M=equationsToMatrix(Mlag,{'ddphir','ddphil'})
D=equationsToMatrix(Mlag,{'dphir','dphil'})