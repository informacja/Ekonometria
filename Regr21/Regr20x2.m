% Regr20 - plik realizuj¹cy regresje 1 i 2 wymiarow¹ wg obiekt2.m i model2.m 
% ==== Pozyskujemy dane (np. z eksperym)
clear all;
wspZ=-0.1; % wzgl odch.std
% defin. x
Ld=30; 
w=0.12; x(:,1)=[1:Ld]'*w+0.5; 
xmin=0.5*w+0.5; xmax=(Ld-0.5)*w+0.5; dx=(xmax-xmin)/(Ld-1);
x(:,2)=[xmin:dx:xmax]'; 
[Yemp,Yteor,sigfZ,Af]=obiekt(x,wspZ); % Pobranie danych
% Wizualizacja
figure(100);
% Hipotetycz. zakl.
Lxh=17000; xh(:,1)=w*[1:Lxh]'/Lxh*Ld+0.5; 
dxh=(xmax-xmin)/(Lxh-1);
xh(:,2)=[xmin:dxh:xmax]; 
Yh=obiekt(xh,sigfZ); % symulacja danych hipotet.
plot(xh,Yh,'c.');
hold on; plot(x,Yemp,'k*',x,Yteor,'k:'); hold off;
xlabel('Dane i funk.Igo rodz. oraz hipotet.punkty pomiarowe'); axis('tight');
% ====== Teraz musimy zaprojekt. model ==================
[FI,Kmf,Tx]=model2(x);  % pe³na macierz wejœæ uogóln dla danych x
% ====== Teraz standardowa regresja krokowa =====================
istot=ones(1,Kmf); dalej=1; 
tStkryt=2; mintSt=-1
while(dalej)
    hold off; plot(xh,Yh,'c.',x,Yemp,'k*',x,Yteor,'k:'); hold on;    
    % Budujemy macierz wejsc w³¹czonych
    clear Fi G Am Yo E KA Ye sigYm sigYe; 
    mist=find(istot>0); 
    k=0; for(m=1:Kmf) if(istot(m)) k=k+1; Fi(:,k)=FI(:,m); end, end
    Km=k; % tyle mamy faktycznie w³¹czonych cz³onów
    % Liczymy regresjê dla Fi
    % Najpierw liczymy RCN
    FixFi=Fi'*Fi; s=svd(FixFi); RCN=s(end)/s(1); 
    % Teraz zwyk³a regresja
    G=inv(Fi'*Fi);
    Am=G*Fi'*Yemp; % wspolczyn. modelu
    Yo=Fi*Am; % wartoœci funkcji regr. dla x
    % Liczymy macierz kowar.A
    E=Yemp-Yo; varZ=(E'*E)/(Ld-Km); % estymata war.Z
    KA=G*varZ;
    % Liczymy satystyki Stodenta 
    k=0; mintSt=1.e40; 
    fprintf(1,'\nWspolczynniki i test Studenta - RCN=%.5g \n',RCN); 
    for(m=1:Kmf)
        if(istot(m)) 
           k=k+1;  
           tSt(k)=abs(Am(k))/sqrt(KA(k,k)); 
           if(tSt(k)<mintSt && m>1) kminSt=m; mintSt=tSt(k); end
           fprintf(1,'Am(%.2d)=%5.2f tSt(%2d)=%5.2f ...... Af(%2d)=%5.2f\n',m,Am(k),m,tSt(k),m,Af(m));
        else
           fprintf(1,'Am(%.2d)= 0.00 tSt(%2d)=***** ...... Af(%2d)=%5.2f\n',m,m,m,Af(m));
        end
    end
    LEsig=0;
    for(n=1:Ld)
        fd=Fi(n,:);  % wektor wejœæ uogóln dla danych xd(n)
        varYm=fd*KA*fd';
        sigYem=sqrt(varYm+varZ);
        if(abs(E(n))<=sigYem) LEsig=LEsig+1; end
    end
    udzEsig=LEsig/Ld*100;
    % wizualizacja wyników.
    xd=x*1.01; Fd=model2(xd);  % macierz wejœæ uogóln dla danych xd
    Fd=Fd(:,mist); 
    Yd=Fd*Am; Ydz=Yd+sqrt(varZ)*randn(Ld,1);
    % Wizualiz. wyniku:
    hold on; plot(x,Yo,'r',xd,Yd,'b--',xd,Ydz,'r.'); hold off; axis('tight');
    % Liczymy odch. stand. modelu i wyjsc modelu % varYm(v)=fi(v)*KA*fi(v)'
    wd=1.1*w; Lxd=7000; xd=wd*[1:Lxd]'/Lxd*Ld+0.5; xd=[xd xd]; 
    for(n=1:Lxd)
        fd=model2(xd(n,:));  % wektor wejœæ uogóln dla danych xd(n)
        fd=fd(mist); 
        varYm=fd*KA*fd';
        Yd(n,1)=fd*Am;
        sigYm(n,1)=sqrt(varYm);
        sigYe(n,1)=sqrt(varYm+varZ);
    end
    hold on; plot(xd,Yd+sigYm,'r--',xd,Yd-sigYm,'r--',xd,Yd+sigYe,'m--',xd,Yd-sigYe,'m--'); hold off; axis('tight');
    txt=sprintf('Y(x)=%.3f',Am(1)); 
    m=1; for(k=2:Kmf) if(istot(k)) m=m+1; txt=[txt sprintf('%+5.3f*%s',Am(m),Tx(k).nf)]; end, end
    txt=[txt sprintf('  udz_{Esig}=%.1f %%',udzEsig)];
    xlabel(txt);
    % Procedura odrzucania
    if(dalej<0) 
        fprintf(1,'Model KONCOWY: RCN=%.4g     ',RCN); 
        break; 
    end
    if(mintSt>tStkryt) dalej=-1; % sa cz³ony do odrzucenia
    else % eliminujemy cz³on kminSt
        istot(kminSt)=0; 
        fprintf(1,'RCN=%.4g Usuniêto cz³on %d %s     ',RCN,kminSt,Tx(kminSt).nf); 
    end
end