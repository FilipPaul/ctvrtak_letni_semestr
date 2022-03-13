<h1> IKS_synchroniz_empty.m </h1>

```Matlab
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

```



<h1> MIKS__CFOest_student.m </h1>

```Matlab
clear variables;
close all;

%% figure settings
fontsize_axis = 20;
fontsize_ticks = 18;
fontsize_legend = 15;
fontsize_title = 20;
fontsize_linewidth = 3;
fontsize_marker = 15;


L = [1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0,...
1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];

SIG_ref = [ L(28:end),L(1:26)];


%% Generovani kanalove fce
H = ChannelModel;
H_vyrez = H(1,1:52);
H = H_vyrez;

SIG = SIG_ref.* H(1,:);

%Channel estimation
H_LS_perfect = SIG./SIG_ref;

%OFDM modulation
sig = ifft([L(27), SIG(1:26),zeros(1,11),SIG(27:end)]);

s_dlouhy = [sig(end-32+1:end),sig,sig];  % dlouha preamble s CP [GI2 | T1 | T2]

%% simulace CFO:
Ts = 50e-9;
T = length(sig)*Ts;
dF = 1/T;
cfo_rel = 0.1
cfo = cfo_rel*dF;
t = 0:Ts:length(s_dlouhy)*Ts-Ts;
srec = s_dlouhy.*exp(j*2*pi*cfo*t);

%SREC AWGN
AWGN = 200
srec = awgn(srec,AWGN,'measured');

% FFT
R1 = fft( srec(33: 33+length(sig)-1) )
R2 = fft( srec(end+1-length(sig) :end) )

%odhad CFO
CFO_est = angle(R1.*conj(R2))/(2*pi)
CFO_comp = mean(CFO_est)*dF

%kompenzace
srec_comp = s_dlouhy.*exp(j*2*pi*cfo*t).*exp(j*2*pi*CFO_comp*t)

%Eqalizace kanalu
R1_comp = fft( srec_comp(33: 33+length(sig)-1) );
R2_comp = fft( srec_comp(end+1-length(sig) :end) );

title_string = sprintf (" SNR = %d , CFO = %0.1f x %d Hz",AWGN,cfo_rel,dF)
%% jak vypada preamble bez korekce CFO:
figure('Name','CFO','units','normalized','outerposition',[0 0 0.5 0.8]);
subplot(3,2,1)
stem(R1)
title( "R1 bez kompenzace:" + title_string,"FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R1(N)","FontSize",fontsize_axis)
grid on
grid minor

subplot(3,2,2)
stem(R1_comp)
title( "R1 po kompenzaci :" + title_string,"FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R1(N)","FontSize",fontsize_axis)
grid on
grid minor

subplot(3,2,3)
stem(R2)
title( "R2 bez kompenzace:" + title_string,"FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R2(N)","FontSize",fontsize_axis)
grid on
grid minor

subplot(3,2,4)
stem(R2_comp)
title( "R2 po kompenzaci:" + title_string,"FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("R2(N)","FontSize",fontsize_axis)
grid on
grid minor

%% odhad CFO:
subplot(3,1,3)
stem(CFO_est)
title( "Odhad CFO:" +CFO_comp/dF +" x" +dF+ "Hz ->" + title_string,"FontSize",fontsize_title)
xlabel("N samples","FontSize",fontsize_axis)
ylabel("CFO(N)","FontSize",fontsize_axis)
grid on
grid minor

%saveas(gcf,"H_eq_200", "epsc")
```