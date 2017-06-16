clearvars
syms s_w d_w l_CW r_w xc yc theta dxc dyc dtheta  ddxc ddyc ddtheta 

% % For 4 wheels
CW= [l_CW  l_CW -l_CW -l_CW;
     l_CW -l_CW -l_CW l_CW]; 

Nwheels = size(CW,2);


delta     = sym('delta',[1,Nwheels]); 
ddelta     = sym('ddelta',[1,Nwheels]); 
dddelta     = sym('dddelta',[1,Nwheels]); 

varphi    = sym('varphi',[2,Nwheels]); 
dvarphi    = sym('dvarphi',[2,Nwheels]); 
ddvarphi    = sym('ddvarphi',[2,Nwheels]); 

for i=1:Nwheels
    
    % Point of contact each wheel
    xwi= xc + CW(1,i)*cos(theta) - CW(2,i)*sin(theta);
    ywi= yc + CW(1,i)*sin(theta) + CW(2,i)*cos(theta);
    
    % Unconstrained Middle point of axis between wheels
    xgi = xwi -s_w*cos(theta + delta(i));
    ygi = ywi -s_w*sin(theta + delta(i));
    
    % Unconstrained Middle point of caster offset axis
    xgsi = xwi -s_w/2*cos(theta + delta(i));
    ygsi = ywi -s_w/2*sin(theta + delta(i));
    
    % Unconstrained Middle point fo left wheel
    xwil= xgi-d_w/2*sin(theta + delta(i));
    ywil= ygi+d_w/2*cos(theta + delta(i));
    
    % Unconstrained Middle point fo right wheel
    xwir= xgi+d_w/2*sin(theta + delta(i));
    ywir= ygi-d_w/2*cos(theta + delta(i));
    
    % diffMtime(xwi, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta])
    % Unconstrained velocities
    dxg(i) = diffMtime(xgi, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    dyg(i) = diffMtime(ygi, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    
    dxgs(i) = diffMtime(xgsi, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    dygs(i) = diffMtime(ygsi, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    
    dxwl(i) = diffMtime(xwil, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    dywl(i) = diffMtime(ywil, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    
    dxwr(i) = diffMtime(xwir, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    dywr(i) = diffMtime(ywir, [xc dxc ddxc yc dyc ddyc theta dtheta ddtheta ...
        delta(i) ddelta(i) dddelta(i) ]);
    
    
    Wi_noslip(i) = dxg(i)*sin(theta + delta(i)) - dyg(i)*cos(theta + delta(i));
    Wil_proll(i) = dxwl(i)*cos(theta + delta(i)) + dywl(i)*sin(theta + delta(i)) - r_w*dvarphi(1,i);
    Wir_proll(i) = dxwr(i)*cos(theta + delta(i)) + dywr(i)*sin(theta + delta(i)) - r_w*dvarphi(2,i);
    
end
%% Lagrange construction
syms Mr     % Robot base mass
syms Ir     % Robot base inertia around z-axes
syms Mwma   % Mass of the wheel's main axis
syms Iwma   % Inertia of the wheel's main axis around z-axes
syms Mwca   % Mass of the caster offset axis 
syms Iwca   % Inertia of the caster offset axis around z-axes
syms Mw     % Mass of an individual wheel
syms Iwz    % Inertia of an individual wheel around z-axes (around diameter)
syms Iwp    % Inertia of an individual wheel around y^W-axis (rolling)
% Mw = 0; Mwca=6; Iwca=0; Iwz =0;

% Lagrange equations
E_Mr    = 1/2*Mr*dxc^2 + 1/2*Mr*dyc^2;
E_Ir    = 1/2*Ir*dtheta^2;

E_Mwma = 0;
E_Iwma = 0;
E_Mwca = 0;
E_Iwca = 0;
E_Mwl   = 0;
E_Iwzl   = 0;
E_Iwpl  = 0;
E_Mwr   = 0;
E_Iwzr   = 0;
E_Iwpr  = 0;
for i=1:Nwheels  
    % Wheel's main axis kinetic energy
    E_Mwma = E_Mwma + 1/2*Mwma*dxg(i)^2 + 1/2*Mwma*dyg(i)^2;
    E_Iwma = E_Iwma + 1/2*Iwma*( dtheta + ddelta(i) )^2;
    
    % Wheel's caster offset axis kinetic energy
    E_Mwca = E_Mwca + 1/2*Mwca*dxgs(i)^2 + 1/2*Mwca*dygs(i)^2;
    E_Iwca = E_Iwca + 1/2*Iwca*( dtheta + ddelta(i) )^2;
    
    % Left wheel's kinetic energy
    E_Mwl = E_Mwl + 1/2*Mw*dxwl(i)^2 + 1/2*Mw*dywl(i)^2;
    E_Iwzl = E_Iwzl + 1/2*Iwz*( dtheta + ddelta(i) )^2;
    E_Iwpl = E_Iwpl + 1/2*Iwp*( dvarphi(1,i) )^2;
    
    % Right wheel's kinetic energy
    E_Mwr = E_Mwr + 1/2*Mw*dxwr(i)^2 + 1/2*Mw*dywr(i)^2;
    E_Iwzr = E_Iwzr + 1/2*Iwz*( dtheta + ddelta(i) )^2;
    E_Iwpr = E_Iwpr + 1/2*Iwp*( dvarphi(2,i) )^2;
end

E =     E_Mr + E_Ir + E_Mwma + E_Iwma + E_Mwca + E_Iwca ...
    +   E_Mwl + E_Iwzl + E_Iwpl + E_Mwr + E_Iwzr + E_Iwpr;

E = simplify(E);
E = expand(E);


% Vector definitions
% if Nwheels == 4

q = [xc ; yc ; theta; delta.'];
dq= [dxc ; dyc ; dtheta ; ddelta.'];
ddq= [ddxc ; ddyc ; ddtheta; dddelta.'];
diffvec = [  xc; dxc; ddxc; yc; dyc; ddyc; theta; dtheta; ddtheta];

for i=1:Nwheels
    q   = [q;  varphi(:,i)];
    dq  = [dq;  dvarphi(:,i)];
    ddq = [ddq; ddvarphi(:,i)];
    diffvec = [ diffvec; delta(i); ddelta(i); dddelta(i)];
end
for i=1:Nwheels
    diffvec = [ diffvec; varphi(1,i); dvarphi(1,i); ddvarphi(1,i); varphi(2,i); dvarphi(2,i); ddvarphi(2,i);];
end
    
% Torques are applied directly in the varphi variable coordinate.
% This definition of S is be used for modelling purposes
S = [zeros(length(q)-2*Nwheels,2*Nwheels);
     eye(2*Nwheels)];
                  
B = 2*sympoly2sm(E,dq);                  
                  
B = simplify(B);                  
Lageq=Lagrange(E,diffvec);  
Lageq=simplify(Lageq.');            
n = simplify(Lageq-B*ddq);

ActivecasterwheelRobot_InvKinMod;
v = [dxc; dyc; dtheta];
Gv = G*v;
nv = simplify(subs(n,dq,Gv));

dG=diffMtime(G,diffvec);   

  
M = simplify(G.'*B*G);
m = G.'*B*dG*v+G.'*nv;
GtS = simplify(G.'*S);

mtest = simplify(subs(m,dq,Gv));


% For control we use a different S definition 
% The second definition of S can be used for control purposes, the input 
% is then defined as torques directly on x y theta. It allows to compute
% the inversed dynamics for feedback linearization. 
% The calculated torques need to be transformed to the torques at wheel
% Such transformation is not unique but we can assume we want to distribute
% equally forces and torques among the wheels and then is unique
Sc = [eye(3);
     zeros(length(q)-3,3)];
GtSc = simplify(G.'*Sc);
GtSc_inv = simplify(inv(GtSc));

ActivecasterwheelRobot_KinMod;
JqwT = Jqw.';
