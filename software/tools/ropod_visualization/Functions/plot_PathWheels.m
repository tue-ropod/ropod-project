function plot_PathWheels(x,y,z)
%% Draw the wheels
l = 0.5;            % Length of the robot
w = 0.5;            % Width of the robot
i_max = length(x);
W1 = zeros(2,i_max);
W2 = zeros(2,i_max);
W3 = zeros(2,i_max);
W4 = zeros(2,i_max);
for i = 1:i_max
    R_Matrix = [cos(z(i)) sin(z(i));-sin(z(i)) cos(z(i))];
    % Left Back
    W1(:,i) = [x(i);y(i)]+R_Matrix*[(-.3*w);(-.3*l)];
    % Left Front
    W2(:,i) = [x(i);y(i)]+R_Matrix*[(-.3*w);(.3*l)];
    % Right Back
    W3(:,i) = [x(i);y(i)]+R_Matrix*[(.3*w);(-.3*l)];
    % Right Front
    W4(:,i) = [x(i);y(i)]+R_Matrix*[(.3*w);(.3*l)];
end
plot(W1(1,1:i_max),W1(2,1:i_max),'.','MarkerEdgeColor','r')
hold on
plot(W2(1,1:i_max),W2(2,1:i_max),'.','MarkerEdgeColor','b')
plot(W3(1,1:i_max),W3(2,1:i_max),'.','MarkerEdgeColor','g')
plot(W4(1,1:i_max),W4(2,1:i_max),'.','MarkerEdgeColor','y')
