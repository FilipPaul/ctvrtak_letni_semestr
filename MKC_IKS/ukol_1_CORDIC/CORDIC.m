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
title("CORDIC Vector rotation: init vector = [0.5,0.5], Max Error = 0.5°","FontSize",fontsize_title)
xlabel("X","FontSize",fontsize_axis)
ylabel("Y","FontSize",fontsize_axis)

saveas(gcf,"CORDIC_vect_rot","epsc")

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
title("CORDIC Vector transaltion: \Theta = 40°, init vector = [0.5,0.25], Max Error = 0.5°","FontSize",fontsize_title)
xlabel("X","FontSize",fontsize_axis)
ylabel("Y","FontSize",fontsize_axis)

saveas(gcf,"CORDIC_vect_trans","epsc")