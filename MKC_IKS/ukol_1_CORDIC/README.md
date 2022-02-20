<h1>MATLAB script CORDIC implementation</h1>

OUTPUT:\
CORDIC vector rotation\
Iterace: 0 -> add_angle: (1)*0.0000° ; out_angle: 45.0000°;ERROR: -40.0000° ; vector:[0.5000,0.5000]\
Iterace: 1 -> add_angle: (1)*26.5651° ; out_angle: 71.5651°;ERROR: -13.4349° ; vector:[0.2236,0.6708]\
Iterace: 2 -> add_angle: (-1)*14.0362° ; out_angle: 85.6013°;ERROR: 0.6013° ; vector:[0.0542,0.7050]\
Iterace: 3 -> add_angle: (1)*7.1250° ; out_angle: 78.4763°;ERROR: -6.5237° ; vector:[0.1413,0.6929]\
Iterace: 4 -> add_angle: (1)*3.5763° ; out_angle: 82.0526°;ERROR: -2.9474° ; vector:[0.0978,0.7003]\
Iterace: 5 -> add_angle: (1)*1.7899° ; out_angle: 83.8425°;ERROR: -1.1575° ; vector:[0.0758,0.7030]\
Iterace: 6 -> add_angle: (1)*0.8952° ; out_angle: 84.7377°;ERROR: -0.2623° ; vector:[0.0649,0.7041]\
CORDIC vector translation\
Iterace: 0 -> add_angle: (-1)*0.0000° ; out_angle: 26.5651°;ERROR: 26.5651° ; vector:[0.5000,0.2500]\
Iterace: 1 -> add_angle: (-1)*26.5651° ; out_angle: 0.0000°;ERROR: 0.0000° ; vector:[0.5590,0.0000]


CORDIC_fun.m

```matlab
function [last_iteration,vectors,angles] = CORDIC_fun(input_vector,angle,MAX_ERROR,MAX_iterations,print_flag)
    n_iterations = MAX_iterations;
    angle_rad = angle*pi/180;
    MAX_ERROR_RAD = MAX_ERROR*pi/180;
    %alocate memmory
    output_vectors = zeros(n_iterations,2);
    output_angles = zeros(1,n_iterations);
    scale_factor_K = zeros(1,n_iterations);
    table_of_iters = zeros(1,n_iterations);
    ERROR = zeros(1,n_iterations);
    format_str = "Iterace: %d -> add_angle: (%d)*%0.4f° ; out_angle: %0.4f°;"+...
    "ERROR: %0.4f° ; vector:[%0.4f,%0.4f]";
    for i = 1:1:n_iterations
        if i == 1
            table_of_iters(i) = 0;
            scale_factor_K(i) = 1;
            l_init = sqrt(input_vector(1)^2 + input_vector(2)^2);
            output_angles(i) = acos(input_vector(1)/l_init);
            output_vectors(i,:) = input_vector;
            if angle_rad == 0 %For translation mode
                ERROR(i) = output_angles(i);
                if abs(ERROR(i)) > 45*pi/180 %ALL quadrants
                    output_angles(i) = output_angles(i) + sign(ERROR(i))*45*pi/180;
                    ERROR(i) = output_angles(i);
                    output_vectors(i,:) = [cos(output_angles(i)),sin(output_angles(i))];
                end
            else %Rotation MOde
                ERROR(i) = -angle_rad;
                while abs(ERROR(i)) > 45*pi/180 %ALL quadrants
                    disp(sign(ERROR(i)) + "45°")
                    output_angles(i) = output_angles(i) - sign(ERROR(i))*45*pi/180;
                    (angle_rad - sign(ERROR(i))*45*pi/180)*180/pi
                    angle_rad = (angle_rad + sign(ERROR(i))*45*pi/180);
                    ERROR(i) = - angle_rad ;
                    output_vectors(i,:) = [cos(output_angles(i)),sin(output_angles(i))];
                    l = sqrt(output_vectors(i,1)^2 + output_vectors(i,2)^2);
                    output_vectors(i,:) = output_vectors(i,:)/l *l_init;
                    
                end
            end
            txt = sprintf(format_str,i-1, sign(ERROR(i)*(-1)),...
            table_of_iters(i),output_angles(i)*180/pi,...
            ERROR(i)*180/pi,output_vectors(i,1), output_vectors(i,2));
            if print_flag == 1
                disp(txt)
            end

        else
            table_of_iters(i) = atan(2^(-i+1));
            if (ERROR(i-1) < 0)
               output_angles(i) = output_angles(i-1) + table_of_iters(i);
            elseif (ERROR(i-1) > 0)
               output_angles(i) = output_angles(i-1) - table_of_iters(i);
            end
            output_vectors(i,:) = [cos(output_angles(i)),sin(output_angles(i))];
            l = sqrt(output_vectors(i,1)^2 + output_vectors(i,2)^2);
            scale_factor_K(i) = l_init/l;
            output_vectors(i,:) = output_vectors(i,:)/l *l_init;
            
            if angle_rad == 0 %For translation mode
                ERROR(i) = output_angles(i);
            else %rotation mode
               ERROR(i) = output_angles(i) - (angle_rad+output_angles(1));
            end

            txt = sprintf(format_str,i-1,sign(ERROR(i))*(-1),...
            table_of_iters(i)*180/pi,output_angles(i)*180/pi,...
            ERROR(i)*180/pi, output_vectors(i,1), output_vectors(i,2));
            if print_flag == 1
                disp(txt)
            end

            if (abs(ERROR(i)) < MAX_ERROR_RAD) || (i == n_iterations) 
                last_iteration = i-1;
                last_Error = ERROR(i);
                angles = output_angles;
                vectors = output_vectors;
                
                break
            end
        end

    end
end
```
\
CORDIC.m (main)

```matlab
clear variables
close all
clc

fontsize_axis = 20;
fontsize_ticks = 18;
fontsize_legend = 15;
fontsize_title = 20;
fontsize_linewidth = 3;
fontsize_marker = 15;

input_vector = [0.5,0.5]; %[x,y]
angle = 40; %rotation angle degrees
MAX_ERROR = 0.5; %max error in degreees
MAX_iterations = 20;


%% CORDIC VECTOR ROTATION FIGURE
disp("CORDIC vector rotation")
[iter,vector,angles] = CORDIC_fun(input_vector,angle,MAX_ERROR,MAX_iterations,1);

figure('Name','tng','units','normalized','outerposition',[0 0 0.5 0.8]);
%plot(QX, QY, '-r', 'LineWidth',1.2) 
hold on
texts = string(zeros(1,iter+1));
for i = 1:1:iter+1
    QX = vector(i,1);
    QY = vector(i,2);       
    quiv = quiver(0, 0, QX,QY,0);
    set(quiv,'MaxHeadSize',0.08);
    txt = sprintf("iter:%d; vect: [%0.3f,%0.3f] ; angle: %0.4f°",...
        i-1, QX,QY,angles(i)*180/pi);
    texts(i) = txt;
    c = get(quiv,'Color');
    text(QX*0.85,QY*0.85,txt,'HorizontalAlignment','center','VerticalAlignment',...
        'bottom','rotation',angles(i)*180/pi, "FontSize", 12, 'Color',c)
end
legend(texts,'Location','Southeast','FontSize',fontsize_legend+8,'AutoUpdate','off')
plot([-0.1,0.6],[0,0], "-k")
plot([0,0],[-0.1,1.1], "-k")


grid on
grid minor
axis equal
xlim([0,0.52])
ylim([0,0.75])
ax = gca;
ax.FontSize = fontsize_ticks;
title("CORDIC Vector rotation: \Theta = 40°, init vector = [0.5,0.5], Max Error = 0.5°","FontSize",fontsize_title)
xlabel("X","FontSize",fontsize_axis)
ylabel("Y","FontSize",fontsize_axis)

%saveas(gcf,"CORDIC_vect_rot","epsc")

%% CORDIC VECTOR TRANSLATION FIGURE
disp("CORDIC vector translation")
[iter,vector,angles] = CORDIC_fun([0.5,0.25],0,MAX_ERROR,MAX_iterations,1);

figure('Name','tng','units','normalized','outerposition',[0 0 0.5 0.8]);
%plot(QX, QY, '-r', 'LineWidth',1.2) 
hold on
texts = string(zeros(1,iter+1));
for i = 1:1:iter+1
    QX = vector(i,1);
    QY = vector(i,2);       
    quiv = quiver(0, 0, QX,QY,0);
    set(quiv,'MaxHeadSize',0.08);
    txt = sprintf("iter:%d; vect: [%0.3f,%0.3f] ; angle: %0.4f°",...
        i-1, QX,QY,angles(i)*180/pi);
    texts(i) = txt;
    c = get(quiv,'Color');
    text(QX*0.85,QY*0.85,txt,'HorizontalAlignment','center','VerticalAlignment',...
        'bottom','rotation',angles(i)*180/pi, "FontSize", 12, 'Color',c)
end
legend(texts,'Location','Northwest','FontSize',fontsize_legend+8,'AutoUpdate','off')
plot([-0.1,0.6],[0,0], "-k")
plot([0,0],[-0.1,0.3], "-k")


grid on
grid minor
axis equal
ax = gca;
ax.FontSize = fontsize_ticks;
title("CORDIC Vector translation: init vector = [0.5,0.5], Max Error = 0.5°","FontSize",fontsize_title)
xlabel("X","FontSize",fontsize_axis)
ylabel("Y","FontSize",fontsize_axis)

%saveas(gcf,"CORDIC_vect_trans","epsc")

%% CORDIC VECTOR TRANSLATION MORE THAN 45°
disp("CORDIC vector translation")
[iter,vector,angles] = CORDIC_fun([0.5,0.7],150,MAX_ERROR,MAX_iterations,1);

figure('Name','tng','units','normalized','outerposition',[0 0 0.5 0.8]);
%plot(QX, QY, '-r', 'LineWidth',1.2) 
hold on
texts = string(zeros(1,iter+1));
for i = 1:1:iter+1
    QX = vector(i,1);
    QY = vector(i,2);       
    quiv = quiver(0, 0, QX,QY,0);
    set(quiv,'MaxHeadSize',0.08);
    txt = sprintf("iter:%d; vect: [%0.3f,%0.3f] ; angle: %0.4f°",...
        i-1, QX,QY,angles(i)*180/pi);
    texts(i) = txt;
    c = get(quiv,'Color');
    text(QX*0.85,QY*0.85,txt,'HorizontalAlignment','center','VerticalAlignment',...
        'bottom','rotation',angles(i)*180/pi, "FontSize", 12, 'Color',c)
end
legend(texts,'Location','Northwest','FontSize',fontsize_legend+8,'AutoUpdate','off')
plot([-1,0.1],[0,0], "-k")
plot([0,0],[0.1,-0.6], "-k")

grid on
grid minor
axis equal
ax = gca;
ax.FontSize = fontsize_ticks;
title("CORDIC Vector rotation: \Theta = 150°, init vector = [0.5,0.7], Max Error = 0.5°","FontSize",fontsize_title)
xlabel("X","FontSize",fontsize_axis)
ylabel("Y","FontSize",fontsize_axis)

saveas(gcf,"CORDIC_vect_trans_150","epsc")
```
