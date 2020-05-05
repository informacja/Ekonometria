function [ lN_out,stmpIdx,strBufC ] = T_Init( line,stmpIdx,strBufC,delTmp )%tu1
%T_Init deklaracja oraz inicjalizacja zmiennych tablic,wektrów
%IN:
%line ->dzialanie
%stmpIdx ->liczba uzywanych i juz zainicjalizowanych zmiennych tymczasowych
%          domyslnie 0
%strBufC ->lista z kolejnymi linijkami przetlumaczonego kodu w C
%delTemp ->zmienna okreslajaca zwalniac zaalokowana pamiec zminnych
%          tymczasowych temp, domyslnie zwalniam
%
%OUT:
%stmpIdx_out -> indeks od ktorego mozna zaczac dalsza indeksacje poza
%              funkcja, zazwyczaj 0 lub 1 przy pojedynczym wywolaniu
%              funkcji
%lN_out->
lN_out='';
if(nargin<2) stmpIdx=0; end;%jeœli nie podano tej wartoœci tu1
if(nargin<3) strBufC={}; end;
if(nargin<4) delTmp=1; end;
global kod
tmplist={};
%out=cell(1);
%out{1}=stmpIdx_out
%out{2}=lN_out->outline
%out{3}=bufor;
%tablice (Mallokiem)
Fd=zeros(5);
Lline=length(line);
dzialo='';
namezm='';
f3=0;f4=0;
f5=0;
liczba='';
%---------------------------------------------------------------------------------------
if(~isempty(strBufC))%czyszczenie bufora
    mstrBufC=[strBufC];
else
    mstrBufC={}; 
end
Lline=length(line);

if(IsLike(line,'[%s]')||IsLike(line,'%s=[%s]%s')||IsLike(line,'%s=[%s]'))
   f3=1; 
else
    f3=0;
end
if((IsLike(line,'(%s:%s)')) ||(IsLike(line,'%s=(%s:%s)%s'))||(IsLike(line,'%s=(%s:%s)')))
    f4=1;
else
    f4=0;
end
if(f3==0&&f4==0)
    f5=1;
end
Fd=[0,0,0,0,0,0];
tf1=0;tf2=0;tf3=0;tf4=0;
dzialo='';
%------------------------------
while(IsLike(line,'%s%l# + - * / ^ #'))%mamy jeszcze dzia³anie idziemy do inz Kamila
    %fin - plik do ktorego zapisuje
    %str - dzialanie
    %stmpIdx - liczba uzywanych i juz zainicjalizowanych zmiennych tymczasowych
    %          domyslnie 0
    %
    %OUT:
    %stmpIdx - to samo co na wejsciu tylko zwiekszone o aktualna liste
    %[out{1}, out{2}, out{3}]=T_Op(fin, line, stmpIdx, strBufC);
    %wracamy i nie wiem co tak konkretnie musze podawaæ tylko to równianie 
    %??????
    %line=out{2};
    for(i=1:Lline)
        %tworzymy tab z flagami
        if(line(i)=='+')
            tf1=1;
            Fd(1)=i;
            break
        elseif(line(i)=='-')
            Fd(2)=i;
            tf2=1;
            break
        elseif(line(i)=='*')
            Fd(3)=i;
            tf3=1;
            break
        elseif(line(i)=='/')
            Fd(4)=i;
            tf4=1;
            break
        elseif(line(i)=='^')
            Fd(5)=i;
            tf4=1;
            break    
        end
    end
    if(tf1||tf2||tf3||tf4)
        koniec=max(Fd);
        %szukamy pocz¹tek
        Bline=koniec;
        for(i=koniec-1:-1:1)
            if(line(i)=='[')
                break;
            elseif(line(i)==':'&&f4)
                break;
            elseif(line(i)==' ')
                break;
            elseif(line(i)==',')
                break;
            elseif(line(i)==';')
                break;
            elseif(line(i)=='=')
                break;
            elseif(line(i)=='('&&f4)
                break;
            else
                dzialo=[line(i) dzialo];
                Bline=Bline-1;
            end
        end
        %koniec
        Kline=koniec;
        for(i=koniec:Lline)
            if(line(i)==']'||line(i)==')')
                break;
            elseif(line(i)==':')
                break;
            elseif(line(i)==' ')
                break;
            elseif(line(i)==',')
                break;
            elseif(line(i)==';')
                break;
            else
                dzialo=[dzialo line(i)];
                Kline=Kline+1;
            end
        end
    end
    %[a,b,strBufC]=T_Op('a=b(1)',2,strBufC)
    [out{1}, out{2},strBufC]=T_Op(dzialo, stmpIdx, strBufC);%!odkomenuj
    
    %replace='temp';
    replace=out{1};
    stmpIdx=out{2};
    line=strrep(line,dzialo,replace);%Replace text in a cell array with values in a second cell array
    %zerowanie----------------------------------------------------
    Fd=zeros(5);
    Kline=0;
    Bline=0;
    tf1=0;tf2=0;tf3=0;tf4=0;
    koniec=0;
    dzialo='';
    %break;
end   
%-----------------------------------
%gdzy mam temp to sproawdzam 
%-----------------------------------
tname=''; namezm=''; liczba='';
myconst=0;alok=0;typ='';i=0; Lwier=1;
%-------------------------------------------------------------------------------------
St=1;
Lline=length(line);
for(k=1:Lline)
    if(line(k)=='='||line(k)=='[')
        St=0;
    end
    if(St==0)
        break
    end
    if(line(k)=='('||line(k)=='.')
        St=1;
    end
   namezm=[namezm line(k)];
end
if(St==1)
    namezm='';
    k=1;
end
%szukanie na liscie zmiennych ktï¿½ra jest pusta nieï¿½le !!!!!!!
namezm=strDelChar(namezm,' ');
%rozpoznawanie typu deklaracji danej zmiennej
myconst=false;
%-----------------------------------------------------------------
%gdyby jakimï¿½ cudem byï¿½o na liï¿½cie zmiennych 
yestemp=0;
if(isempty(namezm))
    yestemp=1;
    k=1;
end
% for(j=1:Lname)
%     tname=vname_list{j}{1};
%     if(strcmp(tname,namezm))
%         typ=vname_list{j}{2};
%         %alok=vname_list{j}{6};
%         myconst=vname_list{j}{5};
%         break;
%     end
% end

%skoro jest to trzeba porï¿½wnaï¿½ wyniki

%--------------------------------------
if(f3)%tablice podowanï¿½ max 2 wymiarowï¿½ 
    fn=0;
    listadek=''; rozm=0;
    Lkol=1;Lwie=1; tabw=0; typq=0; poztyq=0; iq=0; pozli=0; pozsred=0; isred=0;
    for(i=k:Lline)
        if(line(i)==char(39))
            return;
        end
        if(line(i)=='=')
        elseif(line(i)=='[')
            fn=1;
        elseif(line(i)==':')
            typq=typq+1;
            liczba='';
        elseif(line(i)==')')
            liczba='';
        elseif(line(i)=='(')
            iq=iq+1;
            poztypq(iq)=i;
        elseif(line(i)==']')
            fn=0;
            if(~isempty(liczba))
            listadek=[listadek ',' liczba];
            end
            rozm=rozm+1;
        elseif(fn)
            if(line(i)==','||line(i)==' ')
                if(line(i)==','&&line(i+1)==' ')
                    continue;
                end
                if(line(i+1)==','&&line(i)==' ')
                    continue;
                end
                if(line(i-1)==';'||line(i+1)==';')
                    continue;
                end
                if(~isempty(liczba))
                listadek=[listadek ',' liczba];
                end
                liczba='';
                rozm=rozm+1;
                Lwier=Lwier+1;
                pozli=i;
            elseif(line(i)==';')
                if(~isempty(liczba))
                listadek=[listadek ',' liczba];
                end
                liczba='';
                Lwie=Lwie+1;%liczba wierszy
                if(typq==0)
                Lkol=rozm+1;
                end
                rozm=0;
                tabw=1;
                if(typq>0)
                    listadek=[listadek ';'];
                    isred=isred+1;
                    pozsred(isred)=i;
                end
            else
                    liczba=[liczba line(i)];
            end
        end
    end
    if(typq>0)%poï¿½ï¿½czenie [] i (:)
        iqw=1;
        while(iq>=iqw);
            start=''; krok='';koniec='';
            for(q=poztypq(iqw):Lline)
                if(line(q)=='(')
                    fstart=1;
                elseif(line(q)==':')
                    fstart=fstart-1;
                elseif(line(q)==')')
                    break
                end
            %if(typq==2)
                if(fstart==1)
                    start=[start line(q)];
                elseif(fstart==0)
                    krok=[krok line(q)];
                elseif(fstart==-1)
                    koniec=[koniec line(q)];
                end
%             else
%                 if(fstart==1)
%                     start=[start line(q)];
%                 elseif(fstart==0)
%                     koniec=[koniec line(q)];
%                 end
%             end
            end

        if(~isempty(koniec))%usuwanie zbï¿½dnych znakï¿½w
            koniec(1)='';
        numko=str2num(koniec);
        else
            krok(1)='';
            numko=str2num(krok);
            krok='1';
        end    
        if(iqw==1&&listadek(1)==';')
            Lkol=numko;
        end
        if(~isempty(krok))
            if(length(krok)>1)
                krok(1)='';
            end
            numkr=str2num(krok);
        end
        if(~isempty(start))
            start(1)='';
            numst=str2num(start);
        end
        listaq='';
        for(q=numst:numkr:numko)
                tq=num2str(q);
                listaq=[listaq ',' tq];
                rozm=rozm+1;
        end
        brea=0;
        for(i=1:length(listadek))
            if(listadek(i)==';')
                brea=1;
                break;
            end
        end
        if(brea==0)
            i=i+1;
        end
        if((i+1)<length(listadek)&&iq<(iqw+1))
            if(listadek(i+1)==';')
                listadek(i+1)='';
            end
        end
        listadek=strWriteInplus(listadek,i,listaq);
        listaq='';
            if(listadek(1)==',')
                listadek(1)='';
            end
        iqw=iqw+1;
        end
    end
    if(listadek(1)==',')
        listadek(1)='';
    end
    %okreï¿½lanie typ----------------------------------------------------
    dotyp='';
    preftyp{1}={'long int'};
    preftyp{2}={'double'};
    preftyp{3}={'char'};
    Lwier=rozm;
    x=1;%index typu
    for(q=1:length(listadek))
        if(listadek(q)==',')
            if(~IsLike(dotyp,'%l#1 2 3 4 5 6 7 8 9 0#'))
                [yes malokzm]=GetFromNL(dotyp);
                lasttyp=malokzm{2};
                if(malokzm{4}>1)
                Lwier=malokzm{4}+Lwier;
                end
                if(malokzm{3}>1)
                Lkol=malokzm{3}+Lkol;
                end
            else
                lasttyp=strGetType(dotyp);
            end
            dotyp='';
            for(z=1:3)%rodzaje typow
                zx=preftyp{z}{1};
                if(strcmp(zx,lasttyp))
                    tabpreftyp(x)=z;
                    x=x+1;
                end
            end
        else
            dotyp=[dotyp listadek(q)];
        end
    end
    if(~IsLike(dotyp,'%l#1 2 3 4 5 6 7 8 9 0#'))
        [yes malokzm]=GetFromNL(dotyp);
        lasttyp=malokzm{2};
        if(Lwie>rozm)
        Lwier=malokzm{4}+Lwier;
        else
            Lwier=malokzm{4}+Lwier;
        end
        if(malokzm{3}>1)
            Lkol=malokzm{4}+Lkol;
        end
    else
        lasttyp=strGetType(dotyp);
    end
    dotyp='';
    for(z=1:3)%rodzaje typï¿½w
        zx=preftyp{z}{1};
        if(strcmp(zx,lasttyp))
            tabpreftyp(x)=z;
            x=x+1;
        end
    end
    Ltyp=max(tabpreftyp);
    typ=preftyp{Ltyp}{1};
    %typ='double';
    %--------------------------------------
    if(myconst==1)%?????------------------------------------------------
        listadek=['{' listadek '}'];
        chrozm=num2str(rozm);
        outline=['const ' typ ' ' namezm '[' chrozm ']' '=' listadek ';'];
    else
        %a=malloc(sizeof(double)*3);
        %((double*)a)[0]=1;
        %((double*)a)[0]=2;
        %((double**)a)[0][0]=1; ((double**)a)[0][1]=2;
        %((double**)a)[1][0]=2; ((double**)a)[1][1]=1;
        if(tabw==1)
            chLkol=num2str(Lkol);
            chLwie=num2str(Lwie);
            if(yestemp==0)%------------------------------------
                Myzm=cell(1);
                Myzm{1}=namezm;
                Myzm{2}=typ;%??????????????????????
                Myzm{4}=Lwie;
                Myzm{3}=Lkol;
                Myzm{5}=0;
                malokzm=AddToNL(Myzm);
                if(isempty(malokzm))
                    %zmenna jest juz alokowana i nie zmienia sie i jest juZ
                else
                    %to dostajï¿½ alokacjï¿½ ktï¿½ra wposujï¿½ do bufora
                    mstrBufC{end+1}=malokzm;
                end
            else%tworzymy temp i dodajemy? go do listy zminnych----------------------
                namezm=['temp' num2str(stmpIdx)];
                stmpIdx=stmpIdx+1;
                Ctemp={namezm typ Lwie Lkol};
                malokzm=AddToNL(Ctemp);%dodanie zmiennj do listy
                if(isempty(malokzm))
%                     outline=[namezm '=' '(' typ '**)malloc(' chLwie '*sizeof(double*));'];
%                     %tab2=(double**)malloc(lwier*sizeof(double*));
%                     mstrBufC{end+1}=outline; outline='';
%                     outline=['for(sg_sup=0;sg_sup<' chLwie ';' 'sg_sup++){'];
%                     %for(i=0;i<lwier;i++){
%                     mstrBufC{end+1}=outline; outline='';
%                     outline=[namezm '[sg_sup]=(' typ '*)malloc(' chLkol '*sizeof(double));}'];
%                     %tab2[i]=malloc(lkol*sizeof(double));
%                     mstrBufC{end+1}=outline; 
%                     outline='';
                else
                    mstrBufC{end+1}=malokzm;
                end
            end
            outline='';
            Ctyp=[',' typ ','];%['((' typ '**)'];
            poz=1;
            liczba='';
            fex=0;
            i=1;
            chstaLwie=num2str(Lwie);
            while(i<=Lwie)%for(i=1:Lwie)
                chchLwie=num2str(i-1);
                j=1;
                while(j<=Lkol)%for(j=1:Lkol)
                    for(k=poz:length(listadek))
                        if(listadek(k)==',')
                            poz=k+1;
                            break;
                        else
                            liczba=[liczba listadek(k)];
                        end
                    end
                    if(fex==0)
                        exrozm=j-1;
                    else
                        %exrozm=exrozm+exLwie+1;
                        exrozm=rozm;
                    end
                    chchLkol=num2str(exrozm);
                     if(~IsLike(liczba,'%l#1 2 3 4 5 6 7 8 9 0#'))%wywoï¿½anie 
                        [xtyp, ex, exLkol]=GetFromNL(liczba);
                        chexLwie=num2str(ex{3});
                        i=ex{3}+i;
                        chexLkol=num2str(ex{4});
                        j=ex{4}+j;
                        extyp=ex{2};
                        %mstrBufC{end+1}=outline;
                        %fex=1;
                        %chchLkol=exrozm;
                        outline='';
                        chstartW=[chchLwie '*' chstaLwie '+' chchLkol ];
                        %mstrBufC{end+1}=['EqMMM(IncPtrA(' namezm ',' typ ',' chchLwie ',' chchLkol ')' ',' liczba ',' chexLwie ',' chexLkol ',' ex{2} ')'];
                        mstrBufC{end+1}=['InitStepM(' namezm ',' liczba ',' chstartW ',' chexLwie ',' chexLkol Ctyp extyp ');'];
                     else
                        %outline=[outline Ctyp namezm ')' '[' chchLwie '][' chchLkol ']=' liczba '; '];
                        if(rozm==1)
                            outline=[outline 'GetPtrA(' namezm Ctyp chchLwie ')=' liczba '; '];
                        else
                        outline=[outline 'GetPtrA(' namezm Ctyp chchLwie '*' chstaLwie '+' chchLkol ')=' liczba '; '];
                        end
                     end
                     liczba='';
                     j=j+1;
                end
                mstrBufC{end+1}=outline;
                outline='';
                i=i+1;
            end
            
        else
            chLwie=num2str(Lwie);
            if(yestemp==0)%------------------------------------
%                 Myzm=cell(1);
%                 Myzm{1}=namezm;
%                 Myzm{2}=typ;
%                 Myzm{3}=rozm;
%                 Myzm{4}=Lkol;
%                 malokzm=AddToNL(Myzm);
%                 if(isempty(malokzm))
%                     %zmenna jest juz alokowana i nie zmienia sie i jest juZ
%                 else
%                     %to dostajï¿½ alokacjï¿½ ktï¿½ra wposujï¿½ do bufora
%                     mstrBufC{end+1}=malokzm;
%                 end
            else%tworzymy temp i dodajemy? go do listy zminnych----------------------
                namezm=['temp' num2str(stmpIdx)];
                stmpIdx=stmpIdx+1;
            end
            chLol=num2str(Lkol);
            chLwie=num2str(rozm);
            %outline=[namezm '=' '(' typ '*)malloc(' chLwie '*sizeof(double*));'];%deklaracja
                Myzm=cell(1);
                Myzm{1}=namezm;
                Myzm{2}=typ;
                Myzm{4}=Lwier;%???
                Myzm{3}=Lkol;
                Myzm{5}=0;
                outline=AddToNL(Myzm);
                if(~isempty(outline))
            mstrBufC{end+1}=outline; outline='';
                end
            poz=1;
            Ctyp=[',' typ ',']; %['((' typ '*)'];
            liczba='';
            exrozm=-1;
            fex=0;
                for(j=1:rozm)
                    for(k=poz:length(listadek))
                        if(listadek(k)==',')
                            poz=k;
                            break;
                        else
                            liczba=[liczba listadek(k)];
                        end
                    end
                    if(fex==0)
                        exrozm=exrozm+1;
                    else
                        %exrozm=exrozm+exLwie+1;
                        exrozm=rozm;
                    end
                    chchLkol=num2str(exrozm);
                     if(~IsLike(liczba,'%l#1 2 3 4 5 6 7 8 9 0#'))%wywoï¿½anie 
                        [xtyp, ex, exLkol]=GetFromNL(liczba);
                        chexLwie=num2str(ex{3});
                        exrozm=exrozm+ex{4}-1;
                        chexLkol=num2str(ex{4});
                        mstrBufC{end+1}=outline;
                        outline='';
                        %mstrBufC{end+1}=['EqMMM(IncPtrA(' namezm ',' typ ',' chchLkol ')' ',' liczba ',' chexLwie ',' chexLkol ',' ex{2} ')'];
                        mstrBufC{end+1}=['InitStepM(' namezm ',' liczba ',' chchLkol ',' chexLwie ',' chexLkol Ctyp ex{2} ');'];
                     else
                        %outline=[outline Ctyp namezm ')' '[' chchLkol ']=' liczba '; '];
                        outline=[outline 'GetPrtA(' namezm Ctyp chchLkol ')=' liczba '; '];
                     end
                    liczba='';
                    poz=k+1;
                end
                if(~isempty(outline))
                    mstrBufC{end+1}=outline;
                end
                outline='';
        end
    end
end
if(f4)
    %tab2=(double*)malloc(lwier*sizeof(double*));
    %j=1;
    %for(i=0;i<lwier;i++){
    %        tab2[i]=j;
    %        j=j+(-1);
    %}
    wyst=0;
    j=1;
    for(i=k:Lline)
        if(line(i)==':')
            pocz(j)=i;
            j=j+1;
        elseif(line(i)==')')
        end
    end
    %parametry
   start='';krok='';koniec='';fstart=8;
    for(i=k:Lline)
        if(line(i)=='(')
            fstart=1;
        elseif(line(i)==':')
            fstart=fstart-1;
        elseif(line(i)==')')
            break
        end
        if(j==3)
            if(fstart==1)
                start=[start line(i)];
            elseif(fstart==0)
                krok=[krok line(i)];
            elseif(fstart==-1)
                koniec=[koniec line(i)];
            end
        else
            if(fstart==1)
                start=[start line(i)];
            elseif(fstart==0)
                koniec=[koniec line(i)];
            end
            krok='1';
        end
    end
    if(~isempty(koniec))%usuwanie zbï¿½dnych znakï¿½w
        koniec(1)='';
        numko=str2num(koniec);
        if(isempty(numko))
            numko='';
        elseif(numko==0.0 +1.0i)
            numko='';
        end
    end
    if(~isempty(krok))
        if(length(krok)>1)
            krok(1)='';
        end
        numkr=str2num(krok);
        if(isempty(numkr))
            numkr='';
        elseif(numkr==0.0 +1.0i)
            numkr='';
        end
    end
    if(~isempty(start))
        start(1)='';
        numst=str2num(start);
        if(isempty(numst))
            numst='';
        elseif(numst==0.0 +1.0i)
            numst='';
        end
    end
    %co ja narobiï¿½em czy to wogule jest liczba 
    if(isempty(numko)||(isempty(numkr)))
        %koniec pï¿½tli nie jest liczbï¿½ i jest to odwoï¿½anie do zmiennej jak 
%         Ctemp={namezm 'long int' 1 1 0 0 0};
%         outline=[namezm '=' 'floor(' koniec '/' krok ');'];
        if(isempty(numkr))
            [yes el]=GetFromNL(krok);
            if(yes==0)
                mstrBufC{end+1}={'error nazwa krok nie istnieje'};
                lN_out='';
                stmpIdx_out=stmpIdx;
                strBufC=mstrBufC;
                return;
            end
            typ=el{2};
        end
        valuel=load(kod,koniec);
        val=['valuel.' koniec];
        numko=eval(val);
    end
    if(isempty(numst))
        valuel=load(kod,start);
        val=['valuel.' start];
        numst=eval(val);
        start=num2str(numst);
    end
    %obliczmay rozm pï¿½tli
    rozmwek=floor((numko/numkr)-(numst-1));
    %koniec 
    rozmwekstr=num2str(rozmwek);
    if(sign(rozmwek)==(-1))
            rozmwek=rozmwek*(-1);
    end
    typ=strGetType(krok);
%     typ='double';
    %end
    if(yestemp==0)%---------------------------------------------------
        Myzm=cell(1);
        Myzm{1}=namezm;
        Myzm{2}=typ;
        Myzm{3}=1;
        Myzm{4}=rozmwek;
        Myzm{5}=0;
        malokzm=AddToNL(Myzm);
        if(isempty(malokzm))
            %wszystko jest 
        else
            mstrBufC{end+1}=malokzm;
        end
    else%tworze wï¿½asnego TEMP
            namezm=['temp' num2str(stmpIdx)];
            stmpIdx=stmpIdx+1;
            Ctemp={namezm typ 1 rozmwek 0 0 0};
            malokzm=AddToNL(Ctemp);%dodanie zmiennj do listy
            mstrBufC{end+1}=malokzm;
    end
    %#define InitStep(W,Start,Step,End,typ?)\
    outline=['InitStep(' namezm ',' start ',' krok ',' rozmwekstr ',' typ ')'];
    mstrBufC{end+1}=outline;
    outline='';

end
if(f5&&f4==0&&f3==0)%zwykï¿½e przypisanie a=10;
    if(yestemp==0)%------------------------------------
        lst=0; lend=0; Lliczba=0;
        for(i=k:Lline)
            if(line(i)=='=')
                if(line(i+1)==char(39))
                    lst=1;
                end
            elseif(line(i)==';')
                if(line(i-1)==char(39))
                    lend=1;
                    liczba(1)='"';
                    liczba(end)='"';
                end
            else
                liczba=[liczba line(i)];
                Lliczba=Lliczba+1;
            end
        end
        %typ-----------------------------------------------------------
        dotyp='';
        preftyp{1}={'char'};
        preftyp{2}={'long int'};
        preftyp{3}={'double'};
        x=1;%index typï¿½w
        if(lst==0&&lend==0)
                if(~IsLike(liczba,'%l#1 2 3 4 5 6 7 8 9 0#'))
                    [yes,lost]=GetFromNL(liczba);
                    lasttyp=lost{2};
                    tmplist{end+1}=liczba;
                else
                    lasttyp=strGetType(liczba);
                end
        else
            lasttyp='char';
        end
                dotyp='';
                for(z=1:3)%rodzaje typï¿½w 
                    zx=preftyp{z}{1};
                    if(strcmp(zx,lasttyp))
                        Ltyp=z;
                    end
                end
        typ=preftyp{Ltyp}{1};
		%-----------------------------------------------------------------
        Myzm{1}=namezm;
        Myzm{2}=typ;
        Myzm{3}=1;
        if(lst==1&&lend==1)
            Myzm{4}=Lliczba-1;%-2
        else
            Myzm{4}=1;
        end
        Myzm{5}=0;
        malokzm=AddToNL(Myzm);
        if(isempty(malokzm))
                    %zmenna jest juz alokowana i nie zmienia sie i jest juZ
        else
                    %to dostajï¿½ alokacjï¿½ ktï¿½ra wposujï¿½ do bufora
                    if(lst==0&&lend==0)
                    mstrBufC{end+1}=malokzm;
                    end
        end
    else%tworzymy temp i dodajemy? go do listy zminnych----------------------
        namezm=['temp' num2str(stmpIdx)];
        stmpIdx=stmpIdx+1;
        Ctemp={namezm typ 1 1 0 0 0};
        malokzm=AddToNL(Ctemp);%dodanie zmiennj do listy
%         if(isempty(malokzm))
%             outline=[namezm '=' '(' typ '**)malloc(' '1' '*sizeof(double*));'];
%             %tab2=(double**)malloc(lwier*sizeof(double*));
%             mstrBufC{end+1}=outline; 
%             outline='';
%         else
%             mstrBufC{end+1}=malokzm;
%         end
        mstrBufC{end+1}=malokzm;
    end
    if(lst==1&&lend==1)
        if(Lliczba<=3)
            outline=[typ ' ' namezm '=' liczba ';'];
            mstrBufC{end+1}=outline;
        else
            outline=[typ ' ' namezm '[]={' liczba '};'];
            mstrBufC{end+1}=outline;
        end
    else
    mstrBufC{end+1}=[namezm '=' liczba ';'];%wykonanie dziaï¿½ania;
    end
end
    %outline=[namezm '=' '(' typ '*)malloc(' chLwie '*sizeof(double*));'];
%przypisanie wyniku koï¿½cowego---------------------------------------------
    if(~isempty(tmplist))
        frebuf=FreeTmp(tmplist);
        for(i=1:length(frebuf))
            if(isempty(frebuf))
                continue;
            end
             mstrBufC{end+1}=frebuf{i};
        end
    end
    lN_out=namezm;
    stmpIdx_out=stmpIdx;
    strBufC=mstrBufC;
end