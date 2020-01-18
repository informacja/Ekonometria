folder   = 'temperatura/';
filename = 'signalAll.csv';
filename = 'sig.csv';
   
% clear all;
[Temp] = readvars( append(folder,filename) );
L = length(Temp);
subplot 111; plot(Temp); title(filename); 
title('Ujêcie wody lata 2013-2019 '); axis('tight')
lata = 2019-2013; Ldni = floor(L/lata);
xlabel(sprintf("%s %d %s",' Dni ( za³. okresowe, rok trwa):', Ldni, 'dni'));  ylabel(['Temperatura wody [ ' char(176) 'C ]']);  

input('');

Y = fft(Temp-mean(Temp));
plot(abs(Y/L));

input('');

% symulacja


 
%  dt = 1/fpr;
%  T = 
%  N = length(Temp);
%  f0 = fpr/N;
%  f = f0*(0:N-1);
%  figure
% S = Temp
% L = len;
Fs = 1/L;
fpr = 1/365;        % dni w roku
f = Fs*(0:(L/2))/L;

Y = fft(Temp-mean(Temp));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot(f,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')



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


