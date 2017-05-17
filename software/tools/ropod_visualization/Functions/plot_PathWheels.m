function plot_PathWheels(x,y,z,z_wheels,robotconf)
%% Draw the wheels
l = robotconf.l;            % Length of the robot
w = robotconf.w;            % Width of the robot
sw = robotconf.sw;          % distance to rotational point in y plane
Lw = robotconf.Lw;          % wheel position in y axes
Ww = robotconf.Ww;          % wheel position in x axes

i_max = length(x);
W1 = zeros(2,i_max);
W2 = zeros(2,i_max);
W3 = zeros(2,i_max);
W4 = zeros(2,i_max);
% See convention
%      y^R
%       ^
% W4    |    W1
%       |
% <-----|----->x^R
%       |
% W3    |    W2
%       

if nargin == 4
    for i = 1:i_max
        R_Matrix = [cos(z(i)) -sin(z(i));sin(z(i)) cos(z(i))];
        W1(:,i) = [x(i);y(i)]+R_Matrix*[(Ww);(Lw)];
        W2(:,i) = [x(i);y(i)]+R_Matrix*[(Ww);(-Lw)];
        W3(:,i) = [x(i);y(i)]+R_Matrix*[(-Ww);(-Lw)];
        W4(:,i) = [x(i);y(i)]+R_Matrix*[(-Ww);(Lw)];
    end
elseif nargin == 5
    for i = 1:i_max
        R_Matrix = [cos(z(i)) -sin(z(i));sin(z(i)) cos(z(i))];
        % Left Back
        R_Matrix1 = [cos(z_wheels(1,i)) -sin(z_wheels(1,i));sin(z_wheels(1,i)) cos(z_wheels(1,i))];
        W1(:,i) = [x(i);y(i)]+R_Matrix*[(Ww);(Lw)]+R_Matrix1*[0;-sw];
        % Left Front
        R_Matrix2 = [cos(z_wheels(2,i)) -sin(z_wheels(2,i));sin(z_wheels(2,i)) cos(z_wheels(2,i))];
        W2(:,i) = [x(i);y(i)]+R_Matrix*[(Ww);(-Lw)]+R_Matrix2*[0;-sw];
        % Right Back
        R_Matrix3 = [cos(z_wheels(3,i)) -sin(z_wheels(3,i));sin(z_wheels(3,i)) cos(z_wheels(3,i))];
        W3(:,i) = [x(i);y(i)]+R_Matrix*[(-Ww);(-Lw)]+R_Matrix3*[0;-sw];
        % Right Front
        R_Matrix4 = [cos(z_wheels(4,i)) -sin(z_wheels(4,i));sin(z_wheels(4,i)) cos(z_wheels(4,i))];
        W4(:,i) = [x(i);y(i)]+R_Matrix*[(-Ww);(Lw)]+R_Matrix4*[0;-sw];
    end
end

plot(W1(1,1:i_max),W1(2,1:i_max),'.','MarkerEdgeColor','r')
hold on
plot(W2(1,1:i_max),W2(2,1:i_max),'.','MarkerEdgeColor','b')
plot(W3(1,1:i_max),W3(2,1:i_max),'.','MarkerEdgeColor','g')
plot(W4(1,1:i_max),W4(2,1:i_max),'.','MarkerEdgeColor','y')
