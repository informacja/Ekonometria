tic;
% clear all;

Ldanych=2000;  Lsk=10; 
sgdr=[1, 10, 20, 0.1, 30, 12.5, 200, 0.2, 22, 33]; 
sredr=rand(1,Lsk)*100; Sredr=mean(sredr(1:Lsk)); Sgdr=sqrt(mean(sgdr.^2)); 
a=0; %10; 
% Parametry faktyczne rozkladow: 
srtr=0.5; sigtr=1/(2*sqrt(3)); 
srtn=0; sigtn=1; 
% Zadane wart. param. rozk³adów
srdr=10; sigdr=15; 
srdn=20; sigdn=100; 
% Podstawienia wstêpne
Sn=0; Sr=0; S2n=0; S2r=0; % podstawienia wstêpne sum
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
    zr=(zs-Sredr)/Sgdr; 
    %zr=zs/sqrt(Lsk); %=zs/Lsk/(1/sqrt(Lsk));   % standaryzujemy srednia   
    yr(n)=zr*sigdr+srdr; 
    zn=randn;      % zmienna randn jest ju¿ standaryzowana
    yn(n)=sigdn*zn+srdn; %+a*yr(n);  % +a*yr(n) - korelacja
    Sr=Sr+yr(n); srr(n)=Sr/n;  % estymacja wartoœci oczekiwanej
    S2r=S2r+yr(n)^2; varr=S2r/n-srr(n)^2; % obci¹¿ona estymacja wariancji
    Sigr(n)=sqrt(varr); % odchylenie standardowe
    Sn=Sn+yn(n); srn(n)=Sn/n;  % estymacja wartoœci oczekiwanej
    S2n=S2n+yn(n)^2; varn=S2n/n-srn(n)^2; % obci¹¿ona estymacja wariancji
    Sign(n)=sqrt(varn); % odchylenie standardowe
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
toc;

