clear all
% close all
clc

x = 0:1/50:5; 
y = 0:1/50:5;
z = 0:2*pi/250:2*pi;
time = (0:0.02:5).';
z_wheels =  cos(time);
z_wheels = [z_wheels z_wheels z_wheels z_wheels];


robotconf.l     = 0.4;      % Length of the robot
robotconf.w     = 0.4;      % Width of the robot
robotconf.Lw    = 0.3/2;    % wheel position in y axes
robotconf.Ww    = 0.3/2;    % wheel position in x axes        
robotconf.d = 0.005;           % Thickness of the axis between the wheels
robotconf.rw = 0.055;          % Radius of the wheel
robotconf.b_wheel = 0.02;      % Thickness of the wheel
robotconf.dw = 0.08;           % distance between wheels centers
robotconf.sw = 0.1;           % distance to rotational point in y plane

robot_visualization(x,y,z,z_wheels,time,robotconf,3,1,0)