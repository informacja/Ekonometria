
clear all;
folder   = 'temperatura/';
filename = 'signalAll.csv';
filename = 'sig.csv';
   
%%
[Temp] = readvars( append(folder, filename) );
L = length(Temp);
figure(1)
subplot 411; plot(Temp); title(filename); 
title('Stacja Uzdatniana Wody (£uk.) lata 2013-2019 '); axis('tight')
Llat = 2019-2013; Ldni = floor(L/Llat);
xlabel(sprintf("%s %d %s",' Dni ( za³. okresowe, rok trwa):', Ldni, 'dni'));  ylabel(['Temperatura wody [ ' char(176) 'C ]']);  

% input('temperatury, dane surowe');

%% sr. sumowana 
% while(1)
for ( n = 1:Llat)
    zLat = n;                                           % z ilu lat
    rok(Ldni) = 0;
    for (i = 0:zLat-1)    
        for (k = 1:Ldni)
            rok(k) = rok(k) + Temp(i*Ldni+k);
        end
    end

    for (k = 1:Ldni)
        rok(k) = rok(k)/zLat;
    end
       
    figure(2);
    plot(rok); 
    title('Srednia sumowana'); axis('tight')
    xlabel(sprintf("%s %d %s",' Dni ( za³. okresowe, rok trwa):', Ldni, 'dni'));  ylabel(['Temperatura wody [ ' char(176) 'C ]']);  
%     pause(0.7);
end
%  pause(1);
% end
%% sr +-1
[m,n] = size(Temp');
y1 = Temp';
y2 = zeros(m,n);
for i = 2:(n-1)
    y2(i) = (y1(i-1) + y1(i) + y1(i+1))/3;
end

figure(1)
subplot 412; plot(y2); title(filename); 
title('Œrednia ruchoma z 3 dni'); axis('tight')
Llat = 2019-2013; Ldni = floor(L/Llat);
xlabel(sprintf("%s %d %s",' Dni ( za³. okresowe, rok trwa):', Ldni, 'dni'));  ylabel(['Temperatura wody [ ' char(176) 'C ]']);  

% input('srednia ruchoma');
%% sr +-2
[m,n] = size(Temp');
y1 = Temp';
y2 = zeros(m,n);
v = 2;
for i = v+1:(n-v)    
    sum = y1(i);
    for (w = 1:v)
       sum = sum + (y1(i-w) + y1(i+w));
    end
    y2(i) = sum/(v+3);
end

figure(1)
subplot 413; plot(y2); title(filename); 
title(sprintf('Œrednia ruchoma z %d dni',v+v+1)); axis('tight')
Llat = 2019-2013; Ldni = floor(L/Llat);
xlabel(sprintf("%s %d %s",' Dni ( za³. okresowe, rok trwa):', Ldni, 'dni'));  ylabel(['Temperatura wody [ ' char(176) 'C ]']);  

% input('srednia ruchoma');

%% furier

subplot 414; 
Y = fft(Temp-mean(Temp));
plot(abs(Y/L)); title('Widmo furierowskie'); 

% input('furier');

% symulacja


 
%  dt = 1/fpr;
%  T = 
%  N = length(Temp);
%  f0 = fpr/N;
%  f = f0*(0:N-1);
%  figure
% S = Temp
% L = len;

% Fs = 1/L;
% fpr = 1/365;        % dni w roku
% f = Fs*(0:(L/2))/L;
% 
% Y = fft(Temp-mean(Temp));
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of S(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')



%     xlabel('Dni roku'); ylabel(['Temperatura [' char(176) 'C]']);
% t13
% 
% M = 201;
% hLP = fir1(M,(64/(fpr/2))); % 50Hz
% hHP = fir1(M,(84/(fpr/2)), 'high'); % 50Hz
% 
% yLP = conv(x,hLP);
% yHP = conv(x,hHP);
% 
% WZH = sum( yHP.^2 ) / sum( yLP.^2);


