 %Cwicz2Regr
% Mamy dane empiryczne z funkcji obiekt
clear all;
Ldanych = 560; sigZf=0.05; % wzglêdne odch std zak³ odniesien do œredn Ykv
xmin=.1; xmax=1.2;  % zakres x
dx=(xmax-xmin)/(Ldanych-1); 
x=[xmin:dx:xmax];
 [Yemp,Yteor,sigZf,Af]=obiekt(x,-sigZf); 
% G³êbokie myœlenie = prezentacja danych + wyobra¿enia
kol1='r*'; if(Ldanych>80) kol1='r.'; end
 figure(1); subplot(1,1,1); 
 plot(x, Yemp,kol1); hold on
 z=input(' ? jaka to funkcja ? !!!  <Ent> - co mogloby byc ?') ; 
 % wyobra¿enia
 Ldim=1000;
 dv=(xmax-xmin)/(Ldim-1);  v=[xmin:dv:xmax];
 for(i = 1:Ldim)
     ye = obiekt(x, sigZf);
     plot(x, ye, 'c.');
 end
 plot(x, Yteor, 'm',x,Yemp,kol1); hold off;
z=input(' ?  co mogloby byc ?   <Ent> - dobierz funkcje ') ; 
%return
%% Projekt modelu - oblicz FId
% za³. wielomianu
Kd = length(Af); % Wielomian maxym.go rzedu
FId(:,1)= ones(Ldanych, 1);
for(k=2:Kd)
    FId(:,k) = (x').^(k-1);
end
Km = 6; % Przyjety (arbitralnie) rzad modelu 
% wybieramy model
FI(:,1:Km) = FId(:,1:Km);
% dalej ju¿ tylko numeryka i grafika 
Gd = FI'*FI;
G  = inv(Gd);
Ao = G*FI'*Yemp;
% sprawdz modelu
Yo = FI*Ao;
E = Yemp - Yo; varZ=(E'*E)/(Ldanych-Km); 
sigZo=sqrt(varZ); 
hold on; if(Ldanych>30) kol='k.'; else kol = 'ko'; end
plot (x, Yo, kol); %axis('tight');
xlabel(sprintf('Ldanych=%d sigZf=%.3f sigZo=%.3f',Ldanych,sigZf,sigZo)); 
hold off;
% obliczanie sigYo i sigYe;
KA=G*varZ; % macierz kowariancji wspolcz.
Lduzych=0;
for(n=1:Ldanych)
    varYo=FI(n,:)*KA*FI(n,:)'; 
    sigYo(n,1)=sqrt(varYo); 
    sigYe(n,1)=sqrt(varYo+varZ); 
    if(abs(E(n))>sigYe(n)) Lduzych=Lduzych+1; end
end
uLd=Lduzych/Ldanych*100; 
hold on; 
plot(x,Yo+sigYo,'b--',x,Yo-sigYo,'b--'); 
plot(x,Yo+sigYe,'m--',x,Yo-sigYe,'m--'); 
hold off; %axis('tight')
xlabel(sprintf('Ldanych=%d sigZf=%.3f sigZo=%.3f udz.DyzychE=%.1f%%',Ldanych,sigZf,sigZo,uLd)); 
fprintf(1,'\nWspolczynniki i ich statystyki tSt');
for(k=1:Kd)
    if(k>Km)tSt(k)=0;  A(k)=0; 
    else tSt(k)=abs(Ao(k))/KA(k,k); A(k)=Ao(k);
    end
    fprintf(1,'\nA(%-2d)=%-9.3f tSt=%-7.3f ....... Af=%-7.3f',k,A(k),tSt(k),Af(k));
end
hold on; 
Ldim=2000; Xmin=xmin; Xmax=xmax*1.3; 
dv=(Xmax-Xmin)/(Ldim-1);  v=[Xmin:dv:Xmax];
ye = obiekt(v, sigZo);
 for(i = 1:Ldim)
     fi=v(i).^[0:Km-1];
     yo(i,1)=fi*Ao; 
     varYv=fi*KA*fi'; 
     sigYv(i,1)=sqrt(varYv); 
     sigYE(i,1)=sqrt(varYv+varZ); 
 end
 plot(v, ye, 'c.',v,yo,'r')
 plot(v,yo+sigYv,'b:',v,yo-sigYv,'b:');
 plot(v,yo+sigYE,'m:',v,yo-sigYE,'m:');
 plot(x, Yteor, 'm',x,Yemp,kol1); 
 axis('tight'); hold off;

return 
