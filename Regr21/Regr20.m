% Regr20.m 
% ==== Pozyskujemy dane (np. z eksperym)
clear all;
modOrtog=0; Ortog=2; % Na pocz¹tek wg modelu zwyklego
testForyg=0;
wspZ=-0.10e-1; %%wspZ=-0.025*1.e-20; % wzgl odch.std
% ............ defin. wejsc x ......................
Ld=300; 
Lx=1; 
xmin=0.62; xmax=4.1; dx=(xmax-xmin)/(Ld-1); 
x=[xmin:dx:xmax]';
% x = dane()'; plot (x); 
% Ld=length(x); xmin=min(x); xmax=max(x); dx=(xmax-xmin)/(Ld-1); 
if(Lx==2)
    wx2=dx/3; 
    x=[x x+wx2*(rand(Ld,1)-0.5)]; % drugie wejœcie jest zradomizowane wzgl. 1szego 
end
% ..................................................
Yteor=[]; sigfZ=[]; Af=[]; real=0;
if(real) [Yemp,x,Ld,xmin,xmax,sigfZ]=obiekt(x,wspZ); % Pobranie danych realnych (z eksperym)
else [Yemp,x,Ld,xmin,xmax,Lx,Yteor,sigfZ,Af]=obiekt(x,wspZ); % Pobranie danych do cwiczen
end
if(Lx>1) xs=mean(x')'; else xs=x; end
% Wizualizacja
figure(100+abs(modOrtog));
wx1=0.5; wx2=1.3;
xhmin=wx1*xmin; xhmax=wx2*xmax; 
if(~isempty(Yteor))
    % Hipotetycz. zakl.
    Lxh=17000; dxh=(xhmax-xhmin)/(Lxh-1);
    xh=[xhmin:dxh:xhmax]'; 
    if(Lx==2) xh=[xh xh]; end
    Yh=obiekt(xh,sigfZ); % symulacja danych hipotet.
    subplot(1,1,1);
    if(Lx>1) xhs=mean(xh')'; else xhs=xh; end, % Wizualizujemy dla srednich wejsc w obserwacjach 
    plot(xhs,Yh,'c.',xs,Yemp,'k*',xs,Yteor,'k:'); %hold off;
    xlabel('Dane i funk.Igo rodz. oraz hipotet.punkty pomiarowe'); axis('tight');
    input('  ?? Nacisnij <Ent> ');
end
% ====== Teraz musimy zaprojekt. model ==================
RCNmax=1.e-15; tStkryt=3.5;
[FId,Kmax,Tx]=model(x);  % pe³na macierz wejœæ uogóln dla danych x
% Standaryzacja FI
FIdsr=mean(FId); FIds(:,1)=FId(:,1); 
FIds(:,2:Kmax)=FId(:,2:Kmax)-FIdsr(2:Kmax);
stdFId(1)=1; 
for(m=2:Kmax) 
    stdFId(m)=sqrt((FIds(:,m)'*FIds(:,m))/Ld); 
    FIds(:,m)=FIds(:,m)/stdFId(m); 
end
% ====== Teraz standardowa regresja krokowa =====================
istot=zeros(1,Kmax); dalej=1; %istot(Kmax)=0; 
nrA0=[1:Kmax];
% Mozna obliczac model dokladny - trzeba podst. dokladny=1; .........................
dokladny=0;
if(dokladny && ~isempty(Af)) nrA0=find(Af~=0); end,
istot(nrA0)=1; 
NrAforyg=nrA0; NrAforygRCN=NrAforyg; Kmfo=length(NrAforyg);
if(modOrtog)
    % ============= Jesli zaczynamy od modelu ortogonalnego =============
    figure(100+abs(modOrtog));
    % .............................................................
    % Mozna obliczac model dokladny - trzeba podst. dokladny=1; ..................
    NrAforyg=nrA0; NrAforygRCN=NrAforyg;
    Kmfo=length(NrAforyg);
    clear Ps Psf Psx;
    jestAf=ntAr0;
    istot(1:Kmfo)=1; istot(Kmfo+1:Kmax)=0;
    Nr2Aforyg=NrAforyg(1,2:Kmax);
    [Psx,s,v]=svd(FIds(:,Nr2Aforyg)'*FIds(:,Nr2Aforyg));
    Psf=zeros(Kmax,Kmax); Psf(1,1)=1;
    Psf(Nr2Aforyg,Nr2Aforyg)=Psx;
    RCNf=s(Kmfo-1,Kmfo-1)/s(1,1);
    Ps(2:Kmfo,2:Kmfo)=Psx; Ps(1,1)=1;
    FIs=FIds(:,NrAforyg)*Ps;
    [Pm,s,v]=svd(FId(:,NrAforyg)'*FId(:,NrAforyg));
    RCNmf=s(Kmfo,Kmfo)/s(1,1);
    %FI=FId(:,NrAforyg)*Pm;
    % ................... Koniec przygotowania modelu ortogonalnego ......
else  FIs=FIds; FI=FId; % Tu zaczynamy od modelu zwyk³ego
end    
FIsr=FIdsr;
stdFI=stdFId; 
while(dalej)
    subplot(1,2,1);
    hold off; 
    if(~isempty(Yteor)) plot(xhs,Yh,'c.',xs,Yemp,'k*',xs,Yteor,'k:'); 
    else plot(xs,Yemp,'k*'); 
    end
    hold on; 
    % Budujemy macierz wejsc w³¹czonych Fi. Sa to wejœcia orygin. lub
    % ortogon
    clear Fi G Am Yob E KA Ye sigYm sigYe; 
    nrAist=find(istot>0); 
    %k=0; for(m=1:Kmax) if(istot(m)) k=k+1; Fi(:,k)=FI(:,m); end, end
    Fi=FI(:,nrAist); 
    Km=length(nrAist); % tyle mamy faktycznie w³¹czonych cz³onów
    % Liczymy regresjê dla Fi
    % Najpierw liczymy RCN macierzy oryginalnej, a potem RNCs dla standaryzowanej  
    FixFi=Fi'*Fi; s=svd(FixFi); RCN=s(end)/s(1); 
    Fis=FIs(:,nrAist); 
    s=svd(Fis'*Fis); RCNs=s(end)/s(1); 
    if(modOrtog==0)
        NrAforyg=nrAist; % selekcja wejœæ oryginalnych, a wiec istotne Am i FI sa istotnymi Af (FI=FId)  
        Kmfo=Km;
        jestAf=istot; 
        % Baza ortogonalizowana: macierz ortogonaliz. P [P,s,v]=svd(Fis(:,2:Km)
        if(1)
            [Po,s,v]=svd(Fis(:,2:Km)'*Fis(:,2:Km));
            RCNo=s(Km-1,Km-1)/s(1,1);
            P=[[1 zeros(1,Km-1)];[zeros(Km-1,1)] Po];
        else
            [P,s,v]=svd(Fis'*Fis);
            RCNo=s(Km,Km)/s(1,1);
        end
        Fio=Fis*P; % ortogonalizacja
        % ==== Model ortogonalny ======================================
        Kmo=Km;
        gF=(Fio'*Fio);
        Go=gF\eye(Km); go=inv(Fio'*Fio);
        Ao=Go*Fio'*Yemp; % wspolczyn. modelu ortogonalizowanego
        Yo=Fio*Ao; % wartoœci funkcji regr. dla Fio
        % Liczymy macierz kowar.A
        Eo=Yemp-Yo; varZo=(Eo'*Eo)/(Ld-Km); % estymata war.Z
        KAo=Go*varZo;
        % ............ Przeliczenie na wspolcz. modelu zwyk³ego .....
        Aos=P*Ao; % bo Yo=Fio*Ao== Fis*P*Ao =Fis*Aso -> Aos=P*Ao
        % Teraz zwyk³a regresja ================================
        G=inv(Fi'*Fi);
        Am=G*Fi'*Yemp; % wspolczyn. modelu
        Yob=Fi*Am; % wartoœci funkcji regr. dla x
        % Liczymy macierz kowar.A
        E=Yemp-Yob; varZ=(E'*E)/(Ld-Km); % estymata war.Z
        KA=G*varZ;
    end
    % === Model standaryzowany (zwykly lub ortogonalny) ===================
    Gs=inv(Fis'*Fis); 
    As=Gs*Fis'*Yemp; % wspolczyn. modelu ortogonalizowanego
    Yms=Fis*As; % wartoœci funkcji regr. dla x
    % Liczymy macierz kowar.A
    Es=Yemp-Yms; varZs=(Es'*Es)/(Ld-Km); % estymata war.Z
    KAs=Gs*varZs; % Model standaryzowany bêdzie wykorzystany do selekcji wejœæ
    clear Amo;
    if(modOrtog) % model z baz¹ ortogonaln¹
        jestAf=zeros(1,Kmax); jestAf(NrAforyg)=1; 
        RCNs=(Fis(:,Km)'*Fis(:,Km))/(Fis(:,2)'*Fis(:,2)); % od 2, bo PsOrt zaczyna siê od 2.giej zmiennej 
        Kmfo=length(NrAforyg); 
        % ...... Przeliczenie wsp.ortogon.As=Ao na wspolcz.Ams modelu zwyk³ego .....
        Ao=As; KAo=KAs; Go=Gs; Eo=Es; varZo=varZs; % Przemianowanie wyniku z s na o
        Pms=Psf(NrAforyg,NrAforyg(nrAist));
        As=Pms*Ao; % bo Ymo=Fio*Ao== Fis*P*Ao =Fis*Aso -> Aos=P*Ao
        KAs=Pms*KAo*Pms'; Aos=As;
        varAms=zeros(Kmfo,1);
        for(i=1:Km) varAms=varAms+Pms(:,i).^2*KAo(i,i); end
        %max(max(abs(KAs./(diag(varAms)-1)))),
    else
        % ............ Ostateczny model zwyk³y z ortogon./alternatwn.standaryzowanego ......
        % Aos wspolcz. modelu ortog./alternat. przeliczone na wspolcz. modelu zwyk³ego .....
        for(k=2:Km) Amo(k,1)=Aos(k,1)/stdFI(nrAist(k)); end, %stdFI(NrAforyg(nrAist(k))); end, % stdFI(nrAist(k)); end 
        Amo(1,1)=Aos(1,1)-FIsr(nrAist(2:Km))*Amo(2:Km,1); %NrAforyg(nrAist(2:Km)))*Amo(2:Km,1); % FIsr(nrAist(2:Km))*Amo(2:Km,1);
        Ymo=Fi*Amo; 
        Emo=Yemp-Ymo; 
    end
    % ............ Przeliczenie standaryzow.(ortog.lub zwyk³) na model zwyk³y Ams ........
    % Yms=As1+Fis(:,2:Km)*As(2:Km) = As1+(Fi(:,2:Km)-Fisr)/sigFi*As(2:Km); ;
    clear Ams;
    for(k=2:Kmfo) Ams(k,1)=As(k,1)/stdFI(NrAforyg(k)); end
    %for(k=2:Km) Ams(k,1)=As(k,1)/stdFI(NrAforyg(nrAist(k))); end
    %Ams(1,1)=As(1,1)-FIsr(NrAforyg(nrAist(2:Km)))*Ams(2:Kmfo,1);
    Ams(1,1)=As(1,1)-FIsr(NrAforyg(2:Kmfo))*Ams(2:Kmfo,1);
    Ymo=FId(:,NrAforyg)*Ams; 
    Ems=Yemp-Ymo; 
    if(modOrtog) 
        Am=Ams; Yob=Ymo; 
        Amo=Ams; Emo=Ems; % Podstawiamy zbêdne (tu) wspó³cz. mod.zwyk³ego z ortogonaln.alternat.  
    end
    varZm=(Ems'*Ems)/(Ld-Km); 
    % --------------------------------
    clear KAm Fisr stdFik_1 stdFi_1 KAss;
    % Przeliczamy macierz KAs na KAm (dla zmiennych oryginalnych),
    %    na podstawie równoœci wariancji b³êdów:
    %    Fi*KAm*Fi' == Fis*KAs*Fis'; gdzie Fis=(Fi-Fisr)/stdFi
    % Zatem:
    % Fi*KAm*Fi' == (Fi/stdFi)*KAs*(Fi/stdFi)'
    %               -2*(Fi/stdFi)*KAs*(Fisr/stdFi)
    %               +(Fisr/stdFi)*KAs*(Fisr/stdFi)
    % Oznaczamy:
    stdFi_1=diag([1 1./[stdFI(NrAforyg(2:Kmfo))]]); % odwrotn odch.stand Fi (1/stdFi)
    %stdFi_1=diag([1 1./[stdFI(NrAforyg(nrAist(2:Km))]]); % odwrotn odch.stand Fi (1/stdFi)
    %Fisr=FIsr(NrAforyg(nrAist));
    Fisr=FIsr(NrAforyg);
    stdFik_1=stdFi_1(2:Kmfo,2:Kmfo); 
    KAss=KAs(2:Kmfo,2:Kmfo);
    % To oznacza, ¿e macierz KAm oblicza siê ze wzorów:
    KAm(1,1)=Fisr*stdFi_1*KAs*(stdFi_1*Fisr');
    KAm(2:Kmfo,1)=-stdFik_1*KAss*(stdFik_1*Fisr(2:Kmfo)');
    KAm(1,2:Kmfo)=KAm(2:Kmfo,1)';
    KAm(2:Kmfo,2:Kmfo)=stdFik_1*KAss*stdFik_1; %
    clear Fisr stdFik_1 stdFi_1 KAss;
    % ================================================
    % Efektem identyfikacji powinny byæ:
    % 1. Lista formu³ (wzorów Tx(istot).nf) do obliczania wejœæ
    %    uogólnionych Fi
    % 2. wektor wspó³czynników Ams dla wejœæ Fi=FI(:,istot)
    % 3. macierz kowariancji wspó³czynników KAm, obliczona jak wy¿ej
    % ....... UWAGA !!! ................
    % Identyfikacja na postawie wejœæ standaryzowanych FIs jest zalecana,
    % bo jest mniej wra¿liwa numerycznie ni¿ przy wykorzystaniu wejœæ orygin. FI
    % Powy¿sze przeliczenia (modelu standaryzowanego na zwyk³y) s¹
    % konieczne, aby klient nie musia³ korzystaæ z informacji o polu
    % korelacji i o danych standaryzuj¹cych FIsr oraz stdFI
    % =====================================================
    %end
    % --------- Liczymy satystyki Stodenta ----------
    tStkryt=tinv(0.95,Ld-Km)*2; tkrR=tinv(0.95,Ld-Km-1)*2;
    % inaczej: tStkryt=icdf('t',0.95,Ld-Km,0)*2; 
    mintSt=1.e40; Rgr=tkrR/sqrt(Ld-Km-1+tkrR^2);
    % typ modelu dla testu Studenta i korelacji
    if(modOrtog) txMod='ORTOGONALNY'; KA=KAm; 
    else txMod='ZWYKLY'; 
    end
    fprintf(1,'\nModel %s. Wspolczynniki i test Studenta - RCNs=%.5g tSkryt=%.2f Rgr=%.2f \n',...
                txMod,RCNs,tStkryt, Rgr);
    k=0; ko=0; mintSt=1.e20; Rmax=-10; kMaxR=0; 
    if(modOrtog)
        for(m=1:Kmax)
            if(isempty(Af)) txAf=sprintf(' ..Af= ????');
            else txAf=sprintf(' ..Af=%6.2f',Af(m));
            end
            if(jestAf(m)) %if(tStistot(m))    % Ao=%7.2f/%7.2f to=%5.2f Rfe(%2d)=**** .. Af(%2d)=%5.2f\n
                k=k+1;
                tStm(k)=abs(Ams(k))/sqrt(KAm(k,k)); 
                tSts(k)=abs(As(k))/sqrt(KAs(k,k)); 
                txAm=sprintf('Am(%2d)=%-8.2f t=%-7.2g%s As=%-8.2f ts=%-7.2g Rfe=****',...
                                m,Ams(k),tStm(k),txAf,As(k),tSts(k)); 
                if(modOrtog<0) % Selekcja dla modelu ortogon. wg wejœæ zwyk³ych (wg sSts())
                    tSt(k)=tSts(k); 
                    if(tSt(k)<mintSt && m>1) kminSt=m; mintSt=tSt(k); end                       
                end
            else %txAm=sprintf('Am(%.2d)=%7.2f t=***** As=%7.2f ts=*****',m,0.0,0.0); 
                if(1) %modOrtog<0)
                    if(1) %m<=Kmfo)
                        Rfe(m)=(FIds(:,m)'*Ems)/(Ld*sqrt(varZm));  Rfe(m)=abs(Rfe(m));
                        if(Rmax<Rfe(m)) Rmax=Rfe(m); kMaxR=m; end
                        txAm=sprintf('Am(%2d)=%-8.2f t= ******%s As=%-8.2f ts= ****** Rfe=%4.2f',m,0.0,txAf,0.0,Rfe(m)); 
                    else txAm=sprintf('Am(%2d)=%-8.2f t= ******%s As=%-8.2f ts= ****** Rfe=****',m,0.0,txAf,0.0); 
                    end
                end
            end
            if(istot(m)) 
                ko=ko+1;
                tSto(ko)=abs(Ao(ko))/sqrt(KAo(ko,ko)); 
                if(modOrtog>0) % Selekcja dla modelu ortogon. wg wejœæ ortogon.(wg sSto())
                    tSt(ko)=tSto(ko); 
                    if(tSt(ko)<mintSt && m>1) kminSt=m; mintSt=tSt(ko); end                       
                end
                txAm=sprintf('%s Ao(%2d)=%-8.2f to=%-7.2g Rfe(%2d)=****',...
                              txAm,ko,Ao(ko),tSto(ko),m); 
            else % nieistotne wejœcie ortogonalne
                %if(modOrtog>0)
                    if(m<=Kmfo)
                        Rfe(m)=(FIs(:,m)'*Eo)/(Ld*sqrt(varZo));  Rfe(m)=abs(Rfe(m));
                        if(Rmax<Rfe(m)) Rmax=Rfe(m); kMaxR=m; end
                        txAm=sprintf('%s Ao(%2d)=%-8.2f to= ****** Rfe(%2d)=%4.2f',...
                            txAm,ko,0.0,m,Rfe(m));
                    else
                        %txAm=sprintf('%s Ao=%7.2f to=***** Rfe(%2d)=****',...
                        %    txAm,0.0,m);
                    end
                %end
            end
            fprintf(1,'%s\n',txAm);
        end
    else % Selekcja dla modelu zwyk³ego (wg sSts())
        k=0; ko=0;
        for(m=1:Kmax)
            if(isempty(Af)) txAf=sprintf(' ..Af= ????');
            else txAf=sprintf(' ..Af=%6.2f',Af(m));
            end
            if(istot(m)) % istotnoœæ cz³onów modelu regres.
                k=k+1; ko=ko+1;
                tStm(k)=abs(Am(k))/sqrt(KA(k,k));
                tSts(k)=abs(As(k))/sqrt(KAs(k,k));
                tSto(k)=abs(Ao(k))/sqrt(KAo(k,k));
                tSt(k)=tSts(k);
                if(tSt(k)<mintSt && m>1) kminSt=m; mintSt=tSt(k); end
                fprintf(1,'A(%2d)=%6.2f%s t=%-7.2g Ams=%6.2f/%7.2f ts=%-7.2g Rfe(%2d)= *** Amo(%2d)=%6.2f/Ao(%2d)=%6.2f to=%-7.2g\n',...
                             m, Am(k),txAf,tStm(k),Ams(k),  As(k),tSt(k),       m,      m,Amo(k),   ko,Ao(ko),tSto(k));
            else
                Rfe(m)=(FIs(:,m)'*Es)/(Ld*sqrt(varZs));  Rfe(m)=abs(Rfe(m));
                if(Rmax<Rfe(m)) Rmax=Rfe(m); kMaxR=m; end
                fprintf(1,'A(%2d)=  0.00%s t= ****** Ams=  0.00/******* ts= ****** Rfe(%2d)=%4.2f\n',...
                             m,txAf,m,Rfe(m));
            end
        end
    end        
    % --------------- Koniec wydruku i obliczeñ tSt ---------------------
    LEsig=0;
    for(n=1:Ld)
        fd=FId(n,NrAforyg);  % wektor wejœæ uogóln dla danych xd(n)        
        if(modOrtog==0)
            % Liczymy wg modelu oryginalnego
            varY=fd*KA*fd';
            sigYe=sqrt(varY+varZ);
        end
        % Liczymy wg modelu przeliczonego na KAm wg KAs, tj. standaryzowanego   
        varYm=fd*KAm*fd';
        sigYem=sqrt(varYm+varZm);
        if(abs(Ems(n))<=sigYem) LEsig=LEsig+1; end
    end
    udzEsig=LEsig/Ld*100;
    % wizualizacja wyników.
    Ldw=5*Ld; dxw=(xhmax-xhmin)/(Ldw-1);
    xd=[xhmin:dxw:xhmax]';
    if(Lx>1) xd=[xd xd]; xds=mean(xd')'; else xds=xd; end
    Fd=model(xd);  % macierz wejœæ uogóln dla danych xds
    Fd=Fd(:,NrAforyg); 
    Yd=Fd*Am; Ydz=Yd+sqrt(varZ)*randn(Ldw,1);
    % Wizualiz. wyniku:
    subplot(1,2,2); 
    hold off; 
    if(~isempty(Yteor)) 
        nh1=find(xhs>x(Ld,1)); nh1=nh1(1); nh0=find(xhs<x(1,1)); nh0=nh0(end); 
        plot(xhs(nh0:nh1,1),Yh(nh0:nh1,1),'c.',xs,Yemp,'k*',xs,Yob,'r',xs,Ymo,'b',xs,Yteor,'k:'); 
    else plot(xs,Yemp,'k*',xs,Yob,'r',xs,Ymo,'b'); 
    end
    axis('tight');   
    subplot(1,2,1);
    hold on; plot(xs,Yob,'r',xs,Ymo,'b',xds,Yd,'b--',xds,Ydz,'r.'); hold off; axis('tight');
    % Liczymy odch. stand. modelu i wyjsc modelu % varYm(v)=fi(v)*KA*fi(v)'
    for(n=1:Ldw)
        fd=Fd(n,:); %,model(xds(n,1));  % wektor wejœæ uogóln dla danych xds(n)
        % Teraz liczymy wg modelu przeliczonego wg KAs, tj. standaryzowanego   
        varYm=fd*KAm*fd';
        sigYm(n,1)=sqrt(varYm); %varYm);
        sigYme(n,1)=sqrt(varYm+varZm);
        if(modOrtog) sigYe(n,1)=sigYme(n,1);
        else
            % Liczymy wg modelu oryginalnego
            varY=fd*KA*fd';
            sigY(n,1)=sqrt(varY);
            sigYe(n,1)=sqrt(varY+varZ);
        end
    end
    hold on; 
    plot(xds,Yd+sigYm,'r--',xds,Yd-sigYm,'r--',xds,Yd+sigYme,'m--',xds,Yd-sigYme,'m--'); 
    plot(xds,Yd+sigY,'k:',xds,Yd-sigY,'k:',xds,Yd+sigYe,'k:',xds,Yd-sigYe,'k:'); 
    hold off; axis('tight');
    
    subplot(1,2,2); nh1=find(xds>x(Ld,1)); nh1=nh1(1); nh0=find(xds<x(1,1)); nh0=nh0(end); 
    hold on; 
    plot(xds(nh0:nh1,1),Yd(nh0:nh1,1)+sigYm(nh0:nh1,1),'r--',...
        xds(nh0:nh1,1),Yd(nh0:nh1,1)-sigYm(nh0:nh1,1),'r--',...
        xds(nh0:nh1,1),Yd(nh0:nh1,1)+sigYme(nh0:nh1,1),'m--',...
        xds(nh0:nh1,1),Yd(nh0:nh1,1)-sigYme(nh0:nh1,1),'m--'); 
    plot(xds(nh0:nh1,1),Yd(nh0:nh1,1)+sigY(nh0:nh1,1),'k:',...
        xds(nh0:nh1,1),Yd(nh0:nh1,1)-sigY(nh0:nh1,1),'k:',...
        xds(nh0:nh1,1),Yd(nh0:nh1,1)+sigYe(nh0:nh1,1),'k:',...
        xds(nh0:nh1,1),Yd(nh0:nh1,1)-sigYe(nh0:nh1,1),'k:'); 
    hold off; axis('tight');       
    txt=sprintf('Y(x)=%.1f',Ams(1)); 
    m=1; for(k=2:Kmax) if(jestAf(k)) m=m+1; txt=[txt sprintf('%+5.2f*%s',Ams(m),Tx(k).nf)]; end, end
    txt=[txt sprintf('  udz_{Esig}=%.1f %%',udzEsig)];
    subplot(1,2,1); 
    hold on; ax=axis; plot(xds([nh0 nh0]), ax(3:4),'k--',xds([nh1 nh1]), ax(3:4),'k--'); hold off;  
    txsig='\sigma';
    if(isempty(Af)) txsigfZ=sprintf('%s_Z=????',txsig); else txsigfZ=sprintf('%s_Z=%.2f',txsig,sigfZ); end
    xlabel(sprintf('Ld=%d %s s_Z=%.2f/%.2f xd_{max}=%.2f>x_{max}=%.2f',...
                    Ld,txsigfZ,sqrt(varZs),sqrt(varZ),max(xds),xmax));
    subplot(1,2,2); title(txt); 
    %xlabel(sprintf('Ld=%d %s_Z=%.2f s_Z=%.2f/%.2f, udz_{Esig}=%.1f %%; x w polu korelacji: x_{max}=%.2f', ...
    %                Ld,txsig,sigfZ,sqrt(varZs),sqrt(varZ),udzEsig,xmax));
    xlabel(sprintf('Ld=%d %s s_Z=%.2f/%.2f; x w polu korelacji: x_{max}=%.2f', ...
                    Ld,txsigfZ,sqrt(varZs),sqrt(varZ),xmax)); 
    % Eliminacja z³ego uwarunkowania
    Dalej=0; % odblokowanie testów istotnoœci
    if(modOrtog==0 || modOrtog==1) wR=1; else wR=1.e10; end 
    while(wR*RCNs<RCNmax)
        % =======  Regularyzacja - ocena przydatnosci wejsc =======
        clear NrAforyg KaraR GF GR Gf Gr s Ar Amr Yr Ymr; 
        NrAforyg=NrAforygRCN; 
        nrARis=find(istot>0); Kd=length(nrARis); 
        jestAf=istot; 
        % ===== Zadajemy wspó³cz. kary dla cz³onów modelu
        KaraR=[0 ones(1,Kd-1)*1]; %e-1]; 
        % ..... Liczymy model regularyzowany .....................
        GF=FIs(:,nrARis)'*FIs(:,nrARis); 
        GR=GF+diag(KaraR); 
        % Obliczamy liczbe uwarunkowania macierzy orygin. i regularyzowanej
        s=svd(GF'*GF); RCNf=s(end)/s(1); s=svd(GR'*GR); RCNr=s(end)/s(1); 
        Gr=inv(GR);
        Ar=Gr*FIs(:,nrARis)'*Yemp;
        % ....... Przeliczenie wspolcz. na niestandaryzowane ....
        if(modOrtog)
            Pms=Psf(NrAforyg,nrARis);
            Arm=Pms*Ar; % bo Ymo=Fio*Ao== Fis*P*Ao =Fis*Aso -> Aos=P*Ao
        else Arm=Ar; 
        end
        KdAf=length(Arm); 
        Amr(1,1)=Arm(1,1);
        for(k=2:KdAf)
            Amr(k,1)=Arm(k,1)/stdFI(k);
            Amr(1,1)=Amr(1,1)-Amr(k,1)*FIsr(1,k);
        end
        % ........... Wydruk obliczonych wspolcz. ---------
        jestAf=zeros(1,Kmax); jestAf(NrAforyg)=1; 
        fprintf(1,'\n Model regularyzowany: RCNf=%g RCNr=%g',RCNf, RCNr); 
        k=0; km=0; 
        for(m=1:Kmax)
            if(isempty(Af)) txAf=' .... Af= ????'; else txAf=sprintf(' .... Af=%-8.3f',Af(m,1)); end
            if(istot(m))
                k=k+1; 
                txAr=sprintf('Asr(%2d)=%8.3f',m,Ar(k,1)); 
            else
                txAr=sprintf('Asr(%2d)=%8.3f',m,0.0);             
            end
            if(jestAf(m)) 
                km=km+1; txAm=sprintf(' Amr=%8.3f',Amr(km));            
            else txAm=sprintf(' Amr=%8.3f',0);
            end
            fprintf(1,'\n%s%s%s',txAr,txAm,txAf); 
        end
        Yr=FIs(:,nrARis)*Ar; 
        Ymr=FId(:,nrARis)*Amr; %NrAforyg)*Amr; 
        subplot(1,2,2); hold on;         
        plot(xs,Ymr,'b-.',xs,Yr,'r:'); axis('tight'); hold off; 
        input(sprintf('\nModel regularyzowany: KaraR(1)=%.3g  RCNf=%g RCNr=%g  <Ent> ',KaraR(2),RCNf, RCNr));
    % ........................................ 
        mRC=0; rcnMax=-1; RCNp=RCNs; 
        nAist=find(istot>0); LAfist=length(nAist); 
        if(modOrtog==0) NrAforyg=nAist; NrAforygRCN=NrAforyg; end
        for(i=2:LAfist)
            k=1; Fis=ones(Ld,1);             
            mAist=nAist(i); 
            istot(mAist)=0; 
            for(m=2:Kmax)
                if(istot(m)) k=k+1; Fis(:,k)=FIs(:,m);
                end
            end
            s=svd(Fis'*Fis); ls=length(s);
            rcn=s(ls)/s(1); 
            %fprintf(1,'%d/%d %g/%g=%g ',i,ls,s(ls,1),s(1,1),rcn);  
            if(rcn>rcnMax) mRC=mAist; rcnMax=rcn; end
            istot(mAist)=1;
        end
        if(mRC) 
            istot(mRC)=0; nrAist=find(istot>0); 
            if(modOrtog==0) NrAforygRCN=nrAist; NrAforyg=NrAforygRCN; end 
        else Dalej=0; break; 
        end
        Fis=FIs(:,nrAist); 
        s=svd(Fis'*Fis); RCNs=s(end)/s(1);
        fprintf(1,'ZLE UWARUNKOWANIE !!!  Usunieto czlon %d (%s): Byl RCNp=%g jest RCNs=%g \n',mRC,Tx(mRC).nf,RCNp,RCNs);
        input('  ?? Nacisnij <Ent> '); 
        Dalej=1; % Zablokowanie testów istotnoœci
    end
    if(Dalej) Dalej=0; continue; end,    
    % Procedura odrzucania
    if(dalej<0) 
        if(modOrtog) 
            txMOD=sprintf(' Teraz MODEL ORTOGONALNY !!!'); 
            if(modOrtog<0)
                co=input('<Ent> koniec selekcji zwyklej i  MODEL ORTOGONALNY !!! lub <inny> DALEJ sel.zwykla ??? ');
                if(isempty(co)) modOrtog=-Ortog; %break; end, % Na pocz¹tek wg modelu zwyklego
                else decRegr20; if(co<0) modOrtog=Ortog; end; continue;
                end
            else modOrtog=-Ortog; 
            end
         else
            input(' Teraz MODEL ORTOGONALNY !!! nacisnij <Ent> ');
            modOrtog=Ortog; % Teraz wg modelu ortogonalnego
            jestAf=ones(1,Kmax); % Zaczynamy od wszystkich wejœæ
            % Mozna obliczac model dokladny - trzeba podst. dokladny=1; ..................            
            if(dokladny) jestAf=find(Af~=0); end
        end
%        istot=zeros(1,Kmax); 
        % Mozna obliczac model dokladny - trzeba podst. dokladny=1; ..................
%        nrA0=find(jestAf>0);
        NrAforyg=find(jestAf); NrAforygRCN=NrAforyg;
        Kmfo=length(NrAforyg);
        clear Ps Psf Psx;
        %NrAforyg=[1:Kmax]; jestAf=ones(1,Kmax);
        istot=ones(1,Kmfo); istot(Kmfo+1:Kmax)=0; 
        Nr2Aforyg=NrAforyg(1,2:Kmfo);
        nrAist=[1:Kmfo];
        [Psx,s,v]=svd(FIds(:,Nr2Aforyg)'*FIds(:,Nr2Aforyg));
        Psf=zeros(Kmax,Kmax); Psf(1,1)=1;
        Psf(Nr2Aforyg,Nr2Aforyg)=Psx;
        RCNf=s(Kmfo-1,Kmfo-1)/s(1,1);
        Ps(2:Kmfo,2:Kmfo)=Psx; Ps(1,1)=1;
        FIs=FIds(:,NrAforyg)*Ps;
        [Pm,s,v]=svd(FId(:,NrAforyg)'*FId(:,NrAforyg));
        RCNmf=s(Kmfo,Kmfo)/s(1,1);
        %FI=FId(:,NrAforyg)*Pm;         
        dalej=1; testForyg=0;
        %input(' Teraz MODEL ORTOGONALNY !!! Nacisnij <Ent> '); %lub DALEJ dobor - wpisz <1>'); 
        continue; 
    end
    if(mintSt>tStkryt) dalej=-1; % wszystkie cz³ony wl¹czone sa istone
    else % eliminujemy cz³on kminSt
        powt=0;
        while(1)
            if(modOrtog<0)
                if(powt==0)
                    istot=jestAf; decRegr20; jestAf=istot; %jestAf(kminSt)=0;
                    if(co<0) continue; end
                end
                clear Ps Psf Psx FIs;
                NrAforyg=find(jestAf>0); Kmfo=length(NrAforyg);
                jestAf=zeros(1,Kmfo); 
                jestAf(NrAforyg)=1; 
                Nr2Aforyg=NrAforyg(1,2:Kmfo);
                [Psx,s,v]=svd(FIds(:,Nr2Aforyg)'*FIds(:,Nr2Aforyg));
                Psf=zeros(Kmax,Kmax); 
                Psf(1,:)=[1 zeros(1,Kmax-1)]; Psf(2:Kmax,1)=[zeros(Kmax-1,1)]; 
                Psf(Nr2Aforyg,Nr2Aforyg)=Psx;
                RCNf=s(Kmfo-1,Kmfo-1)/s(1,1);
                Ps(2:Kmfo,2:Kmfo)=Psx; 
                Ps(1,:)=[1 zeros(1,Kmfo-1)]; Ps(2:Kmfo,1)=[zeros(Kmfo-1,1)]; %Ps(1,1)=1;
                FIs=FIds(:,NrAforyg)*Ps;
                istot=ones(1,Kmfo); nrAist=[1:Kmfo]; istot(Kmfo+1:Kmax)=0;
                if(powt==0)
                    fprintf(1,'To byl TEST Studenta dla wejœc FAKTYCZNYCH; Usuniêto cz³on %d %s tSt(%d)=%.2f/tkryt=%.2f (RCN=%.4g)\n',kminSt,Tx(kminSt).nf,kminSt,mintSt,tStkryt,RCNs);
                end
                %if(testForyg)
                co=input(' <Ent> - dalej test wejœæ oryginalnych; <1> - Teraz MODEL ORTOGONALNY ');
                if(isempty(co)) testForyg=testForyg+1;
                else modOrtog=-modOrtog; testForyg=0;
                end
                break; 
                %end
            else
                if(modOrtog==0)
                    decRegr20; 
                    if(co<0) 
                        powt=1; modOrtog=-Ortog; 
                        co=input(sprintf('\nTeraz model ORTOGONALNY (dla wejsc istotn) - <Ent> lub dalej <1> ?? '));
                        if(isempty(co)) continue; kminSt=0; else break; end
                    end
                else istot(kminSt)=0;
                end
                nrAist=find(istot>0);
                input(sprintf('Test Studenta dla wejœæ %s; Usuniêto cz³on %d %s tSt(%d)=%.2f/tkryt=%.2f (RCN=%.4g)\n Wpisz <Ent> !!! ',txMod,kminSt,Tx(kminSt).nf,kminSt,mintSt,tStkryt,RCNs));
                break; 
            end
        end
    end
    %input('  ?? Nacisnij <Ent> '); 
end