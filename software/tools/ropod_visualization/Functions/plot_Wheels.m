function plot_Wheels(x,y,z,robotconf)
%% Constants 
d = robotconf.d;                % Thickness of the axis between the wheels
rw = robotconf.rw;              % Radius of the wheel
b_wheel = robotconf.b_wheel;    % Thickness of the wheel
dw = robotconf.dw;              % distance between wheels centers
sw = robotconf.sw;              % distance to rotational point in y plane
%% Rotation Matrix
R_Matrix = [cos(z) -sin(z);sin(z) cos(z)];
%% Right Wheel
P1 = [x;y]+R_Matrix*[(.5*dw-b_wheel/2);(-rw-sw)];
P2 = [x;y]+R_Matrix*[(.5*dw+b_wheel/2);(-rw-sw)];
P3 = [x;y]+R_Matrix*[(.5*dw+b_wheel/2);(rw-sw)];
P4 = [x;y]+R_Matrix*[(.5*dw-b_wheel/2);(rw-sw)];

fill([P1(1) P2(1) P3(1) P4(1)],[P1(2) P2(2) P3(2) P4(2)],'k')

%% Left Wheel
P1 = [x;y]+R_Matrix*[(-.5*dw+b_wheel/2);(-rw-sw)];
P2 = [x;y]+R_Matrix*[(-.5*dw-b_wheel/2);(-rw-sw)];
P3 = [x;y]+R_Matrix*[(-.5*dw-b_wheel/2);(rw-sw)];
P4 = [x;y]+R_Matrix*[(-.5*dw+b_wheel/2);(rw-sw)];

fill([P1(1) P2(1) P3(1) P4(1)],[P1(2) P2(2) P3(2) P4(2)],'k')

%% Axis between wheels

P1 = [x;y]+R_Matrix*[-.5*d;.5*d];
P2 = [x;y]+R_Matrix*[.5*d;.5*d];
P3 = [x;y]+R_Matrix*[.5*d;.5*d-sw];
P4 = [x;y]+R_Matrix*[0.5*dw;.5*d-sw];
P5 = [x;y]+R_Matrix*[0.5*dw;-.5*d-sw];
P6 = [x;y]+R_Matrix*[-0.5*dw;-.5*d-sw];
P7 = [x;y]+R_Matrix*[-0.5*dw;.5*d-sw];
P8 = [x;y]+R_Matrix*[-.5*d;.5*d-sw];

fill([P1(1) P2(1) P3(1) P4(1) P5(1) P6(1) P7(1) P8(1)],[P1(2) P2(2) P3(2) P4(2) P5(2) P6(2) P7(2) P8(2)],'k')

%plot(x,y,'.','linewidth',1.5,'MarkerEdgeColor','w')
