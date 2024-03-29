%regr_cwicz
clear all
% ========== Dane empiryczne ================
wspZ=0.02; 
Ldemp=30; xmin=0.1; xmax=2.1; 
dx=(xmax-xmin)/(Ldemp-1); x=[xmin:dx:xmax]'; %rand(Ldemp,1); 
[Yemp,Yteor,wspZ,Af]=obiekt(x,-wspZ); 
Kf=length(Af); istot=zeros(1,Kf); 
figure(1);
subplot(1,1,1); hold off;
plot(x,Yemp','k.'); 
xlabel(' Mamy dane empiryczne');
input(' Mamy dane empiryczne - <Ent> pokaz hipotetycznych zak��ce� ')
% Generujemy duzo zaklocen, aby zobaczyc jak mog� wygladac dane
Ldem=10000; 
Xvmin=0; Xvmax=xmax*1.2; 
dx=(Xvmax-Xvmin)/(Ldem-1); xd=[Xvmin:dx:Xvmax]'; %rand(Ldemp,1); 
[Ye,Yt]=obiekt(xd,wspZ); 
figure(1);
%subplot(1,2,1);
plot(xd,Ye,'c.', x,Yteor','k',x,Yemp','k.'); 
txsig='\sigma'; txalf='\alpha'; txbet='\beta'; 
xlabel(sprintf(' Dane empiryczne i hipotetyczne zak��cenia %s_z=%.2f %s %s',txsig,wspZ,txalf,txbet));
input(' <Ent> liczymy regresj� ')
% ======== Mamy dane - teraz regresja =======
tKryt=2.5; 
Kd=12; if(Kd>Kf) Kd=Kf; end; % wielom.(Kd-1)go stopnia
% OBLICZAMY MACIERZ WEJSC UOGOLN FI - arbitralne 
FI(:,1)=ones(Ldemp,1); istot(1)=1; 
for(k=2:Kd) FI(:,k)=x.^(k-1); istot(k)=1; end
dalej=1;
% .......... Poczatek iteracji regresji krokowej
while(dalej)
    % .......... Budujemy macierz Fi wejsc uwzglednionych 
    kw=0; clear Fi Aob G Yob E; 
    for(k=1:Kd) 
        if(istot(k)>0) kw=kw+1; Fi(:,kw)=FI(:,k); end
    end
    Kw=kw; 
    % .......... Teraz obliczenia formalne ............
    G=inv(Fi'*Fi); % macierz Gaussa
    Aob=G*Fi'*Yemp; % wspolcz. modelu
    Yob=Fi*Aob;     % wart. Y modelu w obserwacjach
    % .... Liczymy reszty (b��d modelu) ...........
    E=Yemp-Yob;
    % .... Liczymy variancje sklad.losowej i macierz kowariancji wspolcz, KA
    varZ=(E'*E)/(Ldemp-Kd); sigZ=sqrt(varZ); 
    KA=G*varZ; 
    % ------------- Wydruk wspolczynnikow ------------------
    tstmin=1.e20; kw=0;
    tstMale=[]; m=0;  clear tMale Male; 
    for(k=1:Kf)
        if(istot(k)<=0) 
            fprintf(1,'\nAob(%2d)=%-8.3f tst=-%7.2f ......... Af=%.2f (nieznane)',k,0,0,Af(k));
        else    
            kw=kw+1; 
            tst(kw)=abs(Aob(kw))/sqrt(KA(kw,kw)); % tzw. statystyka Studenta 
            if(tst(kw)<tKryt) m=m+1; Male(m)=k; tMale(m)=tst(kw); end
            fprintf(1,'\nAob(%2d)=%-8.3f tst=-%7.2f ......... Af=%.2f (nieznane)',k,Aob(kw),tst(kw),Af(k));
            if(kw>1 && tst(kw)<tstmin) tstmin=tst(kw); kmin=k; end
            if(kw>1 && tst(kw)<tKryt) tstMale=[tstMale, k]; end
        end
    end
    % ---------- Selekcja wspolcz. istotnych wg tst
    if(m==0)  dalej=0; break; end
    mmin=find(tMale==min(tMale)); kmin=Male(mmin(1)); 
     % do usuniecia wybieramy wejsci o najwiekszym najmniejszym tst
    % .......... Usuniecie wejscia kmin modelu; 
    kus=input(sprintf('\nUsuniecie wejscia %d: tst=%.2f <Ent> lub wpisz inny numer wej�cia; 0 - KONIEC ?? ',kmin, tMale(mmin))); 
    if(isempty(kus)) istot(kmin)=0; else if(kus>1 && kus<=Kf) istot(kus)=0; else dalej=0; break; end, end
end
% ... Liczymy odch. stand. bledu estymacji dla obserwacji x i licznosc bledow e w 1.sigmowum przedziale 
Lmalych=0; 
for(n=1:Ldemp)
    varYm=Fi(n,:)*KA*Fi(n,:)'; varYe=varZ+varYm; 
    sgYe(n)=sqrt(varYe); 
    if(abs(E(n))<=sgYe) Lmalych=Lmalych+1; end
end
udzMalych=Lmalych/Ldemp*100; 
% ... Liczymy odch. stand. bledu estymacji dla zadanych dowolnie xv (np.innych niz x) 
Ldv=500; Xvmin=0; Xvmax=xmax*1.2; 
dx=(Xvmax-Xvmin)/(Ldv-1); xv=[Xvmin:dx:Xvmax]'; %rand(Ldemp,1); 
clear fi; 
for(n=1:Ldv)
    fi(1)=1;  kw=1; 
    for(k=2:Kd) 
        if(istot(k)>0) kw=kw+1; fi(kw)=xv(n)^(k-1); end
    end, % Obliczamy wejscia uogoln. dla zadanych xv(n) obserwa
    Yv(n)=fi*Aob; varYm=fi*KA*fi'; varYe=varZ+varYm; 
    sigYm(n)=sqrt(varYm); sigYe(n)=sqrt(varYe); 
end
% ------------ Koniec (na razie) -------
% Generujemy duzo zaklocen, aby zobaczyc jak mog� wygladac dane
Ldem=10000; 
dx=(Xvmax-Xvmin)/(Ldem-1); xd=[Xvmin:dx:Xvmax]'; %rand(Ldemp,1); 
[Ye,Yt]=obiekt(xd,wspZ); 
figure(1);
subplot(1,2,1);
plot(xd,Ye,'c.', x,Yteor','k',x,Yemp','k.'); 
xlabel(sprintf('Dane Y_{emp}k i regresja Y_{ob}r: Ldemp=%d Kd=%d sigZ=%.2f (wspZ=%.2f) udzMaluch=%.2f %%',Ldemp,Kd,sigZ,wspZ,udzMalych));  axis('tight');
subplot(1,2,2);
plot(Yob,E.^2,'k.'); xlabel(sprintf('e^2 v.s. Y_{ob}'));  axis('tight');
%input(' <Ent> ');
subplot(1,1,1); hold on, 
plot(xd,Ye,'c.', x,Yteor','k',x,Yemp','k.',x,Yob,'r.'); 
plot(xv,Yv,'r--',xv,Yv-sigYm,'m--',xv,Yv+sigYm,'m--',xv,Yv-sigYe,'k--',xv,Yv+sigYe,'k--'); 
axis('tight');
xlabel(sprintf('Dane Y_{emp}k i regresja Y_{ob}r: Ldemp=%d Kd=%d sigZ=%.2f (wspZ=%.2f) udzMaluch=%.2f %%',Ldemp,Kd,sigZ,wspZ,udzMalych));  axis('tight');
hold off; 
axis('tight');


%filtacja cyfrowa szum r�owy
% dt=1.e-3; N=10006; t=[1:N]*dt; T=N/5*dt; Y=5*sin(2*pi*t/T)+3*sin(2*pi*t*10/T); A=fft(Y); Am=abs(A); M=round(N/2); Amp=sqrt(Am(M:end)*dt); subplot(1,2,1); plot(t,Y); subplot(1,2,2); plot([M:N],Amp)
%dt=1.e-3; N=1006; t=[1:N]*dt; T=N*dt; Y=5*sin(2*pi*t/T)+3*sin(2*pi*t*100/T); A=fft(Y); Am=abs(A); M=round(N/2); Amp=sqrt(Am(1:M)*dt); subplot(1,2,1); plot(t,Y); axis('tight'); subplot(1,2,2); plot([1:M],Amp,'k',-20,0,'w'); axis('tight')
% dt=1.e-3; N=1006; t=[1:N]*dt; T=N*dt; Y1=5*sin(2*pi*t/T); Y2=3*sin(2*pi*t*5/T); Y3=5*sin(2*pi*t*3/T); Y4=3*sin(2*pi*t*2/T); Y0=10/(N*dt)*t; Y=Y0+Y1+Y2+Y3+Y4;A=fft(Y); Am=abs(A); M=round(N/2); Amp=sqrt(Am(1:M)*dt); subplot(1,2,1); plot(t,Y,'k',t,Y1,'b',t,Y2,'r',t,Y3,'m',t,Y4,'g',t,Y0,'k--'); axis('tight'); subplot(1,2,2); plot([1:50],Amp(1:50),'k',-0.20,0,'w'); axis('tight')