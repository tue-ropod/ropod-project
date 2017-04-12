% Symbolic calculation of ropod kinematic model
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
% theta = 0;

% Nwheels = 4;
% CW     = sym('CW',[2,Nwheels]); 
CW= [l_CW  l_CW -l_CW -l_CW;
     l_CW -l_CW -l_CW l_CW];
Nwheels = size(CW,2);


delta     = sym('delta',[1,Nwheels]);
ddelta     = sym('ddelta',[1,Nwheels]);
vR_W    = sym('VRW',[2,Nwheels]); % vectors (columns) of Wi velocities in Robot coordinates. 
vW_W    = sym('vW_W',[2,Nwheels]); % vectors (columns) of Wi velocities in Wheel pair coordinates.
W_wh    = sym('W_wh',[2,Nwheels]); % vectors (columns) of wheels velocities per Wheel pair. First row is left wheel.
V_wh    = r_w* W_wh;  % vectors (columns) of wheels velocities in m/s per Wheel pair. First row is left wheel.

vR_R = [0;0];
wR_R = 0;

for i=1:Nwheels    
    % From wheel's velocity to pivot point Wi velocity vector
    vW_W(:,i) = [   1/2     1/2 ;  ...
                    -s_w/d_w    s_w/d_w]* V_wh(:,i);
    ddelta(i) = [-1/d_w 1/d_w]* V_wh(:,i);            
                
    % Rotation to obtain pivot Wi velocity vector in robot coordinates
    vR_W(:,i) = [   cos(delta(i))     -sin(delta(i)); ...
                    sin(delta(i))     cos(delta(i))]*vW_W(:,i);
               
    vR_R = vR_R +  1/Nwheels * vR_W(:,i);      
    wR_R = wR_R + 1/1/Nwheels/sum(CW(:,i).^2) * [-CW(2,i) CW(1,i)] * vR_W(:,i);
end        

ddelta = ddelta - wR_R;

% To convert to Inertial frame, velocities in robot coordinates need to be
% rotated by theta
vI_R = [   cos(theta)     -sin(theta); ...
                    sin(theta)     cos(theta)]*vR_R;
wI_R = wR_R;
                

Jv = simplify(equationsToMatrix(vI_R,{'W_wh1_1','W_wh2_1','W_wh1_2','W_wh2_2','W_wh1_3','W_wh2_3','W_wh1_4','W_wh2_4'}));
Jw = simplify(equationsToMatrix(wI_R,{'W_wh1_1','W_wh2_1','W_wh1_2','W_wh2_2','W_wh1_3','W_wh2_3','W_wh1_4','W_wh2_4'}));
Jddelta = simplify(equationsToMatrix(ddelta,{'W_wh1_1','W_wh2_1','W_wh1_2','W_wh2_2','W_wh1_3','W_wh2_3','W_wh1_4','W_wh2_4'}));
JW_wh = simplify(equationsToMatrix(W_wh,{'W_wh1_1','W_wh2_1','W_wh1_2','W_wh2_2','W_wh1_3','W_wh2_3','W_wh1_4','W_wh2_4'}));
Jqw = [Jv; Jw];
% Kinematics, from wheel velocities to Robot velocities. It can be used
% for simulation. Jddelta can be used to compute ddelta and then compute
% delta via integration
J =[Jqw; Jddelta; JW_wh]

