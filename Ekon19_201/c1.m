tic;
%  clear all;
Ldanych=2000
;
a=10; %10; 
% Parametry faktyczne rozkladow: 
srtr=0.5; sigtr=1/(2*sqrt(3)); 
srtn=0; sigtn=1; 
Sn=0; Sr=0; S2n=0; S2r=0; % podstawienia wst�pne sum
% wstepne zerowanie dla przyspiesz oblicze�
t=zeros(1,Ldanych);  yr=zeros(1,Ldanych);  yn=zeros(1,Ldanych);  
srr=zeros(1,Ldanych);  srn=zeros(1,Ldanych);  
Sigr=zeros(1,Ldanych);  Sign=zeros(1,Ldanych);  
for(n=1:Ldanych) % petla czasu 
    t(n)=n-1; 
    yr(n)=rand; 
    yn(n)=randn+a*yr(n);  % +a*yr(n) - korelacja
%     Sr=Sr+yr(n); srr(n)=Sr/n;  % estymacja warto�ci oczekiwanej
    % S2r=S2r+yr(n)^2; varr=S2r/n-srr(n)^2; % obci��ona estymacja wariancji
    % Sigr(n)=sqrt(varr); % odchylenie standardowe
    % Sn=Sn+yn(n); srn(n)=Sn/n;  % estymacja warto�ci oczekiwanej
    S2n=S2n+yn(n)^2; varn=S2n/n-srn(n)^2; % obci��ona estymacja wariancji
    Sign(n)=sqrt(varn); % odchylenie standardowe
end
figure(1); 
subplot(2,2,1); 
plot(t,yr,'k.',t,srr,'r',t,Sigr+srtr,'b',t,-Sigr+srtr,'b',t([1 end]),[sigtr sigtr],'b--');  
xlabel(sprintf('Liczby rand: sr=%.3f/%.3f   t',srr(Ldanych),srtr)); axis('tight')
subplot(2,2,3); 
plot(t,yn,'k.',t,srn,'r',t,Sign+srtn,'b',t,-Sign+srtn,'b',t([1 end]),[sigtn sigtn],'b--');...
    xlabel(sprintf('Liczby randn: sr=%.3f/%.3f   t',srn(Ldanych),srtn)); axis('tight')
subplot(1,2,2); 
plot(yr,yn,'k.');  xlabel('Wykres przekroj. randn=f(rand)'); axis('tight')
toc
