 %Cwicz2Regr
% Mamy dane empiryczne z funkcji obiekt
hold off;
clear all;
Ldanych = 60; sigZf=0.05; % wzglêdne odch std zak³ odniesien do œredn Ykv
xmin=.1; xmax=1.2;  % zakres x
dx=(xmax-xmin)/(Ldanych-1); 
x=[xmin:dx:xmax];
 [Yemp,Yteor,sigZf,Af]=obiekt(x,-sigZf); 
% G³êbokie myœlenie = prezentacja danych + wyobra¿enia
kol1='r*'; if(Ldanych>80) kol1='r.'; end
 figure(1); subplot(1,1,1); plot(x, Yemp,kol1); hold on
%  z=input(' ? jaka to funkcja ? !!!  <Ent> - co mogloby byc ?') ; 
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
Km = 4; % Przyjety (arbitralnie) rzad modelu 
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
hold on; if(Ldanych>80) kol='k.'; else kol = 'ko'; end

% obliczanie sigYo i sigYe; (krzywe neymana) przedzia³y ufnosci
KA=G*varZ; % macierz kowariancji wspolcz.
Lduzych = 0; % odchylek
for(n=1:Ldanych)
    varYo=FI(n,:)*KA*FI(n,:)';
    sigYo(n,1)=sqrt(varYo);
    sigYe(n,1)=sqrt(varYo+varZ);
    if(abs(E(n))>sigYe(n)) Lduzych=Lduzych+1; 
    end
end
hold on;
plot(x,Yo+sigYo,'b--',x,Yo-sigYo,'b--');
plot(x,Yo+sigYe,'m--',x,Yo-sigYe,'m--');
plot (x, Yo, kol); %axis('tight');
xlabel(sprintf('Ldanych=%d sigZf=%.3f sigZo=%.3f% licz. Duzych=%.2f%%',Ldanych,sigZf,sigZo,Lduzych)); 
hold off;
fprintf(1,'\nWspolczynniki i ich statystyki testu Studenta');
for(k=1:Kd)
    if(k>Km) tSt(k)=0; A(k)=0;
    else tSt(k)=abs(Ao(k))/KA(k,k); A(k)=Ao(k);
    end
    fprintf(1,'\nA(%-2d)=%-9.3f tSt=%-6.3F ....... Af=%-7.4f', k,A);
end
%plot(x,
hold on;
 Ldim=1000; Xmin = xmin; Xmax=xmax*1.4;
 dv=(xmax-xmin)/(Ldim-1);  v=[xmin:dv:xmax];
[ye, yo] = obiekt(v, sigZf); % yo - y obliczone
 for(i = 1:Ldim)     
     fi = v(i).^[0:Km-1];
     yo(i,1)=fi*Ao;
     varYv=fi*KA*fi'; % validacja
     sigYv(i,1)=sqrt(varYv);
     sigYE(i,1)=sqrt(varYv+varZ);     
 end
 plot(x, ye, 'c.',v,yo,'r')
 plot(v,yo+sigYv,'b:',v,yo-sigYv,'b:');
 plot(v,yo+sigYE,'b:',v,yo-sigYE,'b:');
 plot(x, Yteor, 'm',x,Yemp,kol1); hold off;

axis('tight');

return 
