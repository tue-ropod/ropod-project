Ts = 1/200;

%% Robot parameters
d_w = 0.08;   % [m] Distance between two wheels in a pair of wheels
s_w = 0.08;   % [m] Caster offset
r_w= 0.11/2;  % [m] radius of the wheel
CW_L = 0.3/2; % [m] Position of the wheels. In this case all wheels are symmetrically distributed. This will be upgrated
robot_par = [d_w s_w r_w CW_L];

%% Trajectory
% Direct line. rotate and translate
% load straightline_traj
% timesim = (0:1:size(V_glb,1)-1).'*Ts;
% qrefdot = [timesim V_glb(:,1:2) W_glb_rz];

% circular path
omega=2*pi*(1/5); % a circle in 5 seconds
timesim=(0:Ts:5)';
xpos=1*cos(omega*timesim)-1;
dxpos=-omega*sin(omega*timesim);
ypos=1*sin(omega*timesim);
dypos=omega*cos(omega*timesim);
qrefdot = [timesim dxpos dypos omega*ones(length(dxpos),1)];


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


%% Visualization
q_est=cumsum(qdot_est.data)*Ts;

delta_abs_est.data = delta_est.data + q_est(:,3);
% The robot visualization needs to be updated tp accept the robot
% parameters as an input
robot_visualization(q_est(:,1),q_est(:,2),q_est(:,3),...
            delta_abs_est.data,qdot_est.Time,2,0,0)
        