function plot_Robot(x,y,z,z_wheels)
%% Constant Values
l = 0.4;            % Length of the robot
w = 0.4;            % Width of the robot
Lw = 0.3/2;
Ww = 0.3/2;
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

plot_Wheels(W1(1),W1(2),z_wheels(1))
plot_Wheels(W2(1),W2(2),z_wheels(2))
plot_Wheels(W3(1),W3(2),z_wheels(3))
plot_Wheels(W4(1),W4(2),z_wheels(4))


