clear all;
Ldanych=1200; %2000;  
Lsk=60;  Lkor=20; 
jednakowe=0; 
if(jednakowe) sgdr=ones(1,Lsk); sredr=zeros(1,Lsk); 
else
    sgdr1=[1, 10, 200, 0.1, 30, 12.5, 20, 0.2, 22, 33]; sgdr=sgdr1; 
    while(length(sgdr)<Lsk)  sgdr=[sgdr sgdr1]; end
    sredr=rand(1,Lsk)*1000; 
end
Sredr=mean(sredr(1,1:Lsk)); Sgdr=sqrt(sum(sgdr(1,1:Lsk).^2)/(Lsk^2)); 
a=0; %10; 
% Parametry faktyczne rozkladow: 
srtr=0.5; sigtr=1/(2*sqrt(3)); 
srtn=0; sigtn=1; 
% Zadane wart. param. rozk³adów
srdr=10; sigdr=15; 
srdn=20; sigdn=100; 
% Parametr dla AR1
alfa=0.8; 
% Podstawienia wstêpne
Sn=0; Sr=0; S2n=0; S2r=0; % podstawienia wstêpne sum
vn=0; 
% Zerowanie sum korelacji
sum12 = zeros(1,Lkor); sum1 = sum12; sum2 = sum1; sum21 = sum1; sum22 = sum1;
R=zeros(Lkor,Ldanych); 
% wstepne zerowanie dla przyspiesz obliczeñ
t=zeros(1,Ldanych);  yr=zeros(1,Ldanych);  yn=zeros(1,Ldanych);  
srr=zeros(1,Ldanych);  srn=zeros(1,Ldanych);  
Sigr=zeros(1,Ldanych);  Sign=zeros(1,Ldanych);  

for(n=1:Ldanych) % petla czasu 
    t(n)=n-1; 
    zs=0; 
    for(k=1:Lsk) % Sprawdz. tw. Lindberga Levy'ego
         zr=(rand-0.5)/sigtr;  % zmienna rand standaryzowana
         zr=zr*sgdr(k)+sredr(k);
         zs=zs+zr; 
    end
    zr=(zs/Lsk-Sredr)/Sgdr; 
    %zr=zs/sqrt(Lsk); %=zs/Lsk/(1/sqrt(Lsk));   % standaryzujemy srednia   
    zr=zr*sigdr;
    vn=alfa*vn+zr;  % Symulacja procesu AR1 z zerow¹ sredni¹
    yr(n)=vn+srdr;  % Dodanie sredniej do vr
    zn=randn;      % zmienna randn jest ju¿ standaryzowana
    yn(n)=sigdn*zn+srdn; %+a*yr(n);  % +a*yr(n) - korelacja
    Sr=Sr+yr(n); srr(n)=Sr/n;  % estymacja wartoœci oczekiwanej
    S2r=S2r+yr(n)^2; varr=S2r/n-srr(n)^2; % obci¹¿ona estymacja wariancji
    Sigr(n)=sqrt(varr); % odchylenie standardowe
    Sn=Sn+yn(n); srn(n)=Sn/n;  % estymacja wartoœci oczekiwanej
    S2n=S2n+yn(n)^2; varn=S2n/n-srn(n)^2; % obci¹¿ona estymacja wariancji
    Sign(n)=sqrt(varn); % odchylenie standardowe for(k=1:Lkor)
    for(k=1:Lkor)
       if(n>k+1) 
           ld=n-k;  % szerokoœæ okna
           % przypisanie zmiennych losowych dla standaryzacji kodu obliczaj¹cego R
           v1=yr(n);  v2=yr(n-k);  
           % ............................. Pocz¹tek obliczeñ dla R(k,n) .................................
           sum12(k)=sum12(k)+v1*v2; 
           sum1(k)=sum1(k)+v1; sum2(k)=sum2(k)+v2; 
           sum21(k)=sum21(k)+v1^2; sum22(k)=sum22(k)+v2^2; 
           sr1=sum1(k)/ld; sr2=sum2(k)/ld; 
           var=sum21(k)/ld-sr1^2; sig1=sqrt(var);
           var=sum22(k)/ld-sr2^2; sig2=sqrt(var);
           K=sum12(k)/ld-sr1*sr2;  % wspó³czynnik kowariancji
           R(k,n)=K/(sig1*sig2);      % wspó³czynnik korelacji - estymata funkcji korelacyjnej R(k)
           R(k,end) = R(k,end-1);
       end
    end
end
sgsrr=sigtr./sqrt([1:Ldanych]); sgsrn=sigtn./sqrt([1:Ldanych]);   
figure(1); 
subplot(2,2,1); 
plot(t,yr,'k.',t,srr,'r',t,srdr+sgsrr,'m',t,srdr-sgsrr,'m',...
    t,Sigr+srdr,'b',t,-Sigr+srdr,'b',t([1 end]),srdr+[sigdr sigdr],'b--',...
    t([1 end]),srdr-[sigdr sigdr],'b--');  
txsig='\sigma';
%xlabel(sprintf('Liczby rand: sr=%.3f/%.3f   t',srr(Ldanych),srtr)); axis('tight')
xlabel(sprintf('Liczby randn: Lsk=%d L_{danych}=%d sr=%.2f/%.2f  %s=%.2f/%.2f  t',Lsk,Ldanych,srr(Ldanych),srdr,txsig,Sigr(Ldanych),sigdr)); 
axis('tight');
subplot(2,2,3); 
plot(t,yn,'k.',t,srn,'r',t,srdn+sgsrn,'m',t,srdn-sgsrn,'m',...
    t,Sign+srdn,'b',t,srdn-Sign,'b',t([1 end]),srdn+[sigdn sigdn],'b--',...
    t([1 end]),srdn-[sigdn sigdn],'b--');  
xlabel(sprintf('Liczby randn: L_{danych}=%d sr=%.2f/%.2f  %s=%.2f/%.2f  t',Ldanych,srn(Ldanych),srdn,txsig,Sign(Ldanych),sigdn)); axis('tight');
if(0)
    subplot(1,2,2); 
    plot(yr,yn,'k.');  xlabel('Wykres przekroj. randn=f(rand)'); axis('tight')
else % Teraz histogramy
    nbins=15;
    subplot(2,2,2); [pvg,pvr,chi2e,chi2r]=mhistf(yr,nbins); 
    txchi='\chi'; txpi='\pi'; 
    xlabel(sprintf('%s_{vg}=%.2f  %s^2_{g}=%.2f  %s_{vr}=%.2f  %s^2_{r}=%.2f',...
        txpi,pvg,txchi,chi2e,txpi,pvr,txchi,chi2r)); 
    subplot(2,2,4); [pvg,pvr,chi2e,chi2r]=mhistf(yn,nbins); 
    xlabel(sprintf('%s_{vg}=%.2f  %s^2_{g}=%.2f  %s_{vr}=%.2f  %s^2_{r}=%.2f',...
        txpi,pvg,txchi,chi2e,txpi,pvr,txchi,chi2r)); 
end
figure(2); subplot(1,2,1); mesh(R); 
title(sprintf('Funkcje korelacyjne R(k), k=1:%d, dla okna o szerokoœci n=k:%d',Lkor,Ldanych))

okno=round([0.1, 0.2, 0.4, 0.6, 0.8, 1]*Ldanych);  Ldokno=length(okno);
tau=[1, 2,  3, 5, 10, Lkor];   Ltau=length(tau);
kol='krmbgc'; 
subplot(2,2,2); tx=[]; 
for(m=Ldokno:-1:1) 
    tx=[tx sprintf('%c n=%d; ',kol(m),okno(m))]; 
    plot([1:Lkor],R(:,okno(m)),[kol(m) '.-']); hold on; 
end, 
hold off;  axis('tight');  
xlabel(tx); 
subplot(2,2,4);  tx=[];
for(m=1:Ltau) 
    tx=[tx sprintf('%c k=%d; ',kol(m),tau(m))]; 
    plot([1:Ldanych],R(tau(m),:),kol(m));  hold on; 
end; hold off; axis('tight'); 
xlabel(tx)


