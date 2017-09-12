%% Trajectory
Ts=1/200;

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
% qrefdot = [timesim [0; dxpos(2:end)] [0; dypos(2:end)] [0; 1*omega*ones(length(dxpos)-1,1)] ];

% linear velocities
% timesim=(0:Ts:5)';
% dxpos=1*ones(length(timesim),1);
% dypos=0*ones(length(timesim),1);
% omega=1*ones(length(timesim),1);
% qrefdot = [timesim dxpos dypos omega];



%%
set_ropod_configparams_sim;
% sim('ROPOD_dynamic_model_sim_Inertial_Input');
sim('ROPOD_dynamic_model_sim_Wheel_Input');


%% Visualization
Time = delta_est_sim.time;
delta_est =  squeeze(delta_est_sim.data)';
ddelta_est =  squeeze(ddelta_est_sim.data)';
q_est =  squeeze(q_est_sim.data)';
qdot_est = squeeze(qdot_est_sim.data)';

delta_abs_est = delta_est + q_est(:,3);

robotconf.l     = 0.4;      % Length of the robot
robotconf.w     = 0.4;      % Width of the robot
robotconf.Lw    = ropod_physical_parameters.wheel_symmetric_distribution.value;    % wheel position in y axes
robotconf.Ww    = ropod_physical_parameters.wheel_symmetric_distribution.value;    % wheel position in x axes        
robotconf.d = 0.005;           % Thickness of the axis between the wheels
robotconf.rw = wheel_physical_parameters.diameter.value;            % Radius of the wheel
robotconf.b_wheel = 0.02;      % Thickness of the wheel
robotconf.dw = wheel_physical_parameters.separation.value;          % distance between wheels centers
robotconf.sw = wheel_physical_parameters.caster_offset.value;       % distance to rotational point in y plane

dsfactor = 10;
q_est_d = downsample(q_est,dsfactor);
delta_abs_est_d = downsample(delta_abs_est,dsfactor);
Time_d = downsample(Time,dsfactor);
robot_visualization(q_est_d(:,1),q_est_d(:,2),q_est_d(:,3),...
    delta_abs_est_d,Time_d,robotconf,3,0,0);

%% slip check
s_w = ropod_dynmodel_param.s_w;
l_CW = ropod_dynmodel_param.l_CW;
for idata = 1: length(q_est(:,1))
    xc= q_est(idata,1);
    yc= q_est(idata,2);
    theta= q_est(idata,3);
    dxc= qdot_est(idata,1);
    dyc= qdot_est(idata,2);
    dtheta = qdot_est(idata,3);
    delta1 = delta_est(idata,1);
    ddelta1 = ddelta_est(idata,1);
    delta2 = delta_est(idata,2);
    ddelta2 = ddelta_est(idata,2);
    delta3 = delta_est(idata,3);
    ddelta3 = ddelta_est(idata,3);
    delta4 = delta_est(idata,4);
    ddelta4 = ddelta_est(idata,4);
    
%     Gsymeval = subs(G,[D S r L theta delta1 delta2 delta3 delta4],[d_w s_w r_w l_CW qdot_est.data(idata,3)...
%         delta_est.data(idata,1) delta_est.data(idata,2)...
%         delta_est.data(idata,3) delta_est.data(idata,4)]);
%    qdotest2(:,idata) = Gsymeval*q_est(idata,:)';
    
    Wslip(:,idata)= [...    
 ddelta1*s_w + dtheta*s_w - dyc*cos(delta1 + theta) + dxc*sin(delta1 + theta) - l_CW*dtheta*cos(delta1) - l_CW*dtheta*sin(delta1);...
 ddelta2*s_w + dtheta*s_w - dyc*cos(delta2 + theta) + dxc*sin(delta2 + theta) - l_CW*dtheta*cos(delta2) + l_CW*dtheta*sin(delta2);...
 ddelta3*s_w + dtheta*s_w - dyc*cos(delta3 + theta) + dxc*sin(delta3 + theta) + l_CW*dtheta*cos(delta3) + l_CW*dtheta*sin(delta3);...
 ddelta4*s_w + dtheta*s_w - dyc*cos(delta4 + theta) + dxc*sin(delta4 + theta) + l_CW*dtheta*cos(delta4) - l_CW*dtheta*sin(delta4)...
 ];
 
    
end

% figure(2)
% plot(Wslip')
% title('Slip check')
