function plot_PathWheels(x,y,z,z_wheels)
%% Draw the wheels
l = 0.5;            % Length of the robot
w = 0.5;            % Width of the robot
sw = 0.08;          % distance to rotational point in y plane
i_max = length(x);
W1 = zeros(2,i_max);
W2 = zeros(2,i_max);
W3 = zeros(2,i_max);
W4 = zeros(2,i_max);
if nargin == 3
    for i = 1:i_max
        R_Matrix = [cos(z(i)) -sin(z(i));sin(z(i)) cos(z(i))];
        % Left Back
        W1(:,i) = [x(i);y(i)]+R_Matrix*[(.3*w);(.3*l)];
        % Left Front
        W2(:,i) = [x(i);y(i)]+R_Matrix*[(.3*w);(-.3*l)];
        % Right Back
        W3(:,i) = [x(i);y(i)]+R_Matrix*[(-.3*w);(-.3*l)];
        % Right Front
        W4(:,i) = [x(i);y(i)]+R_Matrix*[(-.3*w);(.3*l)];
    end
elseif nargin == 4
    for i = 1:i_max
        R_Matrix = [cos(z(i)) -sin(z(i));sin(z(i)) cos(z(i))];
        % Left Back
        R_Matrix1 = [cos(z_wheels(1,i)) -sin(z_wheels(1,i));sin(z_wheels(1,i)) cos(z_wheels(1,i))];
        W1(:,i) = [x(i);y(i)]+R_Matrix*[(.3*w);(.3*l)]+R_Matrix1*[0;-sw];
        % Left Front
        R_Matrix2 = [cos(z_wheels(2,i)) -sin(z_wheels(2,i));sin(z_wheels(2,i)) cos(z_wheels(2,i))];
        W2(:,i) = [x(i);y(i)]+R_Matrix*[(.3*w);(-.3*l)]+R_Matrix2*[0;-sw];
        % Right Back
        R_Matrix3 = [cos(z_wheels(3,i)) -sin(z_wheels(3,i));sin(z_wheels(3,i)) cos(z_wheels(3,i))];
        W3(:,i) = [x(i);y(i)]+R_Matrix*[(-.3*w);(-.3*l)]+R_Matrix3*[0;-sw];
        % Right Front
        R_Matrix4 = [cos(z_wheels(4,i)) -sin(z_wheels(4,i));sin(z_wheels(4,i)) cos(z_wheels(4,i))];
        W4(:,i) = [x(i);y(i)]+R_Matrix*[(-.3*w);(.3*l)]+R_Matrix4*[0;-sw];
    end
end

plot(W1(1,1:i_max),W1(2,1:i_max),'.','MarkerEdgeColor','r')
hold on
plot(W2(1,1:i_max),W2(2,1:i_max),'.','MarkerEdgeColor','b')
plot(W3(1,1:i_max),W3(2,1:i_max),'.','MarkerEdgeColor','g')
plot(W4(1,1:i_max),W4(2,1:i_max),'.','MarkerEdgeColor','y')
