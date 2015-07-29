function[xf,zf]=cricket(x0,y0,z0,v0,angle,h_angle,bounce,spin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRIEF EXPLANATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x0, y0 and z0 are the initial ball release positions
% v0 is the ball release velocity
% angle and h_angle are the vertical and horizontal ball release angles respectively
% bounce and spin are two co-efficients that determine the bounce and spin
% offered by the pitch
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STANDARD VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x0       =   0
% y0       =   0.5
% z0       =   1.8
% v0       =   60
% angle    =  -5
% h_angle  =  -0.5
% bounce   =   3
% spin     =   3.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program has been written as a project for the course EEE 401,
% Bangladesh University of Engineering and Technology by Team Quasar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
close all;

figure('color',[1 1 1]);
set(gcf,'units','normalized','outerposition',[0 0 1 1])
xlim([-75 20.12]);
ylim([-75 75]);
zlim([0 06]);
rotate3d;

a = angle;
t = 0:.01:1;
g = 9.81;
rad = a.*pi/180;

%compute trajectory positions vs time
xf = x0+v0*cos(rad).*t;
yf = 20.12*tan(h_angle);    % 20.12m is the standard cricket pitch length
yf = linspace(y0,max(yf),length(t));
zf = z0+v0*sin(rad).*t-.5*g.*t.^2;

spin = spin*1e-2;

view(260,25); 

hold on;
%%
j=1;
spinvar = 0;
k=0;
% plot each point
for n=1:length(t)
    
    if n==1   %plotting the background for the first time
        
        xImage0 = [20.13 20.130; 20.13 20.13];   % BLUE SKY
        yImage0 = [-75 -75; 75 75];
        zImage0 = [0 6; 0 6];
        surf(xImage0,yImage0,zImage0,...
            'FaceColor',[0.47,0.9,0.947]);
        
        xImage0 = [20.125 20.125; 20.125 20.125];   % BACKSIDE FIELD
        yImage0 = [-75 -75; 75 75];
        zImage0 = [0 .5; 0 .5];
        surf(xImage0,yImage0,zImage0,...
            'FaceColor',[.60,.94,.43]);
        
        xImage3 = [20.12 20.120; 20.12 20.12]; %STUMP1
        yImage3 = [-.1145 -0.0687; -0.1145 -0.0687];
        zImage3 = [.711 .711; 0 0];
        surf(xImage3,yImage3,zImage3,...
            'FaceColor','black');
        
        xImage4 = [20.12 20.120; 20.12 20.12];   %STUMP2
        yImage4 = [-.0229 0.0229; -0.0229 0.0229];
        zImage4 = [.711 .711; 0 0];
        surf(xImage4,yImage4,zImage4,...
            'FaceColor','black');
        xImage5 = [20.12 20.120; 20.12 20.12];     %STUMP3
        yImage5 = [0.0687 0.1145; 0.0687 0.1145 ];
        zImage5 = [.711 .711; 0 0];
        surf(xImage5,yImage5,zImage5,...
            'FaceColor','black');
        
        
        xImage2 = [-75 20.12; -75 20.12];   % FIELD
        yImage2 = [-75 -75; 75 75];
        zImage2 = [-0.001 -0.001; -0.001 -0.001];
        surf(xImage2,yImage2,zImage2,...
            'FaceColor',[.60,.94,.43]);
        
        
        xImage2 = [-0 20.12; -0 20.12];   %# PITCH
        yImage2 = [-1.5 -1.5; 1.5 1.5];
        zImage2 = [0 0; -0 -0];
        surf(xImage2,yImage2,zImage2,...
            'FaceColor',[0.94,0.78,0.47]);        
    end
    
    if ((zf(n)>0&&j==1) && (xf(n)<=20.12))  %plot first part of trajectory 
                                            %using equation of projectile
                                            %motion
        xlim([-75 20.12]);
        ylim([-75 75]);
        zlim([0 06]);
        
        
        plot3(xf(n),yf(n),zf(n),'o-r');
        
        temp=n;  
        hTitle =  title('Cricket simulator');
        xlabel('distance(m)');
        ylabel('width(m)');
        zlabel('height(m)');
        grid on;
        hold on;
        pause(.005);
        
        
    else                                % plot second part of trajectory
                                        % using straight line equation 
        j=0;
        k=k+1;
        if (xf(n)<=20.12)
            yf(n)=yf(n)+spinvar*spin;
            spinvar = spinvar+1;
            zf1=bounce.*t;              %equation of straight line
            
            xlim([-75 20.12]);
            ylim([-75 75]);
            zlim([0 06]);
            
            plot3(xf(n),yf(n),zf1(k),'o-r');
            
            temp=n;
            
            xlabel('distance(m)');
            ylabel('width(m)');
            zlabel('height(m)');
            grid on;
            hold on;
            
            pause(.005);
            hold on;
              
        end
        
        
    end
    
end

% chekcing if the ball hits the stumps
% if the ball misses the stumps, the batsman hits
if (abs(yf(temp))<=.1145)&&(zf(temp)<0.71)
    lgn =  legend('Wickets: Hitting');
    set(lgn,'TextColor','red');
    
elseif abs(yf(temp))>1
    lgn=   legend('Wide Ball');
    set(lgn,'TextColor','Blue');
    
    
else
    lgn=   legend('Wickets: Missing');
    set(lgn,'TextColor','green');
    
end
hit_var = 101;

% if the ball is pitched outside of the off-stump, the batsman can play
% off-side strokes or straight down the ground
if((yf(temp)>=.1145)&&(yf(temp)<=1)&&(zf(temp)<0.51))
    
    % straight drive
    hold on;
    yg=yf(temp)*ones(1,hit_var);zg=abs(zf(temp)*ones(1,hit_var));
    xf = linspace(-75,20.12,hit_var);
    for v=hit_var:-1:1
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);
        
    end
    %cover drive
    
    hold on;
    yg = yf(temp)*ones(1,hit_var);
    
    for i=2:hit_var
        yg(i) = yg(i)+01*i;
    end
    
    zg = abs(zf(temp)*ones(1,hit_var));
    xf = linspace(20.12,-75,hit_var);
    for v = 1:hit_var
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);
        
    end
    % offside six
    
    hold on;
    yg = yf(temp)*ones(1,hit_var);
    
    for i=2:hit_var
        yg(i) = yg(i)+1.4*i;
    end
    
    zg = abs(zf(temp)*ones(1,hit_var));
    
    
    zg(1) = abs(zf(temp));
    for i=2:hit_var
        zg(i) = zg(1)+ 43*sin(9*pi/180)*t(i)-.5*g*t(i)^2;
    end

    xf = linspace(20.12,-75,hit_var);
    for v=1:hit_var
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);
        
    end

    % down the ground
    
    hold on;
    yg = yf(temp)*ones(1,hit_var);
    zg = abs(zf(temp)*ones(1,hit_var));
    zg(1) = abs(zf(temp));
    
    
    for i=2:hit_var
        zg(i)= zg(1)+ 43*sin(9*pi/180)*t(i)-.5*g*t(i)^2;
    end
    
    xf = linspace(20.12,-75,hit_var);
    for v=1:hit_var
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);
        
    end
 % if the ball is pitched in the leg side, shots can be played in the on side   
    
elseif((yf(temp)<=-.1145)&&(yf(temp)>=-1)&&(zf(temp)<0.51))
    
    
    % on drive
    
    hold on;
    yg = yf(temp)*ones(1,hit_var);
    
    for i=2:hit_var
        yg(i) = yg(i)-1*i;
    end
    
    zg = abs(zf(temp)*ones(1,hit_var));
    xf = linspace(20.12,-75,hit_var);
    for v=1:hit_var
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);
        
    end

    % leg flick
    hold on;
    yg = yf(temp)*ones(1,hit_var);
    
    for i=2:hit_var
        yg(i) = yg(i)-3*i;
    end
    
    zg = abs(zf(temp)*ones(1,hit_var));
    xf = linspace(20.12,-75,hit_var);
    for v=1:hit_var
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);   
    end

    % slog sweep
    
    hold on;
    yg = yf(temp)*ones(1,hit_var);
    
    for i=2:hit_var
        yg(i)=yg(i)-1.4*i;
    end
    
    zg = abs(zf(temp)*ones(1,hit_var));
    zg(1) = abs(zf(temp));
    for i=2:hit_var
        zg(i)= zg(1)+ 43*sin(9*pi/180)*t(i)-.5*g*t(i)^2;
    end

    xf = linspace(20.12,-75,hit_var);
    for v=1:hit_var
        
        plot3(xf(v),yg(v),zg(v),'o-b');
        hold on;
        pause(0.005);
        
    end
end
%aesthetics
set(gca , ...
    'Box', 'off', ...
    'TickDir', 'out',...
    'TickLength', [.02 0.02],...
    'XMinorTick','on',...
    'YMinorTick','on',...
    'XColor', [.2 .2 .2],...
    'YColor', [.2 .2 .2],...
    'LineWidth', 1    );
set([hTitle], ...
    'FontSize', 12 , ...
    'FontWeight', 'bold');

end
