%Cwicz2Regr
% Regresja linowa - analiza czêstotliwoœciowa - metody numeryczne.
clear all; 
% toDo:
%   montecarlo
%   MSE

[Yemp, data, time, x, lTim, lrT] = dane(); 
% [size(Yemp);size(data);size(time);size(x);size(lTim);size(lrT)] % debug
% ------------------------------------------------------------------------
% UWAGA do widma furerowiskiego musi byæ spe³nione za³o¿enie o równomiernym
% próbkowaniu, poni¿sza linia jest tylko gdy harmoniczne ju¿ znamy 
% Yemp = data; x = time; % podmian na dane z dziurami do modelu regresjnego
% ------------------------------------------------------------------------
Ldanych = length(x); % size(x, 2);
T = max(x) - min(x) + 1; sred_temp = mean(Yemp);
Yemp = dtrend(Yemp, 1); %sredAfterDentrend = mean(Yemp);
sigYf = std(Yemp);

figure(1), subplot(2, 1, 1), plot(time, data); axis('tight'); 
title('Dane w dziedzinie czasu'); xlabel('[dni]'); ylabel( 'Temperatura [*C]');
legend(sprintf("Œrednia temperatura %.2f *C ", sred_temp))

Ah = abs(fft(Yemp / Ldanych));  Ah = Ah(1:round(Ldanych / 2 )); %nie dzia³a round w matlab 2010
f0 = find(max(Ah) == Ah); % cykl roczny
acept_level = f0 * mean(Ah)*1,618 ;  A(1:length(Ah)) = acept_level; % goldenRatio
harm = [Ah(f0:f0:end)]; % To DO uwzglêdniaj harmoniczne roczne w modelu
nrOm = find(Ah > acept_level) - 1; 
subplot(2, 1, 2),
 semilogx([1:length(Ah)],Ah(1:end)); hold on;
    plot([1:length(Ah)],Ah(1:end),'b.-',nrOm+1,Ah(nrOm+1),'ro',1:length(Ah),A,'r--'); 
    xline(f0, 'b--'); for(i=f0:f0:f0*10) plot(i,Ah(i), 'g.'); end; hold off;
 axis('tight');
ylabel('Si³a wzmocnienia'); xlabel(sprintf('Czêstotliwoœci\n autoPropozycja: %i silnch harmonicznch jako okres podstawowy (cz. bazowa f0=%g-1)\n nr harm. = %s ',length(nrOm), f0, mat2str(nrOm))); title('Analiza w dziedzinie czêstotliwoœci'); 
legend('Moda', 'czêstotliwoœci', 'Proponowane f0', 'Próg cz. bazowych');

%% Eliminacja zmiennych quasi-sta³ych
vi(length(data)) = 0;
for (i = 1:length(data))
    vi(i) = mean(data(1:i)) / std(data(1:i)) ;
end
quasiZmiennosc7lat = sum(vi(end-364:end))/365 - vi(end)
quasiZmiennosc3lat = sum(vi(2:1095))/1095 - vi(end)
figPW; figure(11), plot([1:length(data)],vi(1:end),[1 length(data)],[mean(data)/std(data) mean(data)/std(data)],'r--')
title('Zmiennoœæ danych opisuj¹cych'); ylabel(['(œredna / odchylenie stanadrdowe) [' char(176) 'C]']);
xlabel('pytanie kiedy przerwaæ? Ile lat wystarczy by iloœæ danych uznaæ za wystarczaj¹c¹? [dni]')
%% G³êbokie myœlenie = prezentacja danych + wyobra¿enia
kol1 = 'r*'; if(Ldanych > 80) kol1 = 'r.'; end
figPW; figure(2), subplot(2, 1, 1);
plot(x, Yemp, kol1);  ylabel('[*C]'); title('G³êbokie myœlenie = prezentacja danych + wyobra¿enia'); hold on

% z = input(' ? jaka to funkcja ? !!!  <Ent> - co mogloby byc ?');

% za³. funkcji harmonicznej
nrOm = [7 14 21 28 56]; %nrOm; %[1 2 5 20 36 42 134 236 500 600];
figure(1);
    for i = 1:length(nrOm)
        xline(nrOm(i)+1,'g--'); 
    end

figure(2);
om = 2 * pi / T * nrOm;
% %% Projekt modelu - oblicz FId
[FId, Ldanych, Lh, Kd] = modelRharm(x, om); % za³. funkcji harmonicznej

Yemp=Yemp'; % teraz maj¹c model, dodaæ dane z dziurami

% =============== wybieramy model: Lhm i Km ===================
Lhm = 5; % Lhm = Kd/2;
Km = 2 * Lhm; % Przyjety (arbitralnie) rzad modelu  Kolumny Macierzy
% =============================================================

FI(:, 1:Km) = FId(:, 1:Km);
% dalej ju¿ tylko numeryka i grafika dla wyobra¿enia warstwy fizycznej
Gd = FI' * FI;
G = inv(Gd);

Ao = G * FI' * Yemp; % Wsp.A=inv(FItransp*FI)*FItransp*Yempiryczne
% sprawdz modelu
Yo = FI * Ao;
Em = Yemp - Yo;

if (1) E = Em; LdE = Ldanych;
else E(x') = Em; LdE = length(E); % uzupe³niamy braki zerami;
end
    
varE = (E' * E) / (LdE - Km);
sigEo = sqrt(varE);

% ============= model AR reszt ======================
alf = E(2:end)' * E(1:end - 1) / ((LdE - 1) .* varE);
Talf = -1 / log(alf); txalf = '\alpha';
v(LdE, 1) = 0;
v(1, 1) = 0; for(n = 2:LdE) v(n, 1) = E(n - 1) * alf; end;
sigZ = std(E - v);
% ........................................................
% obliczanie sigYo i sigYe;
KA = G * varE; % macierz kowariancji wspolcz.
Lduzych = 0;

for (n = 1:Ldanych)
    varYo = FI(n, :) * KA * FI(n, :)';
    sigYo(n, 1) = sqrt(varYo);
    sigYe(n, 1) = sqrt(varYo + varE);
    if (abs(E(n)) > sigYe(n)) Lduzych = Lduzych + 1; end
end

Kz = sigEo * sqrt(1 - alf^2);

uLd = Lduzych / Ldanych * 100;
% ................................
hold on; if(Ldanych > 30) kol = 'b'; else kol = 'bo-'; end
plot(x, Yemp, 'k.', x, Yo, kol, x, E, 'r', x, E - v, 'g', x, v, 'b', [x(1) x(end)], [0 0], 'k:'); %axis('tight');
%xlabel(sprintf('Ldanych=%d sigYf=%.3f sigEo=%.3f', Ldanych, sigYf, sigEo));
plot(x, Yo + sigYo, 'b--', x, Yo - sigYo, 'b--');
plot(x, Yo + sigYe, 'm--', x, Yo - sigYe, 'm--');
hold off; axis('tight')
xlabel(sprintf('Ldanych=%d sigYf=%.3f sigEo=%.3f udz.DyzychE=%.1f%% %s=%.3f T_%s=%.3f', Ldanych, sigYf, sigEo, uLd, txalf, alf, txalf, Talf));
% ......................................................
fprintf(1, '\nWspolczynniki i ich statystyki tSt');
m = 0;

for (k = 1:Kd)

    if (k > Km) tSt(k) = 0; A(k) = 0;
    else m = m + 1; tSt(k) = abs(Ao(m)) / KA(m, m); A(k) = Ao(m);
    end

    % fprintf(1, '\nA(%-2d)=%-9.3f tSt=%-7.3f ....... Af=%-7.3f', k, A(k), tSt(k), Af(k)); % DO ZATWIERDZENIA
    fprintf(1, '\nA(%-2d)=%-9.3f tSt=%-7.3f', k, A(k), tSt(k));
end

fprintf(1, '\n alf=%.4f Talf=%.3f Kz=%.3f\n', alf, Talf, Kz)

xmin = min(x); xmax = max(x);
Ldim = 2000; Xmin = xmin; Xmax = xmin + T * 1.3;
dv = (Xmax - Xmin) / (Ldim - 1); v = [Xmin:dv:Xmax];
z0 = 0; z(Ldim) = 0;

for (i = 1:Ldim)

    fi = modelRharm(v(i), om(1:Lhm)); % za³. funkcji harmonicznej

    yo(i, 1) = fi * Ao;
    varYv = fi * KA * fi';
    sigYv(i, 1) = sqrt(varYv);
    sigYE(i, 1) = sqrt(varYv + varE);
    z(i) = alf * z0 + Kz * randn; % z - E symulowane
    z0 = z(i);
end
figPW;
figure(2), subplot(2, 1, 2), plot(x, Yemp+sred_temp, kol1, v, yo+sred_temp, 'r', x, E+sred_temp, 'k', v, z+sred_temp, 'g'); hold on;
%input(' co dalej ?? ');
plot(v, yo + sigYv+sred_temp, 'b:', v, yo - sigYv+sred_temp, 'b:');
plot(v, yo + sigYE+sred_temp, 'm:', v, yo - sigYE+sred_temp, 'm:'); 
xlabel(sprintf('Ldanych=%d sigYf=%.3f sigEo=%.3f Km=%d udz.DyzychE=%.1f%%', Ldanych, sigYf, sigEo, Km, uLd)); ylabel([ 'Temperatura wody [' char(176) 'C]']);
axis('tight'); title('Prognoza temperatury wody (Laboratorium £ukanowice)'); hold off;
legend('Pomiary empiryczne','Trend','Zak³ócenia rzeczywiste','Zak³ócenia estymowane')
yearProgno = [1:365:Xmax]; xticks(yearProgno);
xticklabels(round(yearProgno/366)+2013); figPW;% end

% Œrednia temperatura w tygodniu z wielu lat (do arkusza kalkulacyjnego)
tempe = Yo(1:365)+sred_temp;
Ttyg = [];
for (t = 1:52)
    Mdt = 0;
    for d = 1:7
        Mdt = Mdt + tempe(7*(t-1)+d);
    end    
    Ttyg(t) = Mdt/7;
end
Ttyg = Ttyg'; 

tau = 6000 / 300; % poj zbior. / przewp³yw kwantowy
% wartoœæ oczekiwana po rozowie z technologami: 18* * 0.05

%charak statyczne, moc max
% clipboard ('copy',Ttyg');
% % return
[a,fname,c] = fileparts( mfilename('fullpath'));  % nazwa tego m-pliku
print( strcat(fname,'.png'),'-dpng');              % zapisz ostatn¹ figurê