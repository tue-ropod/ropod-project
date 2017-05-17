function plot_Robot(x,y,z,z_wheels,robotconf)
%% Constant Values
l = robotconf.l;            % Length of the robot
w = robotconf.w;            % Width of the robot
Lw = robotconf.Lw;          % wheel position in y axes
Ww = robotconf.Ww;          % wheel position in x axes
%% Rotation matrix
R_Matrix = [cos(z) -sin(z);sin(z) cos(z)];
%% Draw Frame
P1 = [x;y]+R_Matrix*[(-.5*w);(-.5*l)];
P2 = [x;y]+R_Matrix*[(.5*w);(-.5*l)];
P3 = [x;y]+R_Matrix*[(.5*w);(.5*l)];
P4 = [x;y]+R_Matrix*[(-.5*w);(.5*l)];

fill([P1(1) P2(1) P3(1) P4(1)],[P1(2) P2(2) P3(2) P4(2)],[0.5 0.5 0.5])

hold on
%% Draw the wheels
% See convention
%      y^R
%       ^
% W4    |    W1
%       |
% <-----|----->x^R
%       |
% W3    |    W2
%       
W1 = [x;y]+R_Matrix*[(Ww);(Lw)];
W2 = [x;y]+R_Matrix*[(Ww);(-Lw)];
W3 = [x;y]+R_Matrix*[(-Ww);(-Lw)];
W4 = [x;y]+R_Matrix*[(-Ww);(Lw)];

plot_Wheels(W1(1),W1(2),z_wheels(1),robotconf)
plot_Wheels(W2(1),W2(2),z_wheels(2),robotconf)
plot_Wheels(W3(1),W3(2),z_wheels(3),robotconf)
plot_Wheels(W4(1),W4(2),z_wheels(4),robotconf)


