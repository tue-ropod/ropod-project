function plot_Wheels(x,y,z)
%% Constants 
d = 0.005;            % Thickness of the axis between the wheels
r_wheel = 0.055;      % Radius of the wheel
b_wheel = 0.02;       % Thickness of the wheel
o_x = 0.08;           % distance between wheels centers
o_y = 0.08;           % distance to rotational point in y plane
%% Rotation Matrix
R_Matrix = [cos(z) -sin(z);sin(z) cos(z)];
%% Right Wheel
P1 = [x;y]+R_Matrix*[(.5*o_x-b_wheel/2);(-r_wheel-o_y)];
P2 = [x;y]+R_Matrix*[(.5*o_x+b_wheel/2);(-r_wheel-o_y)];
P3 = [x;y]+R_Matrix*[(.5*o_x+b_wheel/2);(r_wheel-o_y)];
P4 = [x;y]+R_Matrix*[(.5*o_x-b_wheel/2);(r_wheel-o_y)];

fill([P1(1) P2(1) P3(1) P4(1)],[P1(2) P2(2) P3(2) P4(2)],'k')

%% Left Wheel
P1 = [x;y]+R_Matrix*[(-.5*o_x+b_wheel/2);(-r_wheel-o_y)];
P2 = [x;y]+R_Matrix*[(-.5*o_x-b_wheel/2);(-r_wheel-o_y)];
P3 = [x;y]+R_Matrix*[(-.5*o_x-b_wheel/2);(r_wheel-o_y)];
P4 = [x;y]+R_Matrix*[(-.5*o_x+b_wheel/2);(r_wheel-o_y)];

fill([P1(1) P2(1) P3(1) P4(1)],[P1(2) P2(2) P3(2) P4(2)],'k')

%% Axis between wheels

P1 = [x;y]+R_Matrix*[-.5*d;.5*d];
P2 = [x;y]+R_Matrix*[.5*d;.5*d];
P3 = [x;y]+R_Matrix*[.5*d;.5*d-o_y];
P4 = [x;y]+R_Matrix*[0.5*o_x;.5*d-o_y];
P5 = [x;y]+R_Matrix*[0.5*o_x;-.5*d-o_y];
P6 = [x;y]+R_Matrix*[-0.5*o_x;-.5*d-o_y];
P7 = [x;y]+R_Matrix*[-0.5*o_x;.5*d-o_y];
P8 = [x;y]+R_Matrix*[-.5*d;.5*d-o_y];

fill([P1(1) P2(1) P3(1) P4(1) P5(1) P6(1) P7(1) P8(1)],[P1(2) P2(2) P3(2) P4(2) P5(2) P6(2) P7(2) P8(2)],'k')

%plot(x,y,'.','linewidth',1.5,'MarkerEdgeColor','w')
