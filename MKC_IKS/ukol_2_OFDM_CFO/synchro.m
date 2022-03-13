clear variables
close all
clc

fontsize_axis = 20;
fontsize_ticks = 18;
fontsize_legend = 15;
fontsize_title = 20;
fontsize_linewidth = 3;
fontsize_marker = 15;
%% OFDM symbols

OFDM_syms = [0, 0, 1+j, 0, 0, 0,...
-1-j, 0, 0, 0, 1+j, 0, 0, 0, -1-j,...
0, 0, 0,-1-j, 0, 0, 0, 1+j,...
0, 0, 0, 0, 0, 0, 0,-1-j,...
0, 0, 0, -1-j, 0, 0, 0, 1+j,...
0, 0, 0, 1+j, 0, 0, 0, 1+j, 0, 0, 0, 1+j, 0,0]

ZERO_syms = 

IFFT_input_block = [OFDM_syms(end-25:end)' ;OFDM_syms(1:26)']

%% CORDIC VECTOR ROTATION FIGURE
%figure('Name','tng','units','normalized','outerposition',[0 0 0.5 0.8]);
%plot(linspace(0,1),linspace(0,1))
%
%x = 1:2:40
%
%l = [1 , 2 ,5 ; 1 ,2 ,4]
%for i = 1:20
%    dsd a""das=d s" ds
%end