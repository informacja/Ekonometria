function [ lN_out, stmpIdx_out, strBufC_out] = T_LEqArg(str, stmpIdx, strBufC)
%T_LEQARG Funkcja tlumaczy lewostronne przypisania Typu: A(i)=10; A(:,1)=..
%IN:
%str - dzialanie
%stmpIdx - liczba uzywanych i juz zainicjalizowanych zmiennych tymczasowych
%          domyslnie 0
%strBufC - lista z kolejnymi linijkami przetlumaczonego kodu w C
%OUT:
%lN_out - nazwa zmiennej ktora zwraca wartosc przetlumaczonej operacji Matlaba na C
%stmpIdx_out - numer tempa od ktorego mozna zaczac dalsze dodawanie po wyjsciu z funkcji
%strBufC_out - lista z przetlumaczonym kodem w C

global vname_list vname_change kod opt;
if(nargin<3) strBufC={}; end
if(nargin<2) stmpIdx=0; end
lN_out=''; stmpIdx_out=stmpIdx; strBufC_out=strBufC;
strOld=str; %stary zapis, potrzebny przy okresleniu rozmiaru pola struktury
lEl={};
tmpList={};%lista zmiennych tymczasowych: temp0, temp1, temp2..

lNm=[];%nazwa po lewej stronie znaku rownosci
for i=1:length(str)
    if str(i)=='='
        lNm=str(1:i-1); %zapisanie nazwy zmiennej wynikowej
        str=str(i+1:end);%usuniecie lewej strony nazwy zmiennej oraz znaku rownosci
        break;
    end
end

%% Zapisanie alokacji zmiennych typu ..(..)=..
%Sprawdzam czy w nazwie lNm jest indeksowana struktura: A(B).pole
[bd,idxd]=strIsIn('.',lNm); [bb,idxb]=strIsIn('(',lNm);
if(bd&&bb&&(idxd>idxb))
    %zmieniam indeks
    [lNm,stmpIdx,strBufC,tmpList]=idxCStruct(lNm,stmpIdx,strBufC);
    %Sprawdzam czy podana struktura jest juz w vname_change
    %jezeli tak, to znaczy ze musze ja dodac do vname_list lub
    %zaktualizowac
    [bd,el]=GetFromNL(lNm(1:idxb-1),vname_change);
    [bb,elb]=GetFromNL(lNm(1:idxb-1),vname_list);
    %w liscie vname_list jest juz podana struktura
    if(bd&&bb) AddToNL({el{1:4} elb{6:end}});
    %Nie mam podanej struktury w liscie vname_list
    elseif(bd) AddToNL({el{1:4}}); end;
    %sprawdzam czy w polu jest odwo³anie do macierzy
    [bb]=strIsIn('(',lNm(idxd+1:end));
%% PRZYPADEK st(A).pole=..
    %Szczegolny przypadek st(A).pole=.., przypisanie EqCC/MM
    if(~bb)
        %Wczytuje strukture, aby pobrac rozmiar jednego pola
%         load(kod);
        [pusty,idx]=strIsIn('=',strOld);
        %pobieram rozmiar
        [b,tel]=TakeValMat(kod,strOld(1:idx-1));
%         s=eval(['size(',strOld(1:idx-1),');']);
%         c=eval(['class(',strOld(1:idx-1),');']);
        s=size(tel); c=class(tel);
        %dodaje pole do listy zmiennych
        elA={lNm c s(1) s(2)};
        t=AddToNL(elA);
        if(~isempty(t)) strBufC={strBufC{1:end} t}; end
        %rozstrzygniecie EqMM czy EqCC
        elB={};
        if(strIsIn('(',str)||IsLike(str,['%s%l#[ ] + - * ^ / ',char(39),' \#%s'])) 
            [tN, pusty, tBufC]=T_Op(str, stmpIdx);
            %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
            if(isempty(tN)) return; end
            strBufC={strBufC{1:end} tBufC{1:end}};
            stmpIdx=stmpIdx+1;
            tmpList{end+1}=tN;
            [pusty,elB]=GetFromNL(tN,vname_list);
        else
            [b,elB]=GetFromNL(str,vname_list);
            if(~b) elB={str GetType(str) 1 1 1}; end
        end;
        %Jezeli mam proste przypisanie to EqCC, jezeli macierze to EqMM %Eq[CC/MM](W,A,srA,scA,tW,tA);
        if(s(1)>1||s(2)>1) t='EqMM('; else t='EqCC('; end;
        t=[ t lNm ',' elB{1} ',' num2str(s(1)) ',' num2str(s(2)) ',' c ',' elB{2} ');'];
        strBufC={strBufC{1:end} t};
        %sprawdzam czy mam tempy do zwolnienia
        if(~isempty(tmpList)) 
            tBuf=FreeTmp(tmpList); 
            if ~isempty(tBuf) strBufC={strBufC{1:end} tBuf{1:end}}; end
        end
        stmpIdx_out=stmpIdx;
        lN_out=lNm; 
        strBufC_out=strBufC;
        return;
    end
end

%% PRZYPADKI A(10)=.. P.A(3)=..
%sprawdzam czy podana zmienna jest na vname_list
%i czy ma dobrze okreslony rozmiar, jezeli jej nie ma to alokuje poraz
%pierwszy, inaczej realokuje i wyrzucam ostrzezenie
[bb,elb]=GetFromNL(lNm,vname_list);
if(~bb)
    %Musze zaalokowac A(10)=1; P.A(3)=10;
    [bd,el]=GetFromNL(lNm,vname_change);
    if(bd) 
        AddToNL({el{1:4}});
    %podane jest pole struktury, bo kazda inna zmienna jest widoczna
    %i jest ciezko dostac rozmiar pola
    elseif(strIsIn('.',lNm));
        %musze wczytac wszystkie zmienne z operacji ktore wykonal MyDebug
%         load(kod);
        %wykonuje polecenie, a pozniej sprawdzam jego rozmiar
        [pusty,idx]=strIsIn('=',strOld);
        %cofam sie do poczatku nazwy, zeby miec: A(10)=3; -> A, by pozniej
        %wywolac eval z funkcja size
        j=idx-2; cnaw=1;
        while(j>0&&cnaw) if(strOld(j)==')') cnaw=cnaw+1; elseif(strOld(j)=='(') cnaw=cnaw-1; end; j=j-1; end
        %pobieram rozmiar
        [b,tel]=TakeValMat(kod,strOld(1:j));
%         s=eval(['size(',strOld(1:j),');']);
%         c=eval(['class(',strOld(1:j),');']);
        s=size(tel); c=class(tel);
        [b,idxb2]=strIsIn('(',lNm(idxd+1:end));
        if(b) strBufC={strBufC{1:end} AddToNL({lNm(1:idxd+idxb2-1) c s(1) s(2)})};
        else strBufC={strBufC{1:end} AddToNL({strOld(1:j) c s(1) s(2)})}; end
    else
        return;
    end
%sprawdzam czy rozmiary roznia sie od tej w vname_change
else
    [bd,el]=GetFromNL(lNm,vname_change);
    %rozmiary sie roznia, realokacja
    if(bd&&((el{3}~=elb{3})||(el{4}~=elb{4})))
        strBufC={strBufC{1:end} ['MyRealloc(',lNm,',',num2str(el{3}),'*',num2str(el{4}),',',el{2},');']};
        warning('REALOKACJA: %s',lNm);
    %Podane jest np. pole struktury i nie ma go na vname_change oraz na
    %vname_list. PRZYPADEK REALOKACJI POL STRUKTUR
    elseif(strIsIn('.',lNm)); %Tego przypadku nie powinno byc, rozpatruje go ponizej
        %musze wczytac wszystkie zmienne z operacji ktore wykonal MyDebug
%         load(kod);
        %wykonuje polecenie, a pozniej sprawdzam jego rozmiar
        [~,idx]=strIsIn('=',strOld);
        %cofam sie do poczatku nazwy, zeby miec: A(10)=3; -> A, by pozniej
        %wywolac eval z funkcja size
        j=idx-2; cnaw=1;
        while(j>0&&cnaw) if(strOld(j)==')') cnaw=cnaw+1; elseif(strOld(j)=='(') cnaw=cnaw-1; end; j=j-1; end
        %pobieram rozmiar
%         s=eval(['size(',strOld(1:j),');']);
%         c=eval(['class(',strOld(1:j),');']);
        [b,tel]=TakeValMat(kod,strOld(1:j));
        s=size(tel); c=class(tel);
        if((s(1)>elb{3})||(s(2)>elb{4}))
            [b,idxb2]=strIsIn('(',lNm(idxd+1:end));
            if(b) tN=lNm(1:idxd+idxb2-1); else tN=strOld(1:j); end;
            AddToNL({tN c s(1) s(2)});
            strBufC={strBufC{1:end} ['MyRealloc(',tN,',',num2str(s(1)),'*',num2str(s(2)),',',c,');']};
            warning('REALOKACJA: %s',lNm);
        end
    end
end

%Zwyczajne wywo³anie funkcji    
%pobranie lewego elementu do zapisania
[a,b,strBufC]=T_TmpArg(lNm,stmpIdx,strBufC,true);
if(isempty(a)) 
    warning('Nie znaleziono elemetu do zapisania: %s',lNm);
    return
end
%zapisanie pobranych elemntow
[pusty,elNm]=GetFromNL(a{1}{1},vname_list); 
lEl={a{2:end}};
stmpIdx=b{1}; tmpList=b{2};  

%przetlumaczenie prawego fragmentu po znaku rownosci:
%Sprawdzam czy nie mam skladni A(1),A(:,2)...
if(strIsIn('(',str))
    i=2;
    while i<=length(str)
        if((i>1)&&(str(i)=='(')&&IsLetter(str(i-1)))
            %cofam sie do poczatku
            j=i-1;
            while((j>1)&&IsLetter(str(j))) j=j-1; end
            k=i+1; inden=1;
            while((inden>0)&&(k<=length(str))) 
                if(str(k)=='(') inden=inden+1; 
                elseif(str(k)==')') inden=inden-1;
                end
                k=k+1;
            end
            if k~=length(str) k=k-1; end
            %j-indeks poczatku nazwy z nawiasami 'ala(C(..))'
            %k-indeks ostatniego nawiasu pasujacego do ciagu wywolani 'ala(..)'
            tN=''; tBufC={};
            if(j==1) 
                [tN,tIdx,tBufC]=T_TmpArg(str(j:k),stmpIdx);
                str=[tN str(k+1:end)];
            else
                [tN,tIdx,tBufC]=T_TmpArg(str(j+1:k),stmpIdx);
                str=[str(1:j) tN str(k+1:end)];
            end
            %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
            if(isempty(tN)) 
                %Sprawdzam czy nie mam zmienych tymczasowych ktore byly alokowane w
                %vname_list
                if(~isempty(tmpList)) 
                    tBuf=FreeTmp(tmpList); 
                    if ~isempty(tBuf) strBufC={strBufC{1:end} tBuf{1:end}}; end
                end
                return;  
            end
            strBufC={strBufC{1:end} tBufC{1:end}};
            stmpIdx=stmpIdx+1;
            tmpList{end+1}=tN;
            i=j+length(tN);
            lEl{end+1}=tN;
        end
        i=i+1;
    end
end
%Sprawdzam czy nie mam obliczen
if(IsLike(str,['%s%l#[ ] + - * ^ / ',char(39),' \#%s'])) 
    [tN, pusty, tBufC]=T_Op(str, stmpIdx);
    %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
    if(isempty(tN)) 
        %Sprawdzam czy nie mam zmienych tymczasowych ktore byly alokowane w
        %vname_list
        if(~isempty(tmpList)) 
            tBuf=FreeTmp(tmpList); 
            if ~isempty(tBuf) strBufC={strBufC{1:end} tBuf{1:end}}; end
        end
        return; 
    end
    strBufC={strBufC{1:end} tBufC{1:end}};
    stmpIdx=stmpIdx+1;
    tmpList{end+1}=tN;
    lEl{end+1}=tN;
end

%Tlumaczenie przypadku:
%Indeksy juz mam obliczone oraz wszystko sie zgadza.
lDefNam='LEq';
if(length(lEl)<3) lEl={lEl{1} lEl{2} str}; 
%jak mam za duzo indeksow(czasami tak wychodzi ze T_TmpArg zwraca tempa a
%pozniej ten temp jest przetwazany przez T_Op i mam 4 elementy, interesuje
%mnie ten ostatni
elseif(length(lEl)>3) lEl={lEl{1} lEl{2} lEl{end}}; end
%sprawdzam jakie mam parametry
for i=1:length(lEl)
    [b, elA]=GetFromNL(lEl{i},vname_list);
    if((~b)&&IsNumber(lEl{i})) 
        elA={lEl{i} GetType(lEl{i}) 1 1 1};
    elseif(~strcmp(elA{1},lEl{i})) elA{1}=lEl{i}; end%Sprawdzam czy nie podana jest transpozycja 
    if(elA{5}==0) lDefNam=[lDefNam 'M'];
    else%Podany jest parametr Staly, sprawdzam czy nie jest to temp
        lDefNam=[lDefNam 'C']; 
        if(IsTmpN(elA{1})) elA{1}=['GetPtr(',elA{1},',',elA{2},')']; end
    end
    %przypisuje elementy do listy elementow
    lEl{i}=elA;
end
%Tworze linijke z wywolaniem makra
%LEq(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)
strBufC{end+1}=[lDefNam,'(',elNm{1},',',lEl{1}{1},',',lEl{2}{1},',',lEl{end}{1},','...
                 num2str(elNm{3}),',',num2str(elNm{4}),',',...
                 num2str(lEl{1}{3}),',',num2str(lEl{1}{4}),',',...
                 num2str(lEl{2}{3}),',',num2str(lEl{2}{4}),',',...
                 elNm{2},',',lEl{1}{2},',',lEl{2}{2},',',lEl{3}{2},');'];

%sprawdzam czy mam tempy do zwolnienia
if(~isempty(tmpList)) 
    tBuf=FreeTmp(tmpList); 
    if ~isempty(tBuf) strBufC={strBufC{1:end} tBuf{1:end}}; end
end
stmpIdx_out=stmpIdx;
lN_out=lNm; 
strBufC_out=strBufC;
end