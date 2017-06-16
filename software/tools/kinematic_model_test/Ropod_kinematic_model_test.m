clearvars
Ts = 1/200;

%% Robot parameters
d_w = 0.08;   % [m] Distance between two wheels in a pair of wheels
s_w = 0.01;   % [m] Caster offset
r_w= 0.11/2;  % [m] radius of the wheel
CW_L = 0.3/2; % [m] Position of the wheels. In this case all wheels are symmetrically distributed. This will be upgrated
robot_par = [d_w s_w r_w CW_L];

%% Trajectory
% Direct line. rotate and translate
load straightline_traj
timesim = (0:1:size(V_glb,1)-1).'*Ts;
qrefdot = [timesim V_glb(:,1:2) W_glb_rz];

% circular path
% omega=2*pi*(1/5); % a circle in 5 seconds
% timesim=(0:Ts:5)';
% xpos=1*cos(omega*timesim)-1;
% dxpos=1*-omega*sin(omega*timesim);
% ypos=1*sin(omega*timesim);
% dypos=1*omega*cos(omega*timesim);
% qrefdot = [timesim dxpos dypos 1*omega*ones(length(dxpos),1)];

% linear velocities
% timesim=(0:Ts:5)';
% dxpos=1*ones(length(timesim),1);
% dypos=0*ones(length(timesim),1);
% omega=1*ones(length(timesim),1);
% qrefdot = [timesim dxpos dypos omega];

% qrefdot = [timesim dxpos dypos omega*ones(length(dxpos),1)];
% Data from simulator
% load techunited_sim_traj
% timesim = rt_xyphi.time(1:end);
% qrefdot = [timesim rt_xyphi_dot.signals.values((1:end),:)];

%% Low pass filter, gain <1 can be interpreted as slip
BWact = 10;
LPFu=tf(1,[1/(2*pi*BWact)^2 2*0.5*1/(2*pi*BWact) 1]);
LPF_matrix= [   LPFu,   0,  0,  0,  0,  0,  0,  0;
    0,   LPFu,  0,  0,  0,  0,  0,  0;
    0,   0,  LPFu,  0,  0,  0,  0,  0;
    0,   0,  0,  LPFu,  0,  0,  0,  0;
    0,   0,  0,  0,  LPFu,  0,  0,  0;
    0,   0,  0,  0,  0,  LPFu,  0,  0;
    0,   0,  0,  0,  0,  0,  LPFu,  0;
    0,   0,  0,  0,  0,  0,  0,  LPFu];
LPF_z = c2d(LPF_matrix,Ts,'zoh');


%% Simulation

sim('ropod_KinModTest');

q_est=q_est.data;

%% Visualization


delta_abs_est.data = delta_est.data + q_est(:,3);

robotconf.l     = 0.4;      % Length of the robot
robotconf.w     = 0.4;      % Width of the robot
robotconf.Lw    = CW_L;    % wheel position in y axes
robotconf.Ww    = CW_L;    % wheel position in x axes        
robotconf.d = 0.005;           % Thickness of the axis between the wheels
robotconf.rw = r_w;          % Radius of the wheel
robotconf.b_wheel = 0.02;      % Thickness of the wheel
robotconf.dw = d_w;           % distance between wheels centers
robotconf.sw = s_w;           % distance to rotational point in y plane
% 
robot_visualization(downsample(q_est(:,1),10),downsample(q_est(:,2),10),downsample(q_est(:,3),10),...
    downsample(delta_abs_est.data,10),downsample(qdot_est.Time,10),robotconf,3,0,0);


%% slip check

for idata = 1: length(q_est(:,1))
    xc= q_est(idata,1);
    yc= q_est(idata,2);
    theta= q_est(idata,3);
    dxc= qdot_est.data(idata,1);
    dyc= qdot_est.data(idata,2);
    dtheta = qdot_est.data(idata,3);
    delta1 = delta_est.data(idata,1);
    ddelta1 = ddelta_est.data(idata,1);
    delta2 = delta_est.data(idata,2);
    ddelta2 = ddelta_est.data(idata,2);
    delta3 = delta_est.data(idata,3);
    ddelta3 = ddelta_est.data(idata,3);
    delta4 = delta_est.data(idata,4);
    ddelta4 = ddelta_est.data(idata,4);
    
%     Gsymeval = subs(G,[D S r L theta delta1 delta2 delta3 delta4],[d_w s_w r_w CW_L qdot_est.data(idata,3)...
%         delta_est.data(idata,1) delta_est.data(idata,2)...
%         delta_est.data(idata,3) delta_est.data(idata,4)]);
%    qdotest2(:,idata) = Gsymeval*q_est(idata,:)';
    
    Wslip(:,idata)= [...    
 ddelta1*s_w + dtheta*s_w - dyc*cos(delta1 + theta) + dxc*sin(delta1 + theta) - CW_L*dtheta*cos(delta1) - CW_L*dtheta*sin(delta1);...
 ddelta2*s_w + dtheta*s_w - dyc*cos(delta2 + theta) + dxc*sin(delta2 + theta) - CW_L*dtheta*cos(delta2) + CW_L*dtheta*sin(delta2);...
 ddelta3*s_w + dtheta*s_w - dyc*cos(delta3 + theta) + dxc*sin(delta3 + theta) + CW_L*dtheta*cos(delta3) + CW_L*dtheta*sin(delta3);...
 ddelta4*s_w + dtheta*s_w - dyc*cos(delta4 + theta) + dxc*sin(delta4 + theta) + CW_L*dtheta*cos(delta4) - CW_L*dtheta*sin(delta4)...
 ];
 
    
end

figure(2)
plot(Wslip')