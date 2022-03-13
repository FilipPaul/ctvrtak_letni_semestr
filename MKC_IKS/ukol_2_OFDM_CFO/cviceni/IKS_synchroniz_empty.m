clear variables
close all

%% figure settings
fontsize_axis = 20;
fontsize_ticks = 18;
fontsize_legend = 15;
fontsize_title = 20;
fontsize_linewidth = 3;
fontsize_marker = 15;

%%OFDM symbols
SIG_def=sqrt(13/6).*[0, 0, 1+j, 0, 0, 0, -1-j, 0, 0, 0, 1+j, 0,...
                     0, 0,-1-j, 0, 0, 0, -1-j, 0, 0, 0, 1+j, 0, 0, 0, 0, 0,...
                     0, 0,-1-j, 0, 0, 0, -1-j, 0, 0, 0, 1+j, 0,...
                     0, 0, 1+j, 0, 0, 0,  1+j, 0, 0, 0, 1+j, 0, 0];

%Input for IFFT
SIG_IFFT = [SIG_def(27), SIG_def(28:end),zeros(1,11),SIG_def(1:26)];
SIG_OUTPUT_IFFT=ifft(SIG_IFFT); % After IFFT

if 1
    CFO = 1e6 %kHz
    Ts = 1/20e6 %sample period
    t = 0:Ts:length(SIG_OUTPUT_IFFT)*Ts-Ts;
    SIG_OUTPUT_IFFT = SIG_OUTPUT_IFFT.*exp(1j*2*pi*CFO*t);
    save_string = "sync_CFO"
    title_string = sprintf("CFO = %d kHz : ", CFO/1e3)
else
    title_string = ""
    save_string = "sync"
end


%Rx signal [rnd_noise, SIG, SIG, rnd_noise]
rnd_noise = 0.05*randn(1,1000);
preamble = [SIG_OUTPUT_IFFT, SIG_OUTPUT_IFFT];
RX_SIG = [rnd_noise, preamble, rnd_noise];

%% CFO

%% Korelace s lokální replikou
replica = preamble(1:16);
corel = zeros(1,length(RX_SIG)- length(replica));
for i = 1:length(RX_SIG)- length(replica)
    corel(i) = dot(RX_SIG(i:i+15) ,replica);
end

%% Local replica Figure:
figure('Name','local_Replica','units','normalized','outerposition',[0 0 0.5 0.8]);
subplot(3,1,1)
stem(abs(corel))
title( title_string + "Local Replica synchronization","FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R(N)","FontSize",fontsize_axis)
grid on
grid minor

%% Schmidl and Cox
corel = zeros(1,length(RX_SIG)- 16);
for i = 1:length(RX_SIG)- 2*16
    corel(i) = dot(RX_SIG(i:i+15) ,RX_SIG(i+16: i+16 + 15));
end

%% SCHMIDL and COX Figure:
subplot(3,2,3)
stem(abs(corel))
title( title_string + "Schmidl and Cox synchronization","FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R(N)","FontSize",fontsize_axis)
grid on
grid minor

subplot(3,2,4)
stem(abs(corel))
title( title_string + "Schmidl and Cox Zoom","FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R(N)","FontSize",fontsize_axis)
xlim([950,1150])
grid on
grid minor

%% WANG
corel_A = zeros(1,length(RX_SIG)- 16);
corel_B = zeros(1,length(RX_SIG)- 16);
for i = 1:length(RX_SIG)- 3*16
    corel_A(i) = dot(RX_SIG(i:i+15) ,RX_SIG(i+16: i+16 + 15));
    corel_B(i) = dot(RX_SIG(i:i+15) ,RX_SIG(i+2*16: i+2*16 + 15));
end

subplot(3,2,5)
stem(abs(corel_A), 'r')
hold on
stem(abs(corel_B), 'b')
stem(abs(corel_A)-abs(corel_B), 'g')
title( title_string + "WANG synchronization","FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R(N)","FontSize",fontsize_axis)
legend(["Corel A", "Corel B", "A - B"])
grid on
grid minor

subplot(3,2,6)
stem(abs(corel_A), 'r')
hold on
stem(abs(corel_B), 'b')
stem(abs(corel_A) - abs(corel_B), 'g')
title( title_string + "WANG Zoom","FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R(N)","FontSize",fontsize_axis)
xlim([950,1150])
legend(["Corel A", "Corel B", "A - B"])
grid on
grid minor
saveas(gcf,save_string,"epsc")

