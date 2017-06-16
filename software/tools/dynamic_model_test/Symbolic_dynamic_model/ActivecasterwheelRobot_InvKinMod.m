% Symbolic calculation of ropod inverse kinematic model
% v1.0
% Author: 
%   César López -  Start day: 12/04/2017
% Comments: 
%   - Matlab Symbolic toolbox required
%   - Vectors are defined as column vectors with the first row as
%   x coordinate and the second row y coordinate.

syms s_w d_w l_CW r_w theta

% l_CW = 0.3;
% d_w = 0.08;
% s_w = 0.01;
% r_w= 0.11/2;

% Nwheels = 4;
% CW     = sym('CW',[2,Nwheels]); 
% CW= [l_CW  l_CW -l_CW -l_CW;
%      l_CW -l_CW -l_CW l_CW];

Nwheels = size(CW,2);


delta     = sym('delta',[1,Nwheels]); % delta is known.
ddelta     = sym('ddelta',[1,Nwheels]); % derivative of delta
ddeltaeq     = sym('ddeltaeq',[1,Nwheels]); % derivative of delta
vR_W    = sym('VRW',[2,Nwheels]); % vectors (columns) of Wi velocities in Robot coordinates
vW_W    = sym('vW_W',[2,Nwheels]); % vectors (columns) of Wi velocities in Wheel pair coordinates.
V_wh    = sym('V_wh',[2,Nwheels]);  % vectors (columns) of wheels velocities in m/s per Wheel pair. First row is left wheel. 
W_wh    = sym('W_wh',[2,Nwheels]); %  vectors (columns) of wheels velocities per Wheel pair. First row is left wheel.

vI_R    = sym('vI_R',[2 1]);  % vector of velocity robot in Inertial frame
wI_R    = sym('wI_R',[1 1]);  % robot angular velocity in th Inertial frame

% To convert from Inertial frame, to Robot frame, velocities in inertia frame
% need to be rotated by -theta
vR_R = [   cos(-theta)     -sin(-theta); ...
                    sin(-theta)     cos(-theta)]*vI_R;
wR_R = wI_R;


for i=1:Nwheels    
    % To obtain pivot velocities in Robot coordinates, add vectors of
    % translations and movement due to angular velocity.
    vR_W(:,i) = [1 0 -CW(2,i);
                 0 1  CW(1,i)]*[vR_R; wR_R];
    
    % Rotation to obtain pivot Wi velocity vector in wheel coordinates
    vW_W(:,i) = [   cos(-delta(i))     -sin(-delta(i)); ...
                    sin(-delta(i))     cos(-delta(i))]*vR_W(:,i);    
    
    
    % From pivot's Wi velocity to wheel's velocity vector
    V_wh(:,i) = [   1, -d_w/(2*s_w);  ...
                    1,  d_w/(2*s_w)]* vW_W(:,i);
    
    % Compute ddelta
    ddeltaeq(i) = ( V_wh(2,i)-V_wh(1,i) ) / d_w - wR_R;
    
    % Compute wheel's angular velocity
    W_wh(:,i) =  V_wh(:,i)/r_w;           

                
                
    % Now lets compute 
end        
v = [vI_R;  wI_R];
JinvI = simplify(equationsToMatrix([vI_R;wI_R],v));
% JinvI = simplify(equationsToMatrix([vI_R;wI_R],{'vI_R1','vI_R2','wI_R1'}));
Jinvddelta = simplify(equationsToMatrix(ddeltaeq,v));
JinvW_wh = simplify(equationsToMatrix(W_wh,v));

G = [JinvI; Jinvddelta; JinvW_wh];


