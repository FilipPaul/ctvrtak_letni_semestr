function[U_video]=ChannelModel
%% ChannelModel.m je fce generujici koeficienty prenosoveho kanalu v konfiguraci 2x2 MIMO
% dle zadane korelace mezi jednotlivymi cestami a s casovym rozsirenim
% kanalu nastavitelnym v nasobcich symbolove periody. Model pracuje s
% Rayleigho rozlozenim tapu kanalu v casove oblasti a obsahuje i volitelnou
% funkci exponenciálního poklesu vykonu tapu kanalu, ktere se siri po
% delsich cestach. Model generuje koficienty jak v casove, tak frekvencni
% oblasti (impulzni odezva, nebo prenosova funkce). Skript umoznuje
% generovat mnozstvi grafickych vystupu vcetne videi pro sledovani vyvoje
% prenosove fce. v case.
%
%% VYSTUPNI PROMENNE:
%        X_video, U_video, V_video, W_video - prenosove funkce 2x2 kanalu (v log. mire, slouzi pro tvorbu videji)
%        X, U, V, W - prenosove funkce 2x2 kanalu
%        x_video, u_video, v_video, w_video - imp. odezvy 2x2 kanalu (v log. mire, slouzi pro tvorbu videji)
%        x, u, v, w - imp. odezvy 2x2 kanalu
%
%% POZN.: 
%        X - hodnota ve fr. domene, 
%        x - hodnota v casove domene

stand_alone = 'true'; % - pro automatizovane spousteni v ramci simulatoru = 'false'
% - pro jednorazove spousteni napriklad sledovani
% vysledku simulace kanalu = 'true' (pro sledovani vysledku simulace je treba nastavit vhodne parametry promennych nize)
switch stand_alone
    case 'true'
%         clc;clear all;close all;
        pocet_vzorku_na_symbol = 12;
        pocet_snapshotu = 10; % doba trvani simulace kanalu - pro vykresleni obrazku je nutne zde mit hodnotu 10 a vice
    case 'false'
        pocet_vzorku_na_symbol = Phy.Set.Tx.R1 * Phy.Set.Tx.R2 * Phy.Set.Tx.R3 * Phy.Set.Tx.R4 * Phy.Set.Tx.R5 * Phy.Set.Tx.R6;
        pocet_snapshotu = Phy.Set.L1frame.Nl1f; % doba trvani simulace kanalu
end
FR = 10; % frame rate videa
vykresleni = 'false';
generovat_video = 'false'; % pokud videa budu velmi zrychlena, nebo zpomalena, je potreba doladit hodnotu FR (toto je z duvodu ruzne vykonnosti pocitacu)
vypis_korelacni_matice = 'false'; % zadaná korelace je pouze cil, ke kteremu se generatory nahodnych cisel maji blizit - zpetnym vypoctem korelacni matice lze overit miru dosazeni tohoto korelacniho cile

pocet_tapu_kanalu_na_vzorek = 1; % tzn. prevzorkovani signalu pred kanalem a podvzorkovani signalu po kanalu (POZOR: jina hodnota nez 1 momentalne nema smysl - nedodelane prumerovani tapu)

nT = 4;     % casove rozsireni v nasobcich symbolove periody T. POZN.: nT=1 znamena rozsireni O JEDEN SYMBOL, tzn. vysledny kanal ma delku 2 symboly
korelace_zadana = 0.6; % korelace mezi jednotlivymi cestami MIMO kanalu

A = 60;               % utlum kanalu;
zpomaleni = 20;       % cim vetsi zpomaleni, tim pomalejsi kanal - ovlivnuje i parametr index_poctu_der
index_poctu_der = 5;  % cim vetsi index, tim mene der

ch_imp_L = 2*pocet_tapu_kanalu_na_vzorek*nT*pocet_vzorku_na_symbol; % delka imp odezvy kanalu
tau = 1:ch_imp_L; % vektor zpozdeni

P = 10; % "vykon kanalu"
PDP=10.^(-tau.*P./(ch_imp_L))./10; % exponencialni pokles vzdalenejsich tapu
% PDP=ones(1,ch_imp_L);   % bez pokelsu

switch vykresleni
    case 'true'
        figure();plot(tau,PDP);xlabel('\tau [sample]');ylabel('P [-]');title('Slabnuti tapu kanalu s opozdovanim \newline jejich prijmu (prodluzovani cesty odrazu)')
end


str_hod_1=0;
% str_hod_2=0;
rozptyl_1=1;
% rozptyl_2=1;

for i=1:pocet_snapshotu
    
    k = randn(ch_imp_L,1)+j*randn(ch_imp_L,1); % normalni rozdeleni 1
%     l = randn(ch_imp_L,1)+j*randn(ch_imp_L,1); % normalni rozdeleni 2
%     m = randn(ch_imp_L,1)+j*randn(ch_imp_L,1); % normalni rozdeleni 3
%     n = randn(ch_imp_L,1)+j*randn(ch_imp_L,1); % normalni rozdeleni 4
    
    
    % generovani korelovanych promennych
    u(i,:) = (PDP'.*(rozptyl_1*k+str_hod_1));
%     v(i,:) = (PDP'.*(rozptyl_2* (korelace_zadana *k + sqrt(1-korelace_zadana^2) * l) + str_hod_2));
%     w(i,:) = (PDP'.*(rozptyl_2* (korelace_zadana *k + sqrt(1-korelace_zadana^2) * m) + str_hod_2));
%     x(i,:) = (PDP'.*(rozptyl_2* (korelace_zadana *k + sqrt(1-korelace_zadana^2) * n) + str_hod_2));
    
    switch vypis_korelacni_matice
        case 'true'
            korelace;
    end
    
%     dim=ceil(max(max(abs([u(i,:),v(i,:)]))));
    
    % prevod do frekv domeny
    U(i,:)=[fft(u(i,:))];
%     V(i,:)=[fft(v(i,:))];
%     W(i,:)=[fft(w(i,:))];
%     X(i,:)=[fft(x(i,:))];
    
end

%% prevzorkovani za ucelem ziskani plynulych zmen v case
if pocet_snapshotu > 9 % >9 je tady proto, ze fce. interp neumi interpolovat z mene, nez 9 hodnot
    for ii=1:ch_imp_L
        U_interp(:,ii) = interp(U(:,ii),zpomaleni);
%         V_interp(:,ii) = interp(V(:,ii),zpomaleni);
%         W_interp(:,ii) = interp(W(:,ii),zpomaleni);
%         X_interp(:,ii) = interp(X(:,ii),zpomaleni);
        
    end
else
    U_interp = U;
%     V_interp = V;
%     W_interp = W;
%     X_interp = X;
end


%% redukce der (pomoci promenne index_poctu_der)
if pocet_snapshotu > 9 % >9 je tady proto, ze fce. interp neumi interpolovat z mene, nez 9 hodnot
    for ii=1:pocet_snapshotu*zpomaleni;
        U_interp_interp(ii,:) = interp(U_interp(ii,:),index_poctu_der);
        U_video(ii,:) =  [20*log10(abs(U_interp_interp(ii,1:ch_imp_L)))];
        U_video(ii,:) = 1./max(abs(U_video(ii,:))) .* U_video(ii,:);
        
%         V_interp_interp(ii,:) = interp(V_interp(ii,:),index_poctu_der);
%         V_video(ii,:) =  [20*log10(abs(V_interp_interp(ii,1:ch_imp_L)))];
%         
%         W_interp_interp(ii,:) = interp(W_interp(ii,:),index_poctu_der);
%         W_video(ii,:) =  [20*log10(abs(W_interp_interp(ii,1:ch_imp_L)))];
%         
%         X_interp_interp(ii,:) = interp(X_interp(ii,:),index_poctu_der);
%         X_video(ii,:) =  [20*log10(abs(X_interp_interp(ii,1:ch_imp_L)))];
        
%         u(ii,:) = ifft(U_interp_interp(ii,1:ch_imp_L));
%         v(ii,:) = ifft(V_interp_interp(ii,1:ch_imp_L));
%         w(ii,:) = ifft(W_interp_interp(ii,1:ch_imp_L));
%         x(ii,:) = ifft(X_interp_interp(ii,1:ch_imp_L));
        
%         u_mat(ii,:)=u(ii,1:ch_imp_L/2);
%         v_mat(ii,:)=v(ii,1:ch_imp_L/2);
%         w_mat(ii,:)=w(ii,1:ch_imp_L/2);
%         x_mat(ii,:)=x(ii,1:ch_imp_L/2);
        
%         u_video(ii,:) = 20*log10(abs(u_mat(ii,:) ));
%         v_video(ii,:) = 20*log10(abs(v_mat(ii,:) ));
%         w_video(ii,:) = 20*log10(abs(w_mat(ii,:) ));
%         x_video(ii,:) = 20*log10(abs(x_mat(ii,:) ));
        
    end
else

end

% switch generovat_video
%     case 'true'
%         %% tvorba videa
%         writer = VideoWriter(['Korelace = ',num2str(korelace_zadana),'; zpomaleni = ',num2str(zpomaleni),'; cas. rozsireni = ',num2str(nT),'; pocet tapu = ',num2str(ch_imp_L)],'MPEG-4');
%         writer.FrameRate = FR;
%         open(writer);
%         
%         max_Y=max(max(X_video));
%         min_Y=min(min(X_video));
%         
%         for ii=1:pocet_snapshotu*zpomaleni;
%             hline1 = plot(U_video(ii,:));hold on;
%             hline2 = plot(V_video(ii,:),'k');hold on;
%             hline3 = plot(W_video(ii,:),'m');hold on;
%             hline4 = plot(X_video(ii,:),'r');hold off;
%         end
%         
%         for idx=1:pocet_snapshotu*zpomaleni;
%             set(hline1,'YData',U_video(idx,:));ylim([floor(min(min(U_video))) ceil(max(max(U_video)))]);
%             set(hline2,'YData',V_video(idx,:));
%             set(hline3,'YData',W_video(idx,:));
%             set(hline4,'YData',X_video(idx,:));
%             ylim([floor(min([min(min(U_video)),min(min(V_video)),min(min(W_video)),min(min(X_video))]))...
%                 ceil(max([max(max(U_video)),max(max(V_video)),max(max(W_video)),max(max(X_video))]))]);
%             
%             
%             figure(gcf),title(['Korelace = ',num2str(korelace_zadana),'; zpomaleni = ',num2str(zpomaleni),'; \newline cas. rozsireni = ',num2str(nT),'; pocet tapu = ',num2str(ch_imp_L/2)])
%             writeVideo(writer,getframe(gcf));
%         end
%         
%         close(writer);
%         
%         
% end

switch vykresleni
    case 'true'
%         figure;surf(X_video);title('U');xlabel('f');ylabel('t');zlabel('P')
%         figure;surf(U_video);title('V');xlabel('f');ylabel('t');zlabel('P')
%         figure;surf(V_video);title('W');xlabel('f');ylabel('t');zlabel('P')
%         figure;surf(W_video);title('X');xlabel('f');ylabel('t');zlabel('P')
        
%         figure;surf(x_video);title('u');xlabel('\tau');ylabel('t');zlabel('P')
%         figure;surf(u_video);title('v');xlabel('\tau');ylabel('t');zlabel('P')
%         figure;surf(v_video);title('w');xlabel('\tau');ylabel('t');zlabel('P')
%         figure;surf(w_video);title('x');xlabel('\tau');ylabel('t');zlabel('P')
        
        %         figure;
        %                     subplot(3,2,1);
        %                     plot(u(1,:),'.');hold on;
        %             %         title(['korelace vypoctena = ',num2str(korelace_vypoctena),' korelace zadana = ',num2str(korelace_zadana)])
        %                     plot(v(1,:),'r.');hold on;
        %                     %        plot(sklon,'b','LineWidth',2)
        %                     xlim([-dim,dim]);ylim([-dim,dim]);
%         subplot(3,2,1)
%         createFit_U(abs(reshape(U,prod(size(U)),1)));
        
        %             dist_x=fitdist(abs(reshape(U,prod(size(U)),1)),'rayleigh');
%         subplot(3,2,3);
%         hist(abs(reshape(U,prod(size(U)),1)),50);title('abs(U)');hold on;
        %
        %             figure
        %             createFit_U(abs(reshape(U,prod(size(U)),1)));
        %
%         subplot(3,2,4);
%         hist(angle(reshape(U,prod(size(U)),1)),50);title('angle(U)')
        
        %             dist_x=fitdist(abs(conj(x(i,:)')),'rayleigh');
%         subplot(3,2,5);
%         hist(abs(reshape(V,prod(size(V)),1)),50);title('abs(V)')
        
%         subplot(3,2,6);
%         hist(angle(reshape(V,prod(size(V)),1)),50);title('angle(V)')
        
end
% odstraneni "servisnich" promennych
clearvars -except X_video U_video V_video W_video x_video u_video v_video w_video X U V W x u v w
end