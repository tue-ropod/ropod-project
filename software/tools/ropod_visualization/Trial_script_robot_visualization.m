clear all
% close all
clc

x = 0:1/50:5; 
y = 0:1/50:5;
z = 0:2*pi/250:2*pi;
time = (0:0.02:5).';
z_wheels =  cos(time);
z_wheels = [z_wheels z_wheels z_wheels z_wheels];


robot_visualization(x,y,z,z_wheels,time,0,1)