function robot_visualization(x,y,z,z_wheels,time,robotconf,PlotPath,Follow,MakeVideo)
%% Explanation
% VisualiseRobot(x,y,z,z_wheels,time,Ts,MakeVideo)
% In order to visualise the robot, the enteries of the functiofunction robot_visualization(x,y,z,z_wheels,time,PlotPath,Follow,MakeVideo)n need to be
% defined as follows. The size of each variable, is either the same length
% as "time" or has length 1.
%
% x :        Defines the position of the robot in the x direction
% y :        Defines the position of the robot in the y direction
% z :        Defines the rotation around the z direction
% z_Wheels : Defines the rotation of each wheel.[4xi]
% Orientation of the wheels:
%      y^R
%       ^
% W4    |    W1
%       |
% <-----|----->x^R
%       |
% W3    |    W2
% time:      time
% 
% Optional options:
% PlotPath  : enable (1) plots the path driven by the robot
%             enable (2) plots the path of each individual wheel
%             enable (3) plots the path of the wheels axis of the twinwheel
% Follow    : enable (1) makes the axis follow the robot instead of a fixed axis
% MakeVideo : enable (1) to make a video of the generated motion otherwise

% Ugly fix!!!(by Cesar) to be according to the convention. Needs to be fix in the
% ploting fucntion itself

% Fixed the path plotting according to the conventions, Added an extra
% PlotPath functions which plots the path of the twinwheel axis instead of
% the path of the pivot.(by noud)

z_wheels = z_wheels.' - pi/2;

%% Error Messages
warning('off')
addpath('Functions')
if nargin == 6
    PlotPath = 0;
    Follow = 0;
    MakeVideo = 0;
elseif nargin == 7
    Follow = 0;
    MakeVideo = 0;
elseif nargin == 8
    MakeVideo = 0;
end

if length(x) == 1
    x = x*ones(1,length(time));
    disp('x is constant value')
elseif length(x) ~= length(time) && length(x)~= 1
    error('x not same dimension as time')
end
if length(y) == 1
    y = y*ones(1,length(time));
    disp('y is constant value')
elseif length(y) ~= length(time) && length(y)~= 1
    error('y not same dimension as time')
end
if length(z) == 1
    z = z*ones(1,length(time));
    disp('z is constant value')
elseif length(z) ~= length(time) && length(z)~= 1
    error('z not same dimension as time')
end
if size(z_wheels,1) == 4
    if size(z_wheels) == [4 1]
        z_wheels = z_wheels.*ones(4,length(time));
        disp('z_wheels is constant value')
    elseif size(z_wheels,2) ~= length(time) && size(z_wheels,2) ~= 1
        error('z_wheels not same dimension as time')
    end
else
    error('not every wheel angle defined in z_wheels')
end


%% Visualising the robot
% Depending on the variable "MakeVideo" a video file is created
if length(time) > 1
    Ts = time(2)-time(1);
else
    Ts = 1;
end

if MakeVideo == 1
    v1 = VideoWriter('Robot.avi','Motion JPEG AVI');
    if round(1/Ts) <= 50
        v1.FrameRate = round(1/Ts);
    else
        v1.FrameRate = 50;
        disp('Frame Rate not same as sampling time')
    end
    v1.Quality = 100;
    open(v1);
end
% Setting figure to full window size
figure('units','normalized','outerposition',[0 0 1 1])
set(gca,'nextplot','replacechildren');

% Drawing the robot using the function "Robot.m"
for i = 1:length(time)
    t = tic;
    if PlotPath == 1
        plot(x(1:i),y(1:i),'.')
        hold on
    elseif PlotPath == 2
        plot_PathWheels(x(1:i),y(1:i),z(1:i),robotconf)
        hold on
    elseif PlotPath == 3
        plot_PathWheels(x(1:i),y(1:i),z(1:i),z_wheels(1:4,1:i),robotconf)
        hold on
    end
    plot_Robot(x(i),y(i),z(i),z_wheels(:,i),robotconf)    
    if Follow >= 1
        axis([x(i)-1 x(i)+1 y(i)-1 y(i)+1])
        text(x(i)+0.85,y(i)+0.85,['Time = ',num2str(time(i)),'s'])
    else
        if max(x)-min(x) < max(y)-min(y)
            dif = (max(y)-min(y)) - (max(x) - min(x));
            axis([min(x)-1-.5*dif max(x)+1+.5*dif min(y)-1 max(y)+1])
            dif_x = max(x)+1+.5*dif - (min(x)-1-.5*dif);
            dif_y = max(y)+1-(min(y)-1) ;
            text(max(x)+1+.5*dif-0.1*dif_x,max(y)+1-0.1*dif_y,['Time = ',num2str(time(i)),'s'])
        elseif max(x)-min(x) > max(y)-min(y)
            dif = (max(x)-min(x)) - (max(y) - min(y));
            axis([min(x)-1 max(x)+1 min(y)-1-.5*dif max(y)+1+.5*dif])
            dif_x =  max(x)+1-(min(x)-1);
            dif_y =  max(y)+1+.5*dif- (min(y)-1-.5*dif);
            text( max(x)+1-dif_x*0.1, max(y)+1+.5*dif-0.1*dif_y,['Time = ',num2str(time(i)),'s'])
        elseif  max(x)-min(x) == max(y)-min(y)
            axis([min(x)-1 max(x)+1 min(y)-1 max(y)+1])
            dif_x =  max(x)+1-(min(x)-1);
            dif_y =  max(y)+1-(min(y)-1);
            text(max(x)+1-dif_x*0.1,max(y)+1-0.1*dif_y,['Time = ',num2str(time(i)),'s'])
        end
    end
    axis('square')
    xlabel('x axis')
    ylabel('y axis')
    grid on
    hold off
    drawnow
    if MakeVideo == 1
        frame = getframe;
        writeVideo(v1,frame);
    else
        while toc(t) < Ts
        end
    end
end
if PlotPath == 2
    legend('Wheel 1','Wheel 2','Wheel 3','Wheel 4')
end

if MakeVideo == 1
    close(v1);
end
%
%
